import 'dart:async';

import 'package:covid_tracker/providers/covid_locations.dart';
import 'package:covid_tracker/providers/my_location.dart';
import 'package:covid_tracker/styles.dart';
import 'package:covid_tracker/widgets/error_refresh_button.dart';
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
    await _myLocation.getCurrentLocation(context, _controller);
    initialLocation = _myLocation.initialLocation;
    _covidLocation = Provider.of<CovidLocations>(context, listen: false);
    //get all covid locations
    await _covidLocation.fetchAndSetInfectedPoints(context);
    return;
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
            'Covid Tracker',
            style: TextStyle(color: DarkTheme.primaryText),
          ),
        ),
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
                : Consumer2<MyLocation, CovidLocations>(
                    builder: (ctx, myLocation, covidLocation, child) {
                      List<Marker> markers = [];
                      //markers.addAll(myLocation.marker);
                      markers.addAll(covidLocation.markers);
                      Circle circle = myLocation.circle;
                      return GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: initialLocation,
                        markers: Set.of((markers != null) ? markers : []),
                        circles: Set.of((circle != null) ? [circle] : []),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                      );
                    },
                  ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: RecenterFloatingActionButton(_controller),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
