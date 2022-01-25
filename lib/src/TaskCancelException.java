package com.alibaba.sdk.android.oss;

/**
 * Created by huaixu on 2018/2/9.
 */

 class TaskCancelException extends Exception {
    /**
     * Constructor
     */
     TaskCancelException() {
        super();
    }

    /**
     * Constructor with message
     *
     * @param message the error message
     */
     TaskCancelException(String message) {
        super("[ErrorMessage]: " + message);
    }

    /**
     * Constructor with exception
     *
     * @param cause the exception
     */
     TaskCancelException(Throwable cause) {
        super(cause);
    }
}
