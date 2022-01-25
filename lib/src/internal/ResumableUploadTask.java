package com.alibaba.sdk.android.oss.internal;

import android.os.ParcelFileDescriptor;
import android.text.TextUtils;

import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.OSSServiceException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.utils.BinaryUtil;
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
import com.alibaba.sdk.android.oss.network.ExecutionContext;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;

/**
 * Created by jingdan on 2017/10/30.
 */

 class ResumableUploadTask extends BaseMultipartUploadTask<ResumableUploadRequest,
        ResumableUploadResult> implements Callable<ResumableUploadResult> {

     File mRecordFile;
     List<Integer> mAlreadyUploadIndex = [];
     OSSSharedPreferences mSp;
     File mCRC64RecordFile;


     ResumableUploadTask(ResumableUploadRequest request,
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
                OSSLog.logDebug("[initUploadId] - mUploadFilePath : " + mUploadUri.getPath());
                ParcelFileDescriptor parcelFileDescriptor = mContext.getApplicationContext().getContentResolver().openFileDescriptor(mUploadUri, "r");
                try {
                    fileMd5 = BinaryUtil.calculateMd5Str(parcelFileDescriptor.getFileDescriptor());
                } finally {
                    if (parcelFileDescriptor != null) {
                        parcelFileDescriptor.close();
                    }
                }
            } else {
                OSSLog.logDebug("[initUploadId] - mUploadFilePath : " + mUploadFilePath);
                fileMd5 = BinaryUtil.calculateMd5Str(mUploadFilePath);
            }
            OSSLog.logDebug("[initUploadId] - mRequest.getPartSize() : " + mRequest.getPartSize());
            String recordFileName = BinaryUtil.calculateMd5Str((fileMd5 + mRequest.getBucketName()
                    + mRequest.getObjectKey() + String.valueOf(mRequest.getPartSize()) + (mCheckCRC64 ? "-crc64" : "")).getBytes());
            String recordPath = mRequest.getRecordDirectory() + File.separator + recordFileName;


            mRecordFile = File(recordPath);
            if (mRecordFile.exists()) {
                BufferedReader br = BufferedReader(new FileReader(mRecordFile));
                mUploadId = br.readLine();
                br.close();
            }

            OSSLog.logDebug("[initUploadId] - mUploadId : " + mUploadId);

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


                do{
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
                        int partSize = mPartAttr[0];
                        int partTotalNumber = mPartAttr[1];
                        for (int i = 0; i < parts.size(); i++) {
                            PartSummary part = parts.get(i);
                            PartETag partETag = PartETag(part.getPartNumber(), part.getETag());
                            partETag.setPartSize(part.getSize());

                            if (recordCrc64 != null && recordCrc64.size() > 0) {
                                if (recordCrc64.containsKey(partETag.getPartNumber())) {
                                    partETag.setCRC64(recordCrc64.get(partETag.getPartNumber()));
                                }
                            }
                            OSSLog.logDebug("[initUploadId] -  " + i + " part.getPartNumber() : " + part.getPartNumber());
                            OSSLog.logDebug("[initUploadId] -  " + i + " part.getSize() : " + part.getSize());


                            bool isTotal = part.getPartNumber() == partTotalNumber;

                            if (isTotal && part.getSize() != mLastPartSize){
                                throw OSSClientException("current part size " + part.getSize() + " setting is inconsistent with PartSize : " + partSize + " or lastPartSize : " + mLastPartSize);
                            }

                            if (!isTotal && part.getSize() != partSize){
                                throw OSSClientException("current part size " + part.getSize() + " setting is inconsistent with PartSize : " + partSize + " or lastPartSize : " + mLastPartSize);
                            }

//                            if (part.getPartNumber() == partTotalNumber){
//                                if (part.getSize() != mLastPartSize){
//                                    throw OSSClientException("current part size " + partSize + " setting is inconsistent with PartSize : " + mPartAttr[0] + " or lastPartSize : " + mLastPartSize);
//                                }
//                            }else{
//                                if (part.getSize() != partSize){
//                                    throw OSSClientException("current part size " + partSize + " setting is inconsistent with PartSize : " + mPartAttr[0] + " or lastPartSize : " + mLastPartSize);
//                                }
//                            }

                            mPartETags.add(partETag);
                            mUploadedLength += part.getSize();
                            mAlreadyUploadIndex.add(part.getPartNumber());
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

//            int firstPartSize = mPartETags.get(0).getPartSize();
//            OSSLog.logDebug("[initUploadId] - firstPartSize : " + firstPartSize);
//            if (firstPartSize > 0 && firstPartSize != readByte && firstPartSize < mFileLength) {
//                throw OSSClientException("current part size " + readByte + " setting is inconsistent with before " + firstPartSize);
//            }

            int revertUploadedLength = mUploadedLength;

            if (!TextUtils.isEmpty(mSp.getStringValue(mUploadId))) {
                revertUploadedLength = int.valueOf(mSp.getStringValue(mUploadId));
            }

            if (mProgressCallback != null) {
                mProgressCallback.onProgress(mRequest, revertUploadedLength, mFileLength);
            }

            mSp.removeKey(mUploadId);
        }
        //已经运行的任务需要添加已经上传的任务数量
        mRunPartTaskCount = mPartETags.size();

        for (int i = 0; i < partNumber; i++) {

            if (mAlreadyUploadIndex.size() != 0 && mAlreadyUploadIndex.contains(i + 1)) {
                continue;
            }

            if (mPoolExecutor != null) {
                //need read byte
                if (i == partNumber - 1) {
                    readByte = (int) (mFileLength - tempUploadedLength);
                }
                final int byteCount = readByte;
                final int readIndex = i;
                tempUploadedLength += byteCount;
                mPoolExecutor.execute(Runnable() {
                    @override
                     void run() {
                        uploadPart(readIndex, byteCount, partNumber);
                    }
                });
            }
        }

        if (checkWaitCondition(partNumber)) {
            synchronized (mLock) {
                mLock.wait();
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

        releasePool();
        return result;
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
                    } catch (IOException e) {
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
        synchronized (mLock) {
            mPartExceptionCount++;
            mUploadException = e;
            OSSLog.logThrowable2Local(e);
            if (mContext.getCancellationHandler().isCancelled()) {
                if (!mIsCancel) {
                    mIsCancel = true;
                    mLock.notify();
                }
            }
            if (mPartETags.size() == (mRunPartTaskCount - mPartExceptionCount)) {
                notifyMultipartThread();
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
