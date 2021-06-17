import 'package:covid_tracker/providers/health_status_provider.dart';
import 'package:covid_tracker/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HealthStatus extends StatefulWidget {
  @override
  _HealthStatusState createState() => _HealthStatusState();
}

class _HealthStatusState extends State<HealthStatus> {
  var isLoading = false;
  var healthData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    healthData = Provider.of<HealthStatusProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: DarkTheme.black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    'Your Status',
                    style: TextStyle(
                        color: DarkTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'I am corona positive',
                      style: TextStyle(
                        color: DarkTheme.primaryText,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isLoading == true
                        ? CircularProgressIndicator()
                        : FlatButton(
                            color: DarkTheme.button,
                            child: healthData.covidStatus == true
                                ? Text(
                                    'Reset',
                                    style: TextStyle(color: DarkTheme.green),
                                  )
                                : Text(
                                    'Confirm',
                                    style: TextStyle(color: DarkTheme.red),
                                  ),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await healthData.updateStatus(
                                !healthData.covidStatus,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
