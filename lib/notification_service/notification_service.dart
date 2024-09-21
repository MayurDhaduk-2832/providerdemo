import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@drawable/logo"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String data) async {
      Future.delayed(Duration(seconds: 1), () {
        FlutterRingtonePlayer.stop();
      });
      if (data != null) {}
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "FLUTTER_NOTIFICATION_CLICK",
        "OneQlik",
        channelDescription: "this is our channel",
        importance: Importance.max,
        priority: Priority.high,
        /*playSound: true,*/
        enableVibration: true,
        enableLights: true,
        /*sound: RawResourceAndroidNotificationSound('police')*/
      ));

      await _notificationsPlugin.show(
        12,
        message.notification.title,
        message.notification.body,
        notificationDetails,
        payload: "-",
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  static void alertDisplay(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "FLUTTER_NOTIFICATION_CLICK",
        "key1",
        channelDescription: "this is our channel",
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound("police"),
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ));

      await _notificationsPlugin.show(
        id,
        message.notification.title,
        message.notification.body,
        notificationDetails,
        payload: "-",
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
