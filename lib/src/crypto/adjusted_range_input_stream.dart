
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import '../client_error_code.dart';

/// Reads only a specific range of bytes from the underlying input stream.
 class AdjustedRangeInputStream extends InputStream {
     InputStream decryptedContents;
     int virtualAvailable;
     bool closed;

    /// Creates a new DecryptedContentsInputStream object.
    ///
    /// @param objectContents
    ///      The input stream containing the object contents retrieved from OSS
    /// @param rangeBeginning
    ///      The position of the left-most byte desired by the user
    /// @param rangeEnd
    ///      The position of the right-most byte desired by the user
    /// @throws IOException
    ///      If there are errors skipping to the left-most byte desired by the user.
     AdjustedRangeInputStream(InputStream objectContents, int rangeBeginning, int rangeEnd) throws IOException {
        this.decryptedContents = objectContents;
        this.closed = false;
        initializeForRead(rangeBeginning, rangeEnd);
    }

    /// Aborts the inputstream operation if thread is interrupted.
    /// interrupted status of the thread is cleared by this method.
    ///
    /// @throws ClientException with ClientErrorCode INPUTSTREAM_READING_ABORTED if thread aborted.
      void abortIfNeeded() {
        if (shouldAbort()) {
            abort();
            throw ClientException("Thread aborted, inputStream aborted...",
                                      ClientErrorCode.INPUTSTREAM_READING_ABORTED, null);
        }
    }

     void abort() {
    }

    /// Skip to the start location of the range of bytes desired by the user.
     void initializeForRead(int rangeBeginning, int rangeEnd) throws IOException {
        int numBytesToSkip;
        if (rangeBeginning < CryptoScheme.BLOCK_SIZE) {
            numBytesToSkip = (int) rangeBeginning;
        } else {
            int offsetIntoBlock = (int) (rangeBeginning % CryptoScheme.BLOCK_SIZE);
            numBytesToSkip = offsetIntoBlock;
        }
        if (numBytesToSkip != 0) {
            while (numBytesToSkip > 0) {
                this.decryptedContents.read();
                numBytesToSkip--;
            }
        }
        this.virtualAvailable = (rangeEnd - rangeBeginning) + 1;
    }

    @override
     int read() throws IOException {
        abortIfNeeded();
        int result;

        if (this.virtualAvailable <= 0) {
            result = -1;
        } else {
            result = this.decryptedContents.read();
        }

        if (result != -1) {
            this.virtualAvailable--;
        } else {
            this.virtualAvailable = 0;
            close();
        }

        return result;
    }

    @override
     int read(byte[] buffer, int offset, int length) throws IOException {
        abortIfNeeded();
        int numBytesRead;
        if (this.virtualAvailable <= 0) {
            numBytesRead = -1;
        } else {
            if (length > this.virtualAvailable) {
                length = (this.virtualAvailable < Integer.MAX_VALUE) ? (int) this.virtualAvailable : Integer.MAX_VALUE;
            }
            numBytesRead = this.decryptedContents.read(buffer, offset, length);
        }

        if (numBytesRead != -1) {
            this.virtualAvailable -= numBytesRead;
        } else {
            this.virtualAvailable = 0;
            close();
        }
        return numBytesRead;
    }

    @override
     int available() throws IOException {
        abortIfNeeded();
        int available = this.decryptedContents.available();
        if (available < this.virtualAvailable) {
            return available;
        } else {
            return (int) this.virtualAvailable;
        }
    }

    @override
     void close() throws IOException {
        if (!this.closed) {
            this.closed = true;
            if (this.virtualAvailable == 0) {
                drainInputStream(decryptedContents);
            }
            this.decryptedContents.close();
        }
        abortIfNeeded();
    }

     static void drainInputStream(InputStream in) {
        try {
            while (in.read() != -1) {
            }
        } catch (IOException ignored) {
        }
    }

     InputStream getWrappedInputStream() {
        return decryptedContents;
    }
}
