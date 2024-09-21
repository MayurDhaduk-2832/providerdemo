import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/MyNavigation/myNavigator.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/Authentication/ForgotPasswordScreen/get_code_screen.dart';
import 'package:oneqlik/screens/Authentication/LoginScreen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier{

  FirebaseMessaging messaging;
  bool isCommentLoading = false;

  loginUser(data,url,context,type,email,psd) async {
    print(data);
    Helper.dialogCall.showAlertDialog(context);
    isCommentLoading = true;
    notifyListeners();


    var response = await CallApi().postData(data,url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {

      log("Login Data $body");
      Navigator.pop(context);
      messaging = FirebaseMessaging.instance;
      var firebaseToken ;
      await messaging.getToken().then((value){
        firebaseToken = value;
        print("firebase token : $value");
      });

      SharedPreferences preferences = await SharedPreferences.getInstance();

      Map<String, dynamic> decodedToken = JwtDecoder.decode(body['token']);
      print("decoded token : $decodedToken");
      decodedToken.forEach((key, value) {
        print("key : $key" "=>" "value : $value");
      });

      preferences.setString("pass", psd);
      preferences.setString("token", body['token']);
      preferences.setBool("superAdmin", decodedToken['isSuperAdmin']);
      preferences.setString("pass", data["psd"]);
      preferences.setString("uid", decodedToken['_id']);
      preferences.setBool("isDealer", decodedToken['isDealer']);
      preferences.setString("email", decodedToken['email']);
      preferences.setString("fbToken", firebaseToken);
      preferences.setBool("remember", true);


      if(decodedToken['isSuperAdmin']==true){
        preferences.setBool("isSuperAdmin", true);
        preferences.setString("UserCredentialType", type);
        preferences.setString("AdminID", email);
        preferences.setString("AdminPass", psd);
      }
      var sendData = {
        "os": Platform.isAndroid ?
        "android_flutter" : "iso_flutter",
        "token": "$firebaseToken",
        "uid": "${decodedToken['_id']}",
        "serverToken": "AAAAjxVRKSY"
      };

      print("send token data print $sendData");
      await addFirebaseToken(sendData,"users/PushNotification");

      isCommentLoading = false;

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool("isSpeak", true);

      MyNavigator.goToDashBoard(context);
      Helper.dialogCall.showToast(context, "${getTranslated(context, "Login_Successfully")}",
      );

      notifyListeners();
    }
    else{
      isCommentLoading = false;
      Helper.dialogCall.showToast(context,body['message']);
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }

  }

  bool isTokenSuccess = false;
  addFirebaseToken(data,url) async {
    isTokenSuccess = true;
    notifyListeners();
    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);
    print("send firebase token api $body");
    if (response.statusCode == 200) {
      isTokenSuccess = false;
      notifyListeners();
    }else{
      print("addToken api error");
      isTokenSuccess = false;
      notifyListeners();
    }
  }

  bool isTokenRemove = false;
  removeFirebaseToken(data,url,context,clear) async {
    Helper.dialogCall.showAlertDialog(context);
    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);
    print("remove firebase token => $body");
    if (response.statusCode == 200) {
      if(clear){
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.clear();
        await FirebaseMessaging.instance.deleteToken();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
              (route) => false,
        );
      }else{
        Navigator.pop(context);
      }
      notifyListeners();
    }else{
      print("addToken api error");
    }
  }


  bool isForgotSuccess = false;
  var otp = "";
  forgetPassword(data,url,context) async {

    Helper.dialogCall.showAlertDialog(context);

    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print(body);
    if(response.statusCode == 200){
      isForgotSuccess = true;
      if(body["message"] == "OTP sent successfully"){
        otp = body["otp"];
        Navigator.pop(context);
        Helper.dialogCall.showToast(context,body['message']);

      }else{
        Navigator.pop(context);
      }
      notifyListeners();
    }else{
      Helper.dialogCall.showToast(context,body['message']);
      print("forgot password api error");
      Navigator.pop(context);
      notifyListeners();
    }
  }

  bool isReSetPSuccess = false;
  resetPassword(data,url,context) async {

    Helper.dialogCall.showAlertDialog(context);
    isReSetPSuccess = false;
    notifyListeners();

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    print(body);
    if(response.statusCode == 200){
      isReSetPSuccess = true;
      if(body["message"] == "OTP sent successfully"){
        Navigator.pop(context);
        Helper.dialogCall.showToast(context,body['message']);
      }else{
        Navigator.pop(context);
      }
      notifyListeners();
    }else{
      Helper.dialogCall.showToast(context,body['message']);
      isReSetPSuccess = true;
      print("forgot password api error");
      Navigator.pop(context);
      notifyListeners();
    }
  }



  bool isRegisterLoading = false;

  registerUser(data,url,context) async {
    Helper.dialogCall.showAlertDialog(context);
    isRegisterLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data, url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {

      isRegisterLoading = false;

      Navigator.pop(context);
      Navigator.pop(context);


      Helper.dialogCall.showToast(context, "${getTranslated(context, "register_Successfully")}");

      notifyListeners();
    }
    else {
      isRegisterLoading = false;
      Helper.dialogCall.showToast(context, body['message']);
      Navigator.pop(context);
      print("Register Post Api Error !!");
      notifyListeners();
    }
  }

}