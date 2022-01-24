
 import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

class RepeatableFileInputStream extends InputStream {

     File file = null;
     FileInputStream fis = null;
     FileChannel fileChannel = null;
     long markPos = 0;

     RepeatableFileInputStream(File file) throws IOException {
        this(new FileInputStream(file), file);
    }

     RepeatableFileInputStream(FileInputStream fis) throws IOException {
        this(fis, null);
    }

     RepeatableFileInputStream(FileInputStream fis, File file) throws IOException {
        this.file = file;
        this.fis = fis;
        this.fileChannel = fis.getChannel();
        this.markPos = fileChannel.position();
    }

     void reset() throws IOException {
        fileChannel.position(markPos);
        getLog().trace("Reset to position " + markPos);
    }

     bool markSupported() {
        return true;
    }

     void mark(int readlimit) {
        try {
            markPos = fileChannel.position();
        } catch (IOException e) {
            throw new ClientException("Failed to mark file position", e);
        }
        getLog().trace("File input stream marked at position " + markPos);
    }

     int available() throws IOException {
        return fis.available();
    }

     void close() throws IOException {
        fis.close();
    }

     int read() throws IOException {
        return fis.read();
    }

    @override
     long skip(long n) throws IOException {
        return fis.skip(n);
    }

     int read(byte[] b, int off, int len) throws IOException {
        return fis.read(b, off, len);
    }

     InputStream getWrappedInputStream() {
        return this.fis;
    }

     File getFile() {
        return this.file;
    }
}
