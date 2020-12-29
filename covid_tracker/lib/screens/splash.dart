import 'package:covid_tracker/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkTheme.background,
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/loading.png',
              width: 200,
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
