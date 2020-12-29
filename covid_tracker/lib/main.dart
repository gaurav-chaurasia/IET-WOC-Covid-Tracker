import 'package:covid_tracker/providers/countries.dart';
import 'package:covid_tracker/providers/covid_locations.dart';
import 'package:covid_tracker/providers/my_location.dart';
import 'package:covid_tracker/providers/phone_auth.dart';
import 'package:covid_tracker/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyLocation>(
          create: (_) => MyLocation(),
        ),
        ChangeNotifierProvider<CovidLocations>(
          create: (_) => CovidLocations(),
        ),
        ChangeNotifierProvider(
          create: (context) => CountryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PhoneAuthDataProvider(),
        ),
      ],
      child: Home(),
    );
  }
}
