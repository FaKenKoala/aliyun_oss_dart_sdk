class OSSResult {
  int statusCode = -1;

  Map<String, String> responseHeader = <String, String>{};

  String? requestId;

  //client crc64
  int _clientCRC = 0;
  int get clientCRC => _clientCRC;
  void setClientCRC(int? clientCRC) {
    if (clientCRC != null && clientCRC != 0) {
      _clientCRC = clientCRC;
    }
  }

  //server crc64
  int _serverCRC = 0;
  int get serverCRC => _serverCRC;
  set serverCRC(int? serverCRC) {
    if (serverCRC != null && serverCRC != 0) {
      _serverCRC = serverCRC;
    }
  }

  @override
  String toString() {
    return "OSSResult<${super.toString()}>: \nstatusCode:$statusCode,\nresponseHeader:$responseHeader,\nrequestId:$requestId";
  }
}
