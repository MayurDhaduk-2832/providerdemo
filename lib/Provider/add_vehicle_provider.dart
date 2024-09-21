import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/select_dealer_model.dart';
import 'package:oneqlik/Model/select_user_model.dart';
import 'package:oneqlik/Model/vehicalModel.dart';
import 'package:oneqlik/Model/vehicle_type_model.dart';
import 'package:oneqlik/local/localization/language_constants.dart';

class AddVehicleProvider with ChangeNotifier {
  // List <VehicleModels> searchDeviceModel = [];

  List<VehicleModels> vehicleModelList = [];
  List<VehicleModels> searchModelList = [];
  bool isVehicleModelLoading = false;
  bool isModelSuccess = false;

  getVehicleModel(url) async {
    isVehicleModelLoading = true;
    vehicleModelList.clear();
    notifyListeners();

    List<VehicleModels> list;

    var response = await CallApi().getAsParams(url);
    var body = json.decode(response.body);

    print(body);

    if (response.statusCode == 200) {
      var result = body;

      List client = result as List;
      list = client
          .map<VehicleModels>((json) => VehicleModels.fromJson(json))
          .toList();

      vehicleModelList.addAll(list);

      listOfDeviceModelValue =
          List<bool>.filled(vehicleModelList.length, false);
      isVehicleModelLoading = false;
      searchModelList = vehicleModelList;
      isModelSuccess = true;
      notifyListeners();
    } else {
      isVehicleModelLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  List<bool> listOfDeviceModelValue = [];

  changeVehicleBool(int index) {
    listOfDeviceModelValue = List<bool>.filled(vehicleModelList.length, false);
    listOfDeviceModelValue[index] = true;
    notifyListeners();
  }

  List<VehicleTypeModel> vehicleTypeList = [];
  List<VehicleTypeModel> searchVehicleModelList = [];
  bool vehicleTypeLoading = false;
  List<bool> typeSelected = [];
  bool searchVehicleModel = false;
  getVehicleType(data, url) async {
    vehicleTypeLoading = true;
    vehicleTypeList.clear();
    notifyListeners();

    List<VehicleTypeModel> list;

    var response = await CallApi().getDataAsParams(data, url);
    var body = json.decode(response.body);

    print(body);

    if (response.statusCode == 200) {
      var result = body;

      List client = result as List;
      list = client
          .map<VehicleTypeModel>((json) => VehicleTypeModel.fromJson(json))
          .toList();

      vehicleTypeList.addAll(list);

      typeSelected = List<bool>.filled(vehicleTypeList.length, false);

      vehicleTypeLoading = false;
      searchVehicleModelList = vehicleTypeList;
      searchVehicleModel = true;
      notifyListeners();
    } else {
      vehicleTypeLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  changeVehicleType(int index) {
    typeSelected[index] = true;
    notifyListeners();
  }

  List<SelectUserModel> getSelectUserList = [];
  List<SelectUserModel> searchUserModelList = [];
  bool selectUserTypeLoading = false;
  List<bool> typeSelectedUser = [];
  bool isUserModelSuccess = false;
  getSelectUserType(data, url) async {
    selectUserTypeLoading = true;
    getSelectUserList.clear();
    notifyListeners();

    List<SelectUserModel> list;

    var response = await CallApi().getDataAsParams(data, url);
    var body = json.decode(response.body);

    print(body);

    if (response.statusCode == 200) {
      var result = body;

      List client = result as List;
      list = client
          .map<SelectUserModel>((json) => SelectUserModel.fromJson(json))
          .toList();

      getSelectUserList.addAll(list);

      typeSelectedUser = List<bool>.filled(getSelectUserList.length, false);
      selectUserTypeLoading = false;
      searchUserModelList = getSelectUserList;
      isUserModelSuccess = true;
      print(typeSelectedUser);
      print("called");
      notifyListeners();
    } else {
      selectUserTypeLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  changeSelectUserType(int index) {
    typeSelectedUser = List<bool>.filled(getSelectUserList.length, false);
    typeSelectedUser[index] = true;
    notifyListeners();
  }

  List<SelectDealerModel> getSelectDealerList = [];
  List<SelectDealerModel> searchDealerModelList = [];
  bool selectDealerTypeLoading = false;
  List<bool> typeSelectedDealer = [];
  bool isDealerModelSuccess = false;
  getSelectDealer(data, url) async {
    selectDealerTypeLoading = true;
    getSelectDealerList.clear();
    notifyListeners();

    List<SelectDealerModel> list;

    var response = await CallApi().getDataAsParams(data, url);
    var body = json.decode(response.body);

    print(body);

    if (response.statusCode == 200) {
      var result = body;

      List client = result as List;
      list = client
          .map<SelectDealerModel>((json) => SelectDealerModel.fromJson(json))
          .toList();

      getSelectDealerList.addAll(list);

      typeSelectedDealer = List<bool>.filled(getSelectDealerList.length, false);

      selectDealerTypeLoading = false;
      searchDealerModelList = getSelectDealerList;
      isDealerModelSuccess = true;
      notifyListeners();
    } else {
      selectDealerTypeLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  changeSelectDealerType(int index) {
    typeSelectedDealer = List<bool>.filled(getSelectDealerList.length, false);
    typeSelectedDealer[index] = true;
    notifyListeners();
  }

  bool isaddVehicleLoading = false;

  addVehicle(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isaddVehicleLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      isaddVehicleLoading = false;

      Navigator.pop(context);
      Navigator.pop(context);
      Helper.dialogCall.showToast(
          context, "${getTranslated(context, "device_add_successfully")}");

      notifyListeners();
    } else if (response.statusCode == 400) {
      Navigator.pop(context);

      Helper.dialogCall.showToast(
          context, "${getTranslated(context, "imei_exist_already")}");
    } else {
      isaddVehicleLoading = false;
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  updateVehicle(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    // isaddVehicleLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      // isaddVehicleLoading = false;

      Navigator.pop(context);
      Helper.dialogCall.showToast(
          context, "${getTranslated(context, "device_update_successfully")}");
      notifyListeners();
      Navigator.pop(context, true);
    } else if (response.statusCode == 400) {
      Navigator.pop(context);

      Helper.dialogCall.showToast(
          context, "${getTranslated(context, "imei_exist_already")}");
    } else {
      // isaddVehicleLoading = false;
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }
}
