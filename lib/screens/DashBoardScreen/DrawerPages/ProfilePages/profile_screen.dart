import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/Authentication/ChangePasswordScreen/change_password_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ProfilePages/edit_account_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ProfilePages/settings_screen.dart';
import 'package:oneqlik/screens/Authentication/LoginScreen/login_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ProfilePages/setting_notifications.dart';
import 'package:oneqlik/screens/DashBoardScreen/provider_screen.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Provider/login_provider.dart';
import '../../../../components/styleandborder.dart';
import '../../../../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  UserProvider userProvider;
  LoginProvider loginProvider;

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
    };

    await userProvider.getUserData(data, "users/getCustumerDetail", context);
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    loginProvider = Provider.of<LoginProvider>(context, listen: true);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
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
          "${userProvider.useModel.cust.firstName} ${userProvider.useModel.cust.lastName}",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Arial',
            color: ApplicationColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditAccountScreen()));
              },
              child: Image.asset(
                "assets/images/pencil_line.png",
                color: ApplicationColors.whiteColor,
                width: 29,
                height: 29,
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
        child: Container(
          child: Column(
            children: [
              Container(
                width: width,
                color: ApplicationColors.greyC4C4.withOpacity(0.4),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Container(
                      color: ApplicationColors.whiteColor,
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl:
                                "${Utils.http}${Utils.baseUrl}${userProvider.userImage}",
                            width: 45,
                            height: 45,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress)),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/images/profile_icon.png'),
                          ),
                        ),
                        title: Text(
                            "${userProvider.useModel.cust.firstName} ${userProvider.useModel.cust.lastName}"),
                        subtitle: Text(
                            "Account ${userProvider.useModel.cust.userId}"),
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      color: ApplicationColors.whiteColor,
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProviderScreen()));
                            },
                            leading: Icon(
                              Icons.person,
                              color: ApplicationColors.black4240,
                              size: 28,
                            ),
                            title: Text(
                              "${getTranslated(context, "service provider")}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Arial',
                                color: ApplicationColors.blackColor00,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: 75,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Setting_Notifications()));
                            },
                            leading: Icon(
                              Icons.notifications,
                              color: ApplicationColors.black4240,
                              size: 28,
                            ),
                            title: Text(
                              "${getTranslated(context, "notification")}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Arial',
                                color: ApplicationColors.blackColor00,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: 75,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangePasswordScreen()));
                            },
                            leading: Icon(
                              Icons.lock,
                              color: ApplicationColors.black4240,
                              size: 28,
                            ),
                            title: Text(
                              "${getTranslated(context, "reset_password_setting")}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Arial',
                                color: ApplicationColors.blackColor00,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      color: ApplicationColors.whiteColor,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SettingsPage()));
                        },
                        leading: Icon(
                          Icons.settings,
                          color: ApplicationColors.black4240,
                          size: 28,
                        ),
                        title: Text(
                          "${getTranslated(context, "setting")}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Arial',
                            color: ApplicationColors.blackColor00,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: ApplicationColors.blackColor2E,
                      title: Text(
                        "${getTranslated(context, "are_you_sure")}",
                        style: Textstyle1.text14bold,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            "${getTranslated(context, "no")}",
                            style: Textstyle1.text12b,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();

                            var token = sharedPreferences.getString("fbToken");
                            var id = sharedPreferences.getString("uid");

                            var sendData = {
                              "os": Platform.isAndroid ? "android" : "iso",
                              "token": "$token",
                              "uid": "$id"
                            };
                            await loginProvider.removeFirebaseToken(
                              sendData,
                              "users/PullNotification",
                              context,
                              true,
                            );
                            Navigator.pushAndRemoveUntil<void>(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const LoginScreen()),
                              ModalRoute.withName('/'),
                            );
                            sharedPreferences.clear();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            "${getTranslated(context, "yes")}",
                            style: Textstyle1.text12b,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 6),
                    Text(
                      "${getTranslated(context, "logout")}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.90 - 55,
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //     color: ApplicationColors.containercolor.withOpacity(0.2),
              //   ),
              //   child: SingleChildScrollView(
              //     physics: BouncingScrollPhysics(),
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 24, right: 24),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: [
              //           SizedBox(height: 100),
              //           Stack(
              //             clipBehavior: Clip.none,
              //             children: [
              //               Container(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 108, top: 8, right: 10),
              //                       child: Row(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         children: [
              //                           Text(
              //                               "${getTranslated(context, "account")}",
              //                               style: FontStyleUtilities.h18(
              //                                   fontColor: ApplicationColors
              //                                       .blackColor00)),
              //                           InkWell(
              //                             onTap: () {
              //                               Navigator.push(
              //                                   context,
              //                                   MaterialPageRoute(
              //                                       builder: (BuildContext
              //                                               context) =>
              //                                           EditAccountScreen()));
              //                             },
              //                             child: Image.asset(
              //                               "assets/images/pencil_line.png",
              //                               color: ApplicationColors.redColor67,
              //                               width: 29,
              //                               height: 29,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 25, top: 42, bottom: 8),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                               "${getTranslated(context, "name")}",
              //                               style: FontStyleUtilities.h12(
              //                                   fontColor: ApplicationColors
              //                                       .textColorA6)),
              //                           SizedBox(height: 3),
              //                           Text(
              //                               '${userProvider.useModel.cust.firstName} ${userProvider.useModel.cust.lastName}',
              //                               overflow: TextOverflow.ellipsis,
              //                               textAlign: TextAlign.start,
              //                               maxLines: 1,
              //                               style: FontStyleUtilities.h14(
              //                                   fontColor: ApplicationColors
              //                                       .appColors1)),
              //                         ],
              //                       ),
              //                     ),
              //                     Divider(
              //                       color:
              //                           ApplicationColors.textfieldBorderColor,
              //                       thickness: 1,
              //                       endIndent: 0.0,
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 25, top: 13, bottom: 8),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             "${getTranslated(context, "userid")}",
              //                             style: FontStyleUtilities.h12(
              //                                 fontColor: ApplicationColors
              //                                     .textColorA6),
              //                           ),
              //                           SizedBox(height: 3),
              //                           Text(
              //                               '${userProvider.useModel.cust.userId}',
              //                               overflow: TextOverflow.ellipsis,
              //                               maxLines: 1,
              //                               textAlign: TextAlign.start,
              //                               style: FontStyleUtilities.h14(
              //                                   fontColor: ApplicationColors
              //                                       .appColors1)),
              //                         ],
              //                       ),
              //                     ),
              //                     Divider(
              //                       color:
              //                           ApplicationColors.textfieldBorderColor,
              //                       thickness: 1,
              //                       endIndent: 0.0,
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 25, top: 13, bottom: 8),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                               "Email",
              //                               style: FontStyleUtilities.h12(
              //                                   fontColor: ApplicationColors
              //                                       .textColorA6)),
              //                           SizedBox(height: 3),
              //                           Text(
              //                               '${userProvider.useModel.cust.email}',
              //                               overflow: TextOverflow.ellipsis,
              //                               maxLines: 1,
              //                               textAlign: TextAlign.start,
              //                               style: FontStyleUtilities.h14(
              //                                   fontColor: ApplicationColors
              //                                       .appColors1)),
              //                         ],
              //                       ),
              //                     ),
              //                     Divider(
              //                       color:
              //                           ApplicationColors.textfieldBorderColor,
              //                       thickness: 1,
              //                       endIndent: 0.0,
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 25, top: 13, bottom: 8),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                               "${getTranslated(context, "mobile_number")}",
              //                               style: FontStyleUtilities.h12(
              //                                   fontColor: ApplicationColors
              //                                       .textColorA6)),
              //                           SizedBox(height: 3),
              //                           Text(
              //                               '${userProvider.useModel.cust.phone}',
              //                               overflow: TextOverflow.ellipsis,
              //                               maxLines: 1,
              //                               textAlign: TextAlign.start,
              //                               style: FontStyleUtilities.h14(
              //                                   fontColor: ApplicationColors
              //                                       .appColors1)),
              //                         ],
              //                       ),
              //                     ),
              //                     Divider(
              //                       color:
              //                           ApplicationColors.textfieldBorderColor,
              //                       thickness: 1,
              //                       endIndent: 0.0,
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 25, top: 13, bottom: 8),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                               "${getTranslated(context, "address")}",
              //                               style: FontStyleUtilities.h12(
              //                                   fontColor: ApplicationColors
              //                                       .textColorA6)),
              //                           SizedBox(height: 3),
              //                           Text(
              //                               '${userProvider.useModel.cust.address}',
              //                               overflow: TextOverflow.ellipsis,
              //                               maxLines: 2,
              //                               textAlign: TextAlign.start,
              //                               style: FontStyleUtilities.h14(
              //                                   fontColor: ApplicationColors
              //                                       .appColors1)),
              //                         ],
              //                       ),
              //                     ),
              //                     Divider(
              //                       color:
              //                           ApplicationColors.textfieldBorderColor,
              //                       thickness: 1,
              //                       endIndent: 0.0,
              //                     ),
              //                     /*Padding(
              //                               padding: const EdgeInsets.only(left: 25,top: 13,bottom: 8),
              //                               child: Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   Text(
              //                                       "${getTranslated(context, "working_hours")}",
              //                                       style: FontStyleUtilities.h12(
              //                                           fontColor: ApplicationColors.textColorA6)
              //                                   ),
              //                                   SizedBox(height: 3),
              //                                   Text(
              //                                       '${getTranslated(context, "digital_input")} ${ userProvider.useModel.cust.digitalInput}',
              //                                       overflow:TextOverflow.ellipsis,
              //                                       maxLines: 2,
              //                                       textAlign: TextAlign.start,
              //                                       style: FontStyleUtilities.h14(
              //                                           fontColor: ApplicationColors.appColors1
              //                                       )
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                             Divider(
              //                               color: ApplicationColors.textfieldBorderColor,
              //                               thickness: 1,
              //                               endIndent: 0.0,
              //                             ),*/
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                         left: 25,
              //                         top: 13,
              //                         bottom: 8,
              //                       ),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                               "${getTranslated(context, "time_zone")}",
              //                               style: FontStyleUtilities.h12(
              //                                   fontColor: ApplicationColors
              //                                       .textColorA6)),
              //                           SizedBox(height: 3),
              //                           Text(
              //                               '${userProvider.useModel.cust.timezone}',
              //                               overflow: TextOverflow.ellipsis,
              //                               maxLines: 2,
              //                               textAlign: TextAlign.start,
              //                               style: FontStyleUtilities.h14(
              //                                   fontColor: ApplicationColors
              //                                       .appColors1)),
              //                         ],
              //                       ),
              //                     ),
              //                     SizedBox(height: 10)
              //                   ],
              //                 ),
              //                 decoration: BoxDecoration(
              //                   color: ApplicationColors.blackColor2E,
              //                   borderRadius: BorderRadius.circular(20),
              //                 ),
              //               ),
              //               Positioned(
              //                 top: -25,
              //                 left: 25,
              //                 child: Container(
              //                   width: 70,
              //                   height: 70,
              //                   padding: EdgeInsets.all(14),
              //                   child:
              //                       Image.asset("assets/images/account_ic.png"),
              //                   decoration: const BoxDecoration(
              //                     shape: BoxShape.circle,
              //                     color: ApplicationColors.redColor67,
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           const SizedBox(height: 42),
              //           Stack(
              //             clipBehavior: Clip.none,
              //             children: [
              //               Container(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 108, top: 8, right: 27),
              //                       child: InkWell(
              //                         onTap: () {
              //                           Navigator.push(
              //                               context,
              //                               MaterialPageRoute(
              //                                   builder:
              //                                       (BuildContext context) =>
              //                                           SettingsPage()));
              //                         },
              //                         child: Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.spaceBetween,
              //                           children: [
              //                             Text(
              //                               "${getTranslated(context, "setting")}",
              //                               style: FontStyleUtilities.h18(
              //                                   fontColor: ApplicationColors
              //                                       .appColors1),
              //                             ),
              //                             Image.asset(
              //                               "assets/images/vector_ic.png",
              //                               width: 6,
              //                               height: 11,
              //                               color: ApplicationColors.redColor67,
              //                             )
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 25, top: 42, bottom: 7),
              //                       child: Row(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.start,
              //                         children: [
              //                           Container(
              //                             width: 41,
              //                             height: 41,
              //                             padding: EdgeInsets.all(10),
              //                             child: Image.asset(
              //                                 "assets/images/reset_password_ic.png"),
              //                             decoration: BoxDecoration(
              //                               shape: BoxShape.circle,
              //                               color: ApplicationColors.redColor67,
              //                             ),
              //                           ),
              //                           SizedBox(width: 16),
              //                           InkWell(
              //                               onTap: () {
              //                                 Navigator.push(
              //                                     context,
              //                                     MaterialPageRoute(
              //                                         builder: (BuildContext
              //                                                 context) =>
              //                                             ChangePasswordScreen()));
              //                               },
              //                               child: Text(
              //                                   "${getTranslated(context, "reset_password_setting")}",
              //                                   overflow: TextOverflow.ellipsis,
              //                                   maxLines: 1,
              //                                   style: FontStyleUtilities.h14(
              //                                       fontColor: ApplicationColors
              //                                           .appColors1))),
              //                         ],
              //                       ),
              //                     ),
              //                     Divider(
              //                       color:
              //                           ApplicationColors.textfieldBorderColor,
              //                       thickness: 1,
              //                       endIndent: 0.0,
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 25,
              //                           top: 13,
              //                           bottom: 7,
              //                           right: 27),
              //                       child: InkWell(
              //                         onTap: () {
              //                           Navigator.push(
              //                               context,
              //                               MaterialPageRoute(
              //                                   builder: (context) =>
              //                                       Setting_Notifications()));
              //                         },
              //                         child: Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.start,
              //                           children: [
              //                             Container(
              //                               width: 41,
              //                               height: 41,
              //                               padding: EdgeInsets.all(10),
              //                               child: Image.asset(
              //                                 "assets/images/notify_ic.png",
              //                               ),
              //                               decoration: BoxDecoration(
              //                                 shape: BoxShape.circle,
              //                                 color:
              //                                     ApplicationColors.redColor67,
              //                               ),
              //                             ),
              //                             SizedBox(width: 16),
              //                             Text(
              //                                 "${getTranslated(context, "notification")}",
              //                                 overflow: TextOverflow.ellipsis,
              //                                 maxLines: 1,
              //                                 style: FontStyleUtilities.h14(
              //                                     fontColor: ApplicationColors
              //                                         .appColors1)),
              //                             Spacer(),
              //                             Image.asset(
              //                               "assets/images/vector_ic.png",
              //                               width: 6,
              //                               height: 11,
              //                               color: ApplicationColors.redColor67,
              //                             )
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                     Divider(
              //                       color:
              //                           ApplicationColors.textfieldBorderColor,
              //                       thickness: 1,
              //                       endIndent: 0.0,
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 25, top: 13, bottom: 25),
              //                       child: Row(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.start,
              //                         children: [
              //                           Container(
              //                             width: 41,
              //                             height: 41,
              //                             padding: EdgeInsets.all(10),
              //                             child: Image.asset(
              //                                 "assets/images/help_feedback_ic.png"),
              //                             decoration: BoxDecoration(
              //                               shape: BoxShape.circle,
              //                               color: ApplicationColors.redColor67,
              //                             ),
              //                           ),
              //                           SizedBox(width: 16),
              //                           Text(
              //                               "${getTranslated(context, "help_&_feedback")}",
              //                               overflow: TextOverflow.ellipsis,
              //                               maxLines: 1,
              //                               style: FontStyleUtilities.h14(
              //                                   fontColor: ApplicationColors
              //                                       .appColors1)),
              //                         ],
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 decoration: BoxDecoration(
              //                   color: ApplicationColors.blackColor2E,
              //                   borderRadius: BorderRadius.circular(20),
              //                 ),
              //               ),
              //               Positioned(
              //                 top: -25,
              //                 left: 25,
              //                 child: Container(
              //                   width: 70,
              //                   height: 70,
              //                   padding: EdgeInsets.all(14),
              //                   child: Image.asset(
              //                       "assets/images/setting_icon.png"),
              //                   decoration: BoxDecoration(
              //                     shape: BoxShape.circle,
              //                     color: ApplicationColors.redColor67,
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           const SizedBox(height: 30),
              //           Row(
              //             children: [
              //               Expanded(
              //                   child: CustomElevatedButton(
              //                 onPressed: () async {
              //                   Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                           builder: (BuildContext context) =>
              //                               LoginScreen()));
              //                 },
              //                 buttonText:
              //                     "${getTranslated(context, "sign_out")}",
              //                 buttonColor: ApplicationColors.redColor67,
              //               )),
              //             ],
              //           ),
              //           SizedBox(height: height * 0.2),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Container(
              //   height: 20,
              //   width: 20,
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: Image.asset("assets/images/vector_icon.png",
              //         color: ApplicationColors.redColor67,
              //         width: 78,
              //         height: 70),
              //   ),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(10),
              //       topRight: Radius.circular(10),
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Center(
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(100),
              //       child: CachedNetworkImage(
              //         imageUrl:
              //             "${Utils.http}${Utils.baseUrl}${userProvider.userImage}",
              //         width: 120,
              //         height: 120,
              //         fit: BoxFit.fill,
              //         progressIndicatorBuilder:
              //             (context, url, downloadProgress) => Center(
              //                 child: CircularProgressIndicator(
              //                     value: downloadProgress.progress)),
              //         errorWidget: (context, url, error) =>
              //             Image.asset('assets/images/profile_icon.png'),
              //       ),
              //     ),
              //   ),
              //   decoration: BoxDecoration(
              //     // color: ApplicationColors.appColors1,
              //     shape: BoxShape.circle,
              //     border:
              //         Border.all(color: ApplicationColors.black4240, width: 1),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
