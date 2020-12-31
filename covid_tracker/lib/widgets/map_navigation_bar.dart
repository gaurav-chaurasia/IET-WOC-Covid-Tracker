import 'package:covid_tracker/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.location_pin,
              size: 36,
              color: DarkTheme.red,
            ),
          ),
          Expanded(
              child: CupertinoTextField(
            clearButtonMode: OverlayVisibilityMode.editing,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DarkTheme.appBar.withOpacity(0),
            ),
            placeholder: 'Search here',
            style: TextStyle(
                fontSize: 18.0,
                height: 1.5,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )),
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 2, left: 8),
            child: Icon(
              CupertinoIcons.profile_circled,
              size: 36,
              color: DarkTheme.primary,
            ),
          ),
        ],
      ),
      elevation: 16,
      color: DarkTheme.appBar.withOpacity(0.9),
    );
  }
}
