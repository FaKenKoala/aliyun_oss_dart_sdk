 import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/common/utils/io_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/oss_upload_operation.dart';
import 'package:encrypt/encrypt.dart';

class AuthUtils {

    /// Default expiration time
     static final int DEFAULT_EXPIRED_DURATION_SECONDS = 3600;

    /// Default expiration time adjustment factor
     static final double DEFAULT_EXPIRED_FACTOR = 0.8;

    /// The maximum number of retries when getting AK/SK from ECS
     static final int MAX_ECS_METADATA_FETCH_RETRY_TIMES = 3;

    /// AK/SK expiration time obtained from ECS Metadata Service, default 6 hours
     static final int DEFAULT_ECS_SESSION_TOKEN_DURATION_SECONDS = 3600 * 6;

    /// AK/SK expire time obtained from STS, default 1 hour
     static final int DEFAULT_STS_SESSION_TOKEN_DURATION_SECONDS = 3600 * 1;

    /// Connection timeout when getting AK/SK, the default 5 seconds
     static final int DEFAULT_HTTP_SOCKET_TIMEOUT_IN_MILLISECONDS = 5000;

    /// Environment variable name for the oss access key ID
     static final String ACCESS_KEY_ENV_VAR = "OSS_ACCESS_KEY_ID";

    /// Environment variable name for the oss secret key
     static final String SECRET_KEY_ENV_VAR = "OSS_ACCESS_KEY_SECRET";

    /// Environment variable name for the oss session token
     static final String SESSION_TOKEN_ENV_VAR = "OSS_SESSION_TOKEN";

    /**
     * System property used when starting up the JVM to enable the default
     * metrics collected by the OSS SDK.
     *
     * <pre>
     * Example: -Doss.accessKeyId
     * </pre>
     */
    /// System property name for the OSS access key ID */
     static final String ACCESS_KEY_SYSTEM_PROPERTY = "oss.accessKeyId";

    /// System property name for the OSS secret key */
     static final String SECRET_KEY_SYSTEM_PROPERTY = "oss.accessKeySecret";

    /// System property name for the OSS session token */
     static final String SESSION_TOKEN_SYSTEM_PROPERTY = "oss.sessionToken";

    /**
     * Loads the local OSS credential profiles from the standard location
     * (~/.oss/credentials), which can be easily overridden through the
     * <code>OSS_CREDENTIAL_PROFILES_FILE</code> environment variable.
     * <p>
     * The OSS credentials file format allows you to specify multiple profiles,
     * each with their own set of OSS security credentials:
     * 
     * <pre>
     * [default]
     * oss_access_key_id=testAccessKey
     * oss_secret_access_key=testSecretKey
     * oss_session_token=testSessionToken
     *
     * [test-user]
     * oss_access_key_id=testAccessKey
     * oss_secret_access_key=testSecretKey
     * oss_session_token=testSessionToken
     * </pre>
     */
    /// Credential profile file at the default location */
     static final String DEFAULT_PROFILE_PATH = defaultProfilePath();

    /// Default section name in the profile file */
     static final String DEFAULT_SECTION_NAME = "default";

    /// Property name for specifying the OSS Access Key */
     static final String OSS_ACCESS_KEY_ID = "oss_access_key_id";

    /// Property name for specifying the OSS Secret Access Key */
     static final String OSS_SECRET_ACCESS_KEY = "oss_secret_access_key";

    /// Property name for specifying the OSS Session Token */
     static final String OSS_SESSION_TOKEN = "oss_session_token";

    /// Get the default profile path.
    /// 
    /// @return Default profile path
     static String defaultProfilePath() {
        return System.getProperty("user.home") + Platform.pathSeparator + ".oss" + Platform.pathSeparator + "credentials";
    }

    /// Upload the  key of RSA key pair.
    /// 
    /// @param regionId
    ///            RAM's available area.
    /// @param accessKeyId
    ///            Access Key ID of the root user.
    /// @param accessKeySecret
    ///            Secret Access Key of the root user.
    /// @param Key
    ///             key content.
    /// @return  key description, include  key id etc.
    /// @throws ClientException
     static Key uploadKey(String regionId, String accessKeyId, String accessKeySecret,
            String key) {
        DefaultProfile profile = DefaultProfile.getProfile(regionId, accessKeyId, accessKeySecret);
        DefaultAcsClient client = DefaultAcsClient(profile);

        UploadKeyRequest uploadKeyRequest = UploadKeyRequest();
        uploadKeyRequest.setKeySpec(key);

        UploadKeyResponse uploadKeyResponse = client.getAcsResponse(uploadKeyRequest);
        com.aliyuncs.ram.model.v20150501.UploadKeyResponse.Key pubKey = uploadKeyResponse
                .getKey();

        return Key(pubKey);
    }

    /// List the  keys that has been uploaded.
    /// 
    /// @param regionId
    ///            RAM's available area.
    /// @param accessKeyId
    ///            Access Key ID of the root user.
    /// @param accessKeySecret
    ///            Secret Access Key of the root user.
    /// @return  keys.
    /// @throws ClientException
     static List<Key> listKeys(String regionId, String accessKeyId, String accessKeySecret)
             {
        DefaultProfile profile = DefaultProfile.getProfile(regionId, accessKeyId, accessKeySecret);
        DefaultAcsClient client = DefaultAcsClient(profile);

        ListKeysRequest listKeysRequest = ListKeysRequest();
        ListKeysResponse listKeysResponse = client.getAcsResponse(listKeysRequest);

        List<Key> Keys = [];
        for (com.aliyuncs.ram.model.v20150501.ListKeysResponse.Key Key : listKeysResponse
                .getKeys()) {
            Keys.add(Key(Key));
        }

        return Keys;
    }

    /// Delete the uploaded  key.
    /// 
    /// @param regionId
    ///            RAM's available area.
    /// @param accessKeyId
    ///            Access Key ID of the root user.
    /// @param accessKeySecret
    ///            Secret Access Key of the root user.
    /// @param KeyId
    ///             Key Id.
    /// @throws ClientException
     static void deleteKey(String regionId, String accessKeyId, String accessKeySecret, String KeyId)
             {
        DefaultProfile profile = DefaultProfile.getProfile(regionId, accessKeyId, accessKeySecret);
        DefaultAcsClient client = DefaultAcsClient(profile);

        DeleteKeyRequest deleteKeyRequest = DeleteKeyRequest();
        deleteKeyRequest.setUserKeyId(KeyId);

        client.getAcsResponse(deleteKeyRequest);
    }

    /// Load  key content from file and format.
    /// 
    /// @param KeyPath
    ///             key file path.
    /// @return Formatted  key content.
    /// @throws IOException
     static String loadKeyFromFile(String KeyPath) {
        File file = File(KeyPath);
        byte[] filecontent = byte[(int) file.length()];
        InputStream? inputStream ;

        try {
            inputStream = FileInputStream(file);
            inputStream?.read(filecontent);
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch ( e) {
                }
            }
        }

        return String(filecontent);
    }

    /// Load  key content from file and format.
    /// 
    /// @param KeyPath
    ///             key file path.
    /// @return Formatted  key content.
    /// @throws IOException
     static String loadKeyFromFile(String keyPath) {
        BufferedReader? reader;
        StringBuffer builder = StringBuffer();

        try {
            reader = BufferedReader(InputStreamReader(FileInputStream(keyPath)));
            String? str;
            while (true) {
                str = reader.readLine();
                if (str == null) {
                    break;
                }

                if (str.contains("-----BEGIN  KEY-----")) {
                    continue;
                }

                if (str.contains("-----END  KEY-----")) {
                    break;
                }

                if (str != null) {
                    builder.write(str + "\n");
                }
            }
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch ( e) {
                }
            }
        }

        return builder.toString();
    }

}
