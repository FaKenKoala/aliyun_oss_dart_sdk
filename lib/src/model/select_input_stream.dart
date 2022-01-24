
 import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_listener.dart';

class SelectInputStream extends FilterInputStream {
    /// Format of data frame
    /// |--frame type(4 bytes)--|--payload length(4 bytes)--|--header checksum(4 bytes)--|
    /// |--scanned data bytes(8 bytes)--|--payload--|--payload checksum(4 bytes)--|
     static final int DATA_FRAME_MAGIC = 8388609;

    /// Format of continuous frame
    /// |--frame type(4 bytes)--|--payload length(4 bytes)--|--header checksum(4 bytes)--|
    /// |--scanned data bytes(8 bytes)--|--payload checksum(4 bytes)--|
     static final int CONTINUOUS_FRAME_MAGIC = 8388612;

    /// Format of end frame
    /// |--frame type(4 bytes)--|--payload length(4 bytes)--|--header checksum(4 bytes)--|
    /// |--scanned data bytes(8 bytes)--|--total scan size(8 bytes)--|
    /// |--status code(4 bytes)--|--error message--|--payload checksum(4 bytes)--|
     static final int END_FRAME_MAGIC = 8388613;
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
     bool payloadCrcEnabled;
     CRC32 crc32;
     String requestId;
    /// payload checksum is the last 4 bytes in one frame, we use this flag to indicate whether we
    /// need read the 4 bytes before we advance to next frame.
     bool firstReadFrame;

     SelectInputStream(InputStream in, ProgressListener selectProgressListener, bool payloadCrcEnabled) {
        super(in);
        currentFrameOffset = 0;
        currentFramePayloadLength = 0;
        currentFrameTypeBytes = byte[4];
        currentFramePayloadLengthBytes = byte[4];
        currentFrameHeaderChecksumBytes = byte[4];
        scannedDataBytes = byte[8];
        currentFramePayloadChecksumBytes = byte[4];
        finished = false;
        firstReadFrame = true;
        this.selectProgressListener = selectProgressListener;
        this.nextNotificationScannedSize = DEFAULT_NOTIFICATION_THRESHOLD;
        this.payloadCrcEnabled = payloadCrcEnabled;
        if (this.payloadCrcEnabled) {
            this.crc32 = CRC32();
            this.crc32.reset();
        }
    }

     void internalRead(List<int> buf, int off, int len) throws IOException {
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
        if (payloadCrcEnabled) {
            int currentChecksum = ByteBuffer.wrap(checksumBytes).getInt();
            if (crc32.getValue() != ((int)currentChecksum & 0xffffffffL)) {
                throw SelectObjectException(SelectObjectException.INVALID_CRC, "Frame crc check failed, actual " + crc32.getValue() + ", expect: " + currentChecksum, requestId);
            }
            crc32.reset();
        }
    }

     void readFrame() throws IOException {
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
            if (payloadCrcEnabled) {
                crc32.update(scannedDataBytes);
            }

            currentFrameTypeBytes[0] = 0;
            int type = ByteBuffer.wrap(currentFrameTypeBytes).getInt();
            switch (type) {
                case DATA_FRAME_MAGIC:
                    currentFramePayloadLength = ByteBuffer.wrap(currentFramePayloadLengthBytes).getInt() - 8;
                    currentFrameOffset = 0;
                    break;
                case CONTINUOUS_FRAME_MAGIC:
                    //just break, continue
                    break;
                case END_FRAME_MAGIC:
                    currentFramePayloadLength = ByteBuffer.wrap(currentFramePayloadLengthBytes).getInt() - 8;
                    List<int> totalScannedDataSizeBytes = byte[8];
                    internalRead(totalScannedDataSizeBytes, 0, 8);
                    List<int> statusBytes = byte[4];
                    internalRead(statusBytes, 0, 4);
                    if (payloadCrcEnabled) {
                        crc32.update(totalScannedDataSizeBytes);
                        crc32.update(statusBytes);
                    }
                    int status = ByteBuffer.wrap(statusBytes).getInt();
                    int errorMessageSize = (int)(currentFramePayloadLength - 12);
                    String error = "";
                    if (errorMessageSize > 0) {
                        List<int> errorMessageBytes = byte[errorMessageSize];
                        internalRead(errorMessageBytes, 0, errorMessageSize);
                        error = String(errorMessageBytes);
                        if (payloadCrcEnabled) {
                            crc32.update(errorMessageBytes);
                        }
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
                    break;
                default:
                    throw SelectObjectException(SelectObjectException.INVALID_SELECT_FRAME, "Unsupported frame type " + type + " found", requestId);
            }
            //notify select progress
            ProgressEventType eventType = ProgressEventType.SELECT_SCAN_EVENT;
            if (finished) {
                eventType = ProgressEventType.SELECT_COMPLETED_EVENT;
            }
            int scannedDataSize = ByteBuffer.wrap(scannedDataBytes).getint();
            if (scannedDataSize >= nextNotificationScannedSize || finished) {
                publishSelectProgress(selectProgressListener, eventType, scannedDataSize);
                nextNotificationScannedSize += DEFAULT_NOTIFICATION_THRESHOLD;
            }
        }
    }

    @override
     int read() throws IOException {
        readFrame();
        int byteRead = in.read();
        if (byteRead >= 0) {
            currentFrameOffset++;
            if (payloadCrcEnabled) {
                crc32.update(byteRead);
            }
        }
        return byteRead;
    }

    @override
     int read(byte b[]) throws IOException {
        return read(b, 0, b.length);
    }

    @override
     int read(List<int> buf, int off, int len) throws IOException {
        readFrame();
        int bytesToRead = (int)Math.min(len, currentFramePayloadLength - currentFrameOffset);
        if (bytesToRead != 0) {
            int bytes = in.read(buf, off, bytesToRead);
            if (bytes > 0) {
                currentFrameOffset += bytes;
                if (payloadCrcEnabled) {
                    crc32.update(buf, off, bytes);
                }
            }
            return bytes;
        }
        return -1;
    }

    @override
     int available() throws IOException {
        throw IOException("Select object input stream does not support available() operation");
    }

     void setRequestId(String requestId) {
        this.requestId = requestId;
    }
}
