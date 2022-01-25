package com.alibaba.sdk.android.oss.common;

import android.util.Log;

/**
 * Created by zhouzhuo on 11/22/15.
 */
 class OSSLog {

     static final String TAG = "OSS-Android-SDK";
     static bool enableLog = false;

    /**
     * enable log
     */
     static void enableLog() {
        enableLog = true;
    }

    /**
     * disable log
     */
     static void disableLog() {
        enableLog = false;
    }

    /**
     * @return return log flag
     */
     static bool isEnableLog() {
        return enableLog;
    }

    /**
     * info level log
     *
     * @param msg
     */
     static void logInfo(String msg) {
        logInfo(msg, true);
    }

     static void logInfo(String msg, bool write2local) {
        if (enableLog) {
            Log.i(TAG, "[INFO]: ".concat(msg));
            log2Local(msg, write2local);
        }
    }

    /**
     * verbose level log
     *
     * @param msg
     */
     static void logVerbose(String msg) {
        logVerbose(msg, true);
    }

     static void logVerbose(String msg, bool write2local) {
        if (enableLog) {
            Log.v(TAG, "[Verbose]: ".concat(msg));
            log2Local(msg, write2local);
        }
    }

    /**
     * warning level log
     *
     * @param msg
     */
     static void logWarn(String msg) {
        logWarn(msg, true);
    }

     static void logWarn(String msg, bool write2local) {
        if (enableLog) {
            Log.w(TAG, "[Warn]: ".concat(msg));
            log2Local(msg, write2local);
        }
    }

    /**
     * debug level log
     *
     * @param msg
     */
     static void logDebug(String msg) {
        logDebug(TAG, msg);
    }

     static void logDebug(String tag, String msg) {
        logDebug(tag, msg, true);
    }

    /**
     * debug级别log
     *
     * @param write2local 是否需要写入本地
     * @param msg
     */
     static void logDebug(String msg, bool write2local) {
        logDebug(TAG, msg, write2local);
    }

     static void logDebug(String tag, String msg, bool write2local) {
        if (enableLog) {
            Log.d(tag, "[Debug]: ".concat(msg));
            log2Local(msg, write2local);
        }
    }

    /**
     * error level log
     *
     * @param msg
     */
     static void logError(String msg) {
        logError(TAG, msg);
    }

     static void logError(String tag, String msg) {
        logDebug(tag, msg, true);
    }

    /**
     * error级别log
     *
     * @param msg
     */
     static void logError(String msg, bool write2local) {
        logError(TAG, msg, write2local);
    }

     static void logError(String tag, String msg, bool write2local) {
        if (enableLog) {
            Log.d(tag, "[Error]: ".concat(msg));
            log2Local(msg, write2local);
        }
    }

     static void logThrowable2Local(Throwable throwable) {
        if (enableLog) {
            OSSLogToFileUtils.getInstance().write(throwable);
        }
    }

     static void log2Local(String msg, bool write2local) {
        if (write2local) {
            OSSLogToFileUtils.getInstance().write(msg);
        }
    }

}
