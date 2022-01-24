import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/common/utils/auth_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/ini_editor.dart';

class ProfileConfigLoader {
  Map<String, String> loadProfile(File file) {
    IniEditor iniProfile = IniEditor();
    iniProfile.load(file);
    return iniProfile.getSectionMap(AuthUtils.DEFAULT_SECTION_NAME);
  }
}
