import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/login_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/Authentication/NewPasswordScreen/new_password_screen.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../../Provider/user_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final phone,otp;
  const ResetPasswordScreen({Key key, this.phone, this.otp}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  TextEditingController _resetPasswordController = TextEditingController();
  TextEditingController _resetConfirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  bool resetShowPassword = false;
  bool resetConfirmPassword = false;

  LoginProvider loginProvider;


  resetPassword() async {

    var data = {
      "phone":widget.phone,
      "otp":loginProvider.otp,
      "newpwd":_resetPasswordController.text,
      "cred":widget.phone
    };

    await  loginProvider.resetPassword(data, "users/forgotpwd", context);

    if(loginProvider.isReSetPSuccess){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => NewPasswordScreen(),
          ),
      );
    }

  }


  @override
  void initState() {
    super.initState();
    loginProvider = Provider.of<LoginProvider>(context,listen: false);
  }

  @override
  Widget build(BuildContext context) {

    loginProvider = Provider.of<LoginProvider>(context,listen: true);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_image.png"),
              fit: BoxFit.fill,
            )
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 49),
            child: Form(
              key: _forMKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: height *0.08),
                  Image.asset("assets/images/codepng.png", height: height * 0.25),
                   SizedBox(height: 11),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${getTranslated(context, "reset_password")}',style: FontStyleUtilities.h24(
                        fontColor: ApplicationColors.whiteColor,
                      )),
                    ],
                  ),
                  SizedBox(height: height *0.06),
                  CustomTextField(
                    controller: _resetPasswordController,
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            resetShowPassword = !resetShowPassword;
                          });
                        },
                        child: Container(
                          height: 14,
                          width: 20,
                          padding: EdgeInsets.all(14),
                          child: Image.asset(
                            !resetShowPassword
                                ? "assets/images/visible_icon.png"
                                : "assets/images/visibility_on.png",
                            color: ApplicationColors.textfieldBorderColor,
                          ),
                        )
                    ),
                    textAlign: TextAlign.start,
                    obscureText: !resetShowPassword,
                    // controller: _loginController.passwordController,
                    hintText: '${getTranslated(context, "password")} *',
                    validator: (value) {
                      FocusScope.of(context).unfocus();
                      RegExp regex =
                      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value.isEmpty) {
                        return '${getTranslated(context, "Please_enter_password")}';
                      }else if (value.length < 6) {
                          return '${getTranslated(context, "condition_password")}!';
                      } else {
                        if (!regex.hasMatch(value)) {
                          return '${getTranslated(context, "Enter_valid_Password")}';
                        } else {
                          return null;
                        }
                      }
                    }
                  ),
                  const SizedBox(height: 23),
                  CustomTextField(
                    controller: _resetConfirmPasswordController,
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            resetConfirmPassword = !resetConfirmPassword;
                          });
                        },
                        child: Container(
                          height: 14,
                          width: 20,
                          padding: EdgeInsets.all(14),
                          child: Image.asset(
                            !resetConfirmPassword
                                ? "assets/images/visible_icon.png"
                                : "assets/images/visibility_on.png",
                            color: ApplicationColors.textfieldBorderColor,
                          ),
                        )
                    ),
                    textAlign: TextAlign.start,
                    obscureText: !resetConfirmPassword,
                    // controller: _loginController.passwordController,
                    hintText: '${getTranslated(context, "confirm_password")}',
                    validator: (value) {
                      FocusScope.of(context).unfocus();
                      if (value.isEmpty) {
                        return "${getTranslated(context, "enter_confpassword")}";
                      }
                      if (_resetPasswordController.text != value) {
                        return "${getTranslated(context, "password_notmatch")}";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 21),
                  SizedBox(height: 11),
                  Text(
                    "${getTranslated(context, "password_pattern")}",
                    style: FontStyleUtilities.h13(fontColor: ApplicationColors.whiteColor),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: height * 0.15),

                  Row(
                    children: [
                      Expanded(
                          child: CustomElevatedButton(
                            onPressed: () async {
                              if(_forMKey.currentState.validate()){
                                resetPassword();
                              }
                            },
                            buttonText: '${getTranslated(context, "submit")}',
                            buttonColor: ApplicationColors.redColor67,
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),

                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
