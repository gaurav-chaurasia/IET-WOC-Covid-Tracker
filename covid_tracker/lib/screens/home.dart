import 'package:covid_tracker/providers/health_status_provider.dart';
import 'package:covid_tracker/providers/settings_provider.dart';
import 'package:covid_tracker/screens/firebase/auth/phone_auth/get_phone.dart';
import 'package:covid_tracker/screens/firebase/auth/phone_auth/select_country.dart';
import 'package:covid_tracker/screens/firebase/auth/phone_auth/verify.dart';
import 'package:covid_tracker/screens/notifications.dart';
import 'package:covid_tracker/screens/splash.dart';
import 'package:covid_tracker/utils/styles.dart';
import 'package:covid_tracker/widgets/android_home.dart';
import 'package:covid_tracker/widgets/ios_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final User user;
  Home([this.user]);
  static const routeName = '/home';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loadData(BuildContext context) async {
    await Provider.of<SettingsProvider>(context, listen: false).fetchMapType();
  }

  Widget splashScreen() {
    return MaterialApp(
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: _auth.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return splashScreen();
        } else if (snapshot.hasData && !snapshot.data.isAnonymous) {
          return FutureBuilder(
              future: loadData(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return splashScreen();
                return CupertinoApp(
                  title: 'Covid Tracker',
                  theme: CupertinoThemeData(
                    primaryColor: DarkTheme.primary,
                    barBackgroundColor: DarkTheme.appBar,
                    scaffoldBackgroundColor: DarkTheme.black,
                    textTheme: CupertinoTextThemeData(
                        primaryColor: DarkTheme.primaryText),
                  ),
                  home: IOSHome(),
                  debugShowCheckedModeBanner: false,
                  routes: {
                    IOSHome.routeName: (ctx) => IOSHome(),
                    AndroidHome.routeName: (ctx) => AndroidHome(),
                    Notifications.routeName: (ctx) => Notifications(),
                  },
                );
              });
        }
        return MaterialApp(
            theme: ThemeData(
              primaryColor: DarkTheme.primary,
              bottomAppBarColor: DarkTheme.appBar,
              scaffoldBackgroundColor: DarkTheme.black,
            ),
            home: PhoneAuthGetPhone(),
            color: DarkTheme.background,
            debugShowCheckedModeBanner: false,
            routes: {
              SelectCountry.routeName: (ctx) => SelectCountry(),
              PhoneAuthVerify.routeName: (ctx) => PhoneAuthVerify(),
            });
      },
    );
  }
}
