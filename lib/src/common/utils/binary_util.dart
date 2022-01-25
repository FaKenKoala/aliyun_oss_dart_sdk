 import 'dart:convert';

import 'dart:html';

import 'package:aliyun_oss_dart_sdk/src/internal/http_message.dart';

class BinaryUtil {
     static String toBase64String(List<int> binaryData) {
        return base64.encode(binaryData).trim();
    }

    /// decode base64 string
     static List<int> fromBase64String(String base64String) {
        return base64.decode(base64String);
    }

    /// calculate md5 for bytes
     static List<int> calculateMd5(List<int> binaryData) {
        MessageDigest messageDigest = null;
        try {
            messageDigest = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            throw RuntimeException("MD5 algorithm not found.");
        }
        messageDigest.update(binaryData);
        return messageDigest.digest();

    }

    /// calculate md5 for local file
     static List<int> calculateMd5FromFile(String filePath)  {
        List<int> md5;
        try {
            MessageDigest digest = MessageDigest.getInstance("MD5");
            List<int> buffer = byte[10 * 1024];
            FileInputStream is = FileInputStream(new File(filePath));
            int len;
            while ((len = is.read(buffer)) != -1) {
                digest.update(buffer, 0, len);
            }
            is.close();
            md5 = digest.digest();
        } catch (NoSuchAlgorithmException e) {
            throw RuntimeException("MD5 algorithm not found.");
        }
        return md5;
    }

    /// calculate md5 for bytes and string back
     static String calculateMd5Str(List<int> binaryData) {
        return getMd5StrFromBytes(calculateMd5(binaryData));
    }

    /// calculate md5 for file and string back
     static String calculateMd5StrFromFile(String filePath)  {
        return getMd5StrFromBytes(calculateMd5(filePath));
    }


    /// calculate md5 for bytes and base64 string back
     static String calculateBase64Md5(List<int> binaryData) {
        return toBase64String(calculateMd5(binaryData));
    }

    /// calculate md5 for local file and base64 string back
     static String calculateBase64Md5FromFile(String filePath)  {
        return toBase64String(calculateMd5(filePath));
    }

    /// MD5sum for string
     static String getMd5StrFromBytes(List<int>? md5bytes) {
        if (md5bytes == null) {
            return "";
        }
        StringBuffer sb = StringBuffer();
        for (int i = 0; i < md5bytes.length; i++) {
            sb.write(String.format("%02x", md5bytes[i]));
        }
        return sb.toString();
    }

    /// Get the sha1 value of the filepath specified file
    ///
    /// @param filePath The filepath of the file
    /// @return The sha1 value
     static String fileToSHA1(String filePath) {
        InputStream? inputStream = null;
        try {
            inputStream = FileInputStream(filePath); // Create an FileInputStream instance according to the filepath
            List<int> buffer = byte[1024]; // The buffer to read the file
            MessageDigest digest = MessageDigest.getInstance("SHA-1"); // Get a SHA-1 instance
            int numRead = 0; // Record how many bytes have been read
            while (numRead != -1) {
                numRead = inputStream.read(buffer);
                if (numRead > 0) {
                    digest.update(buffer, 0, numRead); // Update the digest
                }
            }
            List<int> sha1Bytes = digest.digest(); // Complete the hash computing
            return convertHashToString(sha1Bytes); // Call the function to convert to hex digits
        } catch ( e) {
            return null;
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close(); // Close the InputStream
                } catch ( e) {
                }
            }
        }
    }

     static String? fileToSHA1(FileDescriptor fileDescriptor) {
        InputStream? inputStream;
        try {
            inputStream = FileInputStream(fileDescriptor); // Create an FileInputStream instance according to the filepath
            List<int> buffer = byte[1024]; // The buffer to read the file
            MessageDigest digest = MessageDigest.getInstance("SHA-1"); // Get a SHA-1 instance
            int numRead = 0; // Record how many bytes have been read
            while (numRead != -1) {
                numRead = inputStream.read(buffer);
                if (numRead > 0) {
                    digest.update(buffer, 0, numRead); // Update the digest
                }
            }
            List<int> sha1Bytes = digest.digest(); // Complete the hash computing
            return convertHashToString(sha1Bytes); // Call the function to convert to hex digits
        } catch ( e) {
            return null;
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close(); // Close the InputStream
                } catch ( e) {
                }
            }
        }
    }

    /// Convert the hash bytes to hex digits string
    ///
    /// @param hashBytes
    /// @return The converted hex digits string
     static String convertHashToString(List<int> hashBytes) {
        String returnVal = "";
        for (int i = 0; i < hashBytes.length; i++) {
            returnVal += ((hashBytes[i] & 0xff) + 0x100).toRadixString(16).substring(1);
        }
        return returnVal.toLowerCase();
    }
}
