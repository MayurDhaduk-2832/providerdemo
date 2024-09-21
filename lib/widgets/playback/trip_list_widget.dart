// import 'package:autonemogps/common/dashed_vertical_line.dart';
// import 'package:autonemogps/config/helpers.dart';
// import 'package:autonemogps/config/string_constants.dart';
// import 'package:autonemogps/models/trip.dart';
// import 'package:flutter/material.dart';
//
// class TripListWidget extends StatelessWidget {
//   final String dtf, dtt, imei, stopDuration;
//   final List<Trip> tripList;
//   final Function(int) onTripClicked;
//
//   TripListWidget(this.dtf, this.dtt, this.imei, this.stopDuration, this.tripList, this.onTripClicked, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height - 250,
//       child: ListView.separated(
//         shrinkWrap: true,
//         separatorBuilder: (context, index) {
//           Trip trip = tripList.elementAt(index);
//           String stopDuration = trip.stopTime ?? '--';
//
//           return Column(
//             children: [
//               Divider(),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//                 child: Row(
//                   children: [
//                     Stack(
//                       children: [
//                         Image.asset('images/stop_location.png', height: 40, width: 40),
//                         Positioned(
//                             top: 0,
//                             bottom: 5,
//                             left: 0,
//                             right: 0,
//                             child: Center(child: Text('${index + 1}', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))))
//                       ],
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(child: Text(getFormattedTripTime(trip.leftAt), style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey))),
//                     SizedBox(width: 10),
//                     Text(stopDuration, style: TextStyle(color: Colors.grey))
//                   ],
//                 ),
//               ),
//               Divider(),
//             ],
//           );
//         },
//         itemCount: tripList.length,
//         itemBuilder: (context, index) {
//           Trip trip = tripList.elementAt(index);
//           String prevLocation = '--';
//           if (index > 0) {
//             prevLocation = tripList.elementAt(index - 1).stopLocation ?? '--';
//           }
//
//           return TextButton(
//             onPressed: () => onTripClicked(index),
//             child: Container(
//               color: Colors.white,
//               child: IntrinsicHeight(
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Image.asset('images/trip-gps.png', height: 20, width: 20, color: Colors.blue),
//                           Expanded(child: CustomPaint(size: Size(1, double.infinity), painter: DashedLineVerticalPainter())),
//                           Image.asset('images/trip-gps.png', height: 20, width: 20, color: Colors.red)
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 20.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(prevLocation, style: TextStyle(color: Color(0xFF212121), fontSize: 15, fontWeight: FontWeight.w500)),
//                                 Text(getFormattedTripTime(trip.startTime), style: TextStyle(color: Color(0xFF212121), fontSize: 12))
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(vertical: 5),
//                             child: Row(
//                               children: [
//                                 Expanded(child: Text(trip.distance ?? '--', style: TextStyle(color: Colors.grey))),
//                                 Expanded(child: Text(trip.runTime ?? '--', textAlign: TextAlign.end, style: TextStyle(color: Colors.grey)))
//                               ],
//                             ),
//                           ),
//                           Container(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(trip.stopLocation ?? '--', style: TextStyle(color: Color(0xFF212121), fontSize: 15, fontWeight: FontWeight.w500)),
//                                 Text(getFormattedTripTime(trip.endTime), style: TextStyle(color: Color(0xFF212121), fontSize: 12))
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   String getFormattedTripTime(String? timeString) {
//     if (timeString == null) {
//       return '--';
//     }
//     return getFormattedDateFromString(timeString, STANDARD_DATE_TIME_INPUT_PATTERN, STANDARD_DATE_TIME_OUTPUT_PATTERN);
//   }
// }
