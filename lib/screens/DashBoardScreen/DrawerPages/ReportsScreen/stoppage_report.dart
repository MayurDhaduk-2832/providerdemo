import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/ProductsFilterPage/vehicle_filter.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class StoppageReportScreen extends StatefulWidget {
  const StoppageReportScreen({Key key}) : super(key: key);

  @override
  _StoppageReportScreenState createState() => _StoppageReportScreenState();
}

class _StoppageReportScreenState extends State<StoppageReportScreen> {
  var height, width;
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
  var toDate = DateTime.now().toString();
  var vehicleId = "", vehicleName = "";

  stoppageReport() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from_date": fromDate.toString(),
      "to_date": toDate.toString(),
      "vname": vehicleId,
      "_u": id,
    };

    print(data);
    _reportProvider.stoppageReport(data, "stoppage/stoppageReport");
  }

  var exportType = "excel";

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
          "From Date\n${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}";
    _endDateController = TextEditingController()
      ..text =
          "To Date\n${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}";
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _reportProvider.stoppageReportList.clear();
    _reportProvider.isStoppageLoading = false;
    getDeviceByUserDropdown();
  }

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
          "${getTranslated(context, "stoppage_report")}",
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
                                              if (vehicleId != "") {
                                                if (exportType == "pdf") {
                                                  List<String> sendList = [];
                                                  for (int i = 0;
                                                      i <
                                                          _reportProvider
                                                              .stoppageReportList
                                                              .length;
                                                      i++) {
                                                    var time;
                                                    var avTime = DateFormat(
                                                            "HH:mm")
                                                        .format(DateTime.parse(
                                                      _reportProvider
                                                              .stoppageReportList[
                                                          i]['arrival_time'],
                                                    ));
                                                    var dvTime = DateFormat(
                                                            "HH:mm")
                                                        .format(DateTime.parse(
                                                      _reportProvider
                                                              .stoppageReportList[
                                                          i]['departure_time'],
                                                    ));
                                                    var format =
                                                        DateFormat("HH:mm");
                                                    var one =
                                                        format.parse(avTime);
                                                    var two =
                                                        format.parse(dvTime);
                                                    time = two.difference(one);

                                                    sendList.add(""
                                                        "Device Name : ${_reportProvider.stoppageReportList[i]['device']['Device_Name']}  "
                                                        "\n\n"
                                                        "Arrival Time : ${DateFormat("dd MMM yyyy").format(DateTime.parse(
                                                      _reportProvider
                                                              .stoppageReportList[
                                                          i]['arrival_time'],
                                                    ))}"
                                                        "  ${DateFormat.jm().format(DateTime.parse(
                                                      _reportProvider
                                                              .stoppageReportList[
                                                          i]['arrival_time'],
                                                    ))},"
                                                        "\n"
                                                        "${time.toString().split(":").first} Hr : ${time.toString().split(":")[1]} Min"
                                                        "\n\n"
                                                        "Address : ${_reportProvider.stoppageAddressList[i]}");
                                                  }

                                                  if (sendList.isNotEmpty) {
                                                    generatePdf(
                                                        sendList, vehicleName);
                                                  } else {
                                                    Helper.dialogCall.showToast(
                                                        context,
                                                        "${getTranslated(context, "vehicle_report_is_empty")}");
                                                  }
                                                  // generatePdf(sendList,vehicleName);
                                                } else {
                                                  List sendList = [];
                                                  for (int i = 0;
                                                      i <
                                                          _reportProvider
                                                              .stoppageReportList
                                                              .length;
                                                      i++) {
                                                    var time;
                                                    var avTime = DateFormat(
                                                            "HH:mm")
                                                        .format(DateTime.parse(
                                                      _reportProvider
                                                              .stoppageReportList[
                                                          i]['arrival_time'],
                                                    ));
                                                    var dvTime = DateFormat(
                                                            "HH:mm")
                                                        .format(DateTime.parse(
                                                      _reportProvider
                                                              .stoppageReportList[
                                                          i]['departure_time'],
                                                    ));
                                                    var format =
                                                        DateFormat("HH:mm");
                                                    var one =
                                                        format.parse(avTime);
                                                    var two =
                                                        format.parse(dvTime);
                                                    time = two.difference(one);

                                                    var data = {
                                                      "a":
                                                          "${_reportProvider.stoppageReportList[i]['device']['Device_Name']}",
                                                      "b": "${DateFormat("dd MMM yyyy").format(DateTime.parse(
                                                        _reportProvider
                                                                .stoppageReportList[
                                                            i]['arrival_time'],
                                                      ))}"
                                                          " ${DateFormat.jm().format(DateTime.parse(
                                                        _reportProvider
                                                                .stoppageReportList[
                                                            i]['arrival_time'],
                                                      ))}",
                                                      "c":
                                                          "${time.toString().split(":").first} Hr : ${time.toString().split(":")[1]} Min",
                                                      "d":
                                                          "${_reportProvider.stoppageAddressList[i]}",
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
                                                    'Date',
                                                    'time',
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
                                                    generateExcel(
                                                        sendList,
                                                        vehicleName,
                                                        excelTitle);
                                                  } else {
                                                    Helper.dialogCall.showToast(
                                                        context,
                                                        "${getTranslated(context, "vehicle_report_is_empty")}");
                                                  }
                                                  // generateExcel(sendList,vehicleName,excelTitle);
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
      body: _reportProvider.isDropDownLoading
          ? Helper.dialogCall.showLoader()
          : SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: ApplicationColors.blackColor2E,
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 2),
                        ]),
                    //height: height*.074,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                hintText:
                                    "${getTranslated(context, "search_vehicle")}",
                                hintStyle: TextStyle(
                                    color: ApplicationColors.black4240,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              items:
                                  _reportProvider.userVehicleDropModel.devices,
                              itemAsString: (VehicleList u) => u.deviceName,
                              onChanged: (VehicleList data) {
                                setState(() {
                                  vehicleId = data.id;
                                  vehicleName = data.deviceName;
                                  stoppageReport();
                                });
                              },
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          SizedBox(height: 10),
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

                                    fromDate =
                                        dateAtMidnight.toUtc().toString();
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
                                    fromDate =
                                        dateAtMidnight.toUtc().toString();
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
                                    DateTime dateAtMidnight = DateTime(
                                        week.year, week.month, week.day);
                                    fromDate =
                                        dateAtMidnight.toUtc().toString();
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
                          SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  maxLines: 2,
                                  style: Textstyle1.signupText1,
                                  keyboardType: TextInputType.number,
                                  controller: datedController,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    dateTimeSelect();
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "From Date",
                                    hintStyle: Textstyle1.signupText1,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
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
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
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
                  Container(
                    height: height * 0.73,
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _reportProvider.isStoppageLoading
                          ? Helper.dialogCall.showLoader()
                          : _reportProvider.stoppageReportList.isEmpty
                              ? Center(
                                  child: Text(
                                    "${getTranslated(context, "stoppage_report_not_available")}",
                                    textAlign: TextAlign.center,
                                    style: Textstyle1.text18.copyWith(
                                      fontSize: 18,
                                      color: ApplicationColors.redColor67,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      _reportProvider.stoppageReportList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    var time;
                                    if (_reportProvider.stoppageReportList[i]
                                                ['arrival_time'] !=
                                            null &&
                                        _reportProvider.stoppageReportList[i]
                                                ['departure_time'] !=
                                            null) {
                                      var avTime = DateFormat("HH:mm")
                                          .format(DateTime.parse(
                                        _reportProvider.stoppageReportList[i]
                                            ['arrival_time'],
                                      ));
                                      var dvTime = DateFormat("HH:mm")
                                          .format(DateTime.parse(
                                        _reportProvider.stoppageReportList[i]
                                            ['departure_time'],
                                      ));
                                      var format = DateFormat("HH:mm");
                                      var one = format.parse(avTime);
                                      var two = format.parse(dvTime);
                                      time = two.difference(one);
                                    }

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
                                                    color: ApplicationColors
                                                        .redColor67,
                                                    width: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    _reportProvider
                                                            .stoppageReportList[i]
                                                        [
                                                        'device']['Device_Name'],
                                                    style:
                                                        Textstyle1.text14bold,
                                                  ),
                                                  Expanded(
                                                      child: SizedBox(
                                                    width: 10,
                                                  )),
                                                  Text(
                                                    "${getTranslated(context, "stoppage")}",
                                                    style: Textstyle1.text10,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/clock_icon_vehicle_Page.png",
                                                    color: ApplicationColors
                                                        .redColor67,
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    DateFormat("dd MMM yyyy")
                                                        .format(DateTime.parse(
                                                      _reportProvider
                                                              .stoppageReportList[
                                                          i]['arrival_time'],
                                                    ).toLocal()),
                                                    style: Textstyle1.text10,
                                                  ),
                                                  Text(
                                                    "  ${DateFormat.jm().format(DateTime.parse(
                                                      _reportProvider
                                                              .stoppageReportList[
                                                          i]['arrival_time'],
                                                    ).toLocal())}",
                                                    style: Textstyle1.text10,
                                                  ),
                                                  Expanded(
                                                      child: SizedBox(
                                                    width: 10,
                                                  )),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4,
                                                            vertical: 2),
                                                    decoration: Boxdec
                                                        .buttonBoxDecRed_r6,
                                                    child: Center(
                                                      child: Text(
                                                        "${time.toString().split(":").first} ${getTranslated(context, "hr")}  : ${time.toString().split(":")[1]} ${getTranslated(context, "min")} ",
                                                        style: Textstyle1
                                                            .text10white,
                                                        overflow: TextOverflow
                                                            .visible,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  )
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
                                                        .redColor67,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      _reportProvider
                                                                  .stoppageAddressList
                                                                  .isEmpty ||
                                                              _reportProvider
                                                                          .stoppageAddressList[
                                                                      i] ==
                                                                  null
                                                          ? "Address Not Found"
                                                          : "${_reportProvider.stoppageAddressList[i]}",
                                                      style: Textstyle1.text10,
                                                    ),
                                                  ),
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
                  )
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
        fromDate = datedController.text;
      });

      if (vehicleId != null && datedController.text.isNotEmpty) {
        stoppageReport();
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

      if (vehicleId != null && _endDateController.text.isNotEmpty) {
        stoppageReport();
      }
    }
  }
}
