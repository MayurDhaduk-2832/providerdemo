import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oneqlik/Helper/helper.dart';
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

class HistoryFilter extends StatefulWidget {
  var selectedId, fromDate, toDate, getIMEINo, deviceName;

  HistoryFilter(
      {Key key,
      this.selectedId,
      this.fromDate,
      this.toDate,
      this.getIMEINo,
      this.deviceName})
      : super(key: key);

  @override
  _HistoryFilterState createState() => _HistoryFilterState();
}

class _HistoryFilterState extends State<HistoryFilter> {
  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";

  FocusNode focusNode = FocusNode();

  var vehicleId = "";

  String selected = 'categories';
  var chooseLocation;
  int selecttype = 1;

  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = TextEditingController();
  TextEditingController _selectVehicleContoller = TextEditingController();

  final _debouncer = Debouncer(milliseconds: 500);

  FocusNode formDateFocus = FocusNode();
  FocusNode toDateFocus = FocusNode();

  ReportProvider _reportProvider;

  bool isLoading = false;

  var selectedId = "", deviceId, vName = "";

  getDeviceByUserDropdown() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");

    var data = {"email": email, "id": id};

    await _reportProvider.getVehicleDropdown(
        data, "devices/getDeviceByUserDropdown");

    setState(() {
      isLoading = false;
    });
  }

  List<bool> listofDateValue = List<bool>.filled(4, false);

  @override
  void initState() {
    super.initState();

    _reportProvider = Provider.of<ReportProvider>(context, listen: false);

    selectedId = "${widget.selectedId}";
    fromDate = widget.fromDate;
    toDate = widget.toDate;
    vName = widget.deviceName;
    deviceId = widget.getIMEINo;

    datedController.text = fromDate;
    _endDateController.text = toDate;

    listofDateValue[0] = true;
    getDeviceByUserDropdown();
  }

  @override
  Widget build(BuildContext context) {
    List<String> listOfDate = [
      '${getTranslated(context, "today")}',
      '${getTranslated(context, "yesterday")}',
      '${getTranslated(context, "last_week")}',
      '${getTranslated(context, "last_month")}',
    ];

    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: ApplicationColors.whiteColorF9),
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
                  // appBar: AppBar(
                  //   automaticallyImplyLeading: false,
                  //   title: Text(
                  //       "${getTranslated(context, "search")}",
                  //       style: Textstyle1.appbartextstyle1
                  //   ),
                  //   backgroundColor: Colors.transparent,
                  //   elevation: 0,
                  // ),
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
                  //               "${getTranslated(context, "cancel")}"
                  //                   .toUpperCase(),
                  //               style: Textstyle1.text18boldwhite,
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
                  //             Navigator.pop(context, [
                  //               selectedId,
                  //               deviceId,
                  //               fromDate,
                  //               toDate,
                  //               vName
                  //             ]);
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
                  //                     style: Textstyle1.text18boldwhite)),
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
                            fontColor: ApplicationColors.black4240,
                          ),
                          decoration: Textfield1.inputdec.copyWith(
                            labelStyle: TextStyle(
                              color: ApplicationColors.black4240,
                              fontSize: 15,
                              fontFamily: "Poppins-Regular",
                              letterSpacing: 0.75,
                            ),
                            border: InputBorder.none,
                            hintText:
                                "${getTranslated(context, "search_vehicle")}",
                            hintStyle: TextStyle(
                              color: ApplicationColors.black4240,
                              fontSize: 14,
                              fontFamily: "Poppins-Regular",
                              letterSpacing: 0.75,
                            ),
                            fillColor: ApplicationColors.whiteColor,
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
                                      color: ApplicationColors.black4240,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      _reportProvider.isDropDownLoading
                          ? Expanded(child: Helper.dialogCall.showLoader())
                          : _reportProvider.vehicleList.length == 0
                              ? Expanded(
                                  child: Center(
                                    child: Text(
                                      "${getTranslated(context, "vehicle_not_available")}",
                                      textAlign: TextAlign.center,
                                      style: Textstyle1.text18.copyWith(
                                        fontSize: 18,
                                        color: ApplicationColors.redColor67,
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      // physics: NeverScrollableScrollPhysics(),
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
                                                  setState(() {
                                                    selectedId = "${list.id}";
                                                    deviceId = list.deviceId;
                                                    vName = list.deviceName;
                                                  });

                                                  print(
                                                      "print ids $selectedId,$deviceId,$vName");
                                                  Navigator.pop(context, [
                                                    selectedId,
                                                    deviceId,
                                                    fromDate,
                                                    toDate,
                                                    vName
                                                  ]);
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: width * .09,
                                                      height: height * .03,
                                                      child: Container(
                                                        width: width * .09,
                                                        height: height * .03,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            width: 2,
                                                            color:
                                                                ApplicationColors
                                                                    .blackColor00,
                                                          ),
                                                        ),
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
                    ],
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
