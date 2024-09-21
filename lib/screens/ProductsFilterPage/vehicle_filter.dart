import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/notifications_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class ProductsFilter extends StatefulWidget {
  const ProductsFilter({Key key}) : super(key: key);

  @override
  _ProductsFilterState createState() => _ProductsFilterState();
}

class _ProductsFilterState extends State<ProductsFilter> {
  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toUtc().toString();

  FocusNode focusNode = FocusNode();

  List sendTypeList = [];
  List sendVehicleList = [];

  String selected = 'categories';
  var chooseLocation;
  int selecttype = 3;
  DateTime _selectedDate = DateTime.now();
  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = TextEditingController();
  TextEditingController _selectVehicleContoller = TextEditingController();

  NotificationsProvider _notificationsProvider;
  final _debouncer = Debouncer(milliseconds: 500);

  report() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from_date": fromDate.toString(),
      "to_date": toDate.toString(),
      "type": "",
      "vehicle": "",
      "user": "$id",
      "limit": "20",
      "skip": "1",
      "sortOrder": "-1",
    };

    print('data-->$data');

    await _notificationsProvider.getNotificationsDetail(
        data, "notifs/getNotifByFilters", context);
  }

  getNotificationsDetail() async {
    var typeList = "";
    String typelist = "";
    if (sendTypeList.isNotEmpty) {
      for (int i = 0; i < sendTypeList.length; i++) {
        typeList = typeList + "${sendTypeList[i]},";
      }

      typelist = typeList.substring(0, typeList.length - 1);
    }

    var vehicleList = "";
    String vehiclelist = "";

    if (sendVehicleList.isNotEmpty) {
      for (int i = 0; i < sendVehicleList.length; i++) {
        // print(sendVehicleList[i]);
        vehicleList = vehicleList + "${sendVehicleList[i]},";
      }
      print(vehicleList);

      vehiclelist = vehicleList.substring(0, vehicleList.length - 1);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from_date": fromDate.toString(),
      "to_date": toDate.toString(),
      "type": typelist,
      "vehicle": "$vehiclelist",
      "user": "$id",
      "limit": "20",
      "skip": "1",
      "sortOrder": "-1",
    };

    print('data-->$data');

    await _notificationsProvider.getNotificationsDetail(
        data, "notifs/getNotifByFilters", context);
    Navigator.pop(context, ["$fromDate", "$toDate"]);
  }

  ReportProvider _reportProvider;

  getDeviceByUserDropdown() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");
    bool isDealer = sharedPreferences.getBool("isDealer");

    var data = isDealer
        ? {"email": email, "id": id, "dealer": id}
        : {
            "email": email,
            "id": id,
          };

    await _reportProvider.getVehicleDropdown(
        data, "devices/getDeviceByUserDropdown");

    if (_reportProvider.isSuccess) {
      _reportProvider.userVehicleDropModel.devices =
          _reportProvider.searchVehicleList;
    }
  }

  @override
  void initState() {
    super.initState();
    _notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    listofVehicleValue = List<bool>.filled(
        _reportProvider.userVehicleDropModel.devices.length, false);
    getDeviceByUserDropdown();
  }

  List<bool> listofCategoriesValue = List<bool>.filled(25, false);
  List<bool> listofVehicleValue = [];
  List<bool> listofDateValue = List<bool>.filled(4, false);

  @override
  Widget build(BuildContext context) {
    List listOfCategories = [
      {"value": '${getTranslated(context, "Ign_small_word")}', "key": "IGN"},
      {
        "value": '${getTranslated(context, "Route_Poi")}',
        "key": "route-poi",
      },
      {
        "value": '${getTranslated(context, "power")}',
        "key": "power",
      },
      {
        "value": '${getTranslated(context, "fuel_small")}',
        "key": "Fuel",
      },
      {
        "value": '${getTranslated(context, "geofence")}',
        "key": 'Geo-Fence',
      },
      {
        "value": '${getTranslated(context, "Watch_Remove")}',
        "key": 'Watch remove',
      },
      {
        "value": '${getTranslated(context, "Overspeed")}',
        "key": 'Over speed',
      },
      {
        "value": '${getTranslated(context, "Ac")}',
        "key": 'AC',
      },
      {
        "value": '${getTranslated(context, "Route")}',
        "key": 'Route',
      },
      {
        "value": '${getTranslated(context, "GeoHalt")}',
        "key": 'GeoHalt',
      },
      {
        "value": '${getTranslated(context, "Maxstoppage")}',
        "key": 'MAXSTOPPAGE',
      },
      {
        "value": '${getTranslated(context, "sos")}',
        "key": 'SOS',
      },
      {
        "value": '${getTranslated(context, "Immo")}',
        "key": 'immo',
      },
      {
        "value": '${getTranslated(context, "sms")}',
        "key": 'sms',
      },
      {
        "value": '${getTranslated(context, "Sb-eta")}',
        "key": 'sb-eta',
      },
      {
        "value": '${getTranslated(context, "Sb-otp")}',
        "key": 'sb-OTP',
      },
      {
        "value": '${getTranslated(context, "Theft")}',
        "key": 'theft',
      },
      {
        "value": '${getTranslated(context, "Accalarm")}',
        "key": 'accalarm',
      },
      {
        "value": '${getTranslated(context, "Lowbattery")}',
        "key": 'lowbattery',
      },
      {
        "value": '${getTranslated(context, "toll")}',
        "key": 'toll',
      },
      {
        "value": '${getTranslated(context, "Student")}',
        "key": 'student',
      },
      {
        "value": '${getTranslated(context, "reminder")}',
        "key": 'Reminder',
      },
      {
        "value": '${getTranslated(context, "Vibration")}',
        "key": 'Vibration',
      },
      {
        "value": '${getTranslated(context, "Chat")}',
        "key": 'chat',
      },
      {
        "value": '${getTranslated(context, "Door")}',
        "key": 'door',
      },
    ];

    List<String> listOfDate = [
      '${getTranslated(context, "today")}',
      '${getTranslated(context, "yesterday")}',
      '${getTranslated(context, "last_week")}',
      '${getTranslated(context, "last_month")}',
    ];

    _notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: ApplicationColors.whiteColorF9
              /* image: DecorationImage(
                  image: AssetImage(
                      "assets/images/dark_background_image.png"
                  ), // <-- BACKGROUND IMAGE
                  fit: BoxFit.cover,
                ),*/
              ),
        ),
        Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("${getTranslated(context, "search")}",
                  style: Textstyle1.appbartextstyle1),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                      child: Text(
                    "${getTranslated(context, "clear_all")}",
                    style: Textstyle1.text14
                        .copyWith(color: ApplicationColors.redColor67),
                  )),
                )
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ApplicationColors.redColor67,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                            child: Text(
                          "${getTranslated(context, "cancel")}",
                          style: Textstyle1.text18boldwhite,
                        )),
                        height: height * .06,
                        width: width * .4,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        getNotificationsDetail();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ApplicationColors.redColor67,
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                            child: Text(
                                "${getTranslated(context, "apply")}"
                                    .toUpperCase(),
                                style: Textstyle1.text18boldwhite)),
                        height: height * .06,
                        width: width * .4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selecttype = 3;
                          });
                        },
                        child: Container(
                          width: width * .25,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration:
                              Boxdec.bcbluerad6withnoborderright.copyWith(
                            color: selecttype == 3
                                ? ApplicationColors.blackColor2E
                                : Colors.transparent,
                          ),
                          child: Text(
                            "${getTranslated(context, "categories")}",
                            style: Textstyle1.text14bold.copyWith(
                                color: selecttype == 3
                                    ? ApplicationColors.black4240
                                    : ApplicationColors.dropdownColor3D,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selecttype = 1;
                          });
                        },
                        child: Container(
                          width: width * .25,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: Boxdec.bcbluerad6withnoborderright
                              .copyWith(
                                  color: selecttype == 1
                                      ? ApplicationColors.blackColor2E
                                      : Colors.transparent),
                          child: Text(
                            "${getTranslated(context, "vehicle")}",
                            style: Textstyle1.text14bold.copyWith(
                                color: selecttype == 1
                                    ? ApplicationColors.black4240
                                    : ApplicationColors.dropdownColor3D,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selecttype = 2;
                          });
                        },
                        child: Container(
                          width: width * .25,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: Boxdec.bcbluerad6withnoborderright
                              .copyWith(
                                  color: selecttype == 2
                                      ? ApplicationColors.blackColor2E
                                      : Colors.transparent),
                          child: Text(
                            "${getTranslated(context, "date")}",
                            style: Textstyle1.text14bold.copyWith(
                                color: selecttype == 2
                                    ? ApplicationColors.black4240
                                    : ApplicationColors.dropdownColor3D,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      /* GestureDetector(
                            onTap: () {
                              setState(() {
                                selecttype = 4;
                              });
                            },
                            child: Container(
                              width: width * .25,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: Boxdec.bcbluerad6withnoborderright
                                  .copyWith(
                                      color: selecttype == 4
                                          ? ApplicationColors.blackColor2E
                                          : Colors.transparent),
                              child: Text(
                                "Location",
                                style: Textstyle1.text14bold.copyWith(
                                    color: selecttype == 4
                                        ? ApplicationColors.white9F9
                                        : ApplicationColors.dropdownColor3D,
                                    fontSize: 12),
                              ),
                            ),
                          ),*/
                    ],
                  ),
                  selecttype == 3
                      ? Expanded(
                          child: Container(
                              height: height,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration:
                                  Boxdec.bcbluerad6withnoborderleft.copyWith(
                                color: ApplicationColors.blackColor2E,
                              ),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: listOfCategories.length,
                                  itemBuilder: (context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, top: 8, bottom: 8),
                                      child: InkWell(
                                        onTap: () {
                                          print('checked');
                                          setState(() {
                                            if (listofCategoriesValue[index] ==
                                                false) {
                                              listofCategoriesValue[index] =
                                                  true;
                                              sendTypeList.add(
                                                  listOfCategories[index]
                                                      ['key']);
                                              print(sendTypeList);
                                            } else {
                                              sendTypeList.remove(
                                                  listOfCategories[index]
                                                      ['key']);
                                              listofCategoriesValue[index] =
                                                  false;
                                              print(sendTypeList);
                                            }
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: width * .05,
                                                  height: height * .022,
                                                  decoration: BoxDecoration(
                                                    color: listofCategoriesValue[
                                                                index] ==
                                                            true
                                                        ? ApplicationColors
                                                            .redColor67
                                                        : ApplicationColors
                                                            .dropdownColor3D,
                                                    border: Border.all(
                                                      width: 3,
                                                      color: ApplicationColors
                                                          .dropdownColor3D,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "${listOfCategories[index]["value"]}",
                                                  style: Textstyle1.text12b,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                        )
                      : selecttype == 1
                          ? Expanded(
                              child: Container(
                                  height: height,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: Boxdec.bcbluerad6withnoborderleft
                                      .copyWith(
                                    color: ApplicationColors.blackColor2E,
                                  ),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _selectVehicleContoller,
                                        focusNode: focusNode,
                                        keyboardType: TextInputType.text,
                                        onChanged: (string) {
                                          _debouncer.run(() {
                                            setState(() {
                                              _reportProvider
                                                      .userVehicleDropModel
                                                      .devices =
                                                  _reportProvider
                                                      .searchVehicleList
                                                      .where((u) {
                                                return (u.deviceName
                                                    .toLowerCase()
                                                    .contains(
                                                        string.toLowerCase()));
                                              }).toList();
                                            });
                                          });
                                        },
                                        style: FontStyleUtilities.h14(
                                          fontColor:
                                              ApplicationColors.blackColor00,
                                        ),
                                        decoration:
                                            Textfield1.inputdec.copyWith(
                                          fillColor:
                                              ApplicationColors.whiteColor,
                                          labelStyle: TextStyle(
                                            color: ApplicationColors.whiteColor,
                                            fontSize: 15,
                                            fontFamily: "Poppins-Regular",
                                            letterSpacing: 0.75,
                                          ),
                                          hintText:
                                              "${getTranslated(context, "search_vehicle")}",
                                          hintStyle: TextStyle(
                                            color: ApplicationColors.black4240,
                                            fontSize: 14,
                                            fontFamily: "Poppins-Regular",
                                            letterSpacing: 0.75,
                                          ),
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Image.asset(
                                              'assets/images/search_icon.png',
                                              color:
                                                  ApplicationColors.redColor67,
                                              width: 8,
                                            ),
                                          ),
                                          suffixIcon: _selectVehicleContoller
                                                  .text.isEmpty
                                              ? SizedBox()
                                              : InkWell(
                                                  onTap: () {
                                                    _reportProvider
                                                        .userVehicleDropModel
                                                        .devices
                                                        .clear();
                                                    _reportProvider
                                                        .searchVehicleList
                                                        .clear();
                                                    _reportProvider
                                                            .isDropDownLoading =
                                                        false;
                                                    getDeviceByUserDropdown();
                                                    _selectVehicleContoller
                                                        .clear();
                                                    focusNode.unfocus();
                                                  },
                                                  child: Icon(
                                                    Icons.cancel_outlined,
                                                    color: ApplicationColors
                                                        .whiteColor,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      _reportProvider.isDropDownLoading
                                          ? Helper.dialogCall.showLoader()
                                          : _reportProvider.userVehicleDropModel
                                                  .devices.isEmpty
                                              ? Center(
                                                  child: Text(
                                                    "${getTranslated(context, "vehicle_not_available")}",
                                                    textAlign: TextAlign.center,
                                                    style: Textstyle1.text18
                                                        .copyWith(
                                                      fontSize: 18,
                                                      color: ApplicationColors
                                                          .redColor67,
                                                    ),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: _reportProvider
                                                          .userVehicleDropModel
                                                          .devices
                                                          .length,
                                                      itemBuilder:
                                                          (context, int index) {
                                                        var list = _reportProvider
                                                            .userVehicleDropModel
                                                            .devices[index];
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 16,
                                                            top: 8,
                                                            bottom: 8,
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              print("Test");
                                                              setState(() {
                                                                if (listofVehicleValue[
                                                                        index] ==
                                                                    false) {
                                                                  listofVehicleValue[
                                                                          index] =
                                                                      true;
                                                                  sendVehicleList
                                                                      .add(
                                                                          '${list.deviceId}');
                                                                  print(
                                                                      sendVehicleList);
                                                                } else {
                                                                  sendVehicleList
                                                                      .remove(list
                                                                          .deviceId);
                                                                  listofVehicleValue[
                                                                          index] =
                                                                      false;
                                                                  print(
                                                                      sendVehicleList);
                                                                }
                                                              });
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          width *
                                                                              .05,
                                                                      height:
                                                                          height *
                                                                              .022,
                                                                      decoration: BoxDecoration(
                                                                          color: listofVehicleValue[index] == true
                                                                              ? ApplicationColors
                                                                                  .redColor67
                                                                              : ApplicationColors
                                                                                  .dropdownColor3D,
                                                                          border: Border.all(
                                                                              width: 3,
                                                                              color: ApplicationColors.dropdownColor3D)),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      "${list.deviceName}",
                                                                      style: Textstyle1
                                                                          .text12b,
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                    ],
                                  )),
                            )
                          : Expanded(
                              child: Container(
                                  height: height,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  decoration: Boxdec.bcbluerad6withnoborderleft
                                      .copyWith(
                                          color:
                                              ApplicationColors.blackColor2E),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: listOfDate.length,
                                          itemBuilder: (context, int index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  listofDateValue =
                                                      List<bool>.filled(
                                                          listOfDate.length,
                                                          false);
                                                  if (listOfDate[index] ==
                                                      '${getTranslated(context, "today")}') {
                                                    fromDate =
                                                        "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
                                                    toDate = DateTime.now()
                                                        .toUtc()
                                                        .toString();
                                                    datedController.text =
                                                        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(fromDate))}";
                                                    _endDateController.text =
                                                        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now())}";
                                                  } else if (listOfDate[
                                                          index] ==
                                                      '${getTranslated(context, "last_month")}') {
                                                    fromDate =
                                                        "${DateTime.now().subtract(Duration(days: 30))}";
                                                    toDate = DateTime.now()
                                                        .toUtc()
                                                        .toString();
                                                    datedController.text =
                                                        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(fromDate))}";
                                                    _endDateController.text =
                                                        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now())}";
                                                  } else if (listOfDate[
                                                          index] ==
                                                      '${getTranslated(context, "yesterday")}') {
                                                    fromDate =
                                                        "${DateTime.now().subtract(Duration(days: 1))}";
                                                    toDate = DateTime.now()
                                                        .toUtc()
                                                        .toString();
                                                    datedController.text =
                                                        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(fromDate))}";
                                                    _endDateController.text =
                                                        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now())}";
                                                  } else if (listOfDate[
                                                          index] ==
                                                      '${getTranslated(context, "last_week")}') {
                                                    fromDate =
                                                        "${DateTime.now().subtract(Duration(days: 7))}";
                                                    toDate = DateTime.now()
                                                        .toUtc()
                                                        .toString();
                                                    datedController.text =
                                                        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(fromDate))}";
                                                    _endDateController.text =
                                                        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now())}";
                                                  }
                                                  listofDateValue[index] = true;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: width * .05,
                                                        height: height * .022,
                                                        decoration: BoxDecoration(
                                                            color: listofDateValue[
                                                                        index] ==
                                                                    true
                                                                ? ApplicationColors
                                                                    .redColor67
                                                                : ApplicationColors
                                                                    .dropdownColor3D,
                                                            border: Border.all(
                                                                width: 3,
                                                                color: ApplicationColors
                                                                    .dropdownColor3D)),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        listOfDate[index],
                                                        style:
                                                            Textstyle1.text12b,
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${getTranslated(context, "custom_range")}",
                                        style: Textstyle1.text12b,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .06,
                                        child: TextFormField(
                                          readOnly: true,
                                          style: Textstyle1.signupText1,
                                          keyboardType: TextInputType.number,
                                          controller: datedController,
                                          focusNode: AlwaysDisabledFocusNode(),
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            DateTime newSelectedDate =
                                                await _selecttDate(context);
                                            if (newSelectedDate != null) {
                                              setState(() {
                                                datedController.text =
                                                    DateFormat("dd-MMM-yyyy")
                                                        .format(
                                                            newSelectedDate);
                                              });
                                            }
                                          },
                                          decoration: fieldStyle.copyWith(
                                            isDense: true,
                                            hintText:
                                                "${getTranslated(context, "select_start_date")}",
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(13.0),
                                              child: Image.asset(
                                                "assets/images/date_icon.png",
                                                color: ApplicationColors
                                                    .redColor67,
                                                width: 5,
                                                height: 5,
                                              ),
                                            ),
                                            hintStyle: Textstyle1.text12b,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Center(
                                          child: Text(
                                        "${getTranslated(context, "to")}",
                                        style: Textstyle1.text12b,
                                        textAlign: TextAlign.center,
                                      )),
                                      SizedBox(height: 5),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .06,
                                        child: TextFormField(
                                          readOnly: true,
                                          style: Textstyle1.signupText1,
                                          keyboardType: TextInputType.number,
                                          controller: _endDateController,
                                          focusNode: AlwaysDisabledFocusNode(),
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            DateTime newSelectedDate =
                                                await _selecttDate(context);
                                            if (newSelectedDate != null) {
                                              setState(() {
                                                //initializeDateFormatting('es');
                                                _endDateController.text =
                                                    DateFormat("dd-MMM-yyyy")
                                                        .format(
                                                            newSelectedDate);
                                              });
                                            }
                                          },
                                          decoration: fieldStyle.copyWith(
                                            hintStyle: Textstyle1.text12b,
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(13.0),
                                              child: Image.asset(
                                                "assets/images/date_icon.png",
                                                color: ApplicationColors
                                                    .redColor67,
                                                width: 5,
                                                height: 5,
                                              ),
                                            ),
                                            hintText:
                                                "${getTranslated(context, "select_end_date")}",
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            )
                ],
              ),
            )),
      ],
    ));
  }

  _selecttDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        // firstDate: DateTime.now().subtract(Duration(days: 10)),
        firstDate: DateTime(2015),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: ApplicationColors.redColor67,
                onPrimary: Colors.white,
                surface: ApplicationColors.redColor67,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });
    return newSelectedDate;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
