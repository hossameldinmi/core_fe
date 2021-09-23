import 'package:core_fe_presentation/core_fe_presentation.dart';
import 'package:flutter/material.dart';
import 'my_app.dart';

class HomePage extends StatefulWidget {
  static const route = '/';
  HomePage({Key? key}) : super(key: key);
  final String title = route;
  static NavigationFunc? navigationFunc;
  @override
  _HomePageState createState() => _HomePageState(navigationFunc);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.navigationFunc);
  NavigationFunc? navigationFunc;
  Object? navResponse;
  void navigate() async {
    try {
      var response = await navigationFunc!(context);
      setState(() {
        navResponse = response;
      });
    } catch (e) {
      print(e);
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
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Page1 extends StatefulWidget {
  static const route = '/Page1';
  Page1({Key? key}) : super(key: key);
  final String title = route;
  static NavigationFunc? navigationFunc;
  @override
  _Page1State createState() => _Page1State(navigationFunc);
}

class _Page1State extends State<Page1> {
  _Page1State(this.navigationFunc);
  NavigationFunc? navigationFunc;
  Object? navResponse;
  void navigate() async {
    try {
      var response = await navigationFunc!(context);
      setState(() {
        navResponse = response;
      });
    } catch (e) {
      print(e);
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
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Page2 extends StatefulWidget {
  static const route = '/Page2';
  Page2({Key? key}) : super(key: key);
  final String title = route;
  static NavigationFunc? navigationFunc;
  @override
  _Page2State createState() => _Page2State(navigationFunc);
}

class _Page2State extends State<Page2> {
  _Page2State(this.navigationFunc);
  final NavigationFunc? navigationFunc;
  Object? navResponse;
  void navigate() async {
    try {
      var response = await navigationFunc!(context);
      setState(() {
        navResponse = response;
      });
    } catch (e) {
      print(e);
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
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
