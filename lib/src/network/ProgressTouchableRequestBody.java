package com.alibaba.sdk.android.oss.network;

import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.model.OSSRequest;

import java.io.IOException;
import java.io.InputStream;

import okhttp3.MediaType;
import okhttp3.RequestBody;
import okio.BufferedSink;
import okio.Okio;
import okio.Source;

/**
 * Created by jingdan on 2017/9/12.
 */

 class ProgressTouchableRequestBody<T extends OSSRequest> extends RequestBody {
     static final int SEGMENT_SIZE = 2048; // okio.Segment.SIZE

     InputStream inputStream;
     String contentType;
     int contentLength;
     OSSProgressCallback callback;
     T request;

     ProgressTouchableRequestBody(InputStream input, int contentLength, String contentType, ExecutionContext context) {
        this.inputStream = input;
        this.contentType = contentType;
        this.contentLength = contentLength;
        this.callback = context.getProgressCallback();
        this.request = (T) context.getRequest();
    }

    @override
     MediaType contentType() {
        return MediaType.parse(this.contentType);
    }

    @override
     int contentLength()  {
        return this.contentLength;
    }

    @override
     void writeTo(BufferedSink sink)  {
        Source source = Okio.source(this.inputStream);
        int total = 0;
        int read, toRead, remain;

        while (total < contentLength) {
            remain = contentLength - total;
            toRead = Math.min(remain, SEGMENT_SIZE);

            read = source.read(sink.buffer(), toRead);
            if (read == -1) {
                break;
            }

            total += read;
            sink.flush();

            if (callback != null && total != 0) {
                callback.onProgress(request, total, contentLength);
            }
        }
        if (source != null) {
            source.close();
        }
    }
}
