
 import 'dart:typed_data';

import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import '../../../client_exception.dart';

class ChunkedUploadStream extends InputStream {

     static final int DEFAULT_CHUNK_SIZE = 128 * 1024;
     static final String DEFAULT_CHARTSET_NAME = "utf-8";
     static final String CLRF = "\r\n";

     late List<int> inputBuffer;
     late List<int> outputBuffer;
     int outputBufferPos = -1;
     int outputBufferDataLen = -1;

     final int innerStreamBufferSize;
     bool innerStreamConsumed = false;
     bool isTerminatingChunk = false;

     ChunkedUploadStream(InputStream innerStream, this.innerStreamBufferSize):super(innerStream) {

        inputBuffer = List.filled(DEFAULT_CHUNK_SIZE, 0);
        outputBuffer = List.filled(CalculateChunkHeaderLength(DEFAULT_CHUNK_SIZE), 0);
    }

    @override
     int read([Uint8List? buffer, int? off, int? length]) {
       if (buffer == null) {
      List<int> tmp = [0];
        int count = read(Uint8List.fromList(tmp));
        if (count != -1) {
            return tmp[0];
        } else {
            return count;
        }
       }

       int offset = off ?? 0;
       int count = length ?? buffer.length;
         if (offset < 0 || count < 0 || count > buffer.length - offset) {
            throw IndexOutOfBoundsException(
                    "buffer size: ${buffer.length}, offset: $offset, count: $count");
        } else if (count == 0) {
            return 0;
        }

        if (outputBufferPos == -1) {
            if (innerStreamConsumed && isTerminatingChunk) {
                return -1;
            }

            int bytesRead = fillInputBuffer();
            constructOutputBufferChunk(bytesRead);
            isTerminatingChunk = (innerStreamConsumed && bytesRead == 0);
        }

        int outputRemaining = outputBufferDataLen - outputBufferPos;
        int bytesToRead = count;
        if (outputRemaining < count) {
            bytesToRead = outputRemaining;
        }

        System.arraycopy(outputBuffer, outputBufferPos, buffer, 0, bytesToRead);
        outputBufferPos += bytesToRead;
        if (outputBufferPos >= outputBufferDataLen) {
            outputBufferPos = -1;
        }

        return bytesToRead;
    }

     int fillInputBuffer() {
        if (innerStreamConsumed) {
            return 0;
        }

        int inputBufferPos = 0;
        while (inputBufferPos < inputBuffer.length && !innerStreamConsumed) {
            int chunkBufferRemaining = inputBuffer.length - inputBufferPos;
            if (chunkBufferRemaining > innerStreamBufferSize) {
                chunkBufferRemaining = innerStreamBufferSize;
            }

            int bytesRead = 0;
            try {
                bytesRead = inputStream.read(inputBuffer, inputBufferPos, chunkBufferRemaining);
                if (bytesRead == -1) {
                    innerStreamConsumed = true;
                } else {
                    inputBufferPos += bytesRead;
                }
            } catch ( e) {
                throw ClientException("Unexpected IO exception, $e");
            }
        }

        return inputBufferPos;
    }

     void constructOutputBufferChunk(int dataLen) {
        StringBuffer chunkHeader = StringBuffer();
        chunkHeader.write(dataLen.toRadixString(16));
        chunkHeader.write(CLRF);

        try {
            byte[] header = chunkHeader.toString().getBytes(DEFAULT_CHARTSET_NAME);
            byte[] trailer = CLRF.getBytes(DEFAULT_CHARTSET_NAME);

            int writePos = 0;
            System.arraycopy(header, 0, outputBuffer, writePos, header.length);
            writePos += header.length;
            if (dataLen > 0) {
                System.arraycopy(inputBuffer, 0, outputBuffer, writePos, dataLen);
                writePos += dataLen;
            }
            System.arraycopy(trailer, 0, outputBuffer, writePos, trailer.length);

            outputBufferPos = 0;
            outputBufferDataLen = header.length + dataLen + trailer.length;
        } catch (Exception e) {
            throw ClientException("Unable to sign the chunked data, " + e.getMessage(), e);
        }
    }

     static int CalculateChunkHeaderLength(long chunkDataSize) {
        return (int) (Long.toHexString(chunkDataSize).length() + CLRF.length() + chunkDataSize + CLRF.length());
    }
}
