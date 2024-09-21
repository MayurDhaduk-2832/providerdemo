import 'dart:developer';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Provider/vehicle_list_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkingSchedulerPage extends StatefulWidget {
  final vName,vId;
  const ParkingSchedulerPage({Key key, this.vName, this.vId}) : super(key: key);

  @override
  _ParkingSchedulerPageState createState() => _ParkingSchedulerPageState();
}

class _ParkingSchedulerPageState extends State<ParkingSchedulerPage> {
  DatePickerController _controller = DatePickerController();
  DateTime _startdateTime = DateTime.now();
  DateTime _enddateTime = DateTime.now();
  DateTime _selectedValue = DateTime.now();
  bool parkingAlert = false;
  var height, width;

  bool selectDateCalendar = false;

  VehicleListProvider vehicleListProvider;

  parkingScheduler() async{
log('hello${  parkingAlert }');
    var data =
    {
      "_id": widget.vId,
      "theftAlert":parkingAlert,
      "theftTime": {
        "start": "${DateFormat("yyyy-MM-dd").format(_selectedValue)}T${DateFormat("hh:mm:ss").format(_startdateTime)}.000Z",
        "end": "${DateFormat("yyyy-MM-dd").format(_selectedValue)}T${DateFormat("hh:mm:ss").format(_enddateTime)}.000Z",
      }

    };

    print('datacheck-->$data');

    vehicleListProvider.parkingScheduler(data, "devices/deviceupdate", context);

    setState(() {

    });
  }

  parkingSchedulerAlert() async{
    log('hello${  parkingAlert }');
    var data =
    {
      "_id": widget.vId,
      "theftAlert":parkingAlert,
    };

    vehicleListProvider.parkingScheduler(data, "devices/deviceupdate", context);
    setState(() {

    });
  }



  customApi() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data =
    {
      "user": "$id",
      "id": widget.vId,
      "fields": "theftAlert",
    };

    print("parking->$data");log('hello${  parkingAlert }');
   await vehicleListProvider.customApi(data, "devices/getDeviceCustomApi", context);
   log('vehicleListProvider.body["theftAlert"]===${vehicleListProvider.body["theftAlert"]}');

    setState(() {
      parkingAlert = vehicleListProvider.body["theftAlert"];
    });
   if(vehicleListProvider.isCustomSuccess){
       setState(() {
         parkingAlert = vehicleListProvider.body["theftAlert"];
       });
       log('vehicleListProvider===>${parkingAlert.runtimeType}');
     }
  }

  @override
  void initState() {
    super.initState();
    vehicleListProvider = Provider.of<VehicleListProvider>(context,listen: false);
    customApi();
  }

  @override
  Widget build(BuildContext context) {

    vehicleListProvider = Provider.of<VehicleListProvider>(context,listen: true);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
            color: ApplicationColors.whiteColorF9
         /* image: DecorationImage(
            image: AssetImage(
                "assets/images/dark_background_image.png"), // <-- BACKGROUND IMAGE
            fit: BoxFit.cover,
          ),*/
        ),
      ),
      Scaffold(
          // bottomNavigationBar: Padding(
          //   padding: const EdgeInsets.all(20),
          //   child: InkWell(
          //     onTap: (){
          //       parkingScheduler();
          //     },
          //     child: Container(
          //       decoration: Boxdec.buttonBoxDecRed_r6,
          //       width: width,
          //       height: height * .057,
          //       child: Center(
          //           child: Text(
          //             "${getTranslated(context, "submit")}",
          //             style: Textstyle1.text18bold.copyWith(color: Colors.white),
          //           )
          //       ),
          //     ),
          //   ),
          // ),
          appBar: AppBar(
            titleSpacing: -8,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 13.0, top: 13),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                    "assets/images/vector_icon.png",  color:ApplicationColors.redColor67 ,
                ),
              ),
            ),
            title: Text(
              "${getTranslated(context, "parking_scheduler")}",
              style: Textstyle1.appbartextstyle1,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${widget.vName}',
                        style: Textstyle1.text18bold.copyWith(fontSize: 16),
                      ),
                      Expanded(
                          child: SizedBox(
                        width: 10,
                      )),
                      FlutterSwitch(
                        toggleSize: 10,
                        padding: 2,
                        height: height * .021,
                        width: width * .09,
                        switchBorder: Border.all(color: Colors.black54),
                        activeColor: ApplicationColors.whiteColor,
                        activeToggleColor: ApplicationColors.redColor67,
                        toggleColor: ApplicationColors.black4240,
                        inactiveColor: ApplicationColors.whiteColor,
                        value:parkingAlert,
                        onToggle: (val) {
                          setState(() {
                            print("------$val");
                           parkingAlert = val;
                            parkingSchedulerAlert();
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      "assets/images/parking_schedular_icon.png",
                    ),
                  ),
                  SizedBox(height: 20),
                  // DatePicker(
                  //   DateTime.now(),
                  //   width: width * .12,
                  //   height: 80,
                  //   controller: _controller,
                  //   initialSelectedDate: DateTime.now(),
                  //   selectionColor: ApplicationColors.dropdownColor3D,
                  //   dateTextStyle: Textstyle1.text14.copyWith(fontSize: 13),
                  //   dayTextStyle: Textstyle1.text14.copyWith(fontSize: 10),
                  //   selectedTextColor: Colors.white,
                  //   deactivatedColor: ApplicationColors.blackColor2E,
                  //   monthTextStyle: Textstyle1.text14.copyWith(
                  //       fontSize: 10,
                  //       color: Colors.transparent
                  //   ),
                  //   onDateChange: (date) {
                  //     setState(() {
                  //       _selectedValue = date;
                  //     });
                  //   },
                  // ),
                  // SizedBox(height: 20),
                  // Container(
                  //   decoration: Boxdec.conrad6colorblack,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 10),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           "${getTranslated(context, "time_set")}",
                  //           style: Textstyle1.text18bold,
                  //         ),
                  //         SizedBox(
                  //           height: 20,
                  //         ),
                  //         IntrinsicHeight(
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               // SizedBox(width: width*.2,),
                  //               Column(
                  //                 children: [
                  //                   Center(
                  //                       child: Text(
                  //                         "${getTranslated(context, "start")}",
                  //                         style: Textstyle1.text18bold,
                  //                       )
                  //                   ),
                  //                   Divider(
                  //                     color: ApplicationColors.dropdownColor3D,
                  //                     thickness: 2,
                  //                   ),
                  //                   SizedBox(
                  //                     height: 7,
                  //                   ),
                  //                   Row(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     mainAxisAlignment: MainAxisAlignment.start,
                  //                     children: [
                  //                       SizedBox(
                  //                         width: width * .091,
                  //                       ),
                  //                       Text(
                  //                         "${getTranslated(context, "hr")}",
                  //                         style: Textstyle1.text12b,
                  //                       ),
                  //                       SizedBox(
                  //                         width: width * .09,
                  //                       ),
                  //                       Text(
                  //                         "${getTranslated(context, "min")}",
                  //                         style: Textstyle1.text12b,
                  //                       ),
                  //                       SizedBox(
                  //                         width: width * .09,
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Container(
                  //                       height: height * .09,
                  //                       child: TimePickerSpinner(
                  //                         is24HourMode: false,
                  //                         normalTextStyle: TextStyle(
                  //                             fontSize: 15,
                  //                             color: ApplicationColors.dropdownColor3D
                  //                         ),
                  //                         highlightedTextStyle: TextStyle(
                  //                             fontSize: 15,
                  //                             color: ApplicationColors.redColor67
                  //                         ),
                  //                         spacing: 7,
                  //                         itemHeight: 30,
                  //                         onTimeChange: (time) {
                  //                           setState(() {
                  //                             _startdateTime = time;
                  //                           });
                  //                          /* parkingScheduler();*/
                  //                         },
                  //                       )
                  //                   ),
                  //                 ],
                  //               ),
                  //               VerticalDivider(
                  //                 color: ApplicationColors.dropdownColor3D,
                  //                 thickness: 2,
                  //                 width: 0,
                  //               ),
                  //               Column(
                  //                 children: [
                  //                   Center(
                  //                       child: Text(
                  //                         "${getTranslated(context, "end")}",
                  //                         style: Textstyle1.text18bold,
                  //                       )
                  //                   ),
                  //                   Divider(
                  //                     color: ApplicationColors.dropdownColor3D,
                  //                     thickness: 2,
                  //                   ),
                  //                   SizedBox(
                  //                     height: 7,
                  //                   ),
                  //                   Row(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     mainAxisAlignment: MainAxisAlignment.start,
                  //                     children: [
                  //                       SizedBox(
                  //                         width: width * .091,
                  //                       ),
                  //                       Text(
                  //                         "${getTranslated(context, "hr")}",
                  //                         style: Textstyle1.text12b,
                  //                       ),
                  //                       SizedBox(
                  //                         width: width * .09,
                  //                       ),
                  //                       Text(
                  //                         "${getTranslated(context, "min")}",
                  //                         style: Textstyle1.text12b,
                  //                       ),
                  //                       SizedBox(
                  //                         width: width * .09,
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Container(
                  //                       height: height * .09,
                  //                       child: TimePickerSpinner(
                  //                         is24HourMode: false,
                  //                         normalTextStyle: TextStyle(
                  //                             fontSize: 15,
                  //                             color: ApplicationColors.dropdownColor3D
                  //                         ),
                  //                         highlightedTextStyle: TextStyle(
                  //                             fontSize: 15,
                  //                             color: ApplicationColors.redColor67
                  //                         ),
                  //                         spacing: 7,
                  //                         itemHeight: 20,
                  //                         onTimeChange: (time) {
                  //                           setState(() {
                  //                             _enddateTime = time;
                  //                           });
                  //                           // parkingScheduler();
                  //                         },
                  //                       )
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ))
    ]);
  }
}
