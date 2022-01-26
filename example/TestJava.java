
import java.util.Base64;
import java.util.HashMap;
import java.util.zip.Checksum;

public class TestJava {

    public static void main(String[] params) {
        HashMap<String, String> map = new HashMap<String, String>();
        map.put("hello", "world");
        JSONObject jsonObj = JSONObject(map);
        return Base64.encodeToString(jsonObj.toString().getBytes());
    }

}

