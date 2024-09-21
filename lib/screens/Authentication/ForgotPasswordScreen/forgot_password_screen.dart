
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneqlik/Provider/login_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/Authentication/ForgotPasswordScreen/get_code_screen.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
   const ForgotPasswordScreen({Key key}) : super(key: key);

   @override
   _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
 }

 class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {


  TextEditingController _forgotPasswordController = TextEditingController();

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  LoginProvider loginProvider;

  generateOtp() async {
    var data = {
      "cred":_forgotPasswordController.text
    };

    await loginProvider.forgetPassword(data, "users/forgotpwd", context);
    if(loginProvider.isForgotSuccess){
      Navigator.push(
          context,
        MaterialPageRoute(
          builder: (BuildContext context)=>
              GetCodeScreen(phone:_forgotPasswordController.text),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loginProvider =Provider.of<LoginProvider>(context,listen: false);
  }


   @override
   Widget build(BuildContext context) {
     loginProvider =Provider.of<LoginProvider>(context,listen: true);
     final height = MediaQuery.of(context).size.height;

     final width = MediaQuery.of(context).size.width;

     return Scaffold(
       body: Container(
         height: height,
         width: width,
         decoration: BoxDecoration(
             color: ApplicationColors.whiteColorF9
         ),
         child: SingleChildScrollView(
           physics: BouncingScrollPhysics(),
           child: Padding(
             padding: EdgeInsets.symmetric(horizontal: 49),
             child: Form(
               key: _forMKey,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   SizedBox(height: height*0.1),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(
                         '${getTranslated(context, "Forgot_password")}',
                           style: FontStyleUtilities.h24(
                             fontColor: ApplicationColors.black4240,
                           ),
                       ),

                     ],
                   ),
                   SizedBox(height: height*0.06),
                   Image.asset(
                     "assets/images/forgot_password.png",
                     height: height * 0.25,
                   ),
                   SizedBox(height: height*0.05),
                   Text(
                     "${getTranslated(context, "send_code")}",
                     style: FontStyleUtilities.h14(fontColor: ApplicationColors.black4240),
                     textAlign: TextAlign.center,
                     maxLines: 3,
                     overflow: TextOverflow.ellipsis,
                   ),
                   SizedBox(height: height*0.07),
                   CustomTextField(
                     hintStyle: TextStyle(color: ApplicationColors.black4240),
                     textAlign: TextAlign.start,
                     keyboardType: TextInputType.emailAddress,
                     controller: _forgotPasswordController,
                     hintText: 'Phone number',
                 /*    validator: (value) {
                       bool validEmail = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value ?? '');
                       if (value == null || value == '') {
                         return "Enter phone number";
                       } else if (validEmail ==
                           false) {
                         return "Enter phone number";
                       }
                       return null;
                     },*/
                   ),
                    SizedBox(height: height*0.1),
                   Row(
                     children: [
                       Expanded(
                           child: CustomElevatedButton(
                             onPressed: () async {
                               if(_forMKey.currentState.validate()){
                                 generateOtp();
                               }
                             },
                             buttonText: '${getTranslated(context, "get_code")}',
                             buttonColor: ApplicationColors.redColor67,
                           )
                       ),
                     ],
                   ),
                 ],
               ),
             ),
           ),
         ),
       ),
     );
   }

 }
