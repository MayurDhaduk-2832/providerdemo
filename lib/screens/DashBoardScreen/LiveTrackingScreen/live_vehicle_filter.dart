import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/vehicle_list_model.dart';
import '../../../Provider/vehicle_list_provider.dart';
import '../../../utils/utils.dart';
import '../LiveForVehicleScreen/live_for_vehicle_screen.dart';

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

class LiveVehicleFilter extends StatefulWidget {
  const LiveVehicleFilter({Key key}) : super(key: key);

  @override
  _LiveVehicleFilterState createState() => _LiveVehicleFilterState();
}

class _LiveVehicleFilterState extends State<LiveVehicleFilter> {
  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toUtc().toString();

  FocusNode focusNode = FocusNode();
  VehicleListProvider vehicleListProvider;

  List sendIdList = [];
  List sendVehicleList = [];

  var vehicleId = "";

  String selected = 'categories';
  var chooseLocation;
  int selecttype = 1;

  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = TextEditingController();
  TextEditingController _selectVehicleContoller = TextEditingController();

  final _debouncer = Debouncer(milliseconds: 100);

  FocusNode formDateFocus = FocusNode();
  FocusNode toDateFocus = FocusNode();

  ReportProvider _reportProvider;

  bool isLoading = false;
  List selectedVehicleIdList = [];

  getDeviceByUserDropdown() async {
    setState(() {
      isLoading = true;
      sendIdList.clear();
      print("send List ==> ${sendIdList.length}");
    });
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
      for (int i = 0; i < _reportProvider.searchVehicleList.length; i++) {
        print("print bool index $i");
        var data = {
          "id": _reportProvider.searchVehicleList[i].id,
          "value": "0"
        };
        selectedVehicleIdList.add(data);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  updateSelectedBool(String id) {
    for (int i = 0; i < selectedVehicleIdList.length; i++) {
      if (selectedVehicleIdList[i]["id"] == id) {
        if (selectedVehicleIdList[i]['value'] == "1") {
          selectedVehicleIdList[i]['value'] = "0";
        } else {
          selectedVehicleIdList[i]['value'] = "1";
        }
        break;
      }
    }
  }

  SharedPreferences sharedPreferences;
  bool isSuperAdmin = false;
  bool isDealer = false;
  bool superAdmin = false;
  var id;

  getVehicleList(page, searchId) async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      isSuperAdmin = sharedPreferences.getBool("superAdmin");
      superAdmin = sharedPreferences.getBool("isSuperAdmin");
      isDealer = sharedPreferences.getBool("isDealer");
    });

    id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");
    var token = sharedPreferences.getString("token");
    var supAdmin = sharedPreferences.getBool("superAdmin");
    isDealer = sharedPreferences.getBool("isDealer");

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    print("page $page");
    var data = {
      "id": id,
      "email": email,
      supAdmin == false ? "" : "supAdmin": id ?? "",
      isDealer == false ? "" : "dealer": id ?? "",
      // "skip": page.toString(),
      "limit": "10",
      "statuss": Utils.vehicleStatus,
      "search": searchId,
    };

    print(data);
    vehicleListProvider.getVehicleList(
        data, "devices/getDeviceByUserMobile", "vehicle");
  }

  List<bool> listofDateValue = List<bool>.filled(4, false);

  @override
  void initState() {
    super.initState();
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    vehicleListProvider =
        Provider.of<VehicleListProvider>(context, listen: false);
    getDeviceByUserDropdown();
    Future.delayed(Duration.zero, () {
      vehicleListProvider.changeBool(false);
      // getUserData();
      getVehicleList(0, "");
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> listOfDate = [
      '${getTranslated(context, "today")}',
      '${getTranslated(context, "yesterday")}',
      '${getTranslated(context, "last_week")}',
      '${getTranslated(context, "last_month")}',
    ];
    vehicleListProvider =
        Provider.of<VehicleListProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ApplicationColors.whiteColorF9,
              /* image: DecorationImage(
                  image: AssetImage(
                      "assets/images/dark_background_image.png"
                  ), // <-- BACKGROUND IMAGE
                  fit: BoxFit.cover,
                ),*/
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: ApplicationColors.redColor67,
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    leading: Container(),
                    actions: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.close,
                            color: ApplicationColors.whiteColor,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
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
                      child: Text(
                        "${getTranslated(context, "select vehicle")}",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Arial',
                          color: ApplicationColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // bottomNavigationBar: Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 20, vertical: 12),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: InkWell(
                  //           onTap: () {
                  //             Navigator.pop(context);
                  //           },
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               color: ApplicationColors.redColor67,
                  //               borderRadius: BorderRadius.circular(6),
                  //             ),
                  //             child: Center(
                  //                 child: Text(
                  //               "${getTranslated(context, "cancel")}",
                  //               style: Textstyle1.text18bold
                  //                   .copyWith(color: Colors.white),
                  //             )),
                  //             height: height * .05,
                  //             width: width * .4,
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(width: 10),
                  //       Expanded(
                  //         child: InkWell(
                  //           onTap: () {
                  //             Navigator.pop(context, sendIdList);
                  //           },
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               color: ApplicationColors.redColor67,
                  //               borderRadius: BorderRadius.circular(6),
                  //             ),
                  //             child: Center(
                  //                 child: Text(
                  //                     "${getTranslated(context, "apply")}"
                  //                         .toUpperCase(),
                  //                     style: Textstyle1.text18bold
                  //                         .copyWith(color: Colors.white))),
                  //             height: height * .05,
                  //             width: width * .4,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  backgroundColor: Colors.white,
                  body: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
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
                        child: TextFormField(
                          controller: _selectVehicleContoller,
                          focusNode: focusNode,
                          keyboardType: TextInputType.text,
                          onChanged: (string) {
                            if (string.isNotEmpty) {
                              _debouncer.run(() {
                                setState(() {
                                  _reportProvider.vehicleList = _reportProvider
                                      .searchVehicleList
                                      .where((u) {
                                    return (u.deviceName
                                        .toLowerCase()
                                        .contains(string.toLowerCase()));
                                  }).toList();
                                });
                              });
                            }
                            setState(() {});
                          },
                          style: FontStyleUtilities.h14(
                            fontColor: ApplicationColors.blackbackcolor,
                          ),
                          decoration: Textfield1.inputdec.copyWith(
                            labelStyle: TextStyle(
                              color: ApplicationColors.whiteColor,
                              fontSize: 15,
                              fontFamily: "Poppins-Regular",
                              letterSpacing: 0.75,
                            ),
                            fillColor: ApplicationColors.whiteColor,
                            border: InputBorder.none,
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
                                color: ApplicationColors.redColor67,
                                width: 8,
                              ),
                            ),
                            suffixIcon: _selectVehicleContoller.text.isEmpty
                                ? SizedBox()
                                : InkWell(
                                    onTap: () {
                                      _selectVehicleContoller.clear();
                                      getDeviceByUserDropdown();
                                      focusNode.unfocus();
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      color: ApplicationColors.whiteColor,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      _reportProvider.isDropDownLoading &&
                              vehicleListProvider.isCommentLoading
                          ? Helper.dialogCall.showLoader()
                          : _reportProvider.vehicleList.length == 0
                              ? Center(
                                  child: Text(
                                    "${getTranslated(context, "vehicle_not_available")}",
                                    textAlign: TextAlign.center,
                                    style: Textstyle1.text18.copyWith(
                                      fontSize: 18,
                                      color: ApplicationColors.redColor67,
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          _reportProvider.vehicleList.length,
                                      itemBuilder: (context, int index) {
                                        var list =
                                            _reportProvider.vehicleList[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                            top: 8,
                                            bottom: 8,
                                          ),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  // sendIdList.add(list.deviceId);
                                                  // Navigator.pop(
                                                  //     context, sendIdList);
                                                  // print("add print");
                                                  // print(sendIdList);
                                                  vehicleListProvider
                                                      .vehicleList
                                                      .map((e) {
                                                    if (list.deviceName ==
                                                        e.deviceName) {
                                                      log(list.deviceName);
                                                      log(e.deviceName);

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              // LiveTrackingScreenCopy(),
                                                              LiveForVehicleScreen(
                                                            vehicleLisDevice: e,
                                                            vId: list.id,
                                                            vDeviceId:
                                                                list.deviceId,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }).toList();
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: width * .09,
                                                      height: height * .03,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            selectedVehicleIdList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index2) {
                                                          var listCheck =
                                                              selectedVehicleIdList[
                                                                  index2];
                                                          return listCheck[
                                                                      "id"] ==
                                                                  list.id
                                                              ? Container(
                                                                  width: width *
                                                                      .09,
                                                                  height:
                                                                      height *
                                                                          .03,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: listCheck[
                                                                                "value"] ==
                                                                            "1"
                                                                        ? ApplicationColors
                                                                            .redColor67
                                                                        : ApplicationColors
                                                                            .whiteColorF9,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      width: 2,
                                                                      color: ApplicationColors
                                                                          .blackColor00,
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox();
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 14),
                                                    Text(
                                                      "${list.deviceName}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                color: Appcolors.text_grey,
                                                indent: 50,
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                      /* ListView.builder(
                        shrinkWrap: true,
                        itemCount: _reportProvider.vehicleList.length,
                        itemBuilder: (context, int index) {
                          var list = _reportProvider.vehicleList[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8,
                            ),
                            child: InkWell(
                              onTap: () {
                               print("Test");
                                setState(() {
                                  updateSelectedBool(list.id);
                                  if(sendIdList.contains(list.deviceId)){
                                    sendIdList.remove(list.deviceId);
                                    print("remove value print");
                                    print(sendIdList);
                                  }else{
                                    sendIdList.add(list.deviceId);
                                    print("add print");
                                    print(sendIdList);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: width * .05,
                                    height: height * .022,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: selectedVehicleIdList.length,
                                      itemBuilder: (context, index2) {
                                        var listCheck = selectedVehicleIdList[index2];
                                        return listCheck["id"] == list.id
                                            ?
                                        Container(
                                          width: width * .05,
                                          height: height * .022,
                                          decoration: BoxDecoration(
                                              color: listCheck["value"] == "1"
                                                  ?
                                              ApplicationColors.redColor67
                                                  :
                                              ApplicationColors.dropdownColor3D,
                                              border: Border.all(
                                                  width: 3,
                                                  color: ApplicationColors.dropdownColor3D
                                              )
                                          ),
                                        )
                                            :
                                        SizedBox();
                                      },
                                    ),
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${list.deviceName}",
                                    style: Textstyle1.text12,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),*/
                    ],
                  )),
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
