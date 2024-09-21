 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Model/get_notify_filter_model.dart';

class NotificationsProvider with ChangeNotifier {

  List<GetNotifyFilterModel> notifyFilterList = [];
  bool isGetNotifyFilterLoading = false;

  getNotificationsDetail(data, url,context) async {

    isGetNotifyFilterLoading = true;
    notifyFilterList.clear();
    notifyListeners();

    List<GetNotifyFilterModel> list;

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);


    print("body-->$body");


    if (response.statusCode == 200) {

      var result = body;

      List client = result as List;
      list = client.map<GetNotifyFilterModel>((json) =>
          GetNotifyFilterModel.fromJson(json)).toList();
      notifyFilterList.addAll(list);

      isGetNotifyFilterLoading = false;

      notifyListeners();
    }
    else {
      isGetNotifyFilterLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }
  }
}