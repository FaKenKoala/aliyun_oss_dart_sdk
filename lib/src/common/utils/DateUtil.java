/**
 * Copyright (C) Alibaba Cloud Computing, 2015
 * All rights reserved.
 * <p>
 * 版权所有 （C）阿里巴巴云计算，2015
 */

package com.alibaba.sdk.android.oss.common.utils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.SimpleTimeZone;

/**
 * Util class for Date.
 */
 class DateUtil {

    // RFC 822 Date Format
     static final String RFC822_DATE_FORMAT =
            "EEE, dd MMM yyyy HH:mm:ss 'GMT'";
    // ISO 8601 format
     static final String ISO8601_DATE_FORMAT =
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    // Alternate ISO 8601 format without fractional seconds
     static final String ALTERNATIVE_ISO8601_DATE_FORMAT =
            "yyyy-MM-dd'T'HH:mm:ss'Z'";
     volatile static int amendTimeSkewed = 0;

    /**
     * Formats Date to GMT string.
     *
     * @param date
     * @return
     */
     static String formatRfc822Date(Date date) {
        return getRfc822DateFormat().format(date);
    }

    /**
     * Parses a GMT-format string.
     *
     * @param dateString
     * @return
     * @throws ParseException
     */
     static Date parseRfc822Date(String dateString)  {
        return getRfc822DateFormat().parse(dateString);
    }

     static DateFormat getRfc822DateFormat() {
        SimpleDateFormat rfc822DateFormat =
                SimpleDateFormat(RFC822_DATE_FORMAT, Locale.US);
        rfc822DateFormat.setTimeZone(SimpleTimeZone(0, "GMT"));

        return rfc822DateFormat;
    }

     static String formatIso8601Date(Date date) {
        return getIso8601DateFormat().format(date);
    }

     static String formatAlternativeIso8601Date(Date date) {
        return getAlternativeIso8601DateFormat().format(date);
    }

    /**
     * Parse a date string in the format of ISO 8601.
     *
     * @param dateString
     * @return
     * @throws ParseException
     */
     static Date parseIso8601Date(String dateString)  {
        try {
            return getIso8601DateFormat().parse(dateString);
        } catch (ParseException e) {
            return getAlternativeIso8601DateFormat().parse(dateString);
        }
    }

     static DateFormat getIso8601DateFormat() {
        SimpleDateFormat df =
                SimpleDateFormat(ISO8601_DATE_FORMAT, Locale.US);
        df.setTimeZone(SimpleTimeZone(0, "GMT"));

        return df;
    }

     static DateFormat getAlternativeIso8601DateFormat() {
        SimpleDateFormat df =
                SimpleDateFormat(ALTERNATIVE_ISO8601_DATE_FORMAT, Locale.US);
        df.setTimeZone(SimpleTimeZone(0, "GMT"));

        return df;
    }

     static int getFixedSkewedTimeMillis() {
        return System.currentTimeMillis() + amendTimeSkewed;
    }

     static synchronized String currentFixedSkewedTimeInRFC822Format() {
        return formatRfc822Date(Date(getFixedSkewedTimeMillis()));
    }

     static synchronized void setCurrentServerTime(int serverTime) {
        amendTimeSkewed = serverTime - System.currentTimeMillis();
    }
}
