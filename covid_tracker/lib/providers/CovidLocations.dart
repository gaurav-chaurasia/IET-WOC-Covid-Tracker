import 'dart:typed_data';

import 'package:covid_tracker/models/infected_point.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CovidLocations with ChangeNotifier {
  List<InfectedPoint> _infectedPoints = [];
  List<Marker> _markers = [];

  List<Marker> get markers {
    return [..._markers];
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
        rotation: null,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.1, 0.1),
        icon: BitmapDescriptor.fromBytes(coronaMarker),
      ),
      Marker(
        markerId: MarkerId("corona2"),
        position: LatLng(25.462325, 81.836148),
        rotation: null,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.1, 0.1),
        icon: BitmapDescriptor.fromBytes(coronaMarker),
      ),
      Marker(
        markerId: MarkerId("corona3"),
        position: LatLng(25.464341, 81.836452),
        rotation: null,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.1, 0.1),
        icon: BitmapDescriptor.fromBytes(coronaMarker),
      ),
    ];
    this._markers.clear();
    this._markers.addAll(markers);
    notifyListeners();
  }
}
