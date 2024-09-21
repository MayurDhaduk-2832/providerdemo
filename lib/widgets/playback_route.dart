import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaybackRoute {
  String time, routeCovered;
  int speed, angle;
  LatLng latLng;

  PlaybackRoute({
    this.speed,
    this.time,
     this.latLng,
    this.angle,
    this.routeCovered
  });
}