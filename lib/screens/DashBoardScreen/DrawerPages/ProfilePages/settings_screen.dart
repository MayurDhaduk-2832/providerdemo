import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/currency_model.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/main.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../components/styleandborder.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool loginshowpassword = false;

  int customerServiceIndex = 0;

  var chooseMapType;

  UserProvider userProvider;

  bool _voiceNotification = true;

  var selectDefaultPage;
  var chooseFuelUnit = "liter";
  var chooseLanguageType = "English";
  var chooseCurrencySettings;

  updateFuel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data = {
      "fname": userProvider.useModel.cust.firstName,
      "lname": userProvider.useModel.cust.firstName,
      "org": userProvider.useModel.cust.orgName,
      "noti": userProvider.useModel.cust.getNotif,
      "uid": id,
      "show_announcement": userProvider.useModel.cust.showAnnouncement,
      "label_setting": userProvider.useModel.cust.labelSetting,
      "digital_input": userProvider.useModel.cust.digitalInput,
      "driverManagement": userProvider.useModel.cust.driverManagement,
      "paymentGateway": userProvider.useModel.cust.paymentgateway,
      "timezone": userProvider.useModel.cust.timezone,
      "fuel_unit": chooseFuelUnit.toUpperCase()
    };

    print('CheckEdit-<${data}');

    await userProvider.updateUserData(data, "users/Account_Edit", context);
  }

  SharedPreferences preferences;

  bool isLoading = false;

  getUserSettings() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var data = {"uid": id};

    await userProvider.getUserSettings(data, "users/get_user_setting", context);

    if (userProvider.isSuccess) {
      //_voiceNotification  = userProvider.getUserSettingsModel.voiceAlert;
      setState(() {
        chooseCurrencySettings =
            userProvider.getUserSettingsModel.currencyCode ?? "INR";
        chooseFuelUnit =
            userProvider.getUserSettingsModel.fuelUnit == "litre" ||
                    userProvider.getUserSettingsModel.fuelUnit == "liter"
                ? "liter"
                : userProvider.getUserSettingsModel.fuelUnit.toLowerCase();
      });
    }
  }

  setUserSettings() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var data = {
      "uid": id,
      "currency_code": "$chooseCurrencySettings",
      "unit_measurement": userProvider.chooseMeasureType,
    };

    print('CheckSet-->$data');

    userProvider.setUserSettings(data, "users/set_user_setting", context);
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
    };

    print(id);

    await userProvider.getUserData(data, "users/getCustumerDetail", context);

    setState(() {
      isLoading = false;
    });
  }

  showBoxDialog() {
    showDialog(
      context: context,
      builder: (context) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;
        return AlertDialog(
          titlePadding: const EdgeInsets.only(right: 18, left: 15, top: 10),
          actionsPadding: EdgeInsets.symmetric(horizontal: 15),
          backgroundColor: ApplicationColors.blackColor2E,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${getTranslated(context, "set_immobilizepasswrd")}",
                overflow: TextOverflow.visible,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: FontStyleUtilities.h24()
                    .copyWith(color: ApplicationColors.black4240, fontSize: 22),
              ),
              SizedBox(height: 5),
              Text(
                "${getTranslated(context, "enter_cutengine_password")}",
                overflow: TextOverflow.visible,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: FontStyleUtilities.h16(
                  fontColor: ApplicationColors.black4240,
                  fontFamily: "Poppins-Regular",
                ),
              ),
            ],
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: ApplicationColors.textfieldBorderColor,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Form(
                      key: _forMKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.01),
                          CustomTextField(
                            hintStyle:
                                TextStyle(color: ApplicationColors.black4240),
                            controller: _oldPasswordController,
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    oldShowPassword = !oldShowPassword;
                                  });
                                },
                                child: Container(
                                  height: 14,
                                  width: 20,
                                  padding: EdgeInsets.all(14),
                                  child: Image.asset(
                                    !oldShowPassword
                                        ? "assets/images/visible_icon.png"
                                        : "assets/images/visibility_on.png",
                                    color: ApplicationColors.dropdownColor3D,
                                  ),
                                )),
                            textAlign: TextAlign.start,
                            obscureText: !oldShowPassword,
                            hintText:
                                "${getTranslated(context, "old_password")}",
                            validator: (value) {
                              FocusScope.of(context).unfocus();
                              if (value.isEmpty) {
                                return "${getTranslated(context, "enter_oldpassword")}";
                              } else if (_oldPasswordController.text !=
                                      userProvider.useModel.cust.engineCutPsd ||
                                  _oldPasswordController.text !=
                                      userProvider.useModel.cust.pass) {
                                return "${getTranslated(context, "old_does_not_match")}";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height * 0.025),
                          CustomTextField(
                            hintStyle:
                                TextStyle(color: ApplicationColors.black4240),
                            controller: _newPasswordController,
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    newPassword = !newPassword;
                                  });
                                },
                                child: Container(
                                  height: 14,
                                  width: 20,
                                  padding: EdgeInsets.all(14),
                                  child: Image.asset(
                                    !newPassword
                                        ? "assets/images/visible_icon.png"
                                        : "assets/images/visibility_on.png",
                                    color: ApplicationColors.dropdownColor3D,
                                  ),
                                )),
                            textAlign: TextAlign.start,
                            obscureText: !newPassword,
                            hintText:
                                "${getTranslated(context, "new_password")}",
                            validator: (value) {
                              FocusScope.of(context).unfocus();
                              if (value.isEmpty) {
                                return "${getTranslated(context, "enter_newpassword")}";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height * 0.025),
                          CustomTextField(
                            hintStyle:
                                TextStyle(color: ApplicationColors.black4240),
                            controller: _changeConfirmPasswordController,
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    changeConfirmPassword =
                                        !changeConfirmPassword;
                                  });
                                },
                                child: Container(
                                  height: 14,
                                  width: 20,
                                  padding: EdgeInsets.all(14),
                                  child: Image.asset(
                                    !changeConfirmPassword
                                        ? "assets/images/visible_icon.png"
                                        : "assets/images/visibility_on.png",
                                    color: ApplicationColors.dropdownColor3D,
                                  ),
                                )),
                            textAlign: TextAlign.start,
                            obscureText: !changeConfirmPassword,
                            hintText:
                                "${getTranslated(context, "confirm_password")}",
                            validator: (value) {
                              FocusScope.of(context).unfocus();
                              if (value.isEmpty) {
                                return "${getTranslated(context, "enter_confpassword")}";
                              } else if (_newPasswordController.text != value) {
                                return "${getTranslated(context, "password_notmatch")}";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height * 0.01),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SimpleElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    buttonName: "${getTranslated(context, "cancel")}",
                    style: FontStyleUtilities.s18(
                        fontColor: ApplicationColors.whiteColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: ApplicationColors.redColor67,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SimpleElevatedButton(
                    onPressed: () {
                      if (_forMKey.currentState.validate()) {
                        setImmobilizePassword();
                      }
                    },
                    buttonName: "${getTranslated(context, "apply")}",
                    style: FontStyleUtilities.s18(
                      fontColor: ApplicationColors.whiteColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: ApplicationColors.redColor67,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: false,
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: ApplicationColors.blackColor2E,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${getTranslated(context, "currency_settings")}",
                overflow: TextOverflow.visible,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: FontStyleUtilities.s18(
                    fontColor: ApplicationColors.black4240,
                    fontFamily: "Poppins-SemiBold"),
              ),
              Divider(
                color: ApplicationColors.textfieldBorderColor,
                thickness: 1.5,
              ),
              SizedBox(height: 5),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 250,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: listCurrency
                        .map((e) => InkWell(
                              onTap: () {
                                setState(() {
                                  chooseCurrencySettings = "${e.code}";
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: chooseCurrencySettings == "${e.code}"
                                        ? ApplicationColors.redColor67
                                        : ApplicationColors.dropdownColor3D,
                                  ),
                                  SizedBox(width: 15),
                                  Flexible(
                                    child: Text(
                                      "${e.code} - ${e.name}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: FontStyleUtilities.h14(
                                          fontColor:
                                              ApplicationColors.black4240),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SimpleElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    buttonName: "${getTranslated(context, "cancel")}",
                    style: FontStyleUtilities.s18(
                        fontColor: ApplicationColors.whiteColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: ApplicationColors.redColor67,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SimpleElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setUserSettings();
                    },
                    buttonName: "${getTranslated(context, "ok")}",
                    style: FontStyleUtilities.s18(
                        fontColor: ApplicationColors.whiteColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: ApplicationColors.redColor67,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  pageDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                contentPadding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: ApplicationColors.blackColor2E,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${getTranslated(context, "choose_screen")}",
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: FontStyleUtilities.s18(
                          fontColor: ApplicationColors.black4240,
                          fontFamily: "Poppins-SemiBold"),
                    ),
                    Divider(
                      color: ApplicationColors.textfieldBorderColor,
                      thickness: 1.5,
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          selectDefaultPage =
                              "${getTranslated(context, "dashbiard")}";
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: selectDefaultPage ==
                                    "${getTranslated(context, "dashbiard")}"
                                ? ApplicationColors.redColor67
                                : ApplicationColors.dropdownColor3D,
                          ),
                          SizedBox(width: 15),
                          Flexible(
                            child: Text(
                              "${getTranslated(context, "dashbiard")}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          selectDefaultPage =
                              "${getTranslated(context, "live_trackin")}";
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: selectDefaultPage ==
                                    "${getTranslated(context, "live_trackin")}"
                                ? ApplicationColors.redColor67
                                : ApplicationColors.dropdownColor3D,
                          ),
                          SizedBox(width: 15),
                          Flexible(
                            child: Text(
                              "${getTranslated(context, "live_trackin")}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          selectDefaultPage = "${getTranslated(context, "")}";
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: selectDefaultPage ==
                                    "${getTranslated(context, "")}"
                                ? ApplicationColors.redColor67
                                : ApplicationColors.dropdownColor3D,
                          ),
                          SizedBox(width: 15),
                          Flexible(
                            child: Text(
                              "${getTranslated(context, "")}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SimpleElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonName: "${getTranslated(context, "cancel")}",
                          style: FontStyleUtilities.s18(
                              fontColor: ApplicationColors.whiteColor),
                          fixedSize: Size(118, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: ApplicationColors.redColor67,
                        ),
                        SizedBox(width: width * 0.020),
                        SimpleElevatedButton(
                          onPressed: () async {
                            if (selectDefaultPage ==
                                "${getTranslated(context, "dashbiard")}") {
                              preferences =
                                  await SharedPreferences.getInstance();
                              preferences.remove("homeIndex");
                              preferences.setInt("homeIndex", 0);
                              userProvider.changeBottomIndex(0);
                              Navigator.pop(context);
                            } else if (selectDefaultPage ==
                                "${getTranslated(context, "live_trackin")}") {
                              preferences =
                                  await SharedPreferences.getInstance();
                              preferences.remove("homeIndex");
                              preferences.setInt("homeIndex", 1);
                              userProvider.changeBottomIndex(1);
                              Navigator.pop(context);
                            } else if (selectDefaultPage ==
                                "${getTranslated(context, "")}") {
                              preferences =
                                  await SharedPreferences.getInstance();
                              preferences.remove("homeIndex");
                              preferences.setInt("homeIndex", 2);
                              userProvider.changeBottomIndex(2);
                              Navigator.pop(context);
                            }
                          },
                          buttonName: "${getTranslated(context, "ok")}",
                          style: FontStyleUtilities.s18(
                              fontColor: ApplicationColors.whiteColor),
                          fixedSize: Size(118, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: ApplicationColors.redColor67,
                        ),
                      ],
                    ),
                  ],
                ));
          },
        );
      },
    );
  }

  fuelDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: ApplicationColors.blackColor2E,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${getTranslated(context, "fuel_unit")}",
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: FontStyleUtilities.s18(
                        fontColor: ApplicationColors.black4240,
                        fontFamily: "Poppins-SemiBold"),
                  ),
                  Divider(
                    color: ApplicationColors.textfieldBorderColor,
                    thickness: 1.5,
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        chooseFuelUnit = "liter";
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: chooseFuelUnit == "liter"
                              ? ApplicationColors.redColor67
                              : ApplicationColors.dropdownColor3D,
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Text(
                            "${getTranslated(context, "liter")}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FontStyleUtilities.h14(
                                fontColor: ApplicationColors.black4240),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        chooseFuelUnit = "percentage";
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: chooseFuelUnit == "percentage"
                              ? ApplicationColors.redColor67
                              : ApplicationColors.dropdownColor3D,
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Text(
                            "${getTranslated(context, "percentage")}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FontStyleUtilities.h14(
                                fontColor: ApplicationColors.black4240),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SimpleElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        buttonName: "${getTranslated(context, "cancel")}",
                        style: FontStyleUtilities.s18(
                            fontColor: ApplicationColors.whiteColor),
                        fixedSize: Size(118, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: ApplicationColors.redColor67,
                      ),
                      SizedBox(width: width * 0.020),
                      SimpleElevatedButton(
                        onPressed: () {
                          updateFuel();
                          Navigator.of(context).pop();
                        },
                        buttonName: "${getTranslated(context, "ok")}",
                        style: FontStyleUtilities.s18(
                            fontColor: ApplicationColors.whiteColor),
                        fixedSize: Size(118, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: ApplicationColors.redColor67,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  var currentLanguage;

  void _changeLanguage(String lan) async {
    Locale _locale = await setLocale(lan);
    MyApp.setLocale(context, _locale);
  }

  void getLan() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      currentLanguage = preferences.getString('lan');
      chooseLanguageType = preferences.getString('lagName') ?? "English";
      chooseMapType = preferences.getString("MapType") ?? "Normal";
    });

    if ("${preferences.getInt("homeIndex")}" == "0") {
      selectDefaultPage = "${getTranslated(context, "dashbiard")}";
    } else if ("${preferences.getInt("homeIndex")}" == "1") {
      selectDefaultPage = "${getTranslated(context, "live_trackin")}";
    } else if ("${preferences.getInt("homeIndex")}" == "2") {
      selectDefaultPage = "${getTranslated(context, "")}";
    } else {
      selectDefaultPage = "${getTranslated(context, "dashbiard")}";
    }
    print(selectDefaultPage);
    print("${preferences.getInt("homeIndex")}");
  }

  showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                contentPadding: EdgeInsets.all(0),
                scrollable: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: ApplicationColors.blackColor2E,
                title: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getTranslated(context, "Language")}",
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: FontStyleUtilities.s18(
                            fontColor: ApplicationColors.black4240,
                            fontFamily: "Poppins-SemiBold"),
                      ),
                      Divider(
                        color: ApplicationColors.textfieldBorderColor,
                        thickness: 1.5,
                      ),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          setState(() {
                            chooseLanguageType = "English";
                            currentLanguage = "en";
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: chooseLanguageType == "English"
                                  ? ApplicationColors.redColor67
                                  : ApplicationColors.dropdownColor3D,
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                "English",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            chooseLanguageType = "Hindi";
                            currentLanguage = "hi";
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: chooseLanguageType == "Hindi"
                                  ? ApplicationColors.redColor67
                                  : ApplicationColors.dropdownColor3D,
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                "Hindi",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            chooseLanguageType = "Marathi";
                            currentLanguage = "mr";
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: chooseLanguageType == "Marathi"
                                  ? ApplicationColors.redColor67
                                  : ApplicationColors.dropdownColor3D,
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                "Marathi",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            chooseLanguageType = "Bangali";
                            currentLanguage = "bn";
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: chooseLanguageType == "Bangali"
                                  ? ApplicationColors.redColor67
                                  : ApplicationColors.dropdownColor3D,
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                "Bangali",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            chooseLanguageType = "Tamil";
                            currentLanguage = "ta";
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: chooseLanguageType == "Tamil"
                                  ? ApplicationColors.redColor67
                                  : ApplicationColors.dropdownColor3D,
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                "Tamil",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            currentLanguage = "te";
                            chooseLanguageType = "Telugu";
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: chooseLanguageType == "Telugu"
                                  ? ApplicationColors.redColor67
                                  : ApplicationColors.dropdownColor3D,
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                "Telugu",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            chooseLanguageType = "Gujarati";
                            currentLanguage = "gu";
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: chooseLanguageType == "Gujarati"
                                  ? ApplicationColors.redColor67
                                  : ApplicationColors.dropdownColor3D,
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                "Gujarati",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            chooseLanguageType = "Kannada";
                            currentLanguage = "kn";
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: chooseLanguageType == "Kannada"
                                  ? ApplicationColors.redColor67
                                  : ApplicationColors.dropdownColor3D,
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                "Kannada",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SimpleElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              buttonName: "${getTranslated(context, "cancel")}",
                              style: FontStyleUtilities.s18(
                                  fontColor: ApplicationColors.whiteColor),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: ApplicationColors.redColor67,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: SimpleElevatedButton(
                              onPressed: () {
                                preferences.setString(
                                    'lan', '$currentLanguage');
                                preferences.setString(
                                    'lagName', '$chooseLanguageType');
                                _changeLanguage('$currentLanguage');
                                getLan();
                                Navigator.pop(context);
                              },
                              buttonName: "${getTranslated(context, "ok")}",
                              style: FontStyleUtilities.s18(
                                  fontColor: ApplicationColors.black4240),
                              fixedSize: Size(118, 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: ApplicationColors.redColor67,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  List<CurrencyModel> listCurrency = [];

  getCurrency() async {
    final String response =
        await rootBundle.loadString('assets/currency_file.json');
    var body = jsonDecode(response);
    List<CurrencyModel> list;

    List client = body as List;
    list = client
        .map<CurrencyModel>((json) => CurrencyModel.fromJson(json))
        .toList();
    listCurrency.addAll(list);
  }

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    getCurrency();
    getUserSettings();
    getUserData();
    Future.delayed(Duration.zero, () {
      getLan();
    });
  }

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _changeConfirmPasswordController =
      TextEditingController();

  bool oldShowPassword = false;

  bool newPassword = false;
  bool changeConfirmPassword = false;

  setImmobilizePassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var data = {
      "engine_cut_psd": _newPasswordController.text,
      "uid": "$id",
    };

    print('setImmobilize-->$data');

    await userProvider.setImmobilizePwd(data, "users/Account_Edit", context);
  }

  var width, height;
  bool voiceAlert = false;

  setUserSetting(bool voiceAlert) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    var data = {
      "uid": id,
      "voice_alert": voiceAlert,
    };

    userProvider.setUserSettings(data, "users/set_user_setting", context);
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ApplicationColors.blackColor2E,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: ApplicationColors.whiteColor,
            size: 26,
          ),
        ),
        title: Text(
          "${getTranslated(context, "setting")}",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Arial',
            color: ApplicationColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
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
      body: isLoading
          ? Helper.dialogCall.showLoader()
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        pageDialog();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 47,
                            height: 47,
                            child: Image.asset(
                              "assets/images/default_page_ic.png",
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: width * 0.05),
                          Expanded(
                            child: Text(
                              "${getTranslated(context, "defaul_page")}",
                              style: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "$selectDefaultPage",
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: ApplicationColors.redColor67,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    indent: 75,
                    thickness: 2,
                  ),
                  // map type
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 47,
                          height: 47,
                          child: Image.asset(
                            "assets/images/map_type_ic.png",
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: width * 0.05),
                        Text("${getTranslated(context, "map_type")}",
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: FontStyleUtilities.h14(
                                fontColor: ApplicationColors.black4240)),
                        Expanded(child: SizedBox()),
                        SizedBox(
                          width: 95,
                          child: DropdownButtonFormField(
                              // style: FontStyleUtilities.h14(fontColor: ApplicationColors.blackColor2E),
                              value: chooseMapType,
                              iconEnabledColor: ApplicationColors.redColor67,
                              isDense: true,
                              isExpanded: true,
                              onChanged: (val) async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  chooseMapType = val;
                                  sharedPreferences.remove("MapType");
                                  sharedPreferences.setString("MapType", val);

                                  if (preferences.getString("MapType") !=
                                      null) {
                                    if (preferences.getString("MapType") ==
                                        "Normal") {
                                      Utils.mapType = MapType.normal;
                                    } else if (preferences
                                            .getString("MapType") ==
                                        "Satellite") {
                                      Utils.mapType = MapType.satellite;
                                    } else if (preferences
                                            .getString("MapType") ==
                                        "Terrain") {
                                      Utils.mapType = MapType.terrain;
                                    } else if (preferences
                                            .getString("MapType") ==
                                        "Hybrid") {
                                      Utils.mapType = MapType.hybrid;
                                    }
                                  }
                                });
                              },
                              dropdownColor: ApplicationColors.whiteColor,
                              decoration: InputDecoration(
                                  hintText:
                                      "${getTranslated(context, "normal")}",
                                  labelStyle: FontStyleUtilities.h14(
                                      fontColor: ApplicationColors.black4240),
                                  hintStyle: FontStyleUtilities.h14(
                                      fontColor: ApplicationColors.black4240),
                                  contentPadding: EdgeInsets.only(left: 15),
                                  border: InputBorder.none),
                              items: [
                                "${getTranslated(context, "normal")}",
                                "${getTranslated(context, "terrain")}",
                                "${getTranslated(context, "satelite")}",
                                "${getTranslated(context, "hybrid")}",
                              ]
                                  .map((String value) => DropdownMenuItem(
                                        child: Text(
                                          value,
                                          style: FontStyleUtilities.h14(
                                              fontColor:
                                                  ApplicationColors.black4240,
                                              fontFamily: 'Poppins-Regular'),
                                        ),
                                        value: value,
                                      ))
                                  .toList()),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 75,
                    thickness: 2,
                  ),
                  // fuel unit
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        fuelDialog();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 47,
                              height: 47,
                              child: Image.asset(
                                "assets/images/fuel_icon.png",
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: width * 0.05),
                            Expanded(
                              child: Text(
                                "${getTranslated(context, "fuel_unit")}",
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "$chooseFuelUnit",
                                  style: FontStyleUtilities.h14(
                                      fontColor: ApplicationColors.black4240),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: ApplicationColors.redColor67,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    indent: 75,
                    thickness: 2,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         padding: EdgeInsets.all(10),
                  //         width: 47,
                  //         height: 47,
                  //         child: Image.asset(
                  //           "assets/images/language_ic.png",
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //       SizedBox(width: width * 0.05),
                  //       Expanded(
                  //         child: InkWell(
                  //           onTap: () {
                  //             showLanguageDialog();
                  //           },
                  //           child: Text(
                  //             '${getTranslated(context, "Language")}',
                  //             style: FontStyleUtilities.h14(
                  //                 fontColor: ApplicationColors.black4240),
                  //           ),
                  //         ),
                  //       ),
                  //       Text(
                  //         "$chooseLanguageType",
                  //         style: FontStyleUtilities.h14(
                  //             fontColor: ApplicationColors.black4240),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Divider(
                  //   indent: 75,
                  //   thickness: 2,
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 47,
                          height: 47,
                          child: Image.asset(
                            "assets/images/password_ic.png",
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: width * 0.05),
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                _oldPasswordController.clear();
                                _newPasswordController.clear();
                                _changeConfirmPasswordController.clear();
                                showBoxDialog();
                              },
                              child: Text(
                                "${getTranslated(context, "set_immobilizepasswrd")}",
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              )),
                        ),
                        Text(
                          "***",
                          style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.black4240),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    indent: 75,
                    thickness: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 47,
                          height: 47,
                          child: Image.asset(
                            "assets/images/mesure_ic.png",
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: width * 0.05),
                        Text("${getTranslated(context, "measurement_type")}",
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: FontStyleUtilities.h14(
                                fontColor: ApplicationColors.black4240)),
                        SizedBox(width: width * 0.15),
                        Expanded(
                          child: DropdownButtonFormField(
                              value: userProvider.chooseMeasureType,
                              iconEnabledColor: ApplicationColors.redColor67,
                              isDense: true,
                              isExpanded: true,
                              onChanged: (val) {
                                setState(() {
                                  userProvider.chooseMeasureType = val;
                                });
                                setUserSettings();
                              },
                              selectedItemBuilder: (context) {
                                return [
                                  "${getTranslated(context, "mks")}",
                                  "${getTranslated(context, "fps")}",
                                ]
                                    .map((e) => Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              "${userProvider.chooseMeasureType}",
                                              textAlign: TextAlign.end,
                                              style: FontStyleUtilities.h14(
                                                  fontColor: ApplicationColors
                                                      .black4240,
                                                  fontFamily:
                                                      'Poppins-Regular')),
                                        ))
                                    .toList();
                              },
                              dropdownColor: ApplicationColors.whiteColor,
                              decoration: InputDecoration(
                                  hintText: "${getTranslated(context, "mks")}",
                                  labelStyle: FontStyleUtilities.h14(
                                      fontColor:
                                          ApplicationColors.blackColor2E),
                                  hintStyle: FontStyleUtilities.h14(
                                      fontColor: ApplicationColors.black4240),
                                  contentPadding: EdgeInsets.only(left: 15),
                                  border: InputBorder.none),
                              items: [
                                "${getTranslated(context, "mks")}",
                                "${getTranslated(context, "fps")}",
                              ]
                                  .map((String value) => DropdownMenuItem(
                                        child: Text(
                                          value,
                                          style: FontStyleUtilities.h14(
                                              fontColor:
                                                  ApplicationColors.black4240,
                                              fontFamily: 'Poppins-Regular'),
                                        ),
                                        value: value,
                                      ))
                                  .toList()),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 75,
                    thickness: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        showCurrencyDialog();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 47,
                            height: 47,
                            child: Image.asset(
                              "assets/images/currency_ic.png",
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: width * 0.05),
                          Expanded(
                            child: Text(
                              "${getTranslated(context, "currency_settings")}",
                              style: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                            ),
                          ),
                          SizedBox(width: 10),
                          Row(
                            children: [
                              Text(
                                "$chooseCurrencySettings",
                                style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.black4240),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: ApplicationColors.redColor67,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    indent: 75,
                    thickness: 2,
                  ),
                ],
              ),
            ),
    );
  }
}
