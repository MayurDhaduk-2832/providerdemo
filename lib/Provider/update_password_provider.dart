

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';

class UpdatePasswordProvider with ChangeNotifier{

  bool isupdatePasswordLoading = false;

  updatePassword(data,url,context) async {

    Helper.dialogCall.showAlertDialog(context);
    isupdatePasswordLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data,url);
    var body = json.decode(response.body);

    print("body-->$body");


    if (response.statusCode == 200) {
      isupdatePasswordLoading = false;

      Navigator.of(context).pop();

      notifyListeners();
    }
    else{
      isupdatePasswordLoading = false;
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }

  }

}