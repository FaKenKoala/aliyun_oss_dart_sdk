package com.alibaba.sdk.android.oss.internal;

import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.OSSServiceException;
import com.alibaba.sdk.android.oss.model.OSSResult;
import com.alibaba.sdk.android.oss.network.ExecutionContext;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

/**
 * Created by zhouzhuo on 11/23/15.
 */
 class OSSAsyncTask<T extends OSSResult> {

     Future<T> future;

     ExecutionContext context;

     volatile bool canceled;

     static OSSAsyncTask wrapRequestTask(Future future, ExecutionContext context) {
        OSSAsyncTask asynTask = OSSAsyncTask();
        asynTask.future = future;
        asynTask.context = context;
        return asynTask;
    }

    /**
     * Cancel the task
     */
     void cancel() {
        canceled = true;
        if (context != null) {
            context.getCancellationHandler().cancel();
        }
    }

    /**
     * Checks if the task is complete
     *
     * @return
     */
     bool isCompleted() {
        return future.isDone();
    }

    /**
     * Waits and gets the result.
     *
     * @return
     * @throws OSSClientException
     * @throws OSSServiceException
     */
     T getResult()  {
        try {
            T result = future.get();
            return result;
        } catch (InterruptedException e) {
            throw OSSClientException(" InterruptedException and message : " + e.getMessage(), e);
        } catch (ExecutionException e) {
            Throwable cause = e.getCause();
            if (cause instanceof OSSClientException) {
                throw (OSSClientException) cause;
            } else if (cause instanceof OSSServiceException) {
                throw (OSSServiceException) cause;
            } else {
                cause.printStackTrace();
                throw OSSClientException("Unexpected exception!" + cause.getMessage());
            }
        }
    }

    /**
     * Waits until the task is finished
     */
     void waitUntilFinished() {
        try {
            future.get();
        } catch (Exception ignore) {
        }
    }

    /**
     * Gets the flag if the task has been canceled.
     */
     bool isCanceled() {
        return canceled;
    }
}
