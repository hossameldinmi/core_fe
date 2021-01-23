import 'dart:async';

import 'package:core_fe_dart/utils.dart';
import 'package:core_fe_flutter/enums.dart';
import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_infrastructure/interfaces.dart';
import 'package:core_fe_infrastructure/managers.dart';
import 'package:core_fe_infrastructure/providers.dart';
import 'package:core_fe_infrastructure/utils.dart';

import 'constants.dart';
import 'models.dart';
import 'src/interfaces/http_network.dart';

class CoreFeInfrastructureModule implements BaseModule {
  CoreFeInfrastructureModule(this._dpName);
  Completer<void> _completer;
  final String _dpName;

  @override
  Future<void> setUp() {
    _completer ??= Completer();
    PathProvider.getDocumentPath().then((dbPath) {
      locator.registerLazySingleton<NoSqlStorageProvider>(
          () => SembastStorageProviderImpl(dbPath + _dpName));
      locator.registerLazySingleton<NoSqlStorageProvider>(
          () =>
              SembastStorageProviderImpl(dbPath + _dpName, isInMemoryDb: true),
          instanceName: IocKeys.cachedStorageProvider);
      _completer.complete();
    });
    locator.registerSingleton<Connectivity>(ConnectivityImpl());
    locator.registerSingleton<DateTimeWrapper>(DateTimeWrapperImpl());

    locator.registerLazySingleton<HttpHelper>(
      () => HttpHelperImpl(
          locator<SessionManagerImpl>(), locator<SettingsManager>()),
    );

    locator.registerLazySingleton<NoSqlStorageManager>(
      () => NoSqlStorageManagerImpl(
        locator<NoSqlStorageProvider>(),
        locator<DateTimeWrapper>(),
      ),
    );

    locator.registerLazySingleton<NoSqlStorageManager>(
        () => NoSqlStorageManagerImpl(
              locator<NoSqlStorageProvider>(
                  instanceName: IocKeys.cachedStorageProvider),
              locator<DateTimeWrapper>(),
            ),
        instanceName: IocKeys.cachedStorageManager);

    locator.registerLazySingleton<SessionProvider>(
      () => SessionProviderImpl(
        locator<NoSqlStorageManager>(),
        locator<NoSqlStorageManager>(
            instanceName: IocKeys.cachedStorageManager),
      ),
    );

    locator.registerLazySingleton<SessionManager>(
      () => SessionManagerImpl(
        locator<SessionProvider>(),
      ),
    );

    locator.registerLazySingleton<SettingsProvider>(
      () => SettingsProviderImpl(locator<NoSqlStorageManager>()),
    );

    locator.registerLazySingleton<SettingsManager>(
      () => SettingsManagerImpl(locator<SettingsProvider>(),
          defaultSettings: Settings(language: Language.ar_EG)),
    );
    return _completer.future;
  }
}
