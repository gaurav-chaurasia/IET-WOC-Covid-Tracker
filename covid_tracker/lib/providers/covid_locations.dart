import 'dart:typed_data';

import 'package:covid_tracker/models/infected_point.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CovidLocations with ChangeNotifier {
  List<InfectedPoint> _infectedPoints = [];
  List<Marker> _markers = [];
  List<Circle> _circles = [];

  List<Marker> get markers {
    return [..._markers];
  }

  List<Circle> get circles {
    return [..._circles];
  }

  InfectedPoint findById(String id) {
    return _infectedPoints.firstWhere((point) => point.id == id);
  }

  Future<Uint8List> getCoronaMarker(BuildContext context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/corona.png");
    return byteData.buffer.asUint8List();
  }

  Future<void> fetchAndSetInfectedPoints(BuildContext context) async {
    Uint8List coronaMarker = await getCoronaMarker(context);
    final markers = [
      Marker(
        markerId: MarkerId("corona1"),
        position: LatLng(25.456060, 81.835310),
        infoWindow: InfoWindow(
          title: 'Covid Zone',
          anchor: Offset(0.045, 0.045),
          snippet: 'Avoid going to this location',
        ),
        rotation: null,
        draggable: false,
        zIndex: 4,
        flat: true,
        anchor: Offset(0.045, 0.045),
        icon: BitmapDescriptor.fromBytes(coronaMarker),
      ),
      Marker(
        markerId: MarkerId("corona2"),
        position: LatLng(25.462325, 81.836148),
        infoWindow: InfoWindow(
          title: 'Covid Zone',
          anchor: Offset(0.045, 0.045),
          snippet: 'Avoid going to this location',
        ),
        rotation: null,
        draggable: false,
        zIndex: 4,
        flat: true,
        anchor: Offset(0.045, 0.045),
        icon: BitmapDescriptor.fromBytes(coronaMarker),
      ),
      Marker(
        markerId: MarkerId("corona3"),
        position: LatLng(25.464341, 81.836452),
        infoWindow: InfoWindow(
          title: 'Covid Zone',
          anchor: Offset(0.045, 0.045),
          snippet: 'Avoid going to this location',
        ),
        rotation: null,
        draggable: false,
        zIndex: 4,
        flat: true,
        anchor: Offset(0.045, 0.045),
        icon: BitmapDescriptor.fromBytes(coronaMarker),
      ),
    ];
    final circles = [
      Circle(
        circleId: CircleId("corona1"),
        radius: 50,
        zIndex: 1,
        strokeWidth: 1,
        strokeColor: Colors.red,
        center: LatLng(25.456060, 81.835310),
        fillColor: Colors.red.withAlpha(70),
      ),
      Circle(
        circleId: CircleId("corona2"),
        radius: 50,
        zIndex: 1,
        strokeWidth: 1,
        strokeColor: Colors.red,
        center: LatLng(25.462325, 81.836148),
        fillColor: Colors.red.withAlpha(70),
      ),
      Circle(
        circleId: CircleId("corona3"),
        radius: 50,
        zIndex: 1,
        strokeWidth: 1,
        strokeColor: Colors.red,
        center: LatLng(25.464341, 81.836452),
        fillColor: Colors.red.withAlpha(70),
      ),
    ];
    this._markers.clear();
    this._circles.clear();
    this._markers.addAll(markers);
    this._circles.addAll(circles);
  }
}
