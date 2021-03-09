import 'package:core_fe_dart/extensions.dart';
import 'package:core_fe_dart/utils.dart';

class ResourceManager {
  static final _logger = Logger('ResourceManager');
  static Map<String, dynamic> _appResource;
  static void init(Map<String, dynamic> appResource) {
    _appResource = appResource;
    _logger.info('init');
  }

  static String getLocalizedString(String key, {Map<String, dynamic> args}) {
    var result = '';
    if (_appResource != null &&
        !key.isNullEmptyOrWhitespace() &&
        _appResource.containsKey(key)) {
      result = (_appResource[key] as String).formatString(args);
    }
    _logger.info({'key': key, 'args': args});
    return result;
  }
}
