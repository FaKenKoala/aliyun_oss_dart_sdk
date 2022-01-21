import 'package:xml/xml.dart';

///<?xml version="1.0" ?>
///  <Error>
///      <Code>
///          AccessDenied
///      </Code>
///      <Message>
///          Query-string authentication requires the Signature, Expires and OSSAccessKeyId parameters
///      </Message>
///      <RequestId>
///          1D842BC54255****
///      </RequestId>
///      <HostId>
///          oss-cn-hangzhou.aliyuncs.com
///      </HostId>
///      <ResourceType>
///          image/jpeg
///      </ResourceType>
///      <Method>
///          GET
///      </Method>
///      <Header>
///          wombat
///      </Header>
///  </Error>
class OSSErrorResult {
  String? code;
  String? message;
  String? requestId;
  String? hostId;
  String? resourceType;
  String? method;
  String? header;

  OSSErrorResult.readXml(String? xmlString) {
    if (xmlString == null) {
      return;
    }
    final document = XmlDocument.parse(xmlString);
    code = document.getAttribute('Code');
    message = document.getAttribute('Message');
    requestId = document.getAttribute('RequestId');
    hostId = document.getAttribute('HostId');
    resourceType = document.getAttribute('ResourceType');
    method = document.getAttribute('Method');
    header = document.getAttribute('Header');
  }
}
// @XmlRootElement(name = "Error")
// public class OSSErrorResult {
//     @XmlElement(name = "Code")
//     public String Code;

//     @XmlElement(name = "Message")
//     public String Message;

//     @XmlElement(name = "RequestId")
//     public String RequestId;

//     @XmlElement(name = "HostId")
//     public String HostId;

//     @XmlElement(name = "ResourceType")
//     public String ResourceType;

//     @XmlElement(name = "Method")
//     public String Method;

//     @XmlElement(name = "Header")
//     public String Header;

// }