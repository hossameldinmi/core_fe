import 'package:permission_handler/permission_handler.dart';

class PermissionsHandler {
  static Future<bool> isStorageGranted() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }
}
