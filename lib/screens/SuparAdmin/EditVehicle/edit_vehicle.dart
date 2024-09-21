import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneqlik/Provider/add_vehicle_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Helper/helper.dart';
import '../../../components/styleandborder.dart';
import '../../../local/localization/language_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/font_utils.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../DashBoardScreen/DrawerPages/CustomerSupportPages/ContactUsScreen/contact_us_screen.dart';
import '../AddVehicle/device_model.dart';
import '../AddVehicle/select_dealer.dart';
import '../AddVehicle/select_user.dart';
import '../AddVehicle/vehicle_type.dart';

class EditVehicle extends StatefulWidget {
  var deviceidimei,
      reginumber,
      simnumber,
      simnumber2,
      drivername,
      drivermobnumber,
      speedlimit,
      expiredate,
      devicemodel,
      devicemodelID,
      dealer,
      user,
      userID,
      id,
      vehicletype,
      vehiclemodel,
      vehicletypeID;

  EditVehicle({
    Key,
    key,
    this.deviceidimei,
    this.reginumber,
    this.simnumber,
    this.simnumber2,
    this.drivername,
    this.drivermobnumber,
    this.speedlimit,
    this.expiredate,
    this.devicemodel,
    this.dealer,
    this.devicemodelID,
    this.user,
    this.userID,
    this.id,
    this.vehicletype,
    this.vehiclemodel,
    this.vehicletypeID,
  }) : super(key: key);

  @override
  State<EditVehicle> createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  TextEditingController datedController = TextEditingController();
  TextEditingController deviceId = TextEditingController();
  TextEditingController registrationConroller = TextEditingController();
  TextEditingController simNoController = TextEditingController();
  TextEditingController simNo2Controller = TextEditingController();
  TextEditingController selectDealerController = TextEditingController();
  TextEditingController deviceModelController = TextEditingController();
  TextEditingController selectUserController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController DriverNameController = TextEditingController();
  TextEditingController DriverNumberController = TextEditingController();
  TextEditingController SpeedLimitController = TextEditingController();

  var dealerId, userId, vehicleTypeId, deviceModelId, vehiclemodel, deviceID;

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();
  AddVehicleProvider addVehicleProvider;

  updateVehicles() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "_id": deviceID,
      "devicename": registrationConroller.text,
      "sim": simNoController.text,
      "deviceid": deviceId.text,
      "speed": SpeedLimitController.text,
      "user": userId,
      "vehicleGroup": "",
      "updatedBy": id,
      "device_model": deviceModelId,
      "vehicleType": vehicleTypeId,
      "Dealer": dealerId,
      "deviceDistanceVariation": "+0",
      "expdate": datedController.text,
      "renew_by": id,
      "sim_number2": simNo2Controller.text,
      "total_odo": "0.0",
    };
    print(data);
    print(jsonEncode(data));

    addVehicleProvider.updateVehicle(data, "devices/deviceupdate", context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviceId.text = widget.deviceidimei;
    registrationConroller.text = widget.reginumber;
    simNoController.text = widget.simnumber;
    simNo2Controller.text = widget.simnumber2;
    DriverNameController.text = widget.drivername;
    DriverNumberController.text = widget.drivermobnumber;
    SpeedLimitController.text = widget.speedlimit.toString();
    datedController.text = widget.expiredate.toString();
    deviceModelController.text = widget.devicemodel.toString();
    deviceModelId = widget.devicemodelID;
    selectUserController.text = widget.user.toString();
    vehicleTypeController.text = widget.vehicletype.toString();
    dealerId = widget.dealer.toString();
    userId = widget.userID;
    deviceID = widget.id;
    vehicleTypeId = widget.vehicletypeID;
    vehiclemodel = widget.vehiclemodel;
    print("-----${widget.vehicletype}");
    print("driver name-----${widget.drivername}");
    print("delaer id-----${widget.dealer}");
    addVehicleProvider =
        Provider.of<AddVehicleProvider>(context, listen: false);
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
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_sharp,
            color: ApplicationColors.white9F9,
            size: 26,
          ),
        ),
        title: Text(
          "${getTranslated(context, "edit_vehicle")}",
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
            updateVehicles();
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
            'UPDATE VEHICLE DETAIL',
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
          padding: EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 60),
          child: Form(
            key: _forMKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("${getTranslated(context, "device_imei")}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: deviceId,
                        textAlign: TextAlign.start,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "enter_device_id")}";
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Text("${getTranslated(context, "registration_number*")}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
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
                SizedBox(height: height * 0.01),
                Text(
                  "${getTranslated(context, "sim_num")}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: FontStyleUtilities.h14(
                    fontColor: ApplicationColors.black4240,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: simNoController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_sim_num")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                SizedBox(height: height * 0.01),
                widget.simnumber2 != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sim Number 2",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.black4240,
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: simNo2Controller,
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: height * 0.01),
                Text(
                  "${getTranslated(context, "Driver_Name")}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: FontStyleUtilities.h14(
                    fontColor: ApplicationColors.black4240,
                  ),
                ),
                TextFormField(
                  controller: DriverNameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_driver_name")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "${getTranslated(context, "mobile_number")}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: FontStyleUtilities.h14(
                    fontColor: ApplicationColors.black4240,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: DriverNumberController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_driver_mobile")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "${getTranslated(context, "speed_limit")}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: FontStyleUtilities.h14(
                    fontColor: ApplicationColors.black4240,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: DriverNumberController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_speed_limit")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                SizedBox(height: height * 0.02),
                Text("${getTranslated(context, "expire_on*")}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240)),
                SizedBox(height: height * 0.01),
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
                  // focusNode: AlwaysDisabledFocusNode(),
                  onTap: () async {
                    FocusScope.of(context).unfocus();

                    /*  DateTime newSelectedDate =
                    await _selecttDate(context);
                    if (newSelectedDate != null) {
                      setState(() {
                        datedController.text = DateFormat("dd-MMM-yyyy").format(newSelectedDate);
                      });
                    }*/
                  },
                  decoration: fieldStyle.copyWith(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ApplicationColors.redColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    errorStyle: FontStyleUtilities.h12(
                      fontColor: ApplicationColors.redColor,
                    ),
                    hintText: "${getTranslated(context, "select_date")}",
                    fillColor: ApplicationColors.transparentColors,
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                ApplicationColors.whiteColor.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(5)),
                    // contentPadding:
                    // const EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ApplicationColors.textfieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text("${getTranslated(context, "device_model")}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
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
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.edit,
                        color: ApplicationColors.blackbackcolor, size: 24),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
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
                    maxLines: 1,
                    textAlign: TextAlign.start,
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
                    suffixIcon: Icon(Icons.edit,
                        color: ApplicationColors.blackbackcolor, size: 24),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    /*  if (value.isEmpty) {
                      return "${getTranslated(
                          context, "enter_select_dealer")}";
                    }
                    FocusScope.of(context).unfocus();*/
                  },
                ),
                SizedBox(height: height * 0.02),
                Text("${getTranslated(context, "select_user")}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
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
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.edit,
                        color: ApplicationColors.blackbackcolor, size: 24),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
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
                    maxLines: 1,
                    textAlign: TextAlign.start,
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
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.edit,
                        color: ApplicationColors.blackbackcolor, size: 24),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
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
