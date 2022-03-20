import 'package:path_provider/path_provider.dart';

class PathProvider {
  static Future<String> getDocumentPath() async {
    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    return appDocumentDir.path;
  }
}
