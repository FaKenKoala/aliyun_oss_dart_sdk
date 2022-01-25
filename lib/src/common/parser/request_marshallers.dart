
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/model/add_bucket_cname_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/image_process.dart';
import 'package:aliyun_oss_dart_sdk/src/model/put_image_style_request.dart';

import 'marshaller.dart';

/**
 * A collection of marshallers that marshall HTTP request into crossponding
 * input stream.
 */
  class RequestMarshallers {

     static final StringMarshaller stringMarshaller = StringMarshaller();

     static final DeleteObjectsRequestMarshaller deleteObjectsRequestMarshaller = DeleteObjectsRequestMarshaller();
     static final DeleteVersionsRequestMarshaller deleteVersionsRequestMarshaller = DeleteVersionsRequestMarshaller();

     static final CreateBucketRequestMarshaller createBucketRequestMarshaller = CreateBucketRequestMarshaller();
     static final BucketRefererMarshaller bucketRefererMarshaller = BucketRefererMarshaller();
     static final SetBucketLoggingRequestMarshaller setBucketLoggingRequestMarshaller = SetBucketLoggingRequestMarshaller();
     static final SetBucketWebsiteRequestMarshaller setBucketWebsiteRequestMarshaller = SetBucketWebsiteRequestMarshaller();
     static final SetBucketLifecycleRequestMarshaller setBucketLifecycleRequestMarshaller = SetBucketLifecycleRequestMarshaller();
     static final PutBucketImageRequestMarshaller putBucketImageRequestMarshaller = PutBucketImageRequestMarshaller();
     static final PutImageStyleRequestMarshaller putImageStyleRequestMarshaller = PutImageStyleRequestMarshaller();
     static final BucketImageProcessConfMarshaller bucketImageProcessConfMarshaller = BucketImageProcessConfMarshaller();
     static final SetBucketCORSRequestMarshaller setBucketCORSRequestMarshaller = SetBucketCORSRequestMarshaller();
     static final SetBucketTaggingRequestMarshaller setBucketTaggingRequestMarshaller = SetBucketTaggingRequestMarshaller();
     static final AddBucketReplicationRequestMarshaller addBucketReplicationRequestMarshaller = AddBucketReplicationRequestMarshaller();
     static final DeleteBucketReplicationRequestMarshaller deleteBucketReplicationRequestMarshaller = DeleteBucketReplicationRequestMarshaller();
     static final AddBucketCnameRequestMarshaller addBucketCnameRequestMarshaller = AddBucketCnameRequestMarshaller();
     static final DeleteBucketCnameRequestMarshaller deleteBucketCnameRequestMarshaller = DeleteBucketCnameRequestMarshaller();
     static final SetBucketQosRequestMarshaller setBucketQosRequestMarshaller = SetBucketQosRequestMarshaller();
     static final CompleteMultipartUploadRequestMarshaller completeMultipartUploadRequestMarshaller = CompleteMultipartUploadRequestMarshaller();
     static final CreateLiveChannelRequestMarshaller createLiveChannelRequestMarshaller = CreateLiveChannelRequestMarshaller();
     static final CreateUdfRequestMarshaller createUdfRequestMarshaller = CreateUdfRequestMarshaller();
     static final CreateUdfApplicationRequestMarshaller createUdfApplicationRequestMarshaller = CreateUdfApplicationRequestMarshaller();
     static final UpgradeUdfApplicationRequestMarshaller upgradeUdfApplicationRequestMarshaller = UpgradeUdfApplicationRequestMarshaller();
     static final ResizeUdfApplicationRequestMarshaller resizeUdfApplicationRequestMarshaller = ResizeUdfApplicationRequestMarshaller();
     static final ProcessObjectRequestMarshaller processObjectRequestMarshaller = ProcessObjectRequestMarshaller();
     static final SetBucketVersioningRequestMarshaller setBucketVersioningRequestMarshaller = SetBucketVersioningRequestMarshaller();
     static final SetBucketEncryptionRequestMarshaller setBucketEncryptionRequestMarshaller = SetBucketEncryptionRequestMarshaller();
     static final SetBucketPolicyRequestMarshaller setBucketPolicyRequestMarshaller = SetBucketPolicyRequestMarshaller();
     static final SetBucketRequestPaymentRequestMarshaller setBucketRequestPaymentRequestMarshaller = SetBucketRequestPaymentRequestMarshaller();
     static final SetBucketQosInfoRequestMarshaller setBucketQosInfoRequestMarshaller = SetBucketQosInfoRequestMarshaller();
     static final SetAsyncFetchTaskRequestMarshaller setAsyncFetchTaskRequestMarshaller = SetAsyncFetchTaskRequestMarshaller();
     static final SetBucketInventoryRequestMarshaller setBucketInventoryRequestMarshaller = SetBucketInventoryRequestMarshaller();
     static final RestoreObjectRequestMarshaller restoreObjectRequestMarshaller = RestoreObjectRequestMarshaller();
     static final ExtendBucketWormRequestMarshaller extendBucketWormRequestMarshaller = ExtendBucketWormRequestMarshaller();
     static final InitiateBucketWormRequestMarshaller initiateBucketWormRequestMarshaller = InitiateBucketWormRequestMarshaller();

     static final CreateSelectObjectMetadataRequestMarshaller createSelectObjectMetadataRequestMarshaller = CreateSelectObjectMetadataRequestMarshaller();
     static final SelectObjectRequestMarshaller selectObjectRequestMarshaller = SelectObjectRequestMarshaller();

     static final CreateVpcipRequestMarshaller createVpcipRequestMarshaller = CreateVpcipRequestMarshaller();
     static final CreateBucketVpcipRequestMarshaller createBucketVpcipRequestMarshaller = CreateBucketVpcipRequestMarshaller();
     static final DeleteVpcipRequestMarshaller deleteVpcipRequestMarshaller = DeleteVpcipRequestMarshaller();
     static final DeleteBucketVpcipRequestMarshaller deleteBucketVpcipRequestMarshaller = DeleteBucketVpcipRequestMarshaller();

     static final SetBucketResourceGroupRequestMarshaller setBucketResourceGroupRequestMarshaller = SetBucketResourceGroupRequestMarshaller();
     static final PutBucketTransferAccelerationRequestMarshaller putBucketTransferAccelerationRequestMarshaller = PutBucketTransferAccelerationRequestMarshaller();

    
     static void populateSelectRange(StringBuffer xmlBody, SelectObjectRequest request) {
        if (request.getLineRange() != null) {
            xmlBody.write("<Range>" + request.lineRangeToString(request.getLineRange()) + "</Range>");
        }
        if (request.getSplitRange() != null) {
            xmlBody.write("<Range>" + request.splitRangeToString(request.getSplitRange()) + "</Range>");
        }
    }

     static void populateSelectJsonObjectRequest(StringBuffer xmlBody, SelectObjectRequest request) {
        InputSerialization inputSerialization = request.getInputSerialization();
        JsonFormat jsonInputFormat = inputSerialization.getJsonInputFormat();
        xmlBody.write("<InputSerialization>");
        xmlBody.write("<CompressionType>" + inputSerialization.getCompressionType() + "</CompressionType>");
        xmlBody.write("<JSON>");
        xmlBody.write("<Type>" + jsonInputFormat.getJsonType().name() + "</Type>");
        xmlBody.write("<ParseJsonNumberAsString>" + jsonInputFormat.isParseJsonNumberAsString() + "</ParseJsonNumberAsString>");
        populateSelectRange(xmlBody, request);
        xmlBody.write("</JSON>");
        xmlBody.write("</InputSerialization>");

        OutputSerialization outputSerialization = request.getOutputSerialization();
        xmlBody.write("<OutputSerialization>");
        xmlBody.write("<JSON>");
        xmlBody.write("<RecordDelimiter>" + BinaryUtil.toBase64String(outputSerialization.getJsonOutputFormat().getRecordDelimiter().getBytes()) + "</RecordDelimiter>");
        xmlBody.write("</JSON>");
        xmlBody.write("<OutputRawData>" + outputSerialization.isOutputRawData() + "</OutputRawData>");
        xmlBody.write("<EnablePayloadCrc>" + outputSerialization.isPayloadCrcEnabled() + "</EnablePayloadCrc>");
        xmlBody.write("</OutputSerialization>");
    }

     static void populateSelectCsvObjectRequest(StringBuffer xmlBody, SelectObjectRequest request) {
        InputSerialization inputSerialization = request.getInputSerialization();
        CSVFormat csvInputFormat = inputSerialization.getCsvInputFormat();
        xmlBody.write("<InputSerialization>");
        xmlBody.write("<CompressionType>" + inputSerialization.getCompressionType() + "</CompressionType>");
        xmlBody.write("<CSV>");
        xmlBody.write("<FileHeaderInfo>" + csvInputFormat.getHeaderInfo() + "</FileHeaderInfo>");
        xmlBody.write("<AllowQuotedRecordDelimiter>" + csvInputFormat.isAllowQuotedRecordDelimiter() + "</AllowQuotedRecordDelimiter>");
        xmlBody.write("<RecordDelimiter>" + BinaryUtil.toBase64String(csvInputFormat.getRecordDelimiter().getBytes()) + "</RecordDelimiter>");
        xmlBody.write("<FieldDelimiter>" + BinaryUtil.toBase64String(csvInputFormat.getFieldDelimiter().toString().getBytes()) + "</FieldDelimiter>");
        xmlBody.write("<QuoteCharacter>" + BinaryUtil.toBase64String(csvInputFormat.getQuoteChar().toString().getBytes()) + "</QuoteCharacter>");
        xmlBody.write("<CommentCharacter>" + BinaryUtil.toBase64String(csvInputFormat.getCommentChar().toString().getBytes()) + "</CommentCharacter>");
        populateSelectRange(xmlBody, request);
        xmlBody.write("</CSV>");
        xmlBody.write("</InputSerialization>");

        OutputSerialization outputSerialization = request.getOutputSerialization();
        xmlBody.write("<OutputSerialization>");
        xmlBody.write("<CSV>");
        xmlBody.write("<RecordDelimiter>" + BinaryUtil.toBase64String(outputSerialization.getCsvOutputFormat().getRecordDelimiter().getBytes()) + "</RecordDelimiter>");
        xmlBody.write("<FieldDelimiter>" + BinaryUtil.toBase64String(outputSerialization.getCsvOutputFormat().getFieldDelimiter().toString().getBytes()) + "</FieldDelimiter>");
        xmlBody.write("<QuoteCharacter>" + BinaryUtil.toBase64String(outputSerialization.getCsvOutputFormat().getQuoteChar().toString().getBytes()) + "</QuoteCharacter>");
        xmlBody.write("</CSV>");
        xmlBody.write("<KeepAllColumns>" + outputSerialization.isKeepAllColumns() + "</KeepAllColumns>");
        xmlBody.write("<OutputHeader>" + outputSerialization.isOutputHeader() + "</OutputHeader>");
        xmlBody.write("<OutputRawData>" + outputSerialization.isOutputRawData() + "</OutputRawData>");
        xmlBody.write("<EnablePayloadCrc>" + outputSerialization.isPayloadCrcEnabled() + "</EnablePayloadCrc>");
        xmlBody.write("</OutputSerialization>");
    }

     

     static String escapeKey(String key) {
        if (key == null) {
            return "";
        }

        int pos;
        int len = key.length();
        StringBuffer builder = StringBuffer();
        for (pos = 0; pos < len; pos++) {
            char ch = key.charAt(pos);
            EscapedChar escapedChar;
            switch (ch) {
            case '\t':
                escapedChar = EscapedChar.TAB;
                break;
            case '\n':
                escapedChar = EscapedChar.NEWLINE;
                break;
            case '\r':
                escapedChar = EscapedChar.RETURN;
                break;
            case '&':
                escapedChar = EscapedChar.AMP;
                break;
            case '"':
                escapedChar = EscapedChar.QUOT;
                break;
            case '<':
                escapedChar = EscapedChar.LT;
                break;
            case '>':
                escapedChar = EscapedChar.GT;
                break;
            default:
                escapedChar = null;
                break;
            }

            if (escapedChar != null) {
                builder.write(escapedChar.toString());
            } else {
                builder.write(ch);
            }
        }

        return builder.toString();
    }

     static String joinRepliationAction(List<ReplicationAction> actions) {
        StringBuffer sb = StringBuffer();
        bool first = true;

        for (ReplicationAction action in actions) {
            if (!first) {
                sb.write(",");
            }
            sb.write(action);

            first = false;
        }

        return sb.toString();
    }

}


     class SelectObjectRequestMarshaller implements RequestMarshaller2<SelectObjectRequest> {

        @override
         List<int> marshall(SelectObjectRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<SelectRequest>");

            xmlBody.write("<Expression>" + BinaryUtil.toBase64String(request.getExpression().getBytes()) + "</Expression>");
            xmlBody.write("<Options>");
            xmlBody.write("<SkipPartialDataRecord>" + request.isSkipPartialDataRecord() + "</SkipPartialDataRecord>");
            if (request.getMaxSkippedRecordsAllowed() > 0) {
                xmlBody.write("<MaxSkippedRecordsAllowed>" + request.getMaxSkippedRecordsAllowed() + "</MaxSkippedRecordsAllowed>");
            }
            xmlBody.write("</Options>");
            InputSerialization inputSerialization = request.getInputSerialization();
            SelectContentFormat selectContentFormat = inputSerialization.getSelectContentFormat();

            if (selectContentFormat == SelectContentFormat.JSON) {
                populateSelectJsonObjectRequest(xmlBody, request);
            } else {
                populateSelectCsvObjectRequest(xmlBody, request);
            }

            xmlBody.write("</SelectRequest>");

            try {
                return xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
        }
    }

     class DeleteObjectsRequestMarshaller implements RequestMarshaller2<DeleteObjectsRequest> {

        @override
         List<int> marshall(DeleteObjectsRequest request) {
            StringBuffer xmlBody = StringBuffer();
            bool quiet = request.isQuiet();
            List<String> keysToDelete = request.getKeys();

            xmlBody.write("<Delete>");
            xmlBody.write("<Quiet>" + quiet + "</Quiet>");
            for (int i = 0; i < keysToDelete.size(); i++) {
                String key = keysToDelete.get(i);
                xmlBody.write("<Object>");
                xmlBody.write("<Key>" + escapeKey(key) + "</Key>");
                xmlBody.write("</Object>");
            }
            xmlBody.write("</Delete>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }
    
     class DeleteVersionsRequestMarshaller implements RequestMarshaller2<DeleteVersionsRequest> {

        @override
         List<int> marshall(DeleteVersionsRequest request) {
            StringBuffer xmlBody = StringBuffer();
            bool quiet = request.getQuiet();
            List<KeyVersion> keysToDelete = request.getKeys();

            xmlBody.write("<Delete>");
            xmlBody.write("<Quiet>" + quiet + "</Quiet>");
            for (int i = 0; i < keysToDelete.size(); i++) {
                KeyVersion key = keysToDelete.get(i);
                xmlBody.write("<Object>");
                xmlBody.write("<Key>" +
                    escapeKey(key.getKey()) + "</Key>");
                if (key.getVersion() != null) {
                    xmlBody.write("<VersionId>" + key.getVersion() + "</VersionId>");
                }
                xmlBody.write("</Object>");
            }
            xmlBody.write("</Delete>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class SetBucketTaggingRequestMarshaller implements RequestMarshaller<SetTaggingRequest> {

        @override
         FixedLengthInputStream marshall(SetTaggingRequest request) {
            StringBuffer xmlBody = StringBuffer();
            TagSet tagSet = request.getTagSet();
            xmlBody.write("<Tagging><TagSet>");
            Map<String, String> tags = tagSet.getAllTags();
            if (!tags.isEmpty()) {
                for (Map.Entry<String, String> tag : tags.entrySet()) {
                    xmlBody.write("<Tag>");
                    xmlBody.write("<Key>" + tag.getKey() + "</Key>");
                    xmlBody.write("<Value>" + tag.getValue() + "</Value>");
                    xmlBody.write("</Tag>");
                }
            }
            xmlBody.write("</TagSet></Tagging>");
            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class AddBucketReplicationRequestMarshaller
            implements RequestMarshaller<AddBucketReplicationRequest> {

        @override
         FixedLengthInputStream marshall(AddBucketReplicationRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<ReplicationConfiguration>");
            xmlBody.write("<Rule>");
            xmlBody.write("<ID>" + escapeKey(request.getReplicationRuleID()) + "</ID>");
            xmlBody.write("<Destination>");
            xmlBody.write("<Bucket>" + request.getTargetBucketName() + "</Bucket>");
            if (request.getTargetBucketLocation() != null) {
                xmlBody.write("<Location>" + request.getTargetBucketLocation() + "</Location>");
            } else if (request.getTargetCloud() != null && request.getTargetCloudLocation() != null) {
                xmlBody.write("<Cloud>" + request.getTargetCloud() + "</Cloud>");
                xmlBody.write("<CloudLocation>" + request.getTargetCloudLocation() + "</CloudLocation>");
            }

            xmlBody.write("</Destination>");
            if (request.isEnableHistoricalObjectReplication()) {
                xmlBody.write("<HistoricalObjectReplication>" + "enabled" + "</HistoricalObjectReplication>");
            } else {
                xmlBody.write("<HistoricalObjectReplication>" + "disabled" + "</HistoricalObjectReplication>");
            }
            if (request.getObjectPrefixList() != null && request.getObjectPrefixList().size() > 0) {
                xmlBody.write("<PrefixSet>");
                for (String prefix : request.getObjectPrefixList()) {
                    xmlBody.write("<Prefix>" + prefix + "</Prefix>");
                }
                xmlBody.write("</PrefixSet>");
            }
            if (request.getReplicationActionList() != null && request.getReplicationActionList().size() > 0) {
                xmlBody.write("<Action>" + RequestMarshallers.joinRepliationAction(request.getReplicationActionList())
                        + "</Action>");
            }

            if (request.getSyncRole() != null) {
                xmlBody.write("<SyncRole>" + request.getSyncRole() + "</SyncRole>");
            }
            if (request.getReplicaKmsKeyID() != null) {
                xmlBody.write("<EncryptionConfiguration>");
                xmlBody.write("<ReplicaKmsKeyID>" + request.getReplicaKmsKeyID() + "</ReplicaKmsKeyID>");
                xmlBody.write("</EncryptionConfiguration>");
            }
            if (request.ENABLED.equals(request.getSseKmsEncryptedObjectsStatus()) ||
                    request.DISABLED.equals(request.getSseKmsEncryptedObjectsStatus())) {
                xmlBody.write("<SourceSelectionCriteria><SseKmsEncryptedObjects>");
                xmlBody.write("<Status>" + request.getSseKmsEncryptedObjectsStatus() + "</Status>");
                xmlBody.write("</SseKmsEncryptedObjects></SourceSelectionCriteria>");
            }

            if (request.getSourceBucketLocation() != null) {
                xmlBody.write("<Source>");
                xmlBody.write("<Location>" + request.getSourceBucketLocation() + "</Location>");
                xmlBody.write("</Source>");
            }

            xmlBody.write("</Rule>");
            xmlBody.write("</ReplicationConfiguration>");
            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class DeleteBucketReplicationRequestMarshaller
            implements RequestMarshaller2<DeleteBucketReplicationRequest> {

        @override
         List<int> marshall(DeleteBucketReplicationRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<ReplicationRules>");
            xmlBody.write("<ID>" + escapeKey(request.getReplicationRuleID()) + "</ID>");
            xmlBody.write("</ReplicationRules>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class AddBucketCnameRequestMarshaller implements RequestMarshaller2<AddBucketCnameRequest> {

        @override
         List<int> marshall(AddBucketCnameRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<BucketCnameConfiguration>");
            xmlBody.write("<Cname>");
            xmlBody.write("<Domain>" + request.getDomain() + "</Domain>");

            if (request.getCertificateConfiguration() != null) {
                CertificateConfiguration certConf = request.getCertificateConfiguration();
                xmlBody.write("<CertificateConfiguration>");
                if (certConf.getId() != null) {
                    xmlBody.write("<CertId>");
                    xmlBody.write(certConf.getId());
                    xmlBody.write("</CertId>");
                }
                if (certConf.getPreviousId() != null) {
                    xmlBody.write("<PreviousCertId>");
                    xmlBody.write(escapeKey(certConf.getPreviousId()));
                    xmlBody.write("</PreviousCertId>");
                }
                if (certConf.getKey() != null) {
                    xmlBody.write("<Certificate>");
                    xmlBody.write(escapeKey(certConf.getKey()));
                    xmlBody.write("</Certificate>");
                }
                if (certConf.getKey() != null) {
                    xmlBody.write("<Key>");
                    xmlBody.write(escapeKey(certConf.getKey()));
                    xmlBody.write("</Key>");
                }
                if (certConf.isForceOverwriteCert()) {
                    xmlBody.write("<Force>true</Force>");
                }
                xmlBody.write("</CertificateConfiguration>");
            }

            xmlBody.write("</Cname>");
            xmlBody.write("</BucketCnameConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class DeleteBucketCnameRequestMarshaller
            implements RequestMarshaller2<DeleteBucketCnameRequest> {

        @override
         List<int> marshall(DeleteBucketCnameRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<BucketCnameConfiguration>");
            xmlBody.write("<Cname>");
            xmlBody.write("<Domain>" + request.getDomain() + "</Domain>");
            xmlBody.write("</Cname>");
            xmlBody.write("</BucketCnameConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class SetBucketQosRequestMarshaller implements RequestMarshaller2<UserQos> {

        @override
         List<int> marshall(UserQos userQos) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<BucketUserQos>");
            if (userQos.hasStorageCapacity()) {
                xmlBody.write("<StorageCapacity>" + userQos.getStorageCapacity() + "</StorageCapacity>");
            }
            xmlBody.write("</BucketUserQos>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }
    
     class SetBucketVersioningRequestMarshaller
        implements RequestMarshaller2<SetBucketVersioningRequest> {

        @override
         List<int> marshall(SetBucketVersioningRequest setBucketVersioningRequest) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<VersioningConfiguration>");
            xmlBody
                .write("<Status>" + setBucketVersioningRequest.getVersioningConfiguration().getStatus() + "</Status>");
            xmlBody.write("</VersioningConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class SetBucketEncryptionRequestMarshaller
    implements RequestMarshaller2<SetBucketEncryptionRequest> {

    	@override
    	 List<int> marshall(SetBucketEncryptionRequest setBucketEncryptionRequest) {
    		StringBuffer xmlBody = StringBuffer();
    		ServerSideEncryptionConfiguration sseConfig =
    				setBucketEncryptionRequest.getServerSideEncryptionConfiguration();
    		ServerSideEncryptionByDefault sseByDefault = sseConfig.getApplyServerSideEncryptionByDefault();

    		xmlBody.write("<ServerSideEncryptionRule>");
    		xmlBody.write("<ApplyServerSideEncryptionByDefault>");

    		xmlBody.write("<SSEAlgorithm>" + sseByDefault.getSSEAlgorithm() + "</SSEAlgorithm>");
    		if (sseByDefault.getKMSMasterKeyID() != null) {
    			xmlBody.write("<KMSMasterKeyID>" + sseByDefault.getKMSMasterKeyID() + "</KMSMasterKeyID>");
    		} else {
    			xmlBody.write("<KMSMasterKeyID></KMSMasterKeyID>");
    		}
            if (sseByDefault.getKMSDataEncryption() != null) {
                xmlBody.write("<KMSDataEncryption>" + sseByDefault.getKMSDataEncryption() + "</KMSDataEncryption>");
            }

    		xmlBody.write("</ApplyServerSideEncryptionByDefault>");
    		xmlBody.write("</ServerSideEncryptionRule>");

    		List<int> rawData = null;
    		try {
    			rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
    		} catch (UnsupportedEncodingException e) {
    			throw ClientException("Unsupported encoding " + e.getMessage(), e);
    		}
    		return rawData;
    	}

    }

     class SetBucketPolicyRequestMarshaller
            implements RequestMarshaller2<SetBucketPolicyRequest> {

        @override
         List<int> marshall(SetBucketPolicyRequest setBucketPolicyRequest) {

            List<int> rawData = null;
            try {
                rawData = setBucketPolicyRequest.getPolicyText().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class CreateLiveChannelRequestMarshaller
            implements RequestMarshaller2<CreateLiveChannelRequest> {

        @override
         List<int> marshall(CreateLiveChannelRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<LiveChannelConfiguration>");
            xmlBody.write("<Description>" + request.getLiveChannelDescription() + "</Description>");
            xmlBody.write("<Status>" + request.getLiveChannelStatus() + "</Status>");

            LiveChannelTarget target = request.getLiveChannelTarget();
            xmlBody.write("<Target>");
            xmlBody.write("<Type>" + target.getType() + "</Type>");
            xmlBody.write("<FragDuration>" + target.getFragDuration() + "</FragDuration>");
            xmlBody.write("<FragCount>" + target.getFragCount() + "</FragCount>");
            xmlBody.write("<PlaylistName>" + target.getPlaylistName() + "</PlaylistName>");
            xmlBody.write("</Target>");
            xmlBody.write("</LiveChannelConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class SetBucketRequestPaymentRequestMarshaller implements RequestMarshaller2<String> {

        @override
         List<int> marshall(String payer) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<RequestPaymentConfiguration>");
            xmlBody.write("<Payer>" +payer + "</Payer>");
            xmlBody.write("</RequestPaymentConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class SetBucketQosInfoRequestMarshaller implements RequestMarshaller2<BucketQosInfo> {

        @override
         List<int> marshall(BucketQosInfo bucketQosInfo) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<QoSConfiguration>");
            if (bucketQosInfo.getTotalUploadBw() != null) {
                xmlBody.write("<TotalUploadBandwidth>" +bucketQosInfo.getTotalUploadBw() + "</TotalUploadBandwidth>");
            }

            if (bucketQosInfo.getIntranetUploadBw() != null) {
                xmlBody.write("<IntranetUploadBandwidth>" +bucketQosInfo.getIntranetUploadBw() + "</IntranetUploadBandwidth>");
            }

            if (bucketQosInfo.getExtranetUploadBw() != null) {
                xmlBody.write("<ExtranetUploadBandwidth>" +bucketQosInfo.getExtranetUploadBw() + "</ExtranetUploadBandwidth>");
            }

            if (bucketQosInfo.getTotalDownloadBw() != null) {
                xmlBody.write("<TotalDownloadBandwidth>" +bucketQosInfo.getTotalDownloadBw() + "</TotalDownloadBandwidth>");
            }

            if (bucketQosInfo.getIntranetDownloadBw() != null) {
                xmlBody.write("<IntranetDownloadBandwidth>" +bucketQosInfo.getIntranetDownloadBw() + "</IntranetDownloadBandwidth>");
            }

            if (bucketQosInfo.getExtranetDownloadBw() != null) {
                xmlBody.write("<ExtranetDownloadBandwidth>" +bucketQosInfo.getExtranetDownloadBw() + "</ExtranetDownloadBandwidth>");
            }

            if (bucketQosInfo.getTotalQps() != null) {
                xmlBody.write("<TotalQps>" +bucketQosInfo.getTotalQps() + "</TotalQps>");
            }

            if (bucketQosInfo.getIntranetQps() != null) {
                xmlBody.write("<IntranetQps>" +bucketQosInfo.getIntranetQps() + "</IntranetQps>");
            }

            if (bucketQosInfo.getExtranetQps() != null) {
                xmlBody.write("<ExtranetQps>" +bucketQosInfo.getExtranetQps() + "</ExtranetQps>");
            }

            xmlBody.write("</QoSConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class SetAsyncFetchTaskRequestMarshaller implements RequestMarshaller2<AsyncFetchTaskConfiguration> {

        @override
         List<int> marshall(AsyncFetchTaskConfiguration asyncFetchTaskConfiguration) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<AsyncFetchTaskConfiguration>");

            if (asyncFetchTaskConfiguration.getUrl() != null) {
                xmlBody.write("<Url>" + escapeKey(asyncFetchTaskConfiguration.getUrl()) + "</Url>");
            }

            if (asyncFetchTaskConfiguration.getObjectName() != null) {
                xmlBody.write("<Object>" + asyncFetchTaskConfiguration.getObjectName() + "</Object>");
            }

            if (asyncFetchTaskConfiguration.getHost() != null) {
                xmlBody.write("<Host>" + asyncFetchTaskConfiguration.getHost() + "</Host>");
            }

            if (asyncFetchTaskConfiguration.getContentMd5() != null) {
                xmlBody.write("<ContentMD5>" + asyncFetchTaskConfiguration.getContentMd5() + "</ContentMD5>");
            }

            if (asyncFetchTaskConfiguration.getCallback() != null) {
                xmlBody.write("<Callback>" + asyncFetchTaskConfiguration.getCallback() + "</Callback>");
            }

            if (asyncFetchTaskConfiguration.getIgnoreSameKey() != null) {
                xmlBody.write("<IgnoreSameKey>" + asyncFetchTaskConfiguration.getIgnoreSameKey() + "</IgnoreSameKey>");
            }

            xmlBody.write("</AsyncFetchTaskConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }


     class SetBucketInventoryRequestMarshaller implements
            RequestMarshaller2<InventoryConfiguration> {
        @override
         List<int> marshall(InventoryConfiguration config) {
            StringBuffer xmlBody = StringBuffer();

            xmlBody.write("<InventoryConfiguration>");
            if (config.getInventoryId() != null) {
                xmlBody.write("<Id>" + config.getInventoryId() + "</Id>");
            }

            if(config.isEnabled() != null) {
                xmlBody.write("<IsEnabled>" + config.isEnabled() + "</IsEnabled>");
            }

            if (config.getIncludedObjectVersions() != null) {
                xmlBody.write("<IncludedObjectVersions>" + config.getIncludedObjectVersions() + "</IncludedObjectVersions>");
            }

            if (config.getInventoryFilter() != null) {
                if (config.getInventoryFilter().getPrefix() != null) {
                    xmlBody.write("<Filter>");
                    xmlBody.write("<Prefix>" +config.getInventoryFilter().getPrefix() + "</Prefix>");
                    xmlBody.write("</Filter>");
                }
            }

            if (config.getSchedule() != null) {
                xmlBody.write("<Schedule>");
                xmlBody.write("<Frequency>" + config.getSchedule().getFrequency() + "</Frequency>");
                xmlBody.write("</Schedule>");
            }

            List<String> fields = config.getOptionalFields();
            if (fields != null && !fields.isEmpty()) {
                xmlBody.write("<OptionalFields>");
                for (String field : fields) {
                    xmlBody.write("<Field>" + field + "</Field>");
                }
                xmlBody.write("</OptionalFields>");
            }

            InventoryDestination destination = config.getDestination();
            if (destination != null) {
                InventoryOSSBucketDestination bucketDestination = destination.getOssBucketDestination();
                if (bucketDestination != null) {
                    xmlBody.write("<Destination>");
                    xmlBody.write("<OSSBucketDestination>");
                    if (bucketDestination.getAccountId() != null) {
                        xmlBody.write("<AccountId>" + bucketDestination.getAccountId() + "</AccountId>");
                    }
                    if (bucketDestination.getRoleArn() != null) {
                        xmlBody.write("<RoleArn>" + bucketDestination.getRoleArn()+ "</RoleArn>");
                    }
                    if (bucketDestination.getBucket() != null) {
                        xmlBody.write("<Bucket>" + "acs:oss:::" + bucketDestination.getBucket()+ "</Bucket>");
                    }
                    if (bucketDestination.getPrefix() != null) {
                        xmlBody.write("<Prefix>" + bucketDestination.getPrefix() + "</Prefix>");
                    }
                    if (bucketDestination.getFormat() != null) {
                        xmlBody.write("<Format>" + bucketDestination.getFormat()+ "</Format>");
                    }
                    if (bucketDestination.getEncryption() != null) {
                        xmlBody.write("<Encryption>");
                        if (bucketDestination.getEncryption().getServerSideKmsEncryption() != null) {
                            xmlBody.write("<SSE-KMS>");
                            xmlBody.write("<KeyId>" + bucketDestination.getEncryption()
                                    .getServerSideKmsEncryption().getKeyId() + "</KeyId>");
                            xmlBody.write("</SSE-KMS>");
                        } else if (bucketDestination.getEncryption().getServerSideOssEncryption() != null) {
                            xmlBody.write("<SSE-OSS></SSE-OSS>");
                        }
                        xmlBody.write("</Encryption>");
                    }
                    xmlBody.write("</OSSBucketDestination>");
                    xmlBody.write("</Destination>");
                }
            }
            xmlBody.write("</InventoryConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }
    }

     class InitiateBucketWormRequestMarshaller implements
            RequestMarshaller2<InitiateBucketWormRequest> {
        @override
         List<int> marshall(InitiateBucketWormRequest request) {
            StringBuffer xmlBody = StringBuffer();

            xmlBody.write("<InitiateWormConfiguration>");
            xmlBody.write("<RetentionPeriodInDays>" + request.getRetentionPeriodInDays() + "</RetentionPeriodInDays>");
            xmlBody.write("</InitiateWormConfiguration>");
            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }
    }

     class ExtendBucketWormRequestMarshaller implements
            RequestMarshaller2<ExtendBucketWormRequest> {
        @override
         List<int> marshall(ExtendBucketWormRequest request) {
            StringBuffer xmlBody = StringBuffer();

            xmlBody.write("<ExtendWormConfiguration>");
            xmlBody.write("<RetentionPeriodInDays>" + request.getRetentionPeriodInDays()+ "</RetentionPeriodInDays>");
            xmlBody.write("</ExtendWormConfiguration>");
            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }
    }

     class SetBucketResourceGroupRequestMarshaller implements RequestMarshaller2<String> {

        @override
         List<int> marshall(String resourceGroupId) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<BucketResourceGroupConfiguration>");
            xmlBody.write("<ResourceGroupId>" + resourceGroupId + "</ResourceGroupId>");
            xmlBody.write("</BucketResourceGroupConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class CreateUdfRequestMarshaller implements RequestMarshaller2<CreateUdfRequest> {

        @override
         List<int> marshall(CreateUdfRequest request) {
            StringBuffer xmlBody = StringBuffer();

            xmlBody.write("<CreateUDFConfiguration>");
            xmlBody.write("<Name>" + request.getName() + "</Name>");
            if (request.getId() != null) {
                xmlBody.write("<ID>" + request.getId() + "</ID>");
            }
            if (request.getDesc() != null) {
                xmlBody.write("<Description>" + request.getDesc() + "</Description>");
            }
            xmlBody.write("</CreateUDFConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class CreateUdfApplicationRequestMarshaller
            implements RequestMarshaller2<CreateUdfApplicationRequest> {

        @override
         List<int> marshall(CreateUdfApplicationRequest request) {
            StringBuffer xmlBody = StringBuffer();
            UdfApplicationConfiguration config = request.getUdfApplicationConfiguration();

            xmlBody.write("<CreateUDFApplicationConfiguration>");
            xmlBody.write("<ImageVersion>" + config.getImageVersion() + "</ImageVersion>");
            xmlBody.write("<InstanceNum>" + config.getInstanceNum() + "</InstanceNum>");
            xmlBody.write("<Flavor>");
            xmlBody.write("<InstanceType>" + config.getFlavor().getInstanceType() + "</InstanceType>");
            xmlBody.write("</Flavor>");
            xmlBody.write("</CreateUDFApplicationConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class UpgradeUdfApplicationRequestMarshaller
            implements RequestMarshaller2<UpgradeUdfApplicationRequest> {

        @override
         List<int> marshall(UpgradeUdfApplicationRequest request) {
            StringBuffer xmlBody = StringBuffer();

            xmlBody.write("<UpgradeUDFApplicationConfiguration>");
            xmlBody.write("<ImageVersion>" + request.getImageVersion() + "</ImageVersion>");
            xmlBody.write("</UpgradeUDFApplicationConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class ResizeUdfApplicationRequestMarshaller
            implements RequestMarshaller2<ResizeUdfApplicationRequest> {

        @override
         List<int> marshall(ResizeUdfApplicationRequest request) {
            StringBuffer xmlBody = StringBuffer();

            xmlBody.write("<ResizeUDFApplicationConfiguration>");
            xmlBody.write("<InstanceNum>" + request.getInstanceNum() + "</InstanceNum>");
            xmlBody.write("</ResizeUDFApplicationConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class ProcessObjectRequestMarshaller implements RequestMarshaller2<ProcessObjectRequest> {

        @override
         List<int> marshall(ProcessObjectRequest request) {
            StringBuffer processBody = StringBuffer();

            processBody.write(RequestParameters.SUBRESOURCE_PROCESS);
            processBody.write("=" + request.getProcess());

            List<int> rawData = null;
            try {
                rawData = processBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class CreateVpcipRequestMarshaller implements RequestMarshaller<CreateVpcipRequest> {

        @override
         FixedLengthInputStream marshall(CreateVpcipRequest request) {
            StringBuffer xmlBody = StringBuffer();

            if (request.getRegion() != null || request.getVSwitchId() != null) {
                xmlBody.write("<CreateVpcip>");
                if (request.getRegion() != null) {
                    xmlBody.write("<Region>" + request.getRegion() + "</Region>");
                }
                if (request.getVSwitchId() != null) {
                    xmlBody.write("<VSwitchId>" + request.getVSwitchId() + "</VSwitchId>");
                }
                if(request.getLabel() != null){
                    xmlBody.write("<Label>" + request.getLabel() + "</Label>");
                }
                xmlBody.write("</CreateVpcip>");
            }

            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class DeleteVpcipRequestMarshaller implements RequestMarshaller<DeleteVpcipRequest> {

        @override
         FixedLengthInputStream marshall(DeleteVpcipRequest deleteVpcipRequest) {
            StringBuffer xmlBody = StringBuffer();
            VpcPolicy request = deleteVpcipRequest.getVpcPolicy();

            if (request.getRegion() != null || request.getVpcId() != null || request.getVip() != null) {
                xmlBody.write("<DeleteVpcip>");
                if (request.getRegion() != null) {
                    xmlBody.write("<Region>" + request.getRegion() + "</Region>");
                }
                if (request.getVpcId() != null) {
                    xmlBody.write("<VpcId>" + request.getVpcId() + "</VpcId>");
                }
                if (request.getVip() != null) {
                    xmlBody.write("<Vip>" + request.getVip() + "</Vip>");
                }
                xmlBody.write("</DeleteVpcip>");
            }

            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class DeleteBucketVpcipRequestMarshaller implements RequestMarshaller<VpcPolicy> {

        @override
         FixedLengthInputStream marshall(VpcPolicy request) {
            StringBuffer xmlBody = StringBuffer();

            if (request.getRegion() != null || request.getVpcId() != null || request.getVip() != null) {
                xmlBody.write("<DeleteBucketVpcPolicy>");
                if (request.getRegion() != null) {
                    xmlBody.write("<Region>" + request.getRegion() + "</Region>");
                }
                if (request.getVpcId() != null) {
                    xmlBody.write("<VpcId>" + request.getVpcId() + "</VpcId>");
                }
                if (request.getVip() != null) {
                    xmlBody.write("<Vip>" + request.getVip() + "</Vip>");
                }
                xmlBody.write("</DeleteBucketVpcPolicy>");
            }

            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class CreateBucketVpcipRequestMarshaller implements RequestMarshaller<CreateBucketVpcipRequest> {

        @override
         FixedLengthInputStream marshall(CreateBucketVpcipRequest bucketVpcPolicyRequest) {
            StringBuffer xmlBody = StringBuffer();
            VpcPolicy request = bucketVpcPolicyRequest.getVpcPolicy();

            if (request.getRegion() != null || request.getVpcId() != null || request.getVip() != null) {
                xmlBody.write("<CreateBucketVpcPolicy>");
                if (request.getRegion() != null) {
                    xmlBody.write("<Region>" + request.getRegion() + "</Region>");
                }
                if (request.getVpcId() != null) {
                    xmlBody.write("<VpcId>" + request.getVpcId() + "</VpcId>");
                }
                if (request.getVip() != null) {
                    xmlBody.write("<Vip>" + request.getVip() + "</Vip>");
                }
                xmlBody.write("</CreateBucketVpcPolicy>");
            }

            return stringMarshaller.marshall(xmlBody.toString());
        }

    }


     class RestoreObjectRequestMarshaller implements RequestMarshaller2<RestoreObjectRequest> {

        @override
         List<int> marshall(RestoreObjectRequest request) {
            StringBuffer body = StringBuffer();

            body.write("<RestoreRequest>");
            body.write("<Days>" + request.getRestoreConfiguration().getDays() + "</Days>");
            if (request.getRestoreConfiguration().getRestoreJobParameters() != null) {
                body.write("<JobParameters>");
                RestoreJobParameters jobParameters = request.getRestoreConfiguration().getRestoreJobParameters();
                if (jobParameters.getRestoreTier() != null) {
                    body.write("<Tier>" + jobParameters.getRestoreTier() + "</Tier>");
                }
                body.write("</JobParameters>");
            }
            body.write("</RestoreRequest>");

            List<int> rawData = null;
            try {
                rawData = body.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            return rawData;
        }

    }

     class PutBucketTransferAccelerationRequestMarshaller implements RequestMarshaller2<SetBucketTransferAccelerationRequest> {
        @override
         List<int> marshall(SetBucketTransferAccelerationRequest input) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<TransferAccelerationConfiguration><Enabled>");
            xmlBody.write(input.isEnabled());
            xmlBody.write("</Enabled></TransferAccelerationConfiguration>");

            List<int> rawData = null;
            try {
                rawData = xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }

            return rawData;
        }
    }

    abstract class RequestMarshaller<R> extends Marshaller<FixedLengthInputStream, R> {

    }

    abstract class RequestMarshaller2<R> extends Marshaller<List<int>, R> {

    }

     class StringMarshaller implements Marshaller<FixedLengthInputStream, String> {

        @override
         FixedLengthInputStream marshall(String? input) {
            if (input == null) {
                throw ArgumentError("The input should not be null.");
            }

            List<int> binaryData = [];
            try {
                binaryData = input.getBytes(DEFAULT_CHARSET_NAME);
            } catch ( e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
            int length = binaryData.length;
            InputStream instream = ByteArrayInputStream(binaryData);
            return FixedLengthInputStream(instream, length);
        }

    }

     class PutImageStyleRequestMarshaller implements RequestMarshaller<PutImageStyleRequest> {
        @override
         FixedLengthInputStream marshall(PutImageStyleRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<Style>");
            xmlBody.write("<Content>${request.style}</Content>");
            xmlBody.write("</Style>");
            return stringMarshaller.marshall(xmlBody.toString());
        }
    }

     class BucketImageProcessConfMarshaller implements RequestMarshaller<ImageProcess> {

        @override
         FixedLengthInputStream marshall(ImageProcess imageProcessConf) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<BucketProcessConfiguration>");
            xmlBody.write("<CompliedHost>" + imageProcessConf.getCompliedHost() + "</CompliedHost>");
            if (imageProcessConf.sourceFileProtect == true) {
                xmlBody.write("<SourceFileProtect>Enabled</SourceFileProtect>");
            } else {
                xmlBody.write("<SourceFileProtect>Disabled</SourceFileProtect>");
            }
            xmlBody.write("<SourceFileProtectSuffix>${imageProcessConf.sourceFileProtectSuffix}</SourceFileProtectSuffix>");
            xmlBody.write("<StyleDelimiters>" + imageProcessConf.getStyleDelimiters() + "</StyleDelimiters>");
            if (imageProcessConf.isSupportAtStyle() != null && imageProcessConf.isSupportAtStyle().boolValue()) {
                xmlBody.write("<OssDomainSupportAtProcess>Enabled</OssDomainSupportAtProcess>");
            } else {
                xmlBody.write("<OssDomainSupportAtProcess>Disabled</OssDomainSupportAtProcess>");
            }
            xmlBody.write("</BucketProcessConfiguration>");
            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class PutBucketImageRequestMarshaller implements RequestMarshaller<PutBucketImageRequest> {
        @override
         FixedLengthInputStream marshall(PutBucketImageRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<Channel>");
            if (request.GetIsForbidOrigPicAccess()) {
                xmlBody.write("<OrigPicForbidden>true</OrigPicForbidden>");
            } else {
                xmlBody.write("<OrigPicForbidden>false</OrigPicForbidden>");
            }

            if (request.GetIsUseStyleOnly()) {
                xmlBody.write("<UseStyleOnly>true</UseStyleOnly>");
            } else {
                xmlBody.write("<UseStyleOnly>false</UseStyleOnly>");
            }

            if (request.GetIsAutoSetContentType()) {
                xmlBody.write("<AutoSetContentType>true</AutoSetContentType>");
            } else {
                xmlBody.write("<AutoSetContentType>false</AutoSetContentType>");
            }

            if (request.GetIsUseSrcFormat()) {
                xmlBody.write("<UseSrcFormat>true</UseSrcFormat>");
            } else {
                xmlBody.write("<UseSrcFormat>false</UseSrcFormat>");
            }

            if (request.GetIsSetAttachName()) {
                xmlBody.write("<SetAttachName>true</SetAttachName>");
            } else {
                xmlBody.write("<SetAttachName>false</SetAttachName>");
            }
            xmlBody.write("<Default404Pic>" + request.GetDefault404Pic() + "</Default404Pic>");
            xmlBody.write("<StyleDelimiters>" + request.GetStyleDelimiters() + "</StyleDelimiters>");

            xmlBody.write("</Channel>");
            return stringMarshaller.marshall(xmlBody.toString());
        }
    }

     class CreateBucketRequestMarshaller implements RequestMarshaller<CreateBucketRequest> {

        @override
         FixedLengthInputStream marshall(CreateBucketRequest request) {
            StringBuffer xmlBody = StringBuffer();
            if (request.getLocationConstraint() != null 
                    || request.getStorageClass() != null 
                    || request.getDataRedundancyType() != null) {
                xmlBody.write("<CreateBucketConfiguration>");
                if (request.getLocationConstraint() != null) {
                    xmlBody.write("<LocationConstraint>" + request.getLocationConstraint() + "</LocationConstraint>");
                }
                if (request.getStorageClass() != null) {
                    xmlBody.write("<StorageClass>" + request.getStorageClass().toString() + "</StorageClass>");
                }
                if (request.getDataRedundancyType() != null) {
                    xmlBody.write("<DataRedundancyType>" + request.getDataRedundancyType().toString() + "</DataRedundancyType>");
                }
                xmlBody.write("</CreateBucketConfiguration>");
            }
            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class BucketRefererMarshaller implements RequestMarshaller<BucketReferer> {

        @override
         FixedLengthInputStream marshall(BucketReferer br) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<RefererConfiguration>");
            xmlBody.write("<AllowEmptyReferer>" + br.isAllowEmptyReferer() + "</AllowEmptyReferer>");

            if (!br.getRefererList().isEmpty()) {
                xmlBody.write("<RefererList>");
                for (String referer : br.getRefererList()) {
                    xmlBody.write("<Referer>" + referer + "</Referer>");
                }
                xmlBody.write("</RefererList>");
            } else {
                xmlBody.write("<RefererList/>");
            }

            xmlBody.write("</RefererConfiguration>");
            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class SetBucketLoggingRequestMarshaller implements RequestMarshaller<SetBucketLoggingRequest> {

        @override
         FixedLengthInputStream marshall(SetBucketLoggingRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<BucketLoggingStatus>");
            if (request.getTargetBucket() != null) {
                xmlBody.write("<LoggingEnabled>");
                xmlBody.write("<TargetBucket>" + request.getTargetBucket() + "</TargetBucket>");
                if (request.getTargetPrefix() != null) {
                    xmlBody.write("<TargetPrefix>" + request.getTargetPrefix() + "</TargetPrefix>");
                }
                xmlBody.write("</LoggingEnabled>");
            } else {
                // Nothing to do here, user attempt to close bucket logging
                // functionality
                // by setting an empty BucketLoggingStatus entity.
            }
            xmlBody.write("</BucketLoggingStatus>");
            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class SetBucketWebsiteRequestMarshaller implements RequestMarshaller<SetBucketWebsiteRequest> {

        @override
         FixedLengthInputStream marshall(SetBucketWebsiteRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<WebsiteConfiguration>");
            if (request.getIndexDocument() != null) {
                xmlBody.write("<IndexDocument>");
                xmlBody.write("<Suffix>" + request.getIndexDocument() + "</Suffix>");
                if(request.isSupportSubDir()) {
                    xmlBody.write("<SupportSubDir>" + request.isSupportSubDir() + "</SupportSubDir>");
                    if (request.getSubDirType() != null) {
                        xmlBody.write("<Type>" + request.getSubDirType().toString() + "</Type>");
                    }
                }
                xmlBody.write("</IndexDocument>");
            }
            if (request.getErrorDocument() != null) {
                xmlBody.write("<ErrorDocument>");
                xmlBody.write("<Key>" + request.getErrorDocument() + "</Key>");
                xmlBody.write("</ErrorDocument>");
            }

            // RoutingRules可以没有
            if (request.getRoutingRules().size() > 0) {
                xmlBody.write("<RoutingRules>");
                for (RoutingRule routingRule : request.getRoutingRules()) {
                    xmlBody.write("<RoutingRule>");
                    xmlBody.write("<RuleNumber>" + routingRule.getNumber() + "</RuleNumber>");

                    // Condition字句可以没有，如果有至少有一个条件
                    RoutingRule.Condition condition = routingRule.getCondition();
                    if (condition.getKeyPrefixEquals() != null || condition.getHttpErrorCodeReturnedEquals() > 0) {
                        xmlBody.write("<Condition>");
                        if (condition.getKeyPrefixEquals() != null) {
                            xmlBody.write("<KeyPrefixEquals>" + escapeKey(condition.getKeyPrefixEquals())
                                    + "</KeyPrefixEquals>");
                        }
                        // add KeySuffixEquals
                        if (condition.getKeySuffixEquals() != null) {
                            xmlBody.write("<KeySuffixEquals>" + escapeKey(condition.getKeySuffixEquals())
                                    + "</KeySuffixEquals>");
                        }

                        if (condition.getHttpErrorCodeReturnedEquals() != null) {
                            xmlBody.write("<HttpErrorCodeReturnedEquals>" + condition.getHttpErrorCodeReturnedEquals()
                                    + "</HttpErrorCodeReturnedEquals>");
                        }
                        if (condition.getIncludeHeaders() != null && condition.getIncludeHeaders().size() > 0) {
                            for (RoutingRule.IncludeHeader includeHeader : condition.getIncludeHeaders()) {
                                xmlBody.write("<IncludeHeader>");
                                if (includeHeader.getKey() != null) {
                                    xmlBody.write("<Key>" + includeHeader.getKey() + "</Key>");
                                }
                                if (includeHeader.getEquals() != null) {
                                    xmlBody.write("<Equals>" + includeHeader.getEquals() + "</Equals>");
                                }
                                if (includeHeader.getStartsWith() != null) {
                                    xmlBody.write("<StartsWith>" + includeHeader.getStartsWith() + "</StartsWith>");
                                }
                                if (includeHeader.getEndsWith() != null) {
                                    xmlBody.write("<EndsWith>" + includeHeader.getEndsWith() + "</EndsWith>");
                                }
                                xmlBody.write("</IncludeHeader>");
                            }
                        }
                        xmlBody.write("</Condition>");
                    }

                    // Redirect子句必须存在
                    RoutingRule.Redirect redirect = routingRule.getRedirect();
                    xmlBody.write("<Redirect>");
                    if (redirect.getRedirectType() != null) {
                        xmlBody.write("<RedirectType>" + redirect.getRedirectType().toString() + "</RedirectType>");
                    }
                    if (redirect.getHostName() != null) {
                        xmlBody.write("<HostName>" + redirect.getHostName() + "</HostName>");
                    }
                    if (redirect.getProtocol() != null) {
                        xmlBody.write("<Protocol>" + redirect.getProtocol().toString() + "</Protocol>");
                    }
                    if (redirect.getReplaceKeyPrefixWith() != null) {
                        xmlBody.write("<ReplaceKeyPrefixWith>" + escapeKey(redirect.getReplaceKeyPrefixWith())
                                + "</ReplaceKeyPrefixWith>");
                    }
                    if (redirect.getReplaceKeyWith() != null) {
                        xmlBody.write(
                                "<ReplaceKeyWith>" + escapeKey(redirect.getReplaceKeyWith()) + "</ReplaceKeyWith>");
                    }
                    if (redirect.getHttpRedirectCode() != null) {
                        xmlBody.write("<HttpRedirectCode>" + redirect.getHttpRedirectCode() + "</HttpRedirectCode>");
                    }
                    if (redirect.getMirrorURL() != null) {
                        xmlBody.write("<MirrorURL>" + redirect.getMirrorURL() + "</MirrorURL>");
                    }
                    if(redirect.getMirrorTunnelId() != null) {
                        xmlBody.write("<MirrorTunnelId>" + redirect.getMirrorTunnelId() + "</MirrorTunnelId>");
                    }
                    if (redirect.getMirrorMultiAlternates() != null && redirect.getMirrorMultiAlternates().size() > 0) {
                        xmlBody.write("<MirrorMultiAlternates>");

                        for (int i = 0; i < redirect.getMirrorMultiAlternates().size(); i++) {
                            RoutingRule.Redirect.MirrorMultiAlternate mirrorMultiAlternate = redirect.getMirrorMultiAlternates().get(i);
                            if (mirrorMultiAlternate != null && mirrorMultiAlternate.getUrl() != null) {
                                xmlBody.write("<MirrorMultiAlternate>");
                                xmlBody.write("<MirrorMultiAlternateNumber>");
                                xmlBody.write(mirrorMultiAlternate.getPrior());
                                xmlBody.write("</MirrorMultiAlternateNumber>");
                                xmlBody.write("<MirrorMultiAlternateURL>");
                                xmlBody.write(mirrorMultiAlternate.getUrl());
                                xmlBody.write("</MirrorMultiAlternateURL>");
                                xmlBody.write("</MirrorMultiAlternate>");
                            }
                        }

                        xmlBody.write("</MirrorMultiAlternates>");
                    }

                    if (redirect.getMirrorSecondaryURL() != null) {
                        xmlBody.write("<MirrorURLSlave>" + redirect.getMirrorSecondaryURL() + "</MirrorURLSlave>");
                    }
                    if (redirect.getMirrorProbeURL() != null) {
                        xmlBody.write("<MirrorURLProbe>" + redirect.getMirrorProbeURL() + "</MirrorURLProbe>");
                    }
                    if (redirect.isMirrorPassQueryString() != null) {
                        xmlBody.write(
                                "<MirrorPassQueryString>" + redirect.isMirrorPassQueryString() + "</MirrorPassQueryString>");
                    }
                    if (redirect.isPassOriginalSlashes() != null) {
                        xmlBody.write("<MirrorPassOriginalSlashes>" + redirect.isPassOriginalSlashes()
                                + "</MirrorPassOriginalSlashes>");
                    }

                    if (redirect.isPassQueryString() != null) {
                        xmlBody.write("<PassQueryString>" + redirect.isPassQueryString()
                                + "</PassQueryString>");
                    }

                    // add EnableReplacePrefix and  MirrorSwitchAllErrors

                    if (redirect.isEnableReplacePrefix() != null) {
                        xmlBody.write("<EnableReplacePrefix>" + redirect.isEnableReplacePrefix()
                                + "</EnableReplacePrefix>");
                    }

                    if (redirect.isMirrorSwitchAllErrors() != null) {
                        xmlBody.write("<MirrorSwitchAllErrors>" + redirect.isMirrorSwitchAllErrors()
                                + "</MirrorSwitchAllErrors>");
                    }

                    if (redirect.isMirrorCheckMd5() != null) {
                        xmlBody.write("<MirrorCheckMd5>" + redirect.isMirrorCheckMd5()
                                + "</MirrorCheckMd5>");
                    }

                    if (redirect.isMirrorFollowRedirect() != null) {
                        xmlBody.write("<MirrorFollowRedirect>" + redirect.isMirrorFollowRedirect()
                                + "</MirrorFollowRedirect>");
                    }
                    if (redirect.isMirrorUserLastModified() != null) {
                        xmlBody.write("<MirrorUserLastModified>" + redirect.isMirrorUserLastModified()
                                + "</MirrorUserLastModified>");
                    }
                    if (redirect.isMirrorIsExpressTunnel() != null) {
                        xmlBody.write("<MirrorIsExpressTunnel>" + redirect.isMirrorIsExpressTunnel()
                                + "</MirrorIsExpressTunnel>");
                    }
                    if (redirect.getMirrorDstRegion() != null) {
                        xmlBody.write("<MirrorDstRegion>" + redirect.getMirrorDstRegion()
                                + "</MirrorDstRegion>");
                    }
                    if (redirect.getMirrorDstVpcId() != null) {
                        xmlBody.write("<MirrorDstVpcId>" + redirect.getMirrorDstVpcId()
                                + "</MirrorDstVpcId>");
                    }

                    if (redirect.isMirrorUsingRole() != null) {
                        xmlBody.write("<MirrorUsingRole>" + redirect.isMirrorUsingRole() + "</MirrorUsingRole>");
                    }

                    if (redirect.getMirrorRole() != null) {
                        xmlBody.write("<MirrorRole>" + redirect.getMirrorRole() + "</MirrorRole>");
                    }

                    if (redirect.getMirrorHeaders() != null) {
                        xmlBody.write("<MirrorHeaders>");
                        RoutingRule.MirrorHeaders mirrorHeaders = redirect.getMirrorHeaders();
                        xmlBody.write("<PassAll>" + mirrorHeaders.isPassAll() + "</PassAll>");
                        if (mirrorHeaders.getPass() != null && mirrorHeaders.getPass().size() > 0) {
                            for (String pass : mirrorHeaders.getPass()) {
                                xmlBody.write("<Pass>" + pass + "</Pass>");
                            }
                        }
                        if (mirrorHeaders.getRemove() != null && mirrorHeaders.getRemove().size() > 0) {
                            for (String remove : mirrorHeaders.getRemove()) {
                                xmlBody.write("<Remove>" + remove + "</Remove>");
                            }
                        }
                        if (mirrorHeaders.getSet() != null && mirrorHeaders.getSet().size() > 0) {
                            for (Map<String, String> setMap : mirrorHeaders.getSet()) {
                                xmlBody.write("<Set>");
                                xmlBody.write("<Key>" + setMap.get("Key") + "</Key>");
                                xmlBody.write("<Value>" + setMap.get("Value") + "</Value>");
                                xmlBody.write("</Set>");
                            }
                        }
                        xmlBody.write("</MirrorHeaders>");
                    }

                    xmlBody.write("</Redirect>");
                    xmlBody.write("</RoutingRule>");
                }
                xmlBody.write("</RoutingRules>");
            }

            xmlBody.write("</WebsiteConfiguration>");
            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class SetBucketLifecycleRequestMarshaller
            implements RequestMarshaller<SetBucketLifecycleRequest> {

        @override
         FixedLengthInputStream marshall(SetBucketLifecycleRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<LifecycleConfiguration>");
            for (LifecycleRule rule : request.getLifecycleRules()) {
                xmlBody.write("<Rule>");

                if (rule.getId() != null) {
                    xmlBody.write("<ID>" + rule.getId() + "</ID>");
                }

                if (rule.getPrefix() != null) {
                    xmlBody.write("<Prefix>" + rule.getPrefix() + "</Prefix>");
                } else {
                    xmlBody.write("<Prefix></Prefix>");
                }
                
                if (rule.hasTags()) {
                    for (Map.Entry<String, String> tag : rule.getTags().entrySet()) {
                        xmlBody.write("<Tag>");
                        xmlBody.write("<Key>" + tag.getKey() + "</Key>");
                        xmlBody.write("<Value>" + tag.getValue() + "</Value>");
                        xmlBody.write("</Tag>");
                    }
                }

                if (rule.getStatus() == RuleStatus.Enabled) {
                    xmlBody.write("<Status>Enabled</Status>");
                } else {
                    xmlBody.write("<Status>Disabled</Status>");
                }

                if (rule.getExpirationTime() != null) {
                    String formatDate = DateUtil.formatIso8601Date(rule.getExpirationTime());
                    xmlBody.write("<Expiration><Date>" + formatDate + "</Date></Expiration>");
                } else if (rule.getExpirationDays() != 0) {
                    xmlBody.write("<Expiration><Days>" + rule.getExpirationDays() + "</Days></Expiration>");
                } else if (rule.getCreatedBeforeDate() != null) {
                    String formatDate = DateUtil.formatIso8601Date(rule.getCreatedBeforeDate());
                    xmlBody.write(
                            "<Expiration><CreatedBeforeDate>" + formatDate + "</CreatedBeforeDate></Expiration>");
                } else if (rule.getExpiredDeleteMarker() != null) {
                    xmlBody.write("<Expiration><ExpiredObjectDeleteMarker>" + rule.getExpiredDeleteMarker() +
                            "</ExpiredObjectDeleteMarker></Expiration>");
                }

                if (rule.hasAbortMultipartUpload()) {
                    AbortMultipartUpload abortMultipartUpload = rule.getAbortMultipartUpload();
                    if (abortMultipartUpload.getExpirationDays() != 0) {
                        xmlBody.write("<AbortMultipartUpload><Days>" + abortMultipartUpload.getExpirationDays()
                                + "</Days></AbortMultipartUpload>");
                    } else {
                        String formatDate = DateUtil.formatIso8601Date(abortMultipartUpload.getCreatedBeforeDate());
                        xmlBody.write("<AbortMultipartUpload><CreatedBeforeDate>" + formatDate
                                + "</CreatedBeforeDate></AbortMultipartUpload>");
                    }
                }

                if (rule.hasStorageTransition()) {
                    for (StorageTransition storageTransition : rule.getStorageTransition()) {
                        xmlBody.write("<Transition>");
                        if (storageTransition.hasExpirationDays()) {
                            xmlBody.write("<Days>" + storageTransition.getExpirationDays() + "</Days>");
                        } else if (storageTransition.hasCreatedBeforeDate()) {
                            String formatDate = DateUtil.formatIso8601Date(storageTransition.getCreatedBeforeDate());
                            xmlBody.write("<CreatedBeforeDate>" + formatDate + "</CreatedBeforeDate>");
                        }
                        xmlBody.write("<StorageClass>" + storageTransition.getStorageClass() + "</StorageClass>");
                        xmlBody.write("</Transition>");
                    }
                }

                if (rule.hasNoncurrentVersionExpiration()) {
                    NoncurrentVersionExpiration expiration = rule.getNoncurrentVersionExpiration();
                    if (expiration.hasNoncurrentDays()) {
                        xmlBody.write("<NoncurrentVersionExpiration><NoncurrentDays>" + expiration.getNoncurrentDays() +
                                "</NoncurrentDays></NoncurrentVersionExpiration>");
                    }
                }

                if (rule.hasNoncurrentVersionStorageTransitions()) {
                    for (NoncurrentVersionStorageTransition transition : rule.getNoncurrentVersionStorageTransitions()) {
                        xmlBody.write("<NoncurrentVersionTransition>");
                        xmlBody.write("<NoncurrentDays>" + transition.getNoncurrentDays() + "</NoncurrentDays>");
                        xmlBody.write("<StorageClass>" + transition.getStorageClass() + "</StorageClass>");
                        xmlBody.write("</NoncurrentVersionTransition>");
                    }
                }

                xmlBody.write("</Rule>");
            }
            xmlBody.write("</LifecycleConfiguration>");
            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class SetBucketCORSRequestMarshaller implements RequestMarshaller<SetBucketCORSRequest> {

        @override
         FixedLengthInputStream marshall(SetBucketCORSRequest request) {
            StringBuffer xmlBody = StringBuffer();
            xmlBody.write("<CORSConfiguration>");
            for (CORSRule rule : request.getCorsRules()) {
                xmlBody.write("<CORSRule>");

                for (String allowedOrigin : rule.getAllowedOrigins()) {
                    xmlBody.write("<AllowedOrigin>" + allowedOrigin + "</AllowedOrigin>");
                }

                for (String allowedMethod : rule.getAllowedMethods()) {
                    xmlBody.write("<AllowedMethod>" + allowedMethod + "</AllowedMethod>");
                }

                if (rule.getAllowedHeaders().size() > 0) {
                    for (String allowedHeader : rule.getAllowedHeaders()) {
                        xmlBody.write("<AllowedHeader>" + allowedHeader + "</AllowedHeader>");
                    }
                }

                if (rule.getExposeHeaders().size() > 0) {
                    for (String exposeHeader : rule.getExposeHeaders()) {
                        xmlBody.write("<ExposeHeader>" + exposeHeader + "</ExposeHeader>");
                    }
                }

                if (null != rule.getMaxAgeSeconds()) {
                    xmlBody.write("<MaxAgeSeconds>" + rule.getMaxAgeSeconds() + "</MaxAgeSeconds>");
                }

                xmlBody.write("</CORSRule>");
            }
            if (null != request.getResponseVary()) {
                xmlBody.write("<ResponseVary>" + request.getResponseVary() + "</ResponseVary>");
            }
            xmlBody.write("</CORSConfiguration>");
            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class CompleteMultipartUploadRequestMarshaller
            implements RequestMarshaller<CompleteMultipartUploadRequest> {

        @override
         FixedLengthInputStream marshall(CompleteMultipartUploadRequest request) {
            StringBuffer xmlBody = StringBuffer();
            List<PartETag> eTags = request.getPartETags();
            xmlBody.write("<CompleteMultipartUpload>");
            for (int i = 0; i < eTags.size(); i++) {
                PartETag part = eTags.get(i);
                String eTag = EscapedChar.QUOT + part.getETag().replace("\"", "") + EscapedChar.QUOT;
                xmlBody.write("<Part>");
                xmlBody.write("<PartNumber>" + part.getPartNumber() + "</PartNumber>");
                xmlBody.write("<ETag>" + eTag + "</ETag>");
                xmlBody.write("</Part>");
            }
            xmlBody.write("</CompleteMultipartUpload>");
            return stringMarshaller.marshall(xmlBody.toString());
        }

    }

     class CreateSelectObjectMetadataRequestMarshaller
            implements RequestMarshaller2<CreateSelectObjectMetadataRequest> {

        @override
         List<int> marshall(CreateSelectObjectMetadataRequest request) {
            StringBuffer xmlBody = StringBuffer();
            InputSerialization inputSerialization = request.getInputSerialization();
            CSVFormat csvFormat = inputSerialization.getCsvInputFormat();
            JsonFormat jsonFormat = inputSerialization.getJsonInputFormat();
            if (inputSerialization.getSelectContentFormat() == SelectContentFormat.CSV) {
                xmlBody.write("<CsvMetaRequest>");
                xmlBody.write("<InputSerialization>");
                xmlBody.write("<CompressionType>" + inputSerialization.getCompressionType() + "</CompressionType>");
                xmlBody.write("<CSV>");
                xmlBody.write("<RecordDelimiter>" + BinaryUtil.toBase64String(csvFormat.getRecordDelimiter().getBytes()) + "</RecordDelimiter>");
                xmlBody.write("<FieldDelimiter>" + BinaryUtil.toBase64String(csvFormat.getFieldDelimiter().toString().getBytes()) + "</FieldDelimiter>");
                xmlBody.write("<QuoteCharacter>" + BinaryUtil.toBase64String(csvFormat.getQuoteChar().toString().getBytes()) + "</QuoteCharacter>");
                xmlBody.write("</CSV>");
                xmlBody.write("</InputSerialization>");
                xmlBody.write("<OverwriteIfExists>" + request.isOverwrite() + "</OverwriteIfExists>");
                xmlBody.write("</CsvMetaRequest>");
            } else {
                xmlBody.write("<JsonMetaRequest>");
                xmlBody.write("<InputSerialization>");
                xmlBody.write("<CompressionType>" + inputSerialization.getCompressionType() + "</CompressionType>");
                xmlBody.write("<JSON>");
                xmlBody.write("<Type>" + jsonFormat.getJsonType().name() + "</Type>");
                xmlBody.write("</JSON>");
                xmlBody.write("</InputSerialization>");
                xmlBody.write("<OverwriteIfExists>" + request.isOverwrite() + "</OverwriteIfExists>");
                xmlBody.write("</JsonMetaRequest>");
            }

            try {
                return xmlBody.toString().getBytes(DEFAULT_CHARSET_NAME);
            } catch (UnsupportedEncodingException e) {
                throw ClientException("Unsupported encoding " + e.getMessage(), e);
            }
        }
    }



 enum EscapedChar {
        // "\r"
        RETURN,

        // "\n"
        NEWLINE,

        // " "
        SPACE,

        // "\t"
        TAB,

        // """
        QUOT,

        // "&"
        AMP,

        // "<"
        LT,

        // ">"
        GT,

    }

    extension EscapedCharX on EscapedChar {
      String get name {
        switch(this){
          // "\r"
        case EscapedChar.RETURN: return("&#x000D;");

        // "\n"
        case EscapedChar.NEWLINE: return("&#x000A;");

        // " "
        case EscapedChar.SPACE: return("&#x0020;");

        // "\t"
        case EscapedChar.TAB: return("&#x0009;");

        // """
        case EscapedChar.QUOT: return("&quot;");

        // "&"
        case EscapedChar.AMP: return("&amp;");

        // "<"
        case EscapedChar.LT: return("&lt;");

        // ">"
        case EscapedChar.GT: return("&gt;");
        } 
      }
    }