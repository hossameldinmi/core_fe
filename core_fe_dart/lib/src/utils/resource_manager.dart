import 'package:core_fe_dart/extensions.dart';

class ResourceManager {
  static Map<String, dynamic> _appResource;
  static void init(Map<String, dynamic> appResource) {
    _appResource = appResource;
  }

  static String getLocalizedString(String key, {Map<String, dynamic> args}) {
    if (_appResource != null &&
        !key.isNullEmptyOrWhitespace() &&
        _appResource.containsKey(key)) {
      return (_appResource[key] as String).formatString(args);
    } else {
      return '';
    }
  }
}
