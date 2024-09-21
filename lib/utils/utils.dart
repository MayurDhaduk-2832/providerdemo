import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../notification_service/notification_service.dart';

class Utils {
  static String currentLanguage = "en";
  static var platform;

  static double lat = 23.259933;
  static double lng = 77.412613;

  static GlobalKey<ScaffoldState> navigatorKey;

  static String deviceToken = "";
  static String vehicleStatus = "";
  static String role;

  static String http = "https://";

  // static String baseUrl = "api.coincafe.in";
  static String baseUrl = "socket.oneqlik.in";
  static String mainBaseUrl = "www.oneqlik.in";
  static MapType mapType = MapType.normal;

  static Future<void> requestPermissions(context) async {
    print("---------------");
    final status = await Permission.notification.request();
    if (status == PermissionStatus.granted) {
      print('Notification permissions granted');
      LocalNotificationService.initialize(context);
    } else if (status == PermissionStatus.denied) {
      print('Please grant notification permissions to use this feature');
    }
  }



  static Future<Position> getGeoLocationPositionTwo() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

String formatMilliseconds(int milliseconds) {
  int seconds = (milliseconds / 1000).round();
  int hours = seconds ~/ 3600;
  seconds %= 3600;
  int minutes = seconds ~/ 60;
  seconds %= 60;

  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = seconds.toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr';
}

double convertInKM(String meter) {
  double me=double.parse(meter);
  double distanceInKiloMeters = me / 1000;
  return double.parse((distanceInKiloMeters).toStringAsFixed(2));
}
