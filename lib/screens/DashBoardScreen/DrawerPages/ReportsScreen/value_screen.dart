import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValueScreen extends StatefulWidget {
  const ValueScreen({Key key}) : super(key: key);

  @override
  _ValueScreenState createState() => _ValueScreenState();
}

class _ValueScreenState extends State<ValueScreen> {
  var height, width;

  ReportProvider _reportProvider;
  UserProvider _userProvider;
  int hours;
  int minutes;

  var vId;
  dailyReportList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "user": id,
      "date": DateTime.now().toString(),
      "device": vId,
    };

    print(data);

    _reportProvider.dailyReportList(data, "devices/dailyReport");
  }

  @override
  void initState() {
    super.initState();
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _reportProvider.getDailyReportList.clear();
  }

  var exportType = "excel";

  @override
  Widget build(BuildContext context) {
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    _userProvider = Provider.of<UserProvider>(context, listen: true);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 13.0, left: 13, top: 13),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset("assets/images/vector_icon.png",  color:ApplicationColors.redColor67 ,),
          ),
        ),
        title: Text(
          "${getTranslated(context, "value_screen_report")}",
          style: Textstyle1.appbartextstyle1,
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
                                      color: ApplicationColors.textFielfForegroundColor,
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
                                                  style: Textstyle1.text14boldwhite
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
                                                              .getDailyReportList
                                                              .length;
                                                      i++) {
                                                    sendList.add(""
                                                        "Vehicle Name : ${_reportProvider.getDailyReportList[i].deviceName}"
                                                        "\n"
                                                        'Running : ${_reportProvider.getDailyReportList[i].todayRunning == null ? "0" : _reportProvider.getDailyReportList[i].todayRunning.toString().split(":").first}:${_reportProvider.getDailyReportList[i].todayRunning.toString().split(":").last}'
                                                        "\n"
                                                        'Stop : ${_reportProvider.getDailyReportList[i].todayStopped == null ? "0" :_reportProvider.getDailyReportList[i].todayStopped.toString().split(":").first}:${_reportProvider.getDailyReportList[i].todayStopped.toString().split(":").last} Hr/Min'
                                                        "\n"
                                                        'Idle : ${_reportProvider.getDailyReportList[i].tOfr == null ? "0" : _reportProvider.getDailyReportList[i].tOfr.toString().split(":").first}:${_reportProvider.getDailyReportList[i].tOfr.toString().split(":").last} Hr/Min'
                                                        "\n"
                                                        "Out Of Reach : ${_reportProvider.getDailyReportList[i].todayOdo == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[i].todayOdo)} ' '${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "Kms" : "Miles"}"
                                                        "\n"
                                                        "Distance : ${_reportProvider.getDailyReportList[i].todayOdo == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[i].todayOdo)}" "${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "Kms" : "Miles"}"
                                                        "\n"
                                                        'Over Speed : ${_reportProvider.getDailyReportList[i].maxSpeed == null ? "0" : _reportProvider.getDailyReportList[i].maxSpeed} Km/hr'
                                                        "\n"
                                                        'Trip : ${_reportProvider.getDailyReportList[i].todayTrips == null ?"" : _reportProvider.getDailyReportList[i].todayTrips}'
                                                        "\n"
                                                        'Fuel Consumption : ${_reportProvider.getDailyReportList[i].mileage == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[i].todayOdo/int.parse(_reportProvider.getDailyReportList[i].mileage))} ' '${_userProvider.useModel.cust.unitMeasurement == "LITER" ? "Litre" : "Pr"}'
                                                        "\n"
                                                    );
                                                  }

                                                  if(sendList.isNotEmpty){
                                                    generatePdf(sendList,
                                                        vId);
                                                  }
                                                  else{
                                                    Helper.dialogCall.showToast(
                                                        context,
                                                        "${getTranslated(context, "vehicle_report_is_empty")}"
                                                    );
                                                  }
                                                  // generatePdf(
                                                  //     sendList, "vehicleName");
                                                } else {
                                                  List sendList = [];
                                                  for (int i = 0;
                                                      i <
                                                          _reportProvider
                                                              .getDailyReportList
                                                              .length;
                                                      i++) {
                                                    var data = {

                                                      "a":
                                                      "${_reportProvider.getDailyReportList[i].deviceName}",
                                                      "b":
                                                      '${_reportProvider.getDailyReportList[i].todayRunning == null ? "0" :_reportProvider.getDailyReportList[0].todayRunning.toString().split(":").first}:${_reportProvider.getDailyReportList[0].todayRunning.toString().split(":").last} Hr/Min',
                                                      "c":
                                                      '${_reportProvider.getDailyReportList[i].todayStopped == null ? "0" :_reportProvider.getDailyReportList[0].todayStopped.toString().split(":").first}:${_reportProvider.getDailyReportList[0].todayStopped.toString().split(":").last} Hr/Min',
                                                      "d":
                                                      '${_reportProvider.getDailyReportList[i].tOfr == null ? "0" :_reportProvider.getDailyReportList[0].tOfr.toString().split(":").first}:${_reportProvider.getDailyReportList[0].tOfr.toString().split(":").last} Hr/Min',
                                                      "e":
                                                      "${_reportProvider.getDailyReportList[i].todayOdo == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[0].todayOdo)} Kms",
                                                      "f":
                                                      "${_reportProvider.getDailyReportList[i].todayOdo == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[i].todayOdo)} Kms",
                                                      "g":
                                                      '${_reportProvider.getDailyReportList[i].maxSpeed == null ? "0" :_reportProvider.getDailyReportList[i].maxSpeed} Km/hr',
                                                      "h":
                                                      '${_reportProvider.getDailyReportList[i].todayTrips == null ? "0" :_reportProvider.getDailyReportList[i].todayTrips}',
                                                      "i":
                                                      '${_reportProvider.getDailyReportList[i].mileage == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[0].todayOdo/int.parse(_reportProvider.getDailyReportList[0].mileage))} Litre',
                                                      "j": "",
                                                      "k": "",
                                                      "l": "",
                                                    };

                                                    sendList.add(data);
                                                  }

                                                  List excelTitle = [
                                                    'Device Name',
                                                    'Running',
                                                    'Stop',
                                                    'Idle',
                                                    'Out Of Reach',
                                                    'Distance',
                                                    'Over Speed',
                                                    'Trip',
                                                    'Fuel Consumption',
                                                    "",
                                                    "",
                                                    "",
                                                  ];

                                                  if(sendList.isNotEmpty){
                                                    generateExcel(
                                                        sendList,
                                                        vId,
                                                        excelTitle);
                                                  }
                                                  else{
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
                                                  style: Textstyle1.text14boldwhite
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
                  "assets/images/threen_verticle_options_icon.png",  color:ApplicationColors.redColor67 ,
                  width: 30,
                )),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        backgroundColor: ApplicationColors.blackColor2E,
        elevation: 0,
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            color: ApplicationColors.whiteColorF9
           /* image: DecorationImage(
          image: AssetImage("assets/images/dashboard_image.jpg"),
          fit: BoxFit.fill,
        )*/
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 20),
          child: Column(
            children: [
              Theme(
                data: ThemeData(
                  textTheme:
                      TextTheme(subtitle1: TextStyle(color: Colors.black)),
                ),
                child: DropdownSearch<VehicleList>(
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
                        item.deviceName,
                        style: TextStyle(
                            color: ApplicationColors.black4240,
                            fontSize: 15,
                            fontFamily: "Poppins-Regular",
                            letterSpacing: 0.75),
                      ),
                    );
                  },

                  emptyBuilder: (context,string){
                    return Center(
                      child: Text(
                        "${getTranslated(context, "vehicle_not_found")}",
                        style: TextStyle(
                            color: ApplicationColors.black4240,
                            fontSize: 15,
                            fontFamily: "Poppins-Regular",
                            letterSpacing: 0.75
                        ),
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
                            color: ApplicationColors.textfieldBorderColor,
                            width: 1,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: ApplicationColors.textfieldBorderColor,
                            width: 1,
                          )),
                      hintText: "${getTranslated(context, "search_vehicle")}",
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
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: ApplicationColors.textfieldBorderColor,
                          width: 1,
                        )),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image.asset(
                        "assets/images/search_icon.png",
                        color: ApplicationColors.redColor67,
                        height: 10,
                        width: 10,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: ApplicationColors.textfieldBorderColor,
                          width: 1,
                        )),
                    hintText: "${getTranslated(context, "search_vehicle")}",
                    hintStyle: TextStyle(
                        color: ApplicationColors.black4240,
                        fontSize: 15,
                        fontFamily: "Poppins-Regular",
                        letterSpacing: 0.75),
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                    border: OutlineInputBorder(),
                  ),
                  items: _reportProvider.userVehicleDropModel.devices,
                  itemAsString: (VehicleList u) => u.deviceName,
                  onChanged: (VehicleList data) {
                    setState(() {
                      vId = data.deviceId;
                      dailyReportList();
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: _reportProvider.isDailyReportListLoading
                    ? Helper.dialogCall.showLoader()
                    : _reportProvider.getDailyReportList.isEmpty
                        ? Center(
                            child: Text(
                              "${getTranslated(context, "value_screen_not_available")}",
                              textAlign: TextAlign.center,
                              style: Textstyle1.text18.copyWith(
                                fontSize: 18,
                                color: ApplicationColors.redColor67,
                              ),
                            ),
                          )
                        : GridView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2.1 / 2,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 18),
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 14, top: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/images/car_icon.png",
                                                  color: Colors.white)),
                                          decoration: BoxDecoration(
                                            color:
                                                ApplicationColors.greenColor370,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ApplicationColors
                                                    .whiteColor,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                                blurRadius: 10.0,
                                                spreadRadius: -8,
                                              ), //BoxShadow
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 9),
                                        Flexible(
                                          child: Text(
                                              "${getTranslated(context, "running")}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Textstyle1.text14bold
                                                  .copyWith(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Expanded(child: SizedBox()),
                                    Flexible(
                                      child: Text(
                                        formatMilliseconds(_reportProvider.getDailyReportList[0].todayRunning),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Textstyle1.text14bold
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                          "${getTranslated(context, "total_running_time")}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Textstyle1.text11),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: serviceOfIndex == index
                                    //     ? ApplicationColors.textFielfForegroundColor
                                    //     : ApplicationColors.textFielfForegroundColor,
                                    color: ApplicationColors.textFielfForegroundColor),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 14, top: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/images/Idle_reports.png",
                                                  color: Colors.white)),
                                          decoration: BoxDecoration(
                                            color: ApplicationColors
                                                .yellowColorD21,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ApplicationColors
                                                    .whiteColor,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                                blurRadius: 10.0,
                                                spreadRadius: -8,
                                              ), //BoxShadow
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 9),
                                        Flexible(
                                          child: Text(
                                              "${getTranslated(context, "idle")}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Textstyle1.text14bold
                                                  .copyWith(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Expanded(child: SizedBox()),
                                    Flexible(
                                      child: Text(
                                        //'${_reportProvider.getDailyReportList[0].tIdling.toString().split(" ").first}:${_reportProvider.getDailyReportList[0].tIdling.toString().split(":").last} Hr/Min',
                                        '${_reportProvider.getDailyReportList[0].tIdling} Hr/Min',

                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Textstyle1.text14bold
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                          "${getTranslated(context, "total_idle_time")}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Textstyle1.text11),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: serviceOfIndex == index
                                    //     ? ApplicationColors.textFielfForegroundColor
                                    //     : ApplicationColors.textFielfForegroundColor,
                                    color: ApplicationColors.textFielfForegroundColor),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 14, top: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/images/Stop.png",
                                                  color: Colors.white)),
                                          decoration: BoxDecoration(
                                            color: ApplicationColors.redColor67,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ApplicationColors
                                                    .whiteColor,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                                blurRadius: 10.0,
                                                spreadRadius: -8,
                                              ), //BoxShadow
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 9),
                                        Flexible(
                                          child: Text(
                                              "${getTranslated(context, "stopped")}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Textstyle1.text14bold
                                                  .copyWith(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Expanded(child: SizedBox()),
                                    Flexible(
                                      child: Text(
                                        '${_reportProvider.getDailyReportList[0].todayStopped.split(":").first}:${_reportProvider.getDailyReportList[0].todayStopped.split(":").last} Hr/Min',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Textstyle1.text14bold
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                          "${getTranslated(context, "total_stopped_time")}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Textstyle1.text11),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: serviceOfIndex == index
                                    //     ? ApplicationColors.textFielfForegroundColor
                                    //     : ApplicationColors.textFielfForegroundColor,
                                    color: ApplicationColors.textFielfForegroundColor),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 14, top: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/images/car_icon.png",
                                                  color: Colors.white)),
                                          decoration: BoxDecoration(
                                            color:
                                                ApplicationColors.blueColorCE,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ApplicationColors
                                                    .whiteColor,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                                blurRadius: 10.0,
                                                spreadRadius: -8,
                                              ), //BoxShadow
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 9),
                                        Flexible(
                                          child: Text(
                                              "${getTranslated(context, "out_reach")}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Textstyle1.text14bold
                                                  .copyWith(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Expanded(child: SizedBox()),
                                    Flexible(
                                      child: Text(
                                        '${_reportProvider.getDailyReportList[0].tOfr.toString().split(":").first}:${_reportProvider.getDailyReportList[0].tOfr.toString().split(":").last} Hr/Min',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Textstyle1.text14bold
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                          "${getTranslated(context, "total_out_reach_time")}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Textstyle1.text11),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: serviceOfIndex == index
                                    //     ? ApplicationColors.textFielfForegroundColor
                                    //     : ApplicationColors.textFielfForegroundColor,
                                    color: ApplicationColors.textFielfForegroundColor),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 14, top: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/images/distance_reports_.png",
                                                  color: Colors.white)),
                                          decoration: BoxDecoration(
                                            color:
                                                ApplicationColors.pinkColorC3,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ApplicationColors
                                                    .whiteColor,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                                blurRadius: 10.0,
                                                spreadRadius: -8,
                                              ), //BoxShadow
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 9),
                                        Flexible(
                                          child: Text(
                                              "${getTranslated(context, "distance")}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Textstyle1.text14bold
                                                  .copyWith(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Expanded(child: SizedBox()),
                                    Flexible(
                                      child: Text(
                                        "${NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[0].todayOdo)} ${getTranslated(context, "kms")}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Textstyle1.text14bold
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                          "${getTranslated(context, "total_distance_travelled")}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Textstyle1.text11),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: serviceOfIndex == index
                                    //     ? ApplicationColors.textFielfForegroundColor
                                    //     : ApplicationColors.textFielfForegroundColor,
                                    color: ApplicationColors.textFielfForegroundColor),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 14, top: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/images/fuel_unit_ic.png",
                                                  color: Colors.white)),
                                          decoration: BoxDecoration(
                                            color: ApplicationColors
                                                .darkredColor1E,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ApplicationColors
                                                    .whiteColor,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                                blurRadius: 10.0,
                                                spreadRadius: -8,
                                              ), //BoxShadow
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 9),
                                        Flexible(
                                          child: Text(
                                              "${getTranslated(context, "fuel_consumption")}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Textstyle1.text14bold
                                                  .copyWith(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Expanded(child: SizedBox()),
                                    Flexible(
                                      child: Text(
                                        '${NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[0].todayOdo / int.parse(_reportProvider.getDailyReportList[0].mileage))} Litre',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Textstyle1.text14bold
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                          "${getTranslated(context, "total_fuel_consumption")}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Textstyle1.text11),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: serviceOfIndex == index
                                    //     ? ApplicationColors.textFielfForegroundColor
                                    //     : ApplicationColors.textFielfForegroundColor,
                                    color: ApplicationColors.textFielfForegroundColor),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 14, top: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/images/subtract_ic.png",
                                                  color: Colors.white)),
                                          decoration: BoxDecoration(
                                            color:
                                                ApplicationColors.radiusColorFB,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ApplicationColors
                                                    .whiteColor,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                                blurRadius: 10.0,
                                                spreadRadius: -8,
                                              ), //BoxShadow
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 9),
                                        Flexible(
                                          child: Text(
                                              "${getTranslated(context, "max_speed")}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Textstyle1.text14bold
                                                  .copyWith(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Expanded(child: SizedBox()),
                                    Flexible(
                                      child: Text(
                                        '${_reportProvider.getDailyReportList[0].maxSpeed}  ${getTranslated(context, "km_hr")}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Textstyle1.text14bold
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                          "${getTranslated(context, "total_max_speed")}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Textstyle1.text11),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: serviceOfIndex == index
                                    //     ? ApplicationColors.textFielfForegroundColor
                                    //     : ApplicationColors.textFielfForegroundColor,
                                    color: ApplicationColors.textFielfForegroundColor),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 14, top: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/images/Loading_report_icon.png",
                                                  color: Colors.white)),
                                          decoration: BoxDecoration(
                                            color:
                                                ApplicationColors.greyColor7676,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ApplicationColors
                                                    .whiteColor,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                                blurRadius: 10.0,
                                                spreadRadius: -8,
                                              ), //BoxShadow
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 9),
                                        Flexible(
                                          child: Text(
                                              "${getTranslated(context, "Trips")}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Textstyle1.text14bold
                                                  .copyWith(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Expanded(child: SizedBox()),
                                    Flexible(
                                      child: Text(
                                        '${_reportProvider.getDailyReportList[0].todayTrips}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Textstyle1.text14bold
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                          "${getTranslated(context, "total_trips")}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Textstyle1.text11),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: serviceOfIndex == index
                                    //     ? ApplicationColors.textFielfForegroundColor
                                    //     : ApplicationColors.textFielfForegroundColor,
                                    color: ApplicationColors.textFielfForegroundColor),
                              ),
                            ],
                          ),
              ),
            ],
          ),
        ),
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

List listOfExpensesServices = [
  {
    'name': 'Running',
    'color': ApplicationColors.greenColor370,
    'price': '0:48 Hr/Min',
    'total': 'Total Running Time ',
    'image': Image.asset(
      "assets/images/car_icon.png",
      color: Colors.white,
    )
  },
  {
    'name': 'Idle',
    'color': ApplicationColors.yellowColorD21,
    'price': '17:04 Hr/Min',
    'total': 'Total Idle Time ',
    'image': Image.asset(
      "assets/images/Idle_reports.png",
      color: Colors.white,
    )
  },
  {
    'name': 'stopped',
    'color': ApplicationColors.blueColorCE,
    'price': '0:37 Hr/Min',
    'total': 'Total stopped Time ',
    'image': Image.asset(
      "assets/images/stoppage_report.png",
      color: Colors.white,
    )
  },
  {
    'name': 'out of reach',
    'color': ApplicationColors.darkgreyColor1E,
    'price': '0:00 Hr/Min',
    'total': 'Total out of reach Time ',
    'image': Image.asset(
      "assets/images/car_icon.png",
      color: Colors.white,
    )
  },
  {
    'name': 'Distance',
    'color': ApplicationColors.pinkColorC3,
    'price': '0:37 Hr/Min',
    'total': 'Total Distance travelled ',
    'image': Image.asset(
      "assets/images/distance_reports_.png",
      color: Colors.white,
    )
  },
  {
    'name': 'Fuel Consumption',
    'color': ApplicationColors.darkredColor1E,
    'price': '2.77 Litre',
    'total': 'Total Fuel  Consumption',
    'image': Image.asset("assets/images/fuel_icon.png")
  },
  {
    'name': 'Max speed',
    'color': ApplicationColors.redColor67,
    'price': '54 Km/Hr',
    'total': 'Total Max Speed',
    'image': Image.asset("assets/images/other_icon.png")
  },
  {
    'name': 'Trips',
    'color': ApplicationColors.radiusColorFB,
    'price': '03',
    'total': 'Total Trips',
    'image': Image.asset("assets/images/protection_icon.png")
  },
  {
    'name': 'Petta',
    'color': ApplicationColors.orangeColor3E,
    'price': '1600',
    'total': 'Total Generate',
    'image': Image.asset("assets/images/protection_icon.png")
  },
];
