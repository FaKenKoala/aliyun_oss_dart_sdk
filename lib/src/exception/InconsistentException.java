package com.alibaba.sdk.android.oss.exception;

import java.io.IOException;

/**
 * Created by jingdan on 2017/11/29.
 */

 class InconsistentException extends IOException {

     int clientChecksum;
     int serverChecksum;
     String requestId;

     InconsistentException(int clientChecksum, int serverChecksum, String requestId) {
        super();
        this.clientChecksum = clientChecksum;
        this.serverChecksum = serverChecksum;
        this.requestId = requestId;
    }

    @override
     String getMessage() {
        return "InconsistentException: inconsistent object"
                + "\n[RequestId]: " + requestId
                + "\n[ClientChecksum]: " + clientChecksum
                + "\n[ServerChecksum]: " + serverChecksum;
    }
}
