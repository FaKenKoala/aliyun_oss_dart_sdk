class OSSResult {
  int statusCode = -1;

  Map<String, String> responseHeader = <String, String>{};

  String? requestId;

  //client crc64
  String? _clientCRC;
  String? get clientCRC => _clientCRC;
  set clientCRC(String? clientCRC) {
    if (clientCRC != null) {
      _clientCRC = clientCRC;
    }
  }

  //server crc64
  String? _serverCRC;
  String? get serverCRC => _serverCRC;
  set serverCRC(String? serverCRC) {
    if (serverCRC != null) {
      _serverCRC = serverCRC;
    }
  }

  @override
  String toString() {
    return "OSSResult<${super.toString()}>: \nstatusCode:$statusCode,\nresponseHeader:$responseHeader,\nrequestId:$requestId";
  }
}
