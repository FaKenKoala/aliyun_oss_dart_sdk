
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.Locale;
import java.util.SimpleTimeZone;

/**
 * Util class for Date.
 */
class DateUtil {

    // RFC 822 Date Format
    private static final String RFC822_DATE_FORMAT = "EEE, dd MMM yyyy HH:mm:ss 'GMT'";
    // ISO 8601 format
    private static final String ISO8601_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    // Alternate ISO 8601 format without fractional seconds
    private static final String ALTERNATIVE_ISO8601_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss'Z'";
    private volatile static long amendTimeSkewed = 0;

    /**
     * Formats Date to GMT string.
     *
     * @param date
     * @return
     */
    public static String formatRfc822Date(Date date) {
        return getRfc822DateFormat().format(date);
    }

    /**
     * Parses a GMT-format string.
     *
     * @param dateString
     * @return
     * @throws ParseException
     */
    public static Date parseRfc822Date(String dateString) throws ParseException {
        return getRfc822DateFormat().parse(dateString);
    }

    private static DateFormat getRfc822DateFormat() {
        SimpleDateFormat rfc822DateFormat = new SimpleDateFormat(RFC822_DATE_FORMAT, Locale.US);
        rfc822DateFormat.setTimeZone(new SimpleTimeZone(0, "GMT"));

        return rfc822DateFormat;
    }

    public static String formatIso8601Date(Date date) {
        return getIso8601DateFormat().format(date);
    }

    public static String formatAlternativeIso8601Date(Date date) {
        return getAlternativeIso8601DateFormat().format(date);
    }

    /**
     * Parse a date string in the format of ISO 8601.
     *
     * @param dateString
     * @return
     * @throws ParseException
     */
    public static Date parseIso8601Date(String dateString) throws ParseException {
        try {
            return getIso8601DateFormat().parse(dateString);
        } catch (ParseException e) {
            return getAlternativeIso8601DateFormat().parse(dateString);
        }
    }

    private static DateFormat getIso8601DateFormat() {
        SimpleDateFormat df = new SimpleDateFormat(ISO8601_DATE_FORMAT, Locale.US);
        df.setTimeZone(new SimpleTimeZone(0, "GMT"));

        return df;
    }

    private static DateFormat getAlternativeIso8601DateFormat() {
        SimpleDateFormat df = new SimpleDateFormat(ALTERNATIVE_ISO8601_DATE_FORMAT, Locale.US);
        df.setTimeZone(new SimpleTimeZone(0, "GMT"));

        return df;
    }

    public static long getFixedSkewedTimeMillis() {
        return System.currentTimeMillis() + amendTimeSkewed;
    }

    public static synchronized String currentFixedSkewedTimeInRFC822Format() {
        return formatRfc822Date(new Date(getFixedSkewedTimeMillis()));
    }

    public static synchronized void setCurrentServerTime(long serverTime) {
        amendTimeSkewed = serverTime - System.currentTimeMillis();
    }
}

public class TestJava {

    public static void main(String[] params) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        System.out.println(DateUtil.formatRfc822Date(new Date()));
        System.out.println(DateUtil.formatIso8601Date(new Date()));
        System.out.println(DateUtil.formatAlternativeIso8601Date(new Date()));

        System.out.println(1/100);
        
    }

}

// Wed, 26 Jan 2022 06:51:39 GMT
// 2022-01-26T06:51:39.378Z
// 2022-01-26T06:51:39Z

// Wed, 26 Jan 2022 06:51:27 GMT
// 2022-01-26T06:54:51.933Z
// 2022-01-26T06:57:46Z


