package com.alibaba.sdk.android.oss.internal;

import android.os.Environment;
import android.os.ParcelFileDescriptor;

import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.OSSServiceException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.common.OSSConstants;
import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.utils.BinaryUtil;
import com.alibaba.sdk.android.oss.common.utils.OSSUtils;
import com.alibaba.sdk.android.oss.model.AbortMultipartUploadRequest;
import com.alibaba.sdk.android.oss.model.ResumableDownloadResult;
import com.alibaba.sdk.android.oss.model.CompleteMultipartUploadResult;
import com.alibaba.sdk.android.oss.model.HeadObjectRequest;
import com.alibaba.sdk.android.oss.model.ResumableDownloadRequest;
import com.alibaba.sdk.android.oss.model.MultipartUploadRequest;
import com.alibaba.sdk.android.oss.model.OSSRequest;
import com.alibaba.sdk.android.oss.model.ResumableUploadRequest;
import com.alibaba.sdk.android.oss.model.ResumableUploadResult;
import com.alibaba.sdk.android.oss.network.ExecutionContext;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.OSSIOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

/**
 * Created by zhouzhuo on 11/27/15.
 */
 class ExtensionRequestOperation {

     static ExecutorService executorService =
            Executors.newFixedThreadPool(OSSConstants.DEFAULT_BASE_THREAD_POOL_SIZE, ThreadFactory() {
                @override
                 Thread newThread(Runnable r) {
                    return Thread(r, "oss-android-extensionapi-thread");
                }
            });
     InternalRequestOperation apiOperation;

     ExtensionRequestOperation(InternalRequestOperation apiOperation) {
        this.apiOperation = apiOperation;
    }

     bool doesObjectExist(String bucketName, String objectKey)
             {

        try {
            HeadObjectRequest head = HeadObjectRequest(bucketName, objectKey);
            apiOperation.headObject(head, null).getResult();
            return true;
        } catch (OSSServiceException e) {
            if (e.getStatusCode() == 404) {
                return false;
            } else {
                throw e;
            }
        }
    }

     void abortResumableUpload(ResumableUploadRequest request)  {
        setCRC64(request);

        if (!OSSUtils.isEmptyString(request.getRecordDirectory())) {
            String uploadFilePath = request.getUploadFilePath();
            String fileMd5 = null;
            if (uploadFilePath != null) {
                fileMd5 = BinaryUtil.calculateMd5Str(uploadFilePath);
            } else {
                ParcelFileDescriptor parcelFileDescriptor = apiOperation.getApplicationContext().getContentResolver().openFileDescriptor(request.getUploadUri(), "r");
                try {
                    fileMd5 = BinaryUtil.calculateMd5Str(parcelFileDescriptor.getFileDescriptor());
                } finally {
                    if (parcelFileDescriptor != null) {
                        parcelFileDescriptor.close();
                    }
                }
            }
            String recordFileName = BinaryUtil.calculateMd5Str((fileMd5 + request.getBucketName()
                    + request.getObjectKey() + String.valueOf(request.getPartSize())).getBytes());
            String recordPath = request.getRecordDirectory() + "/" + recordFileName;
            File recordFile = File(recordPath);

            if (recordFile.exists()) {
                BufferedReader br = BufferedReader(new FileReader(recordFile));
                String uploadId = br.readLine();
                br.close();

                OSSLog.logDebug("[initUploadId] - Found record file, uploadid: " + uploadId);

                if (request.getCRC64() == OSSRequest.CRC64Config.YES) {
                    String filePath = Environment.getExternalStorageDirectory().getPath() + File.separator + "oss" + File.separator + uploadId;
                    File file = File(filePath);
                    if (file.exists()) {
                        file.delete();
                    }
                }

                AbortMultipartUploadRequest abort = AbortMultipartUploadRequest(
                        request.getBucketName(), request.getObjectKey(), uploadId);
                apiOperation.abortMultipartUpload(abort, null);
            }

            if (recordFile != null) {
                recordFile.delete();
            }
        }
    }

     OSSAsyncTask<ResumableUploadResult> resumableUpload(
            ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest
            , ResumableUploadResult> completedCallback) {
        setCRC64(request);
        ExecutionContext<ResumableUploadRequest, ResumableUploadResult> executionContext =
                ExecutionContext(apiOperation.getInnerClient(), request, apiOperation.getApplicationContext());

        return OSSAsyncTask.wrapRequestTask(executorService.submit(ResumableUploadTask(request,
                completedCallback, executionContext, apiOperation)), executionContext);
    }

     OSSAsyncTask<ResumableUploadResult> sequenceUpload(
            ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest
            , ResumableUploadResult> completedCallback) {
        setCRC64(request);
        ExecutionContext<ResumableUploadRequest, ResumableUploadResult> executionContext =
                ExecutionContext(apiOperation.getInnerClient(), request, apiOperation.getApplicationContext());

        SequenceUploadTask task = SequenceUploadTask(request,
                completedCallback, executionContext, apiOperation);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(task), executionContext);
    }


     OSSAsyncTask<CompleteMultipartUploadResult> multipartUpload(MultipartUploadRequest request
            , OSSCompletedCallback<MultipartUploadRequest
            , CompleteMultipartUploadResult> completedCallback) {
        setCRC64(request);
        ExecutionContext<MultipartUploadRequest, CompleteMultipartUploadResult> executionContext =
                ExecutionContext(apiOperation.getInnerClient(), request, apiOperation.getApplicationContext());

        return OSSAsyncTask.wrapRequestTask(executorService.submit(MultipartUploadTask(apiOperation
                , request, completedCallback, executionContext)), executionContext);
    }

     OSSAsyncTask<ResumableDownloadResult> resumableDownload(ResumableDownloadRequest request,
                                                                   OSSCompletedCallback<ResumableDownloadRequest, ResumableDownloadResult> completedCallback) {
        ExecutionContext<ResumableDownloadRequest, ResumableDownloadResult> executionContext =
                ExecutionContext(apiOperation.getInnerClient(), request, apiOperation.getApplicationContext());
        return OSSAsyncTask.wrapRequestTask(executorService.submit(ResumableDownloadTask(apiOperation, request, completedCallback, executionContext)), executionContext);
    }

     void setCRC64(OSSRequest request) {
        Enum crc64 = request.getCRC64() != OSSRequest.CRC64Config.NULL ? request.getCRC64() :
                (apiOperation.getConf().isCheckCRC64() ? OSSRequest.CRC64Config.YES : OSSRequest.CRC64Config.NO);
        request.setCRC64(crc64);
    }
}
