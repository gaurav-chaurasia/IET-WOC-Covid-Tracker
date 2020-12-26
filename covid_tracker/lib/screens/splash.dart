import 'package:covid_tracker/screens/home.dart';
import 'package:covid_tracker/styles.dart';
import 'package:flutter/widgets.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new Home(),
      title: Text(
        'COVID TRACKER',
        style: TextStyle(fontSize: 30.0, color: DarkTheme.primary),
      ),
      image: Image.asset(
        'assets/covid19.png',
        fit: BoxFit.contain,
      ),
      backgroundColor: DarkTheme.background,
      loaderColor: DarkTheme.primary,
      photoSize: 150,
      gradientBackground: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [DarkTheme.button, DarkTheme.background]),
    );
  }
}
