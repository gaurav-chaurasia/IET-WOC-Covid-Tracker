import 'package:covid_tracker/providers/CovidLocations.dart';
import 'package:covid_tracker/providers/MyLocation.dart';
import 'package:covid_tracker/screens/home.dart';
import 'package:covid_tracker/screens/notifications.dart';
import 'package:covid_tracker/styles.dart';
import 'package:covid_tracker/widgets/android_home.dart';
import 'package:covid_tracker/widgets/ios_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyLocation>(
          create: (_) => MyLocation(),
        ),
        ChangeNotifierProvider<CovidLocations>(
          create: (_) => CovidLocations(),
        ),
      ],
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Covid Tracker',
        theme: CupertinoThemeData(
          primaryColor: DarkTheme.primary,
          barBackgroundColor: DarkTheme.appBar,
          scaffoldBackgroundColor: DarkTheme.black,
        ),
        home: MyHomePage(title: 'Covid Tracker'),
        routes: {
          IOSHome.routeName: (ctx) => IOSHome(),
          AndroidHome.routeName: (ctx) => Home(),
          Notifications.routeName: (ctx) => Notifications(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Covid Tracker'),
        ),
        body: FlatButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/ios_home');
          },
          child: Center(
            child: Text('COVID TRACKER HOME PAGE'),
          ),
        ),
      ),
    );
  }
}
