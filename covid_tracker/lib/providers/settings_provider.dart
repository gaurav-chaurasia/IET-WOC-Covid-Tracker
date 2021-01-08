import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _mapType = 'normal';
  double radius;

  String get mapType {
    return _mapType;
  }

  Future<void> updateMapType(String mapType) async {
    _mapType = mapType;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mapType', mapType);
    notifyListeners();
  }

  Future<void> fetchMapType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _mapType = prefs.getString('mapType') ?? 'normal';
    notifyListeners();
  }
}
