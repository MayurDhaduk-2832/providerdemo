import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/fuel_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/FuelPages/edit_fuel_entry.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/FuelPages/fuel_entry.dart';
import 'package:oneqlik/screens/SyncfunctionPages/chart.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FuelPages extends StatefulWidget {
  const FuelPages({Key key}) : super(key: key);

  @override
  _FuelPagesState createState() => _FuelPagesState();
}

class _FuelPagesState extends State<FuelPages> {
  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  TrackballBehavior _trackballBehavior;

  var selectValue = "FuelEntry";
  var selectFuel = "fuel";
  var filterType = "time";
  FuelProvider _fuelProvider;

  var deviceName = "";

  getFuelGraph() async {
    var data = {
      "i": imeiNo,
      "f": fromDate.toString(),
      "t": toDate.toString(),
    };

    print('fuelgraph->$data');
    _fuelProvider.getFuelGraph(data, "summary/fuel");
  }

  getFuelConsumeTimeDetails() async {
    var data = {
      "from": fromDate.toString(),
      "to": toDate.toString(),
      "device": [
        {
          "imei": imeiNo,
          "name": vehicleName,
          "id": vehicleId,
        }
      ],
      "imei": imeiNo,
      "vehicle": vehicleId,
    };

    print('checkTime-->$data');
    _fuelProvider.getFuelConsumeTimeDetails(data, "gps/updatedFuelReport");
  }

  getFuelConsumeDailyDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from": fromDate.toString(),
      "to": toDate.toString(),
      "user": "$id",
      "daywise": true,
      "imei": imeiNo,
      "device": {"imei": imeiNo, "name": vehicleName, "id": vehicleId},
      "vehicle": vehicleId,
    };

    print("calleeddddd");
    print(jsonEncode(data));

    _fuelProvider.getFuelConsumeDailyDetails(data, "gps/updatedFuelReport");
  }

  getFuelConsumeTripDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from": fromDate.toString(),
      "to": toDate.toString(),
      "user": "$id",
      "trip": true,
      "imei": imeiNo,
      "vehicle": vehicleId,
      "device": {
        "imei": imeiNo,
        "name": vehicleName,
        "id": vehicleId,
      }
    };

    print('TripCheck->$data');
    print(jsonEncode(data));
    _fuelProvider.getFuelConsumeTripDetails(data, "gps/updatedFuelReport");
  }

  getDeviceByUserDropdown() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");

    var data = {"email": email, "id": id};

    await _reportProvider.getVehicleDropdown(
        data, "devices/getDeviceByUserDropdown");
  }

  getFuelEntryDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "user": "$id",
      "vehicle": vehicleId,
    };

    print('checkFuelEntry-->$data');

    await _fuelProvider.getFuelEntryDetails(data, "fuel/getFuels", context);
  }

  deleteFuel(id) async {
    var data = {"_id": "$id"};
    print('Delete Fuel -> $data');

    await _fuelProvider.deleteFuel(data, "fuel/deleteFuel", context, vehicleId);
  }

  ZoomPanBehavior zoomPanBehavior;

  ReportProvider _reportProvider;

  @override
  void initState() {
    super.initState();
    datedController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy hh:mm a").format(DateTime.now())}";
    _endDateController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy hh:mm a").format(DateTime.now())}";

    _fuelProvider = Provider.of<FuelProvider>(context, listen: false);
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

    getDeviceByUserDropdown();

    /* getFuelGraph();
    getFuelConsumeTimeDetails();
    getFuelConsumeDailyDetails();
    getFuelConsumeTripDetails();*/

    _fuelProvider.getFuelEntryList.clear();
  }

  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toString();
  var vehicleId = "", vehicleName = "", imeiNo = "";

  List _selectedVehicle = [];

  /*List deviceList = [];
  List vehicleList = [];
  List imeiList = [];*/

  /* void _showMultiSelect(BuildContext context) async {
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
            for(int i =0; i<_selectedVehicle.length;i++){
              var data =
              {
                "imei": values[i].deviceId,
                "name":  values[i].deviceName,
                "id":  values[i].id,
              };
              deviceList.add(data);
              vehicleList.add(data["id"]);
              imeiList.add(data["imei"]);

              print(deviceList);
              print(vehicleList);
              print(imeiList);

            }

            if (_selectedVehicle.isNotEmpty) {
              getFuelGraph();
              getFuelConsumeTimeDetails();
              getFuelConsumeDailyDetails();
              getFuelConsumeTripDetails();
            }
            setState(() {});
            _fuelProvider.fuelChart.clear();
          },
          closeSearchIcon: Icon(
            Icons.close,
            color: ApplicationColors.whiteColor,
          ),
          searchIcon: Icon(
            Icons.search,
            color: ApplicationColors.whiteColor,
          ),
          confirmText: Text(
            "Apply",
            style: TextStyle(
                color: ApplicationColors.whiteColor,
                fontFamily: "Poppins-Regular",
                fontSize: 18),
          ),
          cancelText: Text(
            "Cancel",
            style: TextStyle(
                color: ApplicationColors.whiteColor,
                fontFamily: "Poppins-Regular",
                fontSize: 18),
          ),
          searchHintStyle: TextStyle(
              color: ApplicationColors.whiteColor,
              fontFamily: "Poppins-Regular",
              fontSize: 14),
          searchable: true,
          title: Text(
            "Search",
            style: TextStyle(
                color: ApplicationColors.whiteColor,
                fontFamily: "Poppins-Regular",
                fontSize: 14),
          ),
          backgroundColor: ApplicationColors.blackColor2E,
          selectedColor: ApplicationColors.redColor67,
          unselectedColor: ApplicationColors.textfieldBorderColor,
          searchTextStyle: TextStyle(
              color: ApplicationColors.whiteColor,
              fontFamily: "Poppins-SemiBold",
              fontSize: 15),
          itemsTextStyle: TextStyle(
              color: ApplicationColors.whiteColor,
              fontFamily: "Poppins-SemiBold",
              fontSize: 15),
          selectedItemsTextStyle: TextStyle(
              color: ApplicationColors.whiteColor,
              fontFamily: "Poppins-SemiBold",
              fontSize: 15),
          checkColor: ApplicationColors.redColor67,
          initialValue: _selectedVehicle,
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    _fuelProvider = Provider.of<FuelProvider>(context, listen: true);
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
          "${getTranslated(context, "fuel_small")}",
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
      ),
      floatingActionButton: selectValue == "FuelEntry"
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.red,
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => FuelEntryPage(
                                  vId: vehicleId,
                                  vName: vehicleName,
                                )));
                  },
                  child: Icon(Icons.add)),
            )
          : Container(),
      body: _reportProvider.isDropDownLoading
          ? Helper.dialogCall.showLoader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                      color:
                                          ApplicationColors.transparentColors),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          ApplicationColors.transparentColors),
                                ),
                                hintText:
                                    "${getTranslated(context, "search_vehicle")}",
                                hintStyle: TextStyle(
                                    color: ApplicationColors.black4240,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75),
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          ApplicationColors.transparentColors),
                                ),
                              ),
                              items:
                                  _reportProvider.userVehicleDropModel.devices,
                              itemAsString: (VehicleList u) => u.deviceName,
                              onChanged: (VehicleList data) {
                                setState(() {
                                  imeiNo = data.deviceId;
                                  vehicleId = data.id;
                                  vehicleName = data.deviceName;
                                  getFuelGraph();
                                  getFuelConsumeDailyDetails();
                                  getFuelConsumeTimeDetails();
                                  getFuelConsumeTripDetails();
                                  getFuelEntryDetails();
                                });
                              },
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: ApplicationColors.blackColor2E,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text("From Date"),
                                            TextFormField(
                                              readOnly: true,
                                              style: Textstyle1.signupText1,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: datedController,
                                              focusNode:
                                                  AlwaysDisabledFocusNode(),
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                dateTimeSelect();
                                                // setState(() {
                                                //   datedController.text = DateFormat("dd MMM yyyy").format(dateTimeSelect());
                                                // });
                                              },
                                              decoration: InputDecoration(
                                                isDense: true,
                                                hintText: "From Date",
                                                hintStyle:
                                                    Textstyle1.signupText1,
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("To Date"),
                                            TextFormField(
                                              readOnly: true,
                                              style: Textstyle1.signupText1,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _endDateController,
                                              focusNode:
                                                  AlwaysDisabledFocusNode(),
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                endDateTimeSelect();
                                              },
                                              decoration: InputDecoration(
                                                isDense: true,
                                                hintText: "To Date",
                                                hintStyle:
                                                    Textstyle1.signupText1,
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                  /*InkWell(
                          onTap: () {
                            // _showMultiSelect(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
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
                                      ? Wrap(
                                      children: _selectedVehicle
                                          .map(
                                            (vehicle) => Text(
                                          "${vehicle.deviceName}, ",
                                          style: TextStyle(
                                              color: ApplicationColors.whiteColor,
                                              fontSize: 14,
                                              fontFamily:
                                              "Poppins-Regular",
                                              letterSpacing: 0.75),
                                            ),
                                      ).toList())
                                      : Text(
                                    "Search vehicle",
                                    style: TextStyle(
                                        color:
                                        ApplicationColors.whiteColor,
                                        fontSize: 15,
                                        fontFamily: "Poppins-Regular",
                                        letterSpacing: 0.75),
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
                        ],
                      ),
                    ),
                  ),
                  vehicleId == ""
                      ? Container(
                          height: height - 170,
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
                      : _fuelProvider.isFuelGraphLoading
                          ? Helper.dialogCall.showLoader()
                          : Column(
                              children: [
                                SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      color: ApplicationColors.blackColor2E,
                                      borderRadius: BorderRadius.circular(5)),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 235,
                                        child: SfCartesianChart(
                                            plotAreaBorderWidth: 0,
                                            primaryXAxis: CategoryAxis(
                                              labelPlacement:
                                                  LabelPlacement.onTicks,
                                              majorGridLines:
                                                  const MajorGridLines(
                                                      width: 0),
                                              majorTickLines:
                                                  MajorTickLines(width: 0),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              majorTickLines:
                                                  MajorTickLines(width: 0),
                                              labelFormat: '{value}',
                                              axisLine:
                                                  const AxisLine(width: 0),
                                              majorGridLines: MajorGridLines(
                                                color: ApplicationColors
                                                    .textfieldBorderColor
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                            trackballBehavior:
                                                _trackballBehavior,
                                            zoomPanBehavior: zoomPanBehavior,
                                            series: <
                                                ChartSeries<FuelChart, String>>[
                                              selectFuel != "fuel"
                                                  ? SplineAreaSeries<FuelChart,
                                                      String>(
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: <Color>[
                                                          Color(0xff12A370),
                                                          Color(0xff24282E),
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      borderWidth: 2,
                                                      borderColor:
                                                          const Color.fromRGBO(
                                                              0, 156, 144, 1),
                                                      borderDrawMode:
                                                          BorderDrawMode.top,
                                                      dataSource: _fuelProvider
                                                          .fuelChart,
                                                      name:
                                                          "${getTranslated(context, "voltage")}",
                                                      xValueMapper:
                                                          (FuelChart sales,
                                                                  _) =>
                                                              sales.x,
                                                      yValueMapper:
                                                          (FuelChart sales,
                                                                  _) =>
                                                              sales.x2,
                                                    )
                                                  : SplineAreaSeries<FuelChart,
                                                          String>(
                                                      gradient: LinearGradient(
                                                        colors: <Color>[
                                                          Color(0xffF64848),
                                                          Color(0xffF64848)
                                                              .withOpacity(0.8),
                                                          Color(0xff24282E),
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      borderWidth: 2,
                                                      name:
                                                          "${getTranslated(context, "fuel_small")}",
                                                      borderColor:
                                                          ApplicationColors
                                                              .redColor,
                                                      borderDrawMode:
                                                          BorderDrawMode.top,
                                                      dataSource: _fuelProvider
                                                          .fuelChart,
                                                      xValueMapper:
                                                          (FuelChart sales,
                                                                  _) =>
                                                              sales.x,
                                                      yValueMapper:
                                                          (FuelChart sales,
                                                                  _) =>
                                                              sales.y)
                                            ]),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectFuel = "fuel";
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 13, vertical: 2),
                                              decoration: BoxDecoration(
                                                  color: selectFuel != "fuel"
                                                      ? Colors.transparent
                                                      : ApplicationColors
                                                          .redColor67,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: selectFuel ==
                                                              "fuel"
                                                          ? Colors.transparent
                                                          : ApplicationColors
                                                              .black4240)),
                                              child: Text(
                                                "${getTranslated(context, "fuel_small")}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: FontStyleUtilities.h12(
                                                  fontColor:
                                                      selectFuel == "fuel"
                                                          ? ApplicationColors
                                                              .whiteColor
                                                          : ApplicationColors
                                                              .black4240,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectFuel = "Voltage";
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 13, vertical: 2),
                                              decoration: BoxDecoration(
                                                  color: selectFuel != "Voltage"
                                                      ? Colors.transparent
                                                      : ApplicationColors
                                                          .greenColor370,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: selectFuel ==
                                                              "Voltage"
                                                          ? Colors.transparent
                                                          : ApplicationColors
                                                              .black4240)),
                                              child: Text(
                                                  "${getTranslated(context, "voltage")}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: FontStyleUtilities.h12(
                                                    fontColor:
                                                        selectFuel == "Voltage"
                                                            ? ApplicationColors
                                                                .whiteColor
                                                            : ApplicationColors
                                                                .black4240,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 4),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          color: ApplicationColors
                                              .textfieldBorderColor)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectValue = "FuelEntry";
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: selectValue == "FuelEntry"
                                                  ? ApplicationColors.redColor67
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Text(
                                                "${getTranslated(context, "fuel_entery")}",
                                                style: FontStyleUtilities.h14(
                                                    fontColor: selectValue ==
                                                            "FuelEntry"
                                                        ? ApplicationColors
                                                            .whiteColor
                                                        : ApplicationColors
                                                            .black4240)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectValue = "FuelConsumption";
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: selectValue ==
                                                      "FuelConsumption"
                                                  ? ApplicationColors.redColor67
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Text(
                                                "${getTranslated(context, "fuel_consumption")}",
                                                style: FontStyleUtilities.h14(
                                                    fontColor: selectValue ==
                                                            "FuelConsumption"
                                                        ? ApplicationColors
                                                            .whiteColor
                                                        : ApplicationColors
                                                            .black4240)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                selectValue == "FuelEntry"
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  filterType = "time";
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                    vertical: 7),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: filterType == "time"
                                                      ? ApplicationColors
                                                          .redColor67
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Text(
                                                    "${getTranslated(context, "time")}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor: filterType ==
                                                                "time"
                                                            ? ApplicationColors
                                                                .whiteColor
                                                            : ApplicationColors
                                                                .black4240)),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  filterType = "Daily";
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                    vertical: 7),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: filterType == "Daily"
                                                      ? ApplicationColors
                                                          .redColor67
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Text(
                                                    "${getTranslated(context, "daily")}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor: filterType ==
                                                                "Daily"
                                                            ? ApplicationColors
                                                                .whiteColor
                                                            : ApplicationColors
                                                                .black4240)),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  filterType = "Trip";
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                    vertical: 7),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: filterType == "Trip"
                                                      ? ApplicationColors
                                                          .redColor67
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Text(
                                                    "${getTranslated(context, "trip")}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor: filterType ==
                                                                "Trip"
                                                            ? ApplicationColors
                                                                .whiteColor
                                                            : ApplicationColors
                                                                .black4240)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                    height:
                                        selectValue == "FuelEntry" ? 0 : 20),
                                selectValue == "FuelEntry"
                                    ? _fuelProvider.isGetFuelEntryLoading
                                        ? Helper.dialogCall.showLoader()
                                        : _fuelProvider.getFuelEntryList.isEmpty
                                            ? Center(
                                                child: Text(
                                                  "${getTranslated(context, "fuel_not_avl")}",
                                                  textAlign: TextAlign.center,
                                                  style: Textstyle1.text18
                                                      .copyWith(
                                                    fontSize: 18,
                                                    color: ApplicationColors
                                                        .redColor67,
                                                  ),
                                                ),
                                              )
                                            : ListView.builder(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 0, 20, 80),
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: _fuelProvider
                                                    .getFuelEntryList.length,
                                                itemBuilder: (context, index) {
                                                  var list = _fuelProvider
                                                      .getFuelEntryList[index];
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            22, 10, 0, 10),
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color: ApplicationColors
                                                          .blackColor2E,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${list.vehicle.deviceName}",
                                                          style: FontStyleUtilities.h16(
                                                              fontColor:
                                                                  ApplicationColors
                                                                      .black4240,
                                                              fontweight:
                                                                  FWT.bold),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ApplicationColors
                                                                    .redColor67,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Text(
                                                                list.quantity ==
                                                                        null
                                                                    ? "0.0 ${getTranslated(context, "liters")}"
                                                                    : "${NumberFormat("##0.0#", "en_US").format(double.parse(list.quantity))} ${getTranslated(context, "liters")}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                maxLines: 1,
                                                                style:
                                                                    FontStyleUtilities
                                                                        .h12(
                                                                  fontColor:
                                                                      ApplicationColors
                                                                          .whiteColor,
                                                                  fontweight:
                                                                      FWT.bold,
                                                                ),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "${list.price}",
                                                              style: FontStyleUtilities.h16(
                                                                  fontColor:
                                                                      ApplicationColors
                                                                          .black4240,
                                                                  fontweight:
                                                                      FWT.bold),
                                                            ),
                                                            PopupMenuButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                color: ApplicationColors
                                                                    .blackColor2E,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                icon: Icon(
                                                                    Icons
                                                                        .more_vert,
                                                                    color: ApplicationColors
                                                                        .redColor67),
                                                                itemBuilder:
                                                                    (context) =>
                                                                        [
                                                                          PopupMenuItem(
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (BuildContext context) => EditFuelEntryPage(index: index, vName: list.vehicle.deviceName),
                                                                                    ));
                                                                              },
                                                                              child: Row(
                                                                                children: [
                                                                                  Image.asset(
                                                                                    "assets/images/Edit_icon.png",
                                                                                    color: ApplicationColors.redColor67,
                                                                                    height: 23,
                                                                                    width: 23,
                                                                                  ),
                                                                                  SizedBox(width: 20),
                                                                                  Text(
                                                                                    "${getTranslated(context, "edit")}",
                                                                                    style: FontStyleUtilities.h14(fontColor: ApplicationColors.black4240, fontweight: FWT.regular),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            value:
                                                                                1,
                                                                          ),
                                                                          PopupMenuItem(
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                deleteFuel(list.id);
                                                                              },
                                                                              child: Row(
                                                                                children: [
                                                                                  Image.asset(
                                                                                    "assets/images/delete_icon.png",
                                                                                    color: ApplicationColors.redColor67,
                                                                                    height: 23,
                                                                                    width: 23,
                                                                                  ),
                                                                                  SizedBox(width: 20),
                                                                                  Text(
                                                                                    "${getTranslated(context, "delete")}",
                                                                                    style: FontStyleUtilities.h14(fontColor: ApplicationColors.black4240, fontweight: FWT.regular),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            value:
                                                                                2,
                                                                          )
                                                                        ]),
                                                          ],
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          list.date == null
                                                              ? "${getTranslated(context, "date_not_available")}"
                                                              : DateFormat(
                                                                      "MMM dd,yyyy hh:mm aa")
                                                                  .format(list
                                                                      .date),
                                                          style: FontStyleUtilities.h10(
                                                              fontColor:
                                                                  ApplicationColors
                                                                      .black4240,
                                                              fontweight:
                                                                  FWT.light),
                                                        ),
                                                        SizedBox(height: 2),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                    : filterType == "time"
                                        ? _fuelProvider
                                                .isFuelConsumeTimeListLoading
                                            ? Helper.dialogCall.showLoader()
                                            : _fuelProvider
                                                    .getFuelConsumeTimeList
                                                    .isEmpty
                                                ? Center(
                                                    child: Text(
                                                      "${getTranslated(context, "fuel_consumption_not_avl")}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Textstyle1.text18
                                                          .copyWith(
                                                        fontSize: 18,
                                                        color: ApplicationColors
                                                            .redColor67,
                                                      ),
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 20, 80),
                                                    shrinkWrap: true,
                                                    itemCount: _fuelProvider
                                                        .getFuelConsumeTimeList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var list = _fuelProvider
                                                              .getFuelConsumeTimeList[
                                                          index];
                                                      return Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                22, 10, 0, 10),
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              ApplicationColors
                                                                  .blackColor2E,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              list.vehicleName,
                                                              style: FontStyleUtilities.h16(
                                                                  fontColor:
                                                                      ApplicationColors
                                                                          .black4240,
                                                                  fontweight:
                                                                      FWT.bold),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "${getTranslated(context, "fuel_con")}",
                                                                        style: FontStyleUtilities.h10(
                                                                            fontColor:
                                                                                ApplicationColors.black4240,
                                                                            fontweight: FWT.light),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              2),
                                                                      Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                10,
                                                                            vertical:
                                                                                2),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              ApplicationColors.redColor67,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "${NumberFormat("##0.0#", "en_US").format(list.fuelConsumed)} ${getTranslated(context, "liters")}",
                                                                          style: FontStyleUtilities.h12(
                                                                              fontColor: ApplicationColors.whiteColor,
                                                                              fontweight: FWT.bold),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        "${getTranslated(context, "in_count")}",
                                                                        style: FontStyleUtilities.h10(
                                                                            fontColor:
                                                                                ApplicationColors.black4240,
                                                                            fontweight: FWT.light),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              2),
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child:
                                                                            Text(
                                                                          "${NumberFormat("##0.0#", "en_US").format(list.inEventCount)}",
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style: FontStyleUtilities.h12(
                                                                              fontColor: ApplicationColors.black4240,
                                                                              fontweight: FWT.bold),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        "${getTranslated(context, "out_count")}",
                                                                        style: FontStyleUtilities.h10(
                                                                            fontColor:
                                                                                ApplicationColors.black4240,
                                                                            fontweight: FWT.light),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              2),
                                                                      Text(
                                                                        "${NumberFormat("##0.0#", "en_US").format(list.outEventCount)}",
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: FontStyleUtilities.h12(
                                                                            fontColor:
                                                                                ApplicationColors.black4240,
                                                                            fontweight: FWT.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        "${getTranslated(context, "distance")}",
                                                                        style: FontStyleUtilities.h10(
                                                                            fontColor:
                                                                                ApplicationColors.black4240,
                                                                            fontweight: FWT.light),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              2),
                                                                      Text(
                                                                        "${NumberFormat("##0.0#", "en_US").format(list.distance)} ${getTranslated(context, "Km")}",
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: FontStyleUtilities.h12(
                                                                            fontColor:
                                                                                ApplicationColors.black4240,
                                                                            fontweight: FWT.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
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
                                                                  _fuelProvider
                                                                          .getFuelTimeStartAddressList[
                                                                      index],
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      Textstyle1
                                                                          .text10,
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
                                                                  _fuelProvider
                                                                          .getFuelTimeEndAddressList[
                                                                      index],
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      Textstyle1
                                                                          .text10,
                                                                )),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  )
                                        : filterType == "Daily"
                                            ? _fuelProvider
                                                    .isFuelConsumeDailyListLoading
                                                ? Helper.dialogCall.showLoader()
                                                : _fuelProvider
                                                        .getFuelConsumeDailyList
                                                        .isEmpty
                                                    ? Center(
                                                        child: Text(
                                                          "${getTranslated(context, "fuel_consumption_not_avl")}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Textstyle1
                                                              .text18
                                                              .copyWith(
                                                            fontSize: 18,
                                                            color:
                                                                ApplicationColors
                                                                    .redColor67,
                                                          ),
                                                        ),
                                                      )
                                                    : ListView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 0, 20, 80),
                                                        shrinkWrap: true,
                                                        itemCount: _fuelProvider
                                                            .getFuelConsumeDailyList
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var list = _fuelProvider
                                                                  .getFuelConsumeDailyList[
                                                              index];
                                                          return Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(22,
                                                                    10, 0, 10),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: ApplicationColors
                                                                  .blackColor2E,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "$vehicleName",
                                                                  style: FontStyleUtilities.h16(
                                                                      fontColor:
                                                                          ApplicationColors
                                                                              .black4240,
                                                                      fontweight:
                                                                          FWT.bold),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "${getTranslated(context, "fuel_con")}",
                                                                            style:
                                                                                FontStyleUtilities.h10(fontColor: ApplicationColors.black4240, fontweight: FWT.light),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: ApplicationColors.redColor67,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              "${NumberFormat("##0.0#", "en_US").format(list.fuelConsumed)} ${getTranslated(context, "liters")}",
                                                                              style: FontStyleUtilities.h12(fontColor: ApplicationColors.whiteColor, fontweight: FWT.bold),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            "${getTranslated(context, "in_count")}",
                                                                            style:
                                                                                FontStyleUtilities.h10(fontColor: ApplicationColors.black4240, fontweight: FWT.light),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child:
                                                                                Text(
                                                                              "${NumberFormat("##0.0#", "en_US").format(list.inEventCount)}",
                                                                              textAlign: TextAlign.right,
                                                                              style: FontStyleUtilities.h12(fontColor: ApplicationColors.black4240, fontweight: FWT.bold),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            "${getTranslated(context, "out_count")}",
                                                                            style:
                                                                                FontStyleUtilities.h10(fontColor: ApplicationColors.black4240, fontweight: FWT.light),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Text(
                                                                            "${NumberFormat("##0.0#", "en_US").format(list.outEventCount)}",
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                            style:
                                                                                FontStyleUtilities.h12(fontColor: ApplicationColors.black4240, fontweight: FWT.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            "${getTranslated(context, "distance")}",
                                                                            style:
                                                                                FontStyleUtilities.h10(fontColor: ApplicationColors.black4240, fontweight: FWT.light),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Text(
                                                                            "${NumberFormat("##0.0#", "en_US").format(list.distance)}  ${getTranslated(context, "Km")}",
                                                                            overflow:
                                                                                TextOverflow.visible,
                                                                            maxLines:
                                                                                1,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                FontStyleUtilities.h12(fontColor: ApplicationColors.black4240, fontweight: FWT.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
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
                                                                        child:
                                                                            Text(
                                                                      _fuelProvider
                                                                              .getFuelDailyStartAddressList[
                                                                          index],
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: Textstyle1
                                                                          .text10,
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
                                                                        width:
                                                                            10,
                                                                        color: ApplicationColors
                                                                            .redColor67),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Text(
                                                                      _fuelProvider
                                                                              .getFuelDailyEndAddressList[
                                                                          index],
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: Textstyle1
                                                                          .text10,
                                                                    )),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      )
                                            : _fuelProvider
                                                    .isFuelConsumeTripListLoading
                                                ? Helper.dialogCall.showLoader()
                                                : _fuelProvider
                                                        .getFuelConsumeTripList
                                                        .isEmpty
                                                    ? Center(
                                                        child: Text(
                                                          "${getTranslated(context, "fuel_consumption_trip_not_avl")}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Textstyle1
                                                              .text18
                                                              .copyWith(
                                                            fontSize: 18,
                                                            color:
                                                                ApplicationColors
                                                                    .redColor67,
                                                          ),
                                                        ),
                                                      )
                                                    : ListView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 0, 20, 80),
                                                        shrinkWrap: true,
                                                        itemCount: _fuelProvider
                                                            .getFuelConsumeTripList
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var list = _fuelProvider
                                                                  .getFuelConsumeTripList[
                                                              index];
                                                          return Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(22,
                                                                    10, 0, 10),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: ApplicationColors
                                                                  .blackColor2E,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${list.vehicleName}",
                                                                  style: FontStyleUtilities.h16(
                                                                      fontColor:
                                                                          ApplicationColors
                                                                              .black4240,
                                                                      fontweight:
                                                                          FWT.bold),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "${getTranslated(context, "fuel_con")}",
                                                                            style:
                                                                                FontStyleUtilities.h10(fontColor: ApplicationColors.black4240, fontweight: FWT.light),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: ApplicationColors.redColor67,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              "${NumberFormat("##0.0#", "en_US").format(list.fuelConsumed)} ${getTranslated(context, "liters")}",
                                                                              style: FontStyleUtilities.h12(fontColor: ApplicationColors.whiteColor, fontweight: FWT.bold),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            "${getTranslated(context, "in_count")}",
                                                                            style:
                                                                                FontStyleUtilities.h10(fontColor: ApplicationColors.black4240, fontweight: FWT.light),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child:
                                                                                Text(
                                                                              "${NumberFormat("##0.0#", "en_US").format(list.inEventCount)}",
                                                                              textAlign: TextAlign.right,
                                                                              style: FontStyleUtilities.h12(fontColor: ApplicationColors.black4240, fontweight: FWT.bold),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            "${getTranslated(context, "out_count")}",
                                                                            style:
                                                                                FontStyleUtilities.h10(fontColor: ApplicationColors.black4240, fontweight: FWT.light),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Text(
                                                                            "${NumberFormat("##0.0#", "en_US").format(list.outEventCount)}",
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.visible,
                                                                            style:
                                                                                FontStyleUtilities.h12(fontColor: ApplicationColors.black4240, fontweight: FWT.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            "${getTranslated(context, "distance")}",
                                                                            style:
                                                                                FontStyleUtilities.h10(fontColor: ApplicationColors.black4240, fontweight: FWT.light),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Text(
                                                                            "${NumberFormat("##0.0#", "en_US").format(list.distance)} ${getTranslated(context, "Km")}",
                                                                            overflow:
                                                                                TextOverflow.visible,
                                                                            maxLines:
                                                                                1,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                FontStyleUtilities.h12(fontColor: ApplicationColors.black4240, fontweight: FWT.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
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
                                                                        child:
                                                                            Text(
                                                                      _fuelProvider
                                                                              .getFuelTripStartAddressList[
                                                                          index],
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: Textstyle1
                                                                          .text10,
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
                                                                        width:
                                                                            10,
                                                                        color: ApplicationColors
                                                                            .redColor67),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Text(
                                                                      _fuelProvider
                                                                              .getFuelTripEndAddressList[
                                                                          index],
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: Textstyle1
                                                                          .text10,
                                                                    )),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      )
                              ],
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
            "${DateFormat("dd MMM yyyy hh:mm aa").format(fromDatePicked)}";
        fromDate = datedController.text;
      });

      if (vehicleId != null && datedController.text.isNotEmpty) {
        getFuelGraph();
        getFuelConsumeTimeDetails();
        getFuelConsumeDailyDetails();
        getFuelConsumeTripDetails();
        getFuelEntryDetails();
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

      if (vehicleId != null && _endDateController.text.isNotEmpty) {
        getFuelGraph();
        getFuelConsumeTimeDetails();
        getFuelConsumeDailyDetails();
        getFuelConsumeTripDetails();
        getFuelEntryDetails();
      }
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
