import 'package:core_fe_presentation/src/widget/route_generator.dart';
import 'package:core_fe_presentation/test_lib/mocks/page1.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp(this.initialRoute);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    RouteGenerator.wiringWidgets = routes();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorObservers: [mockObserver],
    );
  }
}

Map<String, Widget Function(BuildContext)> routes() => {
      HomePage.route: (cxt) => HomePage(),
      Page1.route: (cxt) => Page1(),
      Page2.route: (cxt) => Page2(),
    };

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

final mockObserver = MockNavigatorObserver();
typedef NavigationFunc<T> = Future<T> Function(BuildContext);
