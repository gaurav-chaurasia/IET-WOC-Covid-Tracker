import 'package:covid_tracker/providers/covid_locations.dart';
import 'package:covid_tracker/providers/my_location.dart';
import 'package:covid_tracker/screens/home.dart';
import 'package:covid_tracker/screens/notifications.dart';
import 'package:covid_tracker/screens/splash.dart';
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
        home: Splash(),
        routes: {
          IOSHome.routeName: (ctx) => IOSHome(),
          AndroidHome.routeName: (ctx) => AndroidHome(),
          Notifications.routeName: (ctx) => Notifications(),
          Home.routeName: (ctx) => Home(),
        },
      ),
    );
  }
}
