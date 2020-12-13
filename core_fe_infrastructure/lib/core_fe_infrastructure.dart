import 'package:core_fe_dart/utils.dart';
import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_infrastructure/interfaces.dart';
import 'package:core_fe_infrastructure/managers.dart';
import 'package:core_fe_infrastructure/providers.dart';
import 'package:core_fe_infrastructure/utils.dart';

import 'constants.dart';

class CoreFeInfrastructureModule extends BaseModule {
  CoreFeInfrastructureModule();
  @override
  Future<void> setUp() async {
    var dbPath = await PathProvider.getDocumentPath();
    iocInstance.registerSingleton<Connectivity>(ConnectivityImpl());
    iocInstance.registerSingleton<DateTimeWrapper>(DateTimeWrapperImpl());

    iocInstance.registerSingletonWithDependencies<HttpHelper>(
        () => HttpHelperImpl(
            iocInstance<SessionManagerImpl>(), iocInstance<SettingsManager>()),
        dependsOn: [SessionManagerImpl, SettingsManager]);

    iocInstance.registerSingletonWithDependencies<NoSqlStorageProvider>(
        () => SembastStorageProviderImpl(dbPath));
    iocInstance.registerSingletonWithDependencies<NoSqlStorageProvider>(
        () => SembastStorageProviderImpl(dbPath, isInMemoryDb: true),
        instanceName: IocKeys.cachedStorageProvider);
    iocInstance.registerSingletonWithDependencies<NoSqlStorageManager>(
      () => NoSqlStorageManagerImpl(
        iocInstance<NoSqlStorageProvider>(),
        iocInstance<DateTimeWrapper>(),
      ),
      dependsOn: [NoSqlStorageProvider, DateTimeWrapper],
    );

    iocInstance.registerSingletonWithDependencies<NoSqlStorageManager>(
        () => NoSqlStorageManagerImpl(
              iocInstance<NoSqlStorageProvider>(
                  instanceName: IocKeys.cachedStorageProvider),
              iocInstance<DateTimeWrapper>(),
            ),
        dependsOn: [NoSqlStorageProvider, DateTimeWrapper],
        instanceName: IocKeys.cachedStorageManager);

    iocInstance.registerSingletonWithDependencies<SessionProvider>(
      () => SessionProviderImpl(
        iocInstance<NoSqlStorageManager>(),
        iocInstance<NoSqlStorageManager>(
            instanceName: IocKeys.cachedStorageManager),
      ),
      dependsOn: [NoSqlStorageManager],
    );

    iocInstance.registerSingletonWithDependencies<SessionManager>(
        () => SessionManagerImpl(
              iocInstance<SessionProvider>(),
            ),
        dependsOn: [SessionProvider]);

    iocInstance.registerSingletonWithDependencies<SettingsProvider>(
        () => SettingsProviderImpl(iocInstance<NoSqlStorageManager>()),
        dependsOn: [NoSqlStorageManager]);

    iocInstance.registerSingletonWithDependencies<SettingsManager>(
        () => SettingsManagerImpl(iocInstance<SettingsProvider>()),
        dependsOn: [SettingsProvider]);
  }
}
