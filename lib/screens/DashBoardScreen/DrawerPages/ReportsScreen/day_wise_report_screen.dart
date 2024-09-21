import 'dart:async';

import 'dart:ui';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/ProductsFilterPage/vehicle_filter.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DayWiseReportScreen extends StatefulWidget {
  const DayWiseReportScreen({Key key}) : super(key: key);

  @override
  DayWiseReportScreenState createState() => DayWiseReportScreenState();
}

class DayWiseReportScreenState extends State<DayWiseReportScreen> {
  var height, width;
  DateTime _selectedDate = DateTime.now();
  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  ReportProvider _reportProvider;

  String selectedtype;

  List<DropdownMenuItem<String>> get dropdownTypeItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text('${getTranslated(context, "today")}'), value: "Today"),
      DropdownMenuItem(
          child: Text('${getTranslated(context, "1_month")}'),
          value: "1 Month"),
      DropdownMenuItem(
          child: Text('${getTranslated(context, "yesterday")}'),
          value: "Yesterday"),
      DropdownMenuItem(
          child: Text('${getTranslated(context, "week")}'), value: "Week"),
    ];
    return menuItems;
  }

  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toUtc().toString();
  var vehicleId = "";

  getDayWiseReports() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from": fromDate,
      "to": toDate,
      "user": id,
      "device": vehicleId,
    };

    print(data);
    _reportProvider.getDayWiseReports(data, "summary/getDayWiseReport");
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

  @override
  void initState() {
    super.initState();
    datedController = TextEditingController()
      ..text =
          "From Date\n${DateFormat("dd MMM yyyy hh:mm a").format(DateTime.now())}";
    _endDateController = TextEditingController()
      ..text =
          "To Date\n${DateFormat("dd MMM yyyy hh:mm a").format(DateTime.now())}";
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _reportProvider.dayWiseEndAddressList.clear();
    _reportProvider.dayWiseStartAddressList.clear();
    _reportProvider.getDaywiseReportList.clear();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
    getDeviceByUserDropdown();
  }

  var exportType = "excel";

  bool isScrollingDown = false, _showAppbar = true;
  final ScrollController _scrollViewController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      resizeToAvoidBottomInset: false,
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
          "${getTranslated(context, "day_wise_report")}",
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
          Padding(
            padding:
                const EdgeInsets.only(left: 0.0, bottom: 20, top: 20, right: 0),
            child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            titlePadding: EdgeInsets.all(0),
                            backgroundColor: Colors.transparent,
                            title: Container(
                              width: width,
                              decoration: BoxDecoration(
                                  color: ApplicationColors.blackColor2E,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Text(
                                      "${getTranslated(context, "select_export_option")}",
                                      style: Textstyle1.text18bold,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(
                                      color: ApplicationColors.dropdownColor3D,
                                      thickness: 2,
                                      height: 0,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          exportType = "excel";
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                color: exportType == "excel"
                                                    ? ApplicationColors
                                                        .redColor67
                                                    : Colors.transparent,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: ApplicationColors
                                                        .redColor67),
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${getTranslated(context, "export_excel")}",
                                            style: Textstyle1.text11,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          exportType = "pdf";
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                color: exportType == "pdf"
                                                    ? ApplicationColors
                                                        .redColor67
                                                    : Colors.transparent,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: ApplicationColors
                                                        .redColor67),
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${getTranslated(context, "export_pdf")}",
                                            style: Textstyle1.text11,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: height * .04,
                                              padding: EdgeInsets.all(5),
                                              decoration:
                                                  Boxdec.buttonBoxDecRed_r6,
                                              child: Center(
                                                child: Text(
                                                  "${getTranslated(context, "cancel")}",
                                                  style: Textstyle1
                                                      .text14boldwhite
                                                      .copyWith(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if ("vehicleId" != "") {
                                                if (exportType == "pdf") {
                                                  List<String> sendList = [];
                                                  for (int i = 0;
                                                      i <
                                                          _reportProvider
                                                              .getDaywiseReportList
                                                              .length;
                                                      i++) {
                                                    print(
                                                        "123------------${_reportProvider.getDaywiseReportList[i]['Moving Time']}");

                                                    sendList.add(""
                                                        'Vehicle No. : ${_reportProvider.getDaywiseReportList[i]['VRN']}'
                                                        "\n\n"
                                                        "Date : ${DateFormat("MMM dd, yyyy").format(DateTime.parse(
                                                      _reportProvider
                                                              .getDaywiseReportList[
                                                          i]['Date'],
                                                    ))}"
                                                        "\n\n"
                                                        // "Running : ${NumberFormat("##0.0#", "en_US").format(_reportProvider.getDaywiseReportList[i]['Moving Time'])}"
                                                        "Running : ${_reportProvider.getDaywiseReportList[i]['Moving Time'].toString()}"
                                                        "\n\n"
                                                        "Stop : ${_reportProvider.getDaywiseReportList[i]['Stoppage Time'].toString()}"
                                                        "\n\n"
                                                        "Idle : ${_reportProvider.getDaywiseReportList[i]['Idle Time'].toString()}"
                                                        "\n\n"
                                                        "Distance : ${_reportProvider.getDaywiseReportList[i]['Distance(Kms)'].toString()}"
                                                        "\n\n"
                                                        "Start Address : ${_reportProvider.dayWiseStartAddressList[i]}"
                                                        "\n\n"
                                                        "End Address : ${_reportProvider.dayWiseEndAddressList[i]}"
                                                        "\n\n");
                                                  }

                                                  if (sendList.isNotEmpty) {
                                                    generatePdf(
                                                        sendList, vehicleId);
                                                  } else {
                                                    Helper.dialogCall.showToast(
                                                        context,
                                                        "${getTranslated(context, "vehicle_report_is_empty")}");
                                                  }
                                                } else {
                                                  List sendList = [];
                                                  for (int i = 0;
                                                      i <
                                                          _reportProvider
                                                              .getDaywiseReportList
                                                              .length;
                                                      i++) {
                                                    // print(_reportProvider.getDaywiseReportList[i]['Moving Time'].runtimeType);
                                                    var data = {
                                                      "a":
                                                          '${_reportProvider.getDaywiseReportList[i]['VRN']}',
                                                      "b":
                                                          "${DateFormat("MMM dd, yyyy").format(DateTime.parse(
                                                        _reportProvider
                                                                .getDaywiseReportList[
                                                            i]['Date'],
                                                      ))}",
                                                      "c":
                                                          "${_reportProvider.getDaywiseReportList[i]['Moving Time']}",
                                                      "d":
                                                          "${_reportProvider.getDaywiseReportList[i]['Stoppage Time'].toString()}",
                                                      "e":
                                                          "${_reportProvider.getDaywiseReportList[i]['Idle Time'].toString()}",
                                                      "f":
                                                          "${_reportProvider.getDaywiseReportList[i]['Distance(Kms)'].toString()}",
                                                      "g":
                                                          " ${_reportProvider.dayWiseStartAddressList[i]}",
                                                      "h":
                                                          " ${_reportProvider.dayWiseStartAddressList[i]}",
                                                      "i": "",
                                                      "j": "",
                                                      "k": "",
                                                      "l": "",
                                                    };

                                                    sendList.add(data);
                                                  }

                                                  List excelTitle = [
                                                    'Vehicle No.',
                                                    'Date',
                                                    'Running',
                                                    'Stop',
                                                    'Idle',
                                                    'Distance',
                                                    'Start Address',
                                                    'End Address',
                                                    "",
                                                    "",
                                                    "",
                                                    "",
                                                  ];

                                                  if (sendList.isNotEmpty) {
                                                    generateExcel(sendList,
                                                        vehicleId, excelTitle);
                                                  } else {
                                                    Helper.dialogCall.showToast(
                                                        context,
                                                        "${getTranslated(context, "vehicle_report_is_empty")}");
                                                  }

                                                  // generateExcel(
                                                  //     sendList,
                                                  //     "vehicleName",
                                                  //     excelTitle);
                                                }
                                                //  Navigator.pop(context);
                                              } else {
                                                Helper.dialogCall.showToast(
                                                    context,
                                                    "${getTranslated(context, "select_vehicle")}");
                                              }
                                            },
                                            child: Container(
                                              height: height * .04,
                                              padding: EdgeInsets.all(5),
                                              decoration:
                                                  Boxdec.buttonBoxDecRed_r6,
                                              child: Center(
                                                child: Text(
                                                  "${getTranslated(context, "export")}",
                                                  style: Textstyle1
                                                      .text14boldwhite
                                                      .copyWith(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      });
                },
                child: Image.asset(
                  "assets/images/threen_verticle_options_icon.png",
                  color: ApplicationColors.whiteColor,
                  width: 30,
                )),
          ),
          SizedBox(width: 10),
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
      body: _reportProvider.isDropDownLoading
          ? Helper.dialogCall.showLoader()
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ApplicationColors.blackColor2E,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Theme(
                          data: ThemeData(
                            textTheme: TextTheme(
                                subtitle1: TextStyle(color: Colors.black)),
                          ),
                          child: DropdownSearch<VehicleList>(
                            popupBackgroundColor:
                                ApplicationColors.blackColor2E,
                            mode: Mode.DIALOG,
                            showSearchBox: true,
                            showAsSuffixIcons: true,
                            dialogMaxWidth: width,
                            popupItemBuilder: (context, item, isSelected) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  item.deviceName,
                                  style: TextStyle(
                                      color: ApplicationColors.black4240,
                                      fontSize: 15,
                                      fontFamily: "Poppins-Regular",
                                      letterSpacing: 0.75),
                                ),
                              );
                            },
                            emptyBuilder: (context, string) {
                              return Center(
                                child: Text(
                                  "${getTranslated(context, "vehicle_not_found")}",
                                  style: TextStyle(
                                      color: ApplicationColors.black4240,
                                      fontSize: 15,
                                      fontFamily: "Poppins-Regular",
                                      letterSpacing: 0.75),
                                ),
                              );
                            },
                            searchFieldProps: TextFieldProps(
                              style: TextStyle(
                                  color: ApplicationColors.black4240,
                                  fontSize: 15,
                                  fontFamily: "Poppins-Regular",
                                  letterSpacing: 0.75),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: ApplicationColors
                                          .textfieldBorderColor,
                                      width: 1,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: ApplicationColors
                                          .textfieldBorderColor,
                                      width: 1,
                                    )),
                                hintText:
                                    "${getTranslated(context, "search_vehicle")}",
                                hintStyle: TextStyle(
                                    color: ApplicationColors.black4240,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75),
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            dropdownSearchBaseStyle: TextStyle(
                                color: ApplicationColors.black4240,
                                fontSize: 15,
                                fontFamily: "Poppins-Regular",
                                letterSpacing: 0.75),
                            dropdownSearchDecoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ApplicationColors.transparentColors,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ApplicationColors.transparentColors,
                                ),
                              ),
                              hintText:
                                  "${getTranslated(context, "search_vehicle")}",
                              hintStyle: TextStyle(
                                  color: ApplicationColors.black4240,
                                  fontSize: 15,
                                  fontFamily: "Poppins-Regular",
                                  letterSpacing: 0.75),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ApplicationColors.transparentColors,
                                ),
                              ),
                            ),
                            items: _reportProvider.userVehicleDropModel.devices,
                            itemAsString: (VehicleList u) => u.deviceName,
                            onChanged: (VehicleList data) {
                              setState(() {
                                vehicleId = data.deviceId;
                                getDayWiseReports();
                              });
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  //T00:00:00.000Z
                                  DateTime now = DateTime
                                      .now(); // get the current date and time
                                  DateTime dateAtMidnight = DateTime(
                                      now.year,
                                      now.month,
                                      now.day); // set the time to 12:00 am

                                  fromDate = dateAtMidnight.toUtc().toString();
                                  // fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
                                  toDate = DateTime.now().toUtc().toString();

                                  datedController.text =
                                      "From Date\n${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight.toString()))}";
                                  _endDateController.text =
                                      "To Date\n${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now())}";
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Color(0xffee851c),
                                  ),
                                  child: Text(
                                    "TODAY",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ApplicationColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  var hour = DateTime.now()
                                      .subtract(Duration(days: 31));
                                  fromDate = hour.toUtc().toString();
                                  print("Fromdate is----------$fromDate");
                                  print(
                                      "todate is----------${DateTime.now().toUtc().toString()}");
                                  var fromDate1 =
                                      "${DateTime.now().subtract(Duration(days: 31))}";
                                  //fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(hours: 1)))}T00:00:00.000Z";
                                  toDate = DateTime.now().toUtc().toString();

                                  datedController.text =
                                      "From Date\n${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(fromDate1))}";
                                  _endDateController.text =
                                      "To Date\n${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now())}";
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Color(0xffee851c),
                                  ),
                                  child: Text(
                                    "1 MONTH",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ApplicationColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  var yesterday = DateTime.now()
                                      .subtract(Duration(days: 1));
                                  DateTime dateAtMidnight = DateTime(
                                      yesterday.year,
                                      yesterday.month,
                                      yesterday.day);
                                  fromDate = dateAtMidnight.toUtc().toString();
                                  DateTime now = DateTime.now();
                                  var yesterday1 =
                                      now.subtract(Duration(days: 1));
                                  var yesterdayMidnightUtc = DateTime.utc(
                                      yesterday.year,
                                      yesterday.month,
                                      yesterday.day);
                                  // var fromDate1 = "${DateTime.now().subtract(Duration(days: 1))}";
                                  toDate = DateTime.now().toUtc().toString();

                                  datedController.text =
                                      "From Date\n${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(yesterdayMidnightUtc.toString()))}";
                                  _endDateController.text =
                                      "To Date\n${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now())}";
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Color(0xffee851c),
                                  ),
                                  child: Text(
                                    "YESTERDAY",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ApplicationColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  var week = DateTime.now()
                                      .subtract(Duration(days: 6));
                                  DateTime dateAtMidnight =
                                      DateTime(week.year, week.month, week.day);
                                  fromDate = dateAtMidnight.toUtc().toString();
                                  //var fromDate1 = "${DateTime.now().subtract(Duration(days: 7))}";
                                  toDate = DateTime.now().toUtc().toString();

                                  datedController.text =
                                      "From Date\n${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight.toString()))}";
                                  _endDateController.text =
                                      "To Date\n${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now())}";
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Color(0xffee851c),
                                  ),
                                  child: Text(
                                    "WEEK",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ApplicationColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                style: Textstyle1.signupText1,
                                keyboardType: TextInputType.number,
                                controller: datedController,
                                maxLines: 2,
                                focusNode: AlwaysDisabledFocusNode(),
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  dateTimeSelect();
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "From Date",
                                  hintStyle: Textstyle1.signupText.copyWith(
                                    color: Colors.white,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                style: Textstyle1.signupText1,
                                maxLines: 2,
                                keyboardType: TextInputType.number,
                                controller: _endDateController,
                                focusNode: AlwaysDisabledFocusNode(),
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  endDateTimeSelect();
                                },
                                decoration: InputDecoration(
                                  hintStyle: Textstyle1.signupText.copyWith(
                                    color: Colors.white,
                                  ),
                                  hintText: "End Date",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _reportProvider.isDayWiseReportLoading
                        ? Center(
                            child: SpinKitThreeBounce(
                              color: ApplicationColors.redColor67,
                              size: 25,
                            ),
                          )
                        : _reportProvider.getDaywiseReportList.length == 0
                            ? Center(
                                child: Text(
                                  "${getTranslated(context, "day_wise_report_empty")}",
                                  textAlign: TextAlign.center,
                                  style: Textstyle1.text18.copyWith(
                                    fontSize: 18,
                                    color: ApplicationColors.redColor67,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollViewController,
                                physics: BouncingScrollPhysics(),
                                itemCount:
                                    _reportProvider.getDaywiseReportList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  String utcDate = _reportProvider
                                      .getDaywiseReportList[i]['Date'];
                                  DateTime utcDateTime = DateTime.parse(
                                          '$utcDate')
                                      .toLocal(); // Parse the UTC date string into a DateTime object and convert to local timezone
                                  String localDate = DateFormat('dd-MM-yyyy')
                                      .format(utcDateTime);

                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 20,
                                            bottom: 20),
                                        decoration: Boxdec.conrad6colorblack,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/car_icon.png",
                                                  width: 15,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  _reportProvider
                                                          .getDaywiseReportList[
                                                      i]['VRN'],
                                                  style: Textstyle1.text14bold,
                                                ),
                                                Expanded(
                                                    child: SizedBox(
                                                  width: 10,
                                                )),
                                                Text(localDate,
                                                    // DateFormat("MMM dd, yyyy").format(DateTime.parse(_reportProvider.getDaywiseReportList[i]['Date'],),
                                                    style: FontStyleUtilities.h12(
                                                        fontColor:
                                                            ApplicationColors
                                                                .black4240)),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            IntrinsicHeight(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: 15,
                                                              width: 15,
                                                              child: Center(
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/running_icon.png",
                                                                  width: 10,
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ApplicationColors
                                                                    .greenColor370,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: ApplicationColors
                                                                        .black4240,
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
                                                            const SizedBox(
                                                                width: 3),
                                                            Text(
                                                              'Running',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: FontStyleUtilities.h12(
                                                                  fontColor:
                                                                      ApplicationColors
                                                                          .black4240),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.5,
                                                          child: Text(
                                                              "${NumberFormat("##0.0#", "en_US").format(double.parse(_reportProvider.getDaywiseReportList[i]['Moving Time']))}",
                                                              style: FontStyleUtilities.hS12(
                                                                  fontColor:
                                                                      ApplicationColors
                                                                          .black4240),
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  VerticalDivider(
                                                    color: ApplicationColors
                                                        .textfieldBorderColor,
                                                    thickness: 1.5,
                                                    width: 0,
                                                    indent: 0,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height: 15,
                                                                width: 15,
                                                                child: Center(
                                                                    child: Image.asset(
                                                                        "assets/images/running_icon.png",
                                                                        width:
                                                                            10)),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ApplicationColors
                                                                      .redColor67,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: ApplicationColors
                                                                          .black4240,
                                                                      offset:
                                                                          Offset(
                                                                        5.0,
                                                                        5.0,
                                                                      ),
                                                                      blurRadius:
                                                                          10.0,
                                                                      spreadRadius:
                                                                          -8,
                                                                    ),
                                                                    //BoxShadow
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 3),
                                                              Text(
                                                                'Stop',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: true,
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: FontStyleUtilities.h12(
                                                                    fontColor:
                                                                        ApplicationColors
                                                                            .black4240),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.5,
                                                            child: Text(
                                                                _reportProvider
                                                                    .getDaywiseReportList[
                                                                        i][
                                                                        'Stoppage Time']
                                                                    .toString(),
                                                                style: FontStyleUtilities.hS12(
                                                                    fontColor:
                                                                        ApplicationColors
                                                                            .black4240),
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  VerticalDivider(
                                                    color: ApplicationColors
                                                        .textfieldBorderColor,
                                                    thickness: 1.5,
                                                    width: 0,
                                                    indent: 0,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height: 15,
                                                                width: 15,
                                                                child: Center(
                                                                    child: Image.asset(
                                                                        "assets/images/running_icon.png",
                                                                        width:
                                                                            10)),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ApplicationColors
                                                                      .yellowColorD21,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: ApplicationColors
                                                                          .black4240,
                                                                      offset:
                                                                          Offset(
                                                                        5.0,
                                                                        5.0,
                                                                      ),
                                                                      blurRadius:
                                                                          10.0,
                                                                      spreadRadius:
                                                                          -8,
                                                                    ),
                                                                    //BoxShadow
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 3),
                                                              Text(
                                                                'Idle',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: true,
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: FontStyleUtilities.h12(
                                                                    fontColor:
                                                                        ApplicationColors
                                                                            .black4240),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.5,
                                                            child: Text(
                                                              "${NumberFormat("##0.0#", "en_US").format(double.parse(_reportProvider.getDaywiseReportList[i]['Idle Time']))}",
                                                              style:
                                                                  FontStyleUtilities
                                                                      .hS12(
                                                                fontColor:
                                                                    ApplicationColors
                                                                        .black4240,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  VerticalDivider(
                                                    color: ApplicationColors
                                                        .textfieldBorderColor,
                                                    thickness: 1.5,
                                                    width: 0,
                                                    indent: 0,
                                                    endIndent: 0,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              bottom: 12),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Distance',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: true,
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    FontStyleUtilities
                                                                        .h12(
                                                                  fontColor:
                                                                      ApplicationColors
                                                                          .black4240,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.5,
                                                            child: Text(
                                                                double.parse(_reportProvider
                                                                        .getDaywiseReportList[i]
                                                                            [
                                                                            'Distance(Kms)']
                                                                        .toString())
                                                                    .toStringAsFixed(
                                                                        2),
                                                                style: FontStyleUtilities.hS12(
                                                                    fontColor:
                                                                        ApplicationColors
                                                                            .black4240),
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              color: ApplicationColors
                                                  .textfieldBorderColor,
                                              thickness: 1.5,
                                              endIndent: 0,
                                              height: 0,
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/red_rount_icon.png",
                                                  width: 10,
                                                  color: ApplicationColors
                                                      .greenColor370,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  _reportProvider
                                                              .dayWiseStartAddressList
                                                              .isEmpty ||
                                                          _reportProvider
                                                                      .dayWiseStartAddressList[
                                                                  i] ==
                                                              null
                                                      ? "Address Not Found"
                                                      : "${_reportProvider.dayWiseStartAddressList[i]}",
                                                  style: Textstyle1.text10,
                                                )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                    "assets/images/red_rount_icon.png",
                                                    width: 10,
                                                    color: ApplicationColors
                                                        .redColor67),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  _reportProvider
                                                              .dayWiseEndAddressList
                                                              .isEmpty ||
                                                          _reportProvider
                                                                      .dayWiseEndAddressList[
                                                                  i] ==
                                                              null
                                                      ? "Address Not Found"
                                                      : "${_reportProvider.dayWiseEndAddressList[i]}",
                                                  style: Textstyle1.text10,
                                                )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                },
                              ),
                  ),
                ),
              ],
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
        fromDate = fromDatePicked.toUtc().toIso8601String();

        //fromDate = datedController.text;
      });

      if (datedController.text != null && vehicleId != null) {
        getDayWiseReports();
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
        toDate = endDatePicked.toUtc().toIso8601String();
        // toDate = _endDateController.text;
      });

      if (_endDateController.text != null && vehicleId != "") {
        getDayWiseReports();
      }
    }
  }
}
