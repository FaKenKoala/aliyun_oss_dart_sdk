/**
 * Copyright (C) Alibaba Cloud Computing, 2015
 * All rights reserved.
 * <p>
 * 版权所有 （C）阿里巴巴云计算，2015
 */

package com.alibaba.sdk.android.oss.common.utils;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.OSSIOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;

 class IOUtils {

     final static int BUFFER_SIZE = 4 * 1024;

     static String readStreamAsString(InputStream in, String charset)
             {
        if (in == null)
            return "";

        Reader reader = null;
        Writer writer = StringWriter();
        String result;

        char[] buffer = char[BUFFER_SIZE];
        try {
            reader = BufferedReader(
                    InputStreamReader(in, charset));

            int n;
            while ((n = reader.read(buffer)) > 0) {
                writer.write(buffer, 0, n);
            }

            result = writer.toString();
        } finally {
            safeClose(in);
            if (reader != null) {
                reader.close();
            }
            if (writer != null) {
                writer.close();
            }
        }

        return result;
    }

     static List<int> readStreamAsBytesArray(InputStream in)
             {
        if (in == null) {
            return byte[0];
        }

        ByteArrayOutputStream output = ByteArrayOutputStream();
        List<int> buffer = byte[BUFFER_SIZE];
        int len;
        while ((len = in.read(buffer)) > -1) {
            output.write(buffer, 0, len);
        }
        output.flush();
        safeClose(output);
        return output.toByteArray();
    }

     static List<int> readStreamAsBytesArray(InputStream in, int readLength)
             {
        if (in == null) {
            return byte[0];
        }

        ByteArrayOutputStream output = ByteArrayOutputStream();
        List<int> buffer = byte[BUFFER_SIZE];
        int len;
        int readed = 0;
        while (readed < readLength && (len = in.read(buffer, 0, Math.min(2048, (int) (readLength - readed)))) > -1) {
            output.write(buffer, 0, len);
            readed += len;
        }
        output.flush();
        safeClose(output);
        return output.toByteArray();
    }

     static void safeClose(InputStream inputStream) {
        if (inputStream != null) {
            try {
                inputStream.close();
            } catch (OSSIOException e) {
            }
        }
    }

     static void safeClose(OutputStream outputStream) {
        if (outputStream != null) {
            try {
                outputStream.close();
            } catch (OSSIOException e) {
            }
        }
    }
}
