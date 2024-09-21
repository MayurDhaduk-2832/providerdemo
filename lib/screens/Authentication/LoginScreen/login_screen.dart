import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneqlik/Provider/login_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/Authentication/ForgotPasswordScreen/forgot_password_screen.dart';
import 'package:oneqlik/utils/assets_images.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

/*
  bool rememberMe = false;
*/

  bool loginshowpassword = false;

  LoginProvider loginProvider;

  @override
  void initState() {
    super.initState();

    loginProvider = Provider.of<LoginProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    loginProvider = Provider.of<LoginProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: ApplicationColors.black4240,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: ApplicationColors.whiteColorF9),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 49),
            child: Form(
              key: _forMKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 70),
                  Image.asset(AssetsUtilities.logoPng, height: height * 0.25),
                  const SizedBox(height: 55),
                  CustomTextField(
                    hintStyle: TextStyle(color: ApplicationColors.black4240),
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.start,
                    controller: _emailController,
                    hintText: '${getTranslated(context, "enter_userid")}',
                    validator: (value) {
                      if (value == null || value == '') {
                        return "${getTranslated(context, "error_userid")}";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    hintStyle: TextStyle(color: ApplicationColors.black4240),
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            loginshowpassword = !loginshowpassword;
                          });
                        },
                        child: Container(
                          height: 14,
                          width: 20,
                          padding: EdgeInsets.all(14),
                          child: Image.asset(
                            !loginshowpassword
                                ? "assets/images/visible_icon.png"
                                : "assets/images/visibility_on.png",
                            color: ApplicationColors.textfieldBorderColor,
                          ),
                        )),
                    textAlign: TextAlign.start,
                    obscureText: !loginshowpassword,
                    controller: _passwordController,
                    hintText: "${getTranslated(context, "pwd")}",
                    validator: (value) {
                      if (value.length < 1) {
                        return '${getTranslated(context, "condition_password")}';
                      }
                      FocusScope.of(context).unfocus();
                    },
                  ),

                  /*const SizedBox(height: 24),*/
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                          child:   Checkbox(
                              side: BorderSide(color: rememberMe ?ApplicationColors.redColor67:ApplicationColors.redColor67),
                              activeColor:ApplicationColors.redColor67,
                              checkColor:  ApplicationColors.black4240,
                              shape: RoundedRectangleBorder(
                                // side: BorderSide(color: ApplicationColors.lightBlueColorB3),
                                borderRadius: BorderRadius.circular(3),
                              ),

                              value: rememberMe,
                              onChanged: (bool value){
                            setState(() {
                              rememberMe = value;
                            });

                          }),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Keep me Signed in",
                        style: FontStyleUtilities.h13(
                            fontColor: ApplicationColors.black4240),
                      ),
                    ],
                  ),*/

                  const SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ForgotPasswordScreen()));
                    },
                    child: Text(
                      "${getTranslated(context, "forget_password")}",
                      textAlign: TextAlign.center,
                      style: FontStyleUtilities.hW14(
                          fontColor: ApplicationColors.black4240),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                          child: CustomElevatedButton(
                        onPressed: () async {
                          if (_forMKey.currentState.validate()) {
                            bool isEmail = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(_emailController.text);
                            bool isPhone = RegExp(
                                    r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
                                .hasMatch(_emailController.text);

                            var data = isEmail
                                ? {
                                    "emailid": _emailController.text,
                                    "psd": _passwordController.text,
                                  }
                                : isPhone
                                    ? {
                                        "ph_num": _emailController.text,
                                        "psd": _passwordController.text,
                                      }
                                    : {
                                        "user_id": _emailController.text,
                                        "psd": _passwordController.text,
                                      };

                            print(data);

                            await loginProvider.loginUser(
                              data,
                              "users/LoginWithOtp",
                              context,
                              isEmail
                                  ? "emailid"
                                  : isPhone
                                      ? "ph_num"
                                      : "user_id",
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        buttonText: '${getTranslated(context, "login")}',
                        buttonColor: ApplicationColors.redColor67,
                      )),
                    ],
                  ),
                  const SizedBox(height: 45),

                  /* GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesConstants.registerScreen);
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: translate.translate('LoginScreen_DontHaveAccount'),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: FontFamilyConstants.montserratRegular,
                                // fontWeight: FontWeight.w500
                              )),
                          TextSpan(
                            text: ' ${translate.translate('LoginScreen_SignUp')}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.heartColor,
                                fontFamily: FontFamilyConstants.montserratBold,
                                fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ),
                  )*/
                  /*   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${getTranslated(context, "newuser?")}",
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
                                      RegisterScreen()));
                        },
                        child: Text(
                          "${getTranslated(context, "signup")}",
                          textAlign: TextAlign.center,
                          style: FontStyleUtilities.hW14(
                              fontColor: ApplicationColors.redColor67),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
