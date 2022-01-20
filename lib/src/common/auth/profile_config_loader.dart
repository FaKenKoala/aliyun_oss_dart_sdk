import 'dart:io';

class ProfileConfigLoader {
  Map<String, String> loadProfile(File file) {
    IniEditor iniProfile = IniEditor();
    iniProfile.load(file);
    return iniProfile.getSectionMap(AuthUtils.DEFAULT_SECTION_NAME);
  }
}
