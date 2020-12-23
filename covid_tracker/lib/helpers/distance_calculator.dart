import 'dart:math';

class DistanceCalculator {
  double getDistanceFromLatLngInMeters(double latitude1, double longitude1,
      double latitude2, double longitude2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(latitude2 - latitude1); // deg2rad below
    var dLon = deg2rad(longitude2 - longitude1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(latitude1)) *
            cos(deg2rad(latitude2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in km
    return d*1000;
  }

  double deg2rad(double deg) {
    return deg * (pi / 180);
  }
}
