import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/custom_dialog.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/history.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/history_new.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ProductsFilterPage/vehicle_filter.dart';

class TripReportScreen extends StatefulWidget {
  String deviceId, vName;

  TripReportScreen({Key key, this.deviceId, this.vName}) : super(key: key);

  @override
  _TripReportScreenState createState() => _TripReportScreenState();
}

class _TripReportScreenState extends State<TripReportScreen> {
  LatLng startLocation = LatLng(21.1607672, 72.8175179);
  //LatLng startLocation ;
  LatLng endLocation = LatLng(21.1609081, 72.8255265);
  Position position;
  GoogleMapController mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyDNmQ3sok_q3O9JZ66cFJgzFfiJiDWESmY";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

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
  var toDate = DateTime.now().toUtc().toString();

  report() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from_date": fromDate,
      "to_date": toDate,
      "uId": id,
      "device": widget.deviceId,
    };

    print('CheckData-->$data');

    _reportProvider.tripDetailReport(data, "user_trip/trip_detail");
  }

  tripDetailsReport() async {
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
      "from_date": fromDate,
      "to_date": toDate,
      "uId": id,
      "device": list,
    };

    print('CheckData-->$data');

    _reportProvider.tripDetailReport(data, "user_trip/trip_detail");
  }

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
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    datedController = TextEditingController()
      ..text =
          "From Date\n${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}";
    _endDateController = TextEditingController()
      ..text =
          "To Date\n${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}";
    _reportProvider.tripDetailsReportList.clear();
    getDeviceByUserDropdown();
    if (widget.deviceId != null) {
      report();
    }
  }

  var exportType = "excel";

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
              tripDetailsReport();
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
          "${getTranslated(context, "trip_report")}",
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
                                                              .tripDetailsReportList
                                                              .length;
                                                      i++) {
                                                    sendList.add(""
                                                        "Vehicle Name : ${_reportProvider.tripDetailsReportList[i]['device']['Device_Name']}  "
                                                        "\n\n"
                                                        "Duration: ${DateFormat.H().format(DateTime.parse(_reportProvider.tripDetailsReportList[i]['device']['last_device_time']))}h ${DateFormat.m().format(DateTime.parse(_reportProvider.tripDetailsReportList[i]['device']['last_device_time']))}m"
                                                        "\n\n"
                                                        "Start Time : ${DateFormat("MMM dd, yyyy hh:mm aa").format(DateTime.parse(_reportProvider.tripDetailsReportList[i]['start_time']))}"
                                                        "\n\n"
                                                        // "Start Address : ${_reportProvider.tripDetailsReportList[i]['startAddress']}"
                                                        "Start Address : ${_reportProvider.startAdressTripDetailList[i]}"
                                                        "\n\n"
                                                        "End Time : ${DateFormat("MMM dd, yyyy hh:mm aa").format(DateTime.parse(
                                                      _reportProvider
                                                              .tripDetailsReportList[
                                                          i]['end_time'],
                                                    ))}"
                                                        "\n\n"
                                                        // "End Address : ${_reportProvider.tripDetailsReportList[i]['endAddress']}"
                                                        "End Address : ${_reportProvider.endAdressTripDetailList[i]}"
                                                        "\n\n"
                                                        "Distance : ${NumberFormat("##0.0#", "en_US").format(_reportProvider.tripDetailsReportList[i]['distance'])} Kms"
                                                        "\n\n");
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

                                                  // generatePdf(sendList,
                                                  //     "vehicleName");
                                                } else {
                                                  List sendList = [];
                                                  for (int i = 0;
                                                      i <
                                                          _reportProvider
                                                              .tripDetailsReportList
                                                              .length;
                                                      i++) {
                                                    var data = {
                                                      "a":
                                                          "${_reportProvider.tripDetailsReportList[i]['device']['Device_Name']} ",
                                                      "b": "${DateFormat.H().format(DateTime.parse(_reportProvider.tripDetailsReportList[i]['device']['last_device_time']))}h "
                                                          "${DateFormat.m().format(DateTime.parse(_reportProvider.tripDetailsReportList[i]['device']['last_device_time']))}m",
                                                      "c":
                                                          "${DateFormat("MMM dd, yyyy hh:mm aa").format(DateTime.parse(
                                                        _reportProvider
                                                                .tripDetailsReportList[
                                                            i]['start_time'],
                                                      ))}",
                                                      "d":
                                                          "${_reportProvider.startAdressTripDetailList[i]}",
                                                      // "${_reportProvider
                                                      //     .tripDetailsReportList[i]['startAddress']}",
                                                      "e":
                                                          " ${DateFormat("MMM dd, yyyy hh:mm aa").format(DateTime.parse(
                                                        _reportProvider
                                                                .tripDetailsReportList[
                                                            i]['end_time'],
                                                      ))}",
                                                      "f":
                                                          "${_reportProvider.endAdressTripDetailList[i]}",
                                                      // "${_reportProvider
                                                      //     .tripDetailsReportList[i]['endAddress']}",
                                                      "g":
                                                          "${NumberFormat("##0.0#", "en_US").format(_reportProvider.tripDetailsReportList[i]['distance'])} Kms",
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
                                                    'Last Device Time',
                                                    'Start Time',
                                                    'Start Address',
                                                    'End Time',
                                                    'End Address',
                                                    'Distance',
                                                    "",
                                                    "",
                                                    "",
                                                    "",
                                                    "",
                                                  ];

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
                                                    generateExcel(sendList,
                                                        list, excelTitle);
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
      body: _reportProvider.isDropDownLoading
          ? Helper.dialogCall.showLoader()
          : SingleChildScrollView(
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
                        SizedBox(height: 5),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _showMultiSelect(context);
                              },
                              child: _selectedVehicle.isNotEmpty
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _selectedVehicle.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                  : Row(
                                      children: [
                                        Text(
                                          "${widget.vName == null ? getTranslated(context, "search_vehicle") : widget.vName}",
                                          style: TextStyle(
                                              color:
                                                  ApplicationColors.black4240,
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
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            SizedBox(height: 5),
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
                                      toDate =
                                          DateTime.now().toUtc().toString();

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
                                      toDate =
                                          DateTime.now().toUtc().toString();

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
                                      var yesterdayMidnightUtc = DateTime.utc(
                                          yesterday.year,
                                          yesterday.month,
                                          yesterday.day);
                                      // var fromDate1 = "${DateTime.now().subtract(Duration(days: 1))}";
                                      toDate =
                                          DateTime.now().toUtc().toString();

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
                                      toDate =
                                          DateTime.now().toUtc().toString();

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
                                      fillColor:
                                          ApplicationColors.transparentColors,
                                      isDense: true,
                                      hintText: "From Date",
                                      hintStyle: Textstyle1.signupText.copyWith(
                                        color: ApplicationColors.blackbackcolor,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ApplicationColors
                                              .transparentColors,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ApplicationColors
                                              .transparentColors,
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ApplicationColors
                                              .transparentColors,
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
                                      fillColor:
                                          ApplicationColors.transparentColors,
                                      isDense: true,
                                      hintText: "To Date",
                                      hintStyle: Textstyle1.signupText.copyWith(
                                        color: ApplicationColors.blackbackcolor,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ApplicationColors
                                              .transparentColors,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ApplicationColors
                                              .transparentColors,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ApplicationColors
                                              .transparentColors,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.70,
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _reportProvider.isTripDetailsReportLoading
                          ? Helper.dialogCall.showLoader()
                          // Center(
                          //         child: SpinKitThreeBounce(
                          //           color: ApplicationColors.redColor67,
                          //           size: 25,
                          //         ),
                          //       )
                          : _reportProvider.tripDetailsReportList.length == 0
                              ? Center(
                                  child: Text(
                                    "${getTranslated(context, "trip_not_available")}",
                                    textAlign: TextAlign.center,
                                    style: Textstyle1.text18.copyWith(
                                      fontSize: 18,
                                      color: ApplicationColors.redColor67,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: _reportProvider
                                      .tripDetailsReportList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HistoryPage(
                                              toDate: toDate,
                                              formDate: fromDate,
                                              deviceName: _reportProvider
                                                      .tripDetailsReportList[i]
                                                  ['device']['Device_Name'],
                                              deviceId: _reportProvider
                                                      .tripDetailsReportList[i]
                                                  ['device']['Device_ID'],
                                              vId: _reportProvider
                                                      .tripDetailsReportList[i]
                                                  ['_id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          IntrinsicHeight(
                                            child: Container(
                                              decoration: Boxdec.bcgreyrad6
                                                  .copyWith(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                              padding: EdgeInsets.all(2),
                                              child: Stack(
                                                children: [
                                                  GoogleMap(
                                                    //Map widget from google_maps_flutter package
                                                    //zoomGesturesEnabled: true, //enable Zoom in, out on map
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                      //innital position in map
                                                      target: startLocation,
                                                      //initial position
                                                      zoom:
                                                          16.0, //initial zoom level
                                                    ),
                                                    markers: markers,
                                                    //markers to show on map
                                                    polylines: Set<Polyline>.of(
                                                        polylines.values),
                                                    //polylines
                                                    mapType: Utils.mapType,
                                                    //map type
                                                    onMapCreated: (controller) {
                                                      //method called when map is created
                                                      setState(() {
                                                        mapController =
                                                            controller;
                                                      });
                                                    },
                                                  ),
                                                  Positioned(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height:
                                                              height * .12312,
                                                        ),
                                                        IntrinsicHeight(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 16,
                                                                    right: 16,
                                                                    top: 20,
                                                                    bottom: 20),
                                                            decoration: Boxdec
                                                                .conrad6colorblack,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/car_icon.png",
                                                                      color: ApplicationColors
                                                                          .redColor67,
                                                                      width: 15,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            7),
                                                                    Text(
                                                                      "${_reportProvider.tripDetailsReportList[i]['device']['Device_Name']}",
                                                                      style: Textstyle1
                                                                          .text14bold,
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            SizedBox()),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        _reportProvider.tripDetailsReportList[i]['device']['last_device_time'] ==
                                                                                null
                                                                            ? ""
                                                                            : "Duration: ${DateFormat.H().format(DateTime.parse(_reportProvider.tripDetailsReportList[i]['device']['last_device_time']))}h ${DateFormat.m().format(DateTime.parse(_reportProvider.tripDetailsReportList[i]['device']['last_device_time']))}m",
                                                                        style: Textstyle1
                                                                            .text10,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/clock_icon_vehicle_Page.png",
                                                                      width: 10,
                                                                      color: ApplicationColors
                                                                          .greenColor370,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        "${DateFormat("MMM dd, yyyy hh:mm aa").format(DateTime.parse(_reportProvider.tripDetailsReportList[i]['start_time']).toLocal())}",
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                        style: Textstyle1
                                                                            .text10,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child: SizedBox(
                                                                            width:
                                                                                10)),
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
                                                                        child:
                                                                            Text(
                                                                      _reportProvider.startAdressTripDetailList.isEmpty ||
                                                                              _reportProvider.startAdressTripDetailList[i] == null
                                                                          ? "Address Not Found"
                                                                          : "${_reportProvider.startAdressTripDetailList[i]}",
                                                                      // _reportProvider.tripDetailsReportList[i]['device']['startAddress'] == null
                                                                      // ?
                                                                      // "Address not found"
                                                                      // :
                                                                      // "${_reportProvider.tripDetailsReportList[i]['device']['startAddress']}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      maxLines:
                                                                          2,
                                                                      style: Textstyle1
                                                                          .text10,
                                                                    )),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/clock_icon_vehicle_Page.png",
                                                                      width: 10,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        _reportProvider.tripDetailsReportList[i]['end_time'] ==
                                                                                null
                                                                            ? ""
                                                                            : "${DateFormat("MMM dd, yyyy hh:mm aa").format(DateTime.parse(_reportProvider.tripDetailsReportList[i]['end_time']).toLocal())}",
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: Textstyle1
                                                                            .text10,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            SizedBox()),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 7),
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
                                                                        child:
                                                                            Text(
                                                                      _reportProvider.endAdressTripDetailList.isEmpty ||
                                                                              _reportProvider.endAdressTripDetailList[i] == null
                                                                          ? "Address Not Found"
                                                                          : "${_reportProvider.endAdressTripDetailList[i]}",
                                                                      // _reportProvider.tripDetailsReportList[i]['device']['endAddress'] == null
                                                                      // ?
                                                                      // "Address not found"
                                                                      // :
                                                                      // "${_reportProvider.tripDetailsReportList[i]['device']['endAddress']}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      maxLines:
                                                                          2,
                                                                      style: Textstyle1
                                                                          .text10,
                                                                    )),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                      right: 10,
                                                      top: height * .07,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(9),
                                                        height: height * .050,
                                                        width: width * .30,
                                                        decoration: Boxdec
                                                            .bcgreyrad25
                                                            .copyWith(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: ApplicationColors
                                                                    .blackColor2E),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                _reportProvider.tripDetailsReportList[i]
                                                                            [
                                                                            'distance'] !=
                                                                        null
                                                                    ? "${convertInKM(_reportProvider.tripDetailsReportList[i]['distance'].toString())} Kms"
                                                                    : "0 Kms",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: Textstyle1
                                                                    .text12
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black),
                                                              ),
                                                            ),
                                                            Image.asset(
                                                                "assets/images/spped_meter.png",
                                                                color: ApplicationColors
                                                                    .redColor67,
                                                                width: 16),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10)
                                        ],
                                      ),
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
        //  fromDate = datedController.text;
        fromDate = fromDatePicked.toUtc().toLocal().toString();
      });

      //  rescheduleTodo(=);
      if (datedController.text.isNotEmpty && _selectedVehicle.length != 0) {
        tripDetailsReport();
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
        //toDate = _endDateController.text;
        toDate = endDatePicked.toUtc().toLocal().toString();
      });

      //  rescheduleTodo(=);
      if (_endDateController.text.isNotEmpty && _selectedVehicle.length != 0) {
        tripDetailsReport();
      }
    }
  }
}
