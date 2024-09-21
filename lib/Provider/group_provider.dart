import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/get_group_details_model.dart';
import 'package:oneqlik/Model/getfuel_price_model.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetGroupListProvider with ChangeNotifier{

  bool isGroupDetailLoading = false;

  List<GroupDetail> getGroupDetailList = [];

  getGroupDetailsList(data,url) async {


    isGroupDetailLoading = true;
    notifyListeners();

    var response = await CallApi().getDataAsParams(data,url);
    var body = json.decode(response.body);

    print("GroupDetails-->${body}");

    if (response.statusCode == 200) {
      var response = GetGroupListModel.fromJson(body);
      getGroupDetailList = response.groupDetails;

      isGroupDetailLoading = false;
      notifyListeners();
    }
    else{
      isGroupDetailLoading = false;
      print("Comment Post Api Error !!");
      notifyListeners();
    }

  }

  bool isaddGroupLoading = false;


  addGroup(data,url,context) async {


    Helper.dialogCall.showAlertDialog(context);
    isaddGroupLoading = true;
    notifyListeners();

    var response = await CallApi().postData(data,url);
    var body = json.decode(response.body);

    print("response-->$response");

    if (response.statusCode == 200) {
      isaddGroupLoading = false;

      Navigator.of(context).pop();

      var apiCall = {
        "uid":data['uid']
      };

      getGroupDetailsList(apiCall,"groups/getGroups_list");

      Navigator.pop(context);

      notifyListeners();
    }
    else{
      isaddGroupLoading = false;
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }

  }




  editGroups(data,url,context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().postData(data,url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("uid");

      var apiCall = {
        "uid":"$id"
      };

      getGroupDetailList.clear();

      getGroupDetailsList(apiCall,"groups/getGroups_list");

      Navigator.pop(context);
      Navigator.pop(context);

      notifyListeners();
    }
    else{
      Navigator.pop(context);
      print("Comment Post Api Error !!");
      notifyListeners();
    }

  }



  deleteGroup(data, url, context) async {
    Helper.dialogCall.showAlertDialog(context);
    notifyListeners();

    var response = await CallApi().getDataAsParams(data, url);

    print('res${response.body}');

    if (response.statusCode == 200) {
      getGroupDetailList.clear();

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      var id = sharedPreferences.getString("uid");

      var apiCall = {
        "uid":"$id"
      };

      getGroupDetailsList(apiCall,"groups/getGroups_list");
      Helper.dialogCall.showToast(context, "${getTranslated(context, "groups_deleted_successfully")}");

      Navigator.of(context).pop();
      Navigator.of(context).pop();

      notifyListeners();
    }
    else {
      print("delete group Api Error !!");
      notifyListeners();
    }
  }

}
