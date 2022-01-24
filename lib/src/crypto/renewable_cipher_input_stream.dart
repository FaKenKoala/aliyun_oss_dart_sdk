
import 'cipher_input_stream.dart';

/// A specific kind of {@link CipherInputStream} that supports partial
/// mark-and-reset in the sense that, if the underlying input stream supports
/// mark-and-reset, this input stream can then be marked at and get reset back to
/// the very beginning of the stream (but not anywhere else).
  class RenewableCipherInputStream extends CipherInputStream {
     bool hasBeenAccessed;

     RenewableCipherInputStream(InputStream is, CryptoCipher cryptoCipher) {
        super(is, cryptoCipher);
    }

     RenewableCipherInputStream(InputStream is, CryptoCipher c, int buffsize) {
        super(is, c, buffsize);
    }

    /// Mark and reset is currently only partially supported, in the sense that, if
    /// the underlying input stream supports mark-and-reset, this input stream can
    /// then be marked at and get reset back to the very beginning of the stream (but
    /// not anywhere else).
    @override
     bool markSupported() {
        abortIfNeeded();
        return in.markSupported();
    }

    /// Mark and reset is currently only partially supported, in the sense that, if
    /// the underlying input stream supports mark-and-reset, this input stream can
    /// then be marked at and get reset back to the very beginning of the stream (but
    /// not anywhere else).
    /// 
    /// @throws UnsupportedOperationException
    ///             if mark is called after this stream has been accessed.
    @override
     void mark(final int readlimit) {
        abortIfNeeded();
        if (hasBeenAccessed) {
            throw new UnsupportedOperationException(
                    "Marking is only supported before your first call to " + "read or skip.");
        }
        in.mark(readlimit);
    }

    /// Resets back to the very beginning of the stream.
    /// <p>
    /// Mark and reset is currently only partially supported, in the sense that, if
    /// the underlying input stream supports mark-and-reset, this input stream can
    /// then be marked at and get reset back to the very beginning of the stream (but
    /// not anywhere else).
    @override
     void reset() throws IOException {
        abortIfNeeded();
        in.reset();
        renewCryptoCipher();
        resetInternal();
        hasBeenAccessed = false;
    }

    @override
     int read() throws IOException {
        hasBeenAccessed = true;
        return super.read();
    }

    @override
     int read(final byte[] b) throws IOException {
        hasBeenAccessed = true;
        return super.read(b);
    }

    @override
     int read(final byte[] b, final int off, final int len) throws IOException {
        hasBeenAccessed = true;
        return super.read(b, off, len);
    }

    @override
     long skip(final long n) throws IOException {
        hasBeenAccessed = true;
        return super.skip(n);
    }
}
