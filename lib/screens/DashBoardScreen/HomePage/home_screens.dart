import 'dart:io';

import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/home_provider.dart';
import 'package:oneqlik/Provider/login_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/history.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/history_new.dart';
import 'package:oneqlik/screens/SyncfunctionPages/chart.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Provider/reports_provider.dart';
import '../GeofencesPage/Geofeces.dart';
import '../LiveTrackingScreen/live_tracking_screen_copy.dart';
import 'NotificationPage/notification_screen.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key key}) : super(key: key);

  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  int _currentPage = 0;
  PageController _controller = PageController();
  ReportProvider _reportProvider;

  UserProvider userProvider;
  HomeProvider homeProvider;
  LoginProvider loginProvider;
  UserProvider _userSettingsProvider;

  _onchanged(int index) {
    setState(() {
      _currentPage = index;

      if (_currentPage == 1) {
        getVehicleExpenseList();
      }
    });
  }

  getDeviceByUserDropdown() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");

    var data = {"email": email, "id": id};

    await _reportProvider.getVehicleDropdown(
      data,
      "devices/getDeviceByUserDropdown",
    );
  }

  getfuelPriceList(statename) async {
    var data = {
      "state": statename,
    };
    print("getFualprice$data");
    await homeProvider.getfuelPriceList(data, "googleAddress/getFuelPrice1");
  }

  getVehicleExpenseList() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {"id": id};

    await homeProvider.getVehicleExpense(data, "expense/dashboardExpense1");
  }

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;

  getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
    };

    await userProvider.getUserData(data, "users/getCustumerDetail", context);
    // getVehicleStatusList();
  }

  getVehicleStatusList() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");
    bool supAdmin = sharedPreferences.getBool("superAdmin");
    bool isDealer = sharedPreferences.getBool("isDealer");
    print("print admin ==> $supAdmin");

    var data = supAdmin
        ? {
            "id": id,
            "email": email,
            "from": DateTime.now().subtract(Duration(days: 1)).toString(),
            "to": DateTime.now().toString(),
            "supAdmin": id
          }
        : isDealer
            ? {
                "id": id,
                "email": email,
                "from": DateTime.now().subtract(Duration(days: 1)).toString(),
                "to": DateTime.now().toString(),
                "dealer": id
              }
            : {
                "id": id,
                "email": email,
                "from": DateTime.now().subtract(Duration(days: 1)).toString(),
                "to": DateTime.now().toString(),
              };

    print(data);

    await homeProvider.getVehicleStatus(data, "gps/getDashboard1");
    // getMoneySpent();
    // getfuelPriceList("Gujarat");
  }

  getMoneySpent() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data = {
      "user": "$id",
    };

    print(data);

    await homeProvider.getMoneySpent(data, "summary/getSevenDaysDataForUser");
  }

  int serviceOfIndex = 0;

  var selectedGraph = "Fuel";

  showDialogBox() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ApplicationColors.blackColor2E,
        title: Text(
          '${getTranslated(context, "are_you_sure")}',
          style: Textstyle1.text12,
        ),
        content: Text(
          '${getTranslated(context, "do_want_exit")}',
          style: Textstyle1.text12,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              '${getTranslated(context, "no")}',
              style: Textstyle1.text12,
            ),
          ),
          TextButton(
            onPressed: () async {
              sharedPreferences = await SharedPreferences.getInstance();

              var token = sharedPreferences.getString("fbToken");
              var id = sharedPreferences.getString("uid");

              var sendData = {
                "os": Platform.isAndroid ? "android" : "iso",
                "token": "$token",
                "uid": "$id"
              };

              await loginProvider.removeFirebaseToken(
                  sendData, "users/PullNotification", context, true);
            },
            child: Text(
              '${getTranslated(context, "yes")}',
              style: Textstyle1.text12,
            ),
          ),
        ],
      ),
    );
  }

  getUserSettings() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    print("User id is:$id");
    var data = {"uid": id};

    print('CheckGet-->$data');

    userProvider.getUserSettings(data, "users/get_user_setting", context);
  }

  @override
  void initState() {
    super.initState();

    userProvider = Provider.of<UserProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    getVehicleStatusList();
    getUserSettings();
    getUserData();
    getDeviceByUserDropdown();
    //getVehicleExpenseList();
    //getMoneySpent();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    homeProvider = Provider.of<HomeProvider>(context, listen: true);
    loginProvider = Provider.of<LoginProvider>(context, listen: true);
    _userSettingsProvider = Provider.of<UserProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return userProvider.isLoading ||
            //homeProvider.isVehicleExpenseLoading ||
            homeProvider.isVehicleLoading ||
            // homeProvider.isMoneyLoading ||
            userProvider.useModel == null ||
            homeProvider.vehicleStatusModel.data == null
        ? Helper.dialogCall.showLoader()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: InkWell(
                  onTap: () {
                    Utils.navigatorKey.currentState.openDrawer();
                  },
                  child: Icon(
                    Icons.menu,
                    color: ApplicationColors.white9F9,
                    size: 26,
                  ),
                ),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Dashboard',
                        // '${userProvider.useModel.cust.firstName} ${userProvider.useModel.cust.lastName}',
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Arial',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Welcome, ${userProvider.useModel.cust.firstName} ${userProvider.useModel.cust.lastName}!',
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Arial',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen()));
                      },
                      child: Image.asset(
                        "assets/images/notification_icon.png",
                        width: 18,
                        height: 18,
                        color: ApplicationColors.white9F9,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: <Color>[
                        Color(0xffd21938),
                        Color(0xff751c1e),
                      ],
                    ),
                  ),
                ),
              ),
              body: DeclarativeRefreshIndicator(
                color: ApplicationColors.redColor67,
                backgroundColor: ApplicationColors.whiteColor,
                refreshing: homeProvider.isVehicleLoading,
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () async {
                  await getVehicleStatusList();
                  await getUserData();
                  await getDeviceByUserDropdown();
                  await getUserSettings();
                  await getVehicleExpenseList();
                  await getMoneySpent();
                },
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Text(
                            _currentPage == 0
                                ? '${getTranslated(context, "vehicle_current_status")}'
                                : _currentPage == 1
                                    ? '${getTranslated(context, "past_4week_spent")}'
                                    : '${getTranslated(context, "Vehicle_Expense")}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            // style: FontStyleUtilities.s14(
                            //     fontColor: ApplicationColors.whiteColor
                            // )
                            style: FontStyleUtilities.s14(
                                fontColor: ApplicationColors.black4240,),),
                        Container(
                          height: height * .46,
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            onPageChanged: _onchanged,
                            controller: _controller,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: height * 0.4,
                                    width: width,
                                    child: SfCircularChart(
                                        //legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap ),

                                        annotations: <CircularChartAnnotation>[
                                          CircularChartAnnotation(
                                              angle: 10,
                                              height: '90%',
                                              width: '90%',
                                              radius: '0%',
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${homeProvider.vehicleStatusModel.data.totalVech}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 60,
                                                      fontFamily: "Arial",
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xffbb002d),
                                                      //color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                        series: <CircularSeries>[
                                          DoughnutSeries<ChartData, String>(
                                            dataLabelSettings: DataLabelSettings(
                                              isVisible: true,
                                            ),
                                            dataSource: homeProvider.chartData,
                                            animationDuration: 1000,
                                            // maximumValue: 100,
                                            strokeWidth: 10,
                                            //trackColor: ApplicationColors.textfieldBorderColor,
                                            radius: '90%',
                                            // gap: '10%',
                                            xValueMapper: (ChartData data, _) =>
                                                data.x,
                                            yValueMapper: (ChartData data, _) =>
                                                data.y.toInt(),
                                            pointColorMapper:
                                                (ChartData data, index) =>
                                                    data.color,
                                            // Radius of the radial bar
                                            innerRadius: '65%',
                                            legendIconType: LegendIconType.circle,
                                            onPointTap:
                                                (pointInteractionDetails) async {
                                              SharedPreferences prefes =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefes.setInt(
                                                  'data',
                                                  pointInteractionDetails
                                                      .pointIndex);
                                              print(
                                                  "point tap is:${pointInteractionDetails.pointIndex}");
                                              _userSettingsProvider
                                                  .navigateToThirdScreen();
                                              // Navigator.push(context, MaterialPageRoute(builder: (context) => Vehicle_list(),));
                                            },
                                          )
                                        ]),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          //_userSettingsProvider.navigateToThirdScreen('RUNNING',2,context);
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Vehicle_list(status: 'RUNNING',selecttype: 2),));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.circle,
                                                size: 16,
                                                color: ApplicationColors
                                                    .greenColor370),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${getTranslated(context, "running")}',
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,

                                              ///ApplicationColors.whiteColo
                                              style: FontStyleUtilities.h12(
                                                  fontColor: Color(0xffbb002d)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          //_userSettingsProvider.navigateToThirdScreen('IDLING',3,context);
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Vehicle_list(status: 'IDLING',selecttype: 3),));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.circle,
                                                size: 16,
                                                color: ApplicationColors
                                                    .yellowColorD21),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${getTranslated(context, "idling")}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: FontStyleUtilities.h12(
                                                fontColor: Color(0xffbb002d),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          // _userSettingsProvider.navigateToThirdScreen('STOPPED',4,context);
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Vehicle_list(status: 'STOPPED',selecttype: 4,),));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.circle,
                                                size: 16,
                                                color: ApplicationColors
                                                    .lightredColorA67),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${getTranslated(context, "stopped")}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: FontStyleUtilities.h12(
                                                  fontColor: Color(0xffbb002d)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // _userSettingsProvider.navigateToThirdScreen('OUT OF REACH',5,context);
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => Vehicle_list(status: 'OUT OF REACH',selecttype: 5,),));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.circle,
                                                size: 16,
                                                color:
                                                    ApplicationColors.blueColorCE),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${getTranslated(context, "out_of_reach")}',
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: FontStyleUtilities.h12(
                                                  fontColor: Color(0xffbb002d)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          //_userSettingsProvider.navigateToThirdScreen('Expired',6,context);
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Vehicle_list(status: 'Expired',selecttype: 6,),));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.circle,
                                                size: 16,
                                                color: ApplicationColors
                                                    .orangeColor3E),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${getTranslated(context, "Expired")}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: FontStyleUtilities.h12(
                                                  fontColor: Color(0xffbb002d)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          //_userSettingsProvider.navigateToThirdScreen('NO DATA',7,context);
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => Vehicle_list(status: 'NO DATA',selecttype: 7,),));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.circle,
                                                size: 16,
                                                color: ApplicationColors
                                                    .radiusColorFB),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${getTranslated(context, "no_GPS_fix")}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: FontStyleUtilities.h12(
                                                  fontColor: Color(0xffbb002d)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              homeProvider.isVehicleExpenseLoading
                                  ? Helper.dialogCall.showLoader()
                                  : SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 14, left: 14, top: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${getTranslated(context, "today_fuel_rate")}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: FontStyleUtilities.h14(
                                                fontColor: ApplicationColors
                                                    .blackbackcolor,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButtonFormField(
                                                  iconEnabledColor:
                                                      ApplicationColors.redColor67,
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "${getTranslated(context, "Gujarat")}",
                                                    labelStyle:
                                                        FontStyleUtilities.h14(
                                                            fontColor:
                                                                ApplicationColors
                                                                    .blackColor00),
                                                    hintStyle:
                                                        FontStyleUtilities.h14(
                                                            fontColor:
                                                                ApplicationColors
                                                                    .blackColor00,
                                                            fontFamily: 'Arial'),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: ApplicationColors
                                                              .blackColor00),
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: ApplicationColors
                                                              .blackColor00
                                                              .withOpacity(0.25)),
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  dropdownColor: ApplicationColors
                                                      .blackColor2E,
                                                  // validator: (value){
                                                  //   if(value==null){
                                                  //     return 'Please select';
                                                  //   }
                                                  // },
                                                  value: homeProvider.chooseState,
                                                  onChanged: (value) {
                                                    homeProvider.chooseState =
                                                        value;
                                                    getfuelPriceList(value);
                                                  },
                                                  items: [
                                                    "${getTranslated(context, "Gujarat")}",
                                                    "${getTranslated(context, "Andaman_and_Nicobar")}",
                                                    "${getTranslated(context, "Andhra_Pradesh")}",
                                                    "${getTranslated(context, "Arunachal_Pradesh")}",
                                                    "${getTranslated(context, "Assam")}",
                                                    "${getTranslated(context, "Chandigarh")}",
                                                    "${getTranslated(context, "Chhattisgarh")}",
                                                    "${getTranslated(context, "Bihar")}",
                                                    "${getTranslated(context, "Delhi")}",
                                                    "${getTranslated(context, "Goa")}",
                                                    "${getTranslated(context, "Haryana")}",
                                                    "${getTranslated(context, "Himachal_Pradesh")}",
                                                    "${getTranslated(context, "Jammu_and_Kashmir")}",
                                                    "${getTranslated(context, "Jharkhand")}",
                                                    "${getTranslated(context, "Karnataka")}",
                                                    "${getTranslated(context, "Lakshadweep")}",
                                                    "${getTranslated(context, "Kerala")}",
                                                    "${getTranslated(context, "Madhya_Pradesh")}",
                                                    "${getTranslated(context, "Maharastra")}",
                                                    "${getTranslated(context, "Banglore")}",
                                                    "${getTranslated(context, "Manipur")}",
                                                    "${getTranslated(context, "Meghalaya")}",
                                                    "${getTranslated(context, "Nagaland")}",
                                                    "${getTranslated(context, "Orissa")}",
                                                    "${getTranslated(context, "Mizoram")}",
                                                    "${getTranslated(context, "Puducherry")}",
                                                    "${getTranslated(context, "Punjab")}",
                                                    "${getTranslated(context, "Rajasthan")}",
                                                    "${getTranslated(context, "Sikkim")}",
                                                    "${getTranslated(context, "Tamil_Nadu")}",
                                                    "${getTranslated(context, "Telangana")}",
                                                    "${getTranslated(context, "Tripura")}",
                                                    "${getTranslated(context, "Uttar_Pradesh")}",
                                                    "${getTranslated(context, "Uttarakhand")}",
                                                    "${getTranslated(context, "West_Bengal")}",
                                                    "${getTranslated(context, "Pune")}",
                                                    "${getTranslated(context, "Chennai")}",
                                                  ]
                                                      .map((String value) =>
                                                          DropdownMenuItem(
                                                            child: Text(
                                                              value,
                                                              style: FontStyleUtilities.h14(
                                                                  fontColor:
                                                                      ApplicationColors
                                                                          .blackColor00,
                                                                  fontFamily:
                                                                      'Arial'),
                                                            ),
                                                            value: value,
                                                          ))
                                                      .toList()),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${getTranslated(context, "Diesel")}",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 26,
                                                        fontFamily: "Arial",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black,
                                                        //color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      homeProvider.getFuelPriceList
                                                                  .length ==
                                                              0
                                                          ? "₹ 0"
                                                          : "₹ ${homeProvider.getFuelPriceList[0].diesel}",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 30,
                                                        fontFamily: "Arial",
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        //color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${getTranslated(context, "petrol")}",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 26,
                                                        fontFamily: "Arial",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black,
                                                        //color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      homeProvider.getFuelPriceList
                                                                  .length ==
                                                              0
                                                          ? "₹ 0"
                                                          : "₹ ${homeProvider.getFuelPriceList[0].petrol}",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 30,
                                                        fontFamily: "Arial",
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        //color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 14),
                                            Text(
                                              '${getTranslated(context, "today_vehicle_expens")}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: FontStyleUtilities.s14(
                                                  fontColor:
                                                      ApplicationColors.redColor67),
                                            ),
                                            GridView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: homeProvider
                                                  .vehicleExpenseList.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      childAspectRatio: 1.75 / 2,
                                                      crossAxisSpacing: 15,
                                                      mainAxisSpacing: 10),
                                              itemBuilder: (context, index) {
                                                var vehicleExpenseList =
                                                    homeProvider
                                                        .vehicleExpenseList[index];
                                                return homeProvider
                                                        .isVehicleExpenseLoading
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: ApplicationColors
                                                              .whiteColor,
                                                          backgroundColor:
                                                              ApplicationColors
                                                                  .redColor67,
                                                        ),
                                                      )
                                                    : Container(
                                                        padding: EdgeInsets.only(
                                                            left: 9,
                                                            top: 9,
                                                            right: 9),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(height: 5),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(5),
                                                                  height: 25,
                                                                  width: 25,
                                                                  child: Center(
                                                                      child: vehicleExpenseList
                                                                                  .id
                                                                                  .toLowerCase() ==
                                                                              "fuel"
                                                                          ? listOfHomeVehicleExpense[
                                                                                  0]
                                                                              [
                                                                              'image']
                                                                          : vehicleExpenseList.id.toLowerCase() ==
                                                                                  "tools"
                                                                              ? listOfHomeVehicleExpense[1]
                                                                                  [
                                                                                  'image']
                                                                              : vehicleExpenseList.id.toLowerCase() == "salary"
                                                                                  ? listOfHomeVehicleExpense[2]['image']
                                                                                  : vehicleExpenseList.id.toLowerCase() == "petta"
                                                                                      ? listOfHomeVehicleExpense[3]['image']
                                                                                      : vehicleExpenseList.id.toLowerCase() == "food"
                                                                                          ? listOfHomeVehicleExpense[5]['image']
                                                                                          : vehicleExpenseList.id.toLowerCase() == "toll"
                                                                                              ? listOfHomeVehicleExpense[6]['image']
                                                                                              : vehicleExpenseList.id.toLowerCase() == "service"
                                                                                                  ? listOfHomeVehicleExpense[4]['image']
                                                                                                  : vehicleExpenseList.id.toLowerCase() == "labor"
                                                                                                      ? listOfHomeVehicleExpense[7]['image']
                                                                                                      : vehicleExpenseList.id.toLowerCase() == "others"
                                                                                                          ? listOfHomeVehicleExpense[8]['image']
                                                                                                          : listOfHomeVehicleExpense[8]['image']),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: vehicleExpenseList
                                                                                .id
                                                                                .toLowerCase() ==
                                                                            "fuel"
                                                                        ? listOfHomeVehicleExpense[
                                                                                0][
                                                                            'color']
                                                                        : vehicleExpenseList.id.toLowerCase() ==
                                                                                "tools"
                                                                            ? listOfHomeVehicleExpense[1]
                                                                                [
                                                                                'color']
                                                                            : vehicleExpenseList.id.toLowerCase() ==
                                                                                    "salary"
                                                                                ? listOfHomeVehicleExpense[2]['color']
                                                                                : vehicleExpenseList.id.toLowerCase() == "petta"
                                                                                    ? listOfHomeVehicleExpense[3]['color']
                                                                                    : vehicleExpenseList.id.toLowerCase() == "food"
                                                                                        ? listOfHomeVehicleExpense[5]['color']
                                                                                        : vehicleExpenseList.id.toLowerCase() == "toll"
                                                                                            ? listOfHomeVehicleExpense[6]['color']
                                                                                            : vehicleExpenseList.id.toLowerCase() == "service"
                                                                                                ? listOfHomeVehicleExpense[4]['color']
                                                                                                : vehicleExpenseList.id.toLowerCase() == "labor"
                                                                                                    ? listOfHomeVehicleExpense[7]['color']
                                                                                                    : vehicleExpenseList.id.toLowerCase() == "others"
                                                                                                        ? listOfHomeVehicleExpense[8]['color']
                                                                                                        : listOfHomeVehicleExpense[8]['color'],
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                25),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: ApplicationColors
                                                                            .whiteColor,
                                                                        offset:
                                                                            Offset(
                                                                          5.0,
                                                                          5.0,
                                                                        ),
                                                                        blurRadius:
                                                                            10.0,
                                                                        spreadRadius:
                                                                            -8,
                                                                      ), //BoxShadow
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(width: 9),
                                                                Flexible(
                                                                  child: Text(
                                                                    vehicleExpenseList
                                                                        .id
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: FontStyleUtilities.h12(
                                                                        fontFamily:
                                                                            "Poppins-Regular",
                                                                        fontColor:
                                                                            ApplicationColors
                                                                                .black4240),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 6),
                                                            Flexible(
                                                              child: Text(
                                                                vehicleExpenseList
                                                                    .amount
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: FontStyleUtilities.h18(
                                                                    fontColor:
                                                                        ApplicationColors
                                                                            .black4240),
                                                              ),
                                                            ),
                                                            SizedBox(height: 6),
                                                            Flexible(
                                                              child: Text(
                                                                "${getTranslated(context, "total_generate")}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: FontStyleUtilities.h12(
                                                                    fontColor:
                                                                        ApplicationColors
                                                                            .black4240),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                          color: serviceOfIndex ==
                                                                  index
                                                              ? ApplicationColors
                                                                  .greyC4C4
                                                                  .withOpacity(0.4)
                                                              : ApplicationColors
                                                                  .greyC4C4
                                                                  .withOpacity(0.4),
                                                        ),
                                                      );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List<Widget>.generate(
                            2,
                            (int index) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: 8,
                                width: 8,
                                margin: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == _currentPage
                                      ? ApplicationColors.redColor67
                                      : ApplicationColors.textfieldBorderColor,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LiveTrackingScreenCopy(),
                                        // LiveForVehicleScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: height * .150,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Color(0xfff90c42),
                                        ),
                                        bottom: BorderSide(
                                          color: Color(0xfff90c42),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/location.png",
                                          color: Color(0xfff90c42),
                                          height: 40,
                                          width: 40,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "LIVE TRACKING",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    userProvider.changeBottomIndex(2);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: height * .150,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xfff90c42),
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/car_icon.png",
                                          color: Color(0xfff90c42),
                                          height: 40,
                                          width: 40,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "VEHICLES",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HistoryPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: height * .150,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Color(0xfff90c42),
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/History_icon.png",
                                          color: Color(0xfff90c42),
                                          height: 40,
                                          width: 40,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "HISTORY",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Geofences(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: height * .150,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/geofences_icon.png",
                                          color: Color(0xfff90c42),
                                          height: 40,
                                          width: 40,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "GEOFENCE",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
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
                color: ApplicationColors.redColor67,
                borderRadius: BorderRadius.circular(41)),
          ),
          // SizedBox(height: 20, width: 20, child: Image.asset(iconPath)),
          SizedBox(
            width: width * 0.07,
          ),
          Text(
            name,
            style: FontStyleUtilities.s14(
                fontColor: ApplicationColors.whiteColor,
                fontFamily: "Poppins-Regular"),
          )
        ],
      ),
    );
  }
}

List listOfHomeVehicleExpense = [
  {
    'name': 'Fuel',
    'color': ApplicationColors.greenColor370,
    'price': '1500',
    'total': 'Total Generate',
    'image': Image.asset("assets/images/fuel_icon.png")
  },
  {
    'name': 'Tools',
    'color': ApplicationColors.yellowColorD21,
    'price': '200',
    'total': 'Total Generate',
    'image': Image.asset("assets/images/tools_icon.png")
  },
  {
    'name': 'Salary',
    'color': ApplicationColors.blueColorCE,
    'price': '556',
    'total': 'Total Generate',
    'image': Image.asset("assets/images/money_icon.png")
  },
  {
    'name': 'Petta',
    'color': ApplicationColors.orangeColor3E,
    'price': '160',
    'total': 'Total Generate',
    'image': Image.asset("assets/images/protection_icon.png")
  },
  {
    'name': 'Service',
    'color': ApplicationColors.radiusColorFB,
    'price': '300',
    'total': 'Total Generate',
    'image': Image.asset("assets/images/service_icon.png")
  },
  {
    'name': 'Food',
    'color': ApplicationColors.pinkColorC3,
    'price': '200',
    'total': 'Total Generate',
    'image': Image.asset("assets/images/food_icon.png")
  },
  {
    'name': 'Toll',
    'color': ApplicationColors.darkredColor1E,
    'price': '55',
    'total': 'Total Generate',
    'image': Image.asset("assets/images/toll_icon.png")
  },
  {
    'name': 'Labor',
    'color': ApplicationColors.darkgreyColor1E,
    'price': '550',
    'total': 'Total Generate',
    'image': Image.asset("assets/images/labor_icon.png")
  },
  {
    'name': 'Others',
    'color': ApplicationColors.redColor67,
    'price': '320',
    'total': 'Total Generate',
    'image': Image.asset("assets/images/other_icon.png")
  },
];
