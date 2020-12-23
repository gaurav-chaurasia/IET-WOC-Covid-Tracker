import 'package:flutter/material.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Settings",
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chevron_left),
                    Icon(Icons.settings),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            child: Center(
              child: Text('DRAWER'),
            ),
          ),
        ),
      ],
    );
  }
}
