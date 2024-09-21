import 'dart:convert';
import 'dart:developer';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/userModel.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/Authentication/LoginScreen/login_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/get_user_settings_model.dart';
import '../screens/DashBoardScreen/VehicleListPages/vehicle_list.dart';
import '../screens/DashBoardScreen/dashboard_screen.dart';
import '../utils/colors.dart';

class UserProvider with ChangeNotifier {
  var workingHoursValue;
  var timeZoneValue;
  FlutterTts flutterTts = FlutterTts();

  bool isLoading = false;
  UseModel useModel;
  var userImage = "";
  bool isSpeak = true;

  Future<void> _speak() async {
    print(useModel.cust.firstName + useModel.cust.lastName);
    String textToRead =
        "Welcome ${useModel.cust.firstName + useModel.cust.lastName}.";

    await flutterTts.setLanguage("en-US"); // Set the language (locale)
    await flutterTts.setSpeechRate(0.5); // Set speech rate
    await flutterTts.setVolume(1.0); // Set volume
    await flutterTts.speak(textToRead); // Start speaking
  }

  getUserData(data, url, context) async {
    isLoading = true;
    userImage = "";
    notifyListeners();

    var response = await CallApi().getDataAsParams(data, url);
    var body = json.decode(response.body);

    log("user Data ---> $body");
    if (response.statusCode == 200) {
      useModel = UseModel.fromJson(body);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      isSpeak = sharedPreferences.getBool("isSpeak");

      if (isSpeak) {
        sharedPreferences.setBool("isSpeak", false);
        isSpeak = false;
        _speak();
      }

      print(useModel.cust.engineCutPsd);

      if (useModel.cust.imageDoc.isNotEmpty) {
        var data1 = useModel.cust.imageDoc[0].toString().split("/");

        for (int i = 1; i < data1.length; i++) {
          userImage = "$userImage" + "/" + data1[i];
        }
      }

      SharedPreferences preferences = await SharedPreferences.getInstance();

      if (useModel.cust.pass != preferences.getString("pass")) {
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false,
        );
      } else {}

      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  bool isUpdating = false;

  updateUserData(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isUpdating = true;
    notifyListeners();

    var response = await CallApi().postSocket(data, url);
    var body = json.decode(response.body);

    print("user Data --> $body");

    if (response.statusCode == 200) {
      isUpdating = false;

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");
      var data = {
        "uid": id,
      };

      getUserData(data, "users/getCustumerDetail", context);

      Navigator.pop(context);

      notifyListeners();
    } else {
      isUpdating = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  updateNotification(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isUpdating = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    // print("user Data --> $body");
    if (response.statusCode == 200) {
      isUpdating = false;

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");
      var data = {
        "uid": id,
      };

      getUserData(data, "users/getCustumerDetail", context);

      Helper.dialogCall.showToast(
          context, "${getTranslated(context, "notification_updated")}");
      Navigator.pop(context);
      notifyListeners();
    } else {
      isUpdating = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  var chooseMeasureType;
  bool isUserSetingsLoading = false;
  bool isSuccess = false;
  bool isSetLoading = false;
  GetUserSettingsModel getUserSettingsModel;

  getUserSettings(data, url, context) async {
    isUserSetingsLoading = true;
    isSuccess = false;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("body get user setting -->$body");

    if (response.statusCode == 200) {
      getUserSettingsModel = GetUserSettingsModel.fromJson(body);
      isUserSetingsLoading = false;
      isSuccess = true;
      notifyListeners();
    } else {
      isUserSetingsLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  setUserSettings(data, url, context) async {
    isSetLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("Settingupdate-->$body");

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");
      var data = {
        "uid": id,
      };

      getUserData(data, "users/getCustumerDetail", context);

      isSetLoading = false;
      notifyListeners();
    } else {
      isSetLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  int index = 0;

  changeBottomIndex(int bottomIndex) {
    index = bottomIndex;
    notifyListeners();
  }

  navigateToThirdScreen() {
    index = 2;
    notifyListeners();
  }

  uploadNewImage(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("user Data --> $body");

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");
      var data = {
        "uid": id,
      };

      getUserData(data, "users/getCustumerDetail", context);

      Helper.dialogCall.showToast(context, "Image Updated");
      Navigator.pop(context);
      Navigator.pop(context);

      notifyListeners();
    } else {
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  bool isSetImmobilizeLoading = false;

  setImmobilizePwd(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    isSetImmobilizeLoading = true;
    notifyListeners();

    var response = await CallApi().postSocket(data, url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");
      var data = {
        "uid": id,
      };

      await getUserData(data, "users/getCustumerDetail", context);

      isSetImmobilizeLoading = false;

      Navigator.of(context).pop();
      Navigator.of(context).pop();

      notifyListeners();
    } else {
      isSetImmobilizeLoading = false;
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }

  sharedApi(data, url, context, vehicleName) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    print("user Data --> $body");

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);

      Share.share(
        '${useModel.cust.firstName} ${useModel.cust.lastName} has shared $vehicleName live trip with you. Please follow below link to track https://www.oneqlik.in/share/liveShare?t=${body['t']}',
      );
      notifyListeners();
    } else {
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }
}
