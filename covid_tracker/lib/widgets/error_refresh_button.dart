import 'package:covid_tracker/styles.dart';
import 'package:flutter/material.dart';

class ErrorRefreshButton extends StatelessWidget {
  final Function refresh;
  ErrorRefreshButton(this.refresh);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Something went wrong! :(',
          style: TextStyle(color: DarkTheme.primaryText),
        ),
        FlatButton(
          color: DarkTheme.button,
          child: Text(
            'Refresh',
            style: TextStyle(color: DarkTheme.primary),
          ),
          onPressed: () => refresh(),
        ),
      ],
    );
  }
}
