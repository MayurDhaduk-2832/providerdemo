import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/daily_reports_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/day_wise_report_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/distance_report_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/geofence_report_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/idle_report_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/ignition_report.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/poi_report.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/route_violation_report.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/sos_report.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/stoppage_report.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/summary_report.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/trip_report.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/user_trip_report.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/value_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ReportsScreen/working_hours_reports.dart';
import 'package:oneqlik/screens/DashBoardScreen/dashboard_screen.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Speed_variation_report.dart';
import 'ac_report.dart';
import 'over_speed_report.dart';


class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}


class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key key}) : super(key: key);

  @override
  ReportsScreenState createState() => ReportsScreenState();
}

class ReportsScreenState extends State<ReportsScreen> {
  int serviceOfIndex = 0;
  var height, width;
  final _debouncer = Debouncer(milliseconds: 500);

  ReportProvider _reportProvider;

  getDeviceByUserDropdown()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");

    var data = {
     "email":email,
     "id":id
    };

   await _reportProvider.getVehicleDropdown(data, "devices/getDeviceByUserDropdown");

  }

  List searchReportList = [];



  FocusNode focusNode = FocusNode();
  List listOfReports = [];



  @override
  void initState() {
    super.initState();
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    getDeviceByUserDropdown();

    Future.delayed(Duration(milliseconds: 100),(){
      listOfReports = [
        {'name': "${getTranslated(context, "ac_reports")}",'image':"assets/images/ac_report.png"},
        // {'name': "${getTranslated(context, "daily_report")}",'image':"assets/images/daily_report.png"},
        {'name': "${getTranslated(context, "day_wise_report")}",'image':"assets/images/day_wise_report.png"},
        // {'name': "${getTranslated(context, "distance_report")}",'image':"assets/images/distance_report.png"},
        {'name': "${getTranslated(context, "geofence_report")}",'image':"assets/images/geofence_report.png"},
        {'name': "${getTranslated(context, "idle_report")}",'image':"assets/images/idle_report.png"},
        {'name': "${getTranslated(context, "ignition_report")}",'image':"assets/images/ignition_reports_.png"},
        {'name': "${getTranslated(context, "over_speed_report")}",'image':"assets/images/over_speed_report.png"},
        {'name': "${getTranslated(context, "poi_report")}",'image':"assets/images/poi_report.png"},
        // {'name': "${getTranslated(context, "route_violation_report")}",'image':"assets/images/route_report.png"},
        {'name': "${getTranslated(context, "sos_report")}",'image':"assets/images/sos_report.png"},
        {'name': "${getTranslated(context, "speed_variation_report")}",'image':"assets/images/speed_report.png"},
        {'name': "${getTranslated(context, "stoppage_report")}",'image':"assets/images/stoppage_report.png"},
        {'name': "${getTranslated(context, "summary_report")}",'image':"assets/images/summary_report.png"},
        {'name': "${getTranslated(context, "trip_report")}",'image':"assets/images/trip_report.png"},
        // {'name': "${getTranslated(context, "user_trip_report")}",'image':"assets/images/user_trip.png"},
        // {'name': "${getTranslated(context, "value_screen_report")}",'image':"assets/images/value_report.png"},
        {'name': "${getTranslated(context, "working_hours_report")}",'image':"assets/images/working_report.png"},
      ];
      searchReportList = listOfReports;

      listOfReports = searchReportList;
    });

  }

  @override
  Widget build(BuildContext context) {

    _reportProvider = Provider.of<ReportProvider>(context, listen: true);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Utils.navigatorKey.currentState.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset(
              "assets/images/drawer_icon.png",
              width: 10,
              height: 22,
              color:  ApplicationColors.redColor67,
            ),
          ),
        ),
        title: Text(
          '${getTranslated(context, "reports")}',
          // style: Textstyle1.appbartextstyle1,
          style: Textstyle1.text13bold,
        ),
        // backgroundColor: ApplicationColors.blackColor2E,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: InkWell(
          onTap: (){
            focusNode.unfocus();
          },
          child: Column(
            children: [
              /*Container(
                decoration:
                BoxDecoration(color: ApplicationColors.blackColor2E),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 3,bottom: 15),
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 3),
                          height: 50,
                          child: TextField(
                            focusNode: focusNode,
                            style: FontStyleUtilities.h14(
                                fontColor: ApplicationColors.whiteColor),
                            keyboardType: TextInputType.text,
                            onChanged: (string) {
                              _debouncer.run(() {
                                setState(() {
                                  listOfReports = searchReportList.where((u) {
                                    return (u['name'].toLowerCase().contains(string.toLowerCase()));
                                  }).toList();
                                });
                              });
                            },
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: '${getTranslated(context, "search_report")}',
                              hintStyle: TextStyle(
                                  color: ApplicationColors.whiteColor,
                                  fontSize: 15,
                                  fontFamily: "Poppins-Regular",
                                  letterSpacing: 0.75,
                              ),
                              // prefixIcon: Icon(Icons.search,color: ApplicationColors.blackColor33.withOpacity(0.5)),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Image.asset(
                                    "assets/images/search_icon.png",
                                    ),
                              ),

                              // ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ApplicationColors.blackColor2E
                                .withOpacity(0.5),
                            border: Border.all(
                                color: ApplicationColors.textfieldBorderColor,
                                width: 1,
                            ),
                          )),

                    ],
                  ),p
                ),
              ),*/
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      // image: DecorationImage(
                      //   image: AssetImage("assets/images/dashboard_image (1).png"),
                      //   fit: BoxFit.fill,
                      // )
          ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20,left: 20,top: 10,bottom: 15),
                    child: _reportProvider.isDropDownLoading
                        ?
                    Helper.dialogCall.showLoader()
                        :
                    GridView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 70),
                        shrinkWrap: true,
                        itemCount: listOfReports.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:16/16,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 18),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                             if(listOfReports[index]['name']=="${getTranslated(context, "daily_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder:(BuildContext context)=>DailyReportsScreen()
                               ));
                             }
                             else if(listOfReports[index]['name']=="${getTranslated(context, "day_wise_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder:(BuildContext context)=>DayWiseReportScreen()
                               ));
                             }
                             else if(listOfReports[index]['name']=="${getTranslated(context, "distance_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder:(BuildContext context)=>DistanceReportScreen()
                               ));
                             }
                             else if(listOfReports[index]['name']=="${getTranslated(context, "geofence_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder:(BuildContext context)=>GeofenceReportScreen()
                               ));
                             }
                             else if(listOfReports[index]['name']=="${getTranslated(context, "idle_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder:(BuildContext context)=>IdleReportScreen()
                               ));
                             }
                             if(listOfReports[index]['name']=="${getTranslated(context, "ignition_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>IgnitionReportScreen()
                               ));
                             }
                             if(listOfReports[index]['name']=="${getTranslated(context, "ac_reports")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>AcReportScreen()
                               ));
                             }
                             if(listOfReports[index]['name']== "${getTranslated(context, "over_speed_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>OverSpeedReportScreen()
                               ));
                             }
                             if(listOfReports[index]['name']=="${getTranslated(context, "poi_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>PoiReportScreen()
                               ));
                             }
                             if(listOfReports[index]['name']== "${getTranslated(context, "route_violation_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>RouteViolationReportPage()
                               ));
                             }
                             if(listOfReports[index]['name']=="${getTranslated(context, "sos_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>SosReportScreen()
                               ));
                             }
                             if(listOfReports[index]['name']=="${getTranslated(context, "speed_variation_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>SpeedVariationReportPage()
                               ));
                             }
                             if(listOfReports[index]['name']=="${getTranslated(context, "stoppage_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>StoppageReportScreen()
                               ));
                             }
                             if(listOfReports[index]['name']=="${getTranslated(context, "summary_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>SummaryReportScreen()
                               ));
                             }
                             if(listOfReports[index]['name']== "${getTranslated(context, "trip_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>TripReportScreen()
                               ));
                             }
                             if(listOfReports[index]['name']=="${getTranslated(context, "user_trip_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>UserTripReportScreen()
                               ));
                             }
                             if(listOfReports[index]['name']=="${getTranslated(context, "value_screen_report")}")
                             {
                               Navigator.push(
                                   context, MaterialPageRoute(
                                   builder: (context)=>ValueScreen()
                               ));
                             }
                              if(listOfReports[index]['name']=="${getTranslated(context, "working_hours_report")}")
                              {
                                Navigator.push(
                                    context,MaterialPageRoute(
                                    builder: (context) => WorkingHoursReports()
                                ));
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom:15,top: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      listOfReports[index]['image'],
                                      color:  ApplicationColors.redColor67,
                                      width:index==7 ? width*0.22 :width * 0.14,
                                    //height: 120,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(height: 17),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Text(
                                        listOfReports[index]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: FontStyleUtilities.s14(
                                          fontColor: ApplicationColors.blackColor00,
                                          fontFamily: "Poppins-SemiBold"
                                      )
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: serviceOfIndex == index
                                //     ? ApplicationColors.blackColor2E
                                //     : ApplicationColors.blackColor2E
                                color: serviceOfIndex == index
                                    ? ApplicationColors.darkGreyBGColor.withOpacity(0.4)
                                    : ApplicationColors.darkGreyBGColor.withOpacity(0.4),

                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}



