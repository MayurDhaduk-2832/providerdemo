import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/histroy_track_model.dart';
import 'package:oneqlik/Model/parking_model.dart';
import 'package:oneqlik/local/localization/language_constants.dart';

class HistoryProvider with ChangeNotifier{

  bool isDistanceReportLoading = false;
  List distanceReportList = [];

  List<HistoryTrackModel>trackList = [];
  bool isTrackLoading = false;
  List<LatLng> trackLat = [];
  String googleAPiKey = "AIzaSyDNmQ3sok_q3O9JZ66cFJgzFfiJiDWESmY";
  bool isSuccess = false;

  getTrack(data,url,context) async {
    isTrackLoading = true;
    isSuccess = false;
    trackList.clear();
    trackLat.clear();
    notifyListeners();

    List<HistoryTrackModel> list;


    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print("car history");
    print(body);


    if (response.statusCode == 200) {
      var result1  = body;

      List client = result1 as List;
      list  = client.map<HistoryTrackModel>((json) => HistoryTrackModel.fromJson(json)).toList();
      trackList.addAll(list.reversed);
      int i;
      if(trackList.length != 0){
        for( i=0; i<trackList.reversed.length; i++){
          trackLat.add(LatLng(trackList[i].lat,trackList[i].lng));
        }
      }
      if(body.isEmpty){
        Helper.dialogCall.showToast(context, "${getTranslated(context,"History_Is_Not_Available")}");
      }

      if(i == trackList.reversed.length){
        isTrackLoading = false;
        isSuccess = true;
        notifyListeners();
      }
    }
    else{
      isTrackLoading = false;
      print("track history Api Error !!");
      notifyListeners();
    }

  }

  bool isParkingLoading = false;
  List<ParkingModel>parkingList = [];
  Uint8List parkingPoint;
  bool isSuccessParking = false;

  getParkingData(data,url) async {
    isParkingLoading = true;
    isSuccessParking = false;
    parkingList.clear();
    notifyListeners();

    List<ParkingModel> list;

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    print("car parking");
    print("stoppage report :---$body");


    if (response.statusCode == 200) {
      var result1  = body;

      List client = result1 as List;
      list  = client.map<ParkingModel>((json) => ParkingModel.fromJson(json)).toList();
      parkingList.addAll(list);


      isParkingLoading = false;
      isSuccessParking = true;
      notifyListeners();
    }
    else{
      isParkingLoading = false;
      print("parking Api Error !!");
      notifyListeners();
    }

  }

  bool isDisLoading = false;
  var distance ="0.0";

  getDistance(data,url) async {
    isDisLoading = true;

    notifyListeners();

    var response = await CallApi().getDataAsParams(data, url);
    var body = json.decode(response.body);

    print("car distance");
    print(body);

    if (response.statusCode == 200) {
      distance = body['Distance'];
      isDisLoading = false;
      notifyListeners();
    } else {
      isDisLoading = false;
      print("distance  Api Error !!");
      notifyListeners();
    }

  }

  int timerSpeed = 2500;
  int carSpeed = 4000;

  changeTimerSpeed(int carsped,int timerspeed){
    timerSpeed = timerspeed;
    carSpeed = carsped;
    notifyListeners();
  }

  int speedValue = 1;
  changeSpeedValue(speedvalue){
    speedValue = speedvalue;
    notifyListeners();
  }


  int moveSpeedInSeconds = 0;
  changeNewMakerSpeed(int newMoveSpeedSec){
    moveSpeedInSeconds = newMoveSpeedSec;
    notifyListeners();
  }


  distancevalue(data,url)async
  {
    isDistanceReportLoading = true;
    log(' history.isDistanceReportLoading====>${isDistanceReportLoading}');
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
          distance = await distanceReportList[i]['distance'];
          // notifyListeners();
          print("distance id is:$distance");

          if(distanceReportList==null) {
          //  vehicledistance.distance = 0.0;
            //notifyListeners();
          } else {
        //    vehicledistance.distance = distance;
            //  notifyListeners();
          //  print("distnace is----------${vehicledistance.distance}");
          }


          isDistanceReportLoading = false;
          log(' history.isDistanceReportLoading====>${isDistanceReportLoading}');

          notifyListeners();
        }

        if(distanceReportList.isEmpty) {
         // vehicledistance.distance = 0.0;
          notifyListeners();
        }

        isDistanceReportLoading = false;
        log(' history.isDistanceReportLoading====>${isDistanceReportLoading}');

        notifyListeners();
      }
      else {
        isDistanceReportLoading = false;
        log(' history.isDistanceReportLoading====>${isDistanceReportLoading}');

        print("distance Report Api Error !!");
        notifyListeners();
      }
    }catch(e){
      isDistanceReportLoading = false;    log(' history.isDistanceReportLoading====>${isDistanceReportLoading}');


      print("distance Report catch Api Error !!$e");
      notifyListeners();
    }

  }


}