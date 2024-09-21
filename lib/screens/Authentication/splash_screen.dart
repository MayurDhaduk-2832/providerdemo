import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneqlik/MyNavigation/myNavigator.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/notification_service/notification_service.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/assets_images.dart';
import '../../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserProvider _userSettingsProvider;

  @override
  void initState() {
    super.initState();
    _userSettingsProvider = Provider.of<UserProvider>(context, listen: false);

    /* LocalNotificationService.initialize(context,);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {

    });

    FirebaseMessaging.onBackgroundMessage((message) {
      LocalNotificationService.display(message);
      playSong();
    });

    ///foreground work
    FirebaseMessaging.onMessage.listen((message) {
     LocalNotificationService.display(message);
     playSong();
    });


    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      LocalNotificationService.display(message);
      playSong();
    });
*/
    /* Future.delayed(Duration.zero, () async {
      final permission = await Utils.requestPermissions(context);

    });*/

    Future.delayed(Duration.zero, () async {
      final currentPosition = await Utils.getGeoLocationPositionTwo();
      print("device toluene ${Utils.deviceToken}");

      Utils.lat = currentPosition.latitude;
      Utils.lng = currentPosition.longitude;

      print("lat${Utils.lat.toString()}");
      print("lng${Utils.lng.toString()}");
    });

    Future.delayed(
      Duration(seconds: 1),
      () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();

        if (preferences.getString("MapType") != null) {
          if (preferences.getString("MapType") == "Normal") {
            Utils.mapType = MapType.normal;
          } else if (preferences.getString("MapType") == "Satellite") {
            Utils.mapType = MapType.satellite;
          } else if (preferences.getString("MapType") == "Terrain") {
            Utils.mapType = MapType.terrain;
          } else if (preferences.getString("MapType") == "Hybrid") {
            Utils.mapType = MapType.hybrid;
          }
        }

        if (preferences.getInt("homeIndex") != null) {
          _userSettingsProvider
              .changeBottomIndex(preferences.getInt("homeIndex"));
        }

        if (preferences.getBool("remember") == true) {
          MyNavigator.goToDashBoard(context);
        } else {
          // MyNavigator.goToOnboard(context);
          MyNavigator.goToLoginPage(context);
        }
      },
    );
  }

  playSong() {
    Future.delayed(Duration(seconds: 1), () {
      FlutterRingtonePlayer.play(
        fromAsset: "assets/police.wav",
        asAlarm: true,
        looping: true,
        volume: 1.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _userSettingsProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: ApplicationColors.whiteColorF9),
        child: Center(
          child: Image.asset(AssetsUtilities.logoPng, height: 250),
        ),
      ),
    );
  }
}
