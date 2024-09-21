import 'dart:ui';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:oneqlik/Provider/login_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/Authentication/LoginScreen/login_screen.dart';
import 'package:oneqlik/utils/assets_images.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  bool signupShowPassword = false;
  bool signupConfirmPassword = false;

  LoginProvider loginProvider;

  Country _country = CountryPickerUtils.getCountryByPhoneCode('91');

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            searchCursorColor: Colors.pinkAccent,
            divider: Divider(),
            searchInputDecoration: InputDecoration(
                labelText: "${getTranslated(context, "search_location")}",
                suffixIcon: Icon(
                  Icons.search,
                  // color: AppColors.black,
                ),
                labelStyle: TextStyle(fontFamily: 'Poppins-Semibold')),
            isSearchable: true,
            title: Text(
              "${getTranslated(context, "phone_code")}",
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

  @override
  void initState() {
    super.initState();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
  }

  registerUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();

    var data = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "email": _emailIdController.text,
      "password": _passwordController.text,
      "phone": _numberController.text,
      "supAdmin": "59cbbdbe508f164aa2fef3d8",
      "isDealer": false,
      "expdate": DateTime.now().add(Duration(days: 365)).toUtc().toString(),
      "Dealer": "59cbbdbe508f164aa2fef3d8",
      "custumer": true,
      "std_code": {
        "countryCode": _country.isoCode,
        "dialcode": _country.phoneCode,
      },
      "timezone": currentTimeZone
    };

    print("register-->$data");

    loginProvider.registerUser(data, "users/signUp", context);
  }

  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    loginProvider = Provider.of<LoginProvider>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ApplicationColors.whiteColor,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: ApplicationColors.whiteColorF9),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _forMKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: height * 0.1),
                  Image.asset(AssetsUtilities.logoPng, height: height * 0.25),
                  const SizedBox(height: 25),
                  CustomTextField(
                    hintStyle: TextStyle(color: ApplicationColors.black4240),
                    textAlign: TextAlign.start,
                    controller: _userIdController,
                    hintText: '${getTranslated(context, "userid")}',
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${getTranslated(context, "enter_id")}';
                      }
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 21),
                  CustomTextField(
                    hintStyle: TextStyle(color: ApplicationColors.black4240),
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.start,
                    controller: _firstNameController,
                    hintText: '${getTranslated(context, "firstname")}',
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${getTranslated(context, "enter_first_name")}';
                      }
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 21),
                  CustomTextField(
                    hintStyle: TextStyle(color: ApplicationColors.black4240),
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.start,
                    controller: _lastNameController,
                    hintText: '${getTranslated(context, "last_name")}',
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${getTranslated(context, "Enter_lastname")}';
                      }
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 21),
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
                                    color: ApplicationColors.redColor67)),
                            child: Center(
                              child: Text(
                                "+ ${_country.phoneCode}",
                                style: TextStyle(
                                  color: ApplicationColors.black4240,
                                  fontFamily: "Poppins-Regular",
                                ),
                              ),
                            ),
                          )),
                      SizedBox(width: 9),
                      Expanded(
                        child: CustomTextField(
                          hintStyle:
                              TextStyle(color: ApplicationColors.black4240),
                          controller: _numberController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.start,
                          inputFormatter: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          hintText:
                              '${getTranslated(context, "mobile_number")}',
                          validator: (value) {
                            FocusScope.of(context).unfocus();
                            if (value == null || value == '') {
                              return "${getTranslated(context, "enter_num")}";
                            } else if (value.length < 10) {
                              return "${getTranslated(context, "entervalid_num")}";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 21),
                  CustomTextField(
                    hintStyle: TextStyle(color: ApplicationColors.black4240),
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.start,
                    controller: _emailIdController,
                    // hintText: 'Email',
                    hintText: "email id",
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
                  const SizedBox(height: 21),
                  CustomTextField(
                    hintStyle: TextStyle(color: ApplicationColors.black4240),
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            signupShowPassword = !signupShowPassword;
                          });
                        },
                        child: Container(
                          height: 14,
                          width: 20,
                          padding: EdgeInsets.all(14),
                          child: Image.asset(
                            !signupShowPassword
                                ? "assets/images/visible_icon.png"
                                : "assets/images/visibility_on.png",
                            color: ApplicationColors.textfieldBorderColor,
                          ),
                        )),
                    textAlign: TextAlign.start,
                    obscureText: !signupShowPassword,
                    controller: _passwordController,
                    hintText: '${getTranslated(context, "password")} *',
                    validator: (value) {
                      FocusScope.of(context).unfocus();
                      if (value.isEmpty) {
                        return "${getTranslated(context, "Enter_valid_Password")}";
                      }
                      if (value.length < 7) {
                        return '${getTranslated(context, "condition_password")}!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 21),
                  CustomTextField(
                    hintStyle: TextStyle(color: ApplicationColors.black4240),
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            signupConfirmPassword = !signupConfirmPassword;
                          });
                        },
                        child: Container(
                          height: 14,
                          width: 20,
                          padding: EdgeInsets.all(14),
                          child: Image.asset(
                            !signupConfirmPassword
                                ? "assets/images/visible_icon.png"
                                : "assets/images/visibility_on.png",
                            color: ApplicationColors.textfieldBorderColor,
                          ),
                        )),
                    textAlign: TextAlign.start,
                    obscureText: !signupConfirmPassword,
                    hintText: '${getTranslated(context, "confirm_password")}',
                    validator: (value) {
                      FocusScope.of(context).unfocus();
                      if (value.isEmpty) {
                        return "${getTranslated(context, "enter_confpassword")}";
                      }
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        return "${getTranslated(context, "password_notmatch")}";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 21),
                  Row(
                    children: [
                      Expanded(
                          child: CustomElevatedButton(
                        onPressed: () async {
                          registerUser();
                          /* if (_forMKey
                                  .currentState
                                  .validate()){


                              }*/
                        },
                        buttonText: '${getTranslated(context, "signup")}',
                        buttonColor: ApplicationColors.redColor67,
                      )),
                    ],
                  ),
                  const SizedBox(height: 21),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${getTranslated(context, "already_acount")}",
                        textAlign: TextAlign.center,
                        style: FontStyleUtilities.hW14(
                            fontColor: ApplicationColors.black4240),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen()));
                        },
                        child: Text(
                          "${getTranslated(context, "sign_in")}",
                          textAlign: TextAlign.center,
                          style: FontStyleUtilities.hW14(
                              fontColor: ApplicationColors.redColor67),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 57),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
