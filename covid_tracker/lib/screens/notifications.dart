import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  static const routeName = '/notifications';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('NOTIFICATIONS'),
      ),
    );
  }
}
