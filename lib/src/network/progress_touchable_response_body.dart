
 class ProgressTouchableResponseBody<T extends OSSRequest> extends ResponseBody {

     final ResponseBody mResponseBody;
     OSSProgressCallback mProgressListener;
     BufferedSource mBufferedSource;
     T request;

     ProgressTouchableResponseBody(ResponseBody responseBody, ExecutionContext context) {
        this.mResponseBody = responseBody;
        this.mProgressListener = context.getProgressCallback();
        this.request = (T) context.getRequest();
    }

    @override
     MediaType contentType() {
        return mResponseBody.contentType();
    }

    @override
     int contentLength() {
        return mResponseBody.contentLength();
    }

    @override
     BufferedSource source() {
        if (mBufferedSource == null) {
            mBufferedSource = Okio.buffer(source(mResponseBody.source()));
        }
        return mBufferedSource;
    }

     Source source(Source source) {
        return ForwardingSource(source) {
             int totalBytesRead = 0L;

            @override
             int read(Buffer sink, int byteCount)  {
                int bytesRead = super.read(sink, byteCount);
                totalBytesRead += bytesRead != -1 ? bytesRead : 0;
                //callback
                if (mProgressListener != null && bytesRead != -1 && totalBytesRead != 0) {
                    mProgressListener.onProgress(request, totalBytesRead, mResponseBody.contentLength());
                }
                return bytesRead;
            }
        };
    }
}
