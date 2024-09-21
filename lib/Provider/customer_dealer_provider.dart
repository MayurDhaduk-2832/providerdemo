import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/CustomerModel.dart';
import 'package:oneqlik/Model/DealerModel.dart';
import 'package:oneqlik/Model/vehicle_maintenance_model.dart';
import 'package:oneqlik/MyNavigation/myNavigator.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDealerProvider with ChangeNotifier {
  List<CustomerModel> customerList = [];
  bool isCustomerLoading = false;
  bool isPageLoading = false;
  bool isSucces = false;
  FirebaseMessaging messaging;
  bool isCommentLoading = false;

  loginUser(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isCommentLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      await clearLocalInfo();
      log("Login Data $body");
      Navigator.pop(context);
      messaging = FirebaseMessaging.instance;
      var firebaseToken;
      await messaging.getToken().then((value) {
        firebaseToken = value;
        print("firebase token : $value");
      });

      SharedPreferences preferences = await SharedPreferences.getInstance();

      Map<String, dynamic> decodedToken = JwtDecoder.decode(body['token']);
      decodedToken.forEach((key, value) {
        print("key : $key" "=>" "value : $value");
      });
      preferences.setString("token", body['token']);
      preferences.setBool("superAdmin", decodedToken['isSuperAdmin']);
      preferences.setBool("isDealer", decodedToken['isDealer']);
      preferences.setString("pass", data["psd"]);
      preferences.setString("uid", decodedToken['_id']);
      preferences.setString("email", decodedToken['email']);
      preferences.setString("fbToken", firebaseToken);
      preferences.setBool("remember", true);
      var sendData = {
        "os": Platform.isAndroid ? "android_flutter" : "iso_flutter",
        "token": "$firebaseToken",
        "uid": "${decodedToken['_id']}",
        "serverToken": "AAAAjxVRKSY"
      };

      print("send token data print $sendData");
      await addFirebaseToken(sendData, "users/PushNotification");

      isCommentLoading = false;

      MyNavigator.goToDashBoard(context);
      Helper.dialogCall.showToast(
        context,
        "${getTranslated(context, "Login_Successfully")}",
      );

      notifyListeners();
    } else {
      isCommentLoading = false;
      Helper.dialogCall.showToast(context, body['message']);
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  Future<void> clearLocalInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var token = sharedPreferences.getString("fbToken");
    var id = sharedPreferences.getString("uid");

    var sendData = {
      "os": Platform.isAndroid ? "android_flutter" : "iso_flutter",
      "token": "$token",
      "uid": "$id"
    };
    var response = await CallApi().postData(sendData, "users/PullNotification");
    var body = json.decode(response.body);
    print("remove firebase token => $body");
    if (response.statusCode == 200) {
      await FirebaseMessaging.instance.deleteToken();
    }
  }

  addFirebaseToken(data, url) async {
    notifyListeners();
    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);
    print("send firebase token api $body");
    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      print("addToken api error");
      notifyListeners();
    }
  }

  getCustomer(data, url) async {
    isCustomerLoading = true;
    isSucces = true;
    notifyListeners();

    List<CustomerModel> list;

    var response = await CallApi().getDataAsParams(data, url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      var result = body;
      print(body);

      List client = result as List;
      list = client
          .map<CustomerModel>((json) => CustomerModel.fromJson(json))
          .toList();
      customerList.addAll(list);
      isCustomerLoading = false;
      isSucces = false;
      changePageBool(true);
      notifyListeners();
    } else {
      isCustomerLoading = false;
      changePageBool(true);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  changePageBool(bool value) {
    isPageLoading = value;
    notifyListeners();
  }

  changeDPageBool(bool value) {
    isDPageLoading = value;
    notifyListeners();
  }

  List<DealerModel> dealerList = [];
  bool isDealerLoading = false;
  bool isDPageLoading = false;
  bool isSucces1 = false;

  getDealer(data, url) async {
    isDealerLoading = true;
    isSucces1 = true;
    notifyListeners();

    List<DealerModel> list;

    var response = await CallApi().getDataAsParams(data, url);
    var body = json.decode(response.body);
    print("$body");

    if (response.statusCode == 200) {
      isDealerLoading = false;
      changeDPageBool(true);
      isSucces1 = false;
      var result = body;

      List client = result as List;
      list = client
          .map<DealerModel>((json) => DealerModel.fromJson(json))
          .toList();
      dealerList.addAll(list);

      notifyListeners();
    } else {
      isDealerLoading = false;
      changeDPageBool(true);
      isSucces1 = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  addDealer(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      isDealerLoading = false;
      dealerList.clear();
      Navigator.pop(context);
      Navigator.pop(context);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");
      var data = {
        "supAdmin": id,
        "pageNo": "1",
        "size": "8",
      };

      await getDealer(data, "users/getDealers");

      Helper.dialogCall.showToast(context, body['message']);
      notifyListeners();
    } else {
      Helper.dialogCall.showToast(context, body['message']);
      //  Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  deleteDealer(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);

    if (response.statusCode == 200) {
      isDealerLoading = false;
      dealerList.clear();
      Navigator.pop(context);
      Navigator.pop(context);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");
      var data = {
        "supAdmin": id,
        "pageNo": "1",
        "size": "8",
      };

      await getDealer(data, "users/getDealers");

      Helper.dialogCall.showToast(
          context, "${getTranslated(context, "deleted_dealers_successfully")}");
      notifyListeners();
    } else {
      Helper.dialogCall
          .showToast(context, "${getTranslated(context, "something_wrong")}");
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  deleteCustomer(data, url, context, bool) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);

    if (response.statusCode == 200) {
      isDealerLoading = false;
      Navigator.pop(context);
      Navigator.pop(context);
      customerList.clear();

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");
      var data = {"uid": id, "pageNo": "1", "size": "8", "all": "$bool"};
      await getCustomer(data, "users/getCustomer");

      Helper.dialogCall.showToast(
          context, "${getTranslated(context, "deleted_dealers_successfully")}");
      notifyListeners();
    } else {
      Helper.dialogCall
          .showToast(context, "${getTranslated(context, "something_wrong")}");
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  var chooseDealers;

  addCustomer(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      isCustomerLoading = false;
      customerList.clear();
      Navigator.pop(context);
      Navigator.pop(context);

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");

      var data = {
        "uid": id,
        "pageNo": "1",
        "size": "8",
      };

      getCustomer(data, "users/getCustomer");

      Helper.dialogCall.showToast(context, body['message']);
      notifyListeners();
    } else {
      Helper.dialogCall.showToast(context, body['message']);
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  bool editCustomerLoading = false;

  editCustomer(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      editCustomerLoading = false;
      customerList.clear();

      Navigator.pop(context);
      Navigator.pop(context);

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");

      var data = {
        "uid": id,
        "pageNo": "1",
        "size": "8",
      };

      getCustomer(data, "users/getCustomer");

      Helper.dialogCall.showToast(context, body['message']);
      notifyListeners();
    } else {
      Helper.dialogCall.showToast(context, body['message']);
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  bool editDealerLoading = false;

  editDealers(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      editDealerLoading = false;
      dealerList.clear();

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");

      var data = {
        "supAdmin": id,
        "pageNo": "1",
        "size": "8",
      };

      await getDealer(data, "users/getDealers");

      Navigator.pop(context);
      Navigator.pop(context);

      Helper.dialogCall.showToast(context, body['message']);
      notifyListeners();
    } else {
      Helper.dialogCall.showToast(context, body['message']);
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  showLogoutDialog(BuildContext context, data, url, name) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ApplicationColors.blackColor2E,
        title: Text(
          "${getTranslated(context, "are_you_sure")}",
          style: Textstyle1.text12b,
        ),
        content: Text(
          "${getTranslated(context, "do_want_to_login")} $name",
          style: Textstyle1.text12b,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              "${getTranslated(context, "no")}",
              style: Textstyle1.text12b,
            ),
          ),
          TextButton(
            onPressed: () async {
              await loginUser(data, url, context);
            },
            child: Text(
              "${getTranslated(context, "yes")}",
              style: Textstyle1.text12b,
            ),
          ),
        ],
      ),
    );
  }
}
