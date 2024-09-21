import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/contact_model.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactUsProvider with ChangeNotifier {

  List<ContactUsModel> contactUsList = [];
  bool isContactLoading = false;


  getContactUs(data, url) async {
    isContactLoading = true;
    contactUsList.clear();
    notifyListeners();

    List<ContactUsModel> list;


    var response = await CallApi().getDataAsParamsSocket(data, url);
    var body = json.decode(response.body);

    print("get customer issue:$body");

    if (response.statusCode == 200) {
      var result = body;

      List client = result as List;
      list = client.map<ContactUsModel>((json) =>
          ContactUsModel.fromJson(json)).toList();

      contactUsList.addAll(list);

      isContactLoading = false;
      notifyListeners();
    }
    else {
      isContactLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }


  addContact(data,url,context) async {

    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postSocket(data,url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");
      var fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
      var toDate = DateTime.now().toUtc().toString();

      var data = {
        "user":id,
        "from":fromDate,
        "to":toDate,
      };

      getContactUs(data, "customer_support/getCustomerIssues");



      Navigator.pop(context,"refresh");
      Navigator.pop(context,"refresh");
      Helper.dialogCall.showToast(context, "${getTranslated(context, "your_req_added")}",);
      notifyListeners();
    }
    else{
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }


  // List<ContactCountModel> contactCountList = [];

  var body;
  bool isContactCountLoading = false;

  contactCount(data, url) async {
    isContactCountLoading = true;
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data, url);
    var mainBody = json.decode(response.body);

    print("contact count:$mainBody");

    if (response.statusCode == 200) {
       body = mainBody;

      isContactCountLoading = false;
      notifyListeners();
    }
    else {
      isContactCountLoading = false;
      print("Contact Count Api Error !!");
      notifyListeners();
    }
  }
}