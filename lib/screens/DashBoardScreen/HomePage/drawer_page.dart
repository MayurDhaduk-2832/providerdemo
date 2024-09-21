import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/CustomerSupportPages/ContactUsScreen/contact_us_screen.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Provider/home_provider.dart';
import '../../../Provider/login_provider.dart';
import '../../../Provider/user_provider.dart';
import '../../../utils/utils.dart';
import '../../SuparAdmin/customers_dealers.dart';
import '../DrawerPages/ExpensesScreens/expenses_screen.dart';
import '../DrawerPages/FuelPages/main_fuel_page.dart';
import '../DrawerPages/GroupsScreens/main_groups_screen.dart';
import '../DrawerPages/ProfilePages/profile_screen.dart';
import '../DrawerPages/ReportsScreen/Speed_variation_report.dart';
import '../DrawerPages/ReportsScreen/ac_report.dart';
import '../DrawerPages/ReportsScreen/daily_reports_screen.dart';
import '../DrawerPages/ReportsScreen/day_wise_report_screen.dart';
import '../DrawerPages/ReportsScreen/distance_report_screen.dart';
import '../DrawerPages/ReportsScreen/geofence_report_screen.dart';
import '../DrawerPages/ReportsScreen/idle_report_screen.dart';
import '../DrawerPages/ReportsScreen/ignition_report.dart';
import '../DrawerPages/ReportsScreen/over_speed_report.dart';
import '../DrawerPages/ReportsScreen/poi_report.dart';
import '../DrawerPages/ReportsScreen/reports_screen.dart';
import '../DrawerPages/ReportsScreen/route_violation_report.dart';
import '../DrawerPages/ReportsScreen/sos_report.dart';
import '../DrawerPages/ReportsScreen/stoppage_report.dart';
import '../DrawerPages/ReportsScreen/summary_report.dart';
import '../DrawerPages/ReportsScreen/trip_report.dart';
import '../DrawerPages/ReportsScreen/working_hours_reports.dart';
import '../DrawerPages/VehicleMaintenancePages/maintenance_reminder.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  UserProvider userProvider;
  HomeProvider homeProvider;
  LoginProvider loginProvider;

  bool isSuperAdmin = false;
  bool isDealer = false;
  String credentialType = "";
  String email = "";
  String pass = "";
  bool reports = false;

  showDialogBox(bool logout) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ApplicationColors.blackColor2E,
        title: Text(
          "${getTranslated(context, "are_you_sure")}",
          style: Textstyle1.text12b,
        ),
        content: Text(
          "${getTranslated(context, logout ? "do_want_exit" : "do_want_to_login")}" +
              "${!logout ? " Admin" : ""}",
          style: Textstyle1.text12b,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              "${getTranslated(context, "no")}",
              style: Textstyle1.text12b,
            ),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();

              var token = sharedPreferences.getString("fbToken");
              var id = sharedPreferences.getString("uid");

              var sendData = {
                "os": Platform.isAndroid ? "android" : "iso",
                "token": "$token",
                "uid": "$id"
              };
              if (logout) {
                await loginProvider.removeFirebaseToken(
                    sendData, "users/PullNotification", context, true);
              } else {
                await loginProvider.removeFirebaseToken(
                    sendData, "users/PullNotification", context, false);
                await loginProvider.loginUser({
                  "$credentialType": email,
                  "psd": pass,
                }, "users/LoginWithOtp", context, credentialType, email, pass);
              }
            },
            child: Text(
              "${getTranslated(context, "yes")}",
              style: Textstyle1.text12b,
            ),
          ),
        ],
      ),
    );
  }

  getBool() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      isSuperAdmin = sharedPreferences.getBool("superAdmin");
      isDealer = sharedPreferences.getBool("isDealer");
    });
  }

  Future<void> getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    credentialType = sharedPreferences.getString("UserCredentialType");
    email = sharedPreferences.getString("AdminID");
    pass = sharedPreferences.getString("AdminPass");
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    getBool();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    homeProvider = Provider.of<HomeProvider>(context, listen: true);
    loginProvider = Provider.of<LoginProvider>(context, listen: true);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              Color(0xffC21832),
              Color(0xff7C1D21),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              width: width,
              padding: EdgeInsets.only(top: height * .07, bottom: height * .04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: ApplicationColors.dropdownColor3D, width: 5),
                        shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${Utils.http}${Utils.baseUrl}${userProvider.userImage}",
                        width: 63,
                        height: 63,
                        fit: BoxFit.fill,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress)),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/profile_icon.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${userProvider.useModel.cust.firstName} ${userProvider.useModel.cust.lastName}',
                    overflow: TextOverflow.visible,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 2),
                      Text(
                        '${userProvider.useModel.cust.email}',
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 1),
                      Text(
                        '${userProvider.useModel.cust.phone}',
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.clamp,
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF574e51),
                    Color(0xFF1f2326),
                  ],
                ),
                /*  image: DecorationImage(
                    image: AssetImage("assets/images/oneqlik_drawer_image.png"),
                    fit: BoxFit.fill,
                  )*/
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    MenusInDrawer(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      iconPath: "assets/images/other_icon.png",
                      name: '${getTranslated(context, "home")}',
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    MenusInDrawer(
                      onPress: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => GroupsScreen(),
                          ),
                        );
                      },
                      iconPath: "assets/images/groups_ic.png",
                      name: '${getTranslated(context, "groups")}',
                    ),
                    isDealer == true || isSuperAdmin == true
                        ? Column(
                            children: [
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CustomersDealers(
                                        isDealer: isDealer,
                                      ),
                                    ),
                                  );
                                },
                                iconPath: "assets/images/shakehand.png",
                                name: isDealer == true
                                    ? '${getTranslated(context, "customer")}'
                                    : '${getTranslated(context, "customer_dealers")}',
                              ),
                            ],
                          )
                        : Container(),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    MenusInDrawer(
                      onPress: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ExpensesScreen()));
                      },
                      iconPath: "assets/images/money_icon.png",
                      name: '${getTranslated(context, "expenses")}',
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    MenusInDrawer(
                      onPress: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FuelPages()));
                      },
                      iconPath: "assets/images/fuel_icon.png",
                      name: '${getTranslated(context, "fuel_small")}',
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    MenusInDrawer(
                      onPress: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MaintenanceReminderPage()));
                      },
                      iconPath: "assets/images/car_repair_ic.png",
                      name: '${getTranslated(context, "Reminds")}',
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          reports = !reports;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                "assets/images/report_ic.png",
                                color: ApplicationColors.whiteColor,
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: ApplicationColors.transparentColors,
                                borderRadius: BorderRadius.circular(41)),
                          ),
                          // SizedBox(height: 20, width: 20, child: Image.asset(iconPath)),

                          Text(
                            '${getTranslated(context, "reports")}',
                            style: FontStyleUtilities.s14(
                                //fontColor: ApplicationColors.whiteColor,
                                fontColor: ApplicationColors.whiteColor,
                                fontFamily: "Poppins-Regular"),
                          ),
                          Spacer(),
                          reports
                              ? Icon(
                                  Icons.keyboard_arrow_up,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 30,
                                ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    reports
                        ? Column(
                            children: [
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AcReportScreen()));
                                },
                                iconPath: "assets/images/ac_report.png",
                                name: '${getTranslated(context, "ac_reports")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DayWiseReportScreen()));
                                },
                                iconPath: "assets/images/day_wise_report.png",
                                name:
                                    '${getTranslated(context, "day_wise_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              GeofenceReportScreen()));
                                },
                                iconPath: "assets/images/geofence_report.png",
                                name:
                                    '${getTranslated(context, "geofence_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              IdleReportScreen()));
                                },
                                iconPath: "assets/images/idle_report.png",
                                name:
                                    '${getTranslated(context, "idle_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              IgnitionReportScreen()));
                                },
                                iconPath: "assets/images/ignition_reports_.png",
                                name:
                                    '${getTranslated(context, "ignition_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          OverSpeedReportScreen(),
                                    ),
                                  );
                                },
                                iconPath: "assets/images/over_speed_report.png",
                                name:
                                    '${getTranslated(context, "over_speed_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PoiReportScreen()));
                                },
                                iconPath: "assets/images/poi_report.png",
                                name: '${getTranslated(context, "poi_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SosReportScreen()));
                                },
                                iconPath: "assets/images/sos_report.png",
                                name: '${getTranslated(context, "sos_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SpeedVariationReportPage()));
                                },
                                iconPath: "assets/images/speed_report.png",
                                name:
                                    '${getTranslated(context, "speed_variation_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              StoppageReportScreen()));
                                },
                                iconPath: "assets/images/stoppage_report.png",
                                name:
                                    '${getTranslated(context, "stoppage_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SummaryReportScreen()));
                                },
                                iconPath: "assets/images/summary_report.png",
                                name:
                                    '${getTranslated(context, "summary_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              TripReportScreen()));
                                },
                                iconPath: "assets/images/trip_report.png",
                                name:
                                    '${getTranslated(context, "trip_report")}',
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              MenusInDrawer(
                                onPress: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              WorkingHoursReports()));
                                },
                                iconPath: "assets/images/working_report.png",
                                name:
                                    '${getTranslated(context, "working_hours_report")}',
                              ),
                            ],
                          )
                        : Container(),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    MenusInDrawer(
                      onPress: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ContactUsScreen()));
                      },
                      iconPath: "assets/images/customer_ic.png",
                      name: '${getTranslated(context, "customer_support")}',
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    MenusInDrawer(
                      onPress: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileScreen()));
                      },
                      iconPath: "assets/images/account_ic.png",
                      name: '${getTranslated(context, "profile")}',
                    ),
                    isSuperAdmin
                        ? SizedBox.shrink()
                        : credentialType != null && credentialType != ""
                            ? SizedBox(height: height * 0.010)
                            : SizedBox.shrink(),
                    isSuperAdmin
                        ? SizedBox.shrink()
                        : credentialType != null && credentialType != ""
                            ? Column(
                                children: [
                                  Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                  MenusInDrawer(
                                    onPress: () {
                                      Navigator.pop(context);
                                      showDialogBox(false);
                                    },
                                    iconPath: "assets/images/costomers.png",
                                    name:
                                        '${getTranslated(context, "login_as_admin")}',
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenusInDrawer extends StatelessWidget {
  String iconPath;
  String name;
  VoidCallback onPress;

  MenusInDrawer({Key key, this.iconPath, this.name, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onPress,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                iconPath,
                color: ApplicationColors.whiteColor,
              ),
            ),
            decoration: BoxDecoration(
                color: ApplicationColors.transparentColors,
                borderRadius: BorderRadius.circular(41)),
          ),
          // SizedBox(height: 20, width: 20, child: Image.asset(iconPath)),

          Text(
            name,
            style: FontStyleUtilities.s14(
                //fontColor: ApplicationColors.whiteColor,
                fontColor: ApplicationColors.whiteColor,
                fontFamily: "Poppins-Regular"),
          )
        ],
      ),
    );
  }
}
