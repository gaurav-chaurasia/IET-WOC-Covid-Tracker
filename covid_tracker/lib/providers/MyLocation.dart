import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyLocation with ChangeNotifier {
  Location _locationTracker = Location();
  StreamSubscription locationSubscription;
  CameraPosition _initialLocation;
  //List<Marker> _marker = [];
  Circle _circle;

  CameraPosition get initialLocation {
    return _initialLocation;
  }

  // List<Marker> get marker {
  //   return [..._marker];
  // }

  Circle get circle {
    return _circle;
  }

  Future<void> getInitialLocation() async {
    final permission = await _locationTracker.hasPermission();
    final service = await _locationTracker.serviceEnabled();
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      await _locationTracker.requestPermission();
    }
    if (service == false) {
      await _locationTracker.requestService();
    }
    var location = await _locationTracker.getLocation();
    _initialLocation = CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: 14.4746,
    );
    notifyListeners();
  }

  // Future<Uint8List> getMarker(BuildContext context) async {
  //   ByteData byteData =
  //       await DefaultAssetBundle.of(context).load("assets/arrow.png");
  //   return byteData.buffer.asUint8List();
  // }

  // void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
  //   LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
  //   _marker.clear();
  //   _marker.add(Marker(
  //       markerId: MarkerId("home"),
  //       position: latlng,
  //       rotation: newLocalData.heading,
  //       draggable: false,
  //       zIndex: 2,
  //       flat: true,
  //       anchor: Offset(0.065, 0.07),
  //       icon: BitmapDescriptor.fromBytes(imageData)));
  //   _circle = Circle(
  //       circleId: CircleId("home"),
  //       radius: newLocalData.accuracy,
  //       zIndex: 1,
  //       strokeWidth: 4,
  //       strokeColor: Colors.blue,
  //       center: latlng,
  //       fillColor: Colors.blue.withAlpha(70));
  //   notifyListeners();
  // }

  Future<void> getCurrentLocation(
      BuildContext context, GoogleMapController _controller) async {
    try {
      // Uint8List imageData = await getMarker(context);
      // var location = await _locationTracker.getLocation();
      // updateMarkerAndCircle(location, imageData);
      if (locationSubscription != null) {
        locationSubscription.cancel();
      }
      locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 17.60),
            ),
          );
          // updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
}
