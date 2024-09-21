import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/notifications_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/ProductsFilterPage/vehicle_filter.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Model/vehicle_list_model.dart';
import 'notification_clickmap_screen.dart';

class NotificationScreen extends StatefulWidget {
  VehicleLisDevice vehicleLisDevice;

  NotificationScreen({Key key, this.vehicleLisDevice}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationsProvider _notificationsProvider;

  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toString();

  List sendTypeList = [];
  List sendVehicleList = [];

  getNotificationsDetail() async {
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

    print('Notifydata-->$data');

    await _notificationsProvider.getNotificationsDetail(
        data, "notifs/getNotifByFilters", context);
  }

  report() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from_date": fromDate.toString(),
      "to_date": toDate.toString(),
      "type": widget.vehicleLisDevice.typeOfDevice,
      "vehicle": widget.vehicleLisDevice.deviceName,
      "user": "$id",
      "limit": "20",
      "skip": "1",
      "sortOrder": "-1",
    };

    print('Notifydata-->$data');

    await _notificationsProvider.getNotificationsDetail(
        data, "notifs/getNotifByFilters", context);
  }

  ReportProvider _reportProvider;

  getDeviceByUserDropdown() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");

    var data = {"email": email, "id": id};

    await _reportProvider.getVehicleDropdown(
        data, "devices/getDeviceByUserDropdown");
  }

  @override
  void initState() {
    super.initState();
    _notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    datedController = TextEditingController()
      ..text = "From Date\n${DateFormat("dd MMM yyyy").format(DateTime.now())}";
    _endDateController = TextEditingController()
      ..text = "To Date\n${DateFormat("dd MMM yyyy").format(DateTime.now())}";
    getNotificationsDetail();
    getDeviceByUserDropdown();
    if (widget.vehicleLisDevice != null) {
      report();
    }
  }

  @override
  Widget build(BuildContext context) {
    _notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_sharp,
            color: ApplicationColors.whiteColor,
            size: 26,
          ),
        ),
        title: Text(
          "${getTranslated(context, "notification")}",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Arial',
            color: ApplicationColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              final value = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductsFilter(),
                ),
              );
              if (value != null) {
                datedController.text = value[0];
                _endDateController.text = value[1];
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.filter_list,
                size: 35,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xffd21938),
                Color(0xffd21938),
                Color(0xff751c1e),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(right: 19, left: 14, bottom: 05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 05, bottom: 15),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Expanded(
            //         child: TextFormField(
            //           readOnly: true,
            //           maxLines: 2,
            //           style: Textstyle1.signupText1,
            //           keyboardType: TextInputType.number,
            //           controller: datedController,
            //           focusNode: AlwaysDisabledFocusNode(),
            //           onTap: () async {
            //             FocusScope.of(context).unfocus();
            //             dateTimeSelect();
            //           },
            //           decoration: fieldStyle.copyWith(
            //             prefixIcon: Icon(Icons.access_time_sharp),
            //             isDense: true,
            //             hintText: "From Date",
            //             hintStyle: Textstyle1.signupText1,
            //             focusedBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.transparent,
            //               ),
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.transparent,
            //               ),
            //             ),
            //             border: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.transparent,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: TextFormField(
            //           readOnly: true,
            //           maxLines: 2,
            //           style: Textstyle1.signupText1,
            //           keyboardType: TextInputType.number,
            //           controller: _endDateController,
            //           focusNode: AlwaysDisabledFocusNode(),
            //           onTap: () async {
            //             FocusScope.of(context).unfocus();
            //             endDateTimeSelect();
            //           },
            //           decoration: fieldStyle.copyWith(
            //             prefixIcon: Icon(Icons.access_time_sharp),
            //             hintStyle: Textstyle1.signupText1,
            //             hintText: "End Date",
            //             focusedBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.transparent,
            //               ),
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.transparent,
            //               ),
            //             ),
            //             border: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.transparent,
            //               ),
            //             ),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            Expanded(
              child: _notificationsProvider.isGetNotifyFilterLoading
                  ? Helper.dialogCall.showLoader()
                  : _notificationsProvider.notifyFilterList.isEmpty
                      ? Center(
                          child: Text(
                            "${getTranslated(context, "notification_not_available")}",
                            textAlign: TextAlign.center,
                            style: Textstyle1.text18.copyWith(
                              fontSize: 18,
                              color: ApplicationColors.redColor67,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              _notificationsProvider.notifyFilterList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var list =
                                _notificationsProvider.notifyFilterList[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationDetailScreen(
                                        lat: list.lat,
                                        long: list.long,
                                        title: list.item.type,
                                        subtitle: list.item.sentence,
                                        date: list.timestamp,
                                        odo: list.odo,
                                      ),
                                    ));
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(width: width * 0.90, height: 112),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 35, right: 14),
                                      height: 95,
                                      width: width * 0.88,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                      "${list.item.type}",
                                                      style: FontStyleUtilities.h18(
                                                          fontColor:
                                                              ApplicationColors
                                                                  .black4240),
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.start)),
                                              Flexible(
                                                  child: Text(
                                                      "${DateFormat("MMM dd, yyyy hh:mm aa").format(
                                                        DateTime.parse(list
                                                                .timestamp
                                                                .toString())
                                                            .toLocal(),
                                                      )}",
                                                      style: FontStyleUtilities.h12(
                                                          fontColor:
                                                              ApplicationColors
                                                                  .black4240),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.start)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                      "${list.item.sentence}",
                                                      style: FontStyleUtilities.h11(
                                                          fontColor:
                                                              ApplicationColors
                                                                  .black4240),
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start)),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Flexible(
                                            child: RichText(
                                              maxLines: 1,
                                              overflow: TextOverflow.visible,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${getTranslated(context, "odo")} : ',
                                                    style: FontStyleUtilities.h12(
                                                        fontColor:
                                                            ApplicationColors
                                                                .black4240,
                                                        fontFamily:
                                                            'Poppins-Regular'),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${NumberFormat("##0.0#", "en_US").format(list.odo)} ${getTranslated(context, "km_(s)")}",
                                                    style: FontStyleUtilities.h12(
                                                        fontColor:
                                                            ApplicationColors
                                                                .redColor67,
                                                        fontFamily:
                                                            'Poppins-Regular'),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: ApplicationColors.blackColor2E,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ApplicationColors
                                                .textfieldBorderColor,
                                            offset: Offset(
                                              0,
                                              0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: -4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 38,
                                    left: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      height: 35,
                                      width: 35,
                                      child: "${list.item.type}" ==
                                              "Ignition Alert"
                                          ? Image.asset(
                                              "assets/images/ignition_alert.png")
                                          : "${list.item.type}" == "Poi Alert"
                                              ? Image.asset(
                                                  "assets/images/Poi_report_icon.png",
                                                  color: ApplicationColors
                                                      .whiteColor)
                                              : "${list.item.type}" ==
                                                      "Theft Alert"
                                                  ? Image.asset(
                                                      "assets/images/theft_icon.png",
                                                      color: ApplicationColors
                                                          .whiteColor)
                                                  : "${list.item.type}" ==
                                                          "Speed Alert"
                                                      ? Image.asset(
                                                          "assets/images/speedometer.png",
                                                          color: ApplicationColors
                                                              .whiteColor)
                                                      : "${list.item.type}" ==
                                                              "Max Idling Alert"
                                                          ? Image.asset(
                                                              "assets/images/clock.png",
                                                              color: ApplicationColors
                                                                  .whiteColor)
                                                          : "${list.item.type}" ==
                                                                  "Toll Alert"
                                                              ? Image.asset(
                                                                  "assets/images/toll_icon.png",
                                                                  color: ApplicationColors.whiteColor)
                                                              : "${list.item.type}" == "Power Alert"
                                                                  ? Image.asset("assets/images/on-off-button.png", color: ApplicationColors.whiteColor)
                                                                  : Image.asset("assets/images/other_icon.png", color: ApplicationColors.whiteColor),
                                      decoration: BoxDecoration(
                                        color: ApplicationColors.redColor67,
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
            ),
          ],
        ),
      ),
    );
  }

  DateTime date;
  TimeOfDay time;

  DateTime fromDatePicked = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.now();

  DateTime endDatePicked = DateTime.now();
  TimeOfDay endPickedTime = TimeOfDay.now();

  dateTimeSelect() async {
    date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      builder: (context, child) {
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
      },
    );

    time = await showTimePicker(
      context: context,
      initialTime: pickedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.grey,
              onPrimary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: ApplicationColors.black4240,
          ),
          child: child,
        );
      },
    );

    if (date != null) {
      setState(() {
        this.fromDatePicked =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        datedController.text =
            "From Date\n${DateFormat("dd MMM yyyy hh:mm aa").format(fromDatePicked)}";
        fromDate = datedController.text;
      });

      if (datedController.text.isNotEmpty) {
        getNotificationsDetail();
      }
    }
  }

  endDateTimeSelect() async {
    date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      builder: (context, child) {
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
      },
    );

    time = await showTimePicker(
      context: context,
      initialTime: endPickedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey,
              onPrimary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    );

    if (date != null) {
      setState(() {
        this.endDatePicked =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        _endDateController.text =
            "To Date\n${DateFormat("dd MMM yyyy hh:mm aa").format(endDatePicked)}";
        toDate = _endDateController.text;
      });

      if (_endDateController.text.isNotEmpty) {
        getNotificationsDetail();
      }
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
