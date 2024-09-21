import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/Authentication/LoginScreen/login_screen.dart';
import 'package:oneqlik/screens/Authentication/ForgotPasswordScreen/reset_pssword_screen.dart';
import 'package:oneqlik/utils/assets_images.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key key}) : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  @override
  Widget build(BuildContext context) {

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  SizedBox(height: height *0.08),

                  Image.asset(
                      "assets/images/newpasswordpng.png",
                      height: height * 0.25,
                  ),

                  SizedBox(height: height * 0.1),

                  Text(
                      '${getTranslated(context, "password_set_successful")}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: FontStyleUtilities.h24(
                        fontColor: ApplicationColors.whiteColor,
                      ),
                  ),

                  SizedBox(height: height*0.3),

                  Row(
                    children: [
                      Expanded(
                          child: CustomElevatedButton(
                            onPressed: () async {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                    (route) => false,
                              );
                            },
                            buttonText: '${getTranslated(context, "done")}',
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
