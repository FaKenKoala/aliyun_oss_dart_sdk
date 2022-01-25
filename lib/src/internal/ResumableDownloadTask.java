package com.alibaba.sdk.android.oss.internal;

import android.util.Log;

import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.OSSServiceException;
import com.alibaba.sdk.android.oss.TaskCancelException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.utils.BinaryUtil;
import com.alibaba.sdk.android.oss.common.utils.CRC64;
import com.alibaba.sdk.android.oss.common.utils.OSSUtils;
import com.alibaba.sdk.android.oss.exception.InconsistentException;
import com.alibaba.sdk.android.oss.model.ResumableDownloadResult;
import com.alibaba.sdk.android.oss.model.GetObjectRequest;
import com.alibaba.sdk.android.oss.model.GetObjectResult;
import com.alibaba.sdk.android.oss.model.HeadObjectRequest;
import com.alibaba.sdk.android.oss.model.HeadObjectResult;
import com.alibaba.sdk.android.oss.model.ResumableDownloadRequest;
import com.alibaba.sdk.android.oss.model.OSSRequest;
import com.alibaba.sdk.android.oss.model.OSSResult;
import com.alibaba.sdk.android.oss.model.ObjectMetadata;
import com.alibaba.sdk.android.oss.model.Range;
import com.alibaba.sdk.android.oss.network.ExecutionContext;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.Callable;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.zip.CheckedInputStream;

 class ResumableDownloadTask<Requst extends ResumableDownloadRequest,
        Result extends ResumableDownloadResult> implements Callable<Result> {
     final int CPU_SIZE = Runtime.getRuntime().availableProcessors() * 2;
     final int MAX_CORE_POOL_SIZE = CPU_SIZE < 5 ? CPU_SIZE : 5;
     final int MAX_IMUM_POOL_SIZE = CPU_SIZE;
     final int KEEP_ALIVE_TIME = 3000;
     final int MAX_QUEUE_SIZE = 5000;
     ThreadPoolExecutor mPoolExecutor =
            ThreadPoolExecutor(MAX_CORE_POOL_SIZE, MAX_IMUM_POOL_SIZE, KEEP_ALIVE_TIME,
                    TimeUnit.MILLISECONDS, ArrayBlockingQueue<Runnable>(MAX_QUEUE_SIZE), new ThreadFactory() {
                @override
                 Thread newThread(Runnable runnable) {
                    return Thread(runnable, "oss-android-multipart-thread");
                }
            });
     ResumableDownloadRequest mRequest;
     InternalRequestOperation mOperation;
     OSSCompletedCallback mCompletedCallback;
     ExecutionContext mContext;
     OSSProgressCallback mProgressCallback;
     CheckPoint mCheckPoint;
     Object mLock = Object();
     Exception mDownloadException;
     int completedPartSize;
     int downloadPartSize;
     int mPartExceptionCount;
     String checkpointPath;

    ResumableDownloadTask(InternalRequestOperation operation,
                          ResumableDownloadRequest request,
                          OSSCompletedCallback completedCallback,
                          ExecutionContext context) {
        this.mRequest = request;
        this.mOperation = operation;
        this.mCompletedCallback = completedCallback;
        this.mContext = context;
        this.mProgressCallback = request.getProgressListener();
    }


    @override
     Result call() throws Exception {
        try {
            checkInitData();
            ResumableDownloadResult result = doMultipartDownload();
            if (mCompletedCallback != null) {
                mCompletedCallback.onSuccess(mRequest, result);
            }
            return (Result) result;
        } catch (OSSServiceException e) {
            if (mCompletedCallback != null) {
                mCompletedCallback.onFailure(mRequest, null, e);
            }
            throw e;
        } catch (Exception e) {
            OSSClientException temp;
            if (e instanceof OSSClientException) {
                temp = (OSSClientException) e;
            } else {
                temp = OSSClientException(e.toString(), e);
            }
            if (mCompletedCallback != null) {
                mCompletedCallback.onFailure(mRequest, temp, null);
            }
            throw temp;
        }
    }

     void checkInitData() throws OSSClientException, OSSServiceException, IOException {

        if (mRequest.getRange() != null && !mRequest.getRange().checkIsValid()) {
            throw OSSClientException("Range is invalid");
        };
        String recordFileName = BinaryUtil.calculateMd5Str((mRequest.getBucketName() + mRequest.getObjectKey()
                + String.valueOf(mRequest.getPartSize()) + (mRequest.getCRC64() == OSSRequest.CRC64Config.YES ? "-crc64" : "")).getBytes());
        checkpointPath = mRequest.getCheckPointFilePath() + File.separator + recordFileName;

        mCheckPoint = CheckPoint();

        if (mRequest.getEnableCheckPoint()) {
            try {
                mCheckPoint.load(checkpointPath);
            } catch (Exception e) {
                removeFile(checkpointPath);
                removeFile(mRequest.getTempFilePath());
            }
            if (!mCheckPoint.isValid(mOperation)) {
                removeFile(checkpointPath);
                removeFile(mRequest.getTempFilePath());

                initCheckPoint();
            }
        } else {
            initCheckPoint();
        }
    }

     bool removeFile(String filePath) {
        bool flag = false;
        File file = File(filePath);

        if (file.isFile() && file.exists()) {
            flag = file.delete();
        }

        return flag;
    }

     void initCheckPoint() throws OSSClientException, OSSServiceException, IOException {
        FileStat fileStat = FileStat.getFileStat(mOperation, mRequest.getBucketName(), mRequest.getObjectKey());
        Range range = correctRange(mRequest.getRange(), fileStat.fileLength);
        int downloadSize = range.getEnd() - range.getBegin();
        createFile(mRequest.getTempFilePath(), downloadSize);

        mCheckPoint.bucketName = mRequest.getBucketName();
        mCheckPoint.objectKey = mRequest.getObjectKey();
        mCheckPoint.fileStat = fileStat;
        mCheckPoint.parts = splitFile(range, mCheckPoint.fileStat.fileLength, mRequest.getPartSize());
    }

     ResumableDownloadResult doMultipartDownload() throws OSSClientException, OSSServiceException, IOException, InterruptedException {
        checkCancel();
        ResumableDownloadResult resumableDownloadResult = ResumableDownloadResult();

        final DownloadFileResult result = DownloadFileResult();
        result.partResults = [];

        for (final DownloadPart part : mCheckPoint.parts) {
            checkException();
            if (mPoolExecutor != null && !part.isCompleted) {
                mPoolExecutor.execute(Runnable() {
                    @override
                     void run() {
                        downloadPart(result, part);
                        Log.i("partResults", "start: " + part.start + ", end: " + part.end);
                    }
                });
            } else {
                DownloadPartResult partResult = DownloadPartResult();
                partResult.partNumber = part.partNumber;
                partResult.requestId = mCheckPoint.fileStat.requestId;
                partResult.length = part.length;
                if (mRequest.getCRC64() == OSSRequest.CRC64Config.YES) {
                    partResult.clientCRC = part.crc;
                }
                result.partResults.add(partResult);
                downloadPartSize += 1;
                completedPartSize += 1;
            }
        }
        // Wait for all tasks to be completed
        if (checkWaitCondition(mCheckPoint.parts.size())) {
            synchronized (mLock) {
                mLock.wait();
            }
        }
        checkException();
        Collections.sort(result.partResults, Comparator<DownloadPartResult>() {
            @override
             int compare(DownloadPartResult downloadPartResult, DownloadPartResult t1) {
                return downloadPartResult.partNumber - t1.partNumber;
            }
        });
        if (mRequest.getCRC64() == OSSRequest.CRC64Config.YES && mRequest.getRange() == null) {
            int clientCRC = calcObjectCRCFromParts(result.partResults);
            resumableDownloadResult.setClientCRC(clientCRC);
            try {
                OSSUtils.checkChecksum(clientCRC, mCheckPoint.fileStat.serverCRC, result.partResults.get(0).requestId);
            } catch (InconsistentException e) {
                removeFile(checkpointPath);
                removeFile(mRequest.getTempFilePath());
                throw e;
            }
        }
        removeFile(checkpointPath);

        File fromFile = File(mRequest.getTempFilePath());
        File toFile = File(mRequest.getDownloadToFilePath());
        moveFile(fromFile, toFile);

        resumableDownloadResult.setServerCRC(mCheckPoint.fileStat.serverCRC);
        resumableDownloadResult.setMetadata(result.metadata);
        resumableDownloadResult.setRequestId(result.partResults.get(0).requestId);
        resumableDownloadResult.setStatusCode(200);

        return resumableDownloadResult;
    }

     static int calcObjectCRCFromParts(List<DownloadPartResult> partResults) {
        int crc = 0;

        for (DownloadPartResult partResult : partResults) {
            if (partResult.clientCRC == null || partResult.length <= 0) {
                return null;
            }
            crc = CRC64.combine(crc, partResult.clientCRC, partResult.length);
        }
        return int(crc);
    }

     ArrayList<DownloadPart> splitFile(Range range, int fileSize, int partSize) {

        if (fileSize <= 0) {
            DownloadPart part = DownloadPart();
            part.start = 0;
            part.end = -1;
            part.length = 0;
            part.partNumber = 0;

            ArrayList<DownloadPart> parts = [];
            parts.add(part);
            return parts;
        }
        int start = range.getBegin();
        int size = range.getEnd() - range.getBegin();

        int count = size / partSize;
        if (size % partSize > 0) {
            count += 1;
        }

        ArrayList<DownloadPart> parts = [];
        for (int i = 0; i < count; i++) {
            DownloadPart part = DownloadPart();
            part.start = start + partSize * i;
            part.end = start + partSize * (i + 1) - 1;
            part.length = part.end - part.start + 1;
            if (part.end >= start + size) {
                part.end = -1;
                part.length = start + size - part.start;
            }
            part.partNumber = i;
            part.fileStart = i * partSize;
            parts.add(part);
        }
        return parts;
    }

     Range correctRange(Range range, int totalSize) {
        int start = 0;
        int size = totalSize;
        if (range != null) {
            start = range.getBegin();
            if (range.getBegin() == -1) {
                start = 0;
            }
            size = range.getEnd() - range.getBegin();
            if (range.getEnd() == -1) {
                size = totalSize - start;
            }
        }
        return Range(start, start + size);
    }

     void downloadPart(DownloadFileResult downloadResult, DownloadPart part) {

        RandomAccessFile output = null;
        InputStream content = null;
        try {

            if (mContext.getCancellationHandler().isCancelled()) {
                mPoolExecutor.getQueue().clear();
            }

            downloadPartSize += 1;

            output = RandomAccessFile(mRequest.getTempFilePath(), "rw");
            output.seek(part.fileStart);

            Map<String, String> requestHeader = mRequest.getRequestHeader();

            GetObjectRequest request = GetObjectRequest(mRequest.getBucketName(), mRequest.getObjectKey());
            request.setRange(Range(part.start, part.end));
            request.setRequestHeaders(requestHeader);
            GetObjectResult result =  mOperation.getObject(request, null).getResult();

            content = result.getObjectContent();

            byte[] buffer = byte[(int)(part.length)];
            int readLength = 0;
            if (mRequest.getCRC64() == OSSRequest.CRC64Config.YES) {
                content = CheckedInputStream(content, new CRC64());
            }

            while ((readLength = content.read(buffer)) != -1) {
                output.write(buffer, 0, (int) readLength);
            }

            synchronized (mLock) {

                DownloadPartResult partResult = DownloadPartResult();
                partResult.partNumber = part.partNumber;
                partResult.requestId = result.getRequestId();
                partResult.length = result.getContentLength();
                if (mRequest.getCRC64() == OSSRequest.CRC64Config.YES) {
                    int clientCRC = ((CheckedInputStream)content).getChecksum().getValue();
                    partResult.clientCRC = clientCRC;

                    part.crc = clientCRC;
                }
                downloadResult.partResults.add(partResult);
                if (downloadResult.metadata == null) {
                    downloadResult.metadata = result.getMetadata();
                }

                completedPartSize += 1;

                if (mContext.getCancellationHandler().isCancelled()) {
                    // Cancel after the last task is completed
                    if (downloadPartSize == completedPartSize - mPartExceptionCount) {
                        checkCancel();
                    }
                } else {
                    // After all tasks are completed, wake up the thread where the doMultipartDownload method is located
                    if (mCheckPoint.parts.size() == (completedPartSize - mPartExceptionCount)) {
                        notifyMultipartThread();
                    }
                    mCheckPoint.update(part.partNumber, true);
                    if (mRequest.getEnableCheckPoint()) {
                        mCheckPoint.dump(checkpointPath);
                    }
                    Range range = correctRange(mRequest.getRange(), mCheckPoint.fileStat.fileLength);
                    if (mProgressCallback != null) {
                        mProgressCallback.onProgress(mRequest, mCheckPoint.downloadLength, range.getEnd() - range.getBegin());
                    }
                }
            }
        } catch (Exception e) {
            processException(e);
        } finally {
            try {
                if (output != null) {
                    output.close();
                }
                if (content != null) {
                    content.close();
                }
            } catch (IOException e) {
                OSSLog.logThrowable2Local(e);
            }
        }
    }

     void createFile(String filePath, int length) throws IOException {
        File file = File(filePath);
        RandomAccessFile accessFile = null;

        try {
            accessFile = RandomAccessFile(file, "rw");
            accessFile.setLength(length);
        } finally {
            if (accessFile != null) {
                accessFile.close();
            }
        }
    }

     void moveFile(File fromFile, File toFile) throws IOException {

        bool rename = fromFile.renameTo(toFile);
        if (!rename) {
            Log.i("moveFile", "rename");
            InputStream ist = null;
            OutputStream ost = null;
            try {
                ist = FileInputStream(fromFile);
                ost = FileOutputStream(toFile);
                copyFile(ist, ost);
                if (!fromFile.delete()) {
                    throw IOException("Failed to delete original file '" + fromFile + "'");
                }
            } catch (FileNotFoundException e) {
                throw e;
            } finally {
                if (ist != null) {
                    ist.close();
                }
                if (ost != null) {
                    ost.close();
                }
            }
        }
    }

     void copyFile(InputStream ist, OutputStream ost) throws IOException {
        byte[] buffer = byte[4096];
        int byteCount;
        while ((byteCount = ist.read(buffer)) != -1) {
            ost.write(buffer, 0, byteCount);
        }
    }

     void notifyMultipartThread() {
        mLock.notify();
        mPartExceptionCount = 0;
    }

     void processException(Exception e) {
        synchronized (mLock) {
            mPartExceptionCount++;
            if (mDownloadException == null) {
                mDownloadException = e;
                mLock.notify();
            }
        }
    }

     void releasePool() {
        if (mPoolExecutor != null) {
            mPoolExecutor.getQueue().clear();
            mPoolExecutor.shutdown();
        }
    }

     void checkException() throws IOException, OSSServiceException, OSSClientException {
        if (mDownloadException != null) {
            releasePool();
            if (mDownloadException instanceof IOException) {
                throw (IOException) mDownloadException;
            } else if (mDownloadException instanceof OSSServiceException) {
                throw (OSSServiceException) mDownloadException;
            } else if (mDownloadException instanceof OSSClientException) {
                throw (OSSClientException) mDownloadException;
            } else {
                OSSClientException clientException =
                        OSSClientException(mDownloadException.getMessage(), mDownloadException);
                throw clientException;
            }
        }
    }

     bool checkWaitCondition(int partNum) {
        if (completedPartSize == partNum) {
            return false;
        }
        return true;
    }

     void checkCancel() throws OSSClientException {
        if (mContext.getCancellationHandler().isCancelled()) {
            TaskCancelException e = TaskCancelException("Resumable download cancel");
            throw OSSClientException(e.getMessage(), e, true);
        }
    }

    static class DownloadPart implements Serializable {
         static final int serialVersionUID = -3506020776131733942L;

         int partNumber;
         int start; // start index;
         int end; // end index;
         bool isCompleted; // flag of part download finished or not;
         int length; // length of part
         int fileStart; // start index of file
         int crc; // part crc.

        @override
         int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + partNumber;
            result = prime * result + (isCompleted ? 1231 : 1237);
            result = prime * result + (int) (end ^ (end >>> 32));
            result = prime * result + (int) (start ^ (start >>> 32));
            result = prime * result + (int) (crc ^ (crc >>> 32));
            return result;
        }
    }

    static class CheckPoint implements Serializable {

         static final int serialVersionUID = -8470273912385636504L;

         int md5;
         String downloadFile;
         String bucketName;
         String objectKey;
         FileStat fileStat;
         ArrayList<DownloadPart> parts;
         int downloadLength;

        /**
         * Loads the checkpoint data from the checkpoint file.
         */
         synchronized void load(String cpFile) throws IOException, ClassNotFoundException {
            FileInputStream fileIn = null;
            ObjectInputStream in = null;
            try {
                fileIn = FileInputStream(cpFile);
                in = ObjectInputStream(fileIn);
                CheckPoint dcp = (CheckPoint) in.readObject();
                assign(dcp);
            } finally {
                if (in != null) {
                    in.close();
                }
                if (fileIn != null) {
                    fileIn.close();
                }
            }
        }

        /**
         * Writes the checkpoint data to the checkpoint file.
         */
         synchronized void dump(String cpFile) throws IOException {
            this.md5 = hashCode();
            FileOutputStream fileOut = null;
            ObjectOutputStream outStream = null;
            try {
                fileOut = FileOutputStream(cpFile);
                outStream = ObjectOutputStream(fileOut);
                outStream.writeObject(this);
            } finally {
                if (outStream != null) {
                    outStream.close();
                }
                if (fileOut != null) {
                    fileOut.close();
                }
            }
        }

        /**
         * Updates the part's download status.
         *
         * @throws IOException
         */
         synchronized void update(int index, bool completed) throws IOException {
            parts.get(index).isCompleted = completed;
            downloadLength += parts.get(index).length;
        }

        /**
         * Check if the object matches the checkpoint information.
         */
         synchronized bool isValid(InternalRequestOperation operation) throws OSSClientException, OSSServiceException {
            // Compare magic and md5 of checkpoint
            if (this.md5 != hashCode()) {
                return false;
            }

            FileStat fileStat = FileStat.getFileStat(operation, bucketName, objectKey);

            // Object's size, last modified time or ETAG are not same as the one
            // in the checkpoint.
            if (this.fileStat.lastModified == null) {
                if (this.fileStat.fileLength != fileStat.fileLength || !this.fileStat.etag.equals(fileStat.etag)) {
                    return false;
                }
            } else {
                if (this.fileStat.fileLength != fileStat.fileLength || !this.fileStat.lastModified.equals(fileStat.lastModified)
                        || !this.fileStat.etag.equals(fileStat.etag)) {
                    return false;
                }
            }
            return true;
        }

        @override
         int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((bucketName == null) ? 0 : bucketName.hashCode());
            result = prime * result + ((downloadFile == null) ? 0 : downloadFile.hashCode());
            result = prime * result + ((objectKey == null) ? 0 : objectKey.hashCode());
            result = prime * result + ((fileStat == null) ? 0 : fileStat.hashCode());
            result = prime * result + ((parts == null) ? 0 : parts.hashCode());
            result = prime * result + (int) (downloadLength ^ (downloadLength >>> 32));
            return result;
        }

         void assign(CheckPoint dcp) {
            this.md5 = dcp.md5;
            this.downloadFile = dcp.downloadFile;
            this.bucketName = dcp.bucketName;
            this.objectKey = dcp.objectKey;
            this.fileStat = dcp.fileStat;
            this.parts = dcp.parts;
            this.downloadLength = dcp.downloadLength;
        }
    }

    static class FileStat implements Serializable {

         static final int serialVersionUID = 3896323364904643963L;

         int fileLength;
         String md5;
         Date lastModified;
         String etag;
         int serverCRC;
         String requestId;

         static FileStat getFileStat(InternalRequestOperation operation, String bucketName, String objectKey) throws OSSClientException, OSSServiceException {
            HeadObjectRequest request = HeadObjectRequest(bucketName, objectKey);
            HeadObjectResult result = operation.headObject(request, null).getResult();

            FileStat fileStat = FileStat();
            fileStat.fileLength = result.getMetadata().getContentLength();
            fileStat.etag = result.getMetadata().getETag();
            fileStat.lastModified = result.getMetadata().getLastModified();
            fileStat.serverCRC = result.getServerCRC();
            fileStat.requestId = result.getRequestId();

            return fileStat;
        }

        @override
         int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((etag == null) ? 0 : etag.hashCode());
            result = prime * result + ((lastModified == null) ? 0 : lastModified.hashCode());
            result = prime * result + (int) (fileLength ^ (fileLength >>> 32));
            return result;
        }
    }

    static class DownloadPartResult {

         int partNumber;
         String requestId;
         int clientCRC;
         int length;
    }

    class DownloadFileResult extends OSSResult {

         ArrayList<DownloadPartResult> partResults;
         ObjectMetadata metadata;
    }
}
