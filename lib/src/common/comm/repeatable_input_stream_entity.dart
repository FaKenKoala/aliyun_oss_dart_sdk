
 class RepeatableInputStreamEntity extends BasicHttpEntity {

     bool firstAttempt = true;

     NoAutoClosedInputStreamEntity innerEntity;

     InputStream content;

     RepeatableInputStreamEntity(ServiceClient.Request request) {
        setChunked(false);

        String contentType = request.getHeaders().GET(HttpHeaders.CONTENT_TYPE);
        content = request.getContent();
        long contentLength = request.getContentLength();

        innerEntity = new NoAutoClosedInputStreamEntity(content, contentLength);
        innerEntity.setContentType(contentType);

        setContent(content);
        setContentType(contentType);
        setContentLength(request.getContentLength());
    }

    @override
     bool isChunked() {
        return false;
    }

    @override
     bool isRepeatable() {
        return content.markSupported() || innerEntity.isRepeatable();
    }

    @override
     void writeTo(OutputStream output) {
        if (!firstAttempt && isRepeatable()) {
            content.reset();
        }

        firstAttempt = false;
        innerEntity.writeTo(output);
    }
 }

    /// The default entity org.apache.http.entity.InputStreamEntity will close
    /// input stream after wirteTo was called. To avoid this, we custom a entity
    /// that will not close stream automatically.
    /// 
    /// @author chao.wangchaowc
      class NoAutoClosedInputStreamEntity extends AbstractHttpEntity {
         final static int BUFFER_SIZE = 2048;

         final InputStream content;
         final long length;

         NoAutoClosedInputStreamEntity(final InputStream instream, long length) {
            super();
            if (instream == null) {
                throw ArgumentError("Source input stream may not be null");
            }
            this.content = instream;
            this.length = length;
        }

         bool isRepeatable() {
            return false;
        }

         long getContentLength() {
            return this.length;
        }

         InputStream getContent() throws IOException {
            return this.content;
        }

         void writeTo(final OutputStream outstream) throws IOException {
            if (outstream == null) {
                throw ArgumentError("Output stream may not be null");
            }
            InputStream instream = this.content;

            byte[] buffer = new byte[BUFFER_SIZE];
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
                    l = instream.read(buffer, 0, (int) Math.min(BUFFER_SIZE, remaining));
                    if (l == -1) {
                        break;
                    }
                    outstream.write(buffer, 0, l);
                    remaining -= l;
                }
            }

        }

         bool isStreaming() {
            return true;
        }
    }

