import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Model/command_queue_model.dart';
import 'package:oneqlik/Model/device_alert_model.dart';
import 'package:oneqlik/Model/device_expiring_model.dart';
import 'package:oneqlik/Model/get_document_model.dart';
import 'package:oneqlik/Model/stoppage_logs_model.dart';
import 'package:oneqlik/Model/vehicle_list_model.dart';
import 'package:oneqlik/MyNavigation/myNavigator.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/TypeModel.dart';

class VehicleListProvider with ChangeNotifier {
  bool isCommentLoading = false;
  bool isVehicleLoading = false;
  List<VehicleLisDevice> vehicleList = [];
  List addressList = [];
  bool isSucces = false;
  int i = 0;
  VehicleListModel vehicleListModel;
  List<DeviceExpiringModel> deviceExpiringList2 = [];
  List<dynamic> deviceExpiringList;
  String msgValidateIDPass = '';

  Future<String> getValidateIDPass(data, url, context) async {
    var response = await CallApi().postData(data, url);

    var body = json.decode(response.body);

    print(response.statusCode);
    print("getVerifiedLoginIDPass:------------$body");
    msgValidateIDPass = body['message'];

    if (msgValidateIDPass != 'Valid') {
      MyNavigator.goToLoginPage(context);
    }
    if (response.statusCode == 200) {
    } else {
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  Future<String> getDeviceExpiring(data, url, context) async {
    var response = await CallApi().postData(data, url);

    var body = json.decode(response.body);

    print(response.statusCode);
    print("getDeviceExpiring:------------$body");

    if (response.statusCode == 200) {
      deviceExpiringList = body;
      print(deviceExpiringList);
      // deviceExpiringList.forEach((element) {
      //   var response = DeviceExpiringModel.fromJson(element);
      //   deviceExpiringList2.add(response);
      // });
      // print(deviceExpiringList2);
    } else {
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  Future<String> getVehicleList(data, url, pageName) async {
    isCommentLoading = true;
    isSucces = true;
    i = 0;
    if (isVehicleLoading == false) {
      vehicleList.clear();
      addressList.clear();
    }
    notifyListeners();

    var response = await CallApi().getDataAsParams(data, url);

    var body = json.decode(response.body);

    print(response.statusCode);
    log("getVehicleList:------------$body");

    if (response.statusCode == 200) {
      var response = VehicleListModel.fromJson(body);
      vehicleListModel = response;

      vehicleList.addAll(response.devices);

      listExpand = List<bool>.filled(vehicleList.length, false);

      if (pageName == "vehicle") {
        for (i = 0; i < vehicleList.length; i++) {
          if (vehicleList[i].lastLocation != null) {
            var data = {
              "lat": vehicleList[i].lastLocation.lat,
              "long": vehicleList[i].lastLocation.long
            };

            /* var response = await CallApi().postData(data,"googleAddress/getGoogleAddress");

            var body = json.decode(response.body);
            print("address is:$body");
            if(body["message"] == "Address not found in database"){
              //addressList.add(body["message"]);
              addressList.add("Address not found...............");
            }else{
              if(body["address"]=="NA")
                {
                  addressList.add("Address not found...........");
                }
              else {
                addressList.add(body["address"]);
              }
            }*/

            /*  List<Placemark> placemarks = await placemarkFromCoordinates(vehicleList[i].lastLocation.lat, vehicleList[i].lastLocation.long).
            catchError((e){
              addressList.add("Address Not Found");
            });

              addressList.add(
                "${placemarks.first.name}"
                    " ${placemarks.first.subLocality}"
                    " ${placemarks.first.locality}"
                    " ${placemarks.first.subAdministrativeArea} "
                    "${placemarks.first.administrativeArea},"
                    "${placemarks.first.postalCode}",

              );
            */
          } else {
            addressList.add("Address Not Found");
          }
        }
      } else {}

      if (pageName == "live") {
        isCommentLoading = false;
        changeBool(true);
        isSucces = false;
        notifyListeners();
      } else {
        if (i == vehicleList.length) {
          isCommentLoading = false;
          changeBool(true);
          isSucces = false;
          notifyListeners();
        }
      }
    } else {
      isCommentLoading = false;
      isSucces = false;
      print("Comment Post Api Error !!");
      changeBool(true);
      notifyListeners();
    }
  }

  bool isUpdateDeviceLoading = false;

  updateDeviceSettings(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isUpdateDeviceLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      isUpdateDeviceLoading = false;

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var id = sharedPreferences.getString("uid");
      var email = sharedPreferences.getString("email");

      var data = {
        "id": id,
        "email": email,
        "skip": "0",
        "limit": "8",
        "statuss": "",
        "search": "",
      };

      vehicleList.clear();
      addressList.clear();
      print(data);
      getVehicleList(data, "devices/getDeviceByUserMobile", "vehicle");

      Navigator.of(context).pop("refresh");
      Navigator.of(context).pop("refresh");
      Navigator.of(context).pop("refresh");

      notifyListeners();
    } else {
      isUpdateDeviceLoading = false;
      Navigator.pop(context);
      print("Device Settings Api Error !!");
      notifyListeners();
    }
  }

  changeBool(bool value) {
    isVehicleLoading = value;
    notifyListeners();
  }

  List<bool> listExpand;

  changeBoolIndex(bool value, int index) {
    listExpand[index] = value;
    notifyListeners();
  }

  bool uploadSucess = false;

  uploadDoc(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();
    var response = await CallApi().postSocket(data, url);
    var body = json.decode(response.body);

    print(body);
    if (response.statusCode == 200) {
      uploadSucess = true;
      Navigator.pop(context, "refresh");
      Navigator.pop(context, "refresh");
      Helper.dialogCall.showToast(context, body["message"]);
      notifyListeners();
    } else {
      Helper.dialogCall.showToast(context, body["message"]);
      Navigator.pop(context);
      uploadSucess = true;
      print("Upload Document Api Error !!");
      notifyListeners();
    }
  }

  updateDocument(data, url, context, id) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postSocket(data, url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      var data = {
        "device": "$id",
      };

      await getAllDocument(data, "document/get");

      Navigator.pop(context);
      Navigator.pop(context);
      Helper.dialogCall.showToast(context, body["message"]);
      notifyListeners();
    } else {
      Helper.dialogCall.showToast(context, body["message"]);
      Navigator.pop(context);
      print("Update Document Api Error !!");
      notifyListeners();
    }
  }

  deleteDocument(data, url, context, id) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postSocket(data, url);

    print('res${response.body}');

    if (response.statusCode == 200) {
      var data = {
        "device": "$id",
      };

      print("data tion si $data");
      await getAllDocument(data, "document/get");

      Helper.dialogCall.showToast(context,
          "${getTranslated(context, "document_deleted_successfully")}");

      Navigator.of(context).pop();
      Navigator.of(context).pop();

      notifyListeners();
    } else {
      print("delete document Api Error !!");
      notifyListeners();
    }
  }

  bool isStoppageLogsLoading = false;

  // List startAddressStopLogsList = [];
  List endAddressStopLogsList = [];
  StoppageLogsModel stoppageLogsModel;

  getStoppageLogs(data, url, context) async {
    isStoppageLogsLoading = true;
    endAddressStopLogsList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParams(data, url);
    var body = json.decode(response.body);

    print("Bottom Table body-->$body");

    if (response.statusCode == 200) {
      stoppageLogsModel = StoppageLogsModel.fromJson(body);

      for (int i = 0; i < stoppageLogsModel.result.length; i++) {
        if (stoppageLogsModel.result[i].type == "STOPPAGE") {
          if (stoppageLogsModel.result[i].endLat != null &&
              stoppageLogsModel.result[i].endLong != null) {
            print(stoppageLogsModel.result[i].endLat);
            print(stoppageLogsModel.result[i].endLong);

            List<Placemark> placemarks = await placemarkFromCoordinates(
              double.parse("${stoppageLogsModel.result[i].endLat}"),
              double.parse("${stoppageLogsModel.result[i].endLong}"),
            ).catchError((onError) {
              endAddressStopLogsList.add("Address not found");
            });

            endAddressStopLogsList.add(
              "${placemarks.first.name}"
              " ${placemarks.first.subLocality}"
              " ${placemarks.first.locality}"
              " ${placemarks.first.subAdministrativeArea} "
              "${placemarks.first.administrativeArea}"
              "${placemarks.first.postalCode}",
            );
          } else {
            endAddressStopLogsList.add("Address not found");
          }
        } else {
          endAddressStopLogsList.add("");
        }
      }

      isStoppageLogsLoading = false;

      notifyListeners();
    } else {
      isStoppageLogsLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  bool isDocLoading = false;
  GetAllDocumentModel getAllDocumentModel;

  getAllDocument(data, url) async {
    isDocLoading = true;
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    print("get document --> $body");

    if (response.statusCode == 200) {
      getAllDocumentModel = GetAllDocumentModel.fromJson(body);
      isDocLoading = false;
      notifyListeners();
    } else {
      isDocLoading = false;
      notifyListeners();
    }
  }

  bool isupdateParkingLoading = false;
  bool vehicleParking = false;

  parkingScheduler(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isupdateParkingLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("parking->body-->$body");

    if (response.statusCode == 200) {
      isupdateParkingLoading = false;

      Navigator.of(context).pop();

      notifyListeners();
    } else {
      isupdateParkingLoading = false;
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  bool isupdateTowLoading = false;
  bool towAlert = false;

  towScheduler(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isupdateTowLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      isupdateTowLoading = false;

      Navigator.of(context).pop();

      notifyListeners();
    } else {
      isupdateTowLoading = false;
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  bool isCustomApi = false;
  bool isCustomSuccess = false;
  var body;

  customApi(data, url, context) async {
    isCustomApi = true;
    isCustomSuccess = false;
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);

    if (response.statusCode == 200) {
      if (response.body != '') {
        var mainbody = json.decode(response.body);
        print("body-fg->$mainbody");
        print("body-fg-222>$mainbody");

        body = mainbody;
      }

      isCustomApi = false;
      isCustomSuccess = true;

      notifyListeners();
    } else {
      isCustomApi = false;
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  bool isProtocolLoading = false;
  bool isProtocolSuccess = false;
  var protocolBody;

  getProtocol(data, url, context) async {
    isProtocolLoading = true;
    isProtocolSuccess = false;
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    print("protocolBody-->$body");

    if (response.statusCode == 200) {
      protocolBody = body;

      isProtocolLoading = false;
      isProtocolSuccess = true;

      notifyListeners();
    } else {
      isProtocolLoading = false;
      print("protocol Api Error !!");
      notifyListeners();
    }
  }

  addCommandApi(data, url, context, id, imei) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("body-->$body");
    print(response.statusCode);

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");

      var data = {
        "user": "$id",
        "id": id,
        "fields": "ignitionLock",
      };

      var data2 = {
        "imei": "$imei",
      };

      customApi(data, "devices/getDeviceCustomApi", context);
      getCommandQueue(data2, "devices/getCommandQueue");
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      notifyListeners();
    } else {
      Navigator.pop(context);
      print("add Command Api  Api Error !!");
      notifyListeners();
    }
  }

  List<CommandQueueModel> getCommandQueueList = [];
  bool isCommandQueueLoading = false;

  getCommandQueue(data, url) async {
    isCommandQueueLoading = true;
    getCommandQueueList.clear();
    notifyListeners();

    List<CommandQueueModel> list = [];

    var response = await CallApi().getDataAsParams(data, url);
    var body = json.decode(response.body);

    print("get Command Queue ==> $body");

    if (response.statusCode == 200) {
      var result = body;
      List client = result as List;
      list = client
          .map<CommandQueueModel>((json) => CommandQueueModel.fromJson(json))
          .toList();
      getCommandQueueList.addAll(list);

      isCommandQueueLoading = false;
      notifyListeners();
    } else {
      isCommandQueueLoading = false;
      print("Command Queue api error!!");
      notifyListeners();
    }
  }

  bool isDocTypeLoading = false;
  List<TypeModel> docTypeList = [];

  getDocType(data, url) async {
    isDocTypeLoading = true;
    docTypeList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    print("get document type --> $body");
    List<TypeModel> list;
    if (response.statusCode == 200) {
      List client = body["data"];
      list = client.map<TypeModel>((json) => TypeModel.fromJson(json)).toList();
      docTypeList.addAll(list);

      isDocTypeLoading = false;
      notifyListeners();
    } else {
      isDocTypeLoading = false;
      notifyListeners();
      print("======= get document type Error ========");
    }
  }
}
