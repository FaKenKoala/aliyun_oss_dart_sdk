package com.alibaba.sdk.android.oss.internal;

import com.alibaba.sdk.android.oss.common.utils.CaseInsensitiveHashMap;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by jingdan on 2017/11/27.
 */

abstract class HttpMessage {
     Map<String, String> headers = new CaseInsensitiveHashMap<String, String>();
     InputStream content;
     int contentLength;
     String stringBody;

     Map<String, String> getHeaders() {
        return headers;
    }

     void setHeaders(Map<String, String> headers) {
        if (this.headers == null) {
            this.headers = new CaseInsensitiveHashMap<String, String>();
        }
        if (this.headers != null && this.headers.size() > 0) {
            this.headers.clear();
        }

        this.headers.putAll(headers);
    }

     void addHeader(String key, String value) {
        this.headers.put(key, value);
    }

     InputStream getContent() {
        return content;
    }

     void setContent(InputStream content) {
        this.content = content;
    }

     String getStringBody() {
        return stringBody;
    }

     void setStringBody(String stringBody) {
        this.stringBody = stringBody;
    }

     int getContentLength() {
        return contentLength;
    }

     void setContentLength(int contentLength) {
        this.contentLength = contentLength;
    }

     void close() throws IOException {
        if (content != null) {
            content.close();
            content = null;
        }
    }
}
