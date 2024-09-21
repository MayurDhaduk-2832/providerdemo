

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/fuel_consumption_daily_model.dart';
import 'package:oneqlik/Model/fuel_consumption_time_model.dart';
import 'package:oneqlik/Model/fuel_consumption_trip_model.dart';
import 'package:oneqlik/Model/get_fuel_entry_model.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/SyncfunctionPages/chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FuelProvider with ChangeNotifier{

  var chooseExpenseType;

  bool isaddFuelLoading = false;

  addFuel(data,url,context,vId) async {


    Helper.dialogCall.showAlertDialog(context);
    isaddFuelLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data,url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");


      var data =
      {
        "user": "$id",
        "vehicle":"${vId}",
      };

      getFuelEntryDetails(data, "fuel/getFuels",context);

      isaddFuelLoading = false;

      Navigator.pop(context);
      Navigator.pop(context);

      notifyListeners();
    }
    else{
      isaddFuelLoading = false;
      print("Add Fuel Entry Api Error !!");
      notifyListeners();
    }

  }

  bool isUpdateFuelLoading = false;

  updateFuel(data,url,context,vId) async {
    Helper.dialogCall.showAlertDialog(context);
    isUpdateFuelLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data,url);
    // var body = json.decode(response.body);

    // print('body->$body');


    if (response.statusCode == 200) {

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");

      var data =
      {
        "user": "$id",
        "vehicle":"$vId",
      };

      getFuelEntryDetails(data, "fuel/getFuels",context);

      isUpdateFuelLoading = false;

      Navigator.pop(context);
      Navigator.pop(context);

      notifyListeners();
    }
    else{
      Navigator.pop(context);
      print("Edit Fuel Entry  Api Error !!");
      notifyListeners();
    }

  }




  deleteFuel(data, url, context,vId) async {

    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().getDataAsParams(data, url);

    // print('res${response.body}');

    if (response.statusCode == 200) {
      getFuelEntryList.clear();

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      var id = sharedPreferences.getString("uid");

      var data =
      {
        "user": "$id",
        "vehicle":"$vId",
      };

      getFuelEntryDetails(data, "fuel/getFuels",context);

      Helper.dialogCall.showToast(context, "${getTranslated(context, "fuel_deleted_successfully")}");

      Navigator.of(context).pop();
      Navigator.of(context).pop();

      notifyListeners();
    }
    else {
      print("Fuel delete Api Error !!");
      notifyListeners();
    }
  }


  bool isFuelGraphLoading = false;
  var fuelData;
  List<FuelChart> fuelChart = [];

  getFuelGraph(data,url) async {
    fuelChart.clear();
    isFuelGraphLoading = true;
    notifyListeners();

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      fuelData = body;

      for(int i=0; i<body.length; i++){
        fuelChart.add(FuelChart(
            x: DateFormat("hh:mm").format(DateTime.parse(body[i]['insertionTime'])),
            y: body[i]['currentFuel'],
            x2:  (body[i]['fuelVoltage']/1000)
          ));
      }

      isFuelGraphLoading = false;
      notifyListeners();
    }
    else{
      isFuelGraphLoading = false;
      print("Fuel Graph  Api Error !!");
      notifyListeners();
    }
  }


  List<FuelConsumptionTimeModel> getFuelConsumeTimeList = [];
  List getFuelTimeStartAddressList = [];
  List getFuelTimeEndAddressList = [];
  bool isFuelConsumeTimeListLoading = false;

  getFuelConsumeTimeDetails(data,url) async {
    isFuelConsumeTimeListLoading = true;
    getFuelConsumeTimeList.clear();
    notifyListeners();

    List<FuelConsumptionTimeModel> list;


    var response = await CallApi().postData(data,url);
    var body = json.decode(response.body);

    print("check->$body");

    if (response.statusCode == 200) {
      var result  = body;

      List client = result as List;
      list  = client.map<FuelConsumptionTimeModel>((json) => FuelConsumptionTimeModel.fromJson(json)).toList();
      getFuelConsumeTimeList.addAll(list);

      for(int i = 0; i<getFuelConsumeTimeList.length; i++){

        if(getFuelConsumeTimeList[i].startLocation!= null)
        {
          var data = {
            "lat":getFuelConsumeTimeList[i].startLocation.lat,
            "long":getFuelConsumeTimeList[i].startLocation.lng,
          };

          print('datalatlong->${data}');

          var response = await CallApi().postData(data,"googleAddress/getGoogleAddress");
          var body = json.decode(response.body);
          print(body);


          if(body["message"] == "Address not found in database"){
            getFuelTimeStartAddressList.add(body["message"]);
          }else{
            getFuelTimeStartAddressList.add(body["address"]);
          }
        }
        else{
          getFuelTimeStartAddressList.add("Address Not Found");
        }
      }

      for(int i = 0; i<getFuelConsumeTimeList.length; i++){
        if(getFuelConsumeTimeList[i].endLocation != null)
        {
          var data = {
            "lat":getFuelConsumeTimeList[i].endLocation.lat,
            "long":getFuelConsumeTimeList[i].endLocation.lng,
          };

          print('datalatlong->${data}');

          var response = await CallApi().postData(data,"googleAddress/getGoogleAddress");
          var body = json.decode(response.body);
          print(body);

          if(body["message"] == "Address not found in database"){
            getFuelTimeEndAddressList.add(body["message"]);
          }else{
            getFuelTimeEndAddressList.add(body["address"]);
          }
        }
        else{
          getFuelTimeEndAddressList.add("Address Not Found");
        }
      }

      isFuelConsumeTimeListLoading = false;
      notifyListeners();
    }
    else{
      isFuelConsumeTimeListLoading = false;
      print("Fuel Consumption Time Api Error !!");
      notifyListeners();
    }

  }

  List<FuelConsumptionDailyModel> getFuelConsumeDailyList = [];
  List getFuelDailyStartAddressList = [];
  List getFuelDailyEndAddressList = [];
  bool isFuelConsumeDailyListLoading = false;

  getFuelConsumeDailyDetails(data,url) async {
    isFuelConsumeDailyListLoading = true;
    getFuelConsumeDailyList.clear();
    notifyListeners();

    List<FuelConsumptionDailyModel> list;


    var response = await CallApi().postData(data,url);
    var body = json.decode(response.body);

    print("check->$body");

    if (response.statusCode == 200) {

      var result  = body;

      List client = result as List;
      list  = client.map<FuelConsumptionDailyModel>((json) => FuelConsumptionDailyModel.fromJson(json)).toList();
      getFuelConsumeDailyList.addAll(list);

      for(int i = 0; i<getFuelConsumeDailyList.length; i++){
        if(getFuelConsumeDailyList[i].startLocation == null){
          getFuelDailyStartAddressList.add("Address Not Found");
        }
        else{
          if(getFuelConsumeDailyList[i].startLocation.lat != null && getFuelConsumeDailyList[i].startLocation.lng != null)
          {
            var data = {
              "lat":getFuelConsumeDailyList[i].startLocation.lat,
              "long":getFuelConsumeDailyList[i].startLocation.lng,
            };

            print('datalatlong->${data}');

            var response = await CallApi().postData(data,"googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if(body["message"] == "Address not found in database"){
              getFuelDailyStartAddressList.add(body["message"]);
            }else{
              getFuelDailyStartAddressList.add(body["address"]);
            }
          }

        }

      }

      for(int i = 0; i<getFuelConsumeDailyList.length; i++){
        if(getFuelConsumeDailyList[i].endLocation == null){
          getFuelDailyEndAddressList.add("Address Not Found");
        }
       else{
          var data = {
            "lat":getFuelConsumeDailyList[i].endLocation.lat,
            "long":getFuelConsumeDailyList[i].endLocation.lng,
          };

          print('datalatlong->${data}');

          var response = await CallApi().postData(data,"googleAddress/getGoogleAddress");
          var body = json.decode(response.body);
          print(body);

          if(body["message"] == "Address not found in database"){
            getFuelDailyEndAddressList.add(body["message"]);
          }else{
            getFuelDailyEndAddressList.add(body["address"]);
          }
        }

      }

      isFuelConsumeDailyListLoading = false;
      notifyListeners();
    }
    else{
      isFuelConsumeDailyListLoading = false;
      print("Fuel Consumption Daily Api Error !!");
      notifyListeners();
    }

  }

  List<FuelConsumptionTripModel> getFuelConsumeTripList = [];
  List getFuelTripStartAddressList = [];
  List getFuelTripEndAddressList = [];
  bool isFuelConsumeTripListLoading = false;

  getFuelConsumeTripDetails(data,url) async {
    isFuelConsumeTripListLoading = true;
    getFuelConsumeTripList.clear();
    notifyListeners();

    List<FuelConsumptionTripModel> list;


    var response = await CallApi().postData(data,url);
    var body = json.decode(response.body);

    print("check->$body");

    try{
      if (response.statusCode == 200 || body["message"] != "no trip found" ) {
        var result = body;
        List client = result as List;
        list = client.map<FuelConsumptionTripModel>((json) =>
            FuelConsumptionTripModel.fromJson(json)).toList();
        getFuelConsumeTripList.addAll(list);


        for (int i = 0; i < getFuelConsumeTripList.length; i++) {
          if (getFuelConsumeTripList[i].startLocation != null) {
            if (getFuelConsumeTripList[i].startLocation.lat != null &&
                getFuelConsumeTripList[i].startLocation.lng != null) {
              var data = {
                "lat": getFuelConsumeTripList[i].startLocation.lat,
                "long": getFuelConsumeTripList[i].startLocation.lng,
              };

              print('datalatlong->${data}');

              var response = await CallApi().postData(
                  data, "googleAddress/getGoogleAddress");
              var body = json.decode(response.body);
              print(body);

              if (body["message"] == "Address not found in database") {
                getFuelTripStartAddressList.add(body["message"]);
              } else {
                getFuelTripStartAddressList.add(body["address"]);
              }
            }
          }else{
            getFuelTripStartAddressList.add("Address Not Found");
          }
        }

        for (int i = 0; i < getFuelConsumeTripList.length; i++) {
          if (getFuelConsumeTripList[i].endLocation != null) {
            if (getFuelConsumeTripList[i].endLocation.lat != null &&
                getFuelConsumeTripList[i].endLocation.lng != null) {
              var data = {
                "lat": getFuelConsumeTripList[i].endLocation.lat,
                "long": getFuelConsumeTripList[i].endLocation.lng,
              };

              print('datalatlong->${data}');

              var response = await CallApi().postData(
                  data, "googleAddress/getGoogleAddress");
              var body = json.decode(response.body);
              print(body);

              if (body["message"] == "Address not found in database") {
                getFuelTripEndAddressList.add(body["message"]);
              } else {
                getFuelTripEndAddressList.add(body["address"]);
              }
            }

          }
          else{
            getFuelTripEndAddressList.add("Address Not Found");
          }
        }
        isFuelConsumeTripListLoading = false;
        notifyListeners();
      }
      else {
        isFuelConsumeTripListLoading = false;
        print("Fuel Consumption Trip Api Error !!");
        notifyListeners();
      }}
      catch(e){
        isFuelConsumeTripListLoading = false;
        print("Fuel Consumption Trip Catch Api Error !!");
        notifyListeners();
    }
  }

  List<GetFuelEntryModel> getFuelEntryList = [];
  bool isGetFuelEntryLoading = false;

  getFuelEntryDetails(data, url,context) async {

    isGetFuelEntryLoading = true;
    getFuelEntryList.clear();
    notifyListeners();

    List<GetFuelEntryModel> list;

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {

      var result = body;

      List client = result as List;
      list = client.map<GetFuelEntryModel>((json) =>
          GetFuelEntryModel.fromJson(json)).toList();
      getFuelEntryList.addAll(list);

      isGetFuelEntryLoading = false;

      notifyListeners();
    }
    else {
      isGetFuelEntryLoading = false;
      print("Fuel Entrey  Api Error !!");
      notifyListeners();
    }
  }

}