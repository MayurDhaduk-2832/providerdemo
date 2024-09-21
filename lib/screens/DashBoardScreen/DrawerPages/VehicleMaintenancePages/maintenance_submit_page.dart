import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Model/TypeModel.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/maintenance_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:oneqlik/widgets/simple_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../ProductsFilterPage/vehicle_filter.dart';

class MaintenanceSubmitPage extends StatefulWidget {
  const MaintenanceSubmitPage({Key key}) : super(key: key);

  @override
  _MaintenanceSubmitPageState createState() => _MaintenanceSubmitPageState();
}

class _MaintenanceSubmitPageState extends State<MaintenanceSubmitPage> {
  TextEditingController datedController = TextEditingController();
  TextEditingController reminderDayController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();
  TextEditingController odoController = new TextEditingController();

  DateTime newSelectedDate = DateTime.now();

  var reminderType;
  var chooseCurrency;
  var choosePaymentMode;

  ReportProvider _reportProvider;
  MaintenanceProvider maintenanceProvider;

  List<bool> notificationType = [true, false, false];

  GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  var vehicleId = "", vehicleName = "";

  addReminder() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data = {
      "created_by": id,
      "user": id,
      "device": vehicleId.toString(),
      "reminder_type": reminderType.toString(),
      "notification_type": {
        "SMS": notificationType[0],
        "EMAIL": notificationType[1],
        "PUSH_NOTIFICATION": notificationType[2],
      },
      "reminder_date": newSelectedDate.toUtc().toString(),
      "prior_reminder": int.parse(reminderDayController.text),
      "status": "Pending",
      "vehicleName": vehicleName.toString(),
      "note": noteController.text,
      "odo": odoController.text
    };

    print(jsonEncode(data));

    maintenanceProvider.addReminder(data, "reminder/addReminder", context);
  }

  @override
  void initState() {
    super.initState();
    maintenanceProvider =
        Provider.of<MaintenanceProvider>(context, listen: false);
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    maintenanceProvider =
        Provider.of<MaintenanceProvider>(context, listen: true);

    _reportProvider = Provider.of<ReportProvider>(context, listen: false);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
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
      bottomNavigationBar: InkWell(
        onTap: () async {
          print("submit click");
          if (_forMKey.currentState.validate()) {
            addReminder();
          } else {
            print("error");
          }
        },
        child: Container(
          height: 60,
          width: width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              tileMode: TileMode.clamp,
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF574e51),
                Color(0xFF1f2326),
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '  ${getTranslated(context, "submit")}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _forMKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Theme(
                  data: ThemeData(
                    textTheme:
                        TextTheme(subtitle1: TextStyle(color: Colors.black87)),
                  ),
                  child: DropdownSearch<VehicleList>(
                    popupBackgroundColor: ApplicationColors.blackColor2E,
                    mode: Mode.DIALOG,
                    showAsSuffixIcons: true,
                    dialogMaxWidth: width,
                    // selectedItem: widget.vId,
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
                          ),
                        ),
                        hintText: '${getTranslated(context, "search_vehicle")}',
                        hintStyle: TextStyle(
                            color: ApplicationColors.black4240,
                            fontSize: 15,
                            fontFamily: "Poppins-Regular",
                            letterSpacing: 0.75),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    dropdownSearchBaseStyle: TextStyle(
                      color: ApplicationColors.black4240,
                      fontSize: 15,
                      fontFamily: "Poppins-Regular",
                    ),

                    dropdownSearchDecoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: '${getTranslated(context, "search_vehicle")}',
                      hintStyle: TextStyle(
                        color: ApplicationColors.black4240,
                        fontSize: 15,
                        fontFamily: "Poppins-Regular",
                      ),
                      border: InputBorder.none,
                    ),

                    items: _reportProvider.userVehicleDropModel.devices,
                    itemAsString: (VehicleList u) => u.deviceName,
                    onChanged: (VehicleList data) {
                      setState(() {
                        vehicleId = data.id;
                        vehicleName = data.deviceName;
                      });
                    },
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                TextFormField(
                  style: Textstyle1.signupText.copyWith(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.phone,
                  controller: odoController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ApplicationColors.transparentColors),
                    ),
                    isDense: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ApplicationColors.transparentColors),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: ApplicationColors.redColor67),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ApplicationColors.redColor67),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ApplicationColors.transparentColors),
                    ),
                    hintText: '${getTranslated(context, "odo_meter")}',
                    hintStyle: Textstyle1.text14,
                    errorStyle: FontStyleUtilities.h12(
                      fontColor: ApplicationColors.redColor,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Center(
                  child: TextFormField(
                    readOnly: true,
                    style: Textstyle1.signupText.copyWith(
                      color: ApplicationColors.black4240,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${getTranslated(context, "select_reminder_date")}';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: datedController,
                    focusNode: AlwaysDisabledFocusNode(),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      newSelectedDate = await _selecttDate(context);

                      if (newSelectedDate != null) {
                        setState(() {
                          datedController.text =
                              DateFormat("dd MMM yyyy").format(newSelectedDate);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      errorStyle: FontStyleUtilities.h12(
                        fontColor: ApplicationColors.redColor,
                      ),
                      isDense: true,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationColors.transparentColors),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationColors.transparentColors),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ApplicationColors.redColor67),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationColors.transparentColors),
                      ),
                      hintText: '${getTranslated(context, "select_date")}',
                      hintStyle: Textstyle1.text14,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                DropdownButtonFormField<TypeModel>(
                    iconEnabledColor: ApplicationColors.redColor67,
                    isExpanded: true,
                    validator: (value) {
                      if (value == null) {
                        return '${getTranslated(context, "select_reminder_type")}';
                      } else {
                        return null;
                      }
                    },
                    isDense: true,
                    decoration: InputDecoration(
                      hintText: '${getTranslated(context, "Reminder_type*")}',
                      errorStyle: FontStyleUtilities.h12(
                        fontColor: ApplicationColors.redColor,
                      ),
                      labelStyle: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.black4240),
                      hintStyle: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.black4240),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationColors.transparentColors),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ApplicationColors.redColor67),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationColors.transparentColors),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationColors.transparentColors),
                      ),
                    ),
                    dropdownColor: ApplicationColors.dropdownColor3D,
                    onChanged: (value) {
                      setState(() {
                        reminderType = value.name;
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
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  style: Textstyle1.signupText.copyWith(
                    color: Colors.black,
                  ),
                  controller: reminderDayController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return '${getTranslated(context, "add_reminder_days")}';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ApplicationColors.transparentColors),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ApplicationColors.transparentColors),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ApplicationColors.redColor67),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ApplicationColors.redColor67),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ApplicationColors.transparentColors),
                    ),
                    hintText: '${getTranslated(context, "reminder_days")}',
                    hintStyle: Textstyle1.text14,
                    errorStyle: FontStyleUtilities.h12(
                      fontColor: ApplicationColors.redColor,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                SimpleTextField(
                  hintStyle: TextStyle(color: ApplicationColors.black4240),
                  textAlign: TextAlign.start,
                  maxLine: 3,
                  controller: noteController,
                  borderColor: ApplicationColors.transparentColors,
                  hintText: '${getTranslated(context, "additional")}',
                  validator: (value) {
                    if (value.isEmpty) {
                      return '${getTranslated(context, "enter_reference")}';
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '${getTranslated(context, "select_notification")}',
                      style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.black4240,
                          fontweight: FWT.light),
                    ),
                    TextSpan(
                      text: " *",
                      style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.redColor67,
                          fontweight: FWT.light),
                    )
                  ]),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          notificationType[0] = !notificationType[0];
                        });
                      },
                      child: Container(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 23,
                              width: 23,
                              decoration: BoxDecoration(
                                  color: notificationType[0] == true
                                      ? ApplicationColors.redColor67
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ApplicationColors.redColor67,
                                    width: 1.5,
                                  )),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${getTranslated(context, "sms")}',
                              style: FontStyleUtilities.h13().copyWith(
                                letterSpacing: 0.2,
                                color: ApplicationColors.black4240,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          notificationType[1] = !notificationType[1];
                        });
                      },
                      child: Container(
                        width: 85,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 23,
                              width: 23,
                              decoration: BoxDecoration(
                                  color: notificationType[1] == true
                                      ? ApplicationColors.redColor67
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ApplicationColors.redColor67,
                                    width: 1.5,
                                  )),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${getTranslated(context, "mail")}',
                              style: FontStyleUtilities.h13().copyWith(
                                letterSpacing: 0.2,
                                color: ApplicationColors.black4240,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          notificationType[2] = !notificationType[2];
                        });
                      },
                      child: Container(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 23,
                              width: 23,
                              decoration: BoxDecoration(
                                  color: notificationType[2] == true
                                      ? ApplicationColors.redColor67
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ApplicationColors.redColor67,
                                    width: 1.5,
                                  )),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${getTranslated(context, "Notification")}',
                                style: FontStyleUtilities.h13().copyWith(
                                  letterSpacing: 0.2,
                                  color: ApplicationColors.black4240,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: ApplicationColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
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
