import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/rendering.dart';
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

class SosReportScreen extends StatefulWidget {
  const SosReportScreen({Key key}) : super(key: key);

  @override
  _SosReportScreenState createState() => _SosReportScreenState();
}

class _SosReportScreenState extends State<SosReportScreen> {
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

  getSosReportDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from_date": fromDate.toString(),
      "to_date": toDate.toString(),
      "_u": id,
      "dev_id": vehicleId,
    };

    print(data);
    _reportProvider.getSosReport(data, "notifs/SOSReport");
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
    _reportProvider.sosReportList.clear();
    _reportProvider.isSosReportLoading = false;
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
          "${getTranslated(context, "sos_report")}",
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
                                                              .sosReportList
                                                              .length;
                                                      i++) {
                                                    sendList.add(
                                                        "Vehicle Name : ${_reportProvider.sosReportList[i].vehicleName}"
                                                        "\n\n"
                                                        "TimeStamp : ${DateFormat("dd MMM yyyy").format(DateTime.parse(_reportProvider.sosReportList[i].timestamp.toString()))}"
                                                        "\n\n"
                                                        "Address : ${_reportProvider.sosReportAddressList[i].toString()}"
                                                        "\n\n");
                                                  }

                                                  if (sendList.isNotEmpty) {
                                                    generatePdf(
                                                        sendList, vehicleName);
                                                  } else {
                                                    Helper.dialogCall.showToast(
                                                        context,
                                                        "${getTranslated(context, "vehicle_report_is_empty")}");
                                                  }
                                                  // generatePdf(sendList,
                                                  //     vehicleName);
                                                } else {
                                                  List sendList = [];
                                                  for (int i = 0;
                                                      i <
                                                          _reportProvider
                                                              .sosReportList
                                                              .length;
                                                      i++) {
                                                    var data = {
                                                      "a":
                                                          "${_reportProvider.sosReportList[i].vehicleName}",
                                                      "b":
                                                          "${DateFormat("dd MMM yyyy").format(DateTime.parse(_reportProvider.sosReportList[i].timestamp.toString()))}",
                                                      "c":
                                                          "${_reportProvider.sosReportAddressList[i].toString()}",
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
                                                    'Name',
                                                    'TimeStamp',
                                                    'Address',
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
                                                        vehicleName,
                                                        excelTitle);
                                                  } else {
                                                    Helper.dialogCall.showToast(
                                                        context,
                                                        "${getTranslated(context, "vehicle_report_is_empty")}");
                                                  }
                                                  // generateExcel(
                                                  //     sendList,
                                                  //     vehicleName,
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
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 2,
                          )
                        ]),
                    //height: height*.074,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Column(
                        children: [
                          // vehicle dialog
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
                                        color: ApplicationColors
                                            .transparentColors)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ApplicationColors
                                            .transparentColors)),
                                hintText:
                                    "${getTranslated(context, "search_vehicle")}",
                                hintStyle: TextStyle(
                                    color: ApplicationColors.black4240,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ApplicationColors
                                            .transparentColors)),
                              ),
                              items:
                                  _reportProvider.userVehicleDropModel.devices,
                              itemAsString: (VehicleList u) => u.deviceName,
                              onChanged: (VehicleList data) {
                                setState(() {
                                  vehicleId = data.id;
                                  vehicleName = data.deviceName;
                                  getSosReportDetails();
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
                                    // setState(() {
                                    //   datedController.text = DateFormat("dd MMM yyyy").format(dateTimeSelect());
                                    // });
                                  },
                                  decoration: fieldStyle.copyWith(
                                    isDense: true,
                                    hintText: "From Date",
                                    hintStyle: Textstyle1.signupText1,
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
                                    hintStyle: Textstyle1.signupText1,
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

                          // multiple select
                          /*InkWell(
                      onTap: (){
                        _showMultiSelect(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: _selectedVehicle.isNotEmpty?8:12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: ApplicationColors.textfieldBorderColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                "assets/images/search_icon.png",
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _selectedVehicle.isNotEmpty
                                  ?
                              Container(
                                height: 30,
                                padding: EdgeInsets.only(top: 3),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedVehicle.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Text(
                                            "${_selectedVehicle[index].deviceName}, ",
                                            style:TextStyle(
                                                color: ApplicationColors.whiteColor,
                                                fontSize: 14,
                                                fontFamily: "Poppins-Regular",
                                                letterSpacing: 0.75
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                ),
                              )
                                  :
                              Text(
                                "Search vehicle",

                                style:TextStyle(
                                    color: ApplicationColors.whiteColor,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.73,
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _reportProvider.isSosReportLoading
                          ? Helper.dialogCall.showLoader()
                          : _reportProvider.sosReportList.isEmpty
                              ? Center(
                                  child: Text(
                                    "${getTranslated(context, "sos_report_not_available")}",
                                    textAlign: TextAlign.center,
                                    style: Textstyle1.text18.copyWith(
                                      fontSize: 18,
                                      color: ApplicationColors.redColor67,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      _reportProvider.sosReportList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    var list = _reportProvider.sosReportList[i];

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
                                                  Flexible(
                                                    child: Text(
                                                      "${list.vehicleName}",
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style:
                                                          Textstyle1.text14bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: SizedBox(
                                                    width: 10,
                                                  )),
                                                  Expanded(
                                                    child: Text(
                                                      "Sos Report",
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.end,
                                                      style: Textstyle1.text10,
                                                    ),
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
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    DateFormat("dd MMM yyyy")
                                                        .format(DateTime.parse(
                                                      list.timestamp.toString(),
                                                    )),
                                                    style: Textstyle1.text10,
                                                  ),
                                                  Text(
                                                    "  ${DateFormat.jm().format(DateTime.parse(
                                                      list.timestamp.toString(),
                                                    ))}",
                                                    style: Textstyle1.text10,
                                                  ),
                                                  Expanded(
                                                      child: SizedBox(
                                                    width: 10,
                                                  )),
                                                  /*  Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 7,
                                                  vertical: 5),
                                              decoration:
                                                  Boxdec.buttonBoxDecRed_r6,
                                              child: Center(
                                                child: Text(
                                                  "${time.toString().split(":").first} Hr : ${time.toString().split(":")[1]} Min",
                                                  // "${time.toString().split(":").first} Hr : ${time.toString().split(":")[1]} Min",
                                                  style: Textstyle1.text10,
                                                ),
                                              ),
                                            )*/
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
                                                                  .sosReportAddressList
                                                                  .isEmpty ||
                                                              _reportProvider
                                                                          .sosReportAddressList[
                                                                      i] ==
                                                                  null
                                                          ? "Address Not Found"
                                                          : "${_reportProvider.sosReportAddressList[i]}",
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
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
        getSosReportDetails();
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
        getSosReportDetails();
      }
    }
  }
}
