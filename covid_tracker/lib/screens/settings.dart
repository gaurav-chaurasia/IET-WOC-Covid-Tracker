import 'package:covid_tracker/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: DarkTheme.black,
        appBar: CupertinoNavigationBar(
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: DarkTheme.primary,
            ),
            onPressed: () {},
          ),
          middle: Text(
            'Settings',
            style: TextStyle(color: DarkTheme.primaryText),
          ),
        ),
        body: Container(
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
