
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class TestJava {

    public static void main(String[] params) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        MessageDigest messageDigest = null;
        messageDigest = MessageDigest.getInstance("MD5");
        messageDigest.update("hello".getBytes());
        byte[] result = messageDigest.digest();
        for (byte b : result) {
            System.out.println(b & 0xFF);
        }
    }
}
