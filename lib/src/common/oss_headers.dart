
 import 'utils/http_headers.dart';

abstract class OSSHeaders extends HttpHeaders {

    static final String ossPrefix = "x-oss-";
    static final String ossUserMetadataPrefix = "x-oss-meta-";

    static final String ossCannedAcl = "x-oss-acl";
    static final String storageClass = "x-oss-storage-class";
    static final String ossVersionId = "x-oss-version-id";

    static final String ossHeaderSymlinkTarget = "x-oss-symlink-target";

    static final String ossHashSha1 = "x-oss-hash-sha1";

    static final String ossServerSideEncryption = "x-oss-server-side-encryption";

    static final String getObjectIfModifiedSince = "If-Modified-Since";
    static final String getObjectIfUnmodifiedSince = "If-Unmodified-Since";
    static final String getObjectIfMatch = "If-Match";
    static final String getObjectIfNoneMatch = "If-None-Match";

    static final String headObjectIfModifiedSince = "If-Modified-Since";
    static final String headObjectIfUnmodifiedSince = "If-Unmodified-Since";
    static final String headObjectIfMatch = "If-Match";
    static final String headObjectIfNoneMatch = "If-None-Match";

    static final String copyObjectSource = "x-oss-copy-source";
    static final String copySourceRange = "x-oss-copy-source-range";
    static final String copyObjectSourceIfMatch = "x-oss-copy-source-if-match";
    static final String copyObjectSourceIfNoneMatch = "x-oss-copy-source-if-none-match";
    static final String copyObjectSourceIfUnmodifiedSince = "x-oss-copy-source-if-unmodified-since";
    static final String copyObjectSourceIfModifiedSince = "x-oss-copy-source-if-modified-since";
    static final String copyObjectMetadataDirective = "x-oss-metadata-directive";

    static final String ossHeaderRequestId = "x-oss-request-id";

    static final String origin = "origin";
    static final String accessControlRequestMethod = "Access-Control-Request-Method";
    static final String accessControlRequestHeader = "Access-Control-Request-Headers";

    static final String accessControlAllowOrigin = "Access-Control-Allow-Origin";
    static final String accessControlAllowMethods = "Access-Control-Allow-Methods";
    static final String accessControlAllowHeaders = "Access-Control-Allow-Headers";
    static final String accessControlExposeHeaders = "Access-Control-Expose-Headers";
    static final String accessControlMaxAge = "Access-Control-Max-Age";

    static final String ossSecurityToken = "x-oss-security-token";

    static final String ossNextAppendPosition = "x-oss-next-append-position";
    static final String ossHashCrc64Ecma = "x-oss-hash-crc64ecma";
    static final String ossObjectType = "x-oss-object-type";
}
