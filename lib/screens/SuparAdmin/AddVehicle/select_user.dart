import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/add_vehicle_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class SelectUserScreen extends StatefulWidget {
  final dealerId;

  const SelectUserScreen({Key key, this.dealerId}) : super(key: key);

  @override
  _SelectUserScreenState createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  /* List<bool> listOfSelectUserModelValue = List<bool>.filled(6, false);*/

  TextEditingController _selectUserController = TextEditingController();

  final _debouncer = Debouncer(milliseconds: 500);

  var name, id;

  FocusNode focusNode = FocusNode();

  AddVehicleProvider addVehicleProvider;

  getSelectUserType() async {
    print("Dealer Id: ${widget.dealerId}");
    var data = {
      "dealer": widget.dealerId,
    };
    await addVehicleProvider.getSelectUserType(data, "users/getAllUsers");

    if (addVehicleProvider.isUserModelSuccess) {
      addVehicleProvider.getSelectUserList =
          addVehicleProvider.searchUserModelList;
    }
  }

  @override
  void initState() {
    super.initState();
    addVehicleProvider =
        Provider.of<AddVehicleProvider>(context, listen: false);
    getSelectUserType();
  }

  @override
  Widget build(BuildContext context) {
    addVehicleProvider = Provider.of<AddVehicleProvider>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: ApplicationColors.whiteColorF9),
        ),
        Scaffold(
          appBar: AppBar(
            leading: Container(),
            title: Text(
              "${getTranslated(context, "select_user")}",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Arial',
                color: ApplicationColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.close,
                    color: ApplicationColors.whiteColor,
                    size: 26,
                  ),
                ),
              ),
            ],
            flexibleSpace: Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xffd21938),
                    Color(0xffd21938),
                    Color(0xff751c1e),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Form(
                    // key: _forMKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Color(0xffd21938),
                                    Color(0xffd21938),
                                    Color(0xff751c1e),
                                  ],
                                ),
                              ),
                              child: TextFormField(
                                controller: _selectUserController,
                                focusNode: focusNode,
                                keyboardType: TextInputType.text,
                                onChanged: (string) {
                                  _debouncer.run(() {
                                    setState(() {
                                      addVehicleProvider.getSelectUserList =
                                          addVehicleProvider.searchUserModelList
                                              .where((u) {
                                        return ((u.firstName +
                                                " " +
                                                (u.lastName ?? ""))
                                            .contains(string));
                                      }).toList();
                                    });
                                  });
                                },
                                style: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240,
                                ),
                                decoration: Textfield1.inputdec.copyWith(
                                  labelStyle: TextStyle(
                                    color: ApplicationColors.black4240,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75,
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Search User",
                                  hintStyle: TextStyle(
                                    color: ApplicationColors.black4240,
                                    fontSize: 14,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75,
                                  ),
                                  fillColor: ApplicationColors.whiteColor,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                      'assets/images/search_icon.png',
                                      color: ApplicationColors.redColor67,
                                      width: 8,
                                    ),
                                  ),
                                  suffixIcon: _selectUserController.text.isEmpty
                                      ? SizedBox()
                                      : InkWell(
                                          onTap: () {
                                            addVehicleProvider.getSelectUserList
                                                .clear();
                                            addVehicleProvider
                                                .searchUserModelList
                                                .clear();
                                            addVehicleProvider
                                                .selectUserTypeLoading = false;
                                            getSelectUserType();
                                            _selectUserController.clear();
                                            focusNode.unfocus();
                                          },
                                          child: Icon(
                                            Icons.cancel_outlined,
                                            color: ApplicationColors.black4240,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            Container(
                                width: width,
                                height: height * 0.81,
                                decoration: BoxDecoration(
                                  color: ApplicationColors.blackColor2E,
                                ),
                                child: addVehicleProvider.selectUserTypeLoading
                                    ? Helper.dialogCall.showLoader()
                                    : addVehicleProvider
                                            .getSelectUserList.isEmpty
                                        ? Center(
                                            child: Text(
                                              "${getTranslated(context, "user_not_available")}",
                                              textAlign: TextAlign.center,
                                              style: Textstyle1.text18.copyWith(
                                                fontSize: 18,
                                                color: ApplicationColors
                                                    .redColor67,
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            itemCount: addVehicleProvider
                                                .getSelectUserList.length,
                                            itemBuilder: (context, int index) {
                                              var list = addVehicleProvider
                                                  .getSelectUserList[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          name =
                                                              list.firstName +
                                                                  list.lastName;
                                                          id = list.id;
                                                        });
                                                        addVehicleProvider
                                                            .changeSelectUserType(
                                                                index);
                                                        Navigator.pop(context, [
                                                          "$name",
                                                          "$id",
                                                        ]);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: width * .09,
                                                            height:
                                                                height * .03,
                                                            child: Container(
                                                              width:
                                                                  width * .09,
                                                              height:
                                                                  height * .03,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: ApplicationColors
                                                                      .blackColor00,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 14),
                                                          Text(
                                                            "${list.firstName}  "
                                                            "${list.lastName}",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      color:
                                                          Appcolors.text_grey,
                                                      indent: 50,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })),
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: ApplicationColors.blackColor2E,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: height * 0.04),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
