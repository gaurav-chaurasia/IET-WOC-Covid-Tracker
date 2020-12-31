import 'dart:async';

import 'package:covid_tracker/providers/covid_locations.dart';
import 'package:covid_tracker/providers/my_location.dart';
import 'package:covid_tracker/utils/styles.dart';
import 'package:covid_tracker/widgets/error_refresh_button.dart';
import 'package:covid_tracker/widgets/map_navigation_bar.dart';
import 'package:covid_tracker/widgets/recenter_floating_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CovidMap extends StatefulWidget {
  @override
  _CovidMapState createState() => _CovidMapState();
}

class _CovidMapState extends State<CovidMap>
    with AutomaticKeepAliveClientMixin {
  var _isLoading = true;
  CameraPosition initialLocation;
  GoogleMapController _controller;
  var _myLocation;
  var _covidLocation;
  var _errorOccured = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //init state to initialize the location data in the location provider and get all locations
    Future.delayed(Duration.zero).then((_) async {
      await getAllLocations();
      setState(() {
        _isLoading = false;
      });
    });
  }

  //to get all locations to be marked in the map
  Future<void> getAllLocations() async {
    _myLocation = Provider.of<MyLocation>(context, listen: false);
    //check for location access
    bool initialLocationGranted = await _myLocation.getInitialLocation(context);
    //if location not granted then display an error message
    if (initialLocationGranted == false) {
      _errorOccured = true;
      return;
    }
    await _myLocation.getCurrentLocation(_controller);
    initialLocation = _myLocation.initialLocation;
    _covidLocation = Provider.of<CovidLocations>(context, listen: false);
    //get all covid locations
    await _covidLocation.fetchAndSetInfectedPoints(context);
  }

  void refresh() async {
    setState(() {
      _isLoading = true;
      _errorOccured = false;
    });
    await getAllLocations();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkTheme.black,
      resizeToAvoidBottomInset: false,
      body: _isLoading == true
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 25,
                animating: true,
              ),
            )
          : _errorOccured == true
              ? Center(
                  child: ErrorRefreshButton(refresh),
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: Consumer<CovidLocations>(
                        builder: (ctx, covidLocation, child) {
                          List<Marker> markers = [];
                          List<Circle> circles = [];
                          //markers.addAll(myLocation.marker);
                          markers.addAll(covidLocation.markers);
                          circles.addAll(covidLocation.circles);
                          return GoogleMap(
                            mapType: MapType.normal,
                            trafficEnabled: true,
                            buildingsEnabled: true,
                            initialCameraPosition: initialLocation,
                            markers: Set.of((markers != null) ? markers : []),
                            circles: Set.of((circles != null) ? circles : []),
                            onMapCreated: (GoogleMapController controller) {
                              _controller = controller;
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            compassEnabled: false,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      height: 90,
                      child: SafeArea(
                        child: MapNavigationBar(),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      child: RawMaterialButton(
                        onPressed: () async {
                          _myLocation.recenter(_controller);
                        },
                        elevation: 8.0,
                        fillColor: DarkTheme.button.withOpacity(0.8),
                        child: Icon(
                          Icons.my_location,
                          size: 30.0,
                          color: DarkTheme.primary,
                        ),
                        padding: EdgeInsets.all(12.0),
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RefetchFloatingActionButton(_controller, context),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
