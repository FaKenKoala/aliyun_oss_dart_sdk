package com.alibaba.sdk.android.oss.model;

import java.util.ArrayList;
import java.util.List;

 class GetBucketRefererResult extends OSSResult {
     String mAllowEmpty;
     ArrayList<String> mReferers;

     String getAllowEmpty() {
        return mAllowEmpty;
    }

     void setAllowEmpty(String allowEmpty) {
        this.mAllowEmpty = allowEmpty;
    }

     ArrayList<String> getReferers() {
        return mReferers;
    }

     void setReferers(ArrayList<String> referers) {
        this.mReferers = referers;
    }

     void addReferer(String object) {
        if (mReferers == null) {
            mReferers = new ArrayList<String>();
        }
        mReferers.add(object);
    }
}
