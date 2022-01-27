import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/lib_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/task_cancel_exception.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/callback/lib_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'package:aliyun_oss_dart_sdk/src/network/lib_network.dart';

import 'lib_internal.dart';

class SequenceUploadTask extends BaseMultipartUploadTask<ResumableUploadRequest,
    ResumableUploadResult> implements Callable<ResumableUploadResult> {
  File? recordFile;
  List<int> alreadyUploadIndex = [];
  int firstPartSize = 0;
  OSSSharedPreferences sp;
  File? crc64RecordFile;

  SequenceUploadTask(
      ResumableUploadRequest request,
      OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult>?
          completedCallback,
      ExecutionContext context,
      InternalRequestOperation apiOperation)
      : sp = OSSSharedPreferences.instance(context.getApplicationContext()),
        super(apiOperation, request, completedCallback, context);

  @override
  void initMultipartUploadId() async {
    Map<int, String?> recordCrc64 = {};

    if (request.recordDirectory.notNullOrEmpty) {
      String? fileMd5;
      if (uploadUri != null) {
        ParcelFileDescriptor parcelFileDescriptor = context
            .getApplicationContext()
            .getContentResolver()
            .openFileDescriptor(uploadUri, "r");
        try {
          fileMd5 = BinaryUtil.calculateMd5Str(
              parcelFileDescriptor.getFileDescriptor());
        } finally {
          if (parcelFileDescriptor != null) {
            parcelFileDescriptor.close();
          }
        }
      } else {
        fileMd5 = BinaryUtil.calculateMd5StrFromPath(uploadFilePath!);
      }
      String recordFileName = BinaryUtil.calculateMd5StrFromStr((fileMd5 +
          request.bucketName +
          request.objectKey +
          '$request.partSize}' +
          (isCheckCRC64 ? "-crc64" : "") +
          "-sequence"));
      String recordPath =
          '${request.recordDirectory}' + path.separator + recordFileName;

      recordFile = File(recordPath);
      if (recordFile!.existsSync()) {
        BufferedReader br = BufferedReader(FileReader(recordFile));
        uploadId = br.readLine();
        br.close();
        OSSLog.logDebug(
            "sequence [initUploadId] - Found record file, uploadid: $uploadId");
      }

      if (uploadId.notNullOrEmpty) {
        if (isCheckCRC64) {
          String filePath =
              '$request.recordDirectory}' + path.separator + uploadId!;
          File crc64Record = File(filePath);
          if (crc64Record.existsSync()) {
            FileInputStream fs = FileInputStream(crc64Record); //创建文件字节输出流对象
            ObjectInputStream ois = ObjectInputStream(fs);

            try {
              recordCrc64 = ois.readObject();
              crc64Record.delete();
            } on ClassNotFoundException catch (e) {
              OSSLog.logThrowable2Local(e);
            } finally {
              if (ois != null) {
                ois.close();
              }
              crc64Record.delete();
            }
          }
        }

        bool isTruncated = false;
        int nextPartNumberMarker = 0;

        do {
          ListPartsRequest listParts = ListPartsRequest(
              request.bucketName, request.objectKey, uploadId!);
          if (nextPartNumberMarker > 0) {
            listParts.partNumberMarker = nextPartNumberMarker;
          }

          OSSAsyncTask<ListPartsResult> task =
              operation.listParts(listParts, null);

          try {
            ListPartsResult result = await task.getResult();
            isTruncated = result.isTruncated;
            nextPartNumberMarker = result.nextPartNumberMarker;
            List<PartSummary> parts = result.getParts();

            for (int i = 0; i < parts.length; i++) {
              PartSummary part = parts[i];
              PartETag partETag = PartETag(part.partNumber, part.eTag);
              partETag.partSize = part.size;

              if (recordCrc64 != null && recordCrc64.isNotEmpty) {
                if (recordCrc64.containsKey(partETag.partNumber)) {
                  partETag.crc64 = recordCrc64[partETag.partNumber];
                }
              }

              partETags.add(partETag);
              uploadedLength += part.size;
              alreadyUploadIndex.add(part.partNumber);
              if (i == 0) {
                firstPartSize = part.size;
              }
            }
          } on OSSServiceException catch (e) {
            isTruncated = false;
            if (e.statusCode == HttpStatus.notFound) {
              uploadId = null;
            } else {
              rethrow;
            }
          } on OSSClientException catch (e) {
            isTruncated = false;
            rethrow;
          }
          task.waitUntilFinished();
        } while (isTruncated);
      }
      if (!recordFile!.existsSync()) {
        recordFile!.createSync();
      }
      if (!recordFile!.existsSync()) {
        throw OSSClientException(
            "Can't create file at path: ${recordFile!.path}" +
                "\nPlease make sure the directory exist!");
      }
    }

    if (uploadId.isNullOrEmpty) {
      InitiateMultipartUploadRequest init = InitiateMultipartUploadRequest(
          request.bucketName, request.objectKey, request.metadata);
      init.isSequential = true;
      InitiateMultipartUploadResult initResult =
          await operation.initMultipartUpload(init, null).getResult();

      uploadId = initResult.uploadId;

      if (recordFile != null) {
        BufferedWriter bw = BufferedWriter(FileWriter(recordFile));
        bw.write(uploadId);
        bw.close();
      }
    }

    request.uploadId = uploadId;
  }

  @override
  ResumableUploadResult? doMultipartUpload() {
    int tempUploadedLength = uploadedLength;

    checkCancel();

//        int[] mPartAttr = int[2];
//        checkPartSize(mPartAttr);

    int readByte = partAttr[0];
    final int partNumber = partAttr[1];

    if (partETags.isNotEmpty && alreadyUploadIndex.isNotEmpty) {
      //revert progress
      if (uploadedLength > fileLength) {
        throw OSSClientException(
            "The uploading file is inconsistent with before");
      }

      if (firstPartSize != readByte) {
        throw OSSClientException(
            "The part size setting is inconsistent with before");
      }

      int revertUploadedLength = uploadedLength;

      if (sp.getStringValue(uploadId!).notNullOrEmpty) {
        revertUploadedLength = int.parse(sp.getStringValue(uploadId!));
      }

      progressCallback?.onProgress(request, revertUploadedLength, fileLength);

      sp.removeKey(uploadId!);
    }

    for (int i = 0; i < partNumber; i++) {
      if (alreadyUploadIndex.isNotEmpty && alreadyUploadIndex.contains(i + 1)) {
        continue;
      }

      //need read byte
      if (i == partNumber - 1) {
        readByte = fileLength - tempUploadedLength;
      }
      OSSLog.logDebug("upload part readByte : $readByte");
      int byteCount = readByte;
      int readIndex = i;
      tempUploadedLength += byteCount;
      uploadPart(readIndex, byteCount, partNumber);
      //break immediately for sequence upload
      if (uploadException != null) {
        break;
      }
    }

    checkException();
    //complete sort
    CompleteMultipartUploadResult? completeResult =
        completeMultipartUploadResult();
    ResumableUploadResult? result;
    if (completeResult != null) {
      result = ResumableUploadResult(completeResult);
    }
    recordFile?.delete();
    crc64RecordFile?.delete();
    return result;
  }

  @override
  void uploadPart(int readIndex, int byteCount, int partNumber) async {
    RandomAccessFile? raf;
    InputStream? inputStream;
    BufferedInputStream? bufferedInputStream;
    UploadPartRequest? uploadPartRequest;
    try {
      if (context.cancellationHandler.isCancelled) {
        return;
      }

      runPartTaskCount++;

      preUploadPart(readIndex, byteCount, partNumber);
      int skip = readIndex * request.partSize;
      List<int> partContent = List.filled(byteCount, 0);

      if (uploadUri != null) {
        inputStream = context
            .getApplicationContext()
            .getContentResolver()
            .openInputStream(uploadUri);
        bufferedInputStream = BufferedInputStream(inputStream);
        bufferedInputStream.skip(skip);
        bufferedInputStream.read(partContent, 0, byteCount);
      } else {
        raf = uploadFile!.openSync();

        raf.seek(skip);
        raf.readFully(partContent, 0, byteCount);
      }

      uploadPartRequest = UploadPartRequest(
          request.bucketName, request.objectKey, uploadId, readIndex + 1);
      uploadPartRequest.partContent = partContent;
      uploadPartRequest.md5Digest = BinaryUtil.calculateBase64Md5(partContent);
      uploadPartRequest.crc64Config = request.crc64Config;
      UploadPartResult uploadPartResult =
          await operation.syncUploadPart(uploadPartRequest);
      //check isComplete，throw exception when error occur
      PartETag partETag =
          PartETag(uploadPartRequest.partNumber, uploadPartResult.eTag);
      partETag.partSize = byteCount;
      if (isCheckCRC64) {
        partETag.crc64 = uploadPartResult.clientCRC;
      }

      partETags.add(partETag);
      uploadedLength += byteCount;

      uploadPartFinish(partETag);

      if (context.cancellationHandler.isCancelled) {
        //cancel immediately for sequence upload
        TaskCancelException e =
            TaskCancelException("sequence upload task cancel");
        throw OSSClientException(e, true);
      } else {
        onProgressCallback(request, uploadedLength, fileLength);
      }
    } on OSSServiceException catch (e) {
      // it is not necessary to throw 409 PartAlreadyExist exception out
      if (e.statusCode != HttpStatus.conflict) {
        processException(e);
      } else {
        PartETag partETag = PartETag(uploadPartRequest!.partNumber, e.partEtag);
        partETag.partSize = uploadPartRequest.partContent.length;
        if (isCheckCRC64) {
          List<int> partContent = uploadPartRequest.partContent;
          ByteArrayInputStream byteArrayInputStream =
              ByteArrayInputStream(partContent);
          CheckedInputStream checkedInputStream =
              CheckedInputStream(byteArrayInputStream, OSSCRC64());

          partETag.crc64 = checkedInputStream.checksum.value;
        }

        partETags.add(partETag);
        uploadedLength += byteCount;
      }
    } catch (e) {
      processException(e as Exception);
    } finally {
      try {
        if (raf != null) {
          raf.close();
        }
        if (inputStream != null) {
          inputStream.close();
        }
        if (bufferedInputStream != null) {
          bufferedInputStream.close();
        }
      } on OSSIOException catch (e) {
        OSSLog.logThrowable2Local(e);
      }
    }
  }

  @override
  void checkException() {
    if (context.cancellationHandler.isCancelled) {
      if (request.deleteUploadOnCancelling) {
        abortThisUpload();
        recordFile?.delete();
      } else {
        if (partETags != null &&
            partETags.isNotEmpty &&
            isCheckCRC64 &&
            request.recordDirectory != null) {
          Map<int, String?> maps = <int, String?>{};
          for (PartETag eTag in partETags) {
            maps[eTag.partNumber] = eTag.crc64;
          }
          ObjectOutputStream? oot;
          try {
            String filePath =
                '${request.recordDirectory}' + path.separator + uploadId!;
            crc64RecordFile = File(filePath);
            if (!crc64RecordFile!.existsSync()) {
              crc64RecordFile?.createSync();
            }
            oot = ObjectOutputStream(FileOutputStream(crc64RecordFile));
            oot.writeObject(maps);
          } on OSSIOException catch (e) {
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
//        mPartExceptionCount++;
    uploadException = e;
    OSSLog.logThrowable2Local(e);
    if (context.cancellationHandler.isCancelled) {
      if (!isCancel) {
        isCancel = true;
      }
    }
  }

  @override
  void uploadPartFinish(PartETag partETag) {
    if (context.cancellationHandler.isCancelled) {
      if (!sp.contains(uploadId!)) {
        sp.setStringValue(uploadId!, '$uploadedLength');
        onProgressCallback(request, uploadedLength, fileLength);
      }
    }
  }
}
