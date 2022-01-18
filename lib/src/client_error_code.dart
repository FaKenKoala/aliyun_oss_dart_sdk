abstract class ClientErrorCode {
  ///  Unknown error. This means the error is not expected.
  static final String unknown = "Unknown";

  ///  Unknown host. This error is returned when a
  ///  {@link java.net.UnknownHostException} is thrown.
  static final String unknownHost = "UnknownHost";

  ///  connection times out.
  static final String connectionTimeout = "ConnectionTimeout";

  ///  Socket times out
  static final String socketTimeout = "SocketTimeout";

  ///  Socket exception
  static final String socketException = "SocketException";

  ///  Connection is refused by server side.
  static final String connectionRefused = "ConnectionRefused";

  ///  The input stream is not repeatable for reading.
  static final String nonrepeatableRequest = "NonRepeatableRequest";

  ///  Thread interrupted while reading the input stream.
  static final String inputstreamReadingAborted = "InputStreamReadingAborted";

  ///  Ssl exception
  static final String sslException = "SslException";
}
