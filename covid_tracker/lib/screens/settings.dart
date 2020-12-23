import 'package:covid_tracker/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: Container(
          child: Center(
            child: Text(
              'SETTINGS',
              style: TextStyle(color: DarkTheme.primaryText),
            ),
          ),
        ),
      ),
    );
  }
}
