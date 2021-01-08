import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/models/infected_point.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class CovidLocations with ChangeNotifier {
  List<InfectedPoint> _infectedPoints = [];
  List<Marker> _markers = [];
  List<Circle> _circles = [];
  Location location = new Location();
  GoogleMapController mapController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  BuildContext _context;

  // Stateful Data
  final radius = BehaviorSubject<double>.seeded(10);
  Stream<dynamic> query;

  // Subscription
  StreamSubscription subscription;

  reset() {
    _infectedPoints = [];
    _markers = [];
    _circles = [];
    _context = null;
    subscription.cancel();
  }

  set context(BuildContext ctx) {
    _context = ctx;
  }

  set controller(GoogleMapController controller) {
    this.mapController = controller;
  }

  List<Marker> get markers {
    return [..._markers];
  }

  List<Circle> get circles {
    return [..._circles];
  }

  InfectedPoint findById(String id) {
    return _infectedPoints.firstWhere((point) => point.id == id);
  }

  Future<Uint8List> getCoronaMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(_context).load("assets/corona.png");
    return byteData.buffer.asUint8List();
  }

  startQuery() async {
    // Get users location
    var pos = await this.location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;

    // Make a referece to firestore
    var ref = firestore.collection('covid_locations');

    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
          center: center, radius: rad, field: 'location', strictMode: true);
    }).listen((List<DocumentSnapshot> documentList) {
      _updateMarkers(documentList);
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) async {
    _markers.clear();
    _circles.clear();
    Uint8List coronaMarker = await getCoronaMarker();
    List<Marker> markers = [];
    List<Circle> circles = [];
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data()['location']['geopoint'];
      String id = document.data()['id'];
      //double distance = document.data()['distance'];
      double accuracy = document.data()['accuracy'];
      var marker = Marker(
        markerId: MarkerId(id),
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow: InfoWindow(
          title: 'Covid Zone',
          anchor: Offset(0.045, 0.045),
          snippet: 'Avoid going to this location ' + id,
        ),
        rotation: null,
        draggable: false,
        zIndex: 4,
        flat: true,
        anchor: Offset(0.045, 0.045),
        icon: BitmapDescriptor.fromBytes(coronaMarker),
      );
      var circle = Circle(
        circleId: CircleId(id),
        radius: accuracy,
        zIndex: 1,
        strokeWidth: 1,
        strokeColor: Colors.red,
        center: LatLng(pos.latitude, pos.longitude),
        fillColor: Colors.red.withAlpha(70),
      );
      markers.add(marker);
      circles.add(circle);
    });
    _markers.addAll(markers);
    _circles.addAll(circles);
    notifyListeners();
  }
}
