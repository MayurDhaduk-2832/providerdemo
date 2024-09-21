

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/expenses_list_model.dart';
import 'package:oneqlik/Model/trip_detail_type_model.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/TypeModel.dart';

class ExpensesProvider with ChangeNotifier{

  bool isExpensesListLoading = false;
  var totalExpanse = 0;
  List<Expenseobj> getExpensesLists = [];
  expensesLists(data,url) async {


    isExpensesListLoading = true;
    totalExpanse = 0;
    notifyListeners();

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    print("expenses => $body");

    if (response.statusCode == 200) {

      var response = GetExpensesListModel.fromJson(body);
      getExpensesLists = response.expenseobj;

      for(int i=0; i<getExpensesLists.length; i++){
        totalExpanse = totalExpanse + getExpensesLists[i].total;
      }
      isExpensesListLoading = false;
      notifyListeners();

    }
    else{
      isExpensesListLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }

  }


  bool isaddExpensesLoading = false;
  var chooseExpenseType;
  var chooseCurrency;
  var choosePaymentMode;
  addExpense(data,url,context) async {

    Helper.dialogCall.showAlertDialog(context);
    isaddExpensesLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data,url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {
      isaddExpensesLoading = false;

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      var id = sharedPreferences.getString("uid");

      var fromDate = DateTime.now().subtract(Duration(days: 1)).toString();
      var toDate = DateTime.now().toString();

      var data = {
        "user": id,
        "fdate": fromDate,
        "tdate": toDate,
      };


      expensesLists(data,"expense/expensebycateogry");
      Helper.dialogCall.showToast(context, "${getTranslated(context, "expenses_add_successfully")}");

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      notifyListeners();
    }
    else{
      isaddExpensesLoading = false;
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }

  }


  List<TripDetailTypeModel> tripDetailTypeList = [];
  bool isTripTypeLoading = false;
  tripDetailType(data, url,context) async {

    isTripTypeLoading = true;
    tripDetailTypeList.clear();
    notifyListeners();

    List<TripDetailTypeModel> list;

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    print("body-->$body");

    if (response.statusCode == 200) {

      var result = body;

      List client = result as List;
      list = client.map<TripDetailTypeModel>((json) =>
          TripDetailTypeModel.fromJson(json)).toList();
      tripDetailTypeList.addAll(list);

      isTripTypeLoading = false;

      notifyListeners();
    }
    else {
      isTripTypeLoading = false;
      print("Trip Detail Api Error !!");
      notifyListeners();
    }
  }


  bool isExpensesLoading = false;
  List<TypeModel> expensesTypeList = [];
  getExpensesType(data, url) async {
    isExpensesLoading = true;
    expensesTypeList.clear();
    notifyListeners();

    var response = await CallApi().getDataAsParamsSocket(data,url);
    var body = json.decode(response.body);

    print("get document type --> $body");
    List<TypeModel> list;
    if (response.statusCode == 200) {
      List client = body["data"];
      list  = client.map<TypeModel>((json) => TypeModel.fromJson(json)).toList();
      expensesTypeList.addAll(list);

      isExpensesLoading = false;
      notifyListeners();

    }else{
      isExpensesLoading = false;
      notifyListeners();
      print("======= get Remainder type Error ========");
    }
  }
}