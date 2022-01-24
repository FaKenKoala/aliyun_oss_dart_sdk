
 import 'http_credentials_fetcher.dart';

class InstanceProfileCredentialsFetcher extends HttpCredentialsFetcher {

     void setRoleName(String? roleName) {
        if (roleName?.isEmpty ?? true) {
            throw ArgumentError("You must specifiy a valid role name.");
        }
        this.roleName = roleName;
    }

     InstanceProfileCredentialsFetcher withRoleName(String roleName) {
        setRoleName(roleName);
        return this;
    }

    @override
     Uri buildUrl()  {
        try {
            return URL("http://" + metadataServiceHost + URL_IN_ECS_METADATA + roleName);
        } catch (MalformedURLException e) {
            throw ArgumentError(e.toString());
        }
    }

    @override
     Credentials parse(HttpResponse response) {
        String jsonContent = String(response.getHttpContent());

        try {
            JSONObject obj = JSONObject(jsonContent);

            if (obj.has("Code") && obj.has("AccessKeyId") && obj.has("AccessKeySecret") && obj.has("SecurityToken")
                    && obj.has("Expiration")) {
            } else {
                throw ClientException("Invalid json got from ECS Metadata service.");
            }

            if (!"Success".equals(obj.getString("Code"))) {
                throw ClientException("Failed to get RAM session credentials from ECS metadata service.");
            }

            return InstanceProfileCredentials(obj.getString("AccessKeyId"), obj.getString("AccessKeySecret"),
                    obj.getString("SecurityToken"), obj.getString("Expiration"));
        } catch ( e) {
            throw ClientException("InstanceProfileCredentialsFetcher.parse [$jsonContent] exception:$e");
        }
    }

     static final String URL_IN_ECS_METADATA = "/latest/meta-data/ram/security-credentials/";
     static final String metadataServiceHost = "100.100.100.200";

     String roleName;

}
