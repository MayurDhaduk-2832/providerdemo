import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oneqlik/Provider/contactUs_provider.dart';
import 'package:oneqlik/Provider/customer_dealer_provider.dart';
import 'package:oneqlik/Provider/expenses_provider.dart';
import 'package:oneqlik/Provider/fuel_provider.dart';
import 'package:oneqlik/Provider/geofence_provider.dart';
import 'package:oneqlik/Provider/group_provider.dart';
import 'package:oneqlik/Provider/histroy_provider.dart';
import 'package:oneqlik/Provider/home_provider.dart';
import 'package:oneqlik/Provider/maintenance_provider.dart';
import 'package:oneqlik/Provider/notifications_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/Provider/update_password_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/Provider/vehicle_list_provider.dart';
import 'package:oneqlik/local/localization/demo_localization.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/Authentication/LoginScreen/login_screen.dart';
import 'package:oneqlik/screens/Authentication/RegisterScreen/register_screen.dart';
import 'package:oneqlik/screens/Authentication/splash_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/map_provider.dart';
import 'package:oneqlik/screens/DashBoardScreen/dashboard_screen.dart';
import 'package:oneqlik/screens/OnboardingScreens/onboarding_screens.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:soundpool/soundpool.dart';

import 'Provider/add_vehicle_provider.dart';
import 'Provider/login_provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
// log("message is category ${message.category}");
  log("background notification message ${message.toString()}");
  log("background notification message Data ${message.data.toString()}");
  log("background notification message notification ${message.notification.toString()}");
  log("background notification message notification title ${message.notification.title}");
  log("background notification message notification body ${message.notification.body}");
  log("background notification message notification title is Ignition Alert ${message.notification.title.contains("Ignition Alert")}");

  print("iff part excute ");
  // FlutterRingtonePlayer.play(fromAsset: "assets/ringtone.wav");
  Soundpool pool = Soundpool(streamType: StreamType.notification);
  String notificationSound = "";
  if (message?.data['sound'] != null) {
    String sound = message?.data['sound'];
    if (!sound.contains(".mp3")) {
      notificationSound = sound + ".mp3";
    } else {
      notificationSound = sound;
    }
  }
  int soundId = await rootBundle
      .load("assets/images/$notificationSound")
      .then((ByteData soundData) {
    return pool.load(soundData);
  });
  int streamId = await pool.play(soundId);
  log("Stream ID $streamId");

  // if(message.notification.title.contains("Ignition Alert")){
  //   print("iff part excute ");
  //   // FlutterRingtonePlayer.play(fromAsset: "assets/ringtone.wav");
  //   Soundpool pool = Soundpool(streamType: StreamType.notification);
  //
  //   int soundId = await rootBundle.load("assets/images/ignitionon.mp3").then((ByteData soundData) {
  //     return pool.load(soundData);
  //   });
  //   int streamId = await pool.play(soundId);
  //   log("Stream ID $streamId");
  // }
  // else if(message.notification.title.contains("Ignition Alert")){
  //   log("iff part excute ");
  //   // FlutterRingtonePlayer.play(fromAsset: "assets/ringtone.wav");
  //   Soundpool pool = Soundpool(streamType: StreamType.notification);
  //
  //   int soundId = await rootBundle.load("assets/images/ignitionoff.mp3").then((ByteData soundData) {
  //     return pool.load(soundData);
  //   });
  //   int streamId = await pool.play(soundId);
  //   log("Stream ID $streamId");
  // }
  // else if(message.notification.title.contains("Theft Alert")){
  //   log("iff part excute ");
  //   // FlutterRingtonePlayer.play(fromAsset: "assets/ringtone.wav");
  //   Soundpool pool = Soundpool(streamType: StreamType.notification);
  //
  //   int soundId = await rootBundle.load("assets/images/police.mp3").then((ByteData soundData) {
  //     return pool.load(soundData);
  //   });
  //   int streamId = await pool.play(soundId);
  //   log("Stream ID $streamId");

  // }
  log("message is body  ${message.notification.body}");

  /*flutterLocalNotificationsPlugin.initialize(InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/launcher_icon")));

  final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          "FLUTTER_NOTIFICATION_CLICK", "OneQlik",
          channelDescription: "this is our channel",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          sound: RawResourceAndroidNotificationSound('police')));
  final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  await flutterLocalNotificationsPlugin.show(
    id,
    message.notification.title,
    message.notification.body,
    notificationDetails,
    payload: "-",
  );*/
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.getToken().then((value) {
    print("Token => $value");
  });
  // void requestNotificationPermission() async{
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    sound: true,
    provisional: true,
    criticalAlert: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("granted");
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    flutterLocalNotificationsPlugin.initialize(InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/launcher_icon"),
        iOS: IOSInitializationSettings()));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('onMessage() -> data: ${message?.data}');
      // Handle incoming notifications
      if (message.notification.title != null) {
        print("message is title ${message.notification.title}");
      }
      String notificationSound = "";
      print("message is category =>${message?.data['sound']}");
      if (message?.data['sound'] != null) {
        String sound = message?.data['sound'];
        if (sound == "default.mp3") {
          notificationSound = "audio";
        } else {
          if (!sound.contains(".mp3") && !sound.contains(".wav")) {
            notificationSound = sound;
            print("object1 => $notificationSound");
          } else {
            String result = sound.substring(0, sound.indexOf('.'));
            notificationSound = result;
            print("object => $notificationSound");
          }
        }
      }
      // LocalNotificationService.display(message);
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "1",
        "OneQlik",
        channelDescription: "this is our channel",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(notificationSound),
        icon: "@mipmap/launcher_icon",
      ));
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        message.notification.title == null ? "" : message.notification.title,
        message.notification.body,
        notificationDetails,
      );

      print(
          "message is title ignitionon ${message.notification.title.contains("Ignition Alert")}");

      /*Soundpool pool = Soundpool(streamType: StreamType.notification);

      int soundId = await rootBundle
          .load("assets/images/$notificationSound")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });

      int streamId = await pool.play(soundId);
      print("Stream ID $streamId");*/

      /* if(message.notification.title.contains("Ignition Alert")){
          print("iff part excute ");
          // FlutterRingtonePlayer.play(fromAsset: "assets/ringtone.wav");
          Soundpool pool = Soundpool(streamType: StreamType.notification);

          int soundId = await rootBundle.load("assets/images/ignitionon.mp3").then((ByteData soundData) {
            return pool.load(soundData);
          });
          int streamId = await pool.play(soundId);
          print("Stream ID $streamId");
        }
        else if(message.notification.title.contains("Ignition Alert")){
          print("iff part excute ");
          // FlutterRingtonePlayer.play(fromAsset: "assets/ringtone.wav");
          Soundpool pool = Soundpool(streamType: StreamType.notification);

          int soundId = await rootBundle.load("assets/images/ignitionoff.mp3").then((ByteData soundData) {
            return pool.load(soundData);
          });
          int streamId = await pool.play(soundId);
          print("Stream ID $streamId");
        }
        else if(message.notification.title.contains("Theft Alert")){
          print("iff part excute theft alert ");
          // FlutterRingtonePlayer.play(fromAsset: "assets/ringtone.wav");
          Soundpool pool = Soundpool(streamType: StreamType.notification);

          int soundId = await rootBundle.load("assets/images/police.mp3").then((ByteData soundData) {
            return pool.load(soundData);
          });
          int streamId = await pool.play(soundId);
          print("Stream ID $streamId");
        }*/
      print("message is body  ${message.notification.body}");
    });
  }
  // }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /* if (WidgetsBinding.instance?.lifecycleState == AppLifecycleState.resumed) {
      print("app resumed");
      setState(() {
        permissionStatusFuture = getCheckNotificationPermStatus();
      });
    }*/
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //LocalNotificationService.initialize(context);
    Utils.platform = Theme.of(context).platform;
  }

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(ApplicationColors.redColor67),
          ),
        ),
      );
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LoginProvider()),
          ChangeNotifierProvider(create: (context) => VehicleListProvider()),
          ChangeNotifierProvider(create: (context) => HomeProvider()),
          ChangeNotifierProvider(create: (context) => GetGroupListProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => ExpensesProvider()),
          ChangeNotifierProvider(create: (context) => FuelProvider()),
          ChangeNotifierProvider(create: (context) => UpdatePasswordProvider()),
          ChangeNotifierProvider(create: (context) => ReportProvider()),
          ChangeNotifierProvider(create: (context) => MaintenanceProvider()),
          ChangeNotifierProvider(create: (context) => NotificationsProvider()),
          ChangeNotifierProvider(create: (context) => ContactUsProvider()),
          ChangeNotifierProvider(create: (context) => GeofencesProvider()),
          ChangeNotifierProvider(create: (context) => HistoryProvider()),
          ChangeNotifierProvider(create: (context) => CustomerDealerProvider()),
          ChangeNotifierProvider(create: (context) => AddVehicleProvider()),
          ChangeNotifierProvider(create: (context) => MapProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AI TRACKING SOLUTIONS',
          theme: ThemeData(
              primaryColor: ApplicationColors.blackColor2E,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent),
          home: SplashScreen(),
          // home: Sys(),
          routes: <String, WidgetBuilder>{
            '/logIn': (BuildContext context) => LoginScreen(),
            '/dashBoard': (BuildContext context) => DashBoardScreen(),
            '/register': (BuildContext context) => RegisterScreen(),
            '/onboard': (BuildContext context) => OnBoardingScreen(),
          },

          locale: _locale,
          supportedLocales: [
            Locale("en", "US"),
            Locale("hi", "IN"),
            Locale("mr", "IN"),
            Locale("bn", "IN"),
            Locale("ta", "IN"),
            Locale("te", "IN"),
            Locale("gu", "IN"),
            Locale("kn", "IN"),
            Locale("ml", "IN"),
            Locale("pa", "IN"),
            Locale("es", "SPA"),
            Locale("fa", "PER"),
            Locale("ar", "ARA"),
            Locale("ne", "NEP"),
            Locale("fr", "FRE"),
            Locale("pt", "POR"),
            Locale("ps", "PUS"),
            Locale("it", "ITA"),
            Locale("nl", "DUT"),
            Locale("id", "IND"),
          ],
          localizationsDelegates: [
            DemoLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
        ),
      );
    }
  }
}
