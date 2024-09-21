// import 'dart:async';
//
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:autonemogps/api_calls/gps_server_requests.dart';
// import 'package:autonemogps/api_calls/gps_wox_requests.dart';
// import 'package:autonemogps/common/MeasureSizeRenderObject.dart';
// import 'package:autonemogps/common/custom_marker.dart';
// import 'package:autonemogps/config/colors.dart';
// import 'package:autonemogps/config/string_constants.dart';
// import 'package:autonemogps/models/device.dart';
// import 'package:autonemogps/models/device_model.dart';
// import 'package:autonemogps/models/parking.dart';
// import 'package:autonemogps/models/playback_route.dart';
// import 'package:autonemogps/models/trip.dart';
// import 'package:autonemogps/screens/playback/map_playback_page.dart';
// import 'package:autonemogps/screens/playback/trip_list_widget.dart';
// import 'package:autonemogps/storage/repository.dart';
// import 'package:autonemogps/utils/dateUtilities.dart';
// import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';
//
// class PlaybackPage extends StatefulWidget {
//   final DeviceModel? device;
//
//   PlaybackPage(this.device);
//
//   @override
//   _PlaybackPageState createState() => _PlaybackPageState();
// }
//
// class _PlaybackPageState extends State<PlaybackPage> with WidgetsBindingObserver {
//   String zeroTime = '00:00:00';
//
//   Set<Polyline> polyLines = {};
//   LatLngBounds? bounds;
//
//   bool show = false;
//   bool isMoreClicked = false;
//   bool isPlay = false;
//   bool isAlertActive = false;
//   bool isPointActive = false;
//   bool showCalenderLayout = true;
//
//   double bottomSheetPersistentHeight = 0;
//
//   Map<MarkerId, Marker> movementMarkers = <MarkerId, Marker>{};
//   List<Trip> tripList = [];
//
//   List<Widget> widgets = List.empty(growable: true);
//   double rating = 0.0;
//
//   List<PlaybackRoute>? routePoints = [];
//
//   Map<String, dynamic> result = {};
//   String moveDuration = '',
//       avgSpeed = '',
//       stopDuration = '',
//       topSpeed = '',
//       fuelConsumption = '',
//       avgFuelCons100km = '',
//       fuelCost = '',
//       engineWork = '',
//       engineIdle = '',
//       endDate = '',
//       startDate = '',
//       dtt = '',
//       dtf = '';
//
//   List<Parking>? parkingList;
//   MapType _mapType = MapType.normal;
//
//   int speedStep = 1;
//   Color lightSpeedColor = Colors.yellow[50]!;
//   Color darkSpeedColor = Colors.yellow[800]!;
//   String routeLength = '';
//
//   DeviceModel? device;
//
//   int animationDuration = 200;
//
//   bool isFinished = false;
//
//   final now = new DateTime.now();
//   DateFormat dateFormat = DateFormat('yyyy-MM-dd');
//   MarkerId kMarkerId = MarkerId('MarkerId1');
//   String selectedStops = '> 1 min';
//
//   BitmapDescriptor? objectMarker, stopsMarker;
//   List<String> stopsArray = ['> 1 min', '> 2 min', '> 5 min', '> 10 min', '> 20 min', '> 30 min', '> 1 hr', '> 2 hr', '> 5 hr'];
//   List<String> filterArray = ['Today', 'Yesterday', 'This week', 'Last week', 'This month', 'Last month', 'Custom'];
//
//   bool loading = true;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//
//     dtf = dateFormat.format(now) + ' $zeroTime';
//     dtt = dateFormat.format(now.add(Duration(days: 1))) + ' $zeroTime';
//
//     if (widget.device == null) {
//       device = AllDeviceModelData().deviceModelAndImeiMapGpsServer[widget.device!.imei];
//     } else {
//       device = widget.device;
//     }
//
//     loadUI();
//   }
//
//   final GlobalKey<PlaybackMapWidgetState> playbackWidgetState = GlobalKey<PlaybackMapWidgetState>();
//   final GlobalKey<ExpandableBottomSheetState> expandableBottomSheetKey = new GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Playback'), backgroundColor: Colors.white, foregroundColor: Colors.black, actions: [_buildCalenderAction()]),
//       body: ExpandableBottomSheet(
//         key: expandableBottomSheetKey,
//         persistentContentHeight: bottomSheetPersistentHeight,
//         expandableContent: _buildBottomSheet(),
//         background: Stack(
//           children: [
//             PlaybackMapWidget(
//               key: playbackWidgetState,
//               playbackRoutes: routePoints,
//               parkingMarkers: parkingList,
//               polyLines: polyLines,
//               objectMarker: objectMarker,
//               stopsMarker: stopsMarker,
//               bounds: bounds,
//               objectName: widget.device!.name,
//               onLocationUpdated: _onLocationUpdated,
//               onPlaybackEnded: _onPlaybackEnded,
//             ),
//             _buildTopBar(),
//             _buildMapTypeChangeIconPositioned(),
//             _buildShowStopSignsPositioned(),
//             if (loading) Positioned(child: SpinKitCircle(color: AppColors.primaryColor), top: 0, right: 0, left: 0, bottom: 0),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Positioned _buildShowStopSignsPositioned() {
//     return Positioned(
//       right: 20,
//       top: 290,
//       child: InkWell(
//           onTap: () {
//             setState(() {
//               isPointActive = !isPointActive;
//               if (!isPointActive) {
//                 playbackWidgetState.currentState!.removeParkingMarkers(parkingList!);
//               } else {
//                 playbackWidgetState.currentState!.setParkingMarkers(parkingList!);
//               }
//             });
//           },
//           child: Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(color: _mapType == MapType.normal ? Colors.white : Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(2))),
//             child: Image.asset(isPointActive ? 'images/stop-sign.png' : 'images/stop-sign-inactive.png', height: 30, width: 30, color: isPointActive ? null : AppColors.primaryColor),
//           )),
//     );
//   }
//
//   Positioned _buildMapTypeChangeIconPositioned() {
//     return Positioned(
//       right: 20,
//       top: 230,
//       child: InkWell(
//           onTap: () {
//             setState(() {
//               if (_mapType == MapType.normal) {
//                 _mapType = MapType.hybrid;
//               } else {
//                 _mapType = MapType.normal;
//               }
//               playbackWidgetState.currentState!.changeMapType(_mapType);
//             });
//           },
//           child: Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(color: _mapType == MapType.normal ? Colors.white : Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(2))),
//             child: Image.asset(_mapType == MapType.normal ? 'images/roadmap.png' : 'images/satellite-map.png', height: 30, width: 30),
//           )),
//     );
//   }
//
//   InkWell _buildCalenderAction() {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           showCalenderLayout = !showCalenderLayout;
//         });
//       },
//       child: Container(padding: EdgeInsets.all(15), child: Image.asset(showCalenderLayout ? 'images/close_calendar.png' : 'images/playback_calender_icon.png')),
//     );
//   }
//
//   _onPlaybackEnded() {
//     if (mounted) {
//       setState(() {
//         rating = 0;
//         isPlay = false;
//       });
//     }
//   }
//
//   _onLocationUpdated(int index) {
//     if (mounted)
//       setState(() {
//         rating = index.toDouble();
//       });
//   }
//
//   loadUI() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fetchData();
//     });
//
//     getBytesFromAsset('images/stop-sign.png', 70).then((byteData) => stopsMarker = BitmapDescriptor.fromBytes(byteData));
//
//     getCustomMarker().then((value) => objectMarker = value);
//   }
//
//   fetchData() {
//     setState(() {
//       this.loading = true;
//     });
//
//     if (Repository.getServerType() == GPSWoxConstants.type) {
//       String fromDate = dtf.split(' ')[0];
//       String fromTime = dtf.split(' ')[1];
//       String toDate = dtt.split(' ')[0];
//       String toTime = dtt.split(' ')[1];
//       GPSWoxRequests.fetchHistory(fromDate, fromTime, toDate, toTime, widget.device!.deviceId).then((list) {
//         if (list[0] == 1) {
//           setState(() {
//             result = list[1] as Map<String, dynamic>;
//             tripList = result['tripList'] as List<Trip>;
//             routePoints = result['routePoints'] as List<PlaybackRoute>;
//             topSpeed = result['topSpeed'] as String;
//             avgSpeed = result['stopDuration'];
//             moveDuration = result['moveDuration'] as String;
//             routeLength = result['routeLength'].toString();
//             parkingList = result['parkingList'] as List<Parking>;
//             polyLines = result['polyLines'] as Set<Polyline>;
//             bounds = result['bounds'] as LatLngBounds;
//             if (playbackWidgetState.currentState != null && routePoints!.length > 0) {
//               playbackWidgetState.currentState!.setEndMarkers(routePoints!.elementAt(0).latLng, routePoints!.elementAt(routePoints!.length - 1).latLng, bounds!);
//             }
//             showCalenderLayout = false;
//           });
//         } else {
//           Fluttertoast.showToast(msg: list[1]);
//         }
//         setState(() {
//           this.loading = false;
//         });
//       });
//     } else {
//       int minStopDuration = 1;
//       switch (stopsArray.indexOf(selectedStops)) {
//         case 0:
//           minStopDuration = 1;
//           break;
//         case 1:
//           minStopDuration = 2;
//           break;
//         case 2:
//           minStopDuration = 5;
//           break;
//         case 3:
//           minStopDuration = 10;
//           break;
//         case 4:
//           minStopDuration = 20;
//           break;
//         case 5:
//           minStopDuration = 30;
//           break;
//         case 6:
//           minStopDuration = 60;
//           break;
//         case 7:
//           minStopDuration = 120;
//           break;
//         case 8:
//           minStopDuration = 300;
//           break;
//       }
//       GPSServerRequests.fetchHistory(dtf, dtt, widget.device!.imei, minStopDuration.toString()).then((result) async {
//         if (result.containsKey('routePoints')) {
//           setState(() {
//             routePoints = result['routePoints'] as List<PlaybackRoute>;
//             topSpeed = result['topSpeed'] + ' kph';
//             avgSpeed = result['averageSpeed'] + ' kph';
//             moveDuration = result['moveDuration'] as String;
//             routeLength = result['routeLength'] + ' km';
//             stopDuration = result['stopsDuration'];
//             fuelConsumption = result['fuelConsumption'] + ' liters';
//             avgFuelCons100km = result['avgFuelCons100km'] + ' liters';
//             fuelCost = result['fuelCost'] + ' BDT';
//             engineWork = result['engineWork'];
//             engineIdle = result['engineIdle'];
//             parkingList = result['parkingList'] as List<Parking>;
//             tripList = result['tripList'] as List<Trip>;
//             polyLines = result['polyLines'] as Set<Polyline>;
//             bounds = result['bounds'] as LatLngBounds;
//             if (playbackWidgetState.currentState != null) {
//               playbackWidgetState.currentState!.setEndMarkers(routePoints!.elementAt(0).latLng, routePoints!.elementAt(routePoints!.length - 1).latLng, bounds!);
//             }
//             showCalenderLayout = false;
//           });
//         } else {
//           Fluttertoast.showToast(msg: 'No Data Found');
//         }
//         setState(() {
//           this.loading = false;
//         });
//       });
//     }
//   }
//
//   Widget _buildBottomSheet() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: AppColors.primaryMaterialColor[100]!, blurRadius: 3, spreadRadius: 0)],
//         borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildPlaybackStartStopSlider(),
//           TripListWidget(dtf, dtt, widget.device!.imei, '1', tripList, onTripClicked),
//         ],
//       ),
//     );
//   }
//
//   MeasureSize _buildPlaybackStartStopSlider() {
//     return MeasureSize(
//       onChange: (size) {
//         setState(() {
//           bottomSheetPersistentHeight = size.height;
//         });
//       },
//       child: Column(
//         children: [
//           Container(
//             margin: EdgeInsets.only(bottom: 10),
//             width: 30,
//             decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.grey[350]),
//             padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
//           ),
//           if ((routePoints?.length ?? 0) > 0)
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 80,
//                   child: Column(
//                     children: [
//                       Text.rich(TextSpan(children: [
//                         TextSpan(text: routePoints!.elementAt(rating.toInt()).speed.toString(), style: TextStyle(fontSize: 40, color: Colors.green[700], fontWeight: FontWeight.w600)),
//                         TextSpan(text: 'kph', style: TextStyle(fontSize: 10, color: Colors.green[700]))
//                       ])),
//                       AutoSizeText(
//                         routePoints!.elementAt(rating.toInt()).time!.split(' ').elementAt(1),
//                         maxLines: 1,
//                         minFontSize: 4,
//                         style: TextStyle(color: Color(0xFF212121), fontWeight: FontWeight.w600, fontSize: 12),
//                       ),
//                       AutoSizeText(
//                         routePoints!.elementAt(rating.toInt()).time!.split(' ').elementAt(0),
//                         maxLines: 1,
//                         minFontSize: 4,
//                         style: TextStyle(color: Color(0xFF6A6A6A), fontWeight: FontWeight.w400, fontSize: 9),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(margin: EdgeInsets.symmetric(horizontal: 10), height: 70, width: 1, color: Colors.grey[200]),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       InkWell(
//                           onTap: () {
//                             if (isPlay) {
//                               playbackWidgetState.currentState!.pauseStream();
//                             } else
//                               playbackWidgetState.currentState!.startStream();
//                             setState(() {
//                               isPlay = !isPlay;
//                             });
//                           },
//                           child: Padding(padding: EdgeInsets.all(0), child: Image.asset(isPlay ? 'images/pause.png' : 'images/play-button.png', height: 30.0))),
//                       Expanded(
//                         child: SfSlider(
//                           tooltipShape: SfPaddleTooltipShape(),
//                           min: 0,
//                           max: routePoints!.length.toDouble(),
//                           onChanged: (newRating) {
//                             if (routePoints!.length - 1 > newRating) {
//                               setState(() {
//                                 rating = newRating;
//                               });
//
//                               playbackWidgetState.currentState!.onSliderMoved((newRating as double).toInt());
//                             }
//                           },
//                           value: rating,
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             if (speedStep == 1) {
//                               speedStep = 2;
//                               lightSpeedColor = Colors.orange[50]!;
//                               darkSpeedColor = Colors.orange[800]!;
//                             } else if (speedStep == 2) {
//                               speedStep = 3;
//                               lightSpeedColor = Colors.red[50]!;
//                               darkSpeedColor = Colors.red[800]!;
//                             } else if (speedStep == 3) {
//                               speedStep = 4;
//                               lightSpeedColor = Colors.pink[50]!;
//                               darkSpeedColor = Colors.pink[800]!;
//                             } else if (speedStep == 4) {
//                               speedStep = 1;
//                               lightSpeedColor = Colors.yellow[50]!;
//                               darkSpeedColor = Colors.yellow[800]!;
//                             }
//                             isPlay = true;
//                             playbackWidgetState.currentState!.changeSpeed(speedStep);
//                           });
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                           decoration: BoxDecoration(color: lightSpeedColor, borderRadius: BorderRadius.all(Radius.circular(10))),
//                           child: Text('${speedStep}X', style: TextStyle(color: darkSpeedColor, fontSize: 20)),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           Divider(),
//         ],
//       ),
//     );
//   }
//
//   onTripClicked(int index) {
//     expandableBottomSheetKey.currentState!.contract();
//     setState(() {
//       if (polyLines.length == 2) {
//         polyLines.remove(polyLines.last);
//       }
//       polyLines.add(tripList[index].polyline!);
//     });
//     playbackWidgetState.currentState!.zoomToPolyline(tripList[index].polyline!.points);
//   }
//
//   Future<BitmapDescriptor> getCustomMarker() async {
//     String vehicleIcon = 'images/playback_arrow.png';
//     return await getMarkerFromImagePath(vehicleIcon, size: 60);
//   }
//
//   Widget _buildTopBar() {
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: AppColors.primaryMaterialColor[100]!, blurRadius: 3, spreadRadius: 0)]),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(children: [Text(widget.device!.name, style: TextStyle(fontSize: 16))]),
//           Container(
//             height: !showCalenderLayout ? 0 : null,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     margin: EdgeInsets.only(top: 10, bottom: 10),
//                     child: Column(
//                       children: [
//                         InkWell(
//                           onTap: () async {
//                             DateTime? selectedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
//                             if (selectedDate == null) return;
//                             TimeOfDay? selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(selectedDate));
//                             if (selectedTime == null) return;
//
//                             setState(() {
//                               dtf = selectedDate.year.toString().padLeft(4, '0') +
//                                   '-' +
//                                   selectedDate.month.toString().padLeft(2, '0') +
//                                   '-' +
//                                   selectedDate.day.toString().padLeft(2, '0') +
//                                   ' ' +
//                                   selectedTime.hour.toString().padLeft(2, '0') +
//                                   ':' +
//                                   selectedTime.minute.toString().padLeft(2, '0') +
//                                   ':00';
//                             });
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                             decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(10)),
//                             child: Row(children: [Image.asset('images/start_date.png', height: 25, width: 25), SizedBox(width: 20), Text(dtf)]),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         InkWell(
//                           onTap: () async {
//                             DateTime? selectedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
//                             if (selectedDate == null) return;
//                             TimeOfDay? selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(selectedDate));
//                             if (selectedTime == null) return;
//
//                             setState(() {
//                               dtt = selectedDate.year.toString().padLeft(4, '0') +
//                                   '-' +
//                                   selectedDate.month.toString().padLeft(2, '0') +
//                                   '-' +
//                                   selectedDate.day.toString().padLeft(2, '0') +
//                                   ' ' +
//                                   selectedTime.hour.toString().padLeft(2, '0') +
//                                   ':' +
//                                   selectedTime.minute.toString().padLeft(2, '0') +
//                                   ':00';
//                             });
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                             decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(10)),
//                             child: Row(children: [Image.asset('images/end_date.png', height: 25, width: 25), SizedBox(width: 20), Text(dtt)]),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Container(
//                           padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white, border: Border.all(color: Colors.grey[200]!, width: 1)),
//                           child: Row(
//                             children: [
//                               Image.asset('images/stop-sign.png', height: 25, width: 25),
//                               SizedBox(width: 20),
//                               Expanded(
//                                 child: DropdownButtonHideUnderline(
//                                   child: DropdownButton<String>(
//                                     isDense: true,
//                                     hint: Text('Select Stop Duration', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w300)),
//                                     isExpanded: true,
//                                     value: selectedStops,
//                                     items: stopsArray.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 14.0)))).toList(),
//                                     onChanged: (value) {
//                                       if (value != null) {
//                                         setState(() {
//                                           selectedStops = value;
//                                         });
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Column(
//                   children: [
//                     InkWell(
//                       onTap: openDayFilterDialog,
//                       child: Container(
//                         decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(10)),
//                         padding: EdgeInsets.all(5),
//                         child: Icon(Icons.filter_alt_outlined, color: Colors.red),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     InkWell(
//                       onTap: () {
//                         fetchData();
//                         playbackWidgetState.currentState!.resetStream();
//                         setState(() {
//                           isPointActive = false;
//                           isPlay = false;
//                           rating = 0;
//                         });
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
//                         padding: EdgeInsets.all(5),
//                         child: Icon(Icons.send, color: Colors.blue),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//           if (routePoints?.length != 0)
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                 margin: EdgeInsets.only(top: 10),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       margin: EdgeInsets.all(2),
//                       decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.all(Radius.circular(5))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [Text('Route Length', style: TextStyle(color: Colors.black, fontSize: 10)), Text(routeLength.toString(), style: TextStyle(color: Colors.blue[700], fontSize: 12))],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       margin: EdgeInsets.all(2),
//                       decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.all(Radius.circular(5))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('Move Duration', style: TextStyle(color: Colors.black, fontSize: 10)),
//                           Text(moveDuration, style: TextStyle(color: Colors.green[700], fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       margin: EdgeInsets.all(2),
//                       decoration: BoxDecoration(color: Colors.cyan[50], borderRadius: BorderRadius.all(Radius.circular(5))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('Stops Duration', style: TextStyle(color: Colors.black, fontSize: 10)),
//                           Text(stopDuration, style: TextStyle(color: Colors.cyan[700], fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       margin: EdgeInsets.all(2),
//                       decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.all(Radius.circular(5))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(GPSServerConstants.type == Repository.getServerType() ? 'Average Speed' : 'Stop Duration', style: TextStyle(color: Colors.black, fontSize: 10)),
//                           Text(avgSpeed, style: TextStyle(color: Colors.red[700], fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       margin: EdgeInsets.all(2),
//                       decoration: BoxDecoration(color: Colors.cyan[50], borderRadius: BorderRadius.all(Radius.circular(5))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('Max Speed', style: TextStyle(color: Colors.black, fontSize: 10)),
//                           Text(topSpeed, style: TextStyle(color: Colors.cyan[700], fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       margin: EdgeInsets.all(2),
//                       decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.all(Radius.circular(5))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('Avg Fuel Cons 100km', style: TextStyle(color: Colors.black, fontSize: 10)),
//                           Text(avgFuelCons100km, style: TextStyle(color: Colors.green[700], fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       margin: EdgeInsets.all(2),
//                       decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.all(Radius.circular(5))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('Fuel Cost', style: TextStyle(color: Colors.black, fontSize: 10)),
//                           Text(fuelCost, style: TextStyle(color: Colors.red[700], fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       margin: EdgeInsets.all(2),
//                       decoration: BoxDecoration(color: Colors.cyan[50], borderRadius: BorderRadius.all(Radius.circular(5))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('Engine Work', style: TextStyle(color: Colors.black, fontSize: 10)),
//                           Text(engineWork, style: TextStyle(color: Colors.cyan[700], fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       margin: EdgeInsets.all(2),
//                       decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.all(Radius.circular(5))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('Engine Idle', style: TextStyle(color: Colors.black, fontSize: 10)),
//                           Text(engineIdle, style: TextStyle(color: Colors.green[700], fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   openDayFilterDialog() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return Dialog(
//             child: Container(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         dtf = dateFormat.format(now) + ' $zeroTime';
//                         dtt = dateFormat.format(now.add(Duration(days: 1))) + ' $zeroTime';
//                       });
//                       Navigator.pop(context);
//                     },
//                     child: Row(children: [Image.asset('images/today.png', height: 30, width: 30), SizedBox(width: 20), Text('Today')]),
//                   ),
//                   Divider(),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         dtf = dateFormat.format(now.subtract(Duration(days: 1))) + ' $zeroTime';
//                         dtt = dateFormat.format(now) + ' $zeroTime';
//                       });
//                       Navigator.pop(context);
//                     },
//                     child: Row(children: [Image.asset('images/yesterday.png', height: 30, width: 30), SizedBox(width: 20), Text('Yesterday')]),
//                   ),
//                   Divider(),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         dtf = dateFormat.format(dateOnLastMonday()) + ' $zeroTime';
//                         dtt = dateFormat.format(now.add(Duration(days: 1))) + ' $zeroTime';
//                       });
//                       Navigator.pop(context);
//                     },
//                     child: Row(children: [Image.asset('images/this_week.png', height: 30, width: 30), SizedBox(width: 20), Text('This Week')]),
//                   ),
//                   Divider(),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         var mondayDate = dateOnLastMonday();
//                         dtf = dateFormat.format(mondayDate.subtract(Duration(days: 7))) + ' $zeroTime';
//                         dtt = dateFormat.format(mondayDate) + ' $zeroTime';
//                       });
//                       Navigator.pop(context);
//                     },
//                     child: Row(children: [Image.asset('images/last_week.png', height: 30, width: 30), SizedBox(width: 20), Text('Last Week')]),
//                   ),
//                   Divider(),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         dtf = DateFormat('yyyy-MM-01').format(now) + ' $zeroTime';
//                         dtt = dateFormat.format(now.add(Duration(days: 1))) + ' $zeroTime';
//                       });
//                       Navigator.pop(context);
//                     },
//                     child: Row(children: [Image.asset('images/this_month.png', height: 30, width: 30), SizedBox(width: 20), Text('This Month')]),
//                   ),
//                   Divider(),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         dtf = DateFormat('yyyy-MM-01').format(new DateTime(now.year, now.month - 1, now.day)) + ' $zeroTime';
//                         dtt = dateFormat.format(dateFormat.parse(DateFormat('yyyy-MM-01').format(now))) + ' $zeroTime';
//                       });
//                       Navigator.pop(context);
//                     },
//                     child: Row(children: [Image.asset('images/last_month.png', height: 30, width: 30), SizedBox(width: 20), Text('Last Month')]),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//
// }
