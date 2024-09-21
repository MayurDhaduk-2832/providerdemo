import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:oneqlik/Helper/custom_dialog.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/TypeModel.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/maintenance_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/VehicleMaintenancePages/maintenance_submit_page.dart';
import 'package:oneqlik/screens/ProductsFilterPage/vehicle_filter.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MaintenanceReminderPage extends StatefulWidget {
  String deviceName, deviceId;

  MaintenanceReminderPage({Key key, this.deviceName, this.deviceId})
      : super(key: key);

  @override
  _MaintenanceReminderPageState createState() =>
      _MaintenanceReminderPageState();
}

class _MaintenanceReminderPageState extends State<MaintenanceReminderPage> {
  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = TextEditingController();
  var chooseExpenseType = "";

  MaintenanceProvider maintenanceProvider;
  ReportProvider _reportProvider;

  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 30)))}T00:00:00.000Z";
  var toDate = DateTime.now().toUtc().toString();
  var vehicleId = "";

  report() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from": fromDate,
      "to": toDate,
      "user": id,
      "device": widget.deviceId,
      "type": "$chooseExpenseType"
    };

    var data1 = {
      "from": fromDate,
      "to": toDate,
      "user": id,
    };

    print(data);
    maintenanceProvider.getVehicleReminder(
      _selectedVehicle.isNotEmpty == null ? data1 : data,
      "reminder/getReminders",
    );
  }

  getMaintenance() async {
    var idList = "";
    String list = "";

    if (_selectedVehicle.isNotEmpty) {
      if (_selectedVehicle.isNotEmpty) {
        for (int i = 0; i < _selectedVehicle.length; i++) {
          idList = idList + "${_selectedVehicle[i].id},";
        }
      }
      list = idList.substring(0, idList.length - 1);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "from": fromDate,
      "to": toDate,
      "user": id,
      "device": list,
      "type": "$chooseExpenseType"
    };

    var data1 = {
      "from": fromDate,
      "to": toDate,
      "user": id,
    };

    print(data);
    maintenanceProvider.getVehicleReminder(
      _selectedVehicle.isNotEmpty == null ? data1 : data,
      "reminder/getReminders",
    );
  }

  getDeviceByUserDropdown() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");

    var data = {"email": email, "id": id};

    await _reportProvider.getVehicleDropdown(
        data, "devices/getDeviceByUserDropdown");
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
              getMaintenance();
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
            '${getTranslated(context, "search")}',
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

  getType() async {
    var data = {"type": "reminder"};

    await maintenanceProvider.getDocType(data, "typeMaster/get");
  }

  @override
  void initState() {
    super.initState();
    datedController = TextEditingController()
      ..text =
          "${DateFormat("dd MMM yyyy hh:mm a").format(DateTime.now().subtract(Duration(days: 30)))}";
    _endDateController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy hh:mm a").format(DateTime.now())}";
    maintenanceProvider =
        Provider.of<MaintenanceProvider>(context, listen: false);
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    getType();
    getDeviceByUserDropdown();
    maintenanceProvider.maintenanceList.clear();
    getMaintenance();
    if (widget.deviceName != null) {
      report();
    }
  }

  @override
  Widget build(BuildContext context) {
    maintenanceProvider =
        Provider.of<MaintenanceProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
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
          '${getTranslated(context, "maintenance_reminder")}',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MaintenanceSubmitPage()));
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Multiple Select

          Container(
            decoration: BoxDecoration(
              color: ApplicationColors.blackColor2E,
              boxShadow: [
                BoxShadow(
                    color: ApplicationColors.appColors0.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0.1,
                    offset: Offset(0.0, 2.0)),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _showMultiSelect(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _selectedVehicle.isNotEmpty
                              ? Container(
                                  height: 30,
                                  padding: EdgeInsets.only(top: 3),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _selectedVehicle.length,
                                    itemBuilder: (context, index) {
                                      return Text(
                                        "${_selectedVehicle[index].deviceName}",
                                        style: TextStyle(
                                            color: ApplicationColors.black4240,
                                            fontSize: 14,
                                            fontFamily: "Poppins-Regular",
                                            letterSpacing: 0.75),
                                      );
                                    },
                                  ),
                                )
                              : Text(
                                  '${widget.deviceName == null ? getTranslated(context, "search_vehicle") : widget.deviceName}',
                                  style: TextStyle(
                                      color: ApplicationColors.black4240,
                                      fontSize: 15,
                                      fontFamily: "Poppins-Regular",
                                      letterSpacing: 0.75),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 08),
                  child: Container(
                    child: DropdownButtonFormField<TypeModel>(
                        iconEnabledColor: ApplicationColors.redColor67,
                        isExpanded: true,
                        isDense: true,
                        decoration: InputDecoration(
                            hintText:
                                '${getTranslated(context, "Reminder_type")}',
                            labelStyle: FontStyleUtilities.h14(
                                fontColor: ApplicationColors.black4240),
                            hintStyle: FontStyleUtilities.h14(
                                fontColor: ApplicationColors.black4240),
                            contentPadding: EdgeInsets.only(left: 1),
                            border: InputBorder.none),
                        dropdownColor: ApplicationColors.whiteColor,

                        //value: chooseExpenseType,
                        onChanged: (value) {
                          setState(() {
                            chooseExpenseType = value.name;
                          });
                        },
                        items: /*[
                          '${getTranslated(context, "service")}',
                          '${getTranslated(context, "oil_change")}',
                          '${getTranslated(context, "tyres")}',
                          '${getTranslated(context, "maintenance")}',
                          '${getTranslated(context, "auto_repain")}',
                          '${getTranslated(context, "baby_work")}',
                          '${getTranslated(context, "diagnostics")}',
                          '${getTranslated(context, "tune_up")}',
                          '${getTranslated(context, "break_job")}',
                          '${getTranslated(context, "oil_filter_change")}',
                          '${getTranslated(context, "tire_care")}',
                          '${getTranslated(context, "towing")}',
                          '${getTranslated(context, "balance_aligment")}',
                          '${getTranslated(context, "fleet")}',
                          '${getTranslated(context, "auto_tracking")}',
                          '${getTranslated(context, "ac_repair")}',
                          '${getTranslated(context, "others")}',
                          '${getTranslated(context, "subscription")}',
                          '${getTranslated(context, "docunment_type")}',
                        ]*/
                            maintenanceProvider.remainderTypeList
                                .map(
                                  (TypeModel value) => DropdownMenuItem(
                                    child: Text(
                                      value.name,
                                      style: FontStyleUtilities.h14(
                                        fontColor: ApplicationColors.black4240,
                                        fontFamily: 'Poppins-Regular',
                                      ),
                                    ),
                                    value: value,
                                  ),
                                )
                                .toList()),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("From Date"),
                            TextFormField(
                              readOnly: true,
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
                                hintText:
                                    '${getTranslated(context, "from_date")}',
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
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("End Date"),
                            TextFormField(
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
                                isDense: true,
                                hintStyle: Textstyle1.signupText1,
                                hintText:
                                    '${getTranslated(context, "end_date")}',
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: maintenanceProvider.isMaintenanceLoading ||
                      _reportProvider.isDropDownLoading
                  ? Helper.dialogCall.showLoader()
                  : maintenanceProvider.maintenanceList.length == 0
                      ? Center(
                          child: Text(
                            "${getTranslated(context, "maintenance_not_available")}",
                            textAlign: TextAlign.center,
                            style: Textstyle1.text18.copyWith(
                              fontSize: 18,
                              color: ApplicationColors.redColor67,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: maintenanceProvider.maintenanceList.length,
                          padding: const EdgeInsets.only(bottom: 80),
                          itemBuilder: (context, index) {
                            var list =
                                maintenanceProvider.maintenanceList[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 5),
                              child: TimelineTile(
                                alignment: TimelineAlign.manual,
                                lineXY: 0.2,
                                hasIndicator: true,
                                afterLineStyle: LineStyle(
                                    color:
                                        ApplicationColors.textfieldBorderColor,
                                    thickness: 1),
                                beforeLineStyle: LineStyle(
                                    color:
                                        ApplicationColors.textfieldBorderColor,
                                    thickness: 1),
                                indicatorStyle: IndicatorStyle(
                                    color: ApplicationColors.redColor67,
                                    height: 15,
                                    width: 15),
                                endChild: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    // color: ApplicationColors.blackColor2E,
                                    gradient: LinearGradient(
                                      tileMode: TileMode.clamp,
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        Color(0xFF9ac760),
                                        Color(0xFFd1e7a6),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.local_taxi,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                list.vehicleName == null
                                                    ? "No Data"
                                                    : '${list.vehicleName}',
                                                style: FontStyleUtilities.h14(
                                                  fontColor: Colors.white,
                                                  fontweight: FWT.regular,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '${list.reminderType}',
                                            style: FontStyleUtilities.h14(
                                              fontColor: Colors.white,
                                              fontweight: FWT.regular,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${DateFormat("h:mm\na").format(list.createdOn)}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Arial",
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 28,
                                                width: 28,
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/images/notify_ic.png",
                                                    width: 15,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: list.notificationType
                                                              .pushNotification ==
                                                          true
                                                      ? ApplicationColors
                                                          .greenColor370
                                                      : ApplicationColors
                                                          .redColor67,
                                                  borderRadius:
                                                      BorderRadius.circular(28),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: ApplicationColors
                                                          .black4240,
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
                                              SizedBox(width: 8),
                                              Container(
                                                height: 28,
                                                width: 28,
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/images/message.png",
                                                    width: 13,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: list.notificationType
                                                              .sms ==
                                                          true
                                                      ? ApplicationColors
                                                          .greenColor370
                                                      : ApplicationColors
                                                          .redColor67,
                                                  borderRadius:
                                                      BorderRadius.circular(28),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: ApplicationColors
                                                          .black4240,
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
                                              SizedBox(width: 8),
                                              Container(
                                                height: 28,
                                                width: 28,
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/images/email.png",
                                                    width: 15,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      list.notificationType
                                                                  .email ==
                                                              true
                                                          ? ApplicationColors
                                                              .greenColor370
                                                          : ApplicationColors
                                                              .redColor67,
                                                  borderRadius:
                                                      BorderRadius.circular(28),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: ApplicationColors
                                                          .black4240,
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
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                startChild: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${DateFormat("E").format(DateTime.parse("${list.reminderDate}"))}",
                                      style: FontStyleUtilities.h18(
                                        fontColor: Colors.grey,
                                        fontweight: FWT.regular,
                                      ),
                                    ),
                                    Text(
                                      "${DateFormat("dd").format(DateTime.parse("${list.reminderDate}"))}",
                                      style: FontStyleUtilities.h24(
                                          fontColor:
                                              ApplicationColors.black4240,
                                          fontweight: FWT.regular),
                                    ),
                                    Text(
                                      "${DateFormat("MMM, yyyy").format(DateTime.parse("${list.reminderDate}"))}",
                                      style: FontStyleUtilities.h12(
                                          fontColor: ApplicationColors.greyC4C4,
                                          fontweight: FWT.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
        ],
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
      lastDate: DateTime(2050),
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
            dialogBackgroundColor: ApplicationColors.black4240,
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
        fromDate = fromDatePicked.toUtc().toString();
        // datedController.text = "${DateFormat("dd MMM yyyy ").format(fromDatePicked.toUtc())+ DateFormat.jm().format(fromDatePicked.toUtc())}";
        // fromDate = datedController.text;
        // this.fromDatePicked = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      });

      if (datedController.text != null) {
        getMaintenance();
      }
    }
  }

  endDateTimeSelect() async {
    date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
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
        toDate = endDatePicked.toUtc().toString();
      });

      if (_endDateController.text != null) {
        getMaintenance();
      }
    }
  }
}
