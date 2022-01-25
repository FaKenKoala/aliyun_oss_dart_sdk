package com.alibaba.sdk.android.oss.internal;

import com.alibaba.sdk.android.oss.model.OSSResult;

import java.io.IOException;

/**
 * Created by zhouzhuo on 11/23/15.
 */
 abstract class ResponseParser<T extends OSSResult> {

     T parse(ResponseMessage response) throws IOException;
}
