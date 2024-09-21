// import 'dart:convert';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'dart:async';
// import 'api.dart';
// import 'main.dart';
//
// class IndexPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => IndexState();
// }
//
// class IndexState extends State<IndexPage> {
//   String? tokenn;
//
//   ClientRole _role = ClientRole.Broadcaster;
//
//   bool isLoading = true;
//
//
//   TextEditingController title = TextEditingController();
//   TextEditingController chanelname = TextEditingController();
//   TextEditingController videocalltoken = TextEditingController();
//
//   String? fcmtoken;
//
//   String agoraToken = "";
//   String aagora_channel = "";
//
//   @override
//   void initState() {
//     super.initState();
//
//
//     FirebaseMessaging.instance.getToken().then((value) {
//       fcmtoken = value;
//
//       createUser(token: fcmtoken);
//     });
//
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//
//       Notify("${message.notification?.title}", "${message.notification?.body}");
//
//       print("title  ${message.notification?.title.toString()}");
//       print("body  ${message.notification?.body.toString()}");
//       print("Token  ${message.data.toString()}");
//
//         agoraToken = message.data["token"];
//         aagora_channel = message.data["chenal"];
//
//         print(aagora_channel);
//         print(agoraToken);
//
//
//
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       Notify("${message.notification?.title}", "${message.notification?.body}");
//
//       print("title  ${message.notification?.title.toString()}");
//       print("body  ${message.notification?.body.toString()}");
//       print("data  ${message.data.toString()}");
//
//
//     });
//
//     AwesomeNotifications().actionStream.listen(
//             (ReceivedNotification receivedNotification){
//
//
//         }
//     );
//   }
//
//
//   addUserData() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     var data = {
//       "to": "/topics/default",
//       "notification": {
//         "body": "fcmtoken",
//       },
//       "data": {
//         "title": fcmtoken.toString(),
//         "body": "Notification Body"
//       }
//     };
//     var response = await CallApi().postData(data, "send");
//     var body = json.decode(response.body);
//
//
//     if (response.statusCode == 200) {
//       setState(() {
//         // organizations_list.addAll(list);
//         isLoading = false;
//       });
//
//
//     } else {
//       setState(() {});
//       throw Exception('Failed to load ');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         height: 400,
//         child: Column(
//           children: [
//             TextField(
//               controller: videocalltoken,
//               decoration: InputDecoration(
//                 // errorText:
//                 //     _validateError ? 'Channel name is mandatory' : null,
//                 border: UnderlineInputBorder(
//                   borderSide: BorderSide(width: 1),
//                 ),
//                 hintText: "fcmtoken",
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 addUserData();
//               },
//               child: Text('Generate Token'),
//               style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
//                   foregroundColor: MaterialStateProperty.all(Colors.white)),
//             ),
//
//
//
//             SizedBox(
//               height: 50,
//             ),
//
//
//
//
//             TextField(
//               controller: title,
//               decoration: InputDecoration(
//                 // errorText:
//                 //     _validateError ? 'Channel name is mandatory' : null,
//                 border: UnderlineInputBorder(
//                   borderSide: BorderSide(width: 1),
//                 ),
//                 hintText: "send token to doctor",
//               ),
//             ),
//             TextField(
//               controller: chanelname,
//               decoration: InputDecoration(
//                 // errorText:
//                 //     _validateError ? 'Channel name is mandatory' : null,
//                 border: UnderlineInputBorder(
//                   borderSide: BorderSide(width: 1),
//                 ),
//                 hintText: "send token to doctor",
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: ElevatedButton(
//                 onPressed: () {
//                   onJoin();
//                   ClientRole.Broadcaster;
//                   },
//                 child: Text('Video'),
//                 style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all(Colors.blueAccent),
//                     foregroundColor: MaterialStateProperty.all(Colors.white)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
//
//   //Future<void>
//   onJoin() async {
//       await _handleCameraAndMic(Permission.camera);
//       await _handleCameraAndMic(Permission.microphone);
//       // push video page with given channel name
//
//       print(aagora_channel);
//       print(agoraToken);
//
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CallPage(
//               channelName: aagora_channel, role: _role, token: agoraToken),
//         ),
//       );
//   }
//
//   Future<void> _handleCameraAndMic(Permission permission) async {
//     final status = await permission.request();
//     print(status);
//   }
//
//   createUser({String? token}) async {
//     final docUser =
//         FirebaseFirestore.instance.collection("patient_token").doc("2");
//     final data = {'token': token};
//     await docUser.set(data);
//     setState(() {
//       videocalltoken = TextEditingController(text: "$fcmtoken");
//     });
//   }
//
//   Future Notify(String? title, String? body) async {
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: 1,
//             fullScreenIntent: true,
//             channelKey: 'key1',
//             title: '$title',
//             body: '$body',
//             category: NotificationCategory.Call
//
//         ),
//         actionButtons: [
//           NotificationActionButton(
//             label: 'Accpect',
//             enabled: true,
//             buttonType: ActionButtonType.InputField,
//             key: 'accpect',
//           ),
//           NotificationActionButton(
//             autoDismissible: true,
//             label: 'Rejcet',
//             enabled: true,
//             buttonType: ActionButtonType.Default,
//             key: 'cancel',
//           ),
//         ]);
//
//   }
// }
//
// const APP_ID = "859078bf386b4b6dab3fd661136ad696";
// const Token = "006859078bf386b4b6dab3fd661136ad696IABBrW6NU8B1sq5CF9wbcKtKSVQX90Y4WYpIvJ6Syuc6LFFuSlgAAAAAEABTv2OXTWZeYgEAAQBOZl5i";
// const chanel = "Surat";
//
// //Surat
// class CallPage extends StatefulWidget {
//   final String channelName;
//   final ClientRole role;
//   final String token;
//
//   /// Creates a call page with given channel name.
//   const CallPage(
//       {Key? key,
//       required this.channelName,
//       required this.role,
//       required this.token})
//       : super(key: key);
//
//   @override
//   _CallPageState createState() => _CallPageState();
// }
//
// class _CallPageState extends State<CallPage> {
//   final _users = <int>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   late RtcEngine _engine;
//
//   @override
//   void dispose() {
//     // clear users
//     _users.clear();
//     // destroy sdk
//     _engine.leaveChannel();
//     _engine.destroy();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initialize();
//   }
//
//   Future<void> initialize() async {
//     if (APP_ID.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }
//
//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     await _engine.enableWebSdkInteroperability(true);
//     VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
//     configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
//     await _engine.setVideoEncoderConfiguration(configuration);
//     await _engine.joinChannel(widget.token, widget.channelName, null, 0);
//   }
//
//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     _engine = await RtcEngine.create(APP_ID);
//     await _engine.enableVideo();
//     await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await _engine.setClientRole(widget.role);
//   }
//
//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
//       setState(() {
//         final info = 'onError: $code';
//         _infoStrings.add(info);
//       });
//     }, joinChannelSuccess: (channel, uid, elapsed) {
//       setState(() {
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         _infoStrings.add(info);
//       });
//     }, leaveChannel: (stats) {
//       setState(() {
//         _infoStrings.add('onLeaveChannel');
//         _users.clear();
//       });
//     }, userJoined: (uid, elapsed) {
//       setState(() {
//         final info = 'userJoined: $uid';
//         _infoStrings.add(info);
//         _users.add(uid);
//       });
//     }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
//       setState(() {
//         final info = 'firstRemoteVideo: $uid ${width}x $height';
//         _infoStrings.add(info);
//       });
//     }));
//   }
//
//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<StatefulWidget> list = [];
//     if (widget.role == ClientRole.Broadcaster) {
//       list.add(RtcLocalView.SurfaceView());
//     }
//     _users.forEach((
//       int uid,
//     ) =>
//         list.add(RtcRemoteView.SurfaceView(
//           uid: uid,
//           channelId: "",
//         )));
//     return list;
//   }
//
//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }
//
//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }
//
//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[_videoView(views[0])],
//         ));
//       case 2:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow([views[0]]),
//             _expandedVideoRow([views[1]])
//           ],
//         ));
//       // case 3:
//       //   return Container(
//       //       child: Column(
//       //         children: <Widget>[
//       //           _expandedVideoRow(views.sublist(0, 2)),
//       //           _expandedVideoRow(views.sublist(2, 3))
//       //         ],
//       //       ));
//       // case 4:
//       //   return Container(
//       //       child: Column(
//       //         children: <Widget>[
//       //           _expandedVideoRow(views.sublist(0, 2)),
//       //           _expandedVideoRow(views.sublist(2, 4))
//       //         ],
//       //       ));
//       default:
//     }
//     return Container();
//   }
//
//   /// Toolbar layout
//   Widget _toolbar() {
//     if (widget.role == ClientRole.Audience) return Container();
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: _onToggleMute,
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onCallEnd(context),
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: _onSwitchCamera,
//             child: Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           )
//         ],
//       ),
//     );
//   }
//
//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       alignment: Alignment.bottomCenter,
//       child: FractionallySizedBox(
//         heightFactor: 0.5,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _infoStrings.length,
//             itemBuilder: (BuildContext context, int index) {
//               if (_infoStrings.isEmpty) {
//                 return Text(
//                     "null"); // return type can't be null, a widget was required
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 3,
//                   horizontal: 10,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 2,
//                           horizontal: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.yellowAccent,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           _infoStrings[index],
//                           style: TextStyle(color: Colors.blueGrey),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }
//
//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     _engine.muteLocalAudioStream(muted);
//   }
//
//   void _onSwitchCamera() {
//     _engine.switchCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Stack(
//           children: <Widget>[
//             _viewRows(),
//             _panel(),
//             _toolbar(),
//           ],
//         ),
//       ),
//     );
//   }
// }