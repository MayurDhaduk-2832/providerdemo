import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Model/ac_report_model.dart';
import 'package:oneqlik/Model/daily_report_model.dart';
import 'package:oneqlik/Model/geofence_report_model.dart';
import 'package:oneqlik/Model/get_all_geofence_model.dart';
import 'package:oneqlik/Model/get_daywise_reports_model.dart';
import 'package:oneqlik/Model/get_poi_report_model.dart';
import 'package:oneqlik/Model/get_route_model.dart';
import 'package:oneqlik/Model/idle_report_model.dart';
import 'package:oneqlik/Model/route_voilation_reprot_model.dart';
import 'package:oneqlik/Model/sos_report_model.dart';
import 'package:oneqlik/Model/stoppage_logs_model.dart';
import 'package:oneqlik/Model/summary_report_model.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Model/user_trip_model.dart';
import 'package:oneqlik/Model/working_hours_report_model.dart';
import 'package:oneqlik/screens/SyncfunctionPages/chart.dart';

import '../Model/summary_report_model2.dart';
import '../Model/vehicle_list_model.dart';

class ReportProvider with ChangeNotifier{


  bool isGeofenceReportLoading = false;
  List<GeofenceReportDetails> geofenceReportList = [];
  List geofenceAddressList = [];
  geofenceReport(data,url) async {

    isGeofenceReportLoading = true;
    geofenceReportList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print(response.statusCode);
    print('body->${body}');

    try {
      if (response.statusCode == 200) {
        print("GeofenceReport Called");
        var response = GeofencingReportModel.fromJson(body);

        geofenceReportList.addAll(response.data);

        print('lengthcheck-->${geofenceReportList.length}');

        for (int i = 0; i < geofenceReportList.length; i++) {
          if (geofenceReportList[i] != null) {
            var data = {
              "lat": geofenceReportList[i].lat,
              "long": geofenceReportList[i].long,
            };

            print('datalatlong->${data}');

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in database") {
              geofenceAddressList.add(body["message"]);
            } else {
              geofenceAddressList.add(body["address"]);
            }
          }
        }


        isGeofenceReportLoading = false;
        notifyListeners();
      }
      else {
        isGeofenceReportLoading = false;
        print("geofence Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isGeofenceReportLoading = false;
      print("geofence catch Api Error !!");
      notifyListeners();
    }
  }


  bool isStoppageLoading = false;
  List stoppageReportList = [];
  List stoppageAddressList = [];
  stoppageReport(data,url) async {

    isStoppageLoading = true;
    stoppageReportList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    try {
      print(response.statusCode);
      // print('body->$body');

      if (response.statusCode == 200) {
        stoppageReportList = body;


        for (int i = 0; i < stoppageReportList.length; i++) {
          if (stoppageReportList[i]["device"]["last_location"]["lat"] != null && stoppageReportList[i]["device"]["last_location"]["long"] != null){
            var data = {
              "lat": stoppageReportList[i]["device"]["last_location"]["lat"],
              "long": stoppageReportList[i]["device"]["last_location"]["long"],
            };

            print('stoppageReportLatLng->${data}');

            var response = await CallApi().postData(data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in database") {
              stoppageAddressList.add(body["message"]);
            } else {
              stoppageAddressList.add(body["address"]);
            }
          }
          else {
            stoppageAddressList.add("Address Not Found");
          }
        }

        isStoppageLoading = false;
        notifyListeners();
      }
      else {
        isStoppageLoading = false;
        print("stoppage Report Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isStoppageLoading = false;
      print("stoppage Report catch Api Error !!");
      notifyListeners();
    }
  }


  bool isPoiReportLoading = false;
  List<GetPoiReportList> getPoiReportList = [];
  List getPoiReportAddressList = [];
  poiReport(data,url) async {

    isPoiReportLoading = true;
    getPoiReportList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print(response.statusCode);
    print('body->${body}');

    try {
      if (response.statusCode == 200) {
        print("Poi Report Called");
        var response = GetPoiReportModel.fromJson(body);

        getPoiReportList.addAll(response.data);

        print('lengthcheck-->${getPoiReportList.length}');

        for (int i = 0; i < getPoiReportList.length; i++) {
          if (getPoiReportList[i] != null) {
            var data = {
              "lat": getPoiReportList[i].lat,
              "long": getPoiReportList[i].long,
            };

            print('datalatlong->${data}');

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in database") {
              getPoiReportAddressList.add(body["message"]);
            } else {
              getPoiReportAddressList.add(body["address"]);
            }
          }
          else {
            getPoiReportAddressList.add("Address Not Found");
          }
        }


        isPoiReportLoading = false;
        notifyListeners();
      }
      else {
        isPoiReportLoading = false;
        print("poiReport Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isPoiReportLoading = false;
      print("poi Report catch Api Error !!");
      notifyListeners();
    }

  }



  List getIdleReportAddressList =[];

  bool isIdleReportLoading = false;
  List<IdleReportList> getIdleReportList = [];
  idleReport(data,url) async {

    isIdleReportLoading = true;
    getIdleReportList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print(response.statusCode);
    print('body->${body}');

    try {
      if (response.statusCode == 200) {
        print("Idle Report Report Called");
        var response = IdleReportModel.fromJson(body);

        getIdleReportList.addAll(response.data);

        print('lengthcheck-->${getIdleReportList.length}');


        for (int i = 0; i < getIdleReportList.length; i++) {
          if (getIdleReportList[i].lat != null && getIdleReportList[i].long != null) {
            var data = {
              "lat": getIdleReportList[i].lat,
              "long": getIdleReportList[i].long,
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              getIdleReportAddressList.add(body["message"]);
            } else {
              getIdleReportAddressList.add(body["address"]);
            }
          }
          else {
            getIdleReportAddressList.add("Address Not Found");
          }
        }

        isIdleReportLoading = false;
        notifyListeners();
      }
      else {
        isIdleReportLoading = false;
        print("idle Report  Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isIdleReportLoading = false;
      print("idle Report catch Api Error !!");
      notifyListeners();
    }

  }


  List<SosReportModel> sosReportList = [];
  bool isSosReportLoading = false;
  List sosReportAddressList = [];

  getSosReport(data,url) async {
    isSosReportLoading = true;
    sosReportList.clear();
    notifyListeners();

    List<SosReportModel> list;


    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print(body);

    try {
      if (response.statusCode == 200) {
        isSosReportLoading = false;
        var result = body;

        List client = result as List;
        list =
            client.map<SosReportModel>((json) => SosReportModel.fromJson(json))
                .toList();
        sosReportList.addAll(list);

        for (int i = 0; i < sosReportList.length; i++) {
          if (sosReportList[i].lat != null && sosReportList[i].long != null) {
            var data = {
              "lat": sosReportList[i].lat,
              "long": sosReportList[i].long,
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              sosReportAddressList.add(body["message"]);
            } else {
              sosReportAddressList.add(body["address"]);
            }
          }
          else {
            sosReportAddressList.add("Address Not Found");
          }
        }

        notifyListeners();
      }
      else {
        isSosReportLoading = false;
        print("get Sos Report Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isSosReportLoading = false;
      print("get Sos Report catch Api Error !!");
      notifyListeners();
    }
  }



  List<WorkingHoursReportModel> workingHoursReportList = [];
  bool isWorkingHoursReportLoading = false;
  workingHoursReport(data,url) async {
    isWorkingHoursReportLoading = true;
    workingHoursReportList.clear();
    notifyListeners();

   List<WorkingHoursReportModel> list;

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print(body);

    try {
      if (response.statusCode == 200) {
        isWorkingHoursReportLoading = false;
        var result = body;

        List client = result as List;
        list = client.map<WorkingHoursReportModel>((json) =>
            WorkingHoursReportModel.fromJson(json)).toList();
        workingHoursReportList.addAll(list);

        notifyListeners();
      }
      else {
        isWorkingHoursReportLoading = false;
        print("working Hours Report Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isWorkingHoursReportLoading = false;
      print("workingHoursReport catch Api Error !!");
      notifyListeners();
    }
  }



  //List<SummaryReportModel> summaryReportList = [];
  List<DeviceReportModel> summaryReportList = [];
  //List<DeviceReportModel> summaryReportList1 = [];
  bool isSummaryReportLoading = false;
  List summaryStartAddressList = [];
  List summaryEndAddressList = [];
  summaryReport(data,url) async {
    isSummaryReportLoading = true;
    summaryReportList.clear();
    notifyListeners();

    List<SummaryReportModel> list;

    var response = await CallApi().getDataAsParams(data,url);
    //var body = json.decode(response.body);
    final List<dynamic> responseData = json.decode(response.body);


    print("body is:---$responseData");

    try {
      if (response.statusCode == 200) {
        isSummaryReportLoading = false;
       // var result = body;
        summaryReportList.addAll(responseData.map((data) => DeviceReportModel.fromJson(data)).toList());



        /* List client = result as List;
        list = client.map<SummaryReportModel>((json) =>
            SummaryReportModel.fromJson(json)).toList();
        summaryReportList.addAll(list);*/

        for (int i = 0; i < summaryReportList.length; i++) {
          if (summaryReportList[i].startLocation != null) {
            var data = {
              "lat": summaryReportList[i].startLocation.lat,
              "long": summaryReportList[i].startLocation.long,
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              summaryStartAddressList.add(body["message"]);
            } else {
              summaryStartAddressList.add(body["address"]);
            }
          }
          else {
            summaryStartAddressList.add("Address Not Found");
          }
        }

        for (int i = 0; i < summaryReportList.length; i++) {
          if (summaryReportList[i].endLocation != null) {
            var data = {
              "lat": summaryReportList[i].endLocation.lat,
              "long": summaryReportList[i].endLocation.long,
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              summaryEndAddressList.add(body["message"]);
            } else {
              summaryEndAddressList.add(body["address"]);
            }
          }
          else {
            summaryEndAddressList.add("Address Not Found");
          }
        }

        notifyListeners();
      }
      else {
        isSummaryReportLoading = false;
        print("summaryReport  Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isSummaryReportLoading = false;
      print("summaryReport catch Api Error !!");
      notifyListeners();
    }
  }



  // bool isSummaryReportLoading = false;
  // List summaryReportList = [];
  //
  // summaryReport(data,url) async {
  //
  //   isSummaryReportLoading = true;
  //
  //   notifyListeners();
  //
  //   var response = await CallApi().getDataAsParams(data,url);
  //   var body = json.decode(response.body);
  //
  //   print(response.statusCode);
  //   // print('body->$body');
  //
  //   if (response.statusCode == 200) {
  //
  //     summaryReportList = body;
  //
  //     isSummaryReportLoading = false;
  //     notifyListeners();
  //   }
  //   else{
  //     isSummaryReportLoading = false;
  //     print("Comment Post Api Error !!");
  //     notifyListeners();
  //   }
  //
  // }


  bool isDayWiseReportLoading = false;
  GetdaywiseReportModel getdaywiseReportModel;
  List getDaywiseReportList = [];
  List dayWiseStartAddressList = [];
  List dayWiseEndAddressList = [];
  getDayWiseReports(data,url) async {

    isDayWiseReportLoading = true;
    getDaywiseReportList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    print("user Data --> $body");
    try {
      if (response.statusCode == 200) {
        getDaywiseReportList = body;


        for (int i = 0; i < getDaywiseReportList.length; i++) {
          if (getDaywiseReportList[i]['start_location'] != null) {
            var data = {
              "lat": getDaywiseReportList[i]['start_location']['lat'],
              "long": getDaywiseReportList[i]['start_location']['long'],
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              dayWiseStartAddressList.add(body["message"]);
            } else {
              dayWiseStartAddressList.add(body["address"]);
            }
          }
          else {
            dayWiseEndAddressList.add("Address not found");
          }
        }

        for (int i = 0; i < getDaywiseReportList.length; i++) {
          if (getDaywiseReportList[i]['end_location'] != null) {
            var data = {
              "lat": getDaywiseReportList[i]['end_location']['lat'],
              "long": getDaywiseReportList[i]['end_location']['long'],
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              dayWiseEndAddressList.add(body["message"]);
            } else {
              dayWiseEndAddressList.add(body["address"]);
            }
          }
          else {
            dayWiseEndAddressList.add("Address Not Found");
          }
        }

        isDayWiseReportLoading = false;
        notifyListeners();
      }
      else {
        isDayWiseReportLoading = false;
        print("DayWiseReport  Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isDayWiseReportLoading = false;
      print("Day Wise Reports catch Api Error !!");
      notifyListeners();
    }
  }


  bool isDailyReportListLoading = false;
  List<DailyReportList> getDailyReportList = [];
  dailyReportList(data,url) async {

    isDailyReportListLoading = true;
    getDailyReportList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

     print('responsecheck:${response.body}');

     try {
       if (response.statusCode == 200) {
         // var response = DailyReportModel.fromJson(body);
         getDailyReportList = (json.decode(response.body) as List).map((i) =>
             DailyReportList.fromJson(i)).toList();
         int totalMilliseconds = getDailyReportList[0].tIdling; // Replace with your own number
         Duration duration = Duration(milliseconds: totalMilliseconds);
         int hours = duration.inHours;
          int minutes=duration.inMinutes.remainder(60);
         print('$hours hours and $minutes minutes');
         getDailyReportList[0].tIdling ="$hours:$minutes";
         //print("iding is:${getDailyReportList[0].tIdling}");
         print("iding is:${getDailyReportList[0].tIdling}");

         isDailyReportListLoading = false;
         notifyListeners();
       }
       else {
         isDailyReportListLoading = false;
         print("daily Report List  Api Error !!");
         notifyListeners();
       }
     }catch(e){
       isDailyReportListLoading = false;
       print("daily Report List catch Api Error !!");
       notifyListeners();
     }
  }


  bool isIgnitionReportLoading = false;
  List ignitionReportList = [];

  List ignitionAddressList = [];

  ignitionReport(data,url) async {

    isIgnitionReportLoading = true;
    ignitionReportList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print(response.statusCode);

    try {
      if (response.statusCode == 200) {
        ignitionReportList = body;

        print("Body-->${body}");

        for (int i = 0; i < ignitionReportList.length; i++) {
          if (ignitionReportList[i] != null) {
            var data = {
              "lat": ignitionReportList[i]['lat'],
              "long": ignitionReportList[i]['long'],
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              ignitionAddressList.add(body["message"]);
            } else {
              ignitionAddressList.add(body["address"]);
            }
          }
          else {
            ignitionAddressList.add("Address Not Found");
          }
        }

        isIgnitionReportLoading = false;
        notifyListeners();
      }
      else {
        isIgnitionReportLoading = false;
        print("ignition Report Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isIgnitionReportLoading = false;
      print("ignition Report catch Api Error !!");
      notifyListeners();
    }

  }



  bool isOverSpeedReportLoading = false;
  List overSpeedReportList = [];
  List overSpeedAddressList = [];
  overSpeedReport(data,url) async {

    isOverSpeedReportLoading = true;
    overSpeedReportList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print(response.statusCode);

    try {
      if (response.statusCode == 200) {
        overSpeedReportList = body;

        print("Body-->${body}");

        for (int i = 0; i < overSpeedReportList.length; i++) {
          if (overSpeedReportList[i] != null) {
            var data = {
              "lat": overSpeedReportList[i]['lat'],
              "long": overSpeedReportList[i]['long'],
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              overSpeedAddressList.add(body["message"]);
            } else {
              overSpeedAddressList.add(body["address"]);
            }
          }
          else {
            overSpeedAddressList.add("Address Not Found");
          }
        }

        isOverSpeedReportLoading = false;
        notifyListeners();
      }
      else {
        isOverSpeedReportLoading = false;
        print("over Speed Report Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isOverSpeedReportLoading = false;
      print("over Speed Report catch Api Error !!");
      notifyListeners();
    }
  }


  bool isDistanceReportLoading = false;
  List distanceReportList = [];
  List distanceReportList1 = [];
  List distancestartAddressList = [];
  List distancelastAddressList = [];
  double odolist;
  var odolist1;
  bool setval=false;
  int selectedIndex=-1;
  List<int> selectedItems = [];

  void toggleSelected(int index) {

    if (selectedItems.contains(index)){
      setval=true;
      notifyListeners();
      selectedItems.remove(index);
    } else {
      setval=true;
      notifyListeners();
      selectedItems.add(index);
    }
    /*setval =!setval;
    selectedIndex = index;
    print("Selected index is:$selectedIndex");*/
    notifyListeners(); // To rebuild the Widget
  }

  distancevalue(data,url,vehicledistance)async
  {
    isDistanceReportLoading = true;
    log(' _reportProvider.isDistanceReportLoading====>${isDistanceReportLoading}');
   // notifyListeners();
    print("data is:${data["device"]}");
    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        distanceReportList = body;

        print("DistanceRBody-->${body}");


        for (int i = 0; i < distanceReportList.length; i++) {
          odolist = await distanceReportList[i]['distance'];
         // notifyListeners();
          print("distance id is:$odolist");

            if(distanceReportList==null) {
              vehicledistance.distance = 0.0;
              //notifyListeners();
            } else {
              vehicledistance.distance = odolist;
            //  notifyListeners();
              print("distnace is----------${vehicledistance.distance}");
          }


          isDistanceReportLoading = false;
          log(' _reportProvider.isDistanceReportLoading====>${isDistanceReportLoading}');

          notifyListeners();
        }

        if(distanceReportList.isEmpty) {
          vehicledistance.distance = 0.0;
          notifyListeners();
        }

        isDistanceReportLoading = false;
        log(' _reportProvider.isDistanceReportLoading====>${isDistanceReportLoading}');

        notifyListeners();
      }
      else {
        isDistanceReportLoading = false;
        log(' _reportProvider.isDistanceReportLoading====>${isDistanceReportLoading}');

        print("distance Report Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isDistanceReportLoading = false;    log(' _reportProvider.isDistanceReportLoading====>${isDistanceReportLoading}');


      print("distance Report catch Api Error !!$e");
      notifyListeners();
    }

  }

  distanceReport(data,url) async {

    isDistanceReportLoading = true;
    distanceReportList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print(response.statusCode);

    try {
      if (response.statusCode == 200) {
        distanceReportList = body;

        print("DistanceRBody-->${body}");

        for (int i = 0; i < distanceReportList.length; i++) {
          odolist =await distanceReportList[i]['distance'];
          notifyListeners();
          print("distance id is:$odolist");

     /*      VehicleLisDevice(distance:distanceReportList[i]['distance'] );
          final user =await VehicleLisDevice.fromJson(body);
          user.distance =await distanceReportList[i]['distance'];
          notifyListeners();

          VehicleLisDevice itemToUpdate = vehicleList.firstWhere((item) => item.deviceId.toString() == id.toString(), orElse: () => null);
          if (itemToUpdate != null) {
            // Update the distance value for the matching vehicle
            itemToUpdate.distance=distanceReportList[i]['distance'];
            notifyListeners();
            // Update the UI with the new data
            print('Vehicle, found for device ID: $id');

          } else {
            print('Vehicle not found for device ID: $id');
          }

*/

          if (distanceReportList[i]["startLat"] != null &&
              distanceReportList[i]['startLng'] != null) {
            var data = {
              "lat": distanceReportList[i]['startLat'],
              "long": distanceReportList[i]['startLng'],
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              distancestartAddressList.add(body["message"]);
            } else {
              distancestartAddressList.add(body["address"]);
              print('checked-->${distancestartAddressList}');
            }
          }
          else {
            distancestartAddressList.add("Address Not Found");
          }
        }

        for (int i = 0; i < distanceReportList.length; i++) {
          if (distanceReportList[i]['endLat'] != null &&
              distanceReportList[i]['endLng'] != null) {
            var data = {
              "lat": distanceReportList[i]['endLat'],
              "long": distanceReportList[i]['endLng'],
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              distancelastAddressList.add(body["message"]);
            } else {
              distancelastAddressList.add(body["address"]);
            }
          }
          else {
            distancelastAddressList.add("Address Not Found");
          }
        }

        isDistanceReportLoading = false;
        notifyListeners();
      }
      else {
        isDistanceReportLoading = false;
        print("distance Report Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isDistanceReportLoading = false;
      print("distance Report catch Api Error !!$e");
      notifyListeners();
    }

  }

  void setdata(var data) {
    odolist1 = data;

    notifyListeners();
  }


  bool isTripDetailsReportLoading = false;
  List tripDetailsReportList = [];
  List startAdressTripDetailList =[];
  List endAdressTripDetailList =[];
  tripDetailReport(data,url) async {

    isTripDetailsReportLoading = true;
    tripDetailsReportList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print(response.statusCode);

    try {
      if (response.statusCode == 200) {
        tripDetailsReportList = body;

        // print("Body-->${body}");

        for (int i = 0; i < tripDetailsReportList.length; i++) {
          if (tripDetailsReportList[i]["start_lat"] != null &&
              tripDetailsReportList[i]['start_long'] != null) {
            var data = {
              "lat": tripDetailsReportList[i]['start_lat'],
              "long": tripDetailsReportList[i]['start_long'],
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              startAdressTripDetailList.add(body["message"]);
            } else {
              startAdressTripDetailList.add(body["address"]);
              print('checked-->$startAdressTripDetailList');
            }
          }
          else {
            startAdressTripDetailList.add("Address Not Found");
          }
        }


        for (int i = 0; i < tripDetailsReportList.length; i++) {
          if (tripDetailsReportList[i]["end_lat"] != null &&
              tripDetailsReportList[i]['end_long'] != null) {
            var data = {
              "lat": tripDetailsReportList[i]['end_lat'],
              "long": tripDetailsReportList[i]['end_long'],
            };

            print(data);

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in databse") {
              endAdressTripDetailList.add(body["message"]);
            } else {
              endAdressTripDetailList.add(body["address"]);

              print('checked-->$endAdressTripDetailList');
            }
          }
          else {
            endAdressTripDetailList.add("Address Not Found");
          }
        }

        isTripDetailsReportLoading = false;
        notifyListeners();
      }
      else {
        isTripDetailsReportLoading = false;
        print("tripDetailReport Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isTripDetailsReportLoading = false;
      print("tripDetailReport catch Api Error !!");
      notifyListeners();
    }

  }


  bool isDropDownLoading = false;
  UserVehicleDropModel userVehicleDropModel;
  List<VehicleList> searchVehicleList = [];
  List<VehicleList> vehicleList = [];
  bool isSuccess = false;
  getVehicleDropdown(data,url) async {

    isDropDownLoading = true;
    vehicleList.clear();
    searchVehicleList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    print("devices/getDeviceByUserDropdown12: $body");
    try {
      if (response.statusCode == 200) {

        userVehicleDropModel = UserVehicleDropModel.fromJson(body);

        searchVehicleList = userVehicleDropModel.devices;
        vehicleList = userVehicleDropModel.devices;

        isDropDownLoading = false;
        isSuccess = true;
        notifyListeners();
      }
      else {
        isDropDownLoading = false;
        print(" Vehicle Drop down  Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isDropDownLoading = false;
      print("Vehicle Drop down catch Api Error !!");
      notifyListeners();
    }
  }


  List<AcReportsModel>acReportsList = [];
  List<bool>showAcDetail = [];
  bool isAcLoading = false;

  getAcReports(data,url) async {
    isAcLoading = true;
    acReportsList.clear();
    // showAcDetail.clear();
    notifyListeners();

    List<AcReportsModel> list;

    try {
      var response = await CallApi().getDataAsParamsSocket(data, url);
      var body = json.decode(response.body);

      print("Ac Report:$body");

      if (response.statusCode == 200) {
        var result = body;

        print(result);

        List client = result as List;
        client.forEach((element) {
          print(element);
          list = element.map<AcReportsModel>((json) => AcReportsModel.fromJson(json)).toList();
          print(list);

          list.forEach((element1) {
            acReportsList.add(element1);
          });
        });

      //  acReportsList.addAll(list);

        showAcDetail = List<bool>.filled(acReportsList.length, false);
        isAcLoading = false;

        print(showAcDetail);
        isAcLoading = false;
        notifyListeners();
      }
      else {
        isAcLoading = false;
        print("Ac Api Error !!");
        notifyListeners();
      }
    }catch(e){
      print("Ac catch Api Error !!");
      isAcLoading = false;
      notifyListeners();
    }

  }


  updateAcDetails(bool acShow,int index){
    showAcDetail = List<bool>.filled(acReportsList.length, false);
    showAcDetail[index] = acShow;
    notifyListeners();
  }


  bool isGpsSpeedReportLoading = false;
  var gpsSpeedData;
  List<GpsSpeedVariationChart> getGpsSpeedChart = [];
  getGpsSpeedReport(data,url) async {
    getGpsSpeedChart.clear();
    isGpsSpeedReportLoading = true;
    notifyListeners();

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    print("body-->$body");

    try {
      if (response.statusCode == 200) {
        gpsSpeedData = body;

        print('Check-->${gpsSpeedData}');
        print('Check ------time------>${gpsSpeedData[1]["time"].toString()}');

        if (body.length > 0 && body[0]["time"] != 0) {
          for (int i = 0; i < body.length; i++) {
            getGpsSpeedChart.add(
                GpsSpeedVariationChart(
                  x: body[i]['time'] == 0
                      ?
                  ""
                      :
                  DateFormat("hh:mm").format(
                      DateTime.parse(body[i]['time'])),
                  y: body[i]['speed'] == 0 || body[i]['speed'] == null
                      ?
                  0.0
                      :
                  double.parse(body[i]['speed']),
                ));
          }
        }

        isGpsSpeedReportLoading = false;
        notifyListeners();
      }
      else {
        isGpsSpeedReportLoading = false;
        print("Gps Speed Report  Api Error !!");
        notifyListeners();
         }
    }catch(e){
      isGpsSpeedReportLoading = false;
      print("Gps Speed Report catch Api Error !!$e");
      notifyListeners();
    }
  }



   List<RouteReportsModel> routeViolationReportList = [];
  bool isRouteViolationLoading = false;
  List routeAddressList = [];

  routeViolationReport(data,url) async {
    isRouteViolationLoading = true;
    routeViolationReportList.clear();
    routeAddressList.clear();
    notifyListeners();


    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    print(body);
    List<RouteReportsModel> list ;

    try {
      if (response.statusCode == 200) {
        var result = body;

        List client = result as List;
        list  = client.map<RouteReportsModel>((json) => RouteReportsModel.fromJson(json)).toList();
        routeViolationReportList.addAll(list);

        for (int i = 0; i < routeViolationReportList.length; i++) {
          if (routeViolationReportList[i].lat != null && routeViolationReportList[i].long != null) {
            var data = {
              "lat": routeViolationReportList[i].lat,
              "long": routeViolationReportList[i].long,
            };

            print('routeViolationLatLng->${data}');

            var response = await CallApi().postData(data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in database") {
              routeAddressList.add(body["message"]);
            } else {
              routeAddressList.add(body["address"]);
            }
          }
          else {
            routeAddressList.add("Address Not Found");
          }
        }

        /* int i;
        for(i=0;i<routeViolationReportList.length; i++){
          if(routeViolationReportList[i].lat != null && routeViolationReportList[i].long != null ){
            List<Placemark> placemarks = await placemarkFromCoordinates(routeViolationReportList[i].lat, routeViolationReportList[i].long).
            catchError((e){
              routeAddressList.add("Address Not Found");
            });
            routeAddressList.add(
              "${placemarks.first.name}"
                  " ${placemarks.first.subLocality}"
                  " ${placemarks.first.locality}"
                  " ${placemarks.first.subAdministrativeArea} "
                  "${placemarks.first.administrativeArea},"
                  "${placemarks.first.postalCode}",
            );
          }else{
            routeAddressList.add("Address Not Found");
          }
        }

        if(i == routeViolationReportList.length ) {
          isRouteViolationLoading = false;
          notifyListeners();

        }*/
        isRouteViolationLoading = false;
        notifyListeners();

      }
      else {
        isRouteViolationLoading = false;
        print("routeViolationReport Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isRouteViolationLoading = false;
      print("routeViolationReport catch Api Error !!");
      notifyListeners();
    }
  }


  List<GetRouteModel> getRouteList = [];
  bool isGetRouteLoading = false;

  getAllRoute(url)async{
    isGetRouteLoading = true;
    getRouteList.clear();
    notifyListeners();

    List<GetRouteModel> list;
    var response = await CallApi().getAsParams(url);
    var body = json.decode(response.body);

    print("get all route ==> $body");

    if (response.statusCode == 200) {
      var result  = body;
      List client = result as List;
      list  = client.map<GetRouteModel>((json) => GetRouteModel.fromJson(json)).toList();

      getRouteList.addAll(list);


      isGetRouteLoading = false;
      notifyListeners();

    }else{
      isGetRouteLoading = false;
      print("get all route api error!!");
      notifyListeners();
    }

  }


  List<UserTripDetailModel> userTripList = [];
  bool isUserTripLoading = false;
  List userTripStartAddressList = [];

  getUserTrip(data,url)async{

    isUserTripLoading = true;
    userTripList.clear();
    notifyListeners();

    List<UserTripDetailModel> list = [];

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print("get user trip ==> $body");

    if (response.statusCode == 200) {
      var result  = body;
      List client = result as List;
      list  = client.map<UserTripDetailModel>((json) => UserTripDetailModel.fromJson(json)).toList();
      userTripList.addAll(list);

      for (int i = 0; i < userTripList.length; i++) {
        if (userTripList[i].startLat != null && userTripList[i].startLong != null) {
          var data = {
            "lat": userTripList[i].startLat,
            "long": userTripList[i].startLong,
          };

          print('userTripLatLng->${data}');

          var response = await CallApi().postData(data, "googleAddress/getGoogleAddress");
          var body = json.decode(response.body);
          print(body);

          if (body["message"] == "Address not found in database") {
            userTripStartAddressList.add(body["message"]);
          } else {
            userTripStartAddressList.add(body["address"]);
          }
        }
        else {
          userTripStartAddressList.add("Address Not Found");
        }
      }

      isUserTripLoading = false;
      notifyListeners();

    }else{
      isUserTripLoading = false;
      print("User trip api error!!");
      notifyListeners();
    }

  }
}