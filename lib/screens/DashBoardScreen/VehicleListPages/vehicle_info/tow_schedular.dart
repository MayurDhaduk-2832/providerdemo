import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/vehicle_list_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TowSchedulerPage extends StatefulWidget {
  final vName,vId;
  const TowSchedulerPage({Key key, this.vName, this.vId}) : super(key: key);

  @override
  _TowSchedulerPageState createState() => _TowSchedulerPageState();
}

class _TowSchedulerPageState extends State<TowSchedulerPage> {


  VehicleListProvider vehicleListProvider;
  bool towAlert = false;

  towScheduler() async{

    var data =
    {
      "_id": widget.vId,
       "towAlert": towAlert,
      "towTime": {
        "start": "${DateFormat("yyyy-MM-dd").format(_selectedValue)}T${DateFormat("hh:mm:ss").format(_startdateTime)}.000Z",
        "end": "${DateFormat("yyyy-MM-dd").format(_selectedValue)}T${DateFormat("hh:mm:ss").format(_enddateTime)}.000Z",
      }
    };

    print('datacheck-->$data');

    vehicleListProvider.towScheduler(data, "devices/deviceupdate", context);

  }

  towSchedulerAlter() async{

    var data = {
      "_id": widget.vId,
       "towAlert": towAlert,
    };

    print('datacheck-->$data');

    vehicleListProvider.towScheduler(data, "devices/deviceupdate", context);

  }


  customApi() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data =
    {
      "user": "$id",
      "id": widget.vId,
      "fields": "towAlert",
    };

    print("Tow->$data");

    await vehicleListProvider.customApi(data, "devices/getDeviceCustomApi", context);

    if(vehicleListProvider.isCustomSuccess){
      setState(() {
        towAlert = vehicleListProvider.body["towAlert"];
        print(vehicleListProvider.body["towAlert"]);
        print(towAlert);
      });
    }

  }




  @override
  void initState() {
    super.initState();
    vehicleListProvider = Provider.of<VehicleListProvider>(context,listen: false);
    customApi();
  }


  DatePickerController _controller = DatePickerController();
  DateTime _startdateTime = DateTime.now();
  DateTime _enddateTime = DateTime.now();
  DateTime _selectedValue = DateTime.now();

  @override
  Widget build(BuildContext context) {
    vehicleListProvider = Provider.of<VehicleListProvider>(context,listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
         color: ApplicationColors.whiteColorF9

            ),
          ),
      Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: (){
                towScheduler();
              },
              child: Container(
                decoration: Boxdec.buttonBoxDecRed_r6,
                width: width,
                height: height * .057,
                child: Center(
                    child: Text(
                      "${getTranslated(context, "submit")}",
                      style: Textstyle1.text18boldwhite,
                    )
                ),
              ),
            ),
          ),
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
                    "assets/images/vector_icon.png",color: ApplicationColors.redColor67,
                ),
              ),
            ),
            title: Text(
              "${getTranslated(context, "two_schedular")}",
              style: Textstyle1.appbartextstyle1,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: vehicleListProvider.isCustomApi
              ?
          Helper.dialogCall.showLoader()
              :
          SingleChildScrollView(
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
                          )
                      ),
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
                        value: towAlert,
                        onToggle: (val) {
                          setState(() {
                            towAlert = val;
                            towSchedulerAlter();
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Image.asset(
                      "assets/images/tow_scheduler.png",
                    ),
                  ),
                  SizedBox(height: 20),
                  DatePicker(
                    DateTime.now(),
                    width: width * .12,
                    height: 80,
                    controller: _controller,
                    initialSelectedDate: DateTime.now(),
                    selectionColor: ApplicationColors.dropdownColor3D,
                    dateTextStyle: Textstyle1.text14.copyWith(fontSize: 13),
                    dayTextStyle: Textstyle1.text14.copyWith(fontSize: 10),
                    selectedTextColor: Colors.white,
                    deactivatedColor: ApplicationColors.blackColor2E,
                    monthTextStyle: Textstyle1.text14
                        .copyWith(fontSize: 10, color: Colors.transparent),
                    onDateChange: (date) {
                      setState(() {
                        _selectedValue = date;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: Boxdec.conrad6colorblack,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${getTranslated(context, "time_set")}",
                            style: Textstyle1.text18bold,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Center(
                                        child: Text(
                                          "${getTranslated(context, "start")}",
                                          style: Textstyle1.text18bold,
                                        )
                                    ),
                                    Divider(
                                      color: ApplicationColors.dropdownColor3D,
                                      thickness: 2,
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width * .091,
                                        ),
                                        Text(
                                          "${getTranslated(context, "hr")}",
                                          style: Textstyle1.text12b,
                                        ),
                                        SizedBox(
                                          width: width * .09,
                                        ),
                                        Text(
                                          "${getTranslated(context, "min")}",
                                          style: Textstyle1.text12b,
                                        ),
                                        SizedBox(
                                          width: width * .09,
                                        ),
                                      ],
                                    ),
                                    Container(
                                        height: height * .09,
                                        child: TimePickerSpinner(
                                          is24HourMode: false,
                                          normalTextStyle: TextStyle(
                                              fontSize: 15,
                                              color: ApplicationColors.dropdownColor3D
                                          ),
                                          highlightedTextStyle: TextStyle(
                                              fontSize: 15,
                                              color: ApplicationColors.redColor67
                                          ),
                                          spacing: 7,
                                          itemHeight: 30,
                                          onTimeChange: (time) {
                                            setState(() {
                                              _startdateTime = time;
                                            });
                                            /*towScheduler();*/
                                          },
                                        )
                                    ),
                                  ],
                                ),
                                VerticalDivider(
                                  color: ApplicationColors.dropdownColor3D,
                                  thickness: 2,
                                  width: 0,
                                ),
                                Column(
                                  children: [
                                    Center(
                                        child: Text(
                                          "${getTranslated(context, "end")}",
                                          style: Textstyle1.text18bold,
                                        )
                                    ),
                                    Divider(
                                      color: ApplicationColors.dropdownColor3D,
                                      thickness: 2,
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width * .091,
                                        ),
                                        Text(
                                          "${getTranslated(context, "hr")}",
                                          style: Textstyle1.text12b,
                                        ),
                                        SizedBox(
                                          width: width * .09,
                                        ),
                                        Text(
                                          "${getTranslated(context, "min")}",
                                          style: Textstyle1.text12b,
                                        ),
                                        SizedBox(
                                          width: width * .09,
                                        ),
                                      ],
                                    ),
                                    Container(
                                        height: height * .09,
                                        child: TimePickerSpinner(
                                          is24HourMode: false,
                                          normalTextStyle: TextStyle(
                                              fontSize: 15,
                                              color: ApplicationColors.dropdownColor3D
                                          ),
                                          highlightedTextStyle: TextStyle(
                                              fontSize: 15,
                                              color: ApplicationColors.redColor67
                                          ),
                                          spacing: 7,
                                          itemHeight: 20,
                                          onTimeChange: (time) {
                                            setState(() {
                                              _enddateTime = time;
                                            });
                                            /*towScheduler();*/
                                          },
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
         )
        ]
    );
  }
}
