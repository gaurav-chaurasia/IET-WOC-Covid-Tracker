import 'package:covid_tracker/screens/Settings.dart';
import 'package:covid_tracker/screens/home_subscreens/covid_map.dart';
import 'package:covid_tracker/screens/home_subscreens/covid_updates.dart';
import 'package:covid_tracker/screens/home_subscreens/health_status.dart';
import 'package:covid_tracker/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class IOSHome extends StatefulWidget {
  static const routeName = '/ios_home';
  @override
  _IOSHomeState createState() => _IOSHomeState();
}

class _IOSHomeState extends State<IOSHome> {
  CupertinoTabController _cupertinoTabController;

  @override
  void dispose() {
    super.dispose();
    _cupertinoTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: false,
      controller: _cupertinoTabController,
      tabBar: CupertinoTabBar(
        iconSize: 25,
        border: Border(
          top: BorderSide(
            color: DarkTheme.primary,
            width: 1,
          ),
        ),
        currentIndex: 1,
        activeColor: DarkTheme.primary,
        backgroundColor: DarkTheme.background,
        inactiveColor: DarkTheme.secondaryText,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesome.heartbeat,
              ),
              label: "Your Status"),
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.map_pin_ellipse,
              ),
              label: "Covid Map"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesome.bar_chart,
              ),
              label: "Covid Updates"),
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.settings,
              ),
              label: "Settings"),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return HealthStatus();
              case 1:
                return CovidMap();
              case 2:
                return CovidUpdates();
              case 3:
                return Settings();
              default:
                return CovidMap();
            }
          },
        );
      },
    );
  }
}
