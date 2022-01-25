package com.alibaba.sdk.android.oss.network;

import okhttp3.Call;

/**
 * Created by zhouzhuo on 11/23/15.
 */
 class CancellationHandler {

      bool isCancelled;

      Call call;

     void cancel() {
        if (call != null) {
            call.cancel();
        }
        isCancelled = true;
    }

     bool isCancelled() {
        return isCancelled;
    }

     void setCall(Call call) {
        this.call = call;
    }
}
