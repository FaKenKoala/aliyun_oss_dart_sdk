 import 'dart:io';
import 'dart:math';

import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/log_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'releasable.dart';

class ChunkedInputStreamEntity extends BasicHttpEntity {

     bool firstAttempt = true;
     ReleasableInputStreamEntity notClosableRequestEntity;
     InputStream content;

     ChunkedInputStreamEntity(ServiceClient.Request request) {
        setChunked(true);

        int contentLength = -1;
        try {
            String? contentLengthString = request.getHeaders().get(HttpHeaders.CONTENT_LENGTH);
            if (contentLengthString != null) {
                contentLength = int.parse(contentLengthString);
            }
        } catch ( nfe) {
            LogUtils.logException("Unable to parse content length from request.", nfe);
        }

        String contentType = request.getHeaders().get(HttpHeaders.CONTENT_TYPE);

        notClosableRequestEntity = ReleasableInputStreamEntity(request.getContent(), contentLength);
        notClosableRequestEntity.setCloseDisabled(true);
        notClosableRequestEntity.setContentType(contentType);
        content = request.getContent();

        setContent(content);
        content = content;
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
     void writeTo(OutputStream output) {
        if (!firstAttempt && isRepeatable())
            content.reset();

        firstAttempt = false;
        notClosableRequestEntity.writeTo(output);
    }
}

    /// A releaseable HTTP entity that can control its inner inputstream's
    /// auto-close functionality on/off, and it will try to close its inner
    /// inputstream by default when the inputstream reaches EOF.
      class ReleasableInputStreamEntity extends AbstractHttpEntity implements Releasable {

         final InputStream content;
         final int length;

         bool closeDisabled;

         ReleasableInputStreamEntity(this.content,[this.length = -1, ContentType? contentType]) {
            if (contentType != null) {
                setContentType(contentType.toString());
            }
            closeDisabled = false;
        }

        @override
         bool isRepeatable() {
            return content.markSupported();
        }

        @override
         int getContentLength() {
            return length;
        }

        @override
         InputStream getContent() {
            return content;
        }

        @override
         void writeTo(final OutputStream outstream) {
            Args.notNull(outstream, "Output stream");
            final InputStream instream = content;
            try {
                final byte[] buffer = byte[OUTPUT_BUFFER_SIZE];
                int l;
                if (length < 0) {
                    // consume until EOF
                    while ((l = instream.read(buffer)) != -1) {
                        outstream.write(buffer, 0, l);
                    }
                } else {
                    // consume no more than length
                    int remaining = length;
                    while (remaining > 0) {
                        l = instream.read(buffer, 0, min(OUTPUT_BUFFER_SIZE, remaining));
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
                content.close();
            } catch ( ex) {
                LogUtils.logException("Unexpected io exception when trying to close input stream", ex);
            }
        }

         bool isCloseDisabled() {
            return closeDisabled;
        }

         void setCloseDisabled(bool closeDisabled) {
            this.closeDisabled = closeDisabled;
        }
    }

