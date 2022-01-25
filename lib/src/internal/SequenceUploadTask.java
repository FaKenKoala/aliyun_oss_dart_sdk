package com.alibaba.sdk.android.oss.internal;

import android.os.ParcelFileDescriptor;
import android.text.TextUtils;

import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.OSSServiceException;
import com.alibaba.sdk.android.oss.TaskCancelException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.utils.BinaryUtil;
import com.alibaba.sdk.android.oss.common.utils.CRC64;
import com.alibaba.sdk.android.oss.common.utils.OSSSharedPreferences;
import com.alibaba.sdk.android.oss.common.utils.OSSUtils;
import com.alibaba.sdk.android.oss.model.AbortMultipartUploadRequest;
import com.alibaba.sdk.android.oss.model.CompleteMultipartUploadResult;
import com.alibaba.sdk.android.oss.model.InitiateMultipartUploadRequest;
import com.alibaba.sdk.android.oss.model.InitiateMultipartUploadResult;
import com.alibaba.sdk.android.oss.model.ListPartsRequest;
import com.alibaba.sdk.android.oss.model.ListPartsResult;
import com.alibaba.sdk.android.oss.model.PartETag;
import com.alibaba.sdk.android.oss.model.PartSummary;
import com.alibaba.sdk.android.oss.model.ResumableUploadRequest;
import com.alibaba.sdk.android.oss.model.ResumableUploadResult;
import com.alibaba.sdk.android.oss.model.UploadPartRequest;
import com.alibaba.sdk.android.oss.model.UploadPartResult;
import com.alibaba.sdk.android.oss.network.ExecutionContext;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.OSSIOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.RandomAccessFile;
import java.util.List;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.zip.CheckedInputStream;

/**
 * Created by jingdan on 2017/10/30.
 */

 class SequenceUploadTask extends BaseMultipartUploadTask<ResumableUploadRequest,
        ResumableUploadResult> implements Callable<ResumableUploadResult> {

     File mRecordFile;
     List<Integer> mAlreadyUploadIndex = [];
     int mFirstPartSize;
     OSSSharedPreferences mSp;
     File mCRC64RecordFile;

     SequenceUploadTask(ResumableUploadRequest request,
                              OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult> completedCallback,
                              ExecutionContext context, InternalRequestOperation apiOperation) {
        super(apiOperation, request, completedCallback, context);
        mSp = OSSSharedPreferences.instance(mContext.getApplicationContext());
    }

    @override
     void initMultipartUploadId()  {

        Map<Integer, int> recordCrc64 = null;

        if (!OSSUtils.isEmptyString(mRequest.getRecordDirectory())) {
            String fileMd5 = null;
            if (mUploadUri != null) {
                ParcelFileDescriptor parcelFileDescriptor = mContext.getApplicationContext().getContentResolver().openFileDescriptor(mUploadUri, "r");
                try {
                    fileMd5 = BinaryUtil.calculateMd5Str(parcelFileDescriptor.getFileDescriptor());
                } finally {
                    if (parcelFileDescriptor != null) {
                        parcelFileDescriptor.close();
                    }
                }
            } else {
                fileMd5 = BinaryUtil.calculateMd5Str(mUploadFilePath);
            }
            String recordFileName = BinaryUtil.calculateMd5Str((fileMd5 + mRequest.getBucketName()
                    + mRequest.getObjectKey() + String.valueOf(mRequest.getPartSize()) + (mCheckCRC64 ? "-crc64" : "") + "-sequence").getBytes());
            String recordPath = mRequest.getRecordDirectory() + File.separator + recordFileName;

            mRecordFile = File(recordPath);
            if (mRecordFile.exists()) {
                BufferedReader br = BufferedReader(new FileReader(mRecordFile));
                mUploadId = br.readLine();
                br.close();
                OSSLog.logDebug("sequence [initUploadId] - Found record file, uploadid: " + mUploadId);
            }

            if (!OSSUtils.isEmptyString(mUploadId)) {
                if (mCheckCRC64) {
                    String filePath = mRequest.getRecordDirectory() + File.separator + mUploadId;
                    File crc64Record = File(filePath);
                    if (crc64Record.exists()) {
                        FileInputStream fs = FileInputStream(crc64Record);//创建文件字节输出流对象
                        ObjectInputStream ois = ObjectInputStream(fs);

                        try {
                            recordCrc64 = (Map<Integer, int>) ois.readObject();
                            crc64Record.delete();
                        } catch (ClassNotFoundException e) {
                            OSSLog.logThrowable2Local(e);
                        } finally {
                            if (ois != null)
                                ois.close();
                            crc64Record.delete();
                        }
                    }
                }

                bool isTruncated = false;
                int nextPartNumberMarker = 0;

                do {
                    ListPartsRequest listParts = ListPartsRequest(mRequest.getBucketName(), mRequest.getObjectKey(), mUploadId);
                    if (nextPartNumberMarker > 0){
                        listParts.setPartNumberMarker(nextPartNumberMarker);
                    }

                    OSSAsyncTask<ListPartsResult> task = mApiOperation.listParts(listParts, null);

                    try {

                        ListPartsResult result = task.getResult();
                        isTruncated = result.isTruncated();
                        nextPartNumberMarker = result.getNextPartNumberMarker();
                        List<PartSummary> parts = result.getParts();

                        for (int i = 0; i < parts.size(); i++) {
                            PartSummary part = parts.get(i);
                            PartETag partETag = PartETag(part.getPartNumber(), part.getETag());
                            partETag.setPartSize(part.getSize());

                            if (recordCrc64 != null && recordCrc64.size() > 0) {
                                if (recordCrc64.containsKey(partETag.getPartNumber())) {
                                    partETag.setCRC64(recordCrc64.get(partETag.getPartNumber()));
                                }
                            }

                            mPartETags.add(partETag);
                            mUploadedLength += part.getSize();
                            mAlreadyUploadIndex.add(part.getPartNumber());
                            if (i == 0) {
                                mFirstPartSize = part.getSize();
                            }
                        }
                    } catch (OSSServiceException e) {
                        isTruncated = false;
                        if (e.getStatusCode() == 404) {
                            mUploadId = null;
                        } else {
                            throw e;
                        }
                    } catch (OSSClientException e) {
                        isTruncated = false;
                        throw e;
                    }
                    task.waitUntilFinished();

                }while (isTruncated);
            }

            if (!mRecordFile.exists() && !mRecordFile.createNewFile()) {
                throw OSSClientException("Can't create file at path: " + mRecordFile.getAbsolutePath()
                        + "\nPlease make sure the directory exist!");
            }
        }

        if (OSSUtils.isEmptyString(mUploadId)) {
            InitiateMultipartUploadRequest init = InitiateMultipartUploadRequest(
                    mRequest.getBucketName(), mRequest.getObjectKey(), mRequest.getMetadata());
            init.isSequential = true;
            InitiateMultipartUploadResult initResult = mApiOperation.initMultipartUpload(init, null).getResult();

            mUploadId = initResult.getUploadId();

            if (mRecordFile != null) {
                BufferedWriter bw = BufferedWriter(new FileWriter(mRecordFile));
                bw.write(mUploadId);
                bw.close();
            }
        }

        mRequest.setUploadId(mUploadId);
    }

    @override
     ResumableUploadResult doMultipartUpload()  {

        int tempUploadedLength = mUploadedLength;

        checkCancel();

//        int[] mPartAttr = int[2];
//        checkPartSize(mPartAttr);

        int readByte = mPartAttr[0];
        final int partNumber = mPartAttr[1];

        if (mPartETags.size() > 0 && mAlreadyUploadIndex.size() > 0) { //revert progress
            if (mUploadedLength > mFileLength) {
                throw OSSClientException("The uploading file is inconsistent with before");
            }

            if (mFirstPartSize != readByte) {
                throw OSSClientException("The part size setting is inconsistent with before");
            }

            int revertUploadedLength = mUploadedLength;

            if (mSp.getStringValue(mUploadId)).notNullOrEmpty {
                revertUploadedLength = int.valueOf(mSp.getStringValue(mUploadId));
            }

            if (mProgressCallback != null) {
                mProgressCallback.onProgress(mRequest, revertUploadedLength, mFileLength);
            }

            mSp.removeKey(mUploadId);
        }

        for (int i = 0; i < partNumber; i++) {

            if (mAlreadyUploadIndex.size() != 0 && mAlreadyUploadIndex.contains(i + 1)) {
                continue;
            }

            //need read byte
            if (i == partNumber - 1) {
                readByte = (int) (mFileLength - tempUploadedLength);
            }
            OSSLog.logDebug("upload part readByte : " + readByte);
            int byteCount = readByte;
            int readIndex = i;
            tempUploadedLength += byteCount;
            uploadPart(readIndex, byteCount, partNumber);
            //break immediately for sequence upload
            if (mUploadException != null){
                break;
            }
        }

        checkException();
        //complete sort
        CompleteMultipartUploadResult completeResult = completeMultipartUploadResult();
        ResumableUploadResult result = null;
        if (completeResult != null) {
            result = ResumableUploadResult(completeResult);
        }
        if (mRecordFile != null) {
            mRecordFile.delete();
        }
        if (mCRC64RecordFile != null) {
            mCRC64RecordFile.delete();
        }
        return result;
    }

     void uploadPart(int readIndex, int byteCount, int partNumber) {

        RandomAccessFile raf = null;
        InputStream inputStream = null;
        BufferedInputStream bufferedInputStream = null;
        UploadPartRequest uploadPartRequest = null;
        try {

            if (mContext.getCancellationHandler().isCancelled()) {
                return;
            }

            mRunPartTaskCount++;

            preUploadPart(readIndex, byteCount, partNumber);
            int skip = readIndex * mRequest.getPartSize();
            List<int> partContent = byte[byteCount];

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

            uploadPartRequest = UploadPartRequest(
                    mRequest.getBucketName(), mRequest.getObjectKey(), mUploadId, readIndex + 1);
            uploadPartRequest.setPartContent(partContent);
            uploadPartRequest.setMd5Digest(BinaryUtil.calculateBase64Md5(partContent));
            uploadPartRequest.setCRC64(mRequest.getCRC64());
            UploadPartResult uploadPartResult = mApiOperation.syncUploadPart(uploadPartRequest);
            //check isComplete，throw exception when error occur
            PartETag partETag = PartETag(uploadPartRequest.getPartNumber(), uploadPartResult.getETag());
            partETag.setPartSize(byteCount);
            if (mCheckCRC64) {
                partETag.setCRC64(uploadPartResult.getClientCRC());
            }

            mPartETags.add(partETag);
            mUploadedLength += byteCount;

            uploadPartFinish(partETag);

            if (mContext.getCancellationHandler().isCancelled()) {
                //cancel immediately for sequence upload
                TaskCancelException e = TaskCancelException("sequence upload task cancel");
                throw OSSClientException(e.getMessage(), e, true);
            } else {
                onProgressCallback(mRequest, mUploadedLength, mFileLength);
            }
        } catch (OSSServiceException e) {
            // it is not necessary to throw 409 PartAlreadyExist exception out
            if (e.getStatusCode() != 409) {
                processException(e);
            } else {
                PartETag partETag = PartETag(uploadPartRequest.getPartNumber(), e.getPartEtag());
                partETag.setPartSize(uploadPartRequest.getPartContent().length);
                if (mCheckCRC64) {
                    List<int> partContent = uploadPartRequest.getPartContent();
                    ByteArrayInputStream byteArrayInputStream = ByteArrayInputStream(partContent);
                    CheckedInputStream checkedInputStream = CheckedInputStream(byteArrayInputStream, new CRC64());

                    partETag.setCRC64(checkedInputStream.getChecksum().getValue());
                }

                mPartETags.add(partETag);
                mUploadedLength += byteCount;
            }
        } catch ( e) {
            processException(e);
        } finally {
            try {
                if (raf != null)
                    raf.close();
                if (inputStream != null)
                    inputStream.close();
                if (bufferedInputStream != null)
                    bufferedInputStream.close();
            } catch (OSSIOException e) {
                OSSLog.logThrowable2Local(e);
            }
        }
    }


    @override
     void checkException()  {
        if (mContext.getCancellationHandler().isCancelled()) {
            if (mRequest.deleteUploadOnCancelling()) {
                abortThisUpload();
                if (mRecordFile != null) {
                    mRecordFile.delete();
                }
            } else {
                if (mPartETags != null && mPartETags.size() > 0 && mCheckCRC64 && mRequest.getRecordDirectory() != null) {
                    Map<Integer, int> maps = HashMap<Integer, int>();
                    for (PartETag eTag : mPartETags) {
                        maps[eTag.getPartNumber()] = eTag.getCRC64();
                    }
                    ObjectOutputStream oot = null;
                    try {
                        String filePath = mRequest.getRecordDirectory() + File.separator + mUploadId;
                        mCRC64RecordFile = File(filePath);
                        if (!mCRC64RecordFile.exists()) {
                            mCRC64RecordFile.createNewFile();
                        }
                        oot = ObjectOutputStream(new FileOutputStream(mCRC64RecordFile));
                        oot.writeObject(maps);
                    } catch (OSSIOException e) {
                        OSSLog.logThrowable2Local(e);
                    } finally {
                        if (oot != null) {
                            oot.close();
                        }
                    }
                }
            }
        }
        super.checkException();
    }

    @override
     void abortThisUpload() {
        if (mUploadId != null) {
            AbortMultipartUploadRequest abort = AbortMultipartUploadRequest(
                    mRequest.getBucketName(), mRequest.getObjectKey(), mUploadId);
            mApiOperation.abortMultipartUpload(abort, null).waitUntilFinished();
        }
    }

    @override
     void processException(Exception e) {
//        mPartExceptionCount++;
        if (mUploadException == null || !e.getMessage().equals(mUploadException.getMessage())) {
            mUploadException = e;
        }
        OSSLog.logThrowable2Local(e);
        if (mContext.getCancellationHandler().isCancelled()) {
            if (!mIsCancel) {
                mIsCancel = true;
            }
        }
    }

    @override
     void uploadPartFinish(PartETag partETag)  {
        if (mContext.getCancellationHandler().isCancelled()) {
            if (!mSp.contains(mUploadId)) {
                mSp.setStringValue(mUploadId, String.valueOf(mUploadedLength));
                onProgressCallback(mRequest, mUploadedLength, mFileLength);
            }
        }
    }
}
