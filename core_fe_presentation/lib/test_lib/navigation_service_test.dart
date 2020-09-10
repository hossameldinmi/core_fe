// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:core_fe_presentation/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks/my_app.dart';
import 'mocks/page1.dart';

void main() {
  final navigationService = NavigationServiceImpl(Page1.route);
  group('Navigation.push', () {
    tearDown(() {
      HomePage.navigationFunc = null;
      Page1.navigationFunc = null;
      Page1.navigationFunc = null;
    });

    testWidgets('Navigation.push normal push', (WidgetTester tester) async {
      HomePage.navigationFunc =
          (cxt) => navigationService.push(cxt, Page1.route);
      Page1.navigationFunc = (cxt) {
        navigationService.pop(cxt);
        return Future.value();
      };
      await tester.pumpWidget(MyApp(HomePage.route));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      verify(mockObserver.didPush(any, any));
      await tester.pump();
      // Verify that our counter has incremented
      expect(find.text(Page1.route), findsOneWidget);
      expect(find.byType(Page1), findsOneWidget);

      // await tester.tap(find.byIcon(Icons.add));
      // await tester.pump();

      // expect(find.text(Page1.route), findsOneWidget);
      // expect(find.byType(Page1), findsOneWidget);
    });

    testWidgets('Navigation.push with param', (WidgetTester tester) async {
      HomePage.navigationFunc =
          (cxt) => navigationService.push(cxt, Page1.route, args: 'Param');

      Page1.navigationFunc = (cxt) {
        navigationService.pop(cxt);
        return Future.value();
      };
      await tester.pumpWidget(MyApp(HomePage.route));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      verify(mockObserver.didPush(any, any));
      await tester.pump();
      // Verify that our counter has incremented
      expect(find.text(Page1.route), findsOneWidget);
      expect(find.text('Param'), findsOneWidget);
      expect(find.byType(Page1), findsOneWidget);
    });

    testWidgets('Navigation.push with wrong route',
        (WidgetTester tester) async {
      HomePage.navigationFunc =
          (cxt) => navigationService.push(cxt, 'Wrongroute');
      await tester.pumpWidget(MyApp(HomePage.route));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      verify(mockObserver.didPush(any, any));
      await tester.pump();
      // Verify that our counter has incremented
      expect(find.text('No route defined for Wrongroute'), findsOneWidget);
      expect(find.byType(Page1), findsNothing);
    });
  });

}
