class CnameConfiguration {
  String? domain;
  CnameStatus status = CnameStatus.Unknown;
  DateTime? lastMofiedTime;
  bool? purgeCdnCache;
  CertStatus? certStatus;
  CertType? certType;
  String? certId;

  @override
  String toString() {
    return "CnameConfiguration [domain=$domain, status=$status, lastMofiedTime=$lastMofiedTime, certType=$certType, certId=$certId, certStatus$certStatus]";
  }
}

enum CnameStatus {
  Unknown,
  Enabled,
  Disabled,
  Blocked,
  Forbidden,
}

extension CnameStatusX on CnameStatus {
  static CnameStatus parse(String cnameStatusString) {
    for (CnameStatus st in CnameStatus.values) {
      if (st.name.toLowerCase() == cnameStatusString.toLowerCase()) {
        return st;
      }
    }
    throw ArgumentError("Unable to parse " + cnameStatusString);
  }
}

enum CertStatus {
  Unknown,
  Enabled,
  Disabled,
}

extension CertStatusX on CertStatus {
  static CertStatus parse(String certStatusString) {
    for (CertStatus st in CertStatus.values) {
      if (st.name.toLowerCase() == certStatusString.toLowerCase()) {
        return st;
      }
    }
    throw ArgumentError("Unable to parse " + certStatusString);
  }
}

enum CertType {
  Unknown,
  CAS,
  Upload,
}

extension CertTypeX on CertType {
  static CertType parse(String certTypeString) {
    for (CertType ct in CertType.values) {
      if (ct.name.toLowerCase() == certTypeString.toLowerCase()) {
        return ct;
      }
    }
    throw ArgumentError("Unable to parse " + certTypeString);
  }
}
