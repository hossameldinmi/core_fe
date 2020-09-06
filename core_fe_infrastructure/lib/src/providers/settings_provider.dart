import 'package:core_fe_infrastructure/src/constants/storage_key.dart';
import 'package:core_fe_infrastructure/src/interfaces/i_noSql_storage.dart';
import 'package:core_fe_infrastructure/src/interfaces/i_settings.dart';
import 'package:core_fe_infrastructure/src/models/settings.dart';

class SettingsProvider implements ISettingsProvider {
  final INoSqlStorageManager _noSqlStorageManager;
  SettingsProvider(this._noSqlStorageManager);
  @override
  Future<void> deleteSettings() =>
      _noSqlStorageManager.delete(StorageKey.settingsStorageKey);

  @override
  Future<Settings> getSettings() =>
      _noSqlStorageManager.get<Settings>(StorageKey.settingsStorageKey);

  @override
  Future<void> initSettings(Settings settings) =>
      _noSqlStorageManager.addOrUpdate<Settings>(
        key: StorageKey.settingsStorageKey,
        data: settings,
      );

  @override
  Future<void> updateSettings(Settings settings) =>
      _noSqlStorageManager.addOrUpdate<Settings>(
        key: StorageKey.settingsStorageKey,
        data: settings,
      );
}
