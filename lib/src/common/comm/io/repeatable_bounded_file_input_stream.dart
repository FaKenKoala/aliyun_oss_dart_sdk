
 class RepeatableBoundedFileInputStream extends InputStream {

     BoundedInputStream bis = null;
     FileChannel fileChannel = null;
     long markPos = 0;

     RepeatableBoundedFileInputStream(BoundedInputStream bis) throws IOException {
        FileInputStream fin = (FileInputStream) bis.getWrappedInputStream();
        this.bis = bis;
        this.fileChannel = fin.getChannel();
        this.markPos = fileChannel.position();
    }

     void reset() throws IOException {
        bis.backoff(fileChannel.position() - markPos);
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
        return bis.available();
    }

     void close() throws IOException {
        bis.close();
    }

     int read() throws IOException {
        return bis.read();
    }

    @override
     long skip(long n) throws IOException {
        return bis.skip(n);
    }

     int read(byte[] b, int off, int len) throws IOException {
        return bis.read(b, off, len);
    }

     InputStream getWrappedInputStream() {
        return this.bis;
    }

}
