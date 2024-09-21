import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Provider/histroy_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/histoy_vehicle_filter.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/map_provider.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../ProductsFilterPage/vehicle_filter.dart';

class HistoryNewPage extends StatefulWidget {
  String formDate, toDate, deviceId, vId, deviceName, km, deviceType;

  HistoryNewPage(
      {Key key,
      this.formDate,
      this.toDate,
      this.deviceId,
      this.vId,
      this.deviceName,
      this.km,
      this.deviceType})
      : super(key: key);

  @override
  _HistoryNewPageState createState() => _HistoryNewPageState();
}

class _HistoryNewPageState extends State<HistoryNewPage> with TickerProviderStateMixin {
  MapProvider mapProvider;
  HistoryProvider historyProvider;
  UserProvider userProvider;
  var height, width;

  // getDistance() async {
  //
  //   var data = {
  //     "imei":"$getIMEINo",
  //     "from":fromDate,
  //     "to": toDate,
  //   };
  //
  //   print("distance$data");
  //
  //   await historyProvider.getDistance(data, "gps/getDistanceSpeed");
  //
  // }

  // staticMarker(i) {
  //
  //   if(previousDis == 0.0 || replay == true){
  //     //  setState(() {
  //     previousDis = 0.0;
  //     //  });
  //   }
  //
  //   timer =  Timer.periodic(Duration(seconds: 0), (_) {
  //
  //     if(pause){
  //       if(i+1 == historyProvider.trackList.length){
  //         //   setState(() {
  //         timer.cancel();
  //         timer2.cancel();
  //         animationController.dispose();
  //         pause = false;
  //         //     });
  //       }
  //       else {
  //         timer.cancel();
  //
  //         if(pause){
  //           //     setState(() {
  //           startLat = historyProvider.trackList[i].lat;
  //           startLag = historyProvider.trackList[i].lng;
  //           //     });
  //         }
  //
  //         var distance = Geolocator.distanceBetween(
  //           startLat,
  //           startLag,
  //           historyProvider.trackList[i + 1].lat,
  //           historyProvider.trackList[i + 1].lng,
  //         );
  //
  //
  //         //   setState(() {
  //         double value = 1/trackListLength;
  //         playerTimeLine = playerTimeLine + value;
  //
  //         print("playerTimeLine ==>$playerTimeLine");
  //         //   });
  //
  //         if(historyProvider.speedValue == 1){
  //           print("speed 1x");
  //
  //           historyProvider.changeNewMakerSpeed(100 * distance.round());
  //           print(historyProvider.moveSpeedInSeconds);
  //
  //         }
  //         else if(historyProvider.speedValue == 2){
  //           print("speed 2x");
  //
  //           historyProvider.changeNewMakerSpeed((90 * distance.round() - (20 * distance.round())));
  //           print(historyProvider.moveSpeedInSeconds);
  //
  //         }
  //         else if(historyProvider.speedValue == 4){
  //           print("speed 4x");
  //
  //           historyProvider.changeNewMakerSpeed((80 * distance.round() - (40 * distance.round())));
  //           print(historyProvider.moveSpeedInSeconds);
  //
  //         }
  //         else if(historyProvider.speedValue == 6){
  //           print("speed 6x");
  //
  //           historyProvider.changeNewMakerSpeed((70 * distance.round() - (50 * distance.round())));
  //           print(historyProvider.moveSpeedInSeconds);
  //
  //         }
  //         else if(historyProvider.speedValue == 8){
  //           print("speed 8x");
  //
  //           historyProvider.changeNewMakerSpeed((60 * distance.round() - (45 * distance.round())));
  //           print(historyProvider.moveSpeedInSeconds);
  //
  //         }
  //         else if(historyProvider.speedValue == 10){
  //           print("speed 10x");
  //
  //           historyProvider.changeNewMakerSpeed((50 * distance.round() - (40 * distance.round())));
  //
  //           print(historyProvider.moveSpeedInSeconds);
  //         }
  //
  //         print("new Speed ${historyProvider.moveSpeedInSeconds}");
  //
  //         newAddress(historyProvider.trackList[i]);
  //
  //         animateCar(
  //           startLat,
  //           startLag,
  //           historyProvider.trackList[i + 1].lat,
  //           historyProvider.trackList[i + 1].lng,
  //           _mapMarkerSink,
  //           this,
  //           mapController,
  //         );
  //
  //         //    setState(() {
  //         i = i + 1;
  //         timer2 = Timer.periodic(
  //             Duration(milliseconds: historyProvider.moveSpeedInSeconds), (_) {
  //           timer2.cancel();
  //           startMarker();
  //         }
  //         );
  //         //   });
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();

    userProvider = Provider.of<UserProvider>(context, listen: false);
    mapProvider = Provider.of<MapProvider>(context, listen: false);
    historyProvider = Provider.of<HistoryProvider>(context, listen: false);

    historyProvider.distance = '0.0';
    historyProvider.trackLat.clear();
    historyProvider.parkingList.clear();
    mapProvider.markers.clear();

    mapProvider.createMarker();

    if (widget.deviceName != null &&
        widget.vId != null &&
        widget.deviceId != null &&
        widget.toDate != null &&
        widget.formDate != null) {
      mapProvider.getIMEINo = widget.deviceId;
      mapProvider.getId = "${widget.vId}";
      mapProvider.fromDate = "${widget.formDate}";
      mapProvider.toDate = "${widget.toDate}";
      mapProvider.deviceName = '${widget.deviceName}';

      DateTime now = DateTime.now(); // get the current date and time
      DateTime dateAtMidnight = DateTime(now.year, now.month, now.day);
      mapProvider.fromDate = dateAtMidnight.toUtc().toString();
      // fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
      mapProvider.toDate = DateTime.now().toUtc().toString();

      Future.delayed(Duration(microseconds: 100), () {
        mapProvider.datedController.text =
            "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight.toString()))}";
        mapProvider.endDateController.text = "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now())}";
        mapProvider.getTrack(context, historyProvider);
        //mapProvider.getDistance(widget.vId, historyProvider);
        mapProvider.getDistance(historyProvider);
      });
    }
  }

  List<DropdownMenuItem<String>> get dropdownTypeItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text('${getTranslated(context, "today")}'), value: "Today"),
      DropdownMenuItem(child: Text('${getTranslated(context, "1_hour")}'), value: "1 Hour"),
      DropdownMenuItem(child: Text('${getTranslated(context, "yesterday")}'), value: "Yesterday"),
      DropdownMenuItem(child: Text('${getTranslated(context, "week")}'), value: "Week"),
    ];
    return menuItems;
  }

  // DateTime date;
  TimeOfDay fromPickedTime;
  TimeOfDay endPickedTime;
  DateTime fromDatePicked;
  DateTime endDatePicked;

  dateTimeSelect(BuildContext context) async {
    fromDatePicked = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: fromDatePicked == null ? DateTime.now() : fromDatePicked,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.redColor67,
              onPrimary: ApplicationColors.whiteColor,
              surface: ApplicationColors.redColor67,
              onSurface: ApplicationColors.blackbackcolor,
            ),
            dialogBackgroundColor: ApplicationColors.whiteColor,
          ),
          child: child,
        );
      },
    );

    fromPickedTime = await showTimePicker(
      context: context,
      initialTime: fromPickedTime == null ? TimeOfDay.now() : fromPickedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: ApplicationColors.primaryTextColor,
              onPrimary: ApplicationColors.blackbackcolor,
              surface: ApplicationColors.whiteColor,
              onSurface: ApplicationColors.blackbackcolor,
            ),
            dialogBackgroundColor: ApplicationColors.whiteColor,
          ),
          child: child,
        );
      },
    );

    if (fromDatePicked != null) {
      //  setState(() {
      this.fromDatePicked = DateTime(fromDatePicked.year, fromDatePicked.month, fromDatePicked.day,
          fromPickedTime.hour, fromPickedTime.minute);
      mapProvider.datedController.text =
          "${DateFormat("dd MMM yyyy hh:mm a").format(fromDatePicked.toLocal())}";
      mapProvider.fromDate = fromDatePicked.toUtc().toString();
      //  });

      /* if (datedController.text != null && _selectedVehicle.isNotEmpty) {
        acReport();
      }*/
    }
  }

  endDateTimeSelect(BuildContext context) async {
    endDatePicked = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: endDatePicked == null ? DateTime.now() : endDatePicked,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.redColor67,
              onPrimary: ApplicationColors.whiteColor,
              surface: ApplicationColors.redColor67,
              onSurface: ApplicationColors.blackbackcolor,
            ),
            dialogBackgroundColor: ApplicationColors.whiteColor,
          ),
          child: child,
        );
      },
    );

    endPickedTime = await showTimePicker(
      context: context,
      initialTime: endPickedTime == null ? TimeOfDay.now() : endPickedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.primaryTextColor,
              onPrimary: ApplicationColors.blackbackcolor,
              surface: ApplicationColors.whiteColor,
              onSurface: ApplicationColors.blackbackcolor,
            ),
            dialogBackgroundColor: ApplicationColors.whiteColor,
            backgroundColor: ApplicationColors.whiteColor,
          ),
          child: child,
        );
      },
    );

    if (endDatePicked != null) {
      //  setState(() {
      this.endDatePicked = DateTime(endDatePicked.year, endDatePicked.month, endDatePicked.day,
          endPickedTime.hour, endPickedTime.minute);
      mapProvider.endDateController.text =
          "${DateFormat("dd MMM yyyy hh:mm a").format(endDatePicked.toLocal())}";
      mapProvider.toDate = endDatePicked.toUtc().toString();
      //   });

      /*  if (_endDateController.text != null && _selectedVehicle.length != 0) {
        acReport();
      }*/
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (mapProvider.timer != null) {
      mapProvider.timer.cancel();
    }
    if (mapProvider.timer2 != null) {
      mapProvider.timer2.cancel();
    }
    if (mapProvider.animationController != null) {
      mapProvider.animationController.dispose();
    }
    //mapProvider.mapController.dispose();
    mapProvider.pause = false;
    mapProvider.playerTimeLine = 0;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Consumer<MapProvider>(
      builder: (context, value, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: ApplicationColors.whiteColor,
                size: 26,
              ),
            ),
            title: Text(
              getTranslated(context, "view history"),
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
                    Color(0xffb751c1e),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            notchMargin: 8,
            elevation: 0,
            color: ApplicationColors.blackColor2E,
            shape: CircularNotchedRectangle(),
            child: IntrinsicHeight(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    mapProvider.address == ""
                        ? Container()
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      "assets/images/gps1.png",
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "${mapProvider.address}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Textstyle1.signupText
                                          .copyWith(fontSize: 12, color: ApplicationColors.black4240),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/Battery.png",
                                          color: ApplicationColors.redColor67,
                                          width: 12,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "0 ${getTranslated(context, "v")}",
                                          style: Textstyle1.signupText.copyWith(
                                            fontSize: 15,
                                            color: ApplicationColors.black4240,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: ApplicationColors.greyC4C4,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await mapProvider.playPauseButton(context, this, historyProvider);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: ApplicationColors.redColor67,
                                          ),
                                        ),
                                        child: mapProvider.pause
                                            ? Icon(
                                                Icons.pause,
                                                color: ApplicationColors.redColor67,
                                              )
                                            : Image.asset(
                                                "assets/images/play_icon.png",
                                                scale: 5,
                                                color: ApplicationColors.redColor67,
                                              ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: ApplicationColors.greyC4C4,
                                    ),
                                    Expanded(
                                      child: Slider(
                                        value: mapProvider.playerTimeLine,
                                        label: mapProvider.trackListLength.round().toString(),
                                        min: 0,
                                        max: mapProvider.trackListLength.toDouble(),
                                        activeColor: ApplicationColors.redColor67,
                                        inactiveColor: ApplicationColors.dropdownColor3D,
                                        onChanged: (double value) {
                                          mapProvider.sliderOnChanges(value, this, historyProvider);
                                        },
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (historyProvider.speedValue == 1) {
                                          historyProvider.changeSpeedValue(2);
                                        } else if (historyProvider.speedValue == 2) {
                                          historyProvider.changeSpeedValue(4);
                                        } else if (historyProvider.speedValue == 4) {
                                          historyProvider.changeSpeedValue(6);
                                        } else if (historyProvider.speedValue == 6) {
                                          historyProvider.changeSpeedValue(8);
                                        } else if (historyProvider.speedValue == 8) {
                                          historyProvider.changeSpeedValue(10);
                                        } else if (historyProvider.speedValue == 10) {
                                          historyProvider.changeSpeedValue(1);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "${historyProvider.speedValue}px",
                                            style: Textstyle1.signupText.copyWith(
                                                fontSize: 14,
                                                color: ApplicationColors.blackbackcolor,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(width: 10),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: Appcolors.text_grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: ApplicationColors.greyC4C4,
                              ),
                            ],
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/clock_icon_vehicle_Page.png",
                                color: Appcolors.text_grey,
                                width: 20,
                              ),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  mapProvider.dateTime == ""
                                      ? SizedBox()
                                      : Text(
                                          "${DateFormat("dd MMM yy").format(DateTime.parse(mapProvider.dateTime).toLocal())}",
                                          style: Textstyle1.signupText.copyWith(
                                            fontSize: 10,
                                            color: ApplicationColors.black4240,
                                          ),
                                        ),
                                  Text(
                                    mapProvider.dateTime == ""
                                        ? "00:00:00"
                                        : "${DateFormat("hh:mm:ss").format(DateTime.parse(mapProvider.dateTime).toUtc().toLocal())}",
                                    style: Textstyle1.signupText.copyWith(
                                      fontSize: 12,
                                      color: ApplicationColors.black4240,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Image.asset("assets/images/vehicle_page_icon.png",
                                  width: 20, color: ApplicationColors.redColor67),
                              SizedBox(width: 10),
                              Text(
                                "${mapProvider.speed}"
                                "${userProvider.useModel.cust.unitMeasurement == "${getTranslated(context, "mks")}" ? "${getTranslated(context, "km_hr")}" : "${getTranslated(context, "Miles_hr")}"} ",
                                style: Textstyle1.signupText.copyWith(
                                  fontSize: 12,
                                  color: ApplicationColors.black4240,
                                ),
                              ),
                              Spacer(),
                              Image.asset("assets/images/vehicle_page_icon2.png",
                                  width: 20, color: ApplicationColors.redColor67),
                              SizedBox(width: 10),
                              Text(
                                "${NumberFormat("##0.0#", "en_US").format((mapProvider.previousDis))}"
                                "${userProvider.useModel.cust.unitMeasurement == "${getTranslated(context, "mks")}" ? "${getTranslated(context, "kms")}" : "${getTranslated(context, "Miles")}"}",
                                style: Textstyle1.signupText.copyWith(
                                  fontSize: 12,
                                  color: ApplicationColors.black4240,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: ApplicationColors.greyC4C4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mapProvider.deviceName == null
                              ? Container()
                              : Text(
                                  mapProvider.deviceName,
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.normal,
                                    color: ApplicationColors.black4240,
                                  ),
                                ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/route_icon.png",
                                color: ApplicationColors.redColor67,
                                width: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${historyProvider.distance == null ? 0 : "${historyProvider.distance}"}"
                                "${userProvider.useModel.cust.unitMeasurement == "${getTranslated(context, "mks")}" ? "${getTranslated(context, "kms")}" : "${getTranslated(context, "Miles")}"}",
                                style: Textstyle1.signupText.copyWith(
                                  fontSize: 15,
                                  color: ApplicationColors.black4240,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  mapProvider.mapController.animateCamera(CameraUpdate.newCameraPosition(
                                      CameraPosition(target: historyProvider.trackLat.first, zoom: 14)));
                                  if (mapProvider.vehicleId != "") {
                                    //  setState(() async {
                                    mapProvider.timer.cancel();
                                    mapProvider.timer2.cancel();
                                    mapProvider.markers.clear();
                                    mapProvider.mapMarkerSink.done;
                                    mapProvider.replay = true;
                                    mapProvider.pause = true;
                                    mapProvider.i = 0;
                                    mapProvider.playerTimeLine = 0;

                                    double value = 1 / mapProvider.trackListLength;
                                    mapProvider.playerTimeLine = mapProvider.playerTimeLine + value;
                                    List<Marker> list = [
                                      Marker(
                                        markerId: MarkerId("startPoint"),
                                        position: historyProvider.trackLat.first,
                                        icon: BitmapDescriptor.fromBytes(mapProvider.startPoint),
                                      ),
                                      Marker(
                                        markerId: MarkerId("endPoint"),
                                        position: historyProvider.trackLat.last,
                                        icon: BitmapDescriptor.fromBytes(mapProvider.endPoint),
                                      ),
                                    ];
                                    mapProvider.markers.addAll(list);
                                    mapProvider.mapMarkerSink.add(mapProvider.markers);

                                    //   });
                                    mapProvider.startMarker(0, this, historyProvider);
                                  }
                                },
                                child: Image.asset(
                                  "assets/images/rewind_icon_.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  mapProvider.forDistanceReport();
                                },
                                child: Container(
                                  height: 34,
                                  width: 34,
                                  padding: EdgeInsets.all(6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    "assets/images/distance_reports_.png",
                                    color: ApplicationColors.redColor67,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              InkWell(
                onTap: () async {
                  var value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HistoryFilter(
                                selectedId: mapProvider.getId,
                                fromDate: mapProvider.fromDate,
                                toDate: mapProvider.toDate,
                                getIMEINo: mapProvider.getIMEINo,
                                deviceName: mapProvider.deviceName,
                              )));

                  if (value != null) {
                    print("VALUE : $value");

                    //   setState(() {
                    mapProvider.markers.clear();
                    mapProvider.address = "";
                    mapProvider.playerTimeLine = 0;

                    mapProvider.getId = value[0];
                    mapProvider.getIMEINo = value[1];
                    mapProvider.fromDate = value[2];
                    mapProvider.toDate = value[3];
                    mapProvider.deviceName = value[4];

                    print(
                        "back data ${mapProvider.getId},${mapProvider.getIMEINo},${mapProvider.fromDate},${mapProvider.toDate}");
                    //   });

                    mapProvider.getTrack(context, historyProvider);
                    mapProvider.getDistance(historyProvider);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: ApplicationColors.whiteColor,
                  height: height * .06,
                  width: width,
                  child: Row(
                    children: [
                      Text(
                        "${getTranslated(context, "select vehicles")}",
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.normal,
                          color: Appcolors.text_grey,
                        ),
                      ),
                      Spacer(),
                      mapProvider.deviceName == null
                          ? Container()
                          : Text(
                              mapProvider.deviceName,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.normal,
                                color: ApplicationColors.black4240,
                              ),
                            ),
                      Icon(Icons.arrow_drop_down_sharp),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                //color: ApplicationColors.GreyColorC0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              maxLines: 2,
                              readOnly: true,
                              style: Textstyle1.signupText1,
                              keyboardType: TextInputType.number,
                              controller: mapProvider.datedController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                dateTimeSelect(context);
                              },
                              decoration: fieldStyle.copyWith(
                                fillColor: ApplicationColors.transparentColors,
                                isDense: true,
                                hintText: "From Date\n${mapProvider.fromDate}",
                                prefixIcon: Icon(
                                  Icons.access_time_sharp,
                                  size: 30,
                                  color: ApplicationColors.greenColor,
                                ),
                                hintStyle: Textstyle1.signupText.copyWith(
                                  color: ApplicationColors.blackbackcolor,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              maxLines: 2,
                              readOnly: true,
                              style: Textstyle1.signupText1,
                              keyboardType: TextInputType.number,
                              controller: mapProvider.endDateController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                endDateTimeSelect(context);
                              },
                              decoration: fieldStyle.copyWith(
                                fillColor: ApplicationColors.transparentColors,
                                hintStyle: Textstyle1.signupText.copyWith(
                                  color: ApplicationColors.blackbackcolor,
                                ),
                                prefixIcon: Icon(
                                  Icons.access_time_sharp,
                                  size: 30,
                                  color: ApplicationColors.redColor,
                                ),
                                hintText: "End Date\n${mapProvider.fromDate}",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              mapProvider.searchTap(
                                context,
                                historyProvider,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.search,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          mapProvider.oneHoure(
                            context,
                            historyProvider,
                          );
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
                            "1 HOUR",
                            style: TextStyle(
                              fontSize: 12,
                              color: ApplicationColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          mapProvider.todayOnTap(
                            context,
                            historyProvider,
                          );
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
                        onTap: () async {
                          mapProvider.yesterdayOnTap(
                            context,
                            historyProvider,
                          );
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
                        onTap: () async {
                          mapProvider.weekOnTap(
                            context,
                            historyProvider,
                          );
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
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  // SizedBox(
                  //   height: height * 0.90,
                  //   child: GoogleMap(
                  //     zoomControlsEnabled: false,
                  //     initialCameraPosition: CameraPosition(target: LatLng(34.0479, 100.6197), zoom: 3),
                  //     mapType: mapProvider.isChangeMap ? mapProvider.mapType : Utils.mapType,
                  //     //map type
                  //     markers: Set<Marker>.from(mapProvider.markers),
                  //     polylines: historyProvider.trackLat.isEmpty || mapProvider.hidePolyline
                  //         ? {}
                  //         : Set<Polyline>.of(
                  //             <Polyline>[
                  //               Polyline(
                  //                 polylineId: PolylineId("start"),
                  //                 visible: true,
                  //                 points: historyProvider.trackLat,
                  //                 width: 2,
                  //                 color: ApplicationColors.black4240,
                  //               ),
                  //             ],
                  //           ),
                  //     onMapCreated: (controller) {
                  //       //   setState(() {
                  //       mapProvider.mapController = controller;
                  //       if (historyProvider.trackLat.isNotEmpty) {
                  //         mapProvider.mapController.animateCamera(CameraUpdate.newLatLngBounds(
                  //             mapProvider.createBounds(historyProvider.trackLat), 100));
                  //       }
                  //       // });
                  //     },
                  //   ),
                  //   // child: StreamBuilder<List<Marker>>(
                  //   //     stream: mapProvider.mapMarkerStream,
                  //   //     builder: (context, snapshot) {
                  //   //       if (historyProvider.isTrackLoading && historyProvider.isDisLoading ||
                  //   //           historyProvider.isParkingLoading) {
                  //   //         return SpinKitThreeBounce(
                  //   //           color: ApplicationColors.redColor67,
                  //   //           size: 25,
                  //   //         );
                  //   //       } else {
                  //   //         final List<Marker> newMarkers = snapshot.data ?? [];
                  //   //         // Create a new set with the updated markers.
                  //   //         Set<Marker> updatedMarkers = Set<Marker>.from(newMarkers);
                  //   //         return
                  //   //       }
                  //   //     }),
                  // ),
                  SizedBox(
                    height: height * 0.90,
                    child: StreamBuilder<List<Marker>>(
                        stream: mapProvider.mapMarkerStream,
                        builder: (context, snapshot) {
                          if (historyProvider.isTrackLoading && historyProvider.isDisLoading ||
                              historyProvider.isParkingLoading) {
                            return SpinKitThreeBounce(
                              color: ApplicationColors.redColor67,
                              size: 25,
                            );
                          } else {
                            final List<Marker> newMarkers = snapshot.data ?? [];
                            // Create a new set with the updated markers.
                            Set<Marker> updatedMarkers = Set<Marker>.from(newMarkers);
                            return GoogleMap(
                              zoomControlsEnabled: false,
                              initialCameraPosition:
                                  CameraPosition(target: LatLng(34.0479, 100.6197), zoom: 3),
                              mapType: mapProvider.isChangeMap ? mapProvider.mapType : Utils.mapType,
                              //map type
                              markers: updatedMarkers,
                              polylines: historyProvider.trackLat.isEmpty || mapProvider.hidePolyline
                                  ? {}
                                  : Set<Polyline>.of(
                                      <Polyline>[
                                        Polyline(
                                          polylineId: PolylineId("start"),
                                          visible: true,
                                          points: historyProvider.trackLat,
                                          width: 2,
                                          color: ApplicationColors.black4240,
                                        ),
                                      ],
                                    ),
                              onMapCreated: (controller) {
                                //   setState(() {
                                mapProvider.mapController = controller;
                                if (historyProvider.trackLat.isNotEmpty) {
                                  mapProvider.mapController.animateCamera(CameraUpdate.newLatLngBounds(
                                      mapProvider.createBounds(historyProvider.trackLat), 100));
                                }
                                // });
                              },
                            );
                          }
                        }),
                  ),
                  Positioned(
                    top: 20,
                    right: 15,
                    child: InkWell(
                      onTap: () {
                        mapProvider.iconForLive();
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ApplicationColors.blackColor2E,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/images/maap_icon_for_live_screen.png",
                          color: Color(0xfff70b3c),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 240,
                    right: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            mapProvider.mapController.animateCamera(CameraUpdate.zoomIn());
                          },
                          child: Container(
                            width: 37,
                            height: 37,
                            padding: EdgeInsets.all(10),
                            child: Image.asset(
                              "assets/images/add_ic.png",
                              color: ApplicationColors.redColor67,
                            ),
                            decoration: const BoxDecoration(
                              color: ApplicationColors.blackColor2E,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            mapProvider.mapController.animateCamera(CameraUpdate.zoomOut());
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 1),
                            width: 37,
                            height: 37,
                            padding: EdgeInsets.all(10),
                            child: Image.asset(
                              "assets/images/minimise_ic.png",
                              color: ApplicationColors.redColor67,
                            ),
                            decoration: const BoxDecoration(
                              color: ApplicationColors.blackColor2E,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(7),
                                bottomRight: Radius.circular(7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 330,
                      right: 10,
                      child: Container(
                        width: 41,
                        height: 41,
                        padding: EdgeInsets.all(10),
                        child: Image.asset("assets/images/current_location_ic.png"),
                        decoration: BoxDecoration(
                          color: ApplicationColors.redColor67,
                          borderRadius: BorderRadius.circular(41),
                        ),
                      )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

/*DateTime date;
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
              primary: ApplicationColors.blackColor2E,
              onPrimary: ApplicationColors.black4240,
              surface: ApplicationColors.redColor67,
              onSurface: ApplicationColors.blackColor00,
            ),
            dialogBackgroundColor: ApplicationColors.black4240,
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
              primary: ApplicationColors.greyColors,
              onPrimary: ApplicationColors.blackColor00,
              surface: ApplicationColors.black4240,
              onSurface: ApplicationColors.blackColor00,
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
        fromDate = datedController.text;
      });

      if (vehicleId != null && datedController.text.isNotEmpty) {
        _markers.clear();
        address = "";
        playerTimeLine = 0;
       getTrack();
       getDistance();
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
              primary: ApplicationColors.blackColor2E,
              onPrimary: ApplicationColors.black4240,
              surface: ApplicationColors.redColor67,
              onSurface: ApplicationColors.blackColor00,
            ),
            dialogBackgroundColor: ApplicationColors.black4240,
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
              primary: ApplicationColors.greyColors,
              onPrimary: ApplicationColors.blackColor00,
              surface: ApplicationColors.black4240,
              onSurface: ApplicationColors.blackColor00,
            ),
            dialogBackgroundColor: ApplicationColors.black4240,
            backgroundColor: ApplicationColors.black4240,
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
        toDate = _endDateController.text;
      });

      if (vehicleId != null && _endDateController.text.isNotEmpty) {
        _markers.clear();
        address = "";
        playerTimeLine =0;
        getTrack();
        getDistance();

      }
    }
  }*/
}
