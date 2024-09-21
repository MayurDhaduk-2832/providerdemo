import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/custom_dialog.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DistanceReportScreen extends StatefulWidget {
  const DistanceReportScreen({Key key}) : super(key: key);

  @override
  DistanceReportScreenState createState() => DistanceReportScreenState();
}

class DistanceReportScreenState extends State<DistanceReportScreen> {
  var height, width;
  DateTime _selectedDate = DateTime.now();
  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  ReportProvider _reportProvider;
  UserProvider _userProvider;
  var exportType = "excel";

  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toString();

  distanceReport() async {
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
      "from": fromDate,
      "to": toDate,
      // "from":"2022-02-21T18:30:00.838Z",
      // "to":"2022-02-22T18:29:59.838Z",
      "user": id,
      "skip": "0",
      "device": list,
    };

    _reportProvider.distanceReport(data, "summary/distance");
  }

  @override
  void initState() {
    super.initState();
    datedController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy").format(DateTime.now())}";
    _endDateController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy").format(DateTime.now())}";
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _reportProvider.distancelastAddressList.clear();
    _reportProvider.distancestartAddressList.clear();
    _reportProvider.distanceReportList.clear();
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
              distanceReport();
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ApplicationColors.whiteColorF9
            /*color: ApplicationColors.whiteColorF9*/
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 10, left: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset("assets/images/vector_icon.png",color:ApplicationColors.redColor67 ,),
              ),
            ),
            title: Text(
              "${getTranslated(context, "distance_report")}",
              style: Textstyle1.appbartextstyle1,
            ),
            backgroundColor: ApplicationColors.blackColor2E,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, bottom: 20, top: 20, right: 0),
                child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
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
                                          color:
                                              ApplicationColors.dropdownColor3D,
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
 style: Textstyle1.text14boldwhite.copyWith(fontSize: 12),
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
                                                      List<String> sendList =
                                                          [];
                                                      for (int i = 0;
                                                          i <
                                                              _reportProvider
                                                                  .distanceReportList
                                                                  .length;
                                                          i++) {
                                                        sendList.add(""
                                                            "Device Name : ${_reportProvider.distanceReportList[i]['device']['Device_Name']}  "
                                                            "\n\n"
                                                            "Date : ${DateFormat("MMM dd, yyyy").format(DateTime.parse(_reportProvider.distanceReportList[i]['device']['expiration_date']))}"
                                                            "\n\n"
                                                            "Distance : ${NumberFormat("##0.0#", "en_US").format(_reportProvider.distanceReportList[0]['distance'])}Km"
                                                            "\n\n"
                                                            "Start Address : ${_reportProvider.distancestartAddressList[i]}"
                                                            "\n\n"
                                                            "Last Address : ${_reportProvider.distancelastAddressList[i]}");
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
                                                            "${getTranslated(context, "vehicle_report_is_empty")}"
                                                        );
                                                      }
                                                    } else {
                                                      List sendList = [];
                                                      for (int i = 0;
                                                          i <
                                                              _reportProvider
                                                                  .distanceReportList
                                                                  .length;
                                                          i++) {
                                                        var data = {
                                                          "a":
                                                              "${_reportProvider.distanceReportList[i]['device']['Device_Name']}",
                                                          "b":
                                                              "${DateFormat("MMM dd, yyyy").format(
                                                            DateTime.parse(_reportProvider
                                                                        .distanceReportList[
                                                                    i]['device']
                                                                [
                                                                'expiration_date']),
                                                          )}",
                                                          "c":
                                                              "${NumberFormat("##0.0#", "en_US").format(_reportProvider.distanceReportList[i]['distance'])}Km}",
                                                          "d":
                                                              "${_reportProvider.distancestartAddressList[i]}",
                                                          "e":
                                                              "${_reportProvider.distancelastAddressList[i]}",
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
                                                        'Distance',
                                                        'Start Address',
                                                        "Last Address",
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
                                                            "DistanceReport",
                                                            excelTitle);
                                                      } else {
                                                        Helper.dialogCall.showToast(
                                                            context,
                                                            "${getTranslated(context, "vehicle_report_is_empty")}"
                                                        );
                                                      }

                                                    }
                                                    //  Navigator.pop(context);
                                                  } else {
                                                    Helper.dialogCall.showToast(
                                                        context,
                                                        "${getTranslated(context, "select_vehicle")}"
                                                    );
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
 style: Textstyle1.text14boldwhite.copyWith(fontSize: 12),
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
                      color:ApplicationColors.redColor67 ,
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
                decoration:
                    BoxDecoration(color: ApplicationColors.blackColor2E),
                //height: height*.074,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,15),
                  child: Column(
                    children: [
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
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                dateTimeSelect();
                              },
                              decoration: fieldStyle.copyWith(
                                isDense: true,
                                hintText: "From Date",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Image.asset(
                                    "assets/images/date_icon.png",
                                    color:ApplicationColors.redColor67 ,
                                    width: 5,
                                    height: 5,
                                  ),
                                ),
                                hintStyle: Textstyle1.signupText.copyWith(
                                  color: Colors.white,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Center(
                              child: Text(
                                "${getTranslated(context,"to")}",
                                style: Textstyle1.signupText
                                    .copyWith(color: Colors.black),
                              ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              style: Textstyle1.signupText1,
                              keyboardType: TextInputType.number,
                              controller: _endDateController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                endDateTimeSelect();
                              },
                              decoration: fieldStyle.copyWith(
                                hintStyle: Textstyle1.signupText.copyWith(
                                  color: Colors.white,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Image.asset(
                                    "assets/images/date_icon.png",
                                    width: 5,
                                    height: 5,
                                    color:ApplicationColors.redColor67 ,
                                  ),
                                ),
                                hintText: "End Date",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          _showMultiSelect(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
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
                                color:ApplicationColors.redColor67 ,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: _selectedVehicle.isNotEmpty
                                    ? Container(
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
                                            style: TextStyle(
                                                color: ApplicationColors
                                                    .black4240,
                                                fontSize: 14,
                                                fontFamily:
                                                "Poppins-Regular",
                                                letterSpacing: 0.75),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                                    : Text(
                                  "${getTranslated(context, "search_vehicle")}",
                                  style: TextStyle(
                                      color: ApplicationColors.whiteColor,
                                      fontSize: 15,
                                      fontFamily: "Poppins-Regular",
                                      letterSpacing: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(

                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _reportProvider.isDistanceReportLoading
                      ? Center(
                          child: SpinKitThreeBounce(
                            color: ApplicationColors.redColor67,
                            size: 25,
                          ),
                        )
                      : _reportProvider.distanceReportList.length == 0
                          ? Center(
                              child: Text(
                                "${getTranslated(context,"distance_report_not_available")}",
                                textAlign: TextAlign.center,
                                style: Textstyle1.text18.copyWith(
                                  fontSize: 18,
                                  color: ApplicationColors.redColor67,
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  _reportProvider.distanceReportList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/car_icon.png",color: ApplicationColors.redColor67,
                                                width: 15,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                _reportProvider
                                                        .distanceReportList[i]
                                                    ['device']['Device_Name'],
                                                style: Textstyle1.text14bold,
                                              ),
                                              Expanded(
                                                  child: SizedBox(
                                                width: 10,
                                              )),
                                              Text(
                                                  "${getTranslated(context, "distance")}",
                                                  textAlign: TextAlign.center,
                                                  style: FontStyleUtilities.h11(
                                                      fontColor:
                                                          ApplicationColors
                                                              .black4240)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(
                                                  // vehicle_time[i],
                                                  "${DateFormat("MMM dd, yyyy").format(
                                                    DateTime.parse(_reportProvider
                                                                .distanceReportList[
                                                            i]['device']
                                                        ['expiration_date']),
                                                  )}",
                                                  style: Textstyle1.text11),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 7,
                                                    vertical: 7),
                                                decoration:
                                                    Boxdec.buttonBoxDecRed_r6,
                                                child: Center(
                                                  child: Text(
                                                      "${NumberFormat("##0.0#", "en_US").format(_reportProvider.distanceReportList[i]['distance'])} ""${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "Km" : "Miles"}",
                                                      style: FontStyleUtilities.hS12(
                                                          fontColor:
                                                              ApplicationColors
                                                                  .whiteColor)),
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
                                                    .greenColor370,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                    _reportProvider
                                                        .distancestartAddressList.isEmpty
                                                        ||
                                                    _reportProvider
                                                        .distancestartAddressList[i] == null
                                                        ?
                                                        "Address Not Found"
                                                        :
                                                "${_reportProvider.distancestartAddressList[i]}",
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.visible,
                                                textAlign: TextAlign.start,
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
                                                        .distancelastAddressList.isEmpty
                                                    ||
                                                    _reportProvider
                                                        .distancelastAddressList[i] == null
                                                        ?
                                                        "Address Not found"
                                                        :
                                                   "${_reportProvider.distancelastAddressList[i]}",
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.visible,
                                                textAlign: TextAlign.start,
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
        ),
      ],
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
            "${DateFormat("dd MMM yyyy hh:mm aa").format(fromDatePicked)}";
        fromDate = datedController.text;
      });

      if (datedController.text.isNotEmpty && _selectedVehicle.length != 0) {
        distanceReport();
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
            "${DateFormat("dd MMM yyyy hh:mm aa").format(endDatePicked)}";
        toDate = _endDateController.text;
      });

      if (_endDateController.text.isNotEmpty && _selectedVehicle.length != 0) {
        distanceReport();
      }
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
