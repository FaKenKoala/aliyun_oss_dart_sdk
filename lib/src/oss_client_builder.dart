import 'oss.dart';
import 'oss_builder.dart';
import 'oss_client.dart';

/// Fluent builder for OSS Client. Use of the builder is preferred over using
/// constructors of the client class.
 class OSSClientBuilder implements OSSBuilder {

    @override
     OSS build(String endpoint, String accessKeyId, String secretAccessKey) {
        return OSSClient(endpoint, getDefaultCredentialProvider(accessKeyId, secretAccessKey),
                getClientConfiguration());
    }

    @override
     OSS build(String endpoint, String accessKeyId, String secretAccessKey, String securityToken) {
        return OSSClient(endpoint, getDefaultCredentialProvider(accessKeyId, secretAccessKey, securityToken),
                getClientConfiguration());
    }

    @override
     OSS build(String endpoint, String accessKeyId, String secretAccessKey, ClientBuilderConfiguration config) {
        return OSSClient(endpoint, getDefaultCredentialProvider(accessKeyId, secretAccessKey),
                getClientConfiguration(config));
    }

    @override
     OSS build(String endpoint, String accessKeyId, String secretAccessKey, String securityToken,
            ClientBuilderConfiguration config) {
        return OSSClient(endpoint, getDefaultCredentialProvider(accessKeyId, secretAccessKey, securityToken),
                getClientConfiguration(config));
    }

    @override
     OSS build(String endpoint, CredentialsProvider credsProvider) {
        return OSSClient(endpoint, credsProvider, getClientConfiguration());
    }

    @override
     OSS build(String endpoint, CredentialsProvider credsProvider, ClientBuilderConfiguration config) {
        return OSSClient(endpoint, credsProvider, getClientConfiguration(config));
    }

     static ClientBuilderConfiguration getClientConfiguration() {
        return ClientBuilderConfiguration();
    }

     static ClientBuilderConfiguration getClientConfiguration(ClientBuilderConfiguration config) {
        if (config == null) {
            config = ClientBuilderConfiguration();
        }
        return config;
    }

     static DefaultCredentialProvider getDefaultCredentialProvider(String accessKeyId, String secretAccessKey) {
        return DefaultCredentialProvider(accessKeyId, secretAccessKey);
    }

     static DefaultCredentialProvider getDefaultCredentialProvider(String accessKeyId, String secretAccessKey,
            String securityToken) {
        return DefaultCredentialProvider(accessKeyId, secretAccessKey, securityToken);
    }

}
