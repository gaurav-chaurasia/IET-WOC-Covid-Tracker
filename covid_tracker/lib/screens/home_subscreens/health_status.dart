import 'package:covid_tracker/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HealthStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        
        child: Container(
          child: Center(
            child: Text(
              'YOUR HEALTH STATUS',
              style: TextStyle(color: DarkTheme.primaryText),
            ),
          ),
        ),
      ),
    );
  }
}
