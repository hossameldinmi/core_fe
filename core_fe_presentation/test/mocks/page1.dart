import 'package:core_fe_presentation/core_fe_presentation.dart';
import 'package:flutter/material.dart';
import 'my_app.dart';

class HomePage extends StatefulWidget {
  static const route = '/';
  const HomePage({Key? key}) : super(key: key);
  final String title = route;
  static NavigationFunc? navigationFunc;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Object? navResponse;
  void navigate() async {
    try {
      var response = await HomePage.navigationFunc!(context);
      setState(() {
        navResponse = response;
      });
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = RouteUtil.argsOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              navResponse?.toString() ?? '',
            ),
            Text(args?.toString() ?? ''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigate,
        tooltip: 'Navigate',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Page1 extends StatefulWidget {
  static const route = '/Page1';
  const Page1({Key? key}) : super(key: key);
  final String title = route;
  static NavigationFunc? navigationFunc;
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  Object? navResponse;
  void navigate() async {
    try {
      var response = await Page1.navigationFunc!(context);
      setState(() {
        navResponse = response;
      });
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = RouteUtil.argsOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              navResponse?.toString() ?? '',
            ),
            Text(args?.toString() ?? ''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigate,
        tooltip: 'Navigate',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Page2 extends StatefulWidget {
  static const route = '/Page2';
  const Page2({Key? key}) : super(key: key);
  final String title = route;
  static NavigationFunc? navigationFunc;
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  Object? navResponse;
  void navigate() async {
    try {
      var response = await Page2.navigationFunc!(context);
      setState(() {
        navResponse = response;
      });
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = RouteUtil.argsOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              navResponse?.toString() ?? '',
            ),
            Text(args?.toString() ?? ''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigate,
        tooltip: 'Navigate',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
