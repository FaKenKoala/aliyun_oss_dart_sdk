
 import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/callback/lib_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/lib_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/lib_internal.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'package:aliyun_oss_dart_sdk/src/network/lib_network.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';
import 'package:path/path.dart' as path;
class ResumableUploadTask extends BaseMultipartUploadTask<ResumableUploadRequest,
        ResumableUploadResult> implements Callable<ResumableUploadResult> {

     File? recordFile;
     List<int> alreadyUploadIndex = [];
     OSSSharedPreferences sp;
     File? crc64RecordFile;


     ResumableUploadTask(ResumableUploadRequest request,
                               OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult>? completedCallback,
                               ExecutionContext context, InternalRequestOperation apiOperation) :
        sp = OSSSharedPreferences.instance(context.getApplicationContext()),
        super(apiOperation, request, completedCallback, context);


    @override
     void initMultipartUploadId() async {

        Map<int, String> recordCrc64 = {};

        if (request.recordDirectory.notNullOrEmpty) {
            String? fileMd5;
            if (uploadUri != null) {
                OSSLog.logDebug("[initUploadId] - mUploadFilePath : ${uploadUri!.path}");
                ParcelFileDescriptor parcelFileDescriptor = context.getApplicationContext().getContentResolver().openFileDescriptor(uploadUri, "r");
                try {
                    fileMd5 = BinaryUtil.calculateMd5Str(parcelFileDescriptor.getFileDescriptor());
                } finally {
                    if (parcelFileDescriptor != null) {
                        parcelFileDescriptor.close();
                    }
                }
            } else {
                OSSLog.logDebug("[initUploadId] - mUploadFilePath : " + uploadFilePath!);
                fileMd5 = BinaryUtil.calculateMd5StrFromPath(uploadFilePath!);
            }
            OSSLog.logDebug("[initUploadId] - mrequest.partSize : " + '{request.partSize}');
            String recordFileName = BinaryUtil.calculateMd5StrFromStr((fileMd5 + request.bucketName
                    + request.objectKey + '${request.partSize}' + (isCheckCRC64 ? "-crc64" : "")));
            String recordPath = '${request.recordDirectory}' + path.separator + recordFileName;


            recordFile = File(recordPath);
            if (recordFile!.existsSync()) {
                BufferedReader br = BufferedReader(FileReader(recordFile));
                uploadId = br.readLine();
                br.close();
            }

            OSSLog.logDebug("[initUploadId] - uploadId : $uploadId" );

            if (uploadId.notNullOrEmpty) {
                if (isCheckCRC64) {
                    String filePath = '${request.recordDirectory}' + path.separator + '$uploadId';
                    File crc64Record = File(filePath);
                    if (crc64Record.existsSync()) {
                        FileInputStream fs = FileInputStream(crc64Record);//创建文件字节输出流对象
                        ObjectInputStream ois = ObjectInputStream(fs);

                        try {
                            recordCrc64 =  ois.readObject();
                            crc64Record.deleteSync();
                        } on ClassNotFoundException catch ( e) {
                            OSSLog.logThrowable2Local(e);
                        } finally {
                                ois?.close();
                            crc64Record.deleteSync();
                        }
                    }
                }

                bool isTruncated = false;
                int nextPartNumberMarker = 0;


                do{
                    ListPartsRequest listParts = ListPartsRequest(request.bucketName, request.objectKey, uploadId!);
                    if (nextPartNumberMarker > 0){
                        listParts.partNumberMarker = nextPartNumberMarker;
                    }

                    OSSAsyncTask<ListPartsResult> task = operation.listParts(listParts, null);
                    try {
                        ListPartsResult result = await task.getResult();
                        isTruncated = result.isTruncated;
                        nextPartNumberMarker = result.nextPartNumberMarker;
                        List<PartSummary> parts = result.getParts();
                        int partSize = partAttr[0];
                        int partTotalNumber = partAttr[1];
                        for (int i = 0; i < parts.length; i++) {
                            PartSummary part = parts[i];
                            PartETag partETag = PartETag(part.partNumber, part.eTag);
                            partETag.partSize = (part.size);

                            if (recordCrc64 != null && recordCrc64.isNotEmpty) {
                                if (recordCrc64.containsKey(partETag.partNumber)) {
                                    partETag.crc64 = recordCrc64[partETag.partNumber];
                                }
                            }
                            OSSLog.logDebug("[initUploadId] -  $i"  " part.partNumber : ${part.partNumber}");
                            OSSLog.logDebug("[initUploadId] -  $i" " part.size : $part.size}");


                            bool isTotal = part.partNumber == partTotalNumber;

                            if (isTotal && part.size != lastPartSize){
                                throw OSSClientException("current part size " '${part.size}' " setting is inconsistent with PartSize : " '$partSize' " or lastPartSize : $lastPartSize" );
                            }

                            if (!isTotal && part.size != partSize){
                                throw OSSClientException("current part size "  '${part.size}'  " setting is inconsistent with PartSize : "  '$partSize'  " or lastPartSize : $lastPartSize");
                            }

//                            if (part.partNumber == partTotalNumber){
//                                if (part.size != lastPartSize){
//                                    throw OSSClientException("current part size " + partSize + " setting is inconsistent with PartSize : " + mPartAttr[0] + " or lastPartSize : " + lastPartSize);
//                                }
//                            }else{
//                                if (part.size != partSize){
//                                    throw OSSClientException("current part size " + partSize + " setting is inconsistent with PartSize : " + mPartAttr[0] + " or lastPartSize : " + lastPartSize);
//                                }
//                            }

                            partETags.add(partETag);
                            uploadedLength += part.size;
                            alreadyUploadIndex.add(part.partNumber);
                        }
                    } on OSSServiceException catch ( e) {
                        isTruncated = false;
                        if (e.statusCode == HttpStatus.notFound) {
                            uploadId = null;
                        } else {
                            rethrow;
                        }
                    }on OSSClientException catch ( e) {
                        isTruncated = false;
                        rethrow;
                    }
                    task.waitUntilFinished();
                }while (isTruncated);

            }

            if (!recordFile!.existsSync()) {

              try{
                recordFile!.createSync();
              }catch(e){
                throw OSSClientException("Can't create file at path: " + recordFile.path
                        + "\nPlease make sure the directory exist!");
              }
            }
        }

        if (uploadId.isNullOrEmpty) {
            InitiateMultipartUploadRequest init = InitiateMultipartUploadRequest(
                    request.bucketName, request.objectKey, request.metadata);

            InitiateMultipartUploadResult initResult = await operation.initMultipartUpload(init, null).getResult();

            uploadId = initResult.uploadId;

            if (recordFile != null) {
                BufferedWriter bw = BufferedWriter(FileWriter(recordFile));
                bw.write(uploadId);
                bw.close();
            }
        }

        request.uploadId = (uploadId);
    }

    @override
     Future<ResumableUploadResult?> doMultipartUpload()  async{

        int tempUploadedLength = uploadedLength;
        checkCancel();
//        int[] mPartAttr = int[2];
//        checkPartSize(mPartAttr);
        int readByte = partAttr[0];
        final int partNumber = partAttr[1];

        if (partETags.isNotEmpty && alreadyUploadIndex.isNotEmpty) { //revert progress
            if (uploadedLength > fileLength) {
                throw OSSClientException("The uploading file is inconsistent with before");
            }

//            int firstPartSize = mPartETags.get(0).getPartSize();
//            OSSLog.logDebug("[initUploadId] - firstPartSize : " + firstPartSize);
//            if (firstPartSize > 0 && firstPartSize != readByte && firstPartSize < fileLength) {
//                throw OSSClientException("current part size " + readByte + " setting is inconsistent with before " + firstPartSize);
//            }

            int revertUploadedLength = uploadedLength;

            if (sp.getStringValue(uploadId!).notNullOrEmpty) {
                revertUploadedLength = int.parse(sp.getStringValue(uploadId!));
            }

                progressCallback?.onProgress(request, revertUploadedLength, fileLength);

            sp.removeKey(uploadId!);
        }
        //已经运行的任务需要添加已经上传的任务数量
        runPartTaskCount = partETags.length;

        for (int i = 0; i < partNumber; i++) {

            if (alreadyUploadIndex.isNotEmpty && alreadyUploadIndex.contains(i + 1)) {
                continue;
            }

            if (mPoolExecutor != null) {
                //need read byte
                if (i == partNumber - 1) {
                    readByte = fileLength - tempUploadedLength;
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
            //  (mLock) {
            //     mLock.wait();
            // }
        }

        checkException();
        //complete sort
        CompleteMultipartUploadResult? completeResult = await completeMultipartUploadResult();
        ResumableUploadResult? result;
        if (completeResult != null) {
            result = ResumableUploadResult(completeResult);
        }
            recordFile?.deleteSync();
            crc64RecordFile?.deleteSync();

        releasePool();
        return result;
    }

    @override
     void checkException()  {
        if (context.cancellationHandler.isCancelled) {
            if (request.deleteUploadOnCancelling) {
                abortThisUpload();
                    recordFile?.deleteSync();
            } else {
                if (partETags != null && partETags.isNotEmpty && isCheckCRC64 && request.recordDirectory != null) {
                    Map<int, String?> maps = {};
                    for (PartETag eTag in partETags) {
                        maps[eTag.partNumber] = eTag.crc64;
                    }
                    ObjectOutputStream? oot = null;
                    try {
                        String filePath = '${request.recordDirectory}' + path.separator + '$uploadId';
                        crc64RecordFile = File(filePath);
                        if (!crc64RecordFile!.existsSync()) {
                            crc64RecordFile!.createSync();
                        }
                        oot = ObjectOutputStream(FileOutputStream(crc64RecordFile));
                        oot.writeObject(maps);
                    } on OSSIOException catch ( e) {
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
        if (uploadId != null) {
            AbortMultipartUploadRequest abort = AbortMultipartUploadRequest(
                    request.bucketName, request.objectKey, uploadId!);
            operation.abortMultipartUpload(abort, null).waitUntilFinished();
        }
    }

    @override
     void processException(Exception e) {
            partExceptionCount++;
            uploadException = e;
            OSSLog.logThrowable2Local(e);
            if (context.cancellationHandler.isCancelled) {
                if (!isCancel) {
                    isCancel = true;
                    mLock.notify();
                }
            }
            if (partETags.length == (runPartTaskCount - partExceptionCount)) {
                notifyMultipartThread();
            }
    }

    @override
     void uploadPartFinish(PartETag partETag)  {
        if (context.cancellationHandler.isCancelled) {
            if (!sp.contains(uploadId!)) {
                sp.setStringValue(uploadId!, '$uploadedLength');
                onProgressCallback(request, uploadedLength, fileLength);
            }
        }
    }
}
