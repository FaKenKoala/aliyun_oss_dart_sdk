// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oss_federation_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OSSFederationToken _$OSSFederationTokenFromJson(Map<String, dynamic> json) =>
    OSSFederationToken(
      json['AccessKeyId'] as String,
      json['AccessKeySecret'] as String,
      json['SecurityToken'] as String,
      json['Expiration'] as int,
    );

Map<String, dynamic> _$OSSFederationTokenToJson(OSSFederationToken instance) =>
    <String, dynamic>{
      'AccessKeyId': instance.tempAK,
      'AccessKeySecret': instance.tempSK,
      'SecurityToken': instance.securityToken,
      'Expiration': instance.expiration,
    };
