import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/ProductsFilterPage/vehicle_filter.dart';
import 'package:oneqlik/screens/SyncfunctionPages/chart.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpeedVariationReportPage extends StatefulWidget {
  const SpeedVariationReportPage({Key key}) : super(key: key);

  @override
  _SpeedVariationReportPageState createState() =>
      _SpeedVariationReportPageState();
}

class _SpeedVariationReportPageState extends State<SpeedVariationReportPage> {
  TextEditingController datedController = TextEditingController(
      text: 'Date ${DateFormat("dd MMM yyyy").format(DateTime.now())}');

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

  var exportType = "excel";

  var vId;
  var vName;

  TrackballBehavior _trackballBehavior;

  ReportProvider _reportProvider;

  getGpsSpeedGraph() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "imei": "$vId",
      "time": fromDate.toString(),
    };

    print(data);
    _reportProvider.getGpsSpeedReport(data, "gps/getGpsSpeedReport");
  }

  ZoomPanBehavior zoomPanBehavior;

  FocusNode focusNode;

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

    focusNode = FocusNode();

    _reportProvider = Provider.of<ReportProvider>(context, listen: false);

    zoomPanBehavior = ZoomPanBehavior(
        enablePanning: true,
        enableDoubleTapZooming: true,
        maximumZoomLevel: 0.7,
        zoomMode: ZoomMode.x);

    _trackballBehavior = TrackballBehavior(
      enable: true,
      lineColor: Colors.white,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      activationMode: ActivationMode.singleTap,
    );

    getGpsSpeedGraph();
    getDeviceByUserDropdown();
  }

  @override
  Widget build(BuildContext context) {
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ApplicationColors.whiteColor,
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
          "${getTranslated(context, "speed_variation_report")}",
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
                                              if (vId != "") {
                                                if (exportType == "pdf") {
                                                  List<String> sendList = [];
                                                  for (int i = 0;
                                                      i <
                                                          _reportProvider
                                                              .getGpsSpeedChart
                                                              .length;
                                                      i++) {
                                                    sendList.add(""
                                                        "Time : ${DateFormat("hh:mm").format(DateTime.parse(_reportProvider.getGpsSpeedChart[i].x))}"
                                                        "\n\n"
                                                        "Speed : ${double.parse(_reportProvider.getGpsSpeedChart[i].y.toString())}"
                                                        "\n\n");
                                                  }

                                                  if (sendList.isNotEmpty) {
                                                    generatePdf(sendList, vId);
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
                                                              .getGpsSpeedChart
                                                              .length;
                                                      i++) {
                                                    var data = {
                                                      "a":
                                                          "${_reportProvider.getGpsSpeedChart[i].x.toString()}",
                                                      "b":
                                                          "${double.parse(_reportProvider.getGpsSpeedChart[i].y.toString())}",
                                                      "c": "",
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
                                                    'Time',
                                                    'Speed',
                                                    "",
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
                                                    generateExcel(sendList, vId,
                                                        excelTitle);
                                                  } else {
                                                    Helper.dialogCall.showToast(
                                                        context,
                                                        "${getTranslated(context, "vehicle_report_is_empty")}");
                                                  }
                                                }
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
                        },
                      );
                    },
                  );
                  //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>GroupsScreen()));
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
                  decoration:
                      BoxDecoration(color: ApplicationColors.blackColor2E),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          style: Textstyle1.signupText1,
                          keyboardType: TextInputType.number,
                          controller: datedController,
                          focusNode: focusNode,
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            DateTime newSelectedDate =
                                await _selecttDate(context);
                            if (newSelectedDate != null) {
                              focusNode.unfocus();
                              setState(() {
                                datedController.text =
                                    "Date ${DateFormat("dd-MMM-yyyy").format(newSelectedDate)}";
                              });
                            }
                          },
                          decoration: fieldStyle.copyWith(
                            contentPadding: EdgeInsets.all(12),
                            hintText:
                                "${getTranslated(context, "select_date")}",
                            hintStyle: Textstyle1.signupText.copyWith(
                              color: Colors.white,
                            ),
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
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
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
                              hintText:
                                  "${getTranslated(context, "search_vehicle")}",
                              hintStyle: TextStyle(
                                  color: ApplicationColors.black4240,
                                  fontSize: 15,
                                  fontFamily: "Poppins-Regular",
                                  letterSpacing: 0.75),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            ),
                            items: _reportProvider.userVehicleDropModel.devices,
                            itemAsString: (VehicleList u) => u.deviceName,
                            onChanged: (VehicleList data) {
                              setState(() {
                                vId = data.deviceId;
                                vName = data.deviceName;
                                _reportProvider.getGpsSpeedChart.clear();
                                getGpsSpeedGraph();
                              });
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _reportProvider.isGpsSpeedReportLoading
                      ? Helper.dialogCall.showLoader()
                      : Container(
                          decoration: BoxDecoration(
                              color: ApplicationColors.blackColor2E,
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SfCartesianChart(
                                    plotAreaBorderWidth: 0,
                                    primaryXAxis: CategoryAxis(
                                      labelPlacement: LabelPlacement.onTicks,
                                      majorGridLines:
                                          const MajorGridLines(width: 0),
                                      majorTickLines: MajorTickLines(width: 0),
                                    ),
                                    primaryYAxis: NumericAxis(
                                      majorTickLines: MajorTickLines(width: 0),
                                      labelFormat: '{value}',
                                      axisLine: const AxisLine(width: 0),
                                      majorGridLines: MajorGridLines(
                                        color: ApplicationColors
                                            .textfieldBorderColor
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    trackballBehavior: _trackballBehavior,
                                    zoomPanBehavior: zoomPanBehavior,
                                    series: <
                                        ChartSeries<GpsSpeedVariationChart,
                                            String>>[
                                      SplineAreaSeries<GpsSpeedVariationChart,
                                              String>(
                                          gradient: const LinearGradient(
                                            colors: <Color>[
                                              Color(0xff12A370),
                                              Color(0xff24282E),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderWidth: 2,
                                          borderColor: const Color.fromRGBO(
                                              0, 156, 144, 1),
                                          borderDrawMode: BorderDrawMode.top,
                                          dataSource:
                                              _reportProvider.getGpsSpeedChart,
                                          name:
                                              "${getTranslated(context, 'Gps_Speed_Variation')}",
                                          xValueMapper:
                                              (GpsSpeedVariationChart sales,
                                                      _) =>
                                                  sales.x,
                                          yValueMapper:
                                              (GpsSpeedVariationChart sales,
                                                      _) =>
                                                  sales.y,
                                          dataLabelSettings: DataLabelSettings(
                                            isVisible: true,
                                            textStyle:
                                                TextStyle(color: Colors.black),
                                            labelPosition:
                                                ChartDataLabelPosition.inside,
                                          ))
                                    ]),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 13, vertical: 2),
                                decoration: BoxDecoration(
                                    color: ApplicationColors.redColor67,
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Colors.transparent)),
                                child: Text(
                                  'Gps Speed Variation',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: FontStyleUtilities.h12(
                                    fontColor: ApplicationColors.whiteColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: 20),
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
    if (newSelectedDate != null && vId != null) {
      fromDate = newSelectedDate.toString();
      _reportProvider.getGpsSpeedChart.clear();
      getGpsSpeedGraph();
    }
    return newSelectedDate;
  }
}
