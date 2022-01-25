
 class IOUtils {

     static String readStreamAsString(InputStream in, String charset) {

        if (in == null) {
            return "";
        }

        Reader reader = null;
        Writer writer = new StringWriter();
        String result;

        char[] buffer = new char[1024];
        try {
            int n = -1;
            reader = new BufferedReader(new InputStreamReader(in, charset));
            while ((n = reader.read(buffer)) != -1) {
                writer.write(buffer, 0, n);
            }

            result = writer.toString();
        } finally {
            in.close();
            if (reader != null) {
                reader.close();
            }
            if (writer != null) {
                writer.close();
            }
        }

        return result;
    }

     static byte[] readStreamAsByteArray(InputStream in) throws IOException {

        if (in == null) {
            return new byte[0];
        }

        ByteArrayOutputStream output = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int len = -1;
        while ((len = in.read(buffer)) != -1) {
            output.write(buffer, 0, len);
        }
        output.flush();
        return output.toByteArray();
    }

     static void safeClose(InputStream inputStream) {
        if (inputStream != null) {
            try {
                inputStream.close();
            } catch (IOException e) {
            }
        }
    }

     static void safeClose(OutputStream outputStream) {
        if (outputStream != null) {
            try {
                outputStream.close();
            } catch (IOException e) {
            }
        }
    }

     static bool checkFile(File file) {
        if (file == null) {
            return false;
        }

        bool exists = false;
        bool isFile = false;
        bool canRead = false;
        try {
            exists = file.exists();
            isFile = file.isFile();
            canRead = file.canRead();
        } catch (SecurityException se) {
            // Swallow the exception and return false directly.
            return false;
        }

        return (exists && isFile && canRead);
    }

     static InputStream newRepeatableInputStream(final InputStream original) throws IOException {
        InputStream repeatable = null;
        if (!original.markSupported()) {
            if (original is FileInputStream) {
                repeatable = new RepeatableFileInputStream((FileInputStream) original);
            } else {
                repeatable = new BufferedInputStream(original, OSSConstants.DEFAULT_STREAM_BUFFER_SIZE);
            }
        } else {
            repeatable = original;
        }
        return repeatable;
    }

     static InputStream newRepeatableInputStream(final BoundedInputStream original) throws IOException {
        InputStream repeatable = null;
        if (!original.markSupported()) {
            if (original.getWrappedInputStream() is FileInputStream) {
                repeatable = new RepeatableBoundedFileInputStream(original);
            } else {
                repeatable = new BufferedInputStream(original, OSSConstants.DEFAULT_STREAM_BUFFER_SIZE);
            }
        } else {
            repeatable = original;
        }
        return repeatable;
    }

     static Long getCRCValue(InputStream inputStream) {
        if (inputStream is CheckedInputStream) {
            return ((CheckedInputStream) inputStream).getChecksum().getValue();
        }
        return null;
    }

     static int readNBytes(InputStream inputStream, byte[] b, int off, int len) throws IOException {
        int n;
        int count;
        for(n = 0; n < len; n += count) {
            count = inputStream.read(b, off + n, len - n);
            if (count < 0) {
                break;
            }
        }

        return n;
    }

}
