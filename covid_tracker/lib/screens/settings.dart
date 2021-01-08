import 'package:covid_tracker/providers/covid_locations.dart';
import 'package:covid_tracker/providers/health_status_provider.dart';
import 'package:covid_tracker/providers/settings_provider.dart';
import 'package:covid_tracker/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  BehaviorSubject<double> radius = BehaviorSubject.seeded(1.0);
  List<bool> isSelected = [false, false, false];
  FocusNode focusNodeButton1 = FocusNode();
  FocusNode focusNodeButton2 = FocusNode();
  FocusNode focusNodeButton3 = FocusNode();
  List<FocusNode> focusToggle;

  _updateQuery(value) {
    final zoomMap = {
      1.0: 12.0,
      2.6: 10.0,
      4.2: 7.0,
      5.8: 6.0,
      7.4: 5.0,
      9.0: 5.0,
    };
    final zoom = zoomMap[value];
    print(zoom);
    //mapController.moveCamera(CameraUpdate.zoomTo(zoom));

    setState(() {
      radius.add(value);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusToggle = [focusNodeButton1, focusNodeButton2, focusNodeButton3];
    Future.delayed(Duration.zero).then((_) {
      String mapType =
          Provider.of<SettingsProvider>(context, listen: false).mapType;
      int index = 0;
      mapType == 'normal'
          ? index = 0
          : mapType == 'satellite'
              ? index = 1
              : index = 2;
      setState(() {
        isSelected[index] = true;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNodeButton1.dispose();
    focusNodeButton2.dispose();
    focusNodeButton3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                              color: DarkTheme.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        FlatButton.icon(
                          icon: Icon(
                            Icons.save,
                            color: DarkTheme.primary,
                          ),
                          padding: EdgeInsets.all(0),
                          color: DarkTheme.black,
                          splashColor: DarkTheme.button,
                          label: Text(
                            'SAVE',
                            style: TextStyle(
                              color: DarkTheme.primary,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            String mapType;
                            isSelected[0] == true
                                ? mapType = 'normal'
                                : isSelected[1] == true
                                    ? mapType = 'satellite'
                                    : mapType = 'hybrid';
                            Provider.of<SettingsProvider>(context,
                                    listen: false)
                                .updateMapType(mapType);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: DarkTheme.appBar,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Radius of search',
                            style: TextStyle(
                              color: DarkTheme.secondaryText,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Column(
                              children: [
                                Slider(
                                  min: 1.0,
                                  max: 9.0,
                                  divisions: 5,
                                  value: radius.value,
                                  label: 'Radius ${radius.value}km',
                                  activeColor: DarkTheme.secondary,
                                  inactiveColor:
                                      DarkTheme.secondary.withOpacity(0.2),
                                  onChanged: _updateQuery,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '1.0 km',
                                      style: TextStyle(
                                        color: DarkTheme.secondary,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '9.0 km',
                                      style: TextStyle(
                                        color: DarkTheme.secondary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Map Type',
                            style: TextStyle(
                              color: DarkTheme.secondaryText,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: SizedBox(
                              height: 35,
                              child: ToggleButtons(
                                color: DarkTheme.primary,
                                selectedColor: Colors.white,
                                fillColor: DarkTheme.primary,
                                splashColor: Colors.lightBlue,
                                highlightColor: Colors.lightBlue,
                                borderColor: DarkTheme.primary,
                                borderWidth: 0.5,
                                selectedBorderColor: DarkTheme.primary,
                                renderBorder: true,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                disabledColor: Colors.blueGrey,
                                disabledBorderColor: Colors.blueGrey,
                                focusColor: Colors.red,
                                focusNodes: focusToggle,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text('  Normal '),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text('Satellite'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text('  Hybrid  '),
                                  ),
                                ],
                                isSelected: isSelected,
                                onPressed: (int index) {
                                  isSelected.clear();
                                  isSelected.addAll([false, false, false]);
                                  setState(() {
                                    isSelected[index] = true;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: FlatButton.icon(
                  icon: Icon(Icons.logout),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text('Logout'),
                  color: DarkTheme.button,
                  splashColor: Colors.lightBlue,
                  highlightColor: Colors.lightBlue,
                  disabledColor: Colors.blueGrey,
                  textColor: Colors.white,
                  onPressed: () {
                    Provider.of<HealthStatusProvider>(context, listen: false)
                        .reset();
                    Provider.of<CovidLocations>(context, listen: false).reset();
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
