import 'dart:ui';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/get_all_geofence_model.dart';
import 'package:oneqlik/Provider/geofence_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeofenceReportScreen extends StatefulWidget {
  const GeofenceReportScreen({Key key}) : super(key: key);

  @override
  GeofenceReportScreenState createState() => GeofenceReportScreenState();
}

class GeofenceReportScreenState extends State<GeofenceReportScreen> {
  var height, width;
  DateTime _selectedDate = DateTime.now();
  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  ReportProvider _reportProvider;
  GeofencesProvider _geofencesProvider;

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

  var fromDate = DateTime.now().subtract(Duration(days: 1)).toString();
  var toDate = DateTime.now().toString();
  var geoID = "", geoName = "";

  getGeofenceReport() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data = {
      "from_date": fromDate,
      "to_date": toDate,
      "geoid": geoID,
      "_u": id,
    };

    print("check-->${data}");

    _reportProvider.geofenceReport(data, "notifsV2/GeoFencingReport");
  }

  getAllGeofence() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
    };
    _geofencesProvider.getAllGeofence(
        data, "geofencingV2/getallgeofence", "geo", context);
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
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: false);
    _reportProvider.geofenceReportList.clear();
    getAllGeofence();
  }

  var exportType = "excel";

  @override
  Widget build(BuildContext context) {
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: true);
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
          "${getTranslated(context, "geofence_report")}",
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
                                              if ("vehicleId" != "") {
                                                if (exportType == "pdf") {
                                                  List<String> sendList = [];
                                                  for (int i = 0;
                                                      i <
                                                          _reportProvider
                                                              .geofenceReportList
                                                              .length;
                                                      i++) {
                                                    sendList.add(""
                                                        'Vehicle Name : "${_reportProvider.geofenceReportList[i].vehicleName} "'
                                                        "\n\n"
                                                        'Direction : "${_reportProvider.geofenceReportList[i].direction}"'
                                                        "\n\n"
                                                        'Date : "${DateFormat("MMM dd,yyyy hh:mm aa").format(_reportProvider.geofenceAddressList[i].timestamp)}"'
                                                        "\n\n"
                                                        "Address : ${_reportProvider.geofenceAddressList[i]}"
                                                        "\n\n");
                                                  }

                                                  if (sendList.isNotEmpty) {
                                                    generatePdf(
                                                        sendList, geoName);
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
                                                              .geofenceReportList
                                                              .length;
                                                      i++) {
                                                    var data = {
                                                      "a":
                                                          "${_reportProvider.geofenceReportList[i].vehicleName} ",
                                                      "b":
                                                          "${_reportProvider.geofenceReportList[i].direction}",
                                                      "c":
                                                          "${DateFormat("MMM dd,yyyy hh:mm aa").format(_reportProvider.geofenceAddressList[i].timestamp)}",
                                                      "d":
                                                          "${_reportProvider.geofenceAddressList[i]}",
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
                                                    'Vehicle Name',
                                                    'Direction',
                                                    'Date',
                                                    'Address',
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
                                                    generateExcel(sendList,
                                                        geoName, excelTitle);
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
      body: Column(
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
                Theme(
                  data: ThemeData(
                    textTheme:
                        TextTheme(subtitle1: TextStyle(color: Colors.black)),
                  ),
                  child: DropdownSearch<Datum>(
                    popupBackgroundColor: ApplicationColors.blackColor2E,
                    mode: Mode.DIALOG,
                    showSearchBox: true,
                    showAsSuffixIcons: true,
                    dialogMaxWidth: width,
                    popupItemBuilder: (context, item, isSelected) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          item.geoname,
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
                          color: ApplicationColors.whiteColor,
                          fontSize: 15,
                          fontFamily: "Poppins-Regular",
                          letterSpacing: 0.75),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: ApplicationColors.textfieldBorderColor,
                              width: 1,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: ApplicationColors.textfieldBorderColor,
                              width: 1,
                            )),
                        hintText:
                            "${getTranslated(context, "search_geofence")}",
                        hintStyle: TextStyle(
                            color: ApplicationColors.black4240,
                            fontSize: 15,
                            fontFamily: "Poppins-Regular",
                            letterSpacing: 0.75),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    dropdownSearchBaseStyle: TextStyle(
                        color: ApplicationColors.black4240,
                        fontSize: 15,
                        fontFamily: "Poppins-Regular",
                        letterSpacing: 0.75),
                    dropdownSearchDecoration: InputDecoration(
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
                      hintText: "${getTranslated(context, "search_geofence")}",
                      hintStyle: TextStyle(
                          color: ApplicationColors.black4240,
                          fontSize: 15,
                          fontFamily: "Poppins-Regular",
                          letterSpacing: 0.75),
                    ),
                    items: _geofencesProvider.getAllGeofenceList,
                    itemAsString: (Datum u) => u.geoname,
                    onChanged: (Datum data) {
                      setState(() {
                        print(data.id);
                        geoID = data.id;
                        geoName = data.geoname;
                        getGeofenceReport();
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
                          DateTime now =
                              DateTime.now(); // get the current date and time
                          DateTime dateAtMidnight = DateTime(now.year,
                              now.month, now.day); // set the time to 12:00 am

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
                              yesterday.year, yesterday.month, yesterday.day);
                          fromDate = dateAtMidnight.toUtc().toString();
                          DateTime now = DateTime.now();
                          var yesterday1 = now.subtract(Duration(days: 1));
                          var yesterdayMidnightUtc = DateTime.utc(
                              yesterday.year, yesterday.month, yesterday.day);
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
                          var week = DateTime.now().subtract(Duration(days: 6));
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
                        maxLines: 2,
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
                              _selectedDate = newSelectedDate;
                              // initializeDateFormatting('es');
                              datedController
                                ..text =
                                    "From Date\n${DateFormat("dd-MMM-yyyy hh:mm a").format(_selectedDate)}"
                                ..selection = TextSelection.fromPosition(
                                    TextPosition(
                                        offset:
                                            currentdateController.text.length,
                                        affinity: TextAffinity.upstream));
                            });
                            fromDate = newSelectedDate.toString();
                            getGeofenceReport();
                          }
                        },
                        decoration: fieldStyle.copyWith(
                          fillColor: ApplicationColors.transparentColors,
                          isDense: true,
                          hintText: "From Date",
                          hintStyle: Textstyle1.text14.copyWith(
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
                    Expanded(
                      child: TextFormField(
                        maxLines: 2,
                        readOnly: true,
                        style: Textstyle1.signupText1,
                        keyboardType: TextInputType.number,
                        controller: _endDateController,
                        focusNode: AlwaysDisabledFocusNode(),
                        onTap: () async {
                          FocusScope.of(context).unfocus();

                          DateTime newSelectedDate =
                              await _selecttoDate(context);
                          if (newSelectedDate != null) {
                            setState(() {
                              _selectedDate = newSelectedDate;
                              //initializeDateFormatting('es');
                              _endDateController
                                ..text =
                                    "To Date\n${DateFormat("dd-MMM-yyyy hh:mm a").format(_selectedDate)}"
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(
                                    offset: currentdateController.text.length,
                                    affinity: TextAffinity.upstream,
                                  ),
                                );
                            });
                            toDate = newSelectedDate.toString();
                            getGeofenceReport();
                          }
                        },
                        decoration: fieldStyle.copyWith(
                          fillColor: ApplicationColors.transparentColors,
                          isDense: true,
                          hintText: "To Date",
                          hintStyle: Textstyle1.text14.copyWith(
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
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _reportProvider.isGeofenceReportLoading ||
                      _geofencesProvider.isGeofenceLoading
                  ? Helper.dialogCall.showLoader()
                  : _reportProvider.geofenceReportList.length == 0
                      ? Center(
                          child: Text(
                            "${getTranslated(context, "geofence_report_not_available")}",
                            textAlign: TextAlign.center,
                            style: Textstyle1.text18.copyWith(
                              fontSize: 18,
                              color: ApplicationColors.redColor67,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: _reportProvider.geofenceReportList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            var getGeofenceReportDetails =
                                _reportProvider.geofenceReportList[i];
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20),
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
                                            "${getGeofenceReportDetails.vehicleName}",
                                            style: Textstyle1.text14bold,
                                          ),
                                          Expanded(
                                              child: SizedBox(
                                            width: 10,
                                          )),
                                          Text(
                                            "${getGeofenceReportDetails.direction}",
                                            style: Textstyle1.text12,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Image.asset(
                                            getGeofenceReportDetails
                                                        .direction ==
                                                    "Out"
                                                ? "assets/images/out_ic.png"
                                                : "assets/images/in_ic.png",
                                            width: 15,
                                            height: 15,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/clock_icon_vehicle_Page.png",
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            DateFormat("MMM dd,yyyy hh:mm aa")
                                                .format(getGeofenceReportDetails
                                                    .timestamp),
                                            style: Textstyle1.text10,
                                          ),
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
                                            color:
                                                ApplicationColors.greenColor370,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                            _reportProvider.geofenceAddressList
                                                        .isEmpty ||
                                                    _reportProvider
                                                                .geofenceAddressList[
                                                            i] ==
                                                        null
                                                ? "Address Not Found"
                                                : "${_reportProvider.geofenceAddressList[i]}",
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
                          }),
            ),
          ),
        ],
      ),
    );
  }

  _selecttDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        // firstDate: DateTime.now().subtract(Duration(days: 10)),
        firstDate: DateTime(2015),
        lastDate: DateTime.now(),
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

  _selecttoDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        // firstDate: DateTime.now().subtract(Duration(days: 10)),
        firstDate: DateTime(2015),
        lastDate: DateTime.now(),
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
