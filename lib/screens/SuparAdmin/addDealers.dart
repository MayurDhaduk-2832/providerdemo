import 'dart:convert';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:oneqlik/Provider/customer_dealer_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDealers extends StatefulWidget {
  const AddDealers({Key key}) : super(key: key);

  @override
  AddDealersState createState() => AddDealersState();
}

class AddDealersState extends State<AddDealers> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailIDController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  Country _country = CountryPickerUtils.getCountryByPhoneCode('91');
  CustomerDealerProvider customerDealerProvider;

  void _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.pink),
      child: CountryPickerDialog(
        searchCursorColor: Colors.pinkAccent,
        divider: Divider(),
        searchInputDecoration: InputDecoration(
            labelText: 'SearchLocationPage...',
            suffixIcon: Icon(
              Icons.search,
              // color: AppColors.black,
            ),
            labelStyle: TextStyle(fontFamily: 'Poppins-Semibold')),
        isSearchable: true,
        title: Text(
          "Select your phone code",
          style: TextStyle(fontFamily: 'Poppins-SemiBold'),
        ),
        onValuePicked: (Country country) =>
            setState(() => _country = country),
        itemBuilder: (Country country) {
          return Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(width: 8.0),
              Text(
                "+${country.phoneCode}",
                style:
                TextStyle(fontSize: 15, fontFamily: 'Poppins-Regular'),
              ),
              SizedBox(width: 8.0),
              Flexible(
                  child: Text(
                    country.name,
                    style:
                    TextStyle(fontSize: 15, fontFamily: 'Poppins-regular'),
                  ))
            ],
          );
        },
        priorityList: [
          CountryPickerUtils.getCountryByIsoCode('IN'),
        ],
      ),
    ),
  );

  addDealers() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    bool superAdmin = sharedPreferences.getBool("superAdmin");
    final String currentTimeZone =
    await FlutterNativeTimezone.getLocalTimezone();

    var data = {
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "email": emailIDController.text,
      "password": passwordController.text,
      "phone": mobileController.text,
      "isDealer": true,
      "custumer": false,
      "sysadmin": superAdmin,
      "expdate": DateTime.now().add(Duration(days: 365)).toUtc().toString(),
      "supAdmin": id,
      "user_id": userIdController.text,
      "address": addressController.text,
      "bussinessType": "0",
      "std_code": {
        "countryCode": "${_country.isoCode}",
        "dialcode": "${_country.phoneCode}"
      },
      "timezone": currentTimeZone,
      "imageDoc": []
    };

    print(jsonEncode(data));

    await customerDealerProvider.addDealer(data, "users/signUp", context);
  }

  @override
  void initState() {
    super.initState();
    customerDealerProvider =
        Provider.of<CustomerDealerProvider>(context, listen: false);
  }

  bool addDealerPwd = false;
  bool addDealerConfirmPwd = false;

  @override
  Widget build(BuildContext context) {
    customerDealerProvider =
        Provider.of<CustomerDealerProvider>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_sharp,
            color: ApplicationColors.whiteColor,
            size: 26,
          ),
        ),
        title: Text(
          '${getTranslated(context, "add_dealers")}',
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16,
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(right: 19, left: 14, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 25, right: 25, top: 40),
                child: Form(
                  key: _forMKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "${getTranslated(context, "userid")}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      CustomTextField(
                        controller: userIdController,
                        textAlign: TextAlign.start,
                        focusedBorder: ApplicationColors.redColor67,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        // controller: _loginController.userNameController,
                        // hintText: 'Group Name',
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "enter_id")}";
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      Text("${getTranslated(context, "firstname")}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.primaryTextColor)),
                      SizedBox(height: height * 0.01),
                      CustomTextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        controller: firstNameController,
                        maxLine: 1,
                        focusedBorder: ApplicationColors.redColor67,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        // controller: _loginController.userNameController,
                        // hintText: 'Email',
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "enter_first_name")}";
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        "${getTranslated(context, "last_name")}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      CustomTextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        controller: lastNameController,
                        maxLine: 1,
                        focusedBorder: ApplicationColors.redColor67,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        // controller: _loginController.userNameController,
                        // hintText: 'Email',
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "Enter_lastname")}";
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        "Email ID",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailIDController,
                        textAlign: TextAlign.start,
                        focusedBorder: ApplicationColors.redColor67,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        validator: (value) {
                          bool validEmail = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(value ?? '');
                          if (value == null || value == '') {
                            return "${getTranslated(context, "enter_email_id")}";
                          } else if (validEmail == false) {
                            return "${getTranslated(context, "enter_valid_email")}";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      Text('${getTranslated(context, "mobile_no")}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.primaryTextColor)),
                      SizedBox(height: height * 0.01),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                _openCountryPickerDialog();
                              },
                              child: Container(
                                width: 75,
                                height: 58,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: ApplicationColors
                                            .textfieldBorderColor)),
                                child: Center(
                                  child: Text(
                                    "+ ${_country.phoneCode}",
                                    style: TextStyle(
                                      color: ApplicationColors.primaryTextColor,
                                      fontFamily: "Poppins-Regular",
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(width: 9),
                          Expanded(
                            child: CustomTextField(
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.start,
                              focusedBorder: ApplicationColors.redColor67,
                              borderColor:
                              ApplicationColors.textfieldBorderColor,
                              inputFormatter: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              controller: mobileController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "${getTranslated(context, "entervalid_num")}";
                                }
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      Text("${getTranslated(context, "password")}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.primaryTextColor)),
                      SizedBox(height: height * 0.01),
                      CustomTextField(
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                addDealerPwd = !addDealerPwd;
                              });
                            },
                            child: Container(
                              height: 14,
                              width: 20,
                              padding: EdgeInsets.all(14),
                              child: Image.asset(
                                addDealerPwd
                                    ? "assets/images/visible_icon.png"
                                    : "assets/images/visibility_on.png",
                                color: ApplicationColors.textfieldBorderColor,
                              ),
                            )),
                        obscureText: addDealerPwd,
                        keyboardType: TextInputType.visiblePassword,
                        textAlign: TextAlign.start,
                        controller: passwordController,
                        maxLine: 1,
                        focusedBorder: ApplicationColors.redColor67,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        validator: (value) {
                          FocusScope.of(context).unfocus();
                          if (value.isEmpty) {
                            return "${getTranslated(context, "Enter_valid_Password")}";
                          }
                          if (value.length < 7) {
                            return "${getTranslated(context, "password_must_be_6_character")}";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      Text("${getTranslated(context, "confirm_pwd")}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.primaryTextColor)),
                      SizedBox(height: height * 0.01),
                      CustomTextField(
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                addDealerConfirmPwd = !addDealerConfirmPwd;
                              });
                            },
                            child: Container(
                              height: 14,
                              width: 20,
                              padding: EdgeInsets.all(14),
                              child: Image.asset(
                                addDealerConfirmPwd
                                    ? "assets/images/visible_icon.png"
                                    : "assets/images/visibility_on.png",
                                color: ApplicationColors.textfieldBorderColor,
                              ),
                            )),
                        obscureText: addDealerConfirmPwd,
                        keyboardType: TextInputType.visiblePassword,
                        textAlign: TextAlign.start,
                        controller: confirmPasswordController,
                        maxLine: 1,
                        focusedBorder: ApplicationColors.redColor67,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        validator: (value) {
                          FocusScope.of(context).unfocus();
                          if (value.isEmpty) {
                            return "${getTranslated(context, "enter_confpassword")}";
                          }
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            return "${getTranslated(context, "password_notmatch")}";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      Text("${getTranslated(context, "address*")}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.primaryTextColor)),
                      SizedBox(height: height * 0.01),
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.start,
                        controller: addressController,
                        maxLine: 4,
                        focusedBorder: ApplicationColors.redColor67,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "enter_address")}";
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      SizedBox(height: height * 0.07),
                    ],
                  ),
                ),
                decoration: BoxDecoration(),
              ),
              SizedBox(height: height * 0.05),
              Row(
                children: [
                  Expanded(
                      child: CustomElevatedButton(
                        onPressed: () async {
                          if (_forMKey.currentState.validate()) {
                            addDealers();
                          }
                        },
                        buttonText: '${getTranslated(context, "submit")}',
                        buttonColor: ApplicationColors.redColor67,
                      )),
                ],
              ),
              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
