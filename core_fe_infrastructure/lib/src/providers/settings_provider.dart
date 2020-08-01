import 'package:core_fe_infrastructure/src/constants/storage_keys.dart';
import 'package:core_fe_infrastructure/src/interfaces/i_noSql_storage.dart';
import 'package:core_fe_infrastructure/src/interfaces/i_settings.dart';
import 'package:core_fe_infrastructure/src/models/settings.dart';

class SettingsProvider implements ISettingsProvider {
  final INoSqlStorageManager _noSqlStorageManager;
  SettingsProvider(this._noSqlStorageManager);
  @override
  Future<void> deleteSettings() async {
    await _noSqlStorageManager.delete(StorageKey.kSettingsStorageKey);
  }

  @override
  Future<Settings> getSettings() {
    return _noSqlStorageManager.get<Settings>(StorageKey.kSettingsStorageKey);
  }

  @override
  Future<void> initSettings(Settings settings) async {
    return _noSqlStorageManager.addOrUpdate<Settings>(
      key: StorageKey.kSettingsStorageKey,
      data: settings,
    );
  }

  @override
  Future<void> updateSettings(Settings settings) async {
    return _noSqlStorageManager.addOrUpdate<Settings>(
      key: StorageKey.kSettingsStorageKey,
      data: settings,
    );
  }
}
