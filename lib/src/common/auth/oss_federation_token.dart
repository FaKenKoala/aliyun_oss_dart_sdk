import 'package:json_annotation/json_annotation.dart';
part 'oss_federation_token.g.dart';

@JsonSerializable()
class OSSFederationToken {
  @JsonKey(name: 'AccessKeyId')
  String tempAK;
  @JsonKey(name: 'AccessKeySecret')
  String tempSK;
  @JsonKey(name: 'SecurityToken')
  String securityToken;
  @JsonKey(name: 'Expiration')
  int expiration;

  OSSFederationToken(
      this.tempAK, this.tempSK, this.securityToken, this.expiration);

  factory OSSFederationToken.fromJson(Map<String, dynamic> json) =>
      _$OSSFederationTokenFromJson(json);
  Map<String, dynamic> toJson() => _$OSSFederationTokenToJson(this);

  // Sets the expiration time according to the value from STS. The time is in GMT format which is the original format returned from STS.
  //  void setExpirationInGMTFormat(String expirationInGMTFormat) {
  //     try {
  //         SimpleDateFormat sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
  //         sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
  //         Date date = sdf.parse(expirationInGMTFormat);
  //         this.expiration = date.getTime() / 1000;
  //     } catch (ParseException e) {
  //         if (OSSLog.isEnableLog()) {
  //             e.printStackTrace();
  //         }
  //         this.expiration = DateUtil.getFixedSkewedTimeMillis() / 1000 + 30;
  //     }
  // }
}
