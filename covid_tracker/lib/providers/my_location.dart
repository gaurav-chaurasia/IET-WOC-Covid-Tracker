import 'dart:async';

import 'package:covid_tracker/providers/location_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyLocation with ChangeNotifier {
  Location _locationTracker = Location();
  StreamSubscription locationSubscription;
  CameraPosition _initialLocation;

  CameraPosition get initialLocation {
    return _initialLocation;
  }

  //to check for location permission status and enable gps
  Future<bool> _checkLocationPermissionStatus(BuildContext context) async {
    final service = await _locationTracker.serviceEnabled();
    if (service == false) {
      await _locationTracker.requestService();
    }
    bool permission =
        await LocationServices().requestLocationPermission(context);
    return permission;
  }

  //to get the initial location of the user
  Future<bool> getInitialLocation(BuildContext context) async {
    var locationPermission = await _checkLocationPermissionStatus(context);
    if (locationPermission == false) return false;
    try {
      var location = await _locationTracker.getLocation();
      _initialLocation = CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 14.4746,
        tilt: 0,
      );
      return true;
    } on PlatformException catch (e) {
      print("permission denied by getInititalLocation() : " + e.message);
      return false;
    }
  }

  void recenter(GoogleMapController controller) {
    _initialLocation = new CameraPosition(
        target: _initialLocation.target,
        zoom: 17,
        tilt: 37,
        bearing: 192.8334901395799);
    if (controller != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          _initialLocation,
        ),
      );
    }
  }

  // to get the current location of the user
  Future<void> getCurrentLocation(GoogleMapController controller) async {
    try {
      if (locationSubscription != null) {
        locationSubscription.cancel();
      }
      locationSubscription = _locationTracker.onLocationChanged.listen(
        (newLocalData) {
          if (controller != null) {
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                new CameraPosition(
                    bearing: 192.8334901395799,
                    target:
                        LatLng(newLocalData.latitude, newLocalData.longitude),
                    tilt: 37,
                    zoom: 17),
              ),
            );
            _initialLocation = new CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(newLocalData.latitude, newLocalData.longitude),
                tilt: 37,
                zoom: 17);
          }
        },
      );
      return true;
    } on PlatformException catch (e) {
      debugPrint("Permission Denied by getCurrentLocation() : " + e.message);
      return false;
    }
  }
}
