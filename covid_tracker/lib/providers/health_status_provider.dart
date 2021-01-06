import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

class HealthStatusProvider with ChangeNotifier {
  bool _covidStatus = false;
  FirebaseFirestore firestore;
  Geoflutterfire geo;
  String phone;
  Location location;
  StreamSubscription locationSubscription;

  bool get covidStatus {
    return _covidStatus;
  }

  reset() {
    _covidStatus = false;
    firestore = null;
    geo = null;
    phone = null;
    location = null;
    locationSubscription = null;
  }

  init() {
    geo = Geoflutterfire();
    firestore = FirebaseFirestore.instance;
    phone = FirebaseAuth.instance.currentUser.phoneNumber;
    location = Location();
  }

  Future<void> updateStatus(bool value) async {
    var userData = await firestore.collection('users').doc(phone).get();
    userData.reference.set({
      'status': value,
    });
    _covidStatus = value;
    if (_covidStatus == true) {
      await setCovidStream();
    } else {
      await removeCovidStream();
    }
    //notifyListeners();
  }

  Future<void> fetchCoronaStatus() async {
    init();
    var userData = await firestore.collection('users').doc(phone).get();
    var status = userData.data()['status'];
    _covidStatus = status;
    if (_covidStatus == true) {
      await setCovidStream();
    } else {
      await removeCovidStream();
    }
    //notifyListeners();
  }

  Future<void> removeCovidStream() async {
    locationSubscription.cancel();
    location.onLocationChanged.listen((event) => null);
    await firestore.collection('covid_locations').doc(phone).delete();
  }

  Future<void> setCovidStream() async {
    var ref = await getReferenceToCovidLocations();
    locationSubscription = location.onLocationChanged.listen((newLocalData) {
      addGeoPoint(newLocalData.latitude, newLocalData.longitude,
          newLocalData.accuracy, ref);
    });
  }

  Future<DocumentSnapshot> getReferenceToCovidLocations() async {
    if (phone != null)
      return await firestore.collection('covid_locations').doc(phone).get();
    else
      return null;
  }

  Future<void> addGeoPoint(double latitude, double longitude, double accuracy,
      DocumentSnapshot ref) async {
    GeoFirePoint point = geo.point(latitude: latitude, longitude: longitude);
    try {
      await ref.reference.set({
        'location': point.data,
        'accuracy': accuracy,
        'id': phone,
      });
    } catch (e) {
      print(
          'error occured while writing to database \n please check your internet connection');
    }
  }
}
