import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/socket_model.dart';
import 'package:oneqlik/Model/vehicle_list_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:oneqlik/Provider/vehicle_list_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class LiveForVehicleScreenTwo extends StatefulWidget {
  final vDeviceId, vId;

  VehicleLisDevice vehicleLisDevice;

  LiveForVehicleScreenTwo(
      {Key key, this.vDeviceId, this.vehicleLisDevice, this.vId})
      : super(key: key);

  @override
  _LiveForVehicleScreenTwoState createState() =>
      _LiveForVehicleScreenTwoState();
}

class _LiveForVehicleScreenTwoState extends State<LiveForVehicleScreenTwo> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  UserProvider _userProvider;
  bool selectDate = true;
  bool isSnappingOpen = false;
  final ScrollController listViewController = new ScrollController();

  VehicleListProvider vehicleListProvider;
  ReportProvider _reportProvider;

  double convertFuel(double distance, String milege) {
    double mil = double.parse(milege);
    double ans = distance / mil;
    return ans;
  }

  getStoppageLogs() async {
    var data = {
      "date": formattedDate.toString(),
      "device": widget.vId,
    };

    print('StoppageLogs-->$data');

    await vehicleListProvider.getStoppageLogs(
        data, "user_trip/StoppageLogs", context);
  }

  SocketModelClass socketModelClass;
  bool isLoading = true;

  IO.Socket socket;

  connectSocketIo() {
    socket = IO.io('https://www.oneqlik.in/gps', <String, dynamic>{
      "secure": true,
      "rejectUnauthorized": false,
      "transports": ["websocket", "polling"],
      "upgrade": false
    });
    socket.connect();

    socket.onConnect((data) {
      // print("Socket is connected");

      socket.emit("acc", "${widget.vDeviceId}");

      socket.on("${widget.vDeviceId}acc", (data) async {
        // print("socket data ===> ${data[3]}");
        if (data[3] != null) {
          var resonance = data[3];

          socketModelClass = SocketModelClass.fromJson(resonance);
          setState(() {
            isLoading = false;
          });

          print("temp value ${socketModelClass.temp}");
          if (socketModelClass.lastLocation != null) {
            getAddress(socketModelClass.lastLocation.lat,
                socketModelClass.lastLocation.long);
          }
        }
      });
    });
  }

  var address = "Address not found";

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      lat,
      long,
    );

    address = "${placemarks.first.name}"
        " ${placemarks.first.subLocality}"
        " ${placemarks.first.locality}"
        " ${placemarks.first.subAdministrativeArea} "
        "${placemarks.first.administrativeArea},"
        "${placemarks.first.postalCode}";
  }

  dailyReportList({String fromDay, String toDay}) async {
    DateTime now = DateTime.now(); // get the current date and time
    DateTime dateAtMidnight =
        DateTime(now.year, now.month, now.day); // set the time to 12:00 am

    /* var fromDate = dateAtMidnight.toUtc().toString();
    // fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
    var toDate = DateTime.now().toUtc().toString();*/

    ///today to tomorrow time;
    var fromDate = dateAtMidnight.toUtc().toString();
    //     // fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
    var toDate = DateTime(now.year, now.month, now.day)
        .add(Duration(days: 1))
        .toUtc()
        .toString();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (fromDay != null) {
      fromDate = fromDay;
      toDate = toDay;
    }
    var id = sharedPreferences.getString("uid");
    var data = {
      "from": fromDate,
      "to": toDate,
      "user": id,
      "device": widget.vehicleLisDevice.deviceId,
    };

    /* var data = {
      "user":id,
      "date":DateTime.now().toString(),
      "device":widget.vehicleLisDevice.deviceId,
    };*/

    print(data);

    // _reportProvider.dailyReportList(data, "devices/dailyReport");
    _reportProvider.dailyReportList(data, "summary/summaryReport");
    // _reportProvider.getDayWiseReports(data, "summary/getDayWiseReport");
  }

  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toUtc().toString();

  @override
  void initState() {
    super.initState();
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    vehicleListProvider =
        Provider.of<VehicleListProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      getStoppageLogs();
      connectSocketIo();
      getAddress(widget.vehicleLisDevice.lastLocation.lat,
          widget.vehicleLisDevice.lastLocation.long);
      dailyReportList();
    });
    //print("data is----${_reportProvider.getDailyReportList[0].tIdling}");
    /* print('${((_reportProvider.getDailyReportList[0].tIdling / (1000*60*60)) % 24).round()} h ${((_reportProvider.getDailyReportList[0].tIdling / (1000 * 60)) % 60).round()} m',
    );*/
  }

  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    vehicleListProvider =
        Provider.of<VehicleListProvider>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: ApplicationColors.whiteColorF9
              /*color: ApplicationColors.whiteColorF9*/
              ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: width,
              // height: height - 88,
              child: SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/key.png",
                                    width: 20,
                                    color:
                                        //  isLoading
                                        // ?
                                        widget.vehicleLisDevice
                                                    .ignitionSource ==
                                                null
                                            ? ApplicationColors.greyC4C4
                                            : widget.vehicleLisDevice.lastAcc ==
                                                    "0"
                                                ? ApplicationColors.redColor67
                                                : ApplicationColors.greenColor
                                    //  :
                                    //  socketModelClass.lastAcc == "" ? ApplicationColors.greyC4C4 : socketModelClass.lastAcc == "0" ? ApplicationColors.redColor67 :ApplicationColors.greenColor,
                                    ),
                                SizedBox(height: 6),
                                Text(
                                  "${getTranslated(context, "key")}",
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Textstyle1.text12b.copyWith(fontSize: 10),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/freezer.png",
                                  width: 20,
                                  color: isLoading
                                      ? widget.vehicleLisDevice.ac == null
                                          ? ApplicationColors.greyC4C4
                                          : widget.vehicleLisDevice.ac == "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor
                                      : socketModelClass.ac == null
                                          ? ApplicationColors.greyC4C4
                                          : socketModelClass.ac == "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "${getTranslated(context, "ac")}",
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Textstyle1.text12b.copyWith(fontSize: 10),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_gas_station,
                                  color: isLoading
                                      ? widget.vehicleLisDevice.fuelPercent ==
                                              null
                                          ? ApplicationColors.greyC4C4
                                          : widget.vehicleLisDevice
                                                      .fuelPercent ==
                                                  "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor
                                      : socketModelClass.fuelPercent == null
                                          ? ApplicationColors.greyC4C4
                                          : socketModelClass.fuelPercent == "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor,
                                  size: 22,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Fuel",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Textstyle1.text12b.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/power.png",
                                  width: 20,
                                  color: isLoading
                                      ? widget.vehicleLisDevice.power == null
                                          ? ApplicationColors.greyC4C4
                                          : widget.vehicleLisDevice.power == "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor
                                      : socketModelClass.power == ""
                                          ? ApplicationColors.greyC4C4
                                          : socketModelClass.power == "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "${getTranslated(context, "power")}",
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Textstyle1.text12b.copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/satellite.png",
                                  width: 20,
                                  color: isLoading
                                      ? widget.vehicleLisDevice.satellites ==
                                              null
                                          ? ApplicationColors.greyC4C4
                                          : widget.vehicleLisDevice
                                                      .gpsTracking ==
                                                  "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor
                                      : socketModelClass.gpsTracking == ""
                                          ? ApplicationColors.greyC4C4
                                          : socketModelClass.gpsTracking == "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "${getTranslated(context, "gps")}",
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Textstyle1.text12b.copyWith(fontSize: 10),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/Door_icon.png",
                                  width: 20,
                                  color: isLoading
                                      ? widget.vehicleLisDevice.door == null
                                          ? ApplicationColors.greyC4C4
                                          : widget.vehicleLisDevice.door == "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor
                                      : socketModelClass.door == ""
                                          ? ApplicationColors.greyC4C4
                                          : socketModelClass.door == "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${getTranslated(context, "Door")}",
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Textstyle1.text12b.copyWith(fontSize: 10),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/secured-lock.png",
                                  width: 20,
                                  color: isLoading
                                      ? widget.vehicleLisDevice.ignitionLock ==
                                              null
                                          ? ApplicationColors.greyC4C4
                                          : widget.vehicleLisDevice
                                                      .ignitionLock ==
                                                  "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor
                                      : socketModelClass.ignitionLock == null
                                          ? ApplicationColors.greyC4C4
                                          : socketModelClass.ignitionLock == "0"
                                              ? ApplicationColors.redColor67
                                              : ApplicationColors.greenColor,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "${getTranslated(context, "lock")}",
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Textstyle1.text12b.copyWith(fontSize: 10),
                                )
                              ],
                            ),
                          ]),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "${widget.vehicleLisDevice.totalOdo.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text("Odometer"),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    isLoading
                                        ? widget.vehicleLisDevice.lastSpeed ==
                                                null
                                            ? "0"
                                            : "${widget.vehicleLisDevice.lastSpeed}"
                                        : '${socketModelClass.lastSpeed}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    " ${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "${getTranslated(context, "km_h")}" : "${getTranslated(context, "Miles_H")}"}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text("Speed"),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "${widget.vehicleLisDevice.currentFuel == null ? "N/A" : "${widget.vehicleLisDevice.currentFuel}"}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text("Fuel"),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "${widget.vehicleLisDevice.currentFuelVoltage == null ? "N/A" : widget.vehicleLisDevice.currentFuelVoltage}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text("Voltage"),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "${widget.vehicleLisDevice.temp.isEmpty ? "N/A" : widget.vehicleLisDevice.temp}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text("Temp"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    TableCalendar(
                      firstDay: DateTime(DateTime.now().year,
                          DateTime.now().month - 12, DateTime.now().day),
                      lastDay: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      daysOfWeekVisible: false,
                      headerVisible: false,
                      calendarStyle: CalendarStyle(
                        cellMargin:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        todayDecoration: BoxDecoration(
                          color: selectDate != true
                              ? Colors.transparent
                              : ApplicationColors.textfieldBorderColor,
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color(0xffd21938),
                              Color(0xff751c1e),
                            ],
                          ),
                        ),
                        selectedTextStyle: TextStyle(
                            fontFamily: 'NotoSans-regular',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: ApplicationColors.whiteColor),
                        selectedDecoration: BoxDecoration(
                          color: ApplicationColors.textfieldBorderColor,
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color(0xffd21938),
                              Color(0xff751c1e),
                            ],
                          ),
                        ),
                        todayTextStyle: TextStyle(
                          fontFamily: 'NotoSans-regular',
                          fontWeight: selectDate == true
                              ? FontWeight.w700
                              : FontWeight.normal,
                          fontSize: 16,
                          color: selectDate == true
                              ? ApplicationColors.whiteColor
                              : ApplicationColors.black4240,
                        ),
                        outsideDecoration: BoxDecoration(
                          color: ApplicationColors.whiteColor,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        defaultDecoration: BoxDecoration(
                          color: ApplicationColors.whiteColor,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        weekendDecoration: BoxDecoration(
                          color: ApplicationColors.whiteColor,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        outsideTextStyle: TextStyle(
                            fontFamily: 'NotoSans-regular',
                            fontSize: 16,
                            color: ApplicationColors.black4240),
                        holidayDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        disabledTextStyle: TextStyle(
                            fontFamily: 'NotoSans-regular',
                            fontSize: 16,
                            color: ApplicationColors.black4240),
                        weekendTextStyle: TextStyle(
                            fontFamily: 'NotoSans-regular',
                            fontSize: 16,
                            color: ApplicationColors.black4240),
                        defaultTextStyle: TextStyle(
                            fontFamily: 'NotoSans-regular',
                            fontSize: 16,
                            color: ApplicationColors.black4240),
                      ),
                      daysOfWeekHeight: 20,
                      daysOfWeekStyle: DaysOfWeekStyle(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        weekdayStyle: TextStyle(
                            fontFamily: 'NotoSans-regular',
                            fontSize: 14,
                            color: ApplicationColors.black4240),
                        weekendStyle: TextStyle(
                          fontFamily: 'NotoSans-regular',
                          fontSize: 14,
                          color: ApplicationColors.black4240,
                        ),
                      ),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      // headerStyle: HeaderStyle(
                      //   formatButtonVisible: false,
                      //   titleTextStyle: TextStyle(
                      //     color: ApplicationColors.transparentColors,
                      //   ),
                      //   headerMargin: EdgeInsets.symmetric(horizontal: 40),
                      //   headerPadding: EdgeInsets.zero,
                      // rightChevronMargin: EdgeInsets.only(right: 100),
                      // rightChevronPadding: EdgeInsets.only(right: 70),
                      // leftChevronPadding:EdgeInsets.only(left: 70),
                      // leftChevronMargin:EdgeInsets.only(left: 10),
                      // titleCentered: true,
                      // leftChevronIcon: Icon(
                      //   Icons.arrow_back_ios,
                      //   color: ApplicationColors.transparentColors,
                      // ),
                      // rightChevronIcon: Icon(
                      //   Icons.arrow_forward_ios,
                      //   color: ApplicationColors.transparentColors,
                      // ),
                      // ),
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          DateTime fromDateTime = DateTime(
                            selectedDay.year,
                            selectedDay.month,
                            selectedDay.day,
                            18,
                            // hour
                            30,
                            // minute
                            0,
                            // second
                            0, // millisecond
                          );
                          DateTime toDay = fromDateTime.add(Duration(days: 1));
                          setState(() {
                            selectDate = false;
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            formattedDate =
                                DateFormat('yyyy-MM-dd').format(_selectedDay);
                          });
                          getStoppageLogs();
                          dailyReportList(
                              fromDay: "${fromDateTime.toString()}Z",
                              toDay: "${toDay.toString()}Z");
                        }
                      },
                      onPageChanged: (focusedDay) {
                        // No need to call `setState()` here
                        _focusedDay = focusedDay;
                      },
                    ),
                    SizedBox(height: 12),
                    _reportProvider.isDailyReportListLoading
                        ? Helper.dialogCall.showLoader()
                        : _reportProvider.getDailyReportList.isEmpty
                            ? SizedBox(
                                child: Center(
                                  child: Text(
                                    "${getTranslated(context, "data_not")}",
                                    style: Textstyle1.text14bold,
                                  ),
                                ),
                              )
                            : Container(
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/car_time.png",
                                      width: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "${_reportProvider.getDailyReportList[0].todayRunning == null ? "00:00:00" : "${formatMilliseconds(_reportProvider.getDailyReportList[0].todayRunning)}"}",
                                      style: TextStyle(
                                          color: Appcolors.appbarcolor),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 12,
                                      width: 1,
                                      color: ApplicationColors.whiteColor,
                                    ),
                                    Spacer(),
                                    Image.asset(
                                      "assets/images/Union.png",
                                      width: 20,
                                      color: ApplicationColors.whiteColor,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "${_reportProvider.getDailyReportList[0].todayOdo == null ? "0.0 kms" : _reportProvider.getDailyReportList[0].todayOdo}",
                                      style: TextStyle(
                                          color: Appcolors.appbarcolor),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 12,
                                      width: 1,
                                      color: ApplicationColors.whiteColor,
                                    ),
                                    Spacer(),
                                    Image.asset(
                                      "assets/images/parking_icon.png",
                                      width: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "${_reportProvider.getDailyReportList[0].todayStopped == null ? "00:00:00" : "${formatMilliseconds(_reportProvider.getDailyReportList[0].todayStopped)}"}",
                                      style: TextStyle(
                                          color: Appcolors.appbarcolor),
                                    ),
                                  ],
                                ),
                              ),
                    // Container(
                    //             height: 150,
                    //             child:
                    //
                    //                 ///gridview 7 item
                    //                 GridView(
                    //               shrinkWrap: true,
                    //               scrollDirection: Axis.horizontal,
                    //               gridDelegate:
                    //                   SliverGridDelegateWithFixedCrossAxisCount(
                    //                 crossAxisCount: 2,
                    //                 crossAxisSpacing: 10,
                    //                 childAspectRatio: 16 / 20,
                    //                 mainAxisSpacing: 2,
                    //               ),
                    //               children: [
                    //                 Container(
                    //                   margin:
                    //                       EdgeInsets.symmetric(horizontal: 7),
                    //                   width: width * 0.2,
                    //                   padding: EdgeInsets.symmetric(
                    //                       vertical: 5, horizontal: 10),
                    //                   decoration: Boxdec.conrad6colorgrey
                    //                       .copyWith(
                    //                           color: ApplicationColors
                    //                               .blackColor2E),
                    //                   child: Center(
                    //                     child: Column(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Image.asset(
                    //                           "assets/images/geometer_ic.png",
                    //                           width: 24,
                    //                           height: 17,
                    //                           color:
                    //                               ApplicationColors.redColor67,
                    //                         ),
                    //                         SizedBox(height: 2),
                    //                         Text(
                    //                           "${getTranslated(context, "Odometer")}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text14bold
                    //                               .copyWith(fontSize: 10),
                    //                         ),
                    //                         SizedBox(height: 1),
                    //                         Text(
                    //                           "${_reportProvider.getDailyReportList[0].totalOdo.toStringAsFixed(2)}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text12b
                    //                               .copyWith(fontSize: 10),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   margin:
                    //                       EdgeInsets.symmetric(horizontal: 7),
                    //                   width: width * 0.2,
                    //                   padding: EdgeInsets.symmetric(
                    //                       vertical: 5, horizontal: 10),
                    //                   decoration: Boxdec.conrad6colorgrey
                    //                       .copyWith(
                    //                           color: ApplicationColors
                    //                               .blackColor2E),
                    //                   child: Center(
                    //                     child: Column(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Image.asset(
                    //                           "assets/images/spped_meter.png",
                    //                           width: 24,
                    //                           height: 17,
                    //                           color:
                    //                               ApplicationColors.redColor67,
                    //                         ),
                    //                         SizedBox(height: 2),
                    //                         Text(
                    //                           "${getTranslated(context, "avg_speed")}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text14bold
                    //                               .copyWith(fontSize: 10),
                    //                         ),
                    //                         SizedBox(height: 1),
                    //                         Text(
                    //                           "${_reportProvider.getDailyReportList[0].avgSpeed.toStringAsFixed(2)}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text12b
                    //                               .copyWith(fontSize: 10),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   margin:
                    //                       EdgeInsets.symmetric(horizontal: 7),
                    //                   width: width * 0.2,
                    //                   padding: EdgeInsets.symmetric(
                    //                       vertical: 5, horizontal: 10),
                    //                   decoration: Boxdec.conrad6colorgrey
                    //                       .copyWith(
                    //                           color: ApplicationColors
                    //                               .blackColor2E),
                    //                   child: Center(
                    //                     child: Column(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Image.asset(
                    //                           "assets/images/vehicle_page_icon2.png",
                    //                           width: 24,
                    //                           height: 17,
                    //                           color:
                    //                               ApplicationColors.redColor67,
                    //                         ),
                    //                         SizedBox(height: 3),
                    //                         Text(
                    //                           "${getTranslated(context, "max_speed")}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text14bold
                    //                               .copyWith(fontSize: 10),
                    //                         ),
                    //                         SizedBox(height: 1),
                    //                         Text(
                    //                           _reportProvider
                    //                                       .getDailyReportList[0]
                    //                                       .maxSpeed ==
                    //                                   null
                    //                               ? "0 ${getTranslated(context, "km_hr")}"
                    //                               : "${_reportProvider.getDailyReportList[0].maxSpeed} ${getTranslated(context, "km_hr")}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text12b
                    //                               .copyWith(fontSize: 10),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   margin:
                    //                       EdgeInsets.symmetric(horizontal: 7),
                    //                   width: width * 0.2,
                    //                   padding: EdgeInsets.symmetric(
                    //                       vertical: 5, horizontal: 10),
                    //                   decoration: Boxdec.conrad6colorgrey
                    //                       .copyWith(
                    //                           color: ApplicationColors
                    //                               .blackColor2E),
                    //                   child: Center(
                    //                     child: Column(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Image.asset(
                    //                           "assets/images/Union.png",
                    //                           width: 24,
                    //                           height: 17,
                    //                           color:
                    //                               ApplicationColors.redColor67,
                    //                         ),
                    //                         SizedBox(height: 3),
                    //                         Text(
                    //                           "${getTranslated(context, "Mileage")}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text14bold
                    //                               .copyWith(fontSize: 10),
                    //                         ),
                    //                         SizedBox(height: 1),
                    //                         Text(
                    //                           "${_reportProvider.getDailyReportList[0].devObj.Mileage} Km/ltr",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text12b
                    //                               .copyWith(fontSize: 10),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   margin:
                    //                       EdgeInsets.symmetric(horizontal: 7),
                    //                   width: width * 0.2,
                    //                   padding: EdgeInsets.symmetric(
                    //                       vertical: 5, horizontal: 10),
                    //                   decoration: Boxdec.conrad6colorgrey
                    //                       .copyWith(
                    //                           color: ApplicationColors
                    //                               .blackColor2E),
                    //                   child: Center(
                    //                     child: Column(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Image.asset(
                    //                           "assets/images/car_time.png",
                    //                           width: 24,
                    //                           height: 17,
                    //                           color:
                    //                               ApplicationColors.redColor67,
                    //                         ),
                    //                         SizedBox(height: 3),
                    //                         Text(
                    //                           "${getTranslated(context, "moving_time")}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text14bold
                    //                               .copyWith(fontSize: 10),
                    //                         ),
                    //                         SizedBox(height: 1),
                    //                         Text(
                    //                           _reportProvider
                    //                                       .getDailyReportList[0]
                    //                                       .todayRunning ==
                    //                                   null
                    //                               ? "00:00:00"
                    //                               : formatMilliseconds(
                    //                                   _reportProvider
                    //                                       .getDailyReportList[0]
                    //                                       .todayRunning),
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text12b
                    //                               .copyWith(fontSize: 10),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   margin:
                    //                       EdgeInsets.symmetric(horizontal: 7),
                    //                   width: width * 0.2,
                    //                   padding: EdgeInsets.symmetric(
                    //                       vertical: 5, horizontal: 10),
                    //                   decoration: Boxdec.conrad6colorgrey
                    //                       .copyWith(
                    //                           color: ApplicationColors
                    //                               .blackColor2E),
                    //                   child: Center(
                    //                     child: Column(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Image.asset(
                    //                           "assets/images/parking_ic.png",
                    //                           width: 24,
                    //                           height: 17,
                    //                           color:
                    //                               ApplicationColors.redColor67,
                    //                         ),
                    //                         SizedBox(height: 3),
                    //                         Text(
                    //                           "${getTranslated(context, "Park")}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text14bold
                    //                               .copyWith(fontSize: 10),
                    //                         ),
                    //                         SizedBox(height: 1),
                    //                         Text(
                    //                           formatMilliseconds(_reportProvider
                    //                               .getDailyReportList[0]
                    //                               .todayStopped),
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text12b
                    //                               .copyWith(fontSize: 10),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   margin:
                    //                       EdgeInsets.symmetric(horizontal: 7),
                    //                   width: width * 0.2,
                    //                   padding: EdgeInsets.symmetric(
                    //                       vertical: 5, horizontal: 10),
                    //                   decoration: Boxdec.conrad6colorgrey
                    //                       .copyWith(
                    //                           color: ApplicationColors
                    //                               .blackColor2E),
                    //                   child: Center(
                    //                     child: Column(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Image.asset(
                    //                           "assets/images/car_icon.png",
                    //                           width: 24,
                    //                           height: 17,
                    //                           color:
                    //                               ApplicationColors.redColor67,
                    //                         ),
                    //                         SizedBox(height: 3),
                    //                         Text(
                    //                           "${getTranslated(context, "idling")}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text14bold
                    //                               .copyWith(fontSize: 10),
                    //                         ),
                    //                         SizedBox(height: 1),
                    //                         Text(
                    //                           //'${((_reportProvider.getDailyReportList[0].tIdling / (1000*60*60)) % 24).round()} h ${((_reportProvider.getDailyReportList[0].tIdling / (1000 * 60)) % 60).round()} m',
                    //                           //   formatMilliseconds(int.parse(_reportProvider.getDailyReportList[0].tIdling)),
                    //                           _reportProvider
                    //                                       .getDailyReportList[0]
                    //                                       .tIdling !=
                    //                                   null
                    //                               ? formatMilliseconds(84581000)
                    //                               : "00:00:00",
                    //
                    //                           //  "${_reportProvider.getDailyReportList[0].tIdling/1000}",
                    //                           //   "${_reportProvider.getDailyReportList[0].tIdling}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text12b
                    //                               .copyWith(fontSize: 10),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   margin:
                    //                       EdgeInsets.symmetric(horizontal: 7),
                    //                   width: width * 0.2,
                    //                   padding: EdgeInsets.symmetric(
                    //                       vertical: 0, horizontal: 10),
                    //                   decoration: Boxdec.conrad6colorgrey
                    //                       .copyWith(
                    //                           color: ApplicationColors
                    //                               .blackColor2E),
                    //                   child: Center(
                    //                     child: Column(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Image.asset(
                    //                           "assets/images/car_icon.png",
                    //                           width: 24,
                    //                           height: 17,
                    //                           color:
                    //                               ApplicationColors.redColor67,
                    //                         ),
                    //                         SizedBox(height: 3),
                    //                         Text(
                    //                           "${getTranslated(context, "fuel_consum")}",
                    //                           maxLines: 2,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text14bold
                    //                               .copyWith(fontSize: 10),
                    //                         ),
                    //                         SizedBox(height: 1),
                    //                         Text(
                    //                           "${convertFuel(_reportProvider.getDailyReportList[0].totalOdo, _reportProvider.getDailyReportList[0].devObj.Mileage).toStringAsFixed(2)}",
                    //                           maxLines: 1,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.visible,
                    //                           style: Textstyle1.text12b
                    //                               .copyWith(fontSize: 10),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),

                    SizedBox(height: 10),
                    vehicleListProvider.isStoppageLogsLoading
                        ? Helper.dialogCall.showLoader()
                        : !vehicleListProvider.isStoppageLogsLoading &&
                                vehicleListProvider
                                    .stoppageLogsModel.result.isEmpty
                            ? SizedBox.shrink()
                            : Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: ApplicationColors.white9F9,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: vehicleListProvider
                                      .stoppageLogsModel.result.length,
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  itemBuilder: (context, index) {
                                    var list = vehicleListProvider
                                        .stoppageLogsModel.result[index];

                                    var time;
                                    if (list.startTime != null &&
                                        list.endTime != null) {
                                      var avTime = DateFormat("dd hh:mm aa")
                                          .format(DateTime.parse(list.startTime
                                              .toLocal()
                                              .toString()));
                                      var dvTime = DateFormat("dd hh:mm aa")
                                          .format(DateTime.parse(list.endTime
                                              .toLocal()
                                              .toString()));
                                      var format = DateFormat("dd hh:mm aa");
                                      var one = format.parse(avTime);
                                      var two = format.parse(dvTime);
                                      time = two.difference(one);
                                    }

                                    return Container(
                                      color: list.type != "STOPPAGE"
                                          ? Color(0xffece3f6)
                                          : ApplicationColors.blackColor2E,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: TimelineTile(
                                          alignment: TimelineAlign.manual,
                                          lineXY: 0.3,
                                          hasIndicator: true,
                                          afterLineStyle: LineStyle(
                                              color: ApplicationColors
                                                  .textfieldBorderColor,
                                              thickness: 1),
                                          beforeLineStyle: LineStyle(
                                              color: ApplicationColors
                                                  .textfieldBorderColor,
                                              thickness: 1),
                                          indicatorStyle: IndicatorStyle(
                                            indicator: list.type == "STOPPAGE"
                                                ? Container(
                                                    height: 28,
                                                    width: 28,
                                                    child: Center(
                                                      child: Image.asset(
                                                        "assets/images/parking_icon.png",
                                                        width: 15,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: ApplicationColors
                                                          .lightredColorA67,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28),
                                                      //BoxShadow
                                                    ),
                                                  )
                                                : Container(
                                                    height: 28,
                                                    width: 28,
                                                    child: Center(
                                                      child: Image.asset(
                                                        "assets/images/car_time.png",
                                                        width: 15,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: ApplicationColors
                                                          .greenColor370,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              ApplicationColors
                                                                  .whiteColor,
                                                          offset: Offset(
                                                            5.0,
                                                            5.0,
                                                          ),
                                                          blurRadius: 10.0,
                                                          spreadRadius: -8,
                                                        ), //BoxShadow
                                                      ],
                                                    ),
                                                  ),

                                            // color: list.type == "STOPPAGE" ? ApplicationColors.redColor67 : ApplicationColors.greenColor370,
                                            // height: 15,
                                            //  width: 15
                                          ),
                                          endChild: Padding(
                                            // padding: const EdgeInsets.only(top: 15,left: 15,bottom: 5,right: 5),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 15),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  'assets/images/clock_icon_vehicle_Page.png',
                                                  width: width * 0.0025,
                                                  color: ApplicationColors
                                                      .appColor1,
                                                ),
                                                SizedBox(width: width / 40),
                                                Text(
                                                  "${time.toString().split(":").first} ${getTranslated(context, "hr")}  ${time.toString().split(":")[1]} ${getTranslated(context, "min")}",
                                                  style: TextStyle(
                                                      color: ApplicationColors
                                                          .blackbackcolor,
                                                      fontSize: width / 40),
                                                ),
                                                Spacer(),
                                                list.type != "MOVING"
                                                    ? SizedBox()
                                                    : Image.asset(
                                                        'assets/images/car-steering-wheel.png',
                                                        width: width / 20,
                                                        color: ApplicationColors
                                                            .blackbackcolor,
                                                      ),
                                                // SizedBox(width: 10),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: width / 40),
                                                  child: Text(
                                                    list.type == "MOVING"
                                                        ? '${NumberFormat("##0.0#", "en_US").format(list.distance / 1000)} ${getTranslated(context, "kms")}'
                                                        : "",
                                                    style: TextStyle(
                                                      fontSize: width / 40,
                                                      color: ApplicationColors
                                                          .blackbackcolor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          startChild: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Text(
                                              "${DateFormat("MMM dd, ").format(list.startTime.toLocal())},${DateFormat.jm().format(list.startTime.toLocal())}  ",
                                              style: FontStyleUtilities.h9(
                                                      fontColor:
                                                          ApplicationColors
                                                              .black4240,
                                                      fontweight: FWT.bold)
                                                  .copyWith(
                                                      fontSize: width / 40),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ))
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
