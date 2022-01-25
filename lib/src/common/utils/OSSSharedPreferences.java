package com.alibaba.sdk.android.oss.common.utils;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * Created by jingdan on 2017/12/6.
 */

 class OSSSharedPreferences {

     static OSSSharedPreferences sInstance;
     SharedPreferences mSp;

     OSSSharedPreferences(Context context) {
        mSp = context.getSharedPreferences("oss_android_sdk_sp", Context.MODE_);
    }


     static OSSSharedPreferences instance(Context context) {
        if (sInstance == null) {
            synchronized (OSSSharedPreferences.class) {
                if (sInstance == null) {
                    sInstance = OSSSharedPreferences(context);
                }
            }
        }
        return sInstance;
    }

     void setStringValue(String key, String value) {
        SharedPreferences.Editor edit = mSp.edit();
        edit.putString(key, value);
        edit.commit();
    }

     String getStringValue(String key) {
        return mSp.getString(key, "");
    }

     void removeKey(String key) {
        SharedPreferences.Editor edit = mSp.edit();
        edit.remove(key);
        edit.commit();
    }

     bool contains(String key) {
        return mSp.contains(key);
    }
}
