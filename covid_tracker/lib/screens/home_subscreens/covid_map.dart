import 'dart:async';

import 'package:covid_tracker/providers/CovidLocations.dart';
import 'package:covid_tracker/providers/MyLocation.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      await getAllMarkers();
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> getAllMarkers() async {
    _myLocation = Provider.of<MyLocation>(context, listen: false);
    await _myLocation.getInitialLocation();
    initialLocation = _myLocation.initialLocation;
    _covidLocation = Provider.of<CovidLocations>(context, listen: false);
    await _covidLocation.fetchAndSetInfectedPoints(context);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer2<MyLocation, CovidLocations>(
              builder: (ctx, myLocation, covidLocation, child) {
                List<Marker> markers = [];
                markers.addAll(myLocation.marker);
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
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.location_searching),
        onPressed: () {
          _myLocation.getCurrentLocation(context, _controller);
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
