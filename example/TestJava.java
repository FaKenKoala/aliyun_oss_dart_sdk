package example;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class TestJava {

    static void main() throws UnsupportedEncodingException {
        String middle = URLEncoder.encode("a b*c~d/e+f", "utf-8");
        // a b*c~d/e+f 经过URLEncoder.encode 会 转变成 a+b*c%7Ed%2Fe%2Bf

        String expect = "a%20b%2Ac~d/e%2Bf";//"a+b*c%7Ed%2Fe%2Bf";

        String actual = middle.replace("+", "%20").replace("*", "%2A")
                .replace("%7E", "~").replace("%2F", "/");

        System.out.println("expect: $result");
        System.out.println("middle: $middle");
        System.out.println("actual: $actual");
        System.out.println(expect == actual);
    }
}
