import 'package:covid_tracker/providers/covid_locations.dart';
import 'package:covid_tracker/providers/health_status_provider.dart';
import 'package:covid_tracker/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(color: DarkTheme.primaryText),
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: FlatButton(
                  color: DarkTheme.button,
                  child: Text(
                    'Log Out',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: DarkTheme.primaryText),
                  ),
                  onPressed: () {
                    //reset every data
                    Provider.of<HealthStatusProvider>(context, listen: false)
                        .reset();
                    Provider.of<CovidLocations>(context, listen: false).reset();
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
