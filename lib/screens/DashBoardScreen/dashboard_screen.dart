import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/reports_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/GeofencesPage/Geofeces.dart';
import 'package:oneqlik/screens/DashBoardScreen/HomePage/drawer_page.dart';
import 'package:oneqlik/screens/DashBoardScreen/LiveTrackingScreen/live_tracking_screen_copy.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_list.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../Helper/helper.dart';
import 'HomePage/home_screens.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  UserProvider _userSettingsProvider;

  bool isSpeak = true;
  bool isDeviceConnected = false;
  StreamSubscription subscription;
  bool isAlertSet = false;

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: ApplicationColors.blackColor2E,
            title: Text(
              '${getTranslated(context, "are_you_sure")}',
              style: Textstyle1.text12b,
            ),
            content: Text(
              '${getTranslated(context, "do_want_exit")}',
              style: Textstyle1.text12b,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  '${getTranslated(context, "no")}',
                  style: Textstyle1.text12b,
                ),
              ),
              TextButton(
                onPressed: () async {
                  // await checkUserRoleAndPlaySound("assets/images/ignitionoff.mp3");
                  exit(0);
                },
                /*Navigator.of(context).pop(true)*/
                child: Text(
                  '${getTranslated(context, "yes")}',
                  style: Textstyle1.text12b,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  GlobalKey<ScaffoldState> navigatorKey = GlobalKey<ScaffoldState>();

  final List<Widget> _children = [
    HomeScreens(),
    LiveTrackingScreenCopy(),
    Vehicle_list(),
    //HistoryPage(),
    ReportsScreen(),
    Geofences(),
  ];

  // Future<void> _speak() async {
  //
  //   print(_userSettingsProvider.useModel.cust.firstName + _userSettingsProvider.useModel.cust.lastName);
  //   String textToRead = "Welcome ${_userSettingsProvider.useModel.cust.firstName + _userSettingsProvider.useModel.cust.lastName}.";
  //
  //   await flutterTts.setLanguage("en-US"); // Set the language (locale)
  //   await flutterTts.setSpeechRate(0.5); // Set speech rate
  //   await flutterTts.setVolume(1.0); // Set volume
  //   await flutterTts.speak(textToRead); // Start speaking
  // }
  //
  // Future<void> _stop() async {
  //   await flutterTts.stop(); // Stop speaking
  // }

  @override
  void initState() {
    getConnectivity();
    super.initState();
    checkInterNetConnection();
    _userSettingsProvider = Provider.of<UserProvider>(context, listen: false);
    Future.delayed(Duration(microseconds: 100), () {
      Utils.navigatorKey = navigatorKey;
      // checkUserRoleAndPlaySound("assets/images/ignitionon.mp3");
    });
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  checkInterNetConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      Helper.dialogCall
          .showToast(context, "I am connected to a mobile network.");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      Helper.dialogCall.showToast(context, "I am connected to a wifi network.");
    } else if (connectivityResult == ConnectivityResult.none) {
      // I am not connected to any network.
      Helper.dialogCall
          .showToast(context, "I am not connected to any network.");
    }
  }

  @override
  Widget build(BuildContext context) {
    _userSettingsProvider = Provider.of<UserProvider>(context, listen: true);
    // if(isSpeak){
    //   isSpeak = false;
    //   _speak();
    // }
    //_speak();
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState.isDrawerOpen) {
          Navigator.pop(context);
        } else {
          if (_userSettingsProvider.index == 0) {
            _onWillPop();
          } else {
            _userSettingsProvider.changeBottomIndex(0);
            setState(() {
              Utils.vehicleStatus = "";
            });
          }
        }
        return false;
      },
      child: Scaffold(
        extendBody: true,
        key: navigatorKey,
        backgroundColor: ApplicationColors.containercolor,
        drawer:
            _userSettingsProvider.useModel == null ? SizedBox() : DrawerPage(),

        body: _children[_userSettingsProvider.index],
        // bottomNavigationBar: CurvedNavigationBar(
        //   buttonBackgroundColor: ApplicationColors.redColor67,
        //   height: 60,
        //   color: ApplicationColors.dropdownColor3D,
        //   backgroundColor: Colors.transparent,
        //   index: _userSettingsProvider.index,
        //   items: <Widget>[
        //     Container(
        //       width: 30,
        //       height: 22,
        //       child: Image.asset(
        //         menuofBottomNavBar[0]['icon'],
        //         width: 30,
        //         height: 22,
        //         color: ApplicationColors.whiteColor,
        //       ),
        //     ),
        //     Container(
        //       width: 30,
        //       height: 22,
        //       child: Image.asset(
        //         menuofBottomNavBar[1]['icon'],
        //         width: 30,
        //         height: 22,
        //         color: ApplicationColors.whiteColor,
        //       ),
        //     ),
        //     Container(
        //       width: 30,
        //       height: 22,
        //       child: Image.asset(
        //         menuofBottomNavBar[2]['icon'],
        //         width: 30,
        //         height: 22,
        //         color: ApplicationColors.whiteColor,
        //       ),
        //     ),
        //     Container(
        //       width: 30,
        //       height: 22,
        //       child: Image.asset(
        //         menuofBottomNavBar[3]['icon'],
        //         width: 30,
        //         height: 22,
        //         color: ApplicationColors.whiteColor,
        //       ),
        //     ),
        //     Container(
        //       width: 30,
        //       height: 22,
        //       child: Image.asset(
        //         menuofBottomNavBar[4]['icon'],
        //         width: 30,
        //         height: 22,
        //         color: ApplicationColors.whiteColor,
        //       ),
        //     ),
        //   ],
        //   onTap: (index) {
        //     _userSettingsProvider.changeBottomIndex(index);
        //     setState(() {
        //       Utils.vehicleStatus = "";
        //     });
        //   },
        // ),
      ),
    );
  }
}

List menuofBottomNavBar = [
  {
    'icon': "assets/images/menu_icon.png",
    'menuName': 'HomePage',
  },
  {
    'icon': "assets/images/location_icon.png",
    'menuName': 'Shortlisted',
  },
  {
    'icon': "assets/images/vehicle_icon.png",
    'menuName': 'Post',
  },
  {
    'icon': "assets/images/report_ic.png",
    'menuName': 'Alerts',
  },
  {
    'icon': "assets/images/geofences_icon.png",
    'menuName': 'Profile',
  },
];
