/// A collection of parsers that parse HTTP reponses into corresponding human-readable results.
 final import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/parser/response_parse_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/parser/response_parser.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/model/access_control_list.dart';
import 'package:aliyun_oss_dart_sdk/src/model/add_bucket_cname_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/append_object_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket_info.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket_logging_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket_metadata.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket_process.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket_qos_info.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket_referer.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket_stat.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket_versioning_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket_website_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/cname_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/model/complete_multipart_upload_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/cors_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/model/create_live_channel_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/delete_directory_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/delete_versions_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/generic_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_async_fetch_task_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_bucket_image_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_bucket_inventory_configuration_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_bucket_policy_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_bucket_resource_group_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_bucket_worm_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_image_style_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/initiate_bucket_worm_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/initiate_multipart_upload_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lifecycle_rule.dart';
import 'package:aliyun_oss_dart_sdk/src/model/list_bucket_inventory_configurations_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/live_channel_info.dart';
import 'package:aliyun_oss_dart_sdk/src/model/live_channel_listing.dart';
import 'package:aliyun_oss_dart_sdk/src/model/live_channel_stat.dart';
import 'package:aliyun_oss_dart_sdk/src/model/live_record.dart';
import 'package:aliyun_oss_dart_sdk/src/model/object_listing.dart';
import 'package:aliyun_oss_dart_sdk/src/model/object_metadata.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_object.dart';
import 'package:aliyun_oss_dart_sdk/src/model/part_listing.dart';
import 'package:aliyun_oss_dart_sdk/src/model/put_object_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/restore_object_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/server_side_encryption_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/model/set_async_fetch_task_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/simplified_object_meta.dart';
import 'package:aliyun_oss_dart_sdk/src/model/style.dart';
import 'package:aliyun_oss_dart_sdk/src/model/tag_set.dart';
import 'package:aliyun_oss_dart_sdk/src/model/transfer_acceleration.dart';
import 'package:aliyun_oss_dart_sdk/src/model/upload_part_copy_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/user_qos.dart';
import 'package:aliyun_oss_dart_sdk/src/model/user_qos_info.dart';
import 'package:aliyun_oss_dart_sdk/src/model/version_listing.dart';
import 'package:aliyun_oss_dart_sdk/src/model/void_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/vpc_ip.dart';
import 'package:aliyun_oss_dart_sdk/src/model/vpc_policy.dart';

import 'oss_headers.dart';

class ResponseParsers {

     static final ListBucketResponseParser listBucketResponseParser = new ListBucketResponseParser();
     static final ListImageStyleResponseParser listImageStyleResponseParser = new ListImageStyleResponseParser();
     static final GetBucketRefererResponseParser getBucketRefererResponseParser = new GetBucketRefererResponseParser();
     static final GetBucketAclResponseParser getBucketAclResponseParser = new GetBucketAclResponseParser();
     static final GetBucketMetadataResponseParser getBucketMetadataResponseParser = new GetBucketMetadataResponseParser();
     static final GetBucketLocationResponseParser getBucketLocationResponseParser = new GetBucketLocationResponseParser();
     static final GetBucketLoggingResponseParser getBucketLoggingResponseParser = new GetBucketLoggingResponseParser();
     static final GetBucketWebsiteResponseParser getBucketWebsiteResponseParser = new GetBucketWebsiteResponseParser();
     static final GetBucketLifecycleResponseParser getBucketLifecycleResponseParser = new GetBucketLifecycleResponseParser();
     static final GetBucketCorsResponseParser getBucketCorsResponseParser = new GetBucketCorsResponseParser();
     static final GetBucketImageResponseParser getBucketImageResponseParser = new GetBucketImageResponseParser();
     static final GetImageStyleResponseParser getImageStyleResponseParser = new GetImageStyleResponseParser();
     static final GetBucketImageProcessConfResponseParser getBucketImageProcessConfResponseParser = new GetBucketImageProcessConfResponseParser();
     static final GetTaggingResponseParser getTaggingResponseParser = new GetTaggingResponseParser();
     static final GetBucketReplicationResponseParser getBucketReplicationResponseParser = new GetBucketReplicationResponseParser();
     static final GetBucketReplicationProgressResponseParser getBucketReplicationProgressResponseParser = new GetBucketReplicationProgressResponseParser();
     static final GetBucketReplicationLocationResponseParser getBucketReplicationLocationResponseParser = new GetBucketReplicationLocationResponseParser();
     static final AddBucketCnameResponseParser addBucketCnameResponseParser = new AddBucketCnameResponseParser();
     static final GetBucketCnameResponseParser getBucketCnameResponseParser = new GetBucketCnameResponseParser();
     static final GetBucketInfoResponseParser getBucketInfoResponseParser = new GetBucketInfoResponseParser();
     static final GetBucketStatResponseParser getBucketStatResponseParser = new GetBucketStatResponseParser();
     static final GetBucketQosResponseParser getBucketQosResponseParser = new GetBucketQosResponseParser();
     static final GetBucketVersioningResponseParser getBucketVersioningResponseParser = new GetBucketVersioningResponseParser();
     static final GetBucketEncryptionResponseParser getBucketEncryptionResponseParser = new GetBucketEncryptionResponseParser();
     static final GetBucketPolicyResponseParser getBucketPolicyResponseParser = new GetBucketPolicyResponseParser();
     static final GetBucketRequestPaymentResponseParser getBucketRequestPaymentResponseParser = new GetBucketRequestPaymentResponseParser();
     static final GetUSerQosInfoResponseParser getUSerQosInfoResponseParser = new GetUSerQosInfoResponseParser();
     static final GetBucketQosInfoResponseParser getBucketQosInfoResponseParser = new GetBucketQosInfoResponseParser();
     static final SetAsyncFetchTaskResponseParser setAsyncFetchTaskResponseParser = new SetAsyncFetchTaskResponseParser();
     static final GetAsyncFetchTaskResponseParser getAsyncFetchTaskResponseParser = new GetAsyncFetchTaskResponseParser();
     static final CreateVpcipResultResponseParser createVpcipResultResponseParser = new CreateVpcipResultResponseParser();
     static final ListVpcipResultResponseParser listVpcipResultResponseParser = new ListVpcipResultResponseParser();
     static final ListVpcPolicyResultResponseParser listVpcPolicyResultResponseParser = new ListVpcPolicyResultResponseParser();
     static final InitiateBucketWormResponseParser initiateBucketWormResponseParser = new InitiateBucketWormResponseParser();
     static final GetBucketWormResponseParser getBucketWormResponseParser = new GetBucketWormResponseParser();
     static final GetBucketResourceGroupResponseParser getBucketResourceGroupResponseParser = new GetBucketResourceGroupResponseParser();
     static final GetBucketTransferAccelerationResponseParser getBucketTransferAccelerationResponseParser = new GetBucketTransferAccelerationResponseParser();

     static final GetBucketInventoryConfigurationParser getBucketInventoryConfigurationParser = new GetBucketInventoryConfigurationParser();
     static final ListBucketInventoryConfigurationsParser listBucketInventoryConfigurationsParser = new ListBucketInventoryConfigurationsParser();
     static final ListObjectsReponseParser listObjectsReponseParser = new ListObjectsReponseParser();
     static final ListObjectsV2ResponseParser listObjectsV2ResponseParser = new ListObjectsV2ResponseParser();
     static final ListVersionsReponseParser listVersionsReponseParser = new ListVersionsReponseParser();
     static final PutObjectReponseParser putObjectReponseParser = new PutObjectReponseParser();
     static final PutObjectProcessReponseParser putObjectProcessReponseParser = new PutObjectProcessReponseParser();
     static final AppendObjectResponseParser appendObjectResponseParser = new AppendObjectResponseParser();
     static final GetObjectMetadataResponseParser getObjectMetadataResponseParser = new GetObjectMetadataResponseParser();
     static final CopyObjectResponseParser copyObjectResponseParser = new CopyObjectResponseParser();
     static final DeleteObjectsResponseParser deleteObjectsResponseParser = new DeleteObjectsResponseParser();
     static final DeleteVersionsResponseParser deleteVersionsResponseParser = new DeleteVersionsResponseParser();
     static final GetObjectAclResponseParser getObjectAclResponseParser = new GetObjectAclResponseParser();
     static final GetSimplifiedObjectMetaResponseParser getSimplifiedObjectMetaResponseParser = new GetSimplifiedObjectMetaResponseParser();
     static final RestoreObjectResponseParser restoreObjectResponseParser = new RestoreObjectResponseParser();
     static final ProcessObjectResponseParser processObjectResponseParser = new ProcessObjectResponseParser();
     static final HeadObjectResponseParser headObjectResponseParser = new HeadObjectResponseParser();

     static final CompleteMultipartUploadResponseParser completeMultipartUploadResponseParser = new CompleteMultipartUploadResponseParser();
     static final CompleteMultipartUploadProcessResponseParser completeMultipartUploadProcessResponseParser = new CompleteMultipartUploadProcessResponseParser();
     static final InitiateMultipartUploadResponseParser initiateMultipartUploadResponseParser = new InitiateMultipartUploadResponseParser();
     static final ListMultipartUploadsResponseParser listMultipartUploadsResponseParser = new ListMultipartUploadsResponseParser();
     static final ListPartsResponseParser listPartsResponseParser = new ListPartsResponseParser();

     static final CreateLiveChannelResponseParser createLiveChannelResponseParser = new CreateLiveChannelResponseParser();
     static final GetLiveChannelInfoResponseParser getLiveChannelInfoResponseParser = new GetLiveChannelInfoResponseParser();
     static final GetLiveChannelStatResponseParser getLiveChannelStatResponseParser = new GetLiveChannelStatResponseParser();
     static final GetLiveChannelHistoryResponseParser getLiveChannelHistoryResponseParser = new GetLiveChannelHistoryResponseParser();
     static final ListLiveChannelsReponseParser listLiveChannelsReponseParser = new ListLiveChannelsReponseParser();

     static final GetSymbolicLinkResponseParser getSymbolicLinkResponseParser = new GetSymbolicLinkResponseParser();

     static final DeleteDirectoryResponseParser deleteDirectoryResponseParser = new DeleteDirectoryResponseParser();
     
     
     
     static <ResultType extends GenericResult> void setCRC(ResultType result, ResponseMessage response) {
        InputStream inputStream = response.getRequest().getContent();
        if (inputStream is CheckedInputStream) {
            CheckedInputStream checkedInputStream = (CheckedInputStream) inputStream;
            result.setClientCRC(checkedInputStream.getChecksum().getValue());
        }

        String strSrvCrc = response.headers[OSSHeaders.OSS_HASH_CRC64_ECMA];
        if (strSrvCrc != null) {
            BigInteger bi = new BigInteger(strSrvCrc);
            result.setServerCRC(bi.longValue());
        }
    }

     static <ResultType extends GenericResult> void setServerCRC(ResultType result, ResponseMessage response) {
        String strSrvCrc = response.headers[OSSHeaders.OSS_HASH_CRC64_ECMA];
        if (strSrvCrc != null) {
            BigInteger bi = new BigInteger(strSrvCrc);
            result.setServerCRC(bi.longValue());
        }
    }

     static Element getXmlRootElement(InputStream responseBody) {
        SAXBuilder builder = new SAXBuilder();
        builder.setFeature("http://apache.org/xml/features/disallow-doctype-decl",true);
        builder.setFeature("http://xml.org/sax/features/external-general-entities", false);
        builder.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
        builder.setExpandEntities(false);
        Document doc = builder.build(responseBody);
        return doc.getRootElement();
    }

    /**
     * Unmarshall list objects response body to object listing.
     */
    
     static ObjectListing parseListObjects(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            ObjectListing objectListing = new ObjectListing();
            objectListing.setBucketName(root.getChildText("Name"));
            objectListing.setMaxKeys(Integer.valueOf(root.getChildText("MaxKeys")));
            objectListing.setTruncated(bool.valueOf(root.getChildText("IsTruncated")));

            if (root.getChild("Prefix") != null) {
                String prefix = root.getChildText("Prefix");
                objectListing.setPrefix(isNullOrEmpty(prefix) ? null : prefix);
            }

            if (root.getChild("Marker") != null) {
                String marker = root.getChildText("Marker");
                objectListing.setMarker(isNullOrEmpty(marker) ? null : marker);
            }

            if (root.getChild("Delimiter") != null) {
                String delimiter = root.getChildText("Delimiter");
                objectListing.setDelimiter(isNullOrEmpty(delimiter) ? null : delimiter);
            }

            if (root.getChild("NextMarker") != null) {
                String nextMarker = root.getChildText("NextMarker");
                objectListing.setNextMarker(isNullOrEmpty(nextMarker) ? null : nextMarker);
            }

            if (root.getChild("EncodingType") != null) {
                String encodingType = root.getChildText("EncodingType");
                objectListing.setEncodingType(isNullOrEmpty(encodingType) ? null : encodingType);
            }

            List<Element> objectSummaryElems = root.getChildren("Contents");
            for (Element elem : objectSummaryElems) {
                OSSObjectSummary ossObjectSummary = new OSSObjectSummary();

                ossObjectSummary.setKey(elem.getChildText("Key"));
                ossObjectSummary.setETag(trimQuotes(elem.getChildText("ETag")));
                ossObjectSummary.setLastModified(DateUtil.parseIso8601Date(elem.getChildText("LastModified")));
                ossObjectSummary.setSize(Long.valueOf(elem.getChildText("Size")));
                ossObjectSummary.setStorageClass(elem.getChildText("StorageClass"));
                ossObjectSummary.setBucketName(objectListing.getBucketName());

                if (elem.getChild("Type") != null) {
                    ossObjectSummary.setType(elem.getChildText("Type"));
                }

                String id = elem.getChild("Owner").getChildText("ID");
                String displayName = elem.getChild("Owner").getChildText("DisplayName");
                ossObjectSummary.setOwner(new Owner(id, displayName));

                objectListing.addObjectSummary(ossObjectSummary);
            }

            List<Element> commonPrefixesElems = root.getChildren("CommonPrefixes");
            for (Element elem : commonPrefixesElems) {
                String prefix = elem.getChildText("Prefix");
                if (!isNullOrEmpty(prefix)) {
                    objectListing.addCommonPrefix(prefix);
                }
            }

            return objectListing;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall list objects response body to ListObjectsV2Result.
     */
    
     static ListObjectsV2Result parseListObjectsV2(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            ListObjectsV2Result result = new ListObjectsV2Result();
            result.setBucketName(root.getChildText("Name"));
            result.setMaxKeys(Integer.valueOf(root.getChildText("MaxKeys")));
            result.setTruncated(bool.valueOf(root.getChildText("IsTruncated")));
            result.setKeyCount(Integer.valueOf(root.getChildText("KeyCount")));

            if (root.getChild("Prefix") != null) {
                String prefix = root.getChildText("Prefix");
                result.setPrefix(isNullOrEmpty(prefix) ? null : prefix);
            }

            if (root.getChild("Delimiter") != null) {
                String delimiter = root.getChildText("Delimiter");
                result.setDelimiter(isNullOrEmpty(delimiter) ? null : delimiter);
            }

            if (root.getChild("ContinuationToken") != null) {
                String continuationToken = root.getChildText("ContinuationToken");
                result.setContinuationToken(isNullOrEmpty(continuationToken) ? null : continuationToken);
            }

            if (root.getChild("NextContinuationToken") != null) {
                String nextContinuationToken = root.getChildText("NextContinuationToken");
                result.setNextContinuationToken(isNullOrEmpty(nextContinuationToken) ? null : nextContinuationToken);
            }

            if (root.getChild("EncodingType") != null) {
                String encodeType = root.getChildText("EncodingType");
                result.setEncodingType(isNullOrEmpty(encodeType) ? null : encodeType);
            }

            if (root.getChild("StartAfter") != null) {
                String startAfter = root.getChildText("StartAfter");
                result.setStartAfter(isNullOrEmpty(startAfter) ? null : startAfter);
            }

            List<Element> objectSummaryElems = root.getChildren("Contents");
            for (Element elem : objectSummaryElems) {
                OSSObjectSummary ossObjectSummary = new OSSObjectSummary();

                ossObjectSummary.setKey(elem.getChildText("Key"));
                ossObjectSummary.setETag(trimQuotes(elem.getChildText("ETag")));
                ossObjectSummary.setLastModified(DateUtil.parseIso8601Date(elem.getChildText("LastModified")));
                ossObjectSummary.setSize(Long.valueOf(elem.getChildText("Size")));
                ossObjectSummary.setStorageClass(elem.getChildText("StorageClass"));
                ossObjectSummary.setBucketName(result.getBucketName());

                if (elem.getChild("Type") != null) {
                    ossObjectSummary.setType(elem.getChildText("Type"));
                }

                if (elem.getChild("Owner") != null) {
                    String id = elem.getChild("Owner").getChildText("ID");
                    String displayName = elem.getChild("Owner").getChildText("DisplayName");
                    ossObjectSummary.setOwner(new Owner(id, displayName));
                }

                result.addObjectSummary(ossObjectSummary);
            }

            List<Element> commonPrefixesElems = root.getChildren("CommonPrefixes");

            for (Element elem : commonPrefixesElems) {
                String prefix = elem.getChildText("Prefix");
                if (!isNullOrEmpty(prefix)) {
                    result.addCommonPrefix(prefix);
                }
            }

            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }
    
    /**
     * Unmarshall list objects response body to object listing.
     */
    
     static VersionListing parseListVersions(InputStream responseBody) {
        try {
            Element root = getXmlRootElement(responseBody);

            bool shouldSDKDecode = false;
            VersionListing versionListing = new VersionListing();
            versionListing.setBucketName(root.getChildText("Name"));
            versionListing.setMaxKeys(Integer.valueOf(root.getChildText("MaxKeys")));
            versionListing.setTruncated(bool.valueOf(root.getChildText("IsTruncated")));

            if (root.getChild("EncodingType") != null) {
                String encodingType = root.getChildText("EncodingType");
                if (encodingType.equals(OSSConstants.URL_ENCODING)) {
                    shouldSDKDecode = true;
                    versionListing.setEncodingType(null);
                } else {
                    versionListing.setEncodingType(isNullOrEmpty(encodingType) ? null : encodingType);
                }
            }

            if (root.getChild("Prefix") != null) {
                String prefix = root.getChildText("Prefix");
                versionListing.setPrefix(isNullOrEmpty(prefix) ? null : decodeIfSpecified(prefix, shouldSDKDecode));
            }

            if (root.getChild("KeyMarker") != null) {
                String marker = root.getChildText("KeyMarker");
                versionListing.setKeyMarker(isNullOrEmpty(marker) ? null : decodeIfSpecified(marker, shouldSDKDecode));
            }

            if (root.getChild("VersionIdMarker") != null) {
                String marker = root.getChildText("VersionIdMarker");
                versionListing.setVersionIdMarker(isNullOrEmpty(marker) ? null : marker);
            }

            if (root.getChild("Delimiter") != null) {
                String delimiter = root.getChildText("Delimiter");
                versionListing
                    .setDelimiter(isNullOrEmpty(delimiter) ? null : decodeIfSpecified(delimiter, shouldSDKDecode));
            }

            if (root.getChild("NextKeyMarker") != null) {
                String nextMarker = root.getChildText("NextKeyMarker");
                versionListing.setNextKeyMarker(
                    isNullOrEmpty(nextMarker) ? null : decodeIfSpecified(nextMarker, shouldSDKDecode));
            }

            if (root.getChild("NextVersionIdMarker") != null) {
                String nextMarker = root.getChildText("NextVersionIdMarker");
                versionListing.setNextVersionIdMarker(isNullOrEmpty(nextMarker) ? null : nextMarker);
            }

            List<Element> objectSummaryElems = root.getChildren("Version");
            for (Element elem : objectSummaryElems) {
                OSSVersionSummary ossVersionSummary = new OSSVersionSummary();

                ossVersionSummary.setKey(decodeIfSpecified(elem.getChildText("Key"), shouldSDKDecode));
                ossVersionSummary.setVersionId(elem.getChildText("VersionId"));
                ossVersionSummary.setIsLatest("true".equals(elem.getChildText("IsLatest")));
                ossVersionSummary.setETag(trimQuotes(elem.getChildText("ETag")));
                ossVersionSummary.setLastModified(DateUtil.parseIso8601Date(elem.getChildText("LastModified")));
                ossVersionSummary.setSize(Long.valueOf(elem.getChildText("Size")));
                ossVersionSummary.setStorageClass(elem.getChildText("StorageClass"));
                ossVersionSummary.setBucketName(versionListing.getBucketName());
                ossVersionSummary.setIsDeleteMarker(false);

                String id = elem.getChild("Owner").getChildText("ID");
                String displayName = elem.getChild("Owner").getChildText("DisplayName");
                ossVersionSummary.setOwner(new Owner(id, displayName));

                versionListing.getVersionSummaries().add(ossVersionSummary);
            }

            List<Element> delSummaryElems = root.getChildren("DeleteMarker");
            for (Element elem : delSummaryElems) {
                OSSVersionSummary ossVersionSummary = new OSSVersionSummary();

                ossVersionSummary.setKey(decodeIfSpecified(elem.getChildText("Key"), shouldSDKDecode));
                ossVersionSummary.setVersionId(elem.getChildText("VersionId"));
                ossVersionSummary.setIsLatest("true".equals(elem.getChildText("IsLatest")));
                ossVersionSummary.setLastModified(DateUtil.parseIso8601Date(elem.getChildText("LastModified")));
                ossVersionSummary.setBucketName(versionListing.getBucketName());
                ossVersionSummary.setIsDeleteMarker(true);

                String id = elem.getChild("Owner").getChildText("ID");
                String displayName = elem.getChild("Owner").getChildText("DisplayName");
                ossVersionSummary.setOwner(new Owner(id, displayName));

                versionListing.getVersionSummaries().add(ossVersionSummary);
            }

            List<Element> commonPrefixesElems = root.getChildren("CommonPrefixes");
            for (Element elem : commonPrefixesElems) {
                String prefix = elem.getChildText("Prefix");
                if (!isNullOrEmpty(prefix)) {
                    versionListing.getCommonPrefixes().add(decodeIfSpecified(prefix, shouldSDKDecode));
                }
            }

            return versionListing;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }
    
    /**
     * Perform an url decode on the given value if specified.
     */
     static String decodeIfSpecified(String value, bool decode) {
        return decode ? HttpUtil.urlDecode(value, StringUtils.DEFAULT_ENCODING) : value;
    }

    /**
     * Unmarshall get bucket acl response body to ACL.
     */
     static AccessControlList parseGetBucketAcl(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            AccessControlList acl = new AccessControlList();

            String id = root.getChild("Owner").getChildText("ID");
            String displayName = root.getChild("Owner").getChildText("DisplayName");
            Owner owner = new Owner(id, displayName);
            acl.setOwner(owner);

            String aclString = root.getChild("AccessControlList").getChildText("Grant");
            CannedAccessControlList cacl = CannedAccessControlList.parse(aclString);
            acl.setCannedACL(cacl);

            switch (cacl) {
            case Read:
                acl.grantPermission(GroupGrantee.AllUsers, Permission.Read);
                break;
            case ReadWrite:
                acl.grantPermission(GroupGrantee.AllUsers, Permission.FullControl);
                break;
            default:
                break;
            }

            return acl;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall object acl response body to object ACL.
     */
     static ObjectAcl parseGetObjectAcl(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            ObjectAcl acl = new ObjectAcl();

            String id = root.getChild("Owner").getChildText("ID");
            String displayName = root.getChild("Owner").getChildText("DisplayName");
            Owner owner = new Owner(id, displayName);
            acl.setOwner(owner);

            String grantString = root.getChild("AccessControlList").getChildText("Grant");
            acl.setPermission(ObjectPermission.parsePermission(grantString));

            return acl;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket referer response body to bucket referer list.
     */
    
     static BucketReferer parseGetBucketReferer(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            bool allowEmptyReferer = bool.valueOf(root.getChildText("AllowEmptyReferer"));
            List<String> refererList = [];
            if (root.getChild("RefererList") != null) {
                Element refererListElem = root.getChild("RefererList");
                List<Element> refererElems = refererListElem.getChildren("Referer");
                if (refererElems != null && !refererElems.isEmpty()) {
                    for (Element e : refererElems) {
                        refererList.add(e.getText());
                    }
                }
            }
            return new BucketReferer(allowEmptyReferer, refererList);
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall upload part copy response body to uploaded part's ETag.
     */
     static String parseUploadPartCopy(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            return root.getChildText("ETag");
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall list bucket response body to bucket list.
     */
    
     static BucketList parseListBucket(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            BucketList bucketList = new BucketList();
            if (root.getChild("Prefix") != null) {
                bucketList.setPrefix(root.getChildText("Prefix"));
            }
            if (root.getChild("Marker") != null) {
                bucketList.setMarker(root.getChildText("Marker"));
            }
            if (root.getChild("MaxKeys") != null) {
                String value = root.getChildText("MaxKeys");
                bucketList.setMaxKeys(isNullOrEmpty(value) ? null : Integer.valueOf(value));
            }
            if (root.getChild("IsTruncated") != null) {
                String value = root.getChildText("IsTruncated");
                bucketList.setTruncated(isNullOrEmpty(value) ? false : bool.valueOf(value));
            }
            if (root.getChild("NextMarker") != null) {
                bucketList.setNextMarker(root.getChildText("NextMarker"));
            }

            Element ownerElem = root.getChild("Owner");
            String id = ownerElem.getChildText("ID");
            String displayName = ownerElem.getChildText("DisplayName");
            Owner owner = new Owner(id, displayName);

            List<Bucket> buckets = [];
            if (root.getChild("Buckets") != null) {
                List<Element> bucketElems = root.getChild("Buckets").getChildren("Bucket");
                for (Element e : bucketElems) {
                    Bucket bucket = new Bucket();
                    bucket.setOwner(owner);
                    bucket.setName(e.getChildText("Name"));
                    bucket.setLocation(e.getChildText("Location"));
                    bucket.setCreationDate(DateUtil.parseIso8601Date(e.getChildText("CreationDate")));
                    if (e.getChild("StorageClass") != null) {
                        bucket.setStorageClass(StorageClass.parse(e.getChildText("StorageClass")));
                    }
                    bucket.setExtranetEndpoint(e.getChildText("ExtranetEndpoint"));
                    bucket.setIntranetEndpoint(e.getChildText("IntranetEndpoint"));
                    if (e.getChild("Region") != null) {
                        bucket.setRegion(e.getChildText("Region"));
                    }
                    if (e.getChild("HierarchicalNamespace") != null) {
                        bucket.setHnsStatus(e.getChildText("HierarchicalNamespace"));
                    }
					if (e.getChild("ResourceGroupId") != null) {
						bucket.setResourceGroupId(e.getChildText("ResourceGroupId"));
					}
                    buckets.add(bucket);
                }
            }
            bucketList.setBucketList(buckets);

            return bucketList;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall list image style response body to style list.
     */
    
     static List<Style> parseListImageStyle(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            List<Style> styleList = [];
            List<Element> styleElems = root.getChildren("Style");
            for (Element e : styleElems) {
                Style style = new Style();
                style.SetStyleName(e.getChildText("Name"));
                style.SetStyle(e.getChildText("Content"));
                style.SetLastModifyTime(DateUtil.parseRfc822Date(e.getChildText("LastModifyTime")));
                style.SetCreationDate(DateUtil.parseRfc822Date(e.getChildText("CreateTime")));
                styleList.add(style);
            }
            return styleList;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall get bucket location response body to bucket location.
     */
     static String parseGetBucketLocation(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            return root.getText();
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall bucket metadata from response headers.
     */
     static BucketMetadata parseBucketMetadata(Map<String, String> headers) {

        try {
            BucketMetadata bucketMetadata = new BucketMetadata();

            for (Iterator<String> it = headers.keySet().iterator(); it.hasNext();) {
                String key = it.next();

                if (key.equalsIgnoreCase(OSSHeaders.OSS_BUCKET_REGION)) {
                    bucketMetadata.setBucketRegion(headers.GET(key));
                } else {
                    bucketMetadata.addHttpMetadata(key, headers.GET(key));
                }
            }

            return bucketMetadata;
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall simplified object meta from response headers.
     */
     static SimplifiedObjectMeta parseSimplifiedObjectMeta(Map<String, String> headers)
            {

        try {
            SimplifiedObjectMeta objectMeta = new SimplifiedObjectMeta();

            for (Iterator<String> it = headers.keySet().iterator(); it.hasNext();) {
                String key = it.next();

                if (key.equalsIgnoreCase(OSSHeaders.LAST_MODIFIED)) {
                    try {
                        objectMeta.setLastModified(DateUtil.parseRfc822Date(headers.GET(key)));
                    } catch (ParseException pe) {
                        throw new ResponseParseException(pe.getMessage(), pe);
                    }
                } else if (key.equalsIgnoreCase(OSSHeaders.CONTENT_LENGTH)) {
                    Long value = Long.valueOf(headers.GET(key));
                    objectMeta.setSize(value);
                } else if (key.equalsIgnoreCase(OSSHeaders.ETAG)) {
                    objectMeta.setETag(trimQuotes(headers.GET(key)));
                } else if (key.equalsIgnoreCase(OSSHeaders.OSS_HEADER_REQUEST_ID)) {
                    objectMeta.setRequestId(headers.GET(key));
                } else if (key.equalsIgnoreCase(OSSHeaders.OSS_HEADER_VERSION_ID)) {
                    objectMeta.setVersionId(headers.GET(key));
                }
            }

            return objectMeta;
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall symlink link from response headers.
     */
     static OSSSymlink parseSymbolicLink(ResponseMessage response) {

        try {
            OSSSymlink smyLink = null;

            String targetObject = response.headers[OSSHeaders.OSS_HEADER_SYMLINK_TARGET];
            if (targetObject != null) {
                targetObject = HttpUtil.urlDecode(targetObject, "UTF-8");
                smyLink = new OSSSymlink(null, targetObject);
            }

            smyLink.setMetadata(parseObjectMetadata(response.headers));

            return smyLink;
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall object metadata from response headers.
     */
     static ObjectMetadata parseObjectMetadata(Map<String, String> headers) {

        try {
            ObjectMetadata objectMetadata = new ObjectMetadata();

            for (Iterator<String> it = headers.keySet().iterator(); it.hasNext();) {
                String key = it.next();

                if (key.indexOf(OSSHeaders.OSS_USER_METADATA_PREFIX) >= 0) {
                    key = key.substring(OSSHeaders.OSS_USER_METADATA_PREFIX.length());
                    objectMetadata.addUserMetadata(key, headers.GET(OSSHeaders.OSS_USER_METADATA_PREFIX + key));
                } else if (key.equalsIgnoreCase(OSSHeaders.LAST_MODIFIED)||key.equalsIgnoreCase(OSSHeaders.DATE)) {
                    try {
                        objectMetadata.setHeader(key, DateUtil.parseRfc822Date(headers.GET(key)));
                    } catch (ParseException pe) {
                        throw new ResponseParseException(pe.getMessage(), pe);
                    }
                } else if (key.equalsIgnoreCase(OSSHeaders.CONTENT_LENGTH)) {
                    Long value = Long.valueOf(headers.GET(key));
                    objectMetadata.setHeader(key, value);
                } else if (key.equalsIgnoreCase(OSSHeaders.ETAG)) {
                    objectMetadata.setHeader(key, trimQuotes(headers.GET(key)));
                } else {
                    objectMetadata.setHeader(key, headers.GET(key));
                }
            }

            return objectMetadata;
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall initiate multipart upload response body to corresponding
     * result.
     */
     static InitiateMultipartUploadResult parseInitiateMultipartUpload(InputStream responseBody)
            {

        try {
            Element root = getXmlRootElement(responseBody);

            InitiateMultipartUploadResult result = new InitiateMultipartUploadResult();
            if (root.getChild("Bucket") != null) {
                result.setBucketName(root.getChildText("Bucket"));
            }

            if (root.getChild("Key") != null) {
                result.setKey(root.getChildText("Key"));
            }

            if (root.getChild("UploadId") != null) {
                result.setUploadId(root.getChildText("UploadId"));
            }

            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall list multipart uploads response body to multipart upload
     * listing.
     */
    
     static MultipartUploadListing parseListMultipartUploads(InputStream responseBody)
            {

        try {
            Element root = getXmlRootElement(responseBody);

            MultipartUploadListing multipartUploadListing = new MultipartUploadListing();
            multipartUploadListing.setBucketName(root.getChildText("Bucket"));
            multipartUploadListing.setMaxUploads(Integer.valueOf(root.getChildText("MaxUploads")));
            multipartUploadListing.setTruncated(bool.valueOf(root.getChildText("IsTruncated")));

            if (root.getChild("Delimiter") != null) {
                String delimiter = root.getChildText("Delimiter");
                if (!isNullOrEmpty(delimiter)) {
                    multipartUploadListing.setDelimiter(delimiter);
                }
            }

            if (root.getChild("Prefix") != null) {
                String prefix = root.getChildText("Prefix");
                if (!isNullOrEmpty(prefix)) {
                    multipartUploadListing.setPrefix(prefix);
                }
            }

            if (root.getChild("KeyMarker") != null) {
                String keyMarker = root.getChildText("KeyMarker");
                if (!isNullOrEmpty(keyMarker)) {
                    multipartUploadListing.setKeyMarker(keyMarker);
                }
            }

            if (root.getChild("UploadIdMarker") != null) {
                String uploadIdMarker = root.getChildText("UploadIdMarker");
                if (!isNullOrEmpty(uploadIdMarker)) {
                    multipartUploadListing.setUploadIdMarker(uploadIdMarker);
                }
            }

            if (root.getChild("NextKeyMarker") != null) {
                String nextKeyMarker = root.getChildText("NextKeyMarker");
                if (!isNullOrEmpty(nextKeyMarker)) {
                    multipartUploadListing.setNextKeyMarker(nextKeyMarker);
                }
            }

            if (root.getChild("NextUploadIdMarker") != null) {
                String nextUploadIdMarker = root.getChildText("NextUploadIdMarker");
                if (!isNullOrEmpty(nextUploadIdMarker)) {
                    multipartUploadListing.setNextUploadIdMarker(nextUploadIdMarker);
                }
            }

            List<Element> uploadElems = root.getChildren("Upload");
            for (Element elem : uploadElems) {
                if (elem.getChild("Initiated") == null) {
                    continue;
                }

                MultipartUpload mu = new MultipartUpload();
                mu.setKey(elem.getChildText("Key"));
                mu.setUploadId(elem.getChildText("UploadId"));
                mu.setStorageClass(elem.getChildText("StorageClass"));
                mu.setInitiated(DateUtil.parseIso8601Date(elem.getChildText("Initiated")));
                multipartUploadListing.addMultipartUpload(mu);
            }

            List<Element> commonPrefixesElems = root.getChildren("CommonPrefixes");
            for (Element elem : commonPrefixesElems) {
                String prefix = elem.getChildText("Prefix");
                if (!isNullOrEmpty(prefix)) {
                    multipartUploadListing.addCommonPrefix(prefix);
                }
            }

            return multipartUploadListing;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall list parts response body to part listing.
     */
    
     static PartListing parseListParts(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            PartListing partListing = new PartListing();
            partListing.setBucketName(root.getChildText("Bucket"));
            partListing.setKey(root.getChildText("Key"));
            partListing.setUploadId(root.getChildText("UploadId"));
            partListing.setStorageClass(root.getChildText("StorageClass"));
            partListing.setMaxParts(Integer.valueOf(root.getChildText("MaxParts")));
            partListing.setTruncated(bool.valueOf(root.getChildText("IsTruncated")));

            if (root.getChild("PartNumberMarker") != null) {
                String partNumberMarker = root.getChildText("PartNumberMarker");
                if (!isNullOrEmpty(partNumberMarker)) {
                    partListing.setPartNumberMarker(Integer.valueOf(partNumberMarker));
                }
            }

            if (root.getChild("NextPartNumberMarker") != null) {
                String nextPartNumberMarker = root.getChildText("NextPartNumberMarker");
                if (!isNullOrEmpty(nextPartNumberMarker)) {
                    partListing.setNextPartNumberMarker(Integer.valueOf(nextPartNumberMarker));
                }
            }

            List<Element> partElems = root.getChildren("Part");
            for (Element elem : partElems) {
                PartSummary ps = new PartSummary();

                ps.setPartNumber(Integer.valueOf(elem.getChildText("PartNumber")));
                ps.setLastModified(DateUtil.parseIso8601Date(elem.getChildText("LastModified")));
                ps.setETag(trimQuotes(elem.getChildText("ETag")));
                ps.setSize(Integer.valueOf(elem.getChildText("Size")));

                partListing.addPart(ps);
            }

            return partListing;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall complete multipart upload response body to corresponding
     * result.
     */
     static CompleteMultipartUploadResult parseCompleteMultipartUpload(InputStream responseBody)
            {

        try {
            Element root = getXmlRootElement(responseBody);

            CompleteMultipartUploadResult result = new CompleteMultipartUploadResult();
            result.setBucketName(root.getChildText("Bucket"));
            result.setETag(trimQuotes(root.getChildText("ETag")));
            result.setKey(root.getChildText("Key"));
            result.setLocation(root.getChildText("Location"));

            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket logging response body to corresponding result.
     */
     static BucketLoggingResult parseBucketLogging(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            BucketLoggingResult result = new BucketLoggingResult();
            if (root.getChild("LoggingEnabled") != null) {
                result.setTargetBucket(root.getChild("LoggingEnabled").getChildText("TargetBucket"));
            }
            if (root.getChild("LoggingEnabled") != null) {
                result.setTargetPrefix(root.getChild("LoggingEnabled").getChildText("TargetPrefix"));
            }

            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket image response body to corresponding result.
     */
     static GetBucketImageResult parseBucketImage(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            GetBucketImageResult result = new GetBucketImageResult();
            result.SetBucketName(root.getChildText("Name"));
            result.SetDefault404Pic(root.getChildText("Default404Pic"));
            result.SetStyleDelimiters(root.getChildText("StyleDelimiters"));
            result.SetStatus(root.getChildText("Status"));
            result.SetIsAutoSetContentType(root.getChildText("AutoSetContentType").equals("True"));
            result.SetIsForbidOrigPicAccess(root.getChildText("OrigPicForbidden").equals("True"));
            result.SetIsSetAttachName(root.getChildText("SetAttachName").equals("True"));
            result.SetIsUseStyleOnly(root.getChildText("UseStyleOnly").equals("True"));
            result.SetIsUseSrcFormat(root.getChildText("UseSrcFormat").equals("True"));
            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get image style response body to corresponding result.
     */
     static GetImageStyleResult parseImageStyle(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            GetImageStyleResult result = new GetImageStyleResult();
            result.SetStyleName(root.getChildText("Name"));
            result.SetStyle(root.getChildText("Content"));
            result.SetLastModifyTime(DateUtil.parseRfc822Date(root.getChildText("LastModifyTime")));
            result.SetCreationDate(DateUtil.parseRfc822Date(root.getChildText("CreateTime")));
            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket process response body to bucket process.
     */
     static BucketProcess parseGetBucketImageProcessConf(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            String compliedHost = root.getChildText("CompliedHost");
            bool sourceFileProtect = false;
            if (root.getChildText("SourceFileProtect").equals("Enabled")) {
                sourceFileProtect = true;
            }
            String sourceFileProtectSuffix = root.getChildText("SourceFileProtectSuffix");
            String styleDelimiters = root.getChildText("StyleDelimiters");

            ImageProcess imageProcess = new ImageProcess(compliedHost, sourceFileProtect, sourceFileProtectSuffix,
                    styleDelimiters);
            if (root.getChildText("Version") != null) {
                imageProcess.setVersion(Integer.parseInt(root.getChildText("Version")));
            }

            return new BucketProcess(imageProcess);
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket website response body to corresponding result.
     */
    
     static BucketWebsiteResult parseBucketWebsite(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            BucketWebsiteResult result = new BucketWebsiteResult();
            Element indexDocument = root.getChild("IndexDocument");
            if (indexDocument != null) {
                result.setIndexDocument(root.getChild("IndexDocument").getChildText("Suffix"));
                if (indexDocument.getChild("SupportSubDir") != null) {
                    result.setSupportSubDir(bool.valueOf(indexDocument.getChildText("SupportSubDir")));
                }

                if (indexDocument.getChild("Type") != null) {
                    result.setSubDirType(indexDocument.getChildText("Type"));
                }
            }
            if (root.getChild("ErrorDocument") != null) {
                result.setErrorDocument(root.getChild("ErrorDocument").getChildText("Key"));
            }
            if (root.getChild("RoutingRules") != null) {
                List<Element> ruleElements = root.getChild("RoutingRules").getChildren("RoutingRule");
                for (Element ruleElem : ruleElements) {
                    RoutingRule rule = new RoutingRule();

                    rule.setNumber(Integer.parseInt(ruleElem.getChildText("RuleNumber")));

                    Element condElem = ruleElem.getChild("Condition");
                    if (condElem != null) {
                        rule.getCondition().setKeyPrefixEquals(condElem.getChildText("KeyPrefixEquals"));
                        //rule set KeySuffixEquals
                        if (condElem.getChild("KeySuffixEquals") != null) {
                            rule.getCondition().setKeySuffixEquals(condElem.getChildText("KeySuffixEquals"));
                        }
                        if (condElem.getChild("HttpErrorCodeReturnedEquals") != null) {
                            rule.getCondition().setHttpErrorCodeReturnedEquals(
                                    Integer.parseInt(condElem.getChildText("HttpErrorCodeReturnedEquals")));
                        }
                        List<Element> includeHeadersElem = condElem.getChildren("IncludeHeader");
                        if (includeHeadersElem != null && includeHeadersElem.size() > 0) {
                            List<RoutingRule.IncludeHeader> includeHeaders = [];
                            for (Element includeHeaderElem : includeHeadersElem) {
                                RoutingRule.IncludeHeader includeHeader = new RoutingRule.IncludeHeader();
                                includeHeader.setKey(includeHeaderElem.getChildText("Key"));
                                includeHeader.setEquals(includeHeaderElem.getChildText("Equals"));
                                includeHeader.setStartsWith(includeHeaderElem.getChildText("StartsWith"));
                                includeHeader.setEndsWith(includeHeaderElem.getChildText("EndsWith"));
                                includeHeaders.add(includeHeader);
                            }
                            rule.getCondition().setIncludeHeaders(includeHeaders);
                        }
                    }

                    Element redirectElem = ruleElem.getChild("Redirect");
                    if (redirectElem.getChild("RedirectType") != null) {
                        rule.getRedirect().setRedirectType(
                                RoutingRule.RedirectType.parse(redirectElem.getChildText("RedirectType")));
                    }
                    rule.getRedirect().setHostName(redirectElem.getChildText("HostName"));
                    if (redirectElem.getChild("Protocol") != null) {
                        rule.getRedirect()
                                .setProtocol(RoutingRule.Protocol.parse(redirectElem.getChildText("Protocol")));
                    }
                    rule.getRedirect().setReplaceKeyPrefixWith(redirectElem.getChildText("ReplaceKeyPrefixWith"));
                    rule.getRedirect().setReplaceKeyWith(redirectElem.getChildText("ReplaceKeyWith"));
                    if (redirectElem.getChild("HttpRedirectCode") != null) {
                        rule.getRedirect()
                                .setHttpRedirectCode(Integer.parseInt(redirectElem.getChildText("HttpRedirectCode")));
                    }
                    rule.getRedirect().setMirrorURL(redirectElem.getChildText("MirrorURL"));
                    if (redirectElem.getChildText("MirrorTunnelId") != null) {
                        rule.getRedirect().setMirrorTunnelId(redirectElem.getChildText("MirrorTunnelId"));
                    }
                    rule.getRedirect().setMirrorSecondaryURL(redirectElem.getChildText("MirrorURLSlave"));
                    rule.getRedirect().setMirrorProbeURL(redirectElem.getChildText("MirrorURLProbe"));
                    if (redirectElem.getChildText("MirrorPassQueryString") != null) {
                        rule.getRedirect().setMirrorPassQueryString(
                                bool.valueOf(redirectElem.getChildText("MirrorPassQueryString")));
                    }
                    if (redirectElem.getChildText("MirrorPassOriginalSlashes") != null) {
                        rule.getRedirect().setPassOriginalSlashes(
                                bool.valueOf(redirectElem.getChildText("MirrorPassOriginalSlashes")));
                    }

                    if (redirectElem.getChildText("PassQueryString") != null) {
                        rule.getRedirect().setPassQueryString(
                                bool.valueOf(redirectElem.getChildText("PassQueryString")));
                    }
                    if (redirectElem.getChildText("MirrorFollowRedirect") != null) {
                        rule.getRedirect().setMirrorFollowRedirect(
                                bool.valueOf(redirectElem.getChildText("MirrorFollowRedirect")));
                    }
                    if (redirectElem.getChildText("MirrorUserLastModified") != null) {
                        rule.getRedirect().setMirrorUserLastModified(
                                bool.valueOf(redirectElem.getChildText("MirrorUserLastModified")));
                    }
                    if (redirectElem.getChildText("MirrorIsExpressTunnel") != null) {
                        rule.getRedirect().setMirrorIsExpressTunnel(
                                bool.valueOf(redirectElem.getChildText("MirrorIsExpressTunnel")));
                    }
                    if (redirectElem.getChildText("MirrorDstRegion") != null) {
                        rule.getRedirect().setMirrorDstRegion(
                                redirectElem.getChildText("MirrorDstRegion"));
                    }
                    if (redirectElem.getChildText("MirrorDstVpcId") != null) {
                        rule.getRedirect().setMirrorDstVpcId(
                                redirectElem.getChildText("MirrorDstVpcId"));
                    }
                    if (redirectElem.getChildText("MirrorUsingRole") != null) {
                        rule.getRedirect().setMirrorUsingRole(bool.valueOf(redirectElem.getChildText("MirrorUsingRole")));
                    }

                    if (redirectElem.getChildText("MirrorRole") != null) {
                        rule.getRedirect().setMirrorRole(redirectElem.getChildText("MirrorRole"));
                    }

                    // EnableReplacePrefix and MirrorSwitchAllErrors
                    if (redirectElem.getChild("EnableReplacePrefix") != null) {
                        rule.getRedirect().setEnableReplacePrefix(bool.valueOf(redirectElem.getChildText("EnableReplacePrefix")));
                    }

                    if (redirectElem.getChild("MirrorSwitchAllErrors") != null) {
                        rule.getRedirect().setMirrorSwitchAllErrors(bool.valueOf(redirectElem.getChildText("MirrorSwitchAllErrors")));
                    }

                    if (redirectElem.getChild("MirrorCheckMd5") != null) {
                        rule.getRedirect().setMirrorCheckMd5(bool.valueOf(redirectElem.getChildText("MirrorCheckMd5")));
                    }

                    Element mirrorURLsElem = redirectElem.getChild("MirrorMultiAlternates");
                    if (mirrorURLsElem != null) {
                        List<Element> mirrorURLElementList = mirrorURLsElem.getChildren("MirrorMultiAlternate");
                        if (mirrorURLElementList != null && mirrorURLElementList.size() > 0) {
                            List<RoutingRule.Redirect.MirrorMultiAlternate> mirrorURLsList = [];
                            for (Element setElement : mirrorURLElementList) {
                                RoutingRule.Redirect.MirrorMultiAlternate mirrorMultiAlternate = new RoutingRule.Redirect.MirrorMultiAlternate();
                                mirrorMultiAlternate.setPrior(Integer.parseInt(setElement.getChildText("MirrorMultiAlternateNumber")));
                                mirrorMultiAlternate.setUrl(setElement.getChildText("MirrorMultiAlternateURL"));
                                mirrorURLsList.add(mirrorMultiAlternate);
                            }
                            rule.getRedirect().setMirrorMultiAlternates(mirrorURLsList);
                        }
                    }

                    Element mirrorHeadersElem = redirectElem.getChild("MirrorHeaders");
                    if (mirrorHeadersElem != null) {
                        RoutingRule.MirrorHeaders mirrorHeaders = new RoutingRule.MirrorHeaders();
                        mirrorHeaders.setPassAll(bool.valueOf(mirrorHeadersElem.getChildText("PassAll")));
                        mirrorHeaders.setPass(parseStringListFromElemet(mirrorHeadersElem.getChildren("Pass")));
                        mirrorHeaders.setRemove(parseStringListFromElemet(mirrorHeadersElem.getChildren("Remove")));
                        List<Element> setElementList = mirrorHeadersElem.getChildren("Set");
                        if (setElementList != null && setElementList.size() > 0) {
                            List<Map<String, String>> setList = [];
                            for (Element setElement : setElementList) {
                                Map<String, String> map = <String, String>{};
                                map.PUT("Key", setElement.getChildText("Key"));
                                map.PUT("Value", setElement.getChildText("Value"));
                                setList.add(map);
                            }
                            mirrorHeaders.setSet(setList);
                        }

                        rule.getRedirect().setMirrorHeaders(mirrorHeaders);
                    }

                    result.AddRoutingRule(rule);
                }
            }

            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * 转换ElementList to StringList
     *
     * @param elementList
     * @return
     */
     static List<String> parseStringListFromElemet(List<Element> elementList) {
        if (elementList != null && elementList.size() > 0) {
            List<String> list = [];
            for (Element element : elementList) {
                list.add(element.getText());
            }
            return list;
        }
        return null;
    }
    /**
     * Unmarshall copy object response body to corresponding result.
     */
     static CopyObjectResult parseCopyObjectResult(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            CopyObjectResult result = new CopyObjectResult();
            result.setLastModified(DateUtil.parseIso8601Date(root.getChildText("LastModified")));
            result.setEtag(trimQuotes(root.getChildText("ETag")));

            return result;
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall delete objects response body to corresponding result.
     */
    
     static DeleteObjectsResult parseDeleteObjectsResult(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            DeleteObjectsResult deleteObjectsResult = new DeleteObjectsResult();
            if (root.getChild("EncodingType") != null) {
                String encodingType = root.getChildText("EncodingType");
                deleteObjectsResult.setEncodingType(isNullOrEmpty(encodingType) ? null : encodingType);
            }

            List<String> deletedObjects = [];
            List<Element> deletedElements = root.getChildren("Deleted");
            for (Element elem : deletedElements) {
                deletedObjects.add(elem.getChildText("Key"));
            }
            deleteObjectsResult.setDeletedObjects(deletedObjects);

            return deleteObjectsResult;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }
    
    /**
     * Unmarshall delete versions response body to corresponding result.
     */
    
     static DeleteVersionsResult parseDeleteVersionsResult(InputStream responseBody)
        {
        bool shouldSDKDecodeResponse = false;

        try {
            Element root = getXmlRootElement(responseBody);

            if (root.getChild("EncodingType") != null) {
                String encodingType = root.getChildText("EncodingType");
                shouldSDKDecodeResponse = OSSConstants.URL_ENCODING.equals(encodingType);
            }

            List<DeletedVersion> deletedVersions = [];
            List<Element> deletedElements = root.getChildren("Deleted");
            for (Element elem : deletedElements) {
                DeletedVersion key = new DeletedVersion();

                if (shouldSDKDecodeResponse) {
                    key.setKey(HttpUtil.urlDecode(elem.getChildText("Key"), StringUtils.DEFAULT_ENCODING));
                } else {
                    key.setKey(elem.getChildText("Key"));
                }

                if (elem.getChild("VersionId") != null) {
                    key.setVersionId(elem.getChildText("VersionId"));
                }

                if (elem.getChild("DeleteMarker") != null) {
                    key.setDeleteMarker(bool.parsebool(elem.getChildText("DeleteMarker")));
                }

                if (elem.getChild("DeleteMarkerVersionId") != null) {
                    key.setDeleteMarkerVersionId(elem.getChildText("DeleteMarkerVersionId"));
                }

                deletedVersions.add(key);
            }

            return new DeleteVersionsResult(deletedVersions);
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket cors response body to cors rules.
     */
    
     static CORSConfiguration parseListBucketCORS(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            CORSConfiguration result = new CORSConfiguration();
            List<Element> corsRuleElems = root.getChildren("CORSRule");

            for (Element corsRuleElem : corsRuleElems) {
                CORSRule rule = new CORSRule();

                List<Element> allowedOriginElems = corsRuleElem.getChildren("AllowedOrigin");
                for (Element allowedOriginElement : allowedOriginElems) {
                    rule.getAllowedOrigins().add(allowedOriginElement.getValue());
                }

                List<Element> allowedMethodElems = corsRuleElem.getChildren("AllowedMethod");
                for (Element allowedMethodElement : allowedMethodElems) {
                    rule.getAllowedMethods().add(allowedMethodElement.getValue());
                }

                List<Element> allowedHeaderElems = corsRuleElem.getChildren("AllowedHeader");
                for (Element allowedHeaderElement : allowedHeaderElems) {
                    rule.getAllowedHeaders().add(allowedHeaderElement.getValue());
                }

                List<Element> exposeHeaderElems = corsRuleElem.getChildren("ExposeHeader");
                for (Element exposeHeaderElement : exposeHeaderElems) {
                    rule.getExposeHeaders().add(exposeHeaderElement.getValue());
                }

                Element maxAgeSecondsElem = corsRuleElem.getChild("MaxAgeSeconds");
                if (maxAgeSecondsElem != null) {
                    rule.setMaxAgeSeconds(Integer.parseInt(maxAgeSecondsElem.getValue()));
                }
                result.getCorsRules().add(rule);
            }

            Element responseVaryElems = root.getChild("ResponseVary");
            if (responseVaryElems != null) {
                result.setResponseVary(bool.parsebool(responseVaryElems.getValue()));
            }

            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket tagging response body to cors rules.
     */
    
     static TagSet parseGetBucketTagging(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            TagSet tagSet = new TagSet();
            List<Element> tagElems = root.getChild("TagSet").getChildren("Tag");

            for (Element tagElem : tagElems) {
                String key = null;
                String value = null;

                if (tagElem.getChild("Key") != null) {
                    key = tagElem.getChildText("Key");
                }

                if (tagElem.getChild("Value") != null) {
                    value = tagElem.getChildText("Value");
                }

                tagSet.setTag(key, value);
            }

            return tagSet;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket replication response body to replication result.
     */
    
     static List<ReplicationRule> parseGetBucketReplication(InputStream responseBody)
            {

        try {
            List<ReplicationRule> repRules = [];

            Element root = getXmlRootElement(responseBody);
            List<Element> ruleElems = root.getChildren("Rule");

            for (Element ruleElem : ruleElems) {
                ReplicationRule repRule = new ReplicationRule();

                repRule.setReplicationRuleID(ruleElem.getChildText("ID"));

                Element destination = ruleElem.getChild("Destination");
                repRule.setTargetBucketName(destination.getChildText("Bucket"));
                repRule.setTargetBucketLocation(destination.getChildText("Location"));

                repRule.setTargetCloud(destination.getChildText("Cloud"));
                repRule.setTargetCloudLocation(destination.getChildText("CloudLocation"));

                repRule.setReplicationStatus(ReplicationStatus.parse(ruleElem.getChildText("Status")));

                if (ruleElem.getChildText("HistoricalObjectReplication").equals("enabled")) {
                    repRule.setEnableHistoricalObjectReplication(true);
                } else {
                    repRule.setEnableHistoricalObjectReplication(false);
                }

                if (ruleElem.getChild("PrefixSet") != null) {
                    List<String> objectPrefixes = [];
                    List<Element> prefixElems = ruleElem.getChild("PrefixSet").getChildren("Prefix");
                    for (Element prefixElem : prefixElems) {
                        objectPrefixes.add(prefixElem.getText());
                    }
                    repRule.setObjectPrefixList(objectPrefixes);
                }

                if (ruleElem.getChild("Action") != null) {
                    String[] actionStrs = ruleElem.getChildText("Action").split(",");
                    List<ReplicationAction> repActions = [];
                    for (String actionStr : actionStrs) {
                        repActions.add(ReplicationAction.parse(actionStr));
                    }
                    repRule.setReplicationActionList(repActions);
                }

                repRule.setSyncRole(ruleElem.getChildText("SyncRole"));

                if (ruleElem.getChild("EncryptionConfiguration") != null){
                    repRule.setReplicaKmsKeyID(ruleElem.getChild("EncryptionConfiguration").getChildText("ReplicaKmsKeyID"));
                }

                if (ruleElem.getChild("SourceSelectionCriteria") != null &&
                    ruleElem.getChild("SourceSelectionCriteria").getChild("SseKmsEncryptedObjects") != null) {
                    repRule.setSseKmsEncryptedObjectsStatus(ruleElem.getChild("SourceSelectionCriteria").
                            getChild("SseKmsEncryptedObjects").getChildText("Status"));
                }

                if (ruleElem.getChild("Source") != null){
                    repRule.setSourceBucketLocation(ruleElem.getChild("Source").getChildText("Location"));
                }

                repRules.add(repRule);
            }

            return repRules;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket replication response body to replication progress.
     */
     static BucketReplicationProgress parseGetBucketReplicationProgress(InputStream responseBody)
            {
        try {
            BucketReplicationProgress progress = new BucketReplicationProgress();

            Element root = getXmlRootElement(responseBody);
            Element ruleElem = root.getChild("Rule");

            progress.setReplicationRuleID(ruleElem.getChildText("ID"));

            Element destination = ruleElem.getChild("Destination");
            progress.setTargetBucketName(destination.getChildText("Bucket"));
            progress.setTargetBucketLocation(destination.getChildText("Location"));
            progress.setTargetCloud(destination.getChildText("Cloud"));
            progress.setTargetCloudLocation(destination.getChildText("CloudLocation"));

            progress.setReplicationStatus(ReplicationStatus.parse(ruleElem.getChildText("Status")));

            if (ruleElem.getChildText("HistoricalObjectReplication").equals("enabled")) {
                progress.setEnableHistoricalObjectReplication(true);
            } else {
                progress.setEnableHistoricalObjectReplication(false);
            }

            Element progressElem = ruleElem.getChild("Progress");
            if (progressElem != null) {
                if (progressElem.getChild("HistoricalObject") != null) {
                    progress.setHistoricalObjectProgress(
                            Float.parseFloat(progressElem.getChildText("HistoricalObject")));
                }
                progress.setNewObjectProgress(DateUtil.parseIso8601Date(progressElem.getChildText("NewObject")));
            }

            return progress;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket replication response body to replication location.
     */
    
     static List<String> parseGetBucketReplicationLocation(InputStream responseBody)
            {
        try {
            Element root = getXmlRootElement(responseBody);

            List<String> locationList = [];
            List<Element> locElements = root.getChildren("Location");

            for (Element locElem : locElements) {
                locationList.add(locElem.getText());
            }

            return locationList;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket info response body to bucket info.
     */
     static BucketInfo parseGetBucketInfo(InputStream responseBody) {
        try {
            Element root = getXmlRootElement(responseBody);
            Element bucketElem = root.getChild("Bucket");
            BucketInfo bucketInfo = new BucketInfo();

            // owner
            Bucket bucket = new Bucket();
            String id = bucketElem.getChild("Owner").getChildText("ID");
            String displayName = bucketElem.getChild("Owner").getChildText("DisplayName");
            Owner owner = new Owner(id, displayName);
            bucket.setOwner(owner);

            // bucket
            bucket.setName(bucketElem.getChildText("Name"));
            bucket.setLocation(bucketElem.getChildText("Location"));
            bucket.setExtranetEndpoint(bucketElem.getChildText("ExtranetEndpoint"));
            bucket.setIntranetEndpoint(bucketElem.getChildText("IntranetEndpoint"));
            bucket.setCreationDate(DateUtil.parseIso8601Date(bucketElem.getChildText("CreationDate")));

            if (bucketElem.getChild("HierarchicalNamespace") != null) {
                String hnsStatus = bucketElem.getChildText("HierarchicalNamespace");
                bucket.setHnsStatus(hnsStatus);
            }

			if (bucketElem.getChild("ResourceGroupId") != null) {
                String resourceGroupId = bucketElem.getChildText("ResourceGroupId");
                bucket.setResourceGroupId(resourceGroupId);
            }

            if (bucketElem.getChild("StorageClass") != null) {
                bucket.setStorageClass(StorageClass.parse(bucketElem.getChildText("StorageClass")));
            }
            bucketInfo.setBucket(bucket);

            // comment
            if (bucketElem.getChild("Comment") != null) {
                String comment = bucketElem.getChildText("Comment");
                bucketInfo.setComment(comment);
            }

            // data redundancy type
            if (bucketElem.getChild("DataRedundancyType") != null) {
                String dataRedundancyString = bucketElem.getChildText("DataRedundancyType");
                DataRedundancyType dataRedundancyType = DataRedundancyType.parse(dataRedundancyString);
                bucketInfo.setDataRedundancyType(dataRedundancyType);
            }

            // acl
            String aclString = bucketElem.getChild("AccessControlList").getChildText("Grant");
            CannedAccessControlList acl = CannedAccessControlList.parse(aclString);
            bucketInfo.setCannedACL(acl);
            switch (acl) {
            case Read:
                bucketInfo.grantPermission(GroupGrantee.AllUsers, Permission.Read);
                break;
            case ReadWrite:
                bucketInfo.grantPermission(GroupGrantee.AllUsers, Permission.FullControl);
                break;
            default:
                break;
            }

            // sse
            Element sseElem = bucketElem.getChild("ServerSideEncryptionRule");
            if (sseElem != null) {
                ServerSideEncryptionConfiguration serverSideEncryptionConfiguration =
                    new ServerSideEncryptionConfiguration();
                ServerSideEncryptionByDefault applyServerSideEncryptionByDefault = new ServerSideEncryptionByDefault();

                applyServerSideEncryptionByDefault.setSSEAlgorithm(sseElem.getChildText("SSEAlgorithm"));
                if (sseElem.getChild("KMSMasterKeyID") != null) {
                    applyServerSideEncryptionByDefault.setKMSMasterKeyID(sseElem.getChildText("KMSMasterKeyID"));
                }
                if (sseElem.getChild("KMSDataEncryption") != null) {
                    applyServerSideEncryptionByDefault.setKMSDataEncryption(sseElem.getChildText("KMSDataEncryption"));
                }
                serverSideEncryptionConfiguration
                    .setApplyServerSideEncryptionByDefault(applyServerSideEncryptionByDefault);

                bucketInfo.setServerSideEncryptionConfiguration(serverSideEncryptionConfiguration);
            }

            return bucketInfo;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket info response body to bucket stat.
     */
     static BucketStat parseGetBucketStat(InputStream responseBody) {
        try {
            Element root = getXmlRootElement(responseBody);
            Long storage = Long.parseLong(root.getChildText("Storage"));
            Long objectCount = Long.parseLong(root.getChildText("ObjectCount"));
            Long multipartUploadCount = Long.parseLong(root.getChildText("MultipartUploadCount"));
            BucketStat bucketStat = new BucketStat(storage, objectCount, multipartUploadCount);
            return bucketStat;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall create live channel response body to corresponding result.
     */
    
     static CreateLiveChannelResult parseCreateLiveChannel(InputStream responseBody)
            {

        try {
            Element root = getXmlRootElement(responseBody);
            CreateLiveChannelResult result = new CreateLiveChannelResult();

            List<String> publishUrls = [];
            List<Element> publishElems = root.getChild("PublishUrls").getChildren("Url");
            for (Element urlElem : publishElems) {
                publishUrls.add(urlElem.getText());
            }
            result.setPublishUrls(publishUrls);

            List<String> playUrls = [];
            List<Element> playElems = root.getChild("PlayUrls").getChildren("Url");
            for (Element urlElem : playElems) {
                playUrls.add(urlElem.getText());
            }
            result.setPlayUrls(playUrls);

            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall get live channel info response body to corresponding result.
     */
     static LiveChannelInfo parseGetLiveChannelInfo(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            LiveChannelInfo result = new LiveChannelInfo();

            result.setDescription(root.getChildText("Description"));
            result.setStatus(LiveChannelStatus.parse(root.getChildText("Status")));

            Element targetElem = root.getChild("Target");
            LiveChannelTarget target = new LiveChannelTarget();
            target.setType(targetElem.getChildText("Type"));
            target.setFragDuration(Integer.parseInt(targetElem.getChildText("FragDuration")));
            target.setFragCount(Integer.parseInt(targetElem.getChildText("FragCount")));
            target.setPlaylistName(targetElem.getChildText("PlaylistName"));
            result.setTarget(target);

            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall get live channel stat response body to corresponding result.
     */
     static LiveChannelStat parseGetLiveChannelStat(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            LiveChannelStat result = new LiveChannelStat();

            result.setPushflowStatus(PushflowStatus.parse(root.getChildText("Status")));

            if (root.getChild("ConnectedTime") != null) {
                result.setConnectedDate(DateUtil.parseIso8601Date(root.getChildText("ConnectedTime")));
            }

            if (root.getChild("RemoteAddr") != null) {
                result.setRemoteAddress(root.getChildText("RemoteAddr"));
            }

            Element videoElem = root.getChild("Video");
            if (videoElem != null) {
                VideoStat videoStat = new VideoStat();
                videoStat.setWidth(Integer.parseInt(videoElem.getChildText("Width")));
                videoStat.setHeight(Integer.parseInt(videoElem.getChildText("Height")));
                videoStat.setFrameRate(Integer.parseInt(videoElem.getChildText("FrameRate")));
                videoStat.setBandWidth(Integer.parseInt(videoElem.getChildText("Bandwidth")));
                videoStat.setCodec(videoElem.getChildText("Codec"));
                result.setVideoStat(videoStat);
            }

            Element audioElem = root.getChild("Audio");
            if (audioElem != null) {
                AudioStat audioStat = new AudioStat();
                audioStat.setBandWidth(Integer.parseInt(audioElem.getChildText("Bandwidth")));
                audioStat.setSampleRate(Integer.parseInt(audioElem.getChildText("SampleRate")));
                audioStat.setCodec(audioElem.getChildText("Codec"));
                result.setAudioStat(audioStat);
            }

            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall get live channel history response body to corresponding
     * result.
     */
    
     static List<LiveRecord> parseGetLiveChannelHistory(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            List<LiveRecord> liveRecords = [];
            List<Element> recordElements = root.getChildren("LiveRecord");

            for (Element recordElem : recordElements) {
                LiveRecord record = new LiveRecord();
                record.setStartDate(DateUtil.parseIso8601Date(recordElem.getChildText("StartTime")));
                record.setEndDate(DateUtil.parseIso8601Date(recordElem.getChildText("EndTime")));
                record.setRemoteAddress(recordElem.getChildText("RemoteAddr"));
                liveRecords.add(record);
            }

            return liveRecords;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall list live channels response body to live channel listing.
     */
    
     static LiveChannelListing parseListLiveChannels(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            LiveChannelListing liveChannelListing = new LiveChannelListing();
            liveChannelListing.setTruncated(bool.valueOf(root.getChildText("IsTruncated")));

            if (root.getChild("Prefix") != null) {
                String prefix = root.getChildText("Prefix");
                liveChannelListing.setPrefix(isNullOrEmpty(prefix) ? null : prefix);
            }

            if (root.getChild("Marker") != null) {
                String marker = root.getChildText("Marker");
                liveChannelListing.setMarker(isNullOrEmpty(marker) ? null : marker);
            }

            if (root.getChild("MaxKeys") != null) {
                String maxKeys = root.getChildText("MaxKeys");
                liveChannelListing.setMaxKeys(Integer.valueOf(maxKeys));
            }

            if (root.getChild("NextMarker") != null) {
                String nextMarker = root.getChildText("NextMarker");
                liveChannelListing.setNextMarker(isNullOrEmpty(nextMarker) ? null : nextMarker);
            }

            List<Element> liveChannelElems = root.getChildren("LiveChannel");
            for (Element elem : liveChannelElems) {
                LiveChannel liveChannel = new LiveChannel();

                liveChannel.setName(elem.getChildText("Name"));
                liveChannel.setDescription(elem.getChildText("Description"));
                liveChannel.setStatus(LiveChannelStatus.parse(elem.getChildText("Status")));
                liveChannel.setLastModified(DateUtil.parseIso8601Date(elem.getChildText("LastModified")));

                List<String> publishUrls = [];
                List<Element> publishElems = elem.getChild("PublishUrls").getChildren("Url");
                for (Element urlElem : publishElems) {
                    publishUrls.add(urlElem.getText());
                }
                liveChannel.setPublishUrls(publishUrls);

                List<String> playUrls = [];
                List<Element> playElems = elem.getChild("PlayUrls").getChildren("Url");
                for (Element urlElem : playElems) {
                    playUrls.add(urlElem.getText());
                }
                liveChannel.setPlayUrls(playUrls);

                liveChannelListing.addLiveChannel(liveChannel);
            }

            return liveChannelListing;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall get user qos response body to user qos.
     */
     static UserQos parseGetUserQos(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            UserQos userQos = new UserQos();

            if (root.getChild("StorageCapacity") != null) {
                userQos.setStorageCapacity(Integer.parseInt(root.getChildText("StorageCapacity")));
            }

            return userQos;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }
    
    /**
     * Unmarshall get bucket versioning response body to versioning configuration.
     */
     static BucketVersioningConfiguration parseGetBucketVersioning(InputStream responseBody)
        {

        try {
            Element root = getXmlRootElement(responseBody);
            BucketVersioningConfiguration configuration = new BucketVersioningConfiguration();

            configuration.setStatus(root.getChildText("Status"));

            return configuration;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall get bucket encryption response body to encryption configuration.
     */
     static ServerSideEncryptionConfiguration parseGetBucketEncryption(InputStream responseBody)
        {

        try {
            Element root = getXmlRootElement(responseBody);
            ServerSideEncryptionConfiguration configuration = new ServerSideEncryptionConfiguration();
            ServerSideEncryptionByDefault sseByDefault = new ServerSideEncryptionByDefault();

            Element sseElem = root.getChild("ApplyServerSideEncryptionByDefault");
            sseByDefault.setSSEAlgorithm(sseElem.getChildText("SSEAlgorithm"));
            sseByDefault.setKMSMasterKeyID(sseElem.getChildText("KMSMasterKeyID"));
            if (sseElem.getChild("KMSDataEncryption") != null) {
                sseByDefault.setKMSDataEncryption(sseElem.getChildText("KMSDataEncryption"));
            }
            configuration.setApplyServerSideEncryptionByDefault(sseByDefault);

            return configuration;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall get bucket policy response body .
     */
     static GetBucketPolicyResult parseGetBucketPolicy(InputStream responseBody) {

        try {
        	GetBucketPolicyResult result = new GetBucketPolicyResult();

    		BufferedReader reader = new BufferedReader(new InputStreamReader(responseBody));
    		StringBuilder sb = new StringBuilder();
    		
    		String s ;
    		while (( s = reader.readLine()) != null) 
    			sb.append(s);
    		
    		result.setPolicy(sb.toString());
    		
            return result;
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }
    
    /**
     * Unmarshall get bucuket request payment response body to GetBucketRequestPaymentResult.
     */
     static GetBucketRequestPaymentResult parseGetBucketRequestPayment(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            GetBucketRequestPaymentResult paymentResult = new GetBucketRequestPaymentResult();

            if (root.getChild("Payer") != null) {
            	Payer payer = Payer.parse(root.getChildText("Payer"));
            	paymentResult.setPayer(payer);
            }

            return paymentResult;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }
    /**
     * Unmarshall get user qos info response body to UserQosInfo.
     */
     static UserQosInfo parseGetUserQosInfo(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            UserQosInfo userQosInfo = new UserQosInfo();

            userQosInfo.setRegion(root.getChildText("Region"));
            userQosInfo.setTotalUploadBw(Integer.valueOf(root.getChildText("TotalUploadBandwidth")));
            userQosInfo.setIntranetUploadBw(Integer.valueOf(root.getChildText("IntranetUploadBandwidth")));
            userQosInfo.setExtranetUploadBw(Integer.valueOf(root.getChildText("ExtranetUploadBandwidth")));
            userQosInfo.setTotalDownloadBw(Integer.valueOf(root.getChildText("TotalDownloadBandwidth")));
            userQosInfo.setIntranetDownloadBw(Integer.valueOf(root.getChildText("IntranetDownloadBandwidth")));
            userQosInfo.setExtranetDownloadBw(Integer.valueOf(root.getChildText("ExtranetDownloadBandwidth")));
            userQosInfo.setTotalQps(Integer.valueOf(root.getChildText("TotalQps")));
            userQosInfo.setIntranetQps(Integer.valueOf(root.getChildText("IntranetQps")));
            userQosInfo.setExtranetQps(Integer.valueOf(root.getChildText("ExtranetQps")));

            return userQosInfo;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall get bucuket qos info response body to BucketQosInfo.
     */
     static BucketQosInfo parseGetBucketQosInfo(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            BucketQosInfo bucketQosInfo = new BucketQosInfo();

            bucketQosInfo.setTotalUploadBw(Integer.valueOf(root.getChildText("TotalUploadBandwidth")));
            bucketQosInfo.setIntranetUploadBw(Integer.valueOf(root.getChildText("IntranetUploadBandwidth")));
            bucketQosInfo.setExtranetUploadBw(Integer.valueOf(root.getChildText("ExtranetUploadBandwidth")));
            bucketQosInfo.setTotalDownloadBw(Integer.valueOf(root.getChildText("TotalDownloadBandwidth")));
            bucketQosInfo.setIntranetDownloadBw(Integer.valueOf(root.getChildText("IntranetDownloadBandwidth")));
            bucketQosInfo.setExtranetDownloadBw(Integer.valueOf(root.getChildText("ExtranetDownloadBandwidth")));
            bucketQosInfo.setTotalQps(Integer.valueOf(root.getChildText("TotalQps")));
            bucketQosInfo.setIntranetQps(Integer.valueOf(root.getChildText("IntranetQps")));
            bucketQosInfo.setExtranetQps(Integer.valueOf(root.getChildText("ExtranetQps")));

            return bucketQosInfo;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

     static InventoryConfiguration parseInventoryConfigurationElem(Element configElem) {
        InventoryConfiguration inventoryConfiguration = new InventoryConfiguration();

        if (configElem.getChildText("Id") != null) {
            inventoryConfiguration.setInventoryId(configElem.getChildText("Id"));
        }

        if (configElem.getChildText("IncludedObjectVersions") != null) {
            inventoryConfiguration.setIncludedObjectVersions(configElem.getChildText("IncludedObjectVersions"));
        }

        if (configElem.getChildText("IsEnabled") != null) {
            inventoryConfiguration.setEnabled(bool.valueOf(configElem.getChildText("IsEnabled")));
        }

        if (configElem.getChild("Filter") != null) {
            Element elem = configElem.getChild("Filter");
            if (elem.getChildText("Prefix") != null) {
                InventoryFilter filter = new InventoryFilter().withPrefix(elem.getChildText("Prefix"));
                inventoryConfiguration.setInventoryFilter(filter);
            }
        }

        if (configElem.getChild("Schedule") != null) {
            InventorySchedule schedule = new InventorySchedule();
            Element elem = configElem.getChild("Schedule");
            if (elem.getChild("Frequency") != null) {
                schedule.setFrequency(elem.getChildText("Frequency"));
                inventoryConfiguration.setSchedule(schedule);
            }
        }

        if (configElem.getChild("OptionalFields") != null) {
            Element OptionalFieldsElem = configElem.getChild("OptionalFields");
            List<String> optionalFields = [];
            List<Element> fieldElems = OptionalFieldsElem.getChildren("Field");
            for (Element e : fieldElems) {
                optionalFields.add(e.getText());
            }
            inventoryConfiguration.setOptionalFields(optionalFields);
        }

        if (configElem.getChild("Destination") != null) {
            InventoryDestination destination = new InventoryDestination();
            Element destinElem = configElem.getChild("Destination");
            if (destinElem.getChild("OSSBucketDestination") != null) {
                InventoryOSSBucketDestination ossBucketDestion = new InventoryOSSBucketDestination();
                Element bucketDistinElem = destinElem.getChild("OSSBucketDestination");
                if (bucketDistinElem.getChildText("Format") != null) {
                    ossBucketDestion.setFormat(bucketDistinElem.getChildText("Format"));
                }
                if (bucketDistinElem.getChildText("AccountId") != null) {
                    ossBucketDestion.setAccountId(bucketDistinElem.getChildText("AccountId"));
                }
                if (bucketDistinElem.getChildText("RoleArn") != null) {
                    ossBucketDestion.setRoleArn(bucketDistinElem.getChildText("RoleArn"));
                }
                if (bucketDistinElem.getChildText("Bucket") != null) {
                    String tmpBucket = bucketDistinElem.getChildText("Bucket");
                    String bucket = tmpBucket.replaceFirst("acs:oss:::", "");
                    ossBucketDestion.setBucket(bucket);
                }
                if (bucketDistinElem.getChildText("Prefix") != null) {
                    ossBucketDestion.setPrefix(bucketDistinElem.getChildText("Prefix"));
                }

                if (bucketDistinElem.getChild("Encryption") != null) {
                    InventoryEncryption inventoryEncryption = new InventoryEncryption();
                    if (bucketDistinElem.getChild("Encryption").getChild("SSE-KMS") != null) {
                        String keyId = bucketDistinElem.getChild("Encryption").getChild("SSE-KMS").getChildText("KeyId");
                        inventoryEncryption.setServerSideKmsEncryption(new InventoryServerSideEncryptionKMS().withKeyId(keyId));
                    } else if (bucketDistinElem.getChild("Encryption").getChild("SSE-OSS") != null) {
                        inventoryEncryption.setServerSideOssEncryption(new InventoryServerSideEncryptionOSS());
                    }
                    ossBucketDestion.setEncryption(inventoryEncryption);
                }
                destination.setOssBucketDestination(ossBucketDestion);
            }
            inventoryConfiguration.setDestination(destination);
        }

        return inventoryConfiguration;
    }


    /**
     * Unmarshall get bucuket inventory configuration response body to GetBucketInventoryConfigurationResult.
     */
     static GetBucketInventoryConfigurationResult parseGetBucketInventoryConfig(InputStream responseBody)
            {
        try {
            GetBucketInventoryConfigurationResult result = new GetBucketInventoryConfigurationResult();
            Element root = getXmlRootElement(responseBody);
            InventoryConfiguration configuration = parseInventoryConfigurationElem(root);
            result.setInventoryConfiguration(configuration);
            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }


    /**
     * Unmarshall get bucuket qos info response body to BucketQosInfo.
     */
     static ListBucketInventoryConfigurationsResult parseListBucketInventoryConfigurations(InputStream responseBody)
            {
        try {
            Element root = getXmlRootElement(responseBody);
            ListBucketInventoryConfigurationsResult result = new ListBucketInventoryConfigurationsResult();
            List<InventoryConfiguration> inventoryConfigurationList = null;

            if (root.getChild("InventoryConfiguration") != null) {
                inventoryConfigurationList = [];
                List<Element> configurationElems = root.getChildren("InventoryConfiguration");
                for (Element elem : configurationElems) {
                    InventoryConfiguration configuration = parseInventoryConfigurationElem(elem);
                    inventoryConfigurationList.add(configuration);
                }
                result.setInventoryConfigurationList(inventoryConfigurationList);
            }

            if (root.getChild("ContinuationToken") != null) {
                result.setContinuationToken(root.getChildText("ContinuationToken"));
            }

            if (root.getChild("IsTruncated") != null) {
                result.setTruncated(bool.valueOf(root.getChildText("IsTruncated")));
            }

            if (root.getChild("NextContinuationToken") != null) {
                result.setNextContinuationToken(root.getChildText("NextContinuationToken"));
            }

            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket lifecycle response body to lifecycle rules.
     */
    
     static List<LifecycleRule> parseGetBucketLifecycle(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            List<LifecycleRule> lifecycleRules = [];
            List<Element> ruleElements = root.getChildren("Rule");

            for (Element ruleElem : ruleElements) {
                LifecycleRule rule = new LifecycleRule();

                if (ruleElem.getChild("ID") != null) {
                    rule.setId(ruleElem.getChildText("ID"));
                }

                if (ruleElem.getChild("Prefix") != null) {
                    rule.setPrefix(ruleElem.getChildText("Prefix"));
                }
                
                List<Element> tagElems = ruleElem.getChildren("Tag");
                if (tagElems != null) {
                    for (Element tagElem : tagElems) {
                        String key = null;
                        String value = null;
                        
                        if (tagElem.getChild("Key") != null) {
                            key = tagElem.getChildText("Key");
                        }
                        if (tagElem.getChild("Value") != null) {
                            value = tagElem.getChildText("Value");
                        }
                        
                        rule.addTag(key, value);
                    }
                }

                if (ruleElem.getChild("Status") != null) {
                    rule.setStatus(RuleStatus.valueOf(ruleElem.getChildText("Status")));
                }

                if (ruleElem.getChild("Expiration") != null) {
                    if (ruleElem.getChild("Expiration").getChild("Date") != null) {
                        Date expirationDate = DateUtil
                                .parseIso8601Date(ruleElem.getChild("Expiration").getChildText("Date"));
                        rule.setExpirationTime(expirationDate);
                    } else if (ruleElem.getChild("Expiration").getChild("Days") != null) {
                        rule.setExpirationDays(Integer.parseInt(ruleElem.getChild("Expiration").getChildText("Days")));
                    }  else if (ruleElem.getChild("Expiration").getChild("CreatedBeforeDate") != null) {
                        Date createdBeforeDate = DateUtil
                                .parseIso8601Date(ruleElem.getChild("Expiration").getChildText("CreatedBeforeDate"));
                        rule.setCreatedBeforeDate(createdBeforeDate);
                    } else if (ruleElem.getChild("Expiration").getChild("ExpiredObjectDeleteMarker") != null) {
                        rule.setExpiredDeleteMarker(bool.valueOf(ruleElem.getChild("Expiration").getChildText("ExpiredObjectDeleteMarker")));
                    }
                }

                if (ruleElem.getChild("AbortMultipartUpload") != null) {
                    LifecycleRule.AbortMultipartUpload abortMultipartUpload = new LifecycleRule.AbortMultipartUpload();
                    if (ruleElem.getChild("AbortMultipartUpload").getChild("Days") != null) {
                        abortMultipartUpload.setExpirationDays(
                                Integer.parseInt(ruleElem.getChild("AbortMultipartUpload").getChildText("Days")));
                    } else {
                        Date createdBeforeDate = DateUtil.parseIso8601Date(
                                ruleElem.getChild("AbortMultipartUpload").getChildText("CreatedBeforeDate"));
                        abortMultipartUpload.setCreatedBeforeDate(createdBeforeDate);
                    }
                    rule.setAbortMultipartUpload(abortMultipartUpload);
                }

                List<Element> transitionElements = ruleElem.getChildren("Transition");
                List<StorageTransition> storageTransitions = [];
                for (Element transitionElem : transitionElements) {
                    LifecycleRule.StorageTransition storageTransition = new LifecycleRule.StorageTransition();
                    if (transitionElem.getChild("Days") != null) {
                        storageTransition.setExpirationDays(Integer.parseInt(transitionElem.getChildText("Days")));
                    } else {
                        Date createdBeforeDate = DateUtil
                                .parseIso8601Date(transitionElem.getChildText("CreatedBeforeDate"));
                        storageTransition.setCreatedBeforeDate(createdBeforeDate);
                    }
                    if (transitionElem.getChild("StorageClass") != null) {
                        storageTransition
                                .setStorageClass(StorageClass.parse(transitionElem.getChildText("StorageClass")));
                    }
                    storageTransitions.add(storageTransition);
                }
                rule.setStorageTransition(storageTransitions);

                if (ruleElem.getChild("NoncurrentVersionExpiration") != null) {
                    NoncurrentVersionExpiration expiration = new NoncurrentVersionExpiration();
                    if (ruleElem.getChild("NoncurrentVersionExpiration").getChild("NoncurrentDays") != null) {
                        expiration.setNoncurrentDays(Integer.parseInt(ruleElem.getChild("NoncurrentVersionExpiration").getChildText("NoncurrentDays")));
                        rule.setNoncurrentVersionExpiration(expiration);
                    }
                }

                List<Element> versionTansitionElements = ruleElem.getChildren("NoncurrentVersionTransition");
                List<NoncurrentVersionStorageTransition> noncurrentVersionTransitions = [];
                for (Element transitionElem : versionTansitionElements) {
                    NoncurrentVersionStorageTransition transition = new NoncurrentVersionStorageTransition();
                    if (transitionElem.getChild("NoncurrentDays") != null) {
                        transition.setNoncurrentDays(Integer.parseInt(transitionElem.getChildText("NoncurrentDays")));
                    }
                    if (transitionElem.getChild("StorageClass") != null) {
                        transition.setStorageClass(StorageClass.parse(transitionElem.getChildText("StorageClass")));
                    }
                    noncurrentVersionTransitions.add(transition);
                }
                rule.setNoncurrentVersionStorageTransitions(noncurrentVersionTransitions);

                lifecycleRules.add(rule);
            }

            return lifecycleRules;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall get bucket cname response body to cname configuration.
     */
    
     static List<CnameConfiguration> parseGetBucketCname(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            List<CnameConfiguration> cnames = [];
            List<Element> cnameElements = root.getChildren("Cname");

            for (Element cnameElem : cnameElements) {
                CnameConfiguration cname = new CnameConfiguration();

                cname.setDomain(cnameElem.getChildText("Domain"));
                cname.setStatus(CnameConfiguration.CnameStatus.valueOf(cnameElem.getChildText("Status")));
                cname.setLastMofiedTime(DateUtil.parseIso8601Date(cnameElem.getChildText("LastModified")));

                if (cnameElem.getChildText("IsPurgeCdnCache") != null) {
                    bool purgeCdnCache = bool.valueOf(cnameElem.getChildText("IsPurgeCdnCache"));
                    cname.setPurgeCdnCache(purgeCdnCache);
                }

                Element certElem = cnameElem.getChild("Certificate");
                if (certElem != null) {
                    cname.setCertType(CnameConfiguration.CertType.parse(certElem.getChildText("Type")));
                    cname.setCertStatus(CnameConfiguration.CertStatus.parse(certElem.getChildText("Status")));
                    cname.setCertId(certElem.getChildText("CertId"));
                }

                cnames.add(cname);
            }

            return cnames;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

    /**
     * Unmarshall set async fetch task response body to corresponding result.
     */
     static SetAsyncFetchTaskResult parseSetAsyncFetchTaskResult(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            SetAsyncFetchTaskResult setAsyncFetchTaskResult = new SetAsyncFetchTaskResult();
            setAsyncFetchTaskResult.setTaskId(root.getChildText("TaskId"));
            return setAsyncFetchTaskResult;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }

     static AsyncFetchTaskConfiguration parseAsyncFetchTaskInfo(Element taskInfoEle) {
        if (taskInfoEle == null) {
            return null;
        }

        AsyncFetchTaskConfiguration configuration = new AsyncFetchTaskConfiguration();
        configuration.setUrl(taskInfoEle.getChildText("Url"));
        configuration.setObjectName(taskInfoEle.getChildText("Object"));
        configuration.setHost(taskInfoEle.getChildText("Host"));
        configuration.setContentMd5(taskInfoEle.getChildText("ContentMD5"));
        configuration.setCallback(taskInfoEle.getChildText("Callback"));
        if (taskInfoEle.getChild("IgnoreSameKey") != null) {
            configuration.setIgnoreSameKey(bool.valueOf(taskInfoEle.getChildText("IgnoreSameKey")));
        }

        return configuration;
    }

    /**
     * Unmarshall get async fetch task info response body to corresponding result.
     */
     static GetAsyncFetchTaskResult parseGetAsyncFetchTaskResult(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            GetAsyncFetchTaskResult getAsyncFetchTaskResult = new GetAsyncFetchTaskResult();

            getAsyncFetchTaskResult.setTaskId(root.getChildText("TaskId"));
            getAsyncFetchTaskResult.setAsyncFetchTaskState(AsyncFetchTaskState.parse(root.getChildText("State")));
            getAsyncFetchTaskResult.setErrorMsg(root.getChildText("ErrorMsg"));
            AsyncFetchTaskConfiguration configuration = parseAsyncFetchTaskInfo(root.getChild("TaskInfo"));
            getAsyncFetchTaskResult.setAsyncFetchTaskConfiguration(configuration);

            return getAsyncFetchTaskResult;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }
    }


    

    /**
     * Unmarshall image Vpcip response body to style list.
     */
     static Vpcip parseGetCreateVpcipResult(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            Vpcip vpcip = new Vpcip();

            if (root.getChild("Region") != null) {
                vpcip.setRegion(root.getChildText("Region"));
            }
            if (root.getChild("VpcId") != null) {
                vpcip.setVpcId(root.getChildText("VpcId"));
            }
            if (root.getChild("Vip") != null) {
                vpcip.setVip(root.getChildText("Vip"));
            }
            if (root.getChild("Label") != null) {
                vpcip.setLabel(root.getChildText("Label"));
            }

            return vpcip;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall list image Vpcip response body to style list.
     */
    
     static List<Vpcip> parseListVpcipResult(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);

            List<Vpcip> vpcipList = [];
            List<Element> vpcips = root.getChildren("Vpcip");

            for (Element e : vpcips) {
                Vpcip vpcipInfo = new Vpcip();
                vpcipInfo.setRegion(e.getChildText("Region"));
                vpcipInfo.setVpcId(e.getChildText("VpcId"));
                vpcipInfo.setVip(e.getChildText("Vip"));
                vpcipInfo.setLabel(e.getChildText("Label"));
                vpcipList.add(vpcipInfo);
            }

            return vpcipList;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall list image VpcPolicy response body to style list.
     */
    
     static List<VpcPolicy> parseListVpcPolicyResult(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            List<VpcPolicy> vpcipList = [];
            List<Element> vpcips = root.getChildren("Vpcip");

            for (Element e : vpcips) {
                VpcPolicy vpcipInfo = new VpcPolicy();

                vpcipInfo.setRegion(e.getChildText("Region"));
                vpcipInfo.setVpcId(e.getChildText("VpcId"));
                vpcipInfo.setVip(e.getChildText("Vip"));
                vpcipList.add(vpcipInfo);
            }

            return vpcipList;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall initiate bucket worm result from response headers.
     */
     static InitiateBucketWormResult parseInitiateBucketWormResponseHeader(Map<String, String> headers) {

        try {
            InitiateBucketWormResult result = new InitiateBucketWormResult();
            result.setWormId(headers.GET(OSS_HEADER_WORM_ID));
            return result;
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }

    /**
     * Unmarshall get bucket worm result.
     */
     static GetBucketWormResult parseWormConfiguration(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            GetBucketWormResult result = new GetBucketWormResult();
            result.setWormId(root.getChildText("WormId"));
            result.setWormState(root.getChildText("State"));
            result.setRetentionPeriodInDays(Integer.parseInt(root.getChildText("RetentionPeriodInDays")));
            result.setCreationDate(DateUtil.parseIso8601Date(root.getChildText("CreationDate")));
            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }



    /**
     * Unmarshall delete directory result.
     */
     static DeleteDirectoryResult parseDeleteDirectoryResult(InputStream responseBody) {
        try {
            Element root = getXmlRootElement(responseBody);
            DeleteDirectoryResult result = new DeleteDirectoryResult();
            result.setDeleteNumber(Integer.valueOf(root.getChildText("DeleteNumber")).intValue());
            result.setDirectoryName(root.getChildText("DirectoryName"));
            if(root.getChild("NextDeleteToken") != null) {
                result.setNextDeleteToken(root.getChildText("NextDeleteToken"));
            }
            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": $e");
        } catch ( e) {
            throw new ResponseParseException(e);
        }

    }

    /**
     * Unmarshall get bucket resource group.
     */
     static GetBucketResourceGroupResult parseResourceGroupConfiguration(InputStream responseBody) {

        try {
            Element root = getXmlRootElement(responseBody);
            GetBucketResourceGroupResult result = new GetBucketResourceGroupResult();
            result.setResourceGroupId(root.getChildText("ResourceGroupId"));
            return result;
        } catch (JDOMParseException e) {
            throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ResponseParseException(e.getMessage(), e);
        }

    }
}

     class GetBucketTransferAccelerationResponseParser implements ResponseParser<TransferAcceleration> {
        @override
         TransferAcceleration parse(ResponseMessage response) {
            try {
                TransferAcceleration result = parseTransferAcceleration(response.content);
                result.requestId = response.getRequestId();

                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

         TransferAcceleration parseTransferAcceleration(InputStream inputStream) {
            TransferAcceleration transferAcceleration = new TransferAcceleration(false);
            if (inputStream == null) {
                return transferAcceleration;
            }

            try {
                Element root = getXmlRootElement(inputStream);

                if (root.getChildText("Enabled") != null) {
                    transferAcceleration.setEnabled(bool.valueOf(root.getChildText("Enabled")));
                }

                return transferAcceleration;
            } catch (JDOMParseException e) {
                throw new ResponseParseException(e.getPartialDocument() + ": " + e.getMessage(), e);
            } catch (Exception e) {
                throw new ResponseParseException(e.getMessage(), e);
            }
        }
    }




class EmptyResponseParser implements ResponseParser<ResponseMessage> {

        @override
         ResponseMessage parse(ResponseMessage response) {
            // Close response and return it directly without parsing.
            safeCloseResponse(response);
            return response;
        }

    }

     class RequestIdResponseParser implements ResponseParser<VoidResult> {

        @override
         VoidResult parse(ResponseMessage response) {
            try{
                VoidResult result = new VoidResult();
                result.response = response;
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class ListBucketResponseParser implements ResponseParser<BucketList> {

        @override
         BucketList parse(ResponseMessage response) {
            try {
                BucketList result = parseListBucket(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class ListImageStyleResponseParser implements ResponseParser<List<Style>> {
        @override
         List<Style> parse(ResponseMessage response) {
            try {
                return parseListImageStyle(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }
    }

     class GetBucketRefererResponseParser implements ResponseParser<BucketReferer> {

        @override
         BucketReferer parse(ResponseMessage response) {
            try {
                BucketReferer result = parseGetBucketReferer(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketAclResponseParser implements ResponseParser<AccessControlList> {

        @override
         AccessControlList parse(ResponseMessage response) {
            try {
                AccessControlList result = parseGetBucketAcl(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }
	
     class GetBucketMetadataResponseParser implements ResponseParser<BucketMetadata> {

        @override
         BucketMetadata parse(ResponseMessage response) {
            try {
                return parseBucketMetadata(response.headers);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketLocationResponseParser implements ResponseParser<String> {

        @override
         String parse(ResponseMessage response) {
            try {
                return parseGetBucketLocation(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketLoggingResponseParser implements ResponseParser<BucketLoggingResult> {

        @override
         BucketLoggingResult parse(ResponseMessage response) {
            try {
                BucketLoggingResult result = parseBucketLogging(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketImageResponseParser implements ResponseParser<GetBucketImageResult> {
        @override
         GetBucketImageResult parse(ResponseMessage response) {
            try {
                return parseBucketImage(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }
    }

     class GetImageStyleResponseParser implements ResponseParser<GetImageStyleResult> {
        @override
         GetImageStyleResult parse(ResponseMessage response) {
            try {
                return parseImageStyle(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }
    }

     class GetBucketImageProcessConfResponseParser implements ResponseParser<BucketProcess> {

        @override
         BucketProcess parse(ResponseMessage response) {
            try {
                BucketProcess result = parseGetBucketImageProcessConf(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketWebsiteResponseParser implements ResponseParser<BucketWebsiteResult> {

        @override
         BucketWebsiteResult parse(ResponseMessage response) {
            try {
                BucketWebsiteResult result = parseBucketWebsite(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketLifecycleResponseParser implements ResponseParser<List<LifecycleRule>> {

        @override
         List<LifecycleRule> parse(ResponseMessage response) {
            try {
                return parseGetBucketLifecycle(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class AddBucketCnameResponseParser implements ResponseParser<AddBucketCnameResult> {
        @override
         AddBucketCnameResult parse(ResponseMessage response) {
            try {
                AddBucketCnameResult result = new AddBucketCnameResult();
                result.certId = response.headers[OSSHeaders.OSS_HEADER_CERT_ID];
                result.requestId = response.getRequestId();
                result.response = response;
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }
    }

     class GetBucketCnameResponseParser implements ResponseParser<List<CnameConfiguration>> {

        @override
         List<CnameConfiguration> parse(ResponseMessage response) {
            try {
                return parseGetBucketCname(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketInfoResponseParser implements ResponseParser<BucketInfo> {

        @override
         BucketInfo parse(ResponseMessage response) {
            try {
                BucketInfo result = parseGetBucketInfo(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketStatResponseParser implements ResponseParser<BucketStat> {

        @override
         BucketStat parse(ResponseMessage response) {
            try {
                BucketStat result = parseGetBucketStat(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketQosResponseParser implements ResponseParser<UserQos> {

        @override
         UserQos parse(ResponseMessage response) {
            try {
                UserQos result = parseGetUserQos(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }
    
     class GetBucketVersioningResponseParser
        implements ResponseParser<BucketVersioningConfiguration> {

        @override
         BucketVersioningConfiguration parse(ResponseMessage response) {
            try {
                BucketVersioningConfiguration result = parseGetBucketVersioning(response.content);
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketEncryptionResponseParser
    implements ResponseParser<ServerSideEncryptionConfiguration> {
    	
    	@override
    	 ServerSideEncryptionConfiguration parse(ResponseMessage response) {
    		try {
    			ServerSideEncryptionConfiguration result = parseGetBucketEncryption(response.content);
    			return result;
    		} finally {
    			safeCloseResponse(response);
    		}
    	}

    }

     class GetBucketPolicyResponseParser implements ResponseParser<GetBucketPolicyResult> {
    	
        @override
         GetBucketPolicyResult parse(ResponseMessage response) {
        	try {
        		GetBucketPolicyResult result = parseGetBucketPolicy(response.content);
        		result.requestId = response.getRequestId();
        		return result;
        	} finally {
        		safeCloseResponse(response);
        	}
        }

    }

     class GetBucketRequestPaymentResponseParser implements ResponseParser<GetBucketRequestPaymentResult> {

        @override
         GetBucketRequestPaymentResult parse(ResponseMessage response) {
            try {
            	GetBucketRequestPaymentResult result = parseGetBucketRequestPayment(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetUSerQosInfoResponseParser implements ResponseParser<UserQosInfo> {

        @override
         UserQosInfo parse(ResponseMessage response) {
            try {
                UserQosInfo result = parseGetUserQosInfo(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketQosInfoResponseParser implements ResponseParser<BucketQosInfo> {

        @override
         BucketQosInfo parse(ResponseMessage response) {
            try {
                BucketQosInfo result = parseGetBucketQosInfo(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class SetAsyncFetchTaskResponseParser implements ResponseParser<SetAsyncFetchTaskResult> {

        @override
         SetAsyncFetchTaskResult parse(ResponseMessage response) {
            try {
                SetAsyncFetchTaskResult result = parseSetAsyncFetchTaskResult(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetAsyncFetchTaskResponseParser implements ResponseParser<GetAsyncFetchTaskResult> {

        @override
         GetAsyncFetchTaskResult parse(ResponseMessage response) {
            try {
                GetAsyncFetchTaskResult result = parseGetAsyncFetchTaskResult(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketInventoryConfigurationParser implements ResponseParser<GetBucketInventoryConfigurationResult> {

        @override
         GetBucketInventoryConfigurationResult parse(ResponseMessage response) {
            try {
                GetBucketInventoryConfigurationResult result = parseGetBucketInventoryConfig(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class ListBucketInventoryConfigurationsParser implements ResponseParser<ListBucketInventoryConfigurationsResult> {

        @override
         ListBucketInventoryConfigurationsResult parse(ResponseMessage response) {
            try {
                ListBucketInventoryConfigurationsResult result = parseListBucketInventoryConfigurations(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class CreateLiveChannelResponseParser implements ResponseParser<CreateLiveChannelResult> {

        @override
         CreateLiveChannelResult parse(ResponseMessage response) {
            try {
                CreateLiveChannelResult result = parseCreateLiveChannel(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetLiveChannelInfoResponseParser implements ResponseParser<LiveChannelInfo> {

        @override
         LiveChannelInfo parse(ResponseMessage response) {
            try {
                LiveChannelInfo result = parseGetLiveChannelInfo(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetLiveChannelStatResponseParser implements ResponseParser<LiveChannelStat> {

        @override
         LiveChannelStat parse(ResponseMessage response) {
            try {
                LiveChannelStat result = parseGetLiveChannelStat(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetLiveChannelHistoryResponseParser implements ResponseParser<List<LiveRecord>> {

        @override
         List<LiveRecord> parse(ResponseMessage response) {
            try {
                return parseGetLiveChannelHistory(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class ListLiveChannelsReponseParser implements ResponseParser<LiveChannelListing> {

        @override
         LiveChannelListing parse(ResponseMessage response) {
            try {
                return parseListLiveChannels(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketCorsResponseParser implements ResponseParser<CORSConfiguration> {

        @override
         CORSConfiguration parse(ResponseMessage response) {
            try {
                return parseListBucketCORS(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetTaggingResponseParser implements ResponseParser<TagSet> {

        @override
         TagSet parse(ResponseMessage response) {
            try {
                TagSet result = parseGetBucketTagging(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketReplicationResponseParser implements ResponseParser<List<ReplicationRule>> {

        @override
         List<ReplicationRule> parse(ResponseMessage response) {
            try {
                return parseGetBucketReplication(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketReplicationProgressResponseParser
            implements ResponseParser<BucketReplicationProgress> {

        @override
         BucketReplicationProgress parse(ResponseMessage response) {
            try {
                BucketReplicationProgress result = parseGetBucketReplicationProgress(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketReplicationLocationResponseParser implements ResponseParser<List<String>> {

        @override
         List<String> parse(ResponseMessage response) {
            try {
                return parseGetBucketReplicationLocation(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class ListObjectsReponseParser implements ResponseParser<ObjectListing> {

        @override
         ObjectListing parse(ResponseMessage response) {
            try {
                ObjectListing result = parseListObjects(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class ListObjectsV2ResponseParser implements ResponseParser<ListObjectsV2Result> {

        @override
         ListObjectsV2Result parse(ResponseMessage response) {
            try {
                ListObjectsV2Result result = parseListObjectsV2(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }
    
     class ListVersionsReponseParser implements ResponseParser<VersionListing> {

        @override
         VersionListing parse(ResponseMessage response) {
            try {
                VersionListing result = parseListVersions(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class PutObjectReponseParser implements ResponseParser<PutObjectResult> {

        @override
         PutObjectResult parse(ResponseMessage response) {
            PutObjectResult result = new PutObjectResult();
            try {
                result.setETag(trimQuotes(response.headers[OSSHeaders.ETAG))];
                result.setVersionId(response.headers[OSSHeaders.OSS_HEADER_VERSION_ID)];
                result.requestId = response.getRequestId();
                setCRC(result, response);
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class PutObjectProcessReponseParser implements ResponseParser<PutObjectResult> {

        @override
         PutObjectResult parse(ResponseMessage response) {
            PutObjectResult result = new PutObjectResult();
            result.requestId = response.getRequestId();
            result.setETag(trimQuotes(response.headers[OSSHeaders.ETAG]));
            result.setVersionId(response.headers[OSSHeaders.ossHeaderVersionId]);
            result.setCallbackResponseBody(response.content);
            result.response = response;
            return result;
        }

    }

     class AppendObjectResponseParser implements ResponseParser<AppendObjectResult> {

        @override
         AppendObjectResult parse(ResponseMessage response) {
            AppendObjectResult result = new AppendObjectResult();
            result.requestId = response.getRequestId();
            try {
                String nextPosition = response.headers[OSSHeaders.OSS_NEXT_APPEND_POSITION];
                if (nextPosition != null) {
                    result.setNextPosition(Long.valueOf(nextPosition));
                }
                result.setObjectCRC(response.headers[OSSHeaders.OSS_HASH_CRC64_ECMA)];
                result.response = response;
                setCRC(result, response);
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetObjectResponseParser implements ResponseParser<OSSObject> {
         String bucketName;
         String key;

         GetObjectResponseParser(final String bucketName, final String key) {
            this.bucketName = bucketName;
            this.key = key;
        }

        @override
         OSSObject parse(ResponseMessage response) {
            OSSObject ossObject = new OSSObject();
            ossObject.setBucketName(this.bucketName);
            ossObject.setKey(this.key);
            ossObject.setObjectContent(response.content);
            ossObject.setRequestId(response.getRequestId());
            ossObject.setResponse(response);
            try {
                ossObject.setObjectMetadata(parseObjectMetadata(response.headers));
                setServerCRC(ossObject, response);
                return ossObject;
            } catch (ResponseParseException e) {
                // Close response only when parsing exception thrown. Otherwise,
                // just hand over to SDK users and remain them close it when no
                // longer in use.
                safeCloseResponse(response);

                // Rethrow
                throw e;
            }
        }

    }

     class GetObjectAclResponseParser implements ResponseParser<ObjectAcl> {

        @override
         ObjectAcl parse(ResponseMessage response) {
            try {
                ObjectAcl result = parseGetObjectAcl(response.content);
                result.requestId = response.getRequestId();
                result.setVersionId(response.headers[OSSHeaders.OSS_HEADER_VERSION_ID]);
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetSimplifiedObjectMetaResponseParser implements ResponseParser<SimplifiedObjectMeta> {

        @override
         SimplifiedObjectMeta parse(ResponseMessage response) {
            try {
                return parseSimplifiedObjectMeta(response.headers);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class RestoreObjectResponseParser implements ResponseParser<RestoreObjectResult> {

        @override
         RestoreObjectResult parse(ResponseMessage response) {
            try {
                RestoreObjectResult result = new RestoreObjectResult(response.getStatusCode());
                result.requestId = response.getRequestId();
                result.setVersionId(response.headers[OSSHeaders.ossHeaderVersionId]);
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class ProcessObjectResponseParser implements ResponseParser<GenericResult> {

        @override
         GenericResult parse(ResponseMessage response) {
            GenericResult result = new PutObjectResult();
            result.requestId = response.getRequestId();
            result.response = response;
            return result;
        }

    }

     class GetObjectMetadataResponseParser implements ResponseParser<ObjectMetadata> {

        @override
         ObjectMetadata parse(ResponseMessage response) {
            try {
                return parseObjectMetadata(response.headers);
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class HeadObjectResponseParser implements ResponseParser<ObjectMetadata> {

        @override
         ObjectMetadata parse(ResponseMessage response) {
            try {
                return parseObjectMetadata(response.headers);
            } finally {
                safeCloseResponse(response);
            }
        }
    }

     class CopyObjectResponseParser implements ResponseParser<CopyObjectResult> {

        @override
         CopyObjectResult parse(ResponseMessage response) {
            try {
                CopyObjectResult result = parseCopyObjectResult(response.content);
                result.setVersionId(response.headers[OSSHeaders.ossHeaderVersionId]);
                result.requestId = response.getRequestId();
                result.response = response;
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class DeleteObjectsResponseParser implements ResponseParser<DeleteObjectsResult> {

        @override
         DeleteObjectsResult parse(ResponseMessage response) {
            try {
                DeleteObjectsResult result = null;

                // Occurs when deleting multiple objects in quiet mode.
                if (response.getContentLength() == 0) {
                    result = new DeleteObjectsResult(null);
                } else {
                    result = parseDeleteObjectsResult(response.content);
                }
                result.requestId = response.getRequestId();

                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }
    
     class DeleteVersionsResponseParser implements ResponseParser<DeleteVersionsResult> {

        @override
         DeleteVersionsResult parse(ResponseMessage response) {
            try {
                DeleteVersionsResult result = null;

                // Occurs when deleting multiple objects in quiet mode.
                if (response.getContentLength() == 0) {
                    result = new DeleteVersionsResult([]);
                } else {
                    result = parseDeleteVersionsResult(response.content);
                }
                result.requestId = response.getRequestId();

                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class CompleteMultipartUploadResponseParser
            implements ResponseParser<CompleteMultipartUploadResult> {

        @override
         CompleteMultipartUploadResult parse(ResponseMessage response) {
            try {
                CompleteMultipartUploadResult result = parseCompleteMultipartUpload(response.content);
                result.setVersionId(response.headers[OSSHeaders.OSS_HEADER_VERSION_ID]);
                result.requestId = response.getRequestId();
                setServerCRC(result, response);
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class CompleteMultipartUploadProcessResponseParser
            implements ResponseParser<CompleteMultipartUploadResult> {

        @override
         CompleteMultipartUploadResult parse(ResponseMessage response) {
            CompleteMultipartUploadResult result = new CompleteMultipartUploadResult();
            result.setVersionId(response.headers[OSSHeaders.OSS_HEADER_VERSION_ID)];
            result.requestId = response.getRequestId();
            result.setCallbackResponseBody(response.content);
            result.response = response;
            return result;
        }

    }

     class InitiateMultipartUploadResponseParser
            implements ResponseParser<InitiateMultipartUploadResult> {

        @override
         InitiateMultipartUploadResult parse(ResponseMessage response) {
            try {
                InitiateMultipartUploadResult result = parseInitiateMultipartUpload(response.content);
                result.requestId = response.getRequestId();
                result.response = response;
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class ListMultipartUploadsResponseParser implements ResponseParser<MultipartUploadListing> {

        @override
         MultipartUploadListing parse(ResponseMessage response) {
            try {
                MultipartUploadListing result = parseListMultipartUploads(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class ListPartsResponseParser implements ResponseParser<PartListing> {

        @override
         PartListing parse(ResponseMessage response) {
            try {
                PartListing result = parseListParts(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class UploadPartCopyResponseParser implements ResponseParser<UploadPartCopyResult> {

         int partNumber;

         UploadPartCopyResponseParser(int partNumber) {
            this.partNumber = partNumber;
        }

        @override
         UploadPartCopyResult parse(ResponseMessage response) {
            try {
                UploadPartCopyResult result = new UploadPartCopyResult();
                result.setPartNumber(partNumber);
                result.setETag(trimQuotes(parseUploadPartCopy(response.content)));
                result.requestId = response.getRequestId();
                result.response = response;
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetSymbolicLinkResponseParser implements ResponseParser<OSSSymlink> {

        @override
         OSSSymlink parse(ResponseMessage response) {
            try {
                OSSSymlink result = parseSymbolicLink(response);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                OSSUtils.mandatoryCloseResponse(response);
            }
        }

    }

     class InitiateBucketWormResponseParser implements ResponseParser<InitiateBucketWormResult> {

        @override
         InitiateBucketWormResult parse(ResponseMessage response) {
            try {
                InitiateBucketWormResult result = parseInitiateBucketWormResponseHeader(response.headers);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketWormResponseParser implements ResponseParser<GetBucketWormResult> {

        @override
         GetBucketWormResult parse(ResponseMessage response) {
            try {
                GetBucketWormResult result = parseWormConfiguration(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class GetBucketResourceGroupResponseParser implements ResponseParser<GetBucketResourceGroupResult> {

        @override
         GetBucketResourceGroupResult parse(ResponseMessage response) {
            try {
                GetBucketResourceGroupResult result = parseResourceGroupConfiguration(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

 class CreateVpcipResultResponseParser implements ResponseParser<Vpcip> {

        @override
         Vpcip parse(ResponseMessage response) {
            try {
                Vpcip result = parseGetCreateVpcipResult(response.content);
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }

    }

     class ListVpcipResultResponseParser implements ResponseParser<List<Vpcip>> {
        @override
         List<Vpcip> parse(ResponseMessage response) {
            try {
                return parseListVpcipResult(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }
    }

     class ListVpcPolicyResultResponseParser implements ResponseParser<List<VpcPolicy>> {
        @override
         List<VpcPolicy> parse(ResponseMessage response) {
            try {
                return parseListVpcPolicyResult(response.content);
            } finally {
                safeCloseResponse(response);
            }
        }
    }

    class DeleteDirectoryResponseParser implements ResponseParser<DeleteDirectoryResult> {

        @override
         DeleteDirectoryResult parse(ResponseMessage response) {
            try{
                DeleteDirectoryResult result =  parseDeleteDirectoryResult(response.content);
                result.response = response;
                result.requestId = response.getRequestId();
                return result;
            } finally {
                safeCloseResponse(response);
            }
        }
    }