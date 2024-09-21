import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/custom_dialog.dart';
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

class IdleReportScreen extends StatefulWidget {
  const IdleReportScreen({Key key}) : super(key: key);

  @override
  IdleReportScreenState createState() => IdleReportScreenState();
}

class IdleReportScreenState extends State<IdleReportScreen> {
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

  idleReport() async {
    var idList = "";
    String list;
    if (_selectedVehicle.isNotEmpty) {
      for (int i = 0; i < _selectedVehicle.length; i++) {
        idList = idList + "${_selectedVehicle[i].id},";
      }
    }

    list = idList.substring(0, idList.length - 1);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "device": list,
      "from": fromDate.toString(),
      "to": toDate.toString(),
      "time": "300000",
      "_u": id
    };

    print(data);
    _reportProvider.idleReport(data, "stoppage/idleReport");
  }

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
              idleReport();
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

  var exportType = "excel";

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
    _reportProvider.getIdleReportList.clear();
    _reportProvider.isIdleReportLoading = false;
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
          "${getTranslated(context, "idle_report")}",
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
                                              if (_selectedVehicle.isNotEmpty) {
                                                if (exportType == "pdf") {
                                                  List<String> sendList = [];
                                                  for (int i = 0;
                                                      i <
                                                          _reportProvider
                                                              .getIdleReportList
                                                              .length;
                                                      i++) {
                                                    var getIdleReportDetails =
                                                        _reportProvider
                                                            .getIdleReportList[i];
                                                    var time;
                                                    var avTime = DateFormat(
                                                            "HH:mm")
                                                        .format(DateTime.parse(
                                                            getIdleReportDetails
                                                                .startTime
                                                                .toString()));
                                                    var dvTime = DateFormat(
                                                            "HH:mm")
                                                        .format(DateTime.parse(
                                                            getIdleReportDetails
                                                                .endTime
                                                                .toString()));
                                                    var format =
                                                        DateFormat("HH:mm");
                                                    var one =
                                                        format.parse(avTime);
                                                    var two =
                                                        format.parse(dvTime);
                                                    time = two.difference(one);

                                                    sendList.add(""
                                                        "Device Name : ${getIdleReportDetails.device.deviceName}  "
                                                        "\n"
                                                        "Date : ${DateFormat("dd MMM yyyy").format(DateTime.parse(getIdleReportDetails.startTime.toString()))}"
                                                        "  ${DateFormat.jm().format(DateTime.parse(
                                                      getIdleReportDetails
                                                          .startTime
                                                          .toString(),
                                                    ))}"
                                                        "\n"
                                                        "${time.toString().split(":").first} Hr : ${time.toString().split(":")[1]} Min"
                                                        "\n "
                                                        "Address : ${_reportProvider.getIdleReportAddressList[i]}");
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
                                                    generatePdf(sendList, list);
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
                                                              .getIdleReportList
                                                              .length;
                                                      i++) {
                                                    var getIdleReportDetails =
                                                        _reportProvider
                                                            .getIdleReportList[i];
                                                    var time;
                                                    var avTime = DateFormat(
                                                            "HH:mm")
                                                        .format(DateTime.parse(
                                                            getIdleReportDetails
                                                                .startTime
                                                                .toString()));
                                                    var dvTime = DateFormat(
                                                            "HH:mm")
                                                        .format(DateTime.parse(
                                                            getIdleReportDetails
                                                                .endTime
                                                                .toString()));
                                                    var format =
                                                        DateFormat("HH:mm");
                                                    var one =
                                                        format.parse(avTime);
                                                    var two =
                                                        format.parse(dvTime);
                                                    time = two.difference(one);

                                                    var data = {
                                                      "a":
                                                          "${getIdleReportDetails.device.deviceName}",
                                                      "b": "${DateFormat("dd MMM yyyy").format(DateTime.parse(getIdleReportDetails.startTime.toString()))}"
                                                          " ${DateFormat.jm().format(DateTime.parse(getIdleReportDetails.startTime.toString()))}",
                                                      "c":
                                                          "${time.toString().split(":").first} Hr : ${time.toString().split(":")[1]} Min",
                                                      "d":
                                                          "${_reportProvider.getIdleReportAddressList[i]}",
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
                                                    'Time',
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
                  width: 30,
                  color: ApplicationColors.whiteColor,
                )),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
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
                  SizedBox(height: 10),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${_selectedVehicle[index].deviceName}, ",
                                      style: TextStyle(
                                          color: ApplicationColors.black4240,
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
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
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
            Container(
              height: height * 0.73,
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _reportProvider.isIdleReportLoading
                    ? Helper.dialogCall.showLoader()
                    : _reportProvider.getIdleReportList.isEmpty
                        ? Center(
                            child: Text(
                              "${getTranslated(context, "idle_report_not_available")}",
                              textAlign: TextAlign.center,
                              style: Textstyle1.text18.copyWith(
                                fontSize: 18,
                                color: ApplicationColors.redColor67,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _reportProvider.getIdleReportList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              var getIdleReportDetails =
                                  _reportProvider.getIdleReportList[i];
                              var time;
                              if (getIdleReportDetails.startTime != null &&
                                  getIdleReportDetails.endTime != null) {
                                var avTime = DateFormat("HH:mm").format(
                                    DateTime.parse(getIdleReportDetails
                                        .startTime
                                        .toLocal()
                                        .toString()));
                                var dvTime = DateFormat("HH:mm").format(
                                    DateTime.parse(getIdleReportDetails.endTime
                                        .toLocal()
                                        .toString()));
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
                                                width: 15,
                                                color: ApplicationColors
                                                    .redColor67),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${getIdleReportDetails.device.deviceName}",
                                              overflow: TextOverflow.visible,
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              style: Textstyle1.text14bold,
                                            ),
                                            Expanded(child: SizedBox()),
                                            Text(
                                              "${getTranslated(context, "idle")}",
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.visible,
                                              maxLines: 1,
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
                                                width: 10,
                                                color: ApplicationColors
                                                    .redColor67),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              DateFormat("dd MMM yyyy").format(
                                                  DateTime.parse(
                                                      getIdleReportDetails
                                                          .startTime
                                                          .toLocal()
                                                          .toString())),
                                              style: Textstyle1.text10,
                                            ),
                                            Text(
                                              "  ${DateFormat.jm().format(DateTime.parse(getIdleReportDetails.startTime.toLocal().toString()))}",
                                              style: Textstyle1.text10,
                                            ),
                                            Expanded(
                                                child: SizedBox(
                                              width: 10,
                                            )),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4, vertical: 2),
                                              decoration:
                                                  Boxdec.buttonBoxDecRed_r6,
                                              child: Center(
                                                child: Text(
                                                  "${time.toString().split(":").first} Hr : ${time.toString().split(":")[1]} Min",
                                                  style: Textstyle1.text10,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                            .getIdleReportAddressList
                                                            .isEmpty ||
                                                        _reportProvider
                                                                    .getIdleReportAddressList[
                                                                i] ==
                                                            null
                                                    ? "Address Not Found"
                                                    : "${_reportProvider.getIdleReportAddressList[i]}",
                                                overflow: TextOverflow.visible,
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
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
        idleReport();
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
        idleReport();
      }
    }
  }
}
