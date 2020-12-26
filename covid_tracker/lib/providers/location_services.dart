import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;
  location.Location _locationTracker = location.Location();

  //request for permissions
  Future<PermissionStatus> _requestPermission(
      PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    return result[permission];
  }

  //check if the location service is enabled or not
  Future<bool> isLocationServiceAvailable() async {
    var permissionStatus = await _locationTracker.hasPermission();
    if (permissionStatus == location.PermissionStatus.granted ||
        permissionStatus == location.PermissionStatus.grantedLimited) {
      return true;
    }
    return false;
  }

  /*Checking if your App has been Given Permission*/
  Future<bool> requestLocationPermission(BuildContext context,
      {Function onPermissionDenied}) async {
    try {
      var permission = await isLocationServiceAvailable();
      if (permission != true) {
        var permissionStatus =
            await _requestPermission(PermissionGroup.location);
        if (permissionStatus != PermissionStatus.granted) {
          var result = await _openLocationSettings(context);
          return result;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } on PlatformException catch (e) {
      print("permission denied by requestLocationPermission() :" + e.message);
      return await _openLocationSettings(context);
    }
  }

  //open location settings if location service is denied by the user and is set as denied forever
  Future<bool> _openLocationSettings(BuildContext context) async {
    bool value = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: Text("Can't get gurrent location"),
          content: const Text('Please make sure you enable GPS and try again'),
          actions: <Widget>[
            CupertinoButton(
              child: Text('Ok'),
              onPressed: () async {
                await AppSettings.openLocationSettings();
                final permission = await isLocationServiceAvailable();
                if (permission == true)
                  Navigator.of(context, rootNavigator: true).pop(true);
                else
                  Navigator.of(context, rootNavigator: true).pop(false);
              },
            )
          ],
        );
      },
    );
    return value;
  }
}
