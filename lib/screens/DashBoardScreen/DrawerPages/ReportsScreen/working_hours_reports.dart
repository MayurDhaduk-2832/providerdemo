import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/custom_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkingHoursReports extends StatefulWidget {
  const WorkingHoursReports({Key key}) : super(key: key);

  @override
  _WorkingHoursReportsState createState() => _WorkingHoursReportsState();
}

class _WorkingHoursReportsState extends State<WorkingHoursReports> {
  var height, width;
  DateTime _selectedDate = DateTime.now();
  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  ReportProvider _reportProvider;

  UserProvider _userProvider;

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
  var toDate = DateTime.now().toString();
  var vehicleId = "";

  workingHoursReport() async {
    var idList = "";
    String list;
    if (_selectedVehicle.isNotEmpty) {
      for (int i = 0; i < _selectedVehicle.length; i++) {
        idList = idList + "${_selectedVehicle[i].deviceId},";
      }
    }

    list = idList.substring(0, idList.length - 1);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from_date": fromDate,
      "to_date": toDate,
      "_u": id,
      "device": list,
    };

    print('checkdata->$data');

    _userProvider.useModel.cust.digitalInput == 1
        ? _reportProvider.getAcReports(data, "notifs/acReportForMobile")
        : _reportProvider.workingHoursReport(
            data, "notifs/ignitionReportForMobile");
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
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _reportProvider.workingHoursReportList.clear();
    _reportProvider.acReportsList.clear();
    getDeviceByUserDropdown();
  }

  var exportType = "excel";

  List _selectedVehicle = [];

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        final _items = _reportProvider.userVehicleDropModel.devices
            .map((vehicle) =>
                MultiSelectItem<VehicleList>(vehicle, vehicle.deviceName))
            .toList();
        return MultiSelectDialog(
          items: _items,
          onConfirm: (values) {
            _selectedVehicle = values;
            if (_selectedVehicle.isNotEmpty) {
              workingHoursReport();
            }
            setState(() {});
          },
          closeSearchIcon: Icon(
            Icons.close,
            color: ApplicationColors.black4240,
          ),
          searchIcon: Icon(
            Icons.search,
            color: ApplicationColors.black4240,
          ),
          confirmText: Text(
            "${getTranslated(context, "apply_small_word")}",
            style: TextStyle(
                color: ApplicationColors.whiteColor,
                fontFamily: "Poppins-Regular",
                fontSize: 18),
          ),
          cancelText: Text(
            "${getTranslated(context, "cancel_small_word")}",
            style: TextStyle(
                color: ApplicationColors.whiteColor,
                fontFamily: "Poppins-Regular",
                fontSize: 18),
          ),
          searchHintStyle: TextStyle(
              color: ApplicationColors.black4240,
              fontFamily: "Poppins-Regular",
              fontSize: 14),
          searchable: true,
          title: Text(
            "${getTranslated(context, "search")}",
            style: TextStyle(
                color: ApplicationColors.black4240,
                fontFamily: "Poppins-Regular",
                fontSize: 14),
          ),
          backgroundColor: ApplicationColors.blackColor2E,
          selectedColor: ApplicationColors.redColor67,
          unselectedColor: ApplicationColors.textfieldBorderColor,
          searchTextStyle: TextStyle(
              color: ApplicationColors.black4240,
              fontFamily: "Poppins-SemiBold",
              fontSize: 15),
          itemsTextStyle: TextStyle(
              color: ApplicationColors.black4240,
              fontFamily: "Poppins-SemiBold",
              fontSize: 15),
          selectedItemsTextStyle: TextStyle(
              color: ApplicationColors.black4240,
              fontFamily: "Poppins-SemiBold",
              fontSize: 15),
          checkColor: ApplicationColors.redColor67,
          initialValue: _selectedVehicle,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    _userProvider = Provider.of<UserProvider>(context, listen: true);
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
          "${getTranslated(context, "working_hours_report")}",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Arial',
            color: ApplicationColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                                              if (_userProvider.useModel.cust
                                                      .digitalInput ==
                                                  1) {
                                                if ("vehicleId" != "") {
                                                  if (exportType == "pdf") {
                                                    List<String> sendList = [];
                                                    for (int i = 0;
                                                        i <
                                                            _reportProvider
                                                                .acReportsList
                                                                .length;
                                                        i++) {
                                                      sendList.add(""
                                                          "Device Name : ${_reportProvider.acReportsList[i].deviceName}  "
                                                          "\n\n"
                                                          'Working Hours : ${_reportProvider.acReportsList[i].workingHours.split(" ")[0]} : ${_reportProvider.acReportsList[i].workingHours.split(" ")[2]} Hr/Min'
                                                          "\n\n"
                                                          'Stop Hours : ${_reportProvider.acReportsList[i].stopHours.split(" ")[0]} : ${_reportProvider.acReportsList[i].stopHours.split(" ")[2]} Hr/Min'
                                                          "\n\n");
                                                    }

                                                    var idList = "";
                                                    String list;
                                                    if (_selectedVehicle
                                                        .isNotEmpty) {
                                                      for (int i = 0;
                                                          i <
                                                              _selectedVehicle
                                                                  .length;
                                                          i++) {
                                                        idList = idList +
                                                            "${_selectedVehicle[i].deviceName},\n";
                                                      }
                                                    }

                                                    list = idList.substring(
                                                        0, idList.length - 2);

                                                    if (sendList.isNotEmpty) {
                                                      generatePdf(
                                                          sendList, list);
                                                    } else {
                                                      Helper.dialogCall.showToast(
                                                          context,
                                                          "${getTranslated(context, "vehicle_report_is_empty")}");
                                                    }

                                                    // generatePdf(sendList,
                                                    //     "vehicleName");
                                                  } else {
                                                    List sendList = [];
                                                    for (int i = 0;
                                                        i <
                                                            _reportProvider
                                                                .acReportsList
                                                                .length;
                                                        i++) {
                                                      var data = {
                                                        "a":
                                                            "${_reportProvider.acReportsList[i].deviceName}",
                                                        "b":
                                                            '${_reportProvider.acReportsList[i].workingHours.split(" ")[0]} : ${_reportProvider.acReportsList[i].workingHours.split(" ")[2]} Hr/Min',
                                                        "c":
                                                            '${_reportProvider.acReportsList[i].stopHours.split(" ")[0]} : ${_reportProvider.acReportsList[i].stopHours.split(" ")[2]} Hr/Min',
                                                        "d": "",
                                                        "e": "",
                                                        "f": "",
                                                        "g": "",
                                                        "h": "",
                                                        "i": "",
                                                        "j": "",
                                                        "k": "",
                                                        "l": "",
                                                      };

                                                      sendList.add(data);
                                                    }

                                                    List excelTitle = [
                                                      'Device Name',
                                                      'Working Hours',
                                                      'Stop Hours',
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                    ];

                                                    if (sendList.isNotEmpty) {
                                                      generateExcel(
                                                          sendList,
                                                          "AcReport",
                                                          excelTitle);
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
                                              } else {
                                                if ("vehicleId" != "") {
                                                  if (exportType == "pdf") {
                                                    List<String> sendList = [];
                                                    for (int i = 0;
                                                        i <
                                                            _reportProvider
                                                                .workingHoursReportList
                                                                .length;
                                                        i++) {
                                                      sendList.add(""
                                                          "Device Name : ${_reportProvider.workingHoursReportList[i].deviceName}  "
                                                          "\n\n"
                                                          'Working Hours : ${_reportProvider.workingHoursReportList[i].workingHours.split(" ")[0]} : ${_reportProvider.workingHoursReportList[i].workingHours.split(" ")[2]} Hr/Min'
                                                          "\n\n"
                                                          'Stop Hours : ${_reportProvider.workingHoursReportList[i].stopHours.split(" ")[0]} : ${_reportProvider.workingHoursReportList[i].stopHours.split(" ")[2]} Hr/Min'
                                                          "\n\n");
                                                    }

                                                    var idList = "";
                                                    String list;
                                                    if (_selectedVehicle
                                                        .isNotEmpty) {
                                                      for (int i = 0;
                                                          i <
                                                              _selectedVehicle
                                                                  .length;
                                                          i++) {
                                                        idList = idList +
                                                            "${_selectedVehicle[i].deviceName},\n";
                                                      }
                                                    }

                                                    list = idList.substring(
                                                        0, idList.length - 1);

                                                    if (sendList.isNotEmpty) {
                                                      generatePdf(
                                                          sendList, list);
                                                    } else {
                                                      Helper.dialogCall.showToast(
                                                          context,
                                                          "${getTranslated(context, "vehicle_report_is_empty")}");
                                                    }
                                                    // generatePdf(sendList,
                                                    //     "vehicleName");
                                                  } else {
                                                    List sendList = [];
                                                    for (int i = 0;
                                                        i <
                                                            _reportProvider
                                                                .workingHoursReportList
                                                                .length;
                                                        i++) {
                                                      var data = {
                                                        "a":
                                                            "${_reportProvider.workingHoursReportList[i].deviceName}",
                                                        "b":
                                                            '${_reportProvider.workingHoursReportList[i].workingHours.split(" ")[0]} : ${_reportProvider.workingHoursReportList[i].workingHours.split(" ")[2]} Hr/Min',
                                                        "c":
                                                            '${_reportProvider.workingHoursReportList[i].stopHours.split(" ")[0]} : ${_reportProvider.workingHoursReportList[i].stopHours.split(" ")[2]} Hr/Min',
                                                        "d": "",
                                                        "e": "",
                                                        "f": "",
                                                        "g": "",
                                                        "h": "",
                                                        "i": "",
                                                        "j": "",
                                                        "k": "",
                                                        "l": "",
                                                      };

                                                      sendList.add(data);
                                                    }

                                                    List excelTitle = [
                                                      'Device Name',
                                                      'Working Hours',
                                                      'Stop Hours',
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                      "",
                                                    ];

                                                    if (sendList.isNotEmpty) {
                                                      generateExcel(
                                                          sendList,
                                                          "WorkingHoursReport",
                                                          excelTitle);
                                                    } else {
                                                      Helper.dialogCall.showToast(
                                                          context,
                                                          "${getTranslated(context, "vehicle_report_is_empty")}");
                                                    }
                                                  }
                                                  //  Navigator.pop(context);
                                                } else {
                                                  Helper.dialogCall.showToast(
                                                      context,
                                                      "${getTranslated(context, "select_vehicle")}");
                                                }
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
                  //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>GroupsScreen()));
                },
                child: Image.asset(
                  "assets/images/threen_verticle_options_icon.png",
                  color: ApplicationColors.whiteColor,
                  width: 30,
                )),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: _reportProvider.isDropDownLoading
          ? Helper.dialogCall.showLoader()
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 6),
                      InkWell(
                        onTap: () {
                          _showMultiSelect(context);
                        },
                        child: _selectedVehicle.isNotEmpty
                            ? Container(
                                alignment: Alignment.centerLeft,
                                height: 30,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedVehicle.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_selectedVehicle[index].deviceName}, ",
                                          style: TextStyle(
                                              color:
                                                  ApplicationColors.black4240,
                                              fontSize: 14,
                                              fontFamily: "Poppins-Regular",
                                              letterSpacing: 0.75),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Row(
                                children: [
                                  Text(
                                    "${getTranslated(context, "search_vehicle")}",
                                    style: TextStyle(
                                        color: ApplicationColors.black4240,
                                        fontSize: 15,
                                        fontFamily: "Poppins-Regular",
                                        letterSpacing: 0.75),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                ],
                              ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      SizedBox(height: 6),
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
                                var hour =
                                    DateTime.now().subtract(Duration(days: 31));
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
                                var yesterday =
                                    DateTime.now().subtract(Duration(days: 1));
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
                                var week =
                                    DateTime.now().subtract(Duration(days: 6));
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
                              maxLines: 2,
                              controller: datedController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                dateTimeSelect();
                              },
                              decoration: fieldStyle.copyWith(
                                fillColor: ApplicationColors.transparentColors,
                                isDense: true,
                                hintText: "From Date",
                                hintStyle: Textstyle1.signupText.copyWith(
                                  color: ApplicationColors.blackbackcolor,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              maxLines: 2,
                              style: Textstyle1.signupText1,
                              keyboardType: TextInputType.number,
                              controller: _endDateController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                endDateTimeSelect();
                              },
                              decoration: fieldStyle.copyWith(
                                fillColor: ApplicationColors.transparentColors,
                                isDense: true,
                                hintText: "To Date",
                                hintStyle: Textstyle1.signupText.copyWith(
                                  color: ApplicationColors.blackbackcolor,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _reportProvider.isWorkingHoursReportLoading
                        ? Helper.dialogCall.showLoader()
                        : _reportProvider.workingHoursReportList.isEmpty
                            ? Center(
                                child: Text(
                                  "${getTranslated(context, "working_hours_report_not_available")}",
                                  textAlign: TextAlign.center,
                                  style: Textstyle1.text18.copyWith(
                                    fontSize: 18,
                                    color: ApplicationColors.redColor67,
                                  ),
                                ),
                              )
                            : _userProvider.useModel.cust.digitalInput == 1
                                ? ListView.builder(
                                    // physics: BouncingScrollPhysics(),
                                    itemCount:
                                        _reportProvider.acReportsList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      var list =
                                          _reportProvider.acReportsList[i];
                                      return Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            decoration:
                                                Boxdec.conrad6colorblack,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/car_icon.png",
                                                      color: ApplicationColors
                                                          .redColor67,
                                                      width: 15,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          '${list.deviceName}',
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: Textstyle1
                                                              .text14bold),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: ApplicationColors
                                                      .dropdownColor3D,
                                                  thickness: 2,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/setting_icon_vehicle_lis.png",
                                                      width: 17,
                                                      color: ApplicationColors
                                                          .greenColor,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.30,
                                                          child: Text(
                                                            '${list.workingHours.split(" ")[0]} : ${list.workingHours.split(" ")[2]} Hr/Min',
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            maxLines: 2,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: Textstyle1
                                                                .text12bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${getTranslated(context, "engine_on_time")}",
                                                          style:
                                                              Textstyle1.text11,
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Image.asset(
                                                      "assets/images/setting_icon_vehicle_lis.png",
                                                      width: 17,
                                                      color: ApplicationColors
                                                          .redColor67,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.30,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${list.stopHours.split(" ")[0]} : ${list.stopHours.split(" ")[2]} Hr/Min',
                                                            style: Textstyle1
                                                                .text12bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            maxLines: 2,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          Text(
                                                            "${getTranslated(context, "engine_off_time")}",
                                                            style: Textstyle1
                                                                .text11,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: SizedBox(
                                                      width: 10,
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
                                    })
                                : ListView.builder(
                                    // physics: BouncingScrollPhysics(),
                                    itemCount: _reportProvider
                                        .workingHoursReportList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      var list = _reportProvider
                                          .workingHoursReportList[i];
                                      return Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            decoration:
                                                Boxdec.conrad6colorblack,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/car_icon.png",
                                                      color: ApplicationColors
                                                          .redColor67,
                                                      width: 15,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          '${list.deviceName}',
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: Textstyle1
                                                              .text14bold),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: ApplicationColors
                                                      .dropdownColor3D,
                                                  thickness: 2,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/setting_icon_vehicle_lis.png",
                                                      width: 17,
                                                      color: ApplicationColors
                                                          .greenColor,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.30,
                                                          child: Text(
                                                            '${list.workingHours.split(" ")[0]} : ${list.workingHours.split(" ")[2]} ${getTranslated(context, "Hr/Min")}',
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            maxLines: 2,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: Textstyle1
                                                                .text12bold
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        Text(
                                                          "${getTranslated(context, "engine_on_time")}",
                                                          style:
                                                              Textstyle1.text11,
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Image.asset(
                                                      "assets/images/setting_icon_vehicle_lis.png",
                                                      width: 17,
                                                      color: ApplicationColors
                                                          .redColor67,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.30,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${list.stopHours.split(" ")[0]} : ${list.stopHours.split(" ")[2]} ${getTranslated(context, "Hr/Min")}',
                                                            style: Textstyle1
                                                                .text12bold
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black),
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            maxLines: 2,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          Text(
                                                            "${getTranslated(context, "engine_off_time")}",
                                                            style: Textstyle1
                                                                .text11,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: SizedBox(
                                                      width: 10,
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
                                    }),
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
            dialogBackgroundColor: ApplicationColors.whiteColor,
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

      if (datedController.text.isNotEmpty && _selectedVehicle.length != 0) {
        workingHoursReport();
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

      if (_endDateController.text.isNotEmpty && _selectedVehicle.length != 0) {
        workingHoursReport();
      }
    }
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
                primary: ApplicationColors.blackColor2E,
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
