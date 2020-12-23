import 'package:covid_tracker/providers/CovidLocations.dart';
import 'package:covid_tracker/providers/MyLocation.dart';
import 'package:covid_tracker/screens/home.dart';
import 'package:covid_tracker/screens/notifications.dart';
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Covid Tracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(title: 'Covid Tracker'),
        routes: {
          Home.routeName: (ctx) => Home(),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid Tracker'),
      ),
      body: FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/home');
        },
        child: Center(
          child: Text('COVID TRACKER HOME PAGE'),
        ),
      ),
    );
  }
}
