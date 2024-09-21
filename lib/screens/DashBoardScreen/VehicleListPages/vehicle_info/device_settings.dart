import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneqlik/Model/vehicle_list_model.dart';
import 'package:oneqlik/Provider/vehicle_list_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VehicleListDeviceSettingPage extends StatefulWidget {
  VehicleLisDevice vehicleLisDevice;
  VehicleListDeviceSettingPage({Key key,this.vehicleLisDevice}) : super(key: key);

  @override
  _VehicleListDeviceSettingPageState createState() => _VehicleListDeviceSettingPageState();
}

class _VehicleListDeviceSettingPageState extends State<VehicleListDeviceSettingPage> {


  TextEditingController _vehicleNameController = TextEditingController();
  TextEditingController _todayOdoController = TextEditingController();
  TextEditingController _fuelMileageController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _driverNameController = TextEditingController();

  VehicleListProvider vehicleListProvider;

  bool isSuperAdmin = false;
  bool isDealer = false;
  bool superAdmin = false;

  SharedPreferences sharedPreferences;

  bool selectGeofences = false;

  var width, height;
  double _value = 0;


  updateDeviceSettings() async{

    var data = {
      "speed": _value,
      "Mileage": _fuelMileageController.text,
      "ignDetection": selectGeofences ?"ACC":"Movement",
      "digitalInput": selectGeofences ?"ACC":"Movement",
      "analogInput": widget.vehicleLisDevice.analogInput,
      "fuelMeasurement": _fuelMileageController.text,
      "currency": widget.vehicleLisDevice.currency,
      "device_model": widget.vehicleLisDevice.deviceModel.id,
      "overStoppedLimit":  widget.vehicleLisDevice.overStoppedLimit,
      "overIdleLimit":  widget.vehicleLisDevice.overIdleLimit,
      "_id": widget.vehicleLisDevice.id,
      "dphone":_phoneController.text,
      "virtualacc":  widget.vehicleLisDevice.virtualacc,
      "tripType":  widget.vehicleLisDevice.tripType,
      "total_odo": _todayOdoController.text,
      "ac_wire_setting":  widget.vehicleLisDevice.ac_wire_setting,
      "drname": _driverNameController.text,
      "devicename": _vehicleNameController.text,
    };

    vehicleListProvider.updateDeviceSettings(data, "devices/deviceupdate", context);

  }


  getDetails() async {

    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      isSuperAdmin = sharedPreferences.getBool("superAdmin");
      superAdmin = sharedPreferences.getBool("isSuperAdmin");
      isDealer = sharedPreferences.getBool("isDealer");
    });

  }

  @override
  void initState() {

    super.initState();
    getDetails();
    vehicleListProvider = Provider.of<VehicleListProvider>(context, listen: false);
    _vehicleNameController.text = widget.vehicleLisDevice.deviceName;
    _driverNameController.text = widget.vehicleLisDevice.driverName;
    _todayOdoController.text = "${widget.vehicleLisDevice.totalOdo.toStringAsFixed(2)}";
    _fuelMileageController.text = widget.vehicleLisDevice.mileage;
    _phoneController.text = widget.vehicleLisDevice.contactNumber;
    _value = double.parse("${widget.vehicleLisDevice.speedLimit}");
    selectGeofences = widget.vehicleLisDevice.ignitionSource == "ACC" ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    vehicleListProvider = Provider.of<VehicleListProvider>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: ApplicationColors.whiteColorF9
           /* image: DecorationImage(
              image: AssetImage(
                  "assets/images/dark_background_image.png"
              ), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),*/
          ),
        ),
        Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: (){
                updateDeviceSettings();
              },
              child: Container(
                decoration: Boxdec.buttonBoxDecRed_r6,
                width: width,
                height: height * .057,
                child:
                Center(
                    child: Text(
                        "${getTranslated(context, "submit")}",
                        style: Textstyle1.text18bold.copyWith(color: Colors.white)
                    )
                ),
              ),
            ),
          ),
          appBar: AppBar(
            titleSpacing: -10,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 13.0, top: 13),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset("assets/images/vector_icon.png",color: ApplicationColors.redColor67)),
            ),
            title: Text(
                "${getTranslated(context, "device_setting")}",
                style: Textstyle1.appbartextstyle1
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: ApplicationColors.blackColor2E,
                borderRadius: BorderRadius.circular(9)
            ),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    "${getTranslated(context, "Vehicle_Name")}",
                    style: Textstyle1.text14,
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: _vehicleNameController,
                    style: Textstyle1.text12b,
                    decoration: Textfield1.inputdec.copyWith(
                      
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                                  color: ApplicationColors.redColor67
                              )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ApplicationColors.dropdownColor3D
                          )
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Text(
                    "${getTranslated(context, "Driver_Name")}",
                    style: Textstyle1.text14,
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: _driverNameController,
                    style: Textstyle1.text12b,
                    decoration: Textfield1.inputdec.copyWith(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ApplicationColors.redColor67
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ApplicationColors.dropdownColor3D
                          )
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Text(
                    "${getTranslated(context, "mobile_number")}",
                    style: Textstyle1.text14,
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    style: Textstyle1.text12b,
                    decoration: Textfield1.inputdec.copyWith(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ApplicationColors.redColor67
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ApplicationColors.dropdownColor3D
                          )
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Text(
                    "${getTranslated(context, "Total_ODO")}",
                    style: Textstyle1.text14,
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: _todayOdoController,
                    style: Textstyle1.text12b,
                    decoration: Textfield1.inputdec.copyWith(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ApplicationColors.redColor67
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ApplicationColors.dropdownColor3D
                          )
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Text(
                    "${getTranslated(context, "fuel_mileage")}",
                    style: Textstyle1.text14,
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: _fuelMileageController,
                    style: Textstyle1.text12b,
                    validator:
                        (value) {
                      FocusScope.of(context).unfocus();
                      if (value == null ||
                          value == '') {
                        return "${getTranslated(context, "enter_num")}";
                      } else if (value.length <
                          10) {
                        return "${getTranslated(context, "entervalid_num")}";
                      } else {
                        return null;
                      }
                    },
                    decoration: Textfield1.inputdec.copyWith(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ApplicationColors.redColor67
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ApplicationColors.dropdownColor3D
                          )
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "${getTranslated(context, "speed_limit")}",
                        style: Textstyle1.text14,
                        )
                      ),
                      Text(
                       "${_value.round()}",
                        style: Textstyle1.text14,
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Image.asset(
                        "assets/images/spaeed_limit.png",  color:ApplicationColors.redColor67 ,
                        width: 15,
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: ApplicationColors.redColor67,
                          min: 0,
                          max: 250,
                          value: _value,
                          onChanged: (double value) {
                            setState(() {
                              _value = value;
                            });
                          },
                        ),
                      ),
                      Image.asset(
                        "assets/images/spaeed_limit.png",  color:ApplicationColors.redColor67 ,
                        width: 15,
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  superAdmin == true  || isDealer == true || isSuperAdmin == true
                      ?
                  Text(
                    "${getTranslated(context, "ignition_detection")}",
                    style: Textstyle1.text14,
                  ): SizedBox(),

                  SizedBox(height: 10),
                  superAdmin == true  || isDealer == true || isSuperAdmin == true
                      ?
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectGeofences = !selectGeofences;
                            });
                          },
                          child: Container(
                            width: width * .03,
                            height: height * .013,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: selectGeofences == false
                                    ? ApplicationColors.redColor67
                                    : ApplicationColors.dropdownColor3D,
                                border: Border.all(
                                    color: ApplicationColors.redColor67
                                )
                            ),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${getTranslated(context, "movment")}",
                        style: Textstyle1.text14,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectGeofences = true;
                            });
                          },
                          child: Container(
                            width: width * .03,
                            height: height * .013,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: selectGeofences == true
                                    ? ApplicationColors.redColor67
                                    : ApplicationColors.dropdownColor3D,
                                border: Border.all(
                                    color: ApplicationColors.redColor67
                                )
                            ),
                          )
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${getTranslated(context, "acc")}",
                        style: Textstyle1.text14,
                      )
                    ],
                  ) : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
