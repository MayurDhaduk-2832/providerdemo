import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ExampleLocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("@drawable/ic_notification")
    );

    _notificationsPlugin.initialize(initializationSettings, onSelectNotification:(String data) async
    {

      print("Post Id : "+ data);

      try{


        Future.delayed(const Duration(seconds: 1), (){



        }
        );

      }
      catch(e){
        print(e);
      }

      /*Future.delayed(const Duration(seconds: 2), (){
      });*/

    });
  }

  static void display(RemoteMessage message) async {

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              "FLUTTER_NOTIFICATION_CLICK",
              "Altihad_CHANNEL",
              channelDescription: "Altihad is our channel",
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
              enableLights: true
          )
      );


      await _notificationsPlugin.show(
        id,
        message.notification.title,
        message.notification.body,
        notificationDetails,
        payload: "${message.data['postid']}",
        // payload: "-",
      );



    } on Exception catch (e) {
      print(e);
    }
  }
}