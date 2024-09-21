// import 'dart:async';
// import 'dart:math';
//
// import 'package:autonemogps/api_calls/gps_server_requests.dart';
// import 'package:autonemogps/common/bloc/custom_info_widget.dart';
// import 'package:autonemogps/common/bloc/window_bloc.dart';
// import 'package:autonemogps/common/bloc/window_event.dart';
// import 'package:autonemogps/common/custom_marker.dart';
// import 'package:autonemogps/models/parking.dart';
// import 'package:autonemogps/models/playback_route.dart';
// import 'package:autonemogps/utils/math_utils.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class PlaybackMapWidget extends StatefulWidget {
//   final List<PlaybackRoute>? playbackRoutes;
//   final List<Parking>? parkingMarkers;
//   final Set<Polyline> polyLines;
//   final BitmapDescriptor? objectMarker, stopsMarker;
//   final String objectName;
//   final Function? onLocationUpdated;
//   final Function? onPlaybackEnded;
//   final LatLngBounds? bounds;
//
//   const PlaybackMapWidget(
//       {this.playbackRoutes,
//       required this.parkingMarkers,
//       required this.polyLines,
//       this.objectName = '',
//       required this.objectMarker,
//       this.stopsMarker,
//       this.onLocationUpdated,
//       this.bounds,
//       this.onPlaybackEnded,
//       required Key key})
//       : super(key: key);
//
//   @override
//   PlaybackMapWidgetState createState() => PlaybackMapWidgetState();
// }
//
// class PlaybackMapWidgetState extends State<PlaybackMapWidget> with TickerProviderStateMixin {
//   MarkerId markerId = MarkerId('MarkerId1');
//   Completer<GoogleMapController> _controller = Completer();
//   Window? window;
//   List<Marker> _markersList = [];
//   List<Marker>? _parkingMarkers;
//   LatLng? previousLatLng;
//
//   LatLng? currentLatLng;
//   bool show = false;
//   int index = 0;
//   MapType mapType = MapType.normal;
//   double currentZoom = 16, rotation = 0;
//   int speed = 1000;
//   CameraPosition initialCameraPosition = CameraPosition(target: LatLng(23.6850, 90.3563), zoom: 8);
//
//   StreamController<List<Marker>> _mapMarkerSC = StreamController<List<Marker>>();
//
//   bool _cameraIdle = true;
//
//   StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;
//
//   Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;
//
//   AnimationController? animationController;
//   Animation<double>? _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     animationController = AnimationController(duration: Duration(milliseconds: speed), vsync: this);
//     Tween<double> tween = Tween(begin: 0, end: 1);
//     _animation = tween.animate(animationController!);
//     _animation?.addStatusListener(onAnimationStatusChangedListener);
//     _animation?.addListener(onAnimationAddListener);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         StreamBuilder<List<Marker>>(
//             stream: mapMarkerStream,
//             builder: (context, snapshot) {
//               return GoogleMap(
//                 markers: Set<Marker>.of(snapshot.data ?? []),
//                 polylines: widget.polyLines,
//                 mapType: mapType,
//                 initialCameraPosition: initialCameraPosition,
//                 gestureRecognizers: Set()
//                   ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
//                   ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
//                   ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
//                   ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
//                   ..add(Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer())),
//                 onCameraMove: (cameraPosition) {
//                   currentZoom = cameraPosition.zoom;
//                   _onChange();
//                 },
//                 onCameraIdle: () {
//                   this._cameraIdle = true;
//                 },
//                 onMapCreated: (GoogleMapController controller) => _controller.complete(controller),
//                 zoomControlsEnabled: false,
//                 compassEnabled: false,
//                 mapToolbarEnabled: false,
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: false,
//                 tiltGesturesEnabled: false,
//               );
//             }),
//         show ? window! : SizedBox(height: 0, width: 0),
//       ],
//     );
//   }
//
//   onAnimationStatusChangedListener(status) {
//     if (status == AnimationStatus.completed) {
//       previousLatLng = currentLatLng;
//
//       if (index == (widget.playbackRoutes ?? []).length - 1) {
//         index = 0;
//         if (widget.onPlaybackEnded != null) {
//           widget.onPlaybackEnded!();
//         }
//         return;
//       }
//       if (widget.onLocationUpdated != null) {
//         if (mounted) widget.onLocationUpdated!(index);
//       }
//       index++;
//       animationController?.value = 0;
//       animationController?.forward();
//     }
//   }
//
//   onAnimationAddListener() async {
//     if (widget.playbackRoutes == null && previousLatLng == null) {
//       return;
//     }
//
//     final double v = _animation?.value ?? 0;
//     PlaybackRoute playbackRoute = widget.playbackRoutes!.elementAt(index);
//     currentLatLng = playbackRoute.latLng;
//     rotation = bearingBetweenTwoGeoPoints(previousLatLng!, currentLatLng!);
//
//     double lat = (currentLatLng!.latitude - previousLatLng!.latitude) * v + previousLatLng!.latitude;
//     double lngDelta = currentLatLng!.longitude - previousLatLng!.longitude;
//
//     if (lngDelta.abs() > 180) {
//       lngDelta -= (lngDelta.sign) * 360;
//     }
//     double lng = lngDelta * v + previousLatLng!.longitude;
//
//     LatLng newPos = LatLng(lat, lng);
//
//     Marker marker = Marker(markerId: markerId, position: newPos, icon: widget.objectMarker ?? BitmapDescriptor.defaultMarker, rotation: rotation, anchor: Offset(0.5, 0.5));
//     if (v == 1 && this._cameraIdle) {
//       _controller.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newPos, zoom: currentZoom))));
//       setState(() {
//         this._cameraIdle = false;
//       });
//     }
//
//     _markersList.add(marker);
//     _mapMarkerSink.add(_markersList);
//   }
//
//   setIndex(int i) {
//     index = i;
//   }
//
//   startStream() async {
//     if (widget.playbackRoutes != null && widget.playbackRoutes!.length > 0 && currentLatLng == null) {
//       currentLatLng = widget.playbackRoutes!.first.latLng;
//       previousLatLng = currentLatLng;
//     }
//     if (index == 0) {
//       currentZoom = 18;
//     }
//     _controller.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: currentLatLng!, zoom: currentZoom))));
//     animationController?.forward();
//   }
//
//   onSliderMoved(int i) {
//     index = i;
//     startStream();
//   }
//
//   pauseStream() {
//     animationController?.stop();
//   }
//
//   resetStream() {
//     animationController?.reset();
//     index = 0;
//     setState(() {
//       _parkingMarkers = null;
//       _markersList.clear();
//     });
//   }
//
//   changeSpeed(int speed) {
//     switch (speed) {
//       case 1:
//         this.speed = 1000;
//         break;
//       case 2:
//         this.speed = 700;
//         break;
//       case 3:
//         this.speed = 400;
//         break;
//       case 4:
//         this.speed = 100;
//         break;
//     }
//     animationController?.duration = Duration(milliseconds: this.speed);
//
//     startStream();
//   }
//
//   changeMapType(MapType mapType) {
//     this.mapType = mapType;
//   }
//
//   @override
//   void dispose() {
//     _controller.future.then((value) => value.dispose());
//     animationController?.stop(canceled: true);
//     animationController?.dispose();
//     super.dispose();
//   }
//
//   _onChange() async {
//     if (window == null) {
//       return;
//     }
//
//     _controller.future.then((value) async {
//       ScreenCoordinate coordinate = await value.getScreenCoordinate(currentLatLng!);
//       BlocProvider.of<WindowBloc>(context).add(ChangePositionEvent(context: context, screenCoordinate: coordinate));
//     });
//   }
//
//   _onTap(LatLng location, Map<String, String> data) async {
//     previousLatLng = currentLatLng;
//     currentLatLng = location;
//     String address = await GPSServerRequests.fetchAddress(location.latitude.toString(), location.longitude.toString());
//
//     data.update('Address', (value) => address, ifAbsent: () => address);
//
//     window = Window(data: data);
//     setState(() {
//       if (currentLatLng == previousLatLng) {
//         show = !show;
//       } else {
//         show = true;
//       }
//     });
//     await _onChange();
//   }
//
//   double bearingBetweenTwoGeoPoints(LatLng l1, LatLng l2) {
//     if (l1.latitude != l2.latitude && l1.longitude != l2.longitude) {
//       final fromLat = MathUtil.toRadians(l1.latitude);
//       final fromLng = MathUtil.toRadians(l1.longitude);
//       final toLat = MathUtil.toRadians(l2.latitude);
//       final toLng = MathUtil.toRadians(l2.longitude);
//       final dLng = toLng - fromLng;
//       var x = sin(dLng) * cos(toLat);
//       var y = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(dLng);
//       final heading = atan2(x, y);
//       return (MathUtil.toDegrees(heading).toDouble() + 360) % 360;
//     }
//     return rotation;
//   }
//
//   void setParkingMarkers(List<Parking> parkingList) async {
//     if (_parkingMarkers == null) {
//       _parkingMarkers = [];
//       for (int i = 0; i < parkingList.length; i++) {
//         Parking parking = parkingList.elementAt(i);
//         MarkerId markerId = MarkerId('stop' + i.toString());
//
//         Map<String, String> data = Map<String, String>();
//         data.putIfAbsent('Object', () => widget.objectName);
//         data.putIfAbsent('Position', () => parking.position);
//         data.putIfAbsent('Address', () => parking.address ?? '');
//         data.putIfAbsent('Angle', () => parking.angle.toString() + '°');
//         data.putIfAbsent('Came', () => parking.came ?? '');
//         data.putIfAbsent('Left', () => parking.left ?? '');
//         data.putIfAbsent('Duration', () => parking.duration ?? '');
//
//         Marker marker = Marker(
//           markerId: markerId,
//           onTap: () => _onTap(parking.latLng, data),
//           position: parkingList.elementAt(i).latLng,
//           icon: widget.stopsMarker ?? BitmapDescriptor.defaultMarker,
//         );
//         _parkingMarkers!.add(marker);
//         _markersList.add(marker);
//       }
//     } else {
//       _markersList.addAll(_parkingMarkers!);
//     }
//     _mapMarkerSink.add(_markersList);
//   }
//
//   void removeParkingMarkers(List<Parking> parkingList) async {
//     show = false;
//     for (int i = 0; i < parkingList.length; i++) {
//       _markersList.removeWhere((element) => element.markerId.value == 'stop$i');
//     }
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   void setEndMarkers(LatLng start, LatLng end, LatLngBounds bounds) async {
//     Marker startMarker = Marker(markerId: MarkerId('start'), position: start, icon: BitmapDescriptor.fromBytes(await getBytesFromAsset('images/map-start-point.png', 50)));
//
//     Marker endMarker = Marker(markerId: MarkerId('end'), position: end, icon: BitmapDescriptor.fromBytes(await getBytesFromAsset('images/map-end-point.png', 50)));
//
//     _markersList.add(startMarker);
//
//     _markersList.add(endMarker);
//
//     _controller.future.then((value) => value.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)));
//
//     _mapMarkerSink.add(_markersList);
//   }
//
//   void zoomToPolyline(List<LatLng> coordinates) {
//     double? x0, x1, y0, y1;
//     coordinates.forEach((latLng) {
//       if (x0 == null) {
//         x0 = x1 = latLng.latitude;
//         y0 = y1 = latLng.longitude;
//       } else {
//         if (latLng.latitude > x1!) x1 = latLng.latitude;
//         if (latLng.latitude < x0!) x0 = latLng.latitude;
//         if (latLng.longitude > y1!) y1 = latLng.longitude;
//         if (latLng.longitude < y0!) y0 = latLng.longitude;
//       }
//     });
//
//     _controller.future.then((value) => value.animateCamera(CameraUpdate.newLatLngBounds(LatLngBounds(northeast: LatLng(x1 ?? 0, y1 ?? 0), southwest: LatLng(x0 ?? 0, y0 ?? 0)), 50)));
//   }
// }
