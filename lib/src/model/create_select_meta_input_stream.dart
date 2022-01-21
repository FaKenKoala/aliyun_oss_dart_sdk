 import 'package:aliyun_oss_dart_sdk/src/event/progress_event_type.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_listener.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_publisher.dart';

import 'select_object_metadata.dart';

class CreateSelectMetaInputStream extends FilterInputStream {
    /// Format of continuous frame
    /// |--frame type(4 bytes)--|--payload length(4 bytes)--|--header checksum(4 bytes)--|
    /// |--scanned data bytes(8 bytes)--|--payload checksum(4 bytes)--|
     static final int CONTINUOUS_FRAME_MAGIC = 8388612;

    /// Format of csv end frame
    /// |--frame type(4 bytes)--|--payload length(4 bytes)--|--header checksum(4 bytes)--|
    /// |--scanned data bytes(8 bytes)--|--total scan size(8 bytes)--|
    /// |--status code(4 bytes)--|--total splits count(4 bytes)--|
    /// |--total lines(8 bytes)--|--columns count(4 bytes)--|--error message(optional)--|--payload checksum(4 bytes)--|
     static final int CSV_END_FRAME_MAGIC = 8388614;

    /// Format of json end frame
    /// |--frame type(4 bytes)--|--payload length(4 bytes)--|--header checksum(4 bytes)--|
    /// |--scanned data bytes(8 bytes)--|--total scan size(8 bytes)--|
    /// |--status code(4 bytes)--|--total splits count(4 bytes)--|
    /// |--total lines(8 bytes)--|--error message(optional)--|--payload checksum(4 bytes)--|
     static final int JSON_END_FRAME_MAGIC = 8388615;
     static final int SELECT_VERSION = 1;
     static final int DEFAULT_NOTIFICATION_THRESHOLD = 50 * 1024 * 1024;//notify every scanned 50MB

     int currentFrameOffset;
     int currentFramePayloadLength;
     List<int> currentFrameTypeBytes;
     List<int> currentFramePayloadLengthBytes;
     List<int> currentFrameHeaderChecksumBytes;
     List<int> scannedDataBytes;
     List<int> currentFramePayloadChecksumBytes;
     bool finished;
     ProgressListener selectProgressListener;
     int nextNotificationScannedSize;
     CRC32 crc32;
     SelectContentMetadataBase selectContentMetadataBase;
     String requestId;
    /// payload checksum is the last 4 bytes in one frame, we use this flag to indicate whether we
    /// need read the 4 bytes before we advance to next frame.
     bool firstReadFrame;

     CreateSelectMetaInputStream(InputStream inputStream, SelectContentMetadataBase selectContentMetadataBase, ProgressListener selectProgressListener) {
        super(inputStream);
        currentFrameOffset = 0;
        currentFramePayloadLength = 0;
        currentFrameTypeBytes = byte[4];
        currentFramePayloadLengthBytes = byte[4];
        currentFrameHeaderChecksumBytes = byte[4];
        scannedDataBytes = byte[8];
        currentFramePayloadChecksumBytes = byte[4];
        finished = false;
        firstReadFrame = true;
        this.selectContentMetadataBase = selectContentMetadataBase;
        this.selectProgressListener = selectProgressListener;
        nextNotificationScannedSize = DEFAULT_NOTIFICATION_THRESHOLD;
        crc32 = CRC32();
        crc32.reset();
    }

     void internalRead(List<int> buf, int off, int len) {
        int bytesRead = 0;
        while (bytesRead < len) {
            int bytes = in.read(buf, off + bytesRead, len - bytesRead);
            if (bytes < 0) {
                throw SelectObjectException(SelectObjectException.INVALID_INPUT_STREAM, "Invalid input stream end found, need another " + (len - bytesRead) + " bytes", requestId);
            }
            bytesRead += bytes;
        }
    }

     void validateCheckSum(List<int> checksumBytes, CRC32 crc32) throws IOException {
        int currentChecksum = ByteBuffer.wrap(checksumBytes).getInt();
        if (crc32.getValue() != ((int)currentChecksum & 0xffffffffL)) {
            throw SelectObjectException(SelectObjectException.INVALID_CRC, "Frame crc check failed, actual " + crc32.getValue() + ", expect: " + currentChecksum, requestId);
        }
        crc32.reset();
    }

     void readFrame()  {
        while (currentFrameOffset >= currentFramePayloadLength && !finished) {
            if (!firstReadFrame) {
                internalRead(currentFramePayloadChecksumBytes, 0, 4);
                validateCheckSum(currentFramePayloadChecksumBytes, crc32);
            }
            firstReadFrame = false;
            //advance to next frame
            internalRead(currentFrameTypeBytes, 0, 4);
            //first byte is version byte
            if (currentFrameTypeBytes[0] != SELECT_VERSION) {
                throw SelectObjectException(SelectObjectException.INVALID_SELECT_VERSION, "Invalid select version found " + currentFrameTypeBytes[0] + ", expect: " + SELECT_VERSION, requestId);
            }
            internalRead(currentFramePayloadLengthBytes, 0, 4);
            internalRead(currentFrameHeaderChecksumBytes, 0, 4);
            internalRead(scannedDataBytes, 0, 8);
            crc32.update(scannedDataBytes);

            currentFrameTypeBytes[0] = 0;
            int type = ByteBuffer.wrap(currentFrameTypeBytes).getInt();
            switch (type) {
                case CONTINUOUS_FRAME_MAGIC:
                    //just break, continue
                    break;
                case CSV_END_FRAME_MAGIC:
                case JSON_END_FRAME_MAGIC:
                    currentFramePayloadLength = ByteBuffer.wrap(currentFramePayloadLengthBytes).getInt() - 8;
                    List<int> totalScannedDataSizeBytes = byte[8];
                    internalRead(totalScannedDataSizeBytes, 0, 8);
                    List<int> statusBytes = byte[4];
                    internalRead(statusBytes, 0, 4);
                    List<int> splitBytes = byte[4];
                    internalRead(splitBytes, 0, 4);
                    List<int> totalLineBytes = byte[8];
                    internalRead(totalLineBytes, 0, 8);
                    List<int> columnBytes = byte[4];
                    if (type == CSV_END_FRAME_MAGIC) {
                        internalRead(columnBytes, 0, 4);
                    }

                    crc32.update(totalScannedDataSizeBytes);
                    crc32.update(statusBytes);
                    crc32.update(splitBytes);
                    crc32.update(totalLineBytes);
                    if (type == CSV_END_FRAME_MAGIC) {
                        crc32.update(columnBytes);
                    }
                    int status = ByteBuffer.wrap(statusBytes).getInt();
                    int errorMessageSize;
                    if (type == CSV_END_FRAME_MAGIC) {
                        errorMessageSize = (int)(currentFramePayloadLength - 28);
                    } else {
                        errorMessageSize = (int)(currentFramePayloadLength - 24);
                    }

                    String error = "";
                    if (errorMessageSize > 0) {
                        List<int> errorMessageBytes = byte[errorMessageSize];
                        internalRead(errorMessageBytes, 0, errorMessageSize);
                        error = String(errorMessageBytes);
                        crc32.update(errorMessageBytes);
                    }

                    finished = true;
                    currentFramePayloadLength = currentFrameOffset;
                    internalRead(currentFramePayloadChecksumBytes, 0, 4);

                    validateCheckSum(currentFramePayloadChecksumBytes, crc32);
                    if (status / 100 != 2) {
                        if (error.contains(".")) {
                            throw SelectObjectException(error.split("\\.")[0], error.substring(error.indexOf(".") + 1), requestId);
                        } else {
                            // forward compatbility consideration
                            throw SelectObjectException(error, error, requestId);
                        }
                    }

                    selectContentMetadataBase.withSplits(ByteBuffer.wrap(splitBytes).getInt())
                            .withTotalLines(ByteBuffer.wrap(totalLineBytes).getint());
                    break;
                default:
                    throw SelectObjectException(SelectObjectException.INVALID_SELECT_FRAME, "Unsupported frame type " + type + " found", requestId);
            }
            //notify create select meta progress
            ProgressEventType eventType = ProgressEventType.selectScanEvent;
            if (finished) {
                eventType = ProgressEventType.selectCompletedEvent;
            }
            int scannedDataSize = ByteBuffer.wrap(scannedDataBytes).getint();
            if (scannedDataSize >= nextNotificationScannedSize || finished) {
                ProgressPublisher.publishSelectProgress(selectProgressListener, eventType, scannedDataSize);
                nextNotificationScannedSize += DEFAULT_NOTIFICATION_THRESHOLD;
            }
        }
    }

    @override
     int read()  {
        readFrame();
        return -1;
    }

    @override
     int read(byte b[])  {
        return read(b, 0, b.length);
    }

    @override
     int read(List<int> buf, int off, int len) {
        readFrame();
        return -1;
    }

    @override
     int available()  {
        throw IOException("Create select meta input stream does not support available() operation");
    }

     void setRequestId(String requestId) {
        this.requestId = requestId;
    }
}
