import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/add_vehicle_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/SuparAdmin/AddVehicle/device_model.dart';
import 'package:oneqlik/screens/SuparAdmin/AddVehicle/select_dealer.dart';
import 'package:oneqlik/screens/SuparAdmin/AddVehicle/select_user.dart';
import 'package:oneqlik/screens/SuparAdmin/AddVehicle/vehicle_type.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:oneqlik/widgets/simple_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({Key key}) : super(key: key);

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  TextEditingController datedController = TextEditingController();
  TextEditingController deviceId = TextEditingController();
  TextEditingController registrationConroller = TextEditingController();
  TextEditingController simNoController = TextEditingController();
    TextEditingController simNo2Controller = TextEditingController();

  TextEditingController selectDealerController = TextEditingController();
  TextEditingController deviceModelController = TextEditingController();
  TextEditingController selectUserController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  AddVehicleProvider addVehicleProvider;

  var dealerId, userId, vehicleTypeId, deviceModelId;

  addVehicles() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "devicename": registrationConroller.text,
      "deviceid": deviceId.text,
      "typdev": "Tracker",
      "sim_number": simNoController.text,
      "created_by": "$id",
      "supAdmin": "$id",
      "device_model": deviceModelId,
      "expdate": datedController.text,
      "Dealer": dealerId,
      "sim_number2": simNo2Controller.text,
      "user": userId,
      "vehicleType": vehicleTypeId,
    };
    print(jsonEncode(data));
    addVehicleProvider.addVehicle(data, "devices/addDevice", context);
  }

  @override
  void initState() {
    super.initState();
    addVehicleProvider =
        Provider.of<AddVehicleProvider>(context, listen: false);
    DateTime today = DateTime.now();
    DateTime nextYear = today.add(Duration(days: 365));
    String formattedDate = nextYear.toLocal().toString().split(' ')[0];

    datedController.text = formattedDate.toString();
  }

  double total = 0;

  startScanning() async {
    FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "Cancel", false, ScanMode.BARCODE)
        .then((value) {
      setState(() {
        deviceId.text = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    addVehicleProvider = Provider.of<AddVehicleProvider>(context, listen: true);

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
            color: ApplicationColors.white9F9,
            size: 26,
          ),
        ),
        title: Text(
          "${getTranslated(context, "add_vehicle")}",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Arial',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[
                Color(0xffd21938),
                Color(0xff751c1e),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: InkWell(
        onTap: () async {
          if (_forMKey.currentState.validate()) {
            addVehicles();
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
            'Add Vehicle',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _forMKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${getTranslated(context, "device_imei")}",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.black4240,
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: deviceId,
                            textAlign: TextAlign.start,
                            // borderColor: ApplicationColors.textfieldBorderColor,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "${getTranslated(context, "enter_device_id")}";
                              }
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        startScanning();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        height: 45,
                        width: 46,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset("assets/images/scanner.png"),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ApplicationColors.redColor67,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Text("${getTranslated(context, "registration_number*")}",
                    overflow: TextOverflow.ellipsis,
                    style: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240)),
                TextFormField(
                  controller: registrationConroller,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.start,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_reg_num")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "${getTranslated(context, "sim_num")}",
                  overflow: TextOverflow.ellipsis,
                  style: FontStyleUtilities.h14(
                    fontColor: ApplicationColors.black4240,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: simNoController,

                  /* inputFormatter: [
                    LengthLimitingTextInputFormatter(
                        10),
                  ],*/
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_sim_num")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "Sim Number 2",
                  overflow: TextOverflow.ellipsis,
                  style: FontStyleUtilities.h14(
                    fontColor: ApplicationColors.black4240,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: simNo2Controller,

                  /* inputFormatter: [
                    LengthLimitingTextInputFormatter(
                        10),
                  ],*/
                ),
                SizedBox(height: height * 0.02),
                Text("${getTranslated(context, "expire_on*")}",
                    overflow: TextOverflow.ellipsis,
                    style: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240)),
                TextFormField(
                  readOnly: true,
                  style: FontStyleUtilities.h14(
                      fontColor: ApplicationColors.black4240),
                  keyboardType: TextInputType.number,
                  controller: datedController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "select_date")}";
                    }
                    return null;
                  },
                  focusNode: AlwaysDisabledFocusNode(),
                  onTap: () async {
                    FocusScope.of(context).unfocus();

                    DateTime newSelectedDate = await _selecttDate(context);
                    if (newSelectedDate != null) {
                      setState(() {
                        datedController.text =
                            DateFormat("dd-MMM-yyyy").format(newSelectedDate);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ApplicationColors.redColor,
                      ),
                    ),
                    errorStyle: FontStyleUtilities.h12(
                      fontColor: ApplicationColors.redColor,
                    ),
                    hintText: "${getTranslated(context, "select_date")}",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Image.asset(
                        "assets/images/date_icon.png",
                        color: ApplicationColors.redColor67,
                        width: 20,
                      ),
                    ),
                    hintStyle: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240),
                    isDense: true,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text("${getTranslated(context, "device_model")}",
                    overflow: TextOverflow.ellipsis,
                    style: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240)),
                TextFormField(
                  controller: deviceModelController,
                  readOnly: true,
                  onTap: () async {
                    var value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DeviceModelScreen()));
                    if (value != null) {
                      setState(() {
                        deviceModelController.text = value[0];
                        deviceModelId = value[1];
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down,
                        color: ApplicationColors.redColor67, size: 30),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_device_model")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                SizedBox(height: height * 0.02),
                Text("${getTranslated(context, "select_dealers")}",
                    overflow: TextOverflow.ellipsis,
                    style: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240)),
                TextFormField(
                  controller: selectDealerController,
                  readOnly: true,
                  onTap: () async {
                    final value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SelectDealerScreen()));
                    if (value != null) {
                      setState(() {
                        selectDealerController.text = value[0];
                        dealerId = value[1];
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down,
                        color: ApplicationColors.redColor67, size: 30),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_select_dealer")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                SizedBox(height: height * 0.02),
                Text("${getTranslated(context, "select_user")}",
                    style: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240)),
                TextFormField(
                  controller: selectUserController,
                  readOnly: true,
                  onTap: () async {
                    if (dealerId != null) {
                      var value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SelectUserScreen(dealerId: dealerId)));
                      if (value != null) {
                        setState(() {
                          selectUserController.text = value[0];
                          userId = value[1];
                        });
                      }
                    } else {
                      Helper.dialogCall.showToast(context,
                          "${getTranslated(context, "select_dealers_first")}");
                    }
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down,
                        color: ApplicationColors.redColor67, size: 30),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_select_user")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                SizedBox(height: height * 0.02),
                Text("${getTranslated(context, "vehicle_type")}",
                    overflow: TextOverflow.ellipsis,
                    style: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240)),
                SizedBox(height: height * 0.01),
                TextFormField(
                  controller: vehicleTypeController,
                  readOnly: true,
                  onTap: () async {
                    var value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                VehicleTypeScreen()));
                    if (value != null) {
                      setState(() {
                        vehicleTypeController.text = value[0];
                        vehicleTypeId = value[1];
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down,
                        color: ApplicationColors.redColor67, size: 30),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_vehicle_type")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
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
      initialDate: DateTime.now().add(Duration(days: 365)),
      // firstDate: DateTime.now().subtract(Duration(days: 10)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
