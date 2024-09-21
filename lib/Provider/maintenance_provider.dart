

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/TypeModel.dart';
import 'package:oneqlik/Model/vehicle_maintenance_model.dart';
import 'package:oneqlik/local/localization/language_constants.dart';

class MaintenanceProvider with ChangeNotifier{

  List<VehicleMaintenanceModel>maintenanceList = [];
  bool isMaintenanceLoading = false;

  getVehicleReminder(data,url) async {
    isMaintenanceLoading = true;
    maintenanceList.clear();
    notifyListeners();

    List<VehicleMaintenanceModel> list;


    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);
     print("vehicle reminders: $body");



    if (response.statusCode == 200) {
      isMaintenanceLoading = false;
      var result  = body;

      List client = result as List;
      list  = client.map<VehicleMaintenanceModel>((json) => VehicleMaintenanceModel.fromJson(json)).toList();
      maintenanceList.addAll(list);

      notifyListeners();
    }
    else{
      isMaintenanceLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }

  }

  addReminder(data,url,context) async {

    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data,url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      Navigator.of(context).pop();

      Helper.dialogCall.showToast(context, "${getTranslated(context, "reminder_added")}");
      notifyListeners();
    }
    else{
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }


  bool isRemainderLoading = false;
  List<TypeModel> remainderTypeList = [];
  getDocType(data, url) async {
    isRemainderLoading = true;
    remainderTypeList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print("get document type --> $body");
    List<TypeModel> list;
    if (response.statusCode == 200) {
      List client = body["data"];
      list  = client.map<TypeModel>((json) => TypeModel.fromJson(json)).toList();
      remainderTypeList.addAll(list);

      isRemainderLoading = false;
      notifyListeners();

    }else{
      isRemainderLoading = false;
      notifyListeners();
      print("======= get Remainder type Error ========");
    }
  }
}