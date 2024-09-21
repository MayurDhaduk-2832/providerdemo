

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/get_all_geofence_model.dart';
import 'package:oneqlik/Model/get_poi_list_model.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeofencesProvider with ChangeNotifier {

  addGeofenceCircle(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      poiAddress.clear();
      getPoiDetailsList.clear();
      var id = sharedPreferences.getString("uid");

      var data = {
        "user": id,
      };

      getPoiList(data, "poiV2/getPois","geo");


      Navigator.of(context).pop();
      Navigator.of(context).pop();

      Helper.dialogCall.showToast(context, "${getTranslated(context, "fence_added_successfully")}");

      notifyListeners();
    }
    else {
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  addGeofencePoly(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      var id = sharedPreferences.getString("uid");

      var data = {
        "uid": id,
      };

      getAllGeofence(data, "geofencingV2/getallgeofence","geo",context);

      Helper.dialogCall.showToast(context, "${getTranslated(context, "fence_added_successfully")}");
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      notifyListeners();
    }
    else {
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }


  bool isGeofenceLoading = false;
  BitmapDescriptor sourceIcon;
  List<Datum> getAllGeofenceList = [];
  bool geoSuccess = false;
  Set<Polygon> poliyList = {};

  List<List<LatLng>> latLng = [];
  List<LatLng> latLngList = [];
  getAllGeofence(data,url,pageType,context) async {

    isGeofenceLoading = true;
    geoSuccess = false;
    getAllGeofenceList.clear();
    poliyList.clear();
    latLngList.clear();
    latLng.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);


    if (response.statusCode == 200) {

      var response = GetAllGeofenceModel.fromJson(body);
      getAllGeofenceList.addAll(response.data);

      for(int i = 0; i<getAllGeofenceList.length; i++ ) {
        var list = getAllGeofenceList[i];
        List<LatLng> latList = [];
        if (list.geofence.coordinates.isNotEmpty){

          for(int j= 0; j<list.geofence.coordinates.length; j++){
            latList.add(LatLng(list.geofence.coordinates[j].lat, list.geofence.coordinates[j].long));
            latLngList.add(LatLng(list.geofence.coordinates[j].lat, list.geofence.coordinates[j].long));
          }


          latLng.add(latList);
        }
      }

      isGeofenceLoading = false;
      geoSuccess = true;
      notifyListeners();
    }
    else{

        isGeofenceLoading = false;
        geoSuccess = false;
        print("GetAllGeofence Api Error !!");
        notifyListeners();

    }

  }



  bool isGetPoiListLoading = false;
  List<GetPoiList> getPoiDetailsList = [];
  List poiAddress = [];
  bool isSuccess = false;
  getPoiList(data,url,page) async {

    isGetPoiListLoading = true;
    getPoiDetailsList.clear();
    poiAddress.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print("PoiList Details-->${body}");

    if (response.statusCode == 200) {


      var response = GetPoiListModel.fromJson(body);
      getPoiDetailsList.addAll(response.data);


      if(page == "geo") {
        for (int i = 0; i < getPoiDetailsList.length; i++) {
          if (getPoiDetailsList[i].poi.location.coordinates[0] != null &&
              getPoiDetailsList[i].poi.location.coordinates[1] != null) {
            var data = {
              "lat": getPoiDetailsList[i].poi.location.coordinates[0],
              "long": getPoiDetailsList[i].poi.location.coordinates[1]
            };

            print('poiAddressLatLng->${data}');

            var response = await CallApi().postData(
                data, "googleAddress/getGoogleAddress");
            var body = json.decode(response.body);
            print(body);

            if (body["message"] == "Address not found in database") {
              poiAddress.add(body["message"]);
            } else {
              poiAddress.add(body["address"]);
            }
          }
          else {
            poiAddress.add("Address Not Found");
          }
        }
      }
      isSuccess = true;
      isGetPoiListLoading = false;
      notifyListeners();
    }
    else{
      isGetPoiListLoading = false;
      print("GetPoiList Api Error !!");
      notifyListeners();
    }

  }


  bool isdeleteGeofenceLoading = false;
  deleteGeofence(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isdeleteGeofenceLoading = true;
    notifyListeners();

    var response = await CallApi().getDataAsParams(data, url);

    if (response.statusCode == 200) {
      isdeleteGeofenceLoading = false;

      Helper.dialogCall.showToast(context, "${getTranslated(context, "fence_deleted_successfully")}");

      Navigator.of(context).pop();
      Navigator.of(context).pop();

      notifyListeners();
    }
    else {
      isdeleteGeofenceLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }


  bool isdeletePoiLoading = false;
  deletePoi(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isdeletePoiLoading = true;
    notifyListeners();

    var response = await CallApi().getDataAsParams(data, url);

    if (response.statusCode == 200) {
      isdeletePoiLoading = false;

      Helper.dialogCall.showToast(context, "${getTranslated(context, "poi_deleted_successfully")}");

      Navigator.of(context).pop();
      Navigator.of(context).pop();

      notifyListeners();
    }
    else {
      isdeletePoiLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }


  bool isUpdateGeofenceCircLoading = false;
  updateGeofenceCircle(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isUpdateGeofenceCircLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("update Poi Body-->$body");

    if (response.statusCode == 200) {

      isUpdateGeofenceCircLoading = false;


      Helper.dialogCall.showToast(context, "${getTranslated(context, "fence_updated_successfully")}");

      Navigator.pop(context,"refresh");
      Navigator.pop(context,"refresh");

      notifyListeners();
    }
    else {
      isUpdateGeofenceCircLoading = false;
      print("update Poi Api  Error !!");
      notifyListeners();
    }
  }


  bool isUpdatePolyLoading = false;
  updateGeofencePoly(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isUpdatePolyLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      isUpdatePolyLoading = false;


      Helper.dialogCall.showToast(context, "${getTranslated(context, "fence_updated_successfully")}");
      Navigator.pop(context,"refresh");
      Navigator.pop(context,"refresh");


      notifyListeners();
    }
    else {
      isUpdatePolyLoading = false;
      print("update geofence Api Error !!");
      notifyListeners();
    }
  }

}
