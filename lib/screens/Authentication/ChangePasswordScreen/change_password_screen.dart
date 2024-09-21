import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/update_password_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _changeConfirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  bool oldShowPassword = false;

  bool newPassword = false;
  bool changeConfirmPassword = false;

  UpdatePasswordProvider _updatePasswordProvider;

  updatePassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var data = {
      "ID": id,
      "OLD_PASS": _oldPasswordController.text,
      "NEW_PASS": _newPasswordController.text,
    };

    print('datapwd-->$data');

    _updatePasswordProvider.updatePassword(
        data, "users/updatePassword", context);
  }

  @override
  void initState() {
    super.initState();
    _updatePasswordProvider =
        Provider.of<UpdatePasswordProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _updatePasswordProvider =
        Provider.of<UpdatePasswordProvider>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
          "${getTranslated(context, "change_password")}",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Arial',
            color: ApplicationColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () async {
                  if (_forMKey.currentState.validate()) {
                    updatePassword();

                    Helper.dialogCall.showToast(context,
                        "${getTranslated(context, "password_update")}");
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>NewPasswordScreen()));
                  }
                },
                child: Text(
                  "${getTranslated(context, "save")}",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Arial',
                    color: ApplicationColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 19, top: 10, right: 19),
          child: Form(
            key: _forMKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        obscureText: oldShowPassword,
                        controller: _oldPasswordController,
                        validator: (value) {
                          FocusScope.of(context).unfocus();
                          if (value.isEmpty) {
                            return "${getTranslated(context, "enter_oldpassword")}";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '${getTranslated(context, "old_password")}',
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
                                  oldShowPassword
                                      ? "assets/images/visible_icon.png"
                                      : "assets/images/visibility_on.png",
                                  color: ApplicationColors.textfieldBorderColor,
                                ),
                              )),
                          hintStyle:
                              TextStyle(color: ApplicationColors.black4240),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        obscureText: newPassword,
                        controller: _newPasswordController,
                        validator: (value) {
                          FocusScope.of(context).unfocus();
                          if (value.isEmpty) {
                            return "${getTranslated(context, "enter_newpassword")}";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '${getTranslated(context, "new_password")}',
                          hintStyle:
                              TextStyle(color: ApplicationColors.black4240),
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
                                  newPassword
                                      ? "assets/images/visible_icon.png"
                                      : "assets/images/visibility_on.png",
                                  color: ApplicationColors.textfieldBorderColor,
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        obscureText: changeConfirmPassword,
                        controller: _changeConfirmPasswordController,
                        validator: (value) {
                          FocusScope.of(context).unfocus();
                          if (value.isEmpty) {
                            return "${getTranslated(context, "enter_confpassword")}";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(color: ApplicationColors.black4240),
                          hintText:
                              '${getTranslated(context, "confirm_password")}',
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
                                  changeConfirmPassword
                                      ? "assets/images/visible_icon.png"
                                      : "assets/images/visibility_on.png",
                                  color: ApplicationColors.textfieldBorderColor,
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "${getTranslated(context, "password_pattern")}",
                  style: FontStyleUtilities.h13(
                      fontColor: ApplicationColors.black4240),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
