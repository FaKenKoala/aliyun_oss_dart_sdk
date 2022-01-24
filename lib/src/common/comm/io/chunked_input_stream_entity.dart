 class ChunkedInputStreamEntity extends BasicHttpEntity {

     bool firstAttempt = true;
     ReleasableInputStreamEntity notClosableRequestEntity;
     InputStream content;

     ChunkedInputStreamEntity(ServiceClient.Request request) {
        setChunked(true);

        long contentLength = -1;
        try {
            String contentLengthString = request.getHeaders().get(HttpHeaders.CONTENT_LENGTH);
            if (contentLengthString != null) {
                contentLength = Long.parseLong(contentLengthString);
            }
        } catch (NumberFormatException nfe) {
            logException("Unable to parse content length from request.", nfe);
        }

        String contentType = request.getHeaders().get(HttpHeaders.CONTENT_TYPE);

        notClosableRequestEntity = new ReleasableInputStreamEntity(request.getContent(), contentLength);
        notClosableRequestEntity.setCloseDisabled(true);
        notClosableRequestEntity.setContentType(contentType);
        content = request.getContent();

        setContent(content);
        setContentType(contentType);
        setContentLength(contentLength);
    }

    @override
     bool isChunked() {
        return true;
    }

    @override
     bool isRepeatable() {
        return content.markSupported() || notClosableRequestEntity.isRepeatable();
    }

    @override
     void writeTo(OutputStream output) throws IOException {
        if (!firstAttempt && isRepeatable())
            content.reset();

        firstAttempt = false;
        notClosableRequestEntity.writeTo(output);
    }

    /**
     * A releaseable HTTP entity that can control its inner inputstream's
     * auto-close functionality on/off, and it will try to close its inner
     * inputstream by default when the inputstream reaches EOF.
     */
     static class ReleasableInputStreamEntity extends AbstractHttpEntity implements Releasable {

         final InputStream content;
         final long length;

         bool closeDisabled;

         ReleasableInputStreamEntity(final InputStream instream) {
            this(instream, -1);
        }

         ReleasableInputStreamEntity(final InputStream instream, final long length) {
            this(instream, length, null);
        }

         ReleasableInputStreamEntity(final InputStream instream, final ContentType contentType) {
            this(instream, -1, contentType);
        }

         ReleasableInputStreamEntity(final InputStream instream, final long length,
                final ContentType contentType) {
            super();
            this.content = Args.notNull(instream, "Source input stream");
            this.length = length;
            if (contentType != null) {
                setContentType(contentType.toString());
            }
            closeDisabled = false;
        }

        @override
         bool isRepeatable() {
            return this.content.markSupported();
        }

        @override
         long getContentLength() {
            return this.length;
        }

        @override
         InputStream getContent() throws IOException {
            return this.content;
        }

        @override
         void writeTo(final OutputStream outstream) throws IOException {
            Args.notNull(outstream, "Output stream");
            final InputStream instream = this.content;
            try {
                final byte[] buffer = new byte[OUTPUT_BUFFER_SIZE];
                int l;
                if (this.length < 0) {
                    // consume until EOF
                    while ((l = instream.read(buffer)) != -1) {
                        outstream.write(buffer, 0, l);
                    }
                } else {
                    // consume no more than length
                    long remaining = this.length;
                    while (remaining > 0) {
                        l = instream.read(buffer, 0, (int) Math.min(OUTPUT_BUFFER_SIZE, remaining));
                        if (l == -1) {
                            break;
                        }
                        outstream.write(buffer, 0, l);
                        remaining -= l;
                    }
                }
            } finally {
                close();
            }
        }

        @override
         bool isStreaming() {
            return true;
        }

         void close() {
            if (!closeDisabled)
                doRelease();
        }

        @override
         void release() {
            doRelease();
        }

         void doRelease() {
            try {
                this.content.close();
            } catch (Exception ex) {
                logException("Unexpected io exception when trying to close input stream", ex);
            }
        }

         bool isCloseDisabled() {
            return closeDisabled;
        }

         void setCloseDisabled(bool closeDisabled) {
            this.closeDisabled = closeDisabled;
        }
    }
}
