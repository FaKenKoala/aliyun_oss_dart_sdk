import 'dart:ui';

/// Manager class to get localized resources.
 class ResourceManager {
     ResourceBundle bundle;

    ResourceManager(String baseName, Locale locale) {
        bundle = ResourceBundle.getBundle(baseName, locale);
    }

     static ResourceManager getInstance(String baseName, [Locale? locale]) {
        return ResourceManager(baseName, locale ?? Locale.getDefault());
    }

     String getString(String key) {
        return bundle.getString(key);
    }

     String getFormattedString(String key, List<Object> args) {
        return MessageFormat.format(getString(key), args);
    }
}
