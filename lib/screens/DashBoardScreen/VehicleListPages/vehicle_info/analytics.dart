import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/vehicle_list_model.dart';
import 'dart:ui' as ui;
import 'package:oneqlik/Provider/home_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/SyncfunctionPages/chart.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class AnalyticsPage extends StatefulWidget {
  final vDeviceId;
  VehicleLisDevice vehicleListModel;
  AnalyticsPage({Key key, this.vDeviceId,this.vehicleListModel}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {

  HomeProvider homeProvider;

  dynamic _resolveTransform(Rect bounds, TextDirection textDirection) {
    final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
    return transform
        .transform(bounds, textDirection: textDirection)
        .storage;
  }

  // Convert degree to radian
  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);



  speedChartAnalytics() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data =
    {
      "user": "$id",
      "device": "${widget.vehicleListModel.id}",
    };

    print('speedChart->$data');
    homeProvider.speedChartAnalytics(data, "devices/speedChart");
  }


  getMoneySpent()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");


    var data = {
      "user":"$id",
      "device":"${widget.vehicleListModel.deviceId}"
    };

    print('moneySpent-->${data}');

    await homeProvider.getAnalyticsChart(data, "summary/getSevenDaysData");

  }



  var width,height;

  @override
  void initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    speedChartAnalytics();
    getMoneySpent();
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context, listen: true);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: ApplicationColors.whiteColorF9
            /*image: DecorationImage(
              image: AssetImage("assets/images/dark_background_image.png"), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),*/
          ),
        ),
        Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: Boxdec.buttonBoxDecRed_r6,
              width: width,
              height: height*.057,
              child: Center(
                  child: Text(
                    "${getTranslated(context, "submit")}",
                    style: Textstyle1.text18bold.copyWith(color: Colors.white)
                  )
              ),
            ),
          ),
          appBar: AppBar(
            titleSpacing: -10,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 13.0,top: 13),
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                  },
                icon:Image.asset(
                    "assets/images/vector_icon.png",  color:ApplicationColors.redColor67 ,
                ),
              ),
            ),
            title: Text(
                "${getTranslated(context, "analytics")}",
                style: Textstyle1.appbartextstyle1
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body:
          // homeProvider.isMoneyLoading || homeProvider.isSpeedChartLoading
          //     ?
          // Helper.dialogCall.showLoader()
          //     :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                        color: ApplicationColors.blackColor2E,
                        borderRadius: BorderRadius.circular(9)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text("${getTranslated(context, "imei")}",
                                  style: Textstyle1.text14bold.copyWith(
                                      fontSize: 15
                                  ),
                                ),
                            ),
                            Text("${getTranslated(context, "sim_no")}",
                              style: Textstyle1.text14bold.copyWith(
                                  fontSize: 15
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text(
                                "${widget.vehicleListModel.deviceId}",
                                style: Textstyle1.text10
                             )
                            ),
                            Text(
                                "${widget.vehicleListModel.simNumber}",
                                style:Textstyle1.text10
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                   // padding: EdgeInsets.only(right: 28,top: 15,left: 28,bottom: 36),
                    child:  Column(
                      children: [
                        Container(
                          width: width,
                          child:SfCircularChart(
                            onCreateShader: (ChartShaderDetails chartShaderDetails) {
                              return ui.Gradient.sweep(
                                  chartShaderDetails.outerRect.center,
                                  [
                                    Colors.green,
                                    Colors.yellow,
                                    Colors.red,
                                  ],
                                  [0.3, 0.5, 1.1],
                                  TileMode.clamp,
                                  _degreeToRadian(0),
                                  _degreeToRadian(360),
                                  _resolveTransform(
                                      chartShaderDetails.outerRect, TextDirection.ltr));
                            },

                            series: <DoughnutSeries<SpeedChartData, String>>[
                              DoughnutSeries<SpeedChartData, String>(
                                  animationDuration: 0,
                                  dataSource: homeProvider.speedChart,
                                  explodeAll: true,
                                  radius: '75%',
                                  explodeOffset: '4%',
                                  explode: true,
                                  strokeColor: Colors.black.withOpacity(0.3),

                                  strokeWidth: 1.5,
                                  dataLabelSettings: DataLabelSettings(
                                    //showZeroValue: true,
                                    isVisible: true, // show Perce// ntage

                                    textStyle: TextStyle(
                                      color:  Colors.black
                                    ),

                                    labelPosition: ChartDataLabelPosition.outside,
                                    connectorLineSettings: ConnectorLineSettings(
                                      color: ApplicationColors.redColor67,
                                      width: 1.5,
                                      length: '5%',
                                      type: ConnectorType.line,
                                    ),
                                  ),
                                  xValueMapper: (SpeedChartData data, _) => data.x,
                                  yValueMapper: (SpeedChartData data, _) => data.y,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: ApplicationColors.blackColor2E,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                        color: ApplicationColors.blackColor2E,
                        borderRadius: BorderRadius.circular(9)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getTranslated(context, "Past_days")}",
                          style: Textstyle1.text14bold.copyWith(
                              fontSize: 15
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Container(
                                    height: 90,
                                    width: 120,
                                    child:  SfCircularChart(
                                      margin: EdgeInsets.zero,
                                        series: <RadialBarSeries<MoneySpentChart, String>>[
                                          RadialBarSeries<MoneySpentChart, String>(
                                            animationDuration: 1000,
                                            maximumValue: homeProvider.analyticChartModel == null ? 0 : double.parse(homeProvider.analyticChartModel.total.fuel,) + 14.0,
                                            gap: '80%',
                                            radius: '120%',
                                            dataSource: [
                                              MoneySpentChart(
                                                  "",
                                                  homeProvider.analyticChartModel == null ? 0: double.parse(homeProvider.analyticChartModel.total.fuel),
                                                  0.0,
                                                  0.0,
                                                  ApplicationColors.greenColor370
                                              ),
                                            ],
                                            trackColor: ApplicationColors.dropdownColor3D,
                                            cornerStyle:  CornerStyle.bothCurve,
                                            innerRadius: '50%',
                                            xValueMapper: (MoneySpentChart data, _) => '',
                                            yValueMapper: (MoneySpentChart data, _) => data.fuel,
                                            pointColorMapper: (MoneySpentChart data, _) => data.color,
                                            legendIconType: LegendIconType.circle,
                                          ),
                                        ],

                                        annotations: <CircularChartAnnotation>[
                                          CircularChartAnnotation(
                                            height: '70%',
                                            width: '60%',
                                            radius: '0%',
                                            widget: Image.asset(
                                                "assets/images/fual_pump_icon.png",
                                                width: 19
                                            ),
                                          ),
                                        ],
                                    ),
                                  ),
                                  Text(
                                      homeProvider.analyticChartModel == null ? "0 ${getTranslated(context, "ltr")}" :
                                      "${homeProvider.analyticChartModel.total.fuel} ${getTranslated(context, "ltr")}",
                                      style:Textstyle1.text11
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Container(
                                    height: 90,
                                    width: 120,
                                    child:  SfCircularChart(
                                      margin: EdgeInsets.zero,
                                      series: <RadialBarSeries<MoneySpentChart, String>>[
                                        RadialBarSeries<MoneySpentChart, String>(
                                          animationDuration: 1000,
                                          maximumValue:homeProvider.analyticChartModel == null ? 0:  double.parse(homeProvider.analyticChartModel.total.expense) + (double.parse(homeProvider.analyticChartModel.total.expense) > 1000 ? 400 : 14.0),
                                          gap: '80%',
                                          radius: '120%',
                                          dataSource: [
                                            MoneySpentChart(
                                                "",
                                                0.0,
                                                homeProvider.analyticChartModel == null ? 0:  double.parse(homeProvider.analyticChartModel.total.expense),
                                                0.0,
                                                ApplicationColors.yellowColorD21
                                            ),
                                          ],
                                          trackColor: ApplicationColors.dropdownColor3D,
                                          cornerStyle:  CornerStyle.bothCurve,
                                          innerRadius: '50%',
                                          xValueMapper: (MoneySpentChart data, _) => '',
                                          yValueMapper: (MoneySpentChart data, _) => data.money,
                                          pointColorMapper: (MoneySpentChart data, _) => data.color,
                                          legendIconType: LegendIconType.circle,
                                        ),
                                      ],

                                      annotations: <CircularChartAnnotation>[
                                        CircularChartAnnotation(
                                          height: '70%',
                                          width: '60%',
                                          radius: '0%',
                                          widget: Image.asset(
                                            "assets/images/money_icon_.png",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 10,),

                                  Text(
                                      homeProvider.analyticChartModel == null ? "₹0" :
                                      '₹${homeProvider.analyticChartModel.total.expense}',
                                      style:Textstyle1.text11
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),


                                  Container(
                                    height: 90,
                                    width: 120,
                                    child:  SfCircularChart(
                                      margin: EdgeInsets.zero,
                                      series: <RadialBarSeries<MoneySpentChart, String>>[
                                        RadialBarSeries<MoneySpentChart, String>(
                                          animationDuration: 1000,
                                          maximumValue: homeProvider.analyticChartModel == null ? 0 : double.parse(homeProvider.analyticChartModel.total.totalKm) + 14.0,
                                          gap: '80%',
                                          radius: '120%',
                                          dataSource: [
                                            MoneySpentChart(
                                                "",
                                                0.0,
                                                0.0,
                                                homeProvider.analyticChartModel == null ? 0 : double.parse(homeProvider.analyticChartModel.total.totalKm),
                                                ApplicationColors.redColor67
                                            ),
                                          ],
                                          trackColor: ApplicationColors.dropdownColor3D,
                                          cornerStyle:  CornerStyle.bothCurve,
                                          innerRadius: '50%',
                                          xValueMapper: (MoneySpentChart data, _) => '',
                                          yValueMapper: (MoneySpentChart data, _) => data.distance,
                                          pointColorMapper: (MoneySpentChart data, _) => data.color,
                                          legendIconType: LegendIconType.circle,
                                        ),
                                      ],

                                      annotations: <CircularChartAnnotation>[
                                        CircularChartAnnotation(
                                          height: '70%',
                                          width: '60%',
                                          radius: '0%',
                                          widget: Image.asset(
                                              "assets/images/route_icon.png",

                                          ),
                                        ),
                                      ],
                                    ),
                                  ),


                                  SizedBox(height: 10,),

                                  Text(
                                      homeProvider.analyticChartModel == null ? "0 ${getTranslated(context, "Km")}" :
                                      "${homeProvider.analyticChartModel.total.totalKm} ${getTranslated(context, "Km")}",
                                      style:Textstyle1.text11
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                        color: ApplicationColors.blackColor2E,
                        borderRadius: BorderRadius.circular(9)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 22,top: 18),
                          child: Text(
                            '${getTranslated(context, "Past_7_days_Distance_km")}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: FontStyleUtilities.s14(
                              fontColor: ApplicationColors.black4240,
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 22),
                          padding: EdgeInsets.only(right: 28,top: 15,left: 28,bottom: 36),
                          child:  Column(
                            children: [

                              Container(
                                height: height * 0.4,
                                width: width,
                                child: SfCartesianChart(
                                    plotAreaBorderWidth: 0,
                                    primaryXAxis: CategoryAxis(
                                      majorGridLines: const MajorGridLines(width: 0,color: ApplicationColors.textfieldBorderColor),
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      labelStyle: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.w300,
                                          fontSize: 9,
                                          color: ApplicationColors.black4240
                                      ),
                                    ),
                                    primaryYAxis: NumericAxis(
                                        axisLine: const AxisLine(width: 0),
                                        majorGridLines: MajorGridLines(color: ApplicationColors.textfieldBorderColor),
                                        labelFormat: '{value} Km',
                                        labelStyle: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 9,
                                            color: ApplicationColors.black4240
                                        ),
                                        majorTickLines: const MajorTickLines(size: 0)),

                                    series:<ColumnSeries<AnalyticsChart, String>>[

                                      ColumnSeries<AnalyticsChart, String>(
                                        dataSource: homeProvider.analyticsDistance,
                                        color: ApplicationColors.blueColorCE,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        xValueMapper: (AnalyticsChart sales, _) => sales.x as String,
                                        yValueMapper: (AnalyticsChart sales, _) => sales.distance,
                                        dataLabelSettings: const DataLabelSettings(
                                          isVisible: true,
                                          textStyle: TextStyle(
                                              fontSize: 10,
                                              color: ApplicationColors.black4240,
                                              fontFamily: "Poppins-Regular"
                                          ),
                                        ),
                                      )
                                    ]
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      Icons.circle,
                                      size: 16,
                                      color: ApplicationColors.blueColorCE,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${getTranslated(context, "distance")}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: FontStyleUtilities.h12(
                                        fontColor: ApplicationColors.black4240,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: ApplicationColors.blackColor2E,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),


                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
