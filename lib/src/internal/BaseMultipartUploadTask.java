package com.alibaba.sdk.android.oss.internal;

import android.content.res.Resources;
import android.net.Uri;
import android.os.ParcelFileDescriptor;

import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.OSSServiceException;
import com.alibaba.sdk.android.oss.TaskCancelException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.common.OSSHeaders;
import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.utils.BinaryUtil;
import com.alibaba.sdk.android.oss.model.CompleteMultipartUploadRequest;
import com.alibaba.sdk.android.oss.model.CompleteMultipartUploadResult;
import com.alibaba.sdk.android.oss.model.MultipartUploadRequest;
import com.alibaba.sdk.android.oss.model.OSSRequest;
import com.alibaba.sdk.android.oss.model.ObjectMetadata;
import com.alibaba.sdk.android.oss.model.PartETag;
import com.alibaba.sdk.android.oss.model.UploadPartRequest;
import com.alibaba.sdk.android.oss.model.UploadPartResult;
import com.alibaba.sdk.android.oss.network.ExecutionContext;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.Callable;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * Created by jingdan on 2017/10/30.
 * multipart base task
 */

 abstract class BaseMultipartUploadTask<Request extends MultipartUploadRequest,
        Result extends CompleteMultipartUploadResult> implements Callable<Result> {

     final int CPU_SIZE = Runtime.getRuntime().availableProcessors() * 2;
     final int MAX_CORE_POOL_SIZE = CPU_SIZE < 5 ? CPU_SIZE : 5;
     final int MAX_IMUM_POOL_SIZE = CPU_SIZE;
     final int KEEP_ALIVE_TIME = 3000;
     final int MAX_QUEUE_SIZE = 5000;
     final int PART_SIZE_ALIGN_NUM = 4 * 1024;
     ThreadPoolExecutor mPoolExecutor =
            ThreadPoolExecutor(MAX_CORE_POOL_SIZE, MAX_IMUM_POOL_SIZE, KEEP_ALIVE_TIME,
                    TimeUnit.MILLISECONDS, ArrayBlockingQueue<Runnable>(MAX_QUEUE_SIZE), new ThreadFactory() {
                @override
                 Thread newThread(Runnable runnable) {
                    return Thread(runnable, "oss-android-multipart-thread");
                }
            });
     List<PartETag> mPartETags = [];
     Object mLock = Object();
     InternalRequestOperation mApiOperation;
     ExecutionContext mContext;
     Exception mUploadException;
     bool mIsCancel;
     File mUploadFile;
     String mUploadId;
     int mFileLength;
     int mPartExceptionCount;
     int mRunPartTaskCount;
     int mUploadedLength = 0;
     bool mCheckCRC64 = false;
     Request mRequest;
     OSSCompletedCallback<Request, Result> mCompletedCallback;
     OSSProgressCallback<Request> mProgressCallback;
     int[] mPartAttr = int[2];
     String mUploadFilePath;
     int mLastPartSize;//最后一个分片的大小
     Uri mUploadUri;

     BaseMultipartUploadTask(InternalRequestOperation operation, Request request,
                                   OSSCompletedCallback<Request, Result> completedCallback,
                                   ExecutionContext context) {
        mApiOperation = operation;
        mRequest = request;
        mProgressCallback = request.getProgressCallback();
        mCompletedCallback = completedCallback;
        mContext = context;
        mCheckCRC64 = (request.getCRC64() == OSSRequest.CRC64Config.YES);
    }

    /**
     * abort upload
     */
     abstract void abortThisUpload();

    /**
     * init multipart upload id
     *
     * @throws IOException
     * @throws OSSClientException
     * @throws OSSServiceException
     */
     abstract void initMultipartUploadId() throws IOException, OSSClientException, OSSServiceException;

    /**
     * do multipart upload task
     *
     * @return
     * @throws IOException
     * @throws OSSServiceException
     * @throws OSSClientException
     * @throws InterruptedException
     */
     abstract Result doMultipartUpload() throws IOException, OSSServiceException, OSSClientException, InterruptedException;

    /**
     * check is or not cancel
     *
     * @throws OSSClientException
     */
     void checkCancel()  {
        if (mContext.getCancellationHandler().isCancelled()) {
            TaskCancelException e = TaskCancelException("multipart cancel");
            throw OSSClientException(e.getMessage(), e, true);
        }
    }


     void preUploadPart(int readIndex, int byteCount, int partNumber)  {

    }

     void uploadPartFinish(PartETag partETag)  {
    }

    @override
     Result call()  {
        try {
            checkInitData();
            initMultipartUploadId();
            Result result = doMultipartUpload();

            if (mCompletedCallback != null) {
                mCompletedCallback.onSuccess(mRequest, result);
            }
            return result;
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

     void checkInitData()  {
        if (mRequest.getUploadFilePath() != null) {
            mUploadFilePath = mRequest.getUploadFilePath();
            mUploadedLength = 0;
            mUploadFile = File(mUploadFilePath);
            mFileLength = mUploadFile.length();

        } else if (mRequest.getUploadUri() != null) {
            mUploadUri = mRequest.getUploadUri();
            ParcelFileDescriptor mUploadFileDescriptor = null;
            try {
                mUploadFileDescriptor = mContext.getApplicationContext().getContentResolver().openFileDescriptor(mUploadUri, "r");
                mFileLength = mUploadFileDescriptor.getStatSize();
            } catch (IOException e) {
                throw OSSClientException(e.getMessage(), e, true);
            } finally {
                try {
                    if (mUploadFileDescriptor != null) {
                        mUploadFileDescriptor.close();
                    }
                } catch (IOException e) {
                    OSSLog.logThrowable2Local(e);
                }
            }
        }
        if (mFileLength == 0) {
            throw OSSClientException("file length must not be 0");
        }

        checkPartSize(mPartAttr);

        final int partSize = mRequest.getPartSize();
        final int partNumber = mPartAttr[1];

        OSSLog.logDebug("[checkInitData] - partNumber : " + partNumber);
        OSSLog.logDebug("[checkInitData] - partSize : " + partSize);


        if (partNumber > 1 && partSize < 102400) {
            throw OSSClientException("Part size must be greater than or equal to 100KB!");
        }
    }

     void uploadPart(int readIndex, int byteCount, int partNumber) {

        RandomAccessFile raf = null;
        InputStream inputStream = null;
        BufferedInputStream bufferedInputStream = null;
        try {

            if (mContext.getCancellationHandler().isCancelled()) {
                mPoolExecutor.getQueue().clear();
                return;
            }

            synchronized (mLock) {
                mRunPartTaskCount++;
            }

            preUploadPart(readIndex, byteCount, partNumber);

            List<int> partContent = byte[byteCount];
            int skip = readIndex * mRequest.getPartSize();
            if (mUploadUri != null) {
                inputStream = mContext.getApplicationContext().getContentResolver().openInputStream(mUploadUri);
                bufferedInputStream = BufferedInputStream(inputStream);
                bufferedInputStream.skip(skip);
                bufferedInputStream.read(partContent, 0, byteCount);
            } else {
                raf = RandomAccessFile(mUploadFile, "r");

                raf.seek(skip);
                raf.readFully(partContent, 0, byteCount);
            }

            UploadPartRequest uploadPart = UploadPartRequest(
                    mRequest.getBucketName(), mRequest.getObjectKey(), mUploadId, readIndex + 1);
            uploadPart.setPartContent(partContent);
            uploadPart.setMd5Digest(BinaryUtil.calculateBase64Md5(partContent));
            uploadPart.setCRC64(mRequest.getCRC64());
            UploadPartResult uploadPartResult = mApiOperation.syncUploadPart(uploadPart);
            //check isComplete
            synchronized (mLock) {
                PartETag partETag = PartETag(uploadPart.getPartNumber(), uploadPartResult.getETag());
                partETag.setPartSize(byteCount);
                if (mCheckCRC64) {
                    partETag.setCRC64(uploadPartResult.getClientCRC());
                }

                mPartETags.add(partETag);
                mUploadedLength += byteCount;

                uploadPartFinish(partETag);

                if (mContext.getCancellationHandler().isCancelled()) {
                    if (mPartETags.size() == (mRunPartTaskCount - mPartExceptionCount)) {
                        TaskCancelException e = TaskCancelException("multipart cancel");

                        throw OSSClientException(e.getMessage(), e, true);
                    }
                } else {
                    if (mPartETags.size() == (partNumber - mPartExceptionCount)) {
                        notifyMultipartThread();
                    }
                    onProgressCallback(mRequest, mUploadedLength, mFileLength);
                }

            }

        } catch (Exception e) {
            processException(e);
        } finally {
            try {
                if (raf != null)
                    raf.close();
                if (bufferedInputStream != null)
                    bufferedInputStream.close();
                if (inputStream != null)
                    inputStream.close();
            } catch (IOException e) {
                OSSLog.logThrowable2Local(e);
            }
        }
    }

    abstract  void processException(Exception e);

    /**
     * complete multipart upload
     *
     * @return
     * @throws OSSClientException
     * @throws OSSServiceException
     */
     CompleteMultipartUploadResult completeMultipartUploadResult()  {
        //complete sort
        CompleteMultipartUploadResult completeResult = null;
        if (mPartETags.size() > 0) {
            Collections.sort(mPartETags, Comparator<PartETag>() {
                @override
                 int compare(PartETag lhs, PartETag rhs) {
                    if (lhs.getPartNumber() < rhs.getPartNumber()) {
                        return -1;
                    } else if (lhs.getPartNumber() > rhs.getPartNumber()) {
                        return 1;
                    } else {
                        return 0;
                    }
                }
            });

            CompleteMultipartUploadRequest complete = CompleteMultipartUploadRequest(
                    mRequest.getBucketName(), mRequest.getObjectKey(), mUploadId, mPartETags);
            if (mRequest.getCallbackParam() != null) {
                complete.setCallbackParam(mRequest.getCallbackParam());
            }
            if (mRequest.getCallbackVars() != null) {
                complete.setCallbackVars(mRequest.getCallbackVars());
            }
            if (mRequest.getMetadata() != null) {
                ObjectMetadata metadata = ObjectMetadata();
                for (String key : mRequest.getMetadata().getRawMetadata().keySet()) {
                    if (!key.equals(OSSHeaders.STORAGE_CLASS)) {
                        metadata.setHeader(key, mRequest.getMetadata().getRawMetadata().get(key));
                    }
                }
                complete.setMetadata(metadata);
            }

            complete.setCRC64(mRequest.getCRC64());
            completeResult = mApiOperation.syncCompleteMultipartUpload(complete);
        }
        mUploadedLength = 0;
        return completeResult;
    }

     void releasePool() {
        if (mPoolExecutor != null) {
            mPoolExecutor.getQueue().clear();
            mPoolExecutor.shutdown();
        }
    }

     void checkException()  {
        if (mUploadException != null) {
            releasePool();
            if (mUploadException instanceof IOException) {
                throw (IOException) mUploadException;
            } else if (mUploadException instanceof OSSServiceException) {
                throw (OSSServiceException) mUploadException;
            } else if (mUploadException instanceof OSSClientException) {
                throw (OSSClientException) mUploadException;
            } else {
                OSSClientException clientException =
                        OSSClientException(mUploadException.getMessage(), mUploadException);
                throw clientException;
            }
        }
    }

     bool checkWaitCondition(int partNum) {
        if (mPartETags.size() == partNum) {
            return false;
        }
        return true;
    }

    /**
     * notify wait thread
     */
     void notifyMultipartThread() {
        mLock.notify();
        mPartExceptionCount = 0;
    }

    /**
     * check part size
     *
     * @param partAttr
     */
     void checkPartSize(int[] partAttr) {
        int partSize = mRequest.getPartSize();
        OSSLog.logDebug("[checkPartSize] - mFileLength : " + mFileLength);
        OSSLog.logDebug("[checkPartSize] - partSize : " + partSize);
        int partNumber = mFileLength / partSize;
        if (mFileLength % partSize != 0) {
            partNumber = partNumber + 1;
        }
        int MAX_PART_NUM = 5000;
        if (partNumber == 1) {
            partSize = mFileLength;
        } else if (partNumber > MAX_PART_NUM) {
            partSize = mFileLength / (MAX_PART_NUM - 1);
            partSize = ceilPartSize(partSize);
            partNumber = mFileLength / partSize;
            partNumber += (mFileLength % partSize != 0) ? 1 : 0;
        }
        partAttr[0] = (int) partSize;
        partAttr[1] = (int) partNumber;
        mRequest.setPartSize((int) partSize);

        OSSLog.logDebug("[checkPartSize] - partNumber : " + partNumber);
        OSSLog.logDebug("[checkPartSize] - partSize : " + (int) partSize);

        int lastPartSize = mFileLength % partSize;
        mLastPartSize = lastPartSize == 0 ? partSize : lastPartSize;
    }

     int ceilPartSize(int partSize) {
        partSize = (((partSize + (PART_SIZE_ALIGN_NUM - 1)) / PART_SIZE_ALIGN_NUM) * PART_SIZE_ALIGN_NUM);
        return partSize;
    }

    /**
     * progress callback
     *
     * @param request
     * @param currentSize
     * @param totalSize
     */
     void onProgressCallback(Request request, int currentSize, int totalSize) {
        if (mProgressCallback != null) {
            mProgressCallback.onProgress(request, currentSize, totalSize);
        }
    }

}
