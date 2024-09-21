import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/login_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/Authentication/ForgotPasswordScreen/reset_pssword_screen.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_text_field.dart';
import '../LoginScreen/login_screen.dart';

class GetCodeScreen extends StatefulWidget {
  final phone;
  final cred;
  GetCodeScreen({Key key, this.phone,this.cred}) : super(key: key);

  @override
  _GetCodeScreenState createState() => _GetCodeScreenState();
}

class _GetCodeScreenState extends State<GetCodeScreen> {

  LoginProvider loginProvider;
  TextEditingController otpController = TextEditingController();
  TextEditingController _resetPasswordController = TextEditingController();
  TextEditingController _resetConfirmPasswordController = TextEditingController();
  bool resetShowPassword = false;
  bool resetConfirmPassword = false;


  generateOtp() async {
    var data = {
      "cred":widget.cred,
      "phone":widget.phone
    };
    await  loginProvider.forgetPassword(data, "users/forgotpwd", context);
    if(loginProvider.isForgotSuccess){
      Helper.dialogCall.showToast(context, "OTP_ReSend_On_phone_number");
    }
  }

  newPassword() async {
    var data = {
      "cred":widget.phone,
      "phone":widget.phone,
        "otp": otpController.text,
        "newpwd": _resetPasswordController.text,
    };
    await  loginProvider.forgetPassword(data, "users/forgotpwd", context);
    if(loginProvider.isForgotSuccess){
      Helper.dialogCall.showToast(context, "Password Sucessfully Changed");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
      );

    }else{
     // Helper.dialogCall.showToast(context, "${getTranslated(context, "Wrong_OTP_try_again")}");
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: height *0.08),

                  Image.asset("assets/images/codepng.png", height: height * 0.25),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${getTranslated(context, "enter_codebelow")}',style: FontStyleUtilities.h24(
                        fontColor: ApplicationColors.whiteColor,
                      )),
                    ],
                  ),

                  SizedBox(height: 11),

                  Center(
                    child: Text(
                        '${getTranslated(context, "sent_sms")} ${widget.phone}',
                        textAlign: TextAlign.center,
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.whiteColor,
                        ),
                    ),
                  ),

                  SizedBox(height: 21),

                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text(
                        '${getTranslated(context, "reports")}',
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.redColor67,
                        ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  PinCodeTextField(
                    onChanged: (value) {},
                    autoDisposeControllers: false,
                    controller: otpController,
                    appContext: context,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    length: 6,
                    keyboardType: TextInputType.phone,
                    autoDismissKeyboard: false,
                    textStyle: TextStyle(
                      color: ApplicationColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans-SemiBold',
                    ),
                    autoFocus: true,
                    enablePinAutofill: true,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 45,
                      borderWidth: 1,
                      disabledColor: ApplicationColors.whiteColor,
                      inactiveFillColor: ApplicationColors.whiteColor,
                      activeColor: ApplicationColors.whiteColor,
                      inactiveColor: ApplicationColors.whiteColor,
                      selectedColor: ApplicationColors.whiteColor,
                      selectedFillColor: ApplicationColors.redColor67,
                      // borderRadius: BorderRadius.circular(5),
                      activeFillColor: ApplicationColors.whiteColor,
                    ),
                    animationType: AnimationType.fade,
                    animationDuration: Duration(milliseconds: 300),
                    // errorAnimationController: errorController, // Pass it here
                  ),


                  SizedBox(
                    height: 20,
                  ),

                  CustomTextField(
                    color: Colors.white,
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
                      hintText: 'New password *',
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
                  const SizedBox(height: 23),

                  InkWell(
                    onTap: (){
                    //  generateOtp();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${getTranslated(context, "Didnt_receive_the")}",
                          textAlign: TextAlign.center,
                          style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.whiteColor),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: (){
                          },
                          child: Text(
                            "${getTranslated(context, "code")}",
                            textAlign: TextAlign.center,
                            style: FontStyleUtilities.h14(
                                fontColor: ApplicationColors.redColor67),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 38,
                  ),

                  CustomElevatedButton(
                    onPressed: () async {
                      if(_resetPasswordController.text.isEmpty){
                        Helper.dialogCall.showToast(context, "Please enter new password");
                      }else if(_resetConfirmPasswordController.text.isEmpty){
                        Helper.dialogCall.showToast(context, "Please enter confirm password");
                      }else if(_resetPasswordController.text != _resetConfirmPasswordController.text ){
                        Helper.dialogCall.showToast(context, "Password Mismatched");
                      }else{
                        newPassword();
                      }


                  /*    if(otpController.text.isNotEmpty){
                        if(otpController.text == loginProvider.otp){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen(),
                            ),
                          );
                        }else{
                          Helper.dialogCall.showToast(context, "${getTranslated(context, "Wrong_OTP_try_again")}");
                        }
                      }*/
                    },
                    buttonText: '${getTranslated(context, "submit")}',
                    buttonColor: ApplicationColors.redColor67,
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
