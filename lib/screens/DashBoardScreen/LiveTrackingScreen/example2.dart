// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
// import 'package:oneqlik/screens/DashBoardScreen/LiveTrackingScreen/example.dart';
//
// class Example2 extends StatefulWidget {
//
//   @override
//   State<Example2> createState() => _Example2State();
// }
//
// class _Example2State extends State<Example2> {
//   @override
//   void initState() {
//     super.initState();
//     fcmSubscribe();
//     ExampleLocalNotificationService.initialize(context);
//
//   }
//   fcmSubscribe() async {
//
//     // await FirebaseMessaging.instance.subscribeToTopic('SWORD_Testing');
//     await FirebaseMessaging.instance.subscribeToTopic('default');
//     print(FirebaseMessaging.onMessage.toString());
//     print(FirebaseMessaging.onMessageOpenedApp.toString());
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter alarm clock example'),
//         ),
//         body: Center(
//             child: Column(children: <Widget>[
//               Container(
//                 margin: const EdgeInsets.all(25),
//                 child: TextButton(
//                   child: const Text(
//                     'Create alarm at 23:59',
//                     style: TextStyle(fontSize: 20.0),
//                   ),
//                   onPressed: () {
//                     FlutterAlarmClock.createAlarm(2, 14);
//                   },
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(25),
//                 child: TextButton(
//                   child: const Text(
//                     'Show alarms',
//                     style: TextStyle(fontSize: 20.0),
//                   ),
//                   onPressed: () {
//                     FlutterAlarmClock.showAlarms();
//                   },
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(25),
//                 child: TextButton(
//                   child: const Text(
//                     'Create timer for 42 seconds',
//                     style: TextStyle(fontSize: 20.0),
//                   ),
//                   onPressed: () {
//                     FlutterAlarmClock.createTimer(42);
//                   },
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(25),
//                 child: TextButton(
//                   child: const Text(
//                     'Show Timers',
//                     style: TextStyle(fontSize: 20.0),
//                   ),
//                   onPressed: () {
//                     FlutterAlarmClock.showTimers();
//                   },
//                 ),
//               ),
//             ])),
//       ),
//     );
//   }
// }