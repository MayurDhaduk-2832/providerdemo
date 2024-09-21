import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting_Notifications extends StatefulWidget {
  const Setting_Notifications({Key key}) : super(key: key);

  @override
  _Setting_NotificationsState createState() => _Setting_NotificationsState();
}

class _Setting_NotificationsState extends State<Setting_Notifications> {
  bool floationAlert = false;
  bool voiceAlert = false;
  bool smsAlert = false;
  bool emailAlert = false;

  List icons = [
    'assets/images/voice_notification_ic.png',
    'assets/images/setting_icon_vehicle_lis.png',
    'assets/images/Poi_report_icon.png',
    'assets/images/Electricity_icon.png',
    'assets/images/petrol_icon_.png',
    'assets/images/geofence_reports.png',
    'assets/images/OverSpeed_report_icon.png',
    'assets/images/ac_reports_icon.png',
    'assets/images/route_icon.png',
    'assets/images/Stop.png',
    'assets/images/Sos_reeports_icon.png',
    'assets/images/message.png',
    'assets/images/Battery.png',
    'assets/images/Battery.png',
    'assets/images/traced_icon.png',
    'assets/images/toll_icon.png',
    'assets/images/break_icon.png',
    'assets/images/harshacceler_icon.png',
    'assets/images/Stop.png',
    'assets/images/Idle_reports.png',
    'assets/images/thief.png'
  ];

  List name = [
    'Voice Notification',
    'IGN',
    'POI',
    'Power',
    'Fual',
    'Geo',
    'Overspeed',
    'AC',
    'Route',
    'Maxstop',
    'SOS',
    'SMS',
    'Vibration',
    'Low battery',
    'Acc alarm',
    'Toll',
    'Harsh break',
    'Harshacceler action',
    'Over stopped',
    'Over idle',
    'theft'
  ];

  var selectedValue = "";

  UserProvider userProvider;

  updateUserNotifications() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "contactid": "$id",
      "alert": {
        "ign": {
          "phones": [],
          "phone": [],
          "emails": [],
          "priority": userProvider.useModel.cust.alert['ign'].priority,
          "notif_status": selectedValue == "IGN"
              ? floationAlert
              : userProvider.useModel.cust.alert["ign"].notifStatus,
          "sms_status": selectedValue == "IGN"
              ? smsAlert
              : userProvider.useModel.cust.alert["ign"].smsStatus,
          "email_status": selectedValue == "IGN"
              ? emailAlert
              : userProvider.useModel.cust.alert["ign"].emailStatus
        },
        "poi": {
          "phones": [],
          "emails": [],
          "priority": userProvider.useModel.cust.alert["poi"].priority,
          "notif_status": selectedValue == "POI"
              ? floationAlert
              : userProvider.useModel.cust.alert["poi"].notifStatus,
          "sms_status": selectedValue == "POI"
              ? smsAlert
              : userProvider.useModel.cust.alert["poi"].smsStatus,
          "email_status": selectedValue == "POI"
              ? emailAlert
              : userProvider.useModel.cust.alert["poi"].emailStatus
        },
        "power": {
          "phones": [],
          "emails": [],
          "priority": userProvider.useModel.cust.alert["power"].priority,
          "notif_status": selectedValue == "Power"
              ? floationAlert
              : userProvider.useModel.cust.alert["power"].notifStatus,
          "sms_status": selectedValue == "Power"
              ? smsAlert
              : userProvider.useModel.cust.alert["power"].smsStatus,
          "email_status": selectedValue == "Power"
              ? emailAlert
              : userProvider.useModel.cust.alert["power"].emailStatus
        },
        "fuel": {
          "phones": [],
          "emails": [],
          "priority": userProvider.useModel.cust.alert["fuel"].priority,
          "notif_status": selectedValue == "Fual"
              ? floationAlert
              : userProvider.useModel.cust.alert["fuel"].notifStatus,
          "sms_status": selectedValue == "Fual"
              ? smsAlert
              : userProvider.useModel.cust.alert["fuel"].smsStatus,
          "email_status": selectedValue == "Fual"
              ? emailAlert
              : userProvider.useModel.cust.alert["fuel"].emailStatus
        },
        "geo": {
          "phones": [],
          "emails": [],
          "priority": userProvider.useModel.cust.alert["geo"].priority,
          "notif_status": selectedValue == "Geo"
              ? floationAlert
              : userProvider.useModel.cust.alert["geo"].notifStatus,
          "sms_status": selectedValue == "Geo"
              ? smsAlert
              : userProvider.useModel.cust.alert["geo"].smsStatus,
          "email_status": selectedValue == "Geo"
              ? emailAlert
              : userProvider.useModel.cust.alert["geo"].emailStatus,
        },
        "overspeed": {
          "phones": [],
          "emails": [],
          "priority": userProvider.useModel.cust.alert["overspeed"].priority,
          "notif_status": selectedValue == "Overspeed"
              ? floationAlert
              : userProvider.useModel.cust.alert["overspeed"].notifStatus,
          "sms_status": selectedValue == "Overspeed"
              ? smsAlert
              : userProvider.useModel.cust.alert["overspeed"].smsStatus,
          "email_status": selectedValue == "Overspeed"
              ? emailAlert
              : userProvider.useModel.cust.alert["overspeed"].emailStatus,
        },
        "AC": {
          "phones": [],
          "emails": [],
          "priority": userProvider.useModel.cust.alert["AC"].priority,
          "notif_status": selectedValue == "AC"
              ? floationAlert
              : userProvider.useModel.cust.alert["AC"].notifStatus,
          "sms_status": selectedValue == "AC"
              ? smsAlert
              : userProvider.useModel.cust.alert["AC"].smsStatus,
          "email_status": selectedValue == "AC"
              ? emailAlert
              : userProvider.useModel.cust.alert["AC"].emailStatus,
        },
        "route": {
          "phones": [],
          "emails": [],
          "priority": userProvider.useModel.cust.alert["route"].priority,
          "notif_status": selectedValue == "Route"
              ? floationAlert
              : userProvider.useModel.cust.alert["route"].notifStatus,
          "sms_status": selectedValue == "Route"
              ? smsAlert
              : userProvider.useModel.cust.alert["route"].smsStatus,
          "email_status": selectedValue == "Route"
              ? emailAlert
              : userProvider.useModel.cust.alert["route"].emailStatus
        },
        "maxstop": {
          "phones": [],
          "emails": [],
          "priority": userProvider.useModel.cust.alert["maxstop"].priority,
          "notif_status": selectedValue == "Maxstop"
              ? floationAlert
              : userProvider.useModel.cust.alert["maxstop"].notifStatus,
          "sms_status": selectedValue == "Maxstop"
              ? smsAlert
              : userProvider.useModel.cust.alert["maxstop"].smsStatus,
          "email_status": selectedValue == "Maxstop"
              ? emailAlert
              : userProvider.useModel.cust.alert["maxstop"].emailStatus,
        },
        "sos": {
          "phones": [],
          "emails": [],
          "priority": userProvider.useModel.cust.alert["sos"].priority,
          "notif_status": selectedValue == "SOS"
              ? floationAlert
              : userProvider.useModel.cust.alert["sos"].notifStatus,
          "sms_status": selectedValue == "SOS"
              ? smsAlert
              : userProvider.useModel.cust.alert["sos"].smsStatus,
          "email_status": selectedValue == "SOS"
              ? emailAlert
              : userProvider.useModel.cust.alert["sos"].emailStatus,
        },
        "sms": {
          "sms_status": selectedValue == "SMS"
              ? smsAlert
              : userProvider.useModel.cust.alert["sms"].smsStatus,
          "email_status": selectedValue == "SMS"
              ? emailAlert
              : userProvider.useModel.cust.alert["sms"].emailStatus,
          "notif_status": selectedValue == "SMS"
              ? floationAlert
              : userProvider.useModel.cust.alert["sms"].notifStatus,
          "priority": userProvider.useModel.cust.alert["sms"].priority,
          "emails": [],
          "phones": []
        },
        "vibration": {
          "sms_status": selectedValue == "Vibration"
              ? smsAlert
              : userProvider.useModel.cust.alert["vibration"].smsStatus,
          "email_status": selectedValue == "Vibration"
              ? emailAlert
              : userProvider.useModel.cust.alert["vibration"].emailStatus,
          "notif_status": selectedValue == "Vibration"
              ? floationAlert
              : userProvider.useModel.cust.alert["vibration"].notifStatus,
          "priority": userProvider.useModel.cust.alert["vibration"].priority,
          "emails": [],
          "phones": []
        },
        "lowBattery": {
          "sms_status": selectedValue == "Low battery"
              ? smsAlert
              : userProvider.useModel.cust.alert["lowBattery"].smsStatus,
          "email_status": selectedValue == "Low battery"
              ? emailAlert
              : userProvider.useModel.cust.alert["lowBattery"].emailStatus,
          "notif_status": selectedValue == "Low battery"
              ? floationAlert
              : userProvider.useModel.cust.alert["lowBattery"].notifStatus,
          "priority": userProvider.useModel.cust.alert["lowBattery"].priority,
          "emails": [],
          "phones": []
        },
        "accAlarm": {
          "sms_status": selectedValue == "Acc alarm"
              ? smsAlert
              : userProvider.useModel.cust.alert["accAlarm"].smsStatus,
          "email_status": selectedValue == "Acc alarm"
              ? emailAlert
              : userProvider.useModel.cust.alert["accAlarm"].emailStatus,
          "notif_status": selectedValue == "Acc alarm"
              ? floationAlert
              : userProvider.useModel.cust.alert["accAlarm"].notifStatus,
          "priority": userProvider.useModel.cust.alert["accAlarm"].priority,
          "emails": [],
          "phones": []
        },
        "toll": {
          "sms_status": selectedValue == "Toll"
              ? smsAlert
              : userProvider.useModel.cust.alert["toll"].smsStatus,
          "email_status": selectedValue == "Toll"
              ? emailAlert
              : userProvider.useModel.cust.alert["toll"].emailStatus,
          "notif_status": selectedValue == "Toll"
              ? floationAlert
              : userProvider.useModel.cust.alert["toll"].notifStatus,
          "priority": userProvider.useModel.cust.alert["toll"].priority,
          "emails": [],
          "phones": []
        },
        "harshBreak": {
          "sms_status": selectedValue == "Harsh break"
              ? smsAlert
              : userProvider.useModel.cust.alert["harshBreak"].smsStatus,
          "email_status": selectedValue == "Harsh break"
              ? emailAlert
              : userProvider.useModel.cust.alert["harshBreak"].emailStatus,
          "notif_status": selectedValue == "Harsh break"
              ? floationAlert
              : userProvider.useModel.cust.alert["harshBreak"].notifStatus,
          "priority": userProvider.useModel.cust.alert["harshBreak"].priority,
          "emails": [],
          "phones": []
        },
        "harshAcceleration": {
          "sms_status": selectedValue == "Harshacceler action"
              ? smsAlert
              : userProvider.useModel.cust.alert["harshAcceleration"].smsStatus,
          "email_status": selectedValue == "Harshacceler action"
              ? emailAlert
              : userProvider
                  .useModel.cust.alert["harshAcceleration"].emailStatus,
          "notif_status": selectedValue == "Harshacceler action"
              ? floationAlert
              : userProvider
                  .useModel.cust.alert["harshAcceleration"].notifStatus,
          "priority":
              userProvider.useModel.cust.alert["harshAcceleration"].priority,
          "emails": [],
          "phones": []
        },
        "over_stopped": {
          "sms_status": selectedValue == "Over stopped"
              ? smsAlert
              : userProvider.useModel.cust.alert["over_stopped"].smsStatus,
          "email_status": selectedValue == "Over stopped"
              ? emailAlert
              : userProvider.useModel.cust.alert["over_stopped"].emailStatus,
          "notif_status": selectedValue == "Over stopped"
              ? floationAlert
              : userProvider.useModel.cust.alert["over_stopped"].notifStatus,
          "priority": userProvider.useModel.cust.alert["over_stopped"].priority,
          "emails": [],
          "phones": []
        },
        "over_idle": {
          "sms_status": selectedValue == "Over idle"
              ? smsAlert
              : userProvider.useModel.cust.alert["over_idle"].smsStatus,
          "email_status": selectedValue == "Over idle"
              ? emailAlert
              : userProvider.useModel.cust.alert["over_idle"].emailStatus,
          "notif_status": selectedValue == "Over idle"
              ? floationAlert
              : userProvider.useModel.cust.alert["over_idle"].notifStatus,
          "priority": userProvider.useModel.cust.alert["over_idle"].priority,
          "emails": [],
          "phones": []
        },
        "theft": {
          "sms_status": selectedValue == "theft"
              ? smsAlert
              : userProvider.useModel.cust.alert["theft"].smsStatus,
          "email_status": selectedValue == "theft"
              ? emailAlert
              : userProvider.useModel.cust.alert["theft"].emailStatus,
          "notif_status": selectedValue == "theft"
              ? floationAlert
              : userProvider.useModel.cust.alert["theft"].notifStatus,
          "priority": userProvider.useModel.cust.alert["theft"].priority,
          "emails": [],
          "phones": []
        }
      }
    };
    await userProvider.updateNotification(
        data, "users/editUserDetails", context);
  }

  var height, width;

  showDialogBox() {
    print("floationAlert ==> $floationAlert");
    print("smsAlert ==> $smsAlert");
    print("emailAlert ==> $emailAlert");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ApplicationColors.blackColor2E,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: EdgeInsets.fromLTRB(15, 15, 15, 05),
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        scrollable: true,
        title: Text(
          "${getTranslated(context, "notification")}",
          style: Textstyle1.text14bold.copyWith(fontSize: 18),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: ApplicationColors.dropdownColor3D,
                    thickness: 2,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Text(
                          "${getTranslated(context, "floating_notification")}",
                          style: Textstyle1.text14,
                        ),
                        Expanded(child: SizedBox(width: 20)),
                        FlutterSwitch(
                          toggleSize: 10,
                          padding: 2,
                          height: height * .021,
                          width: width * .09,
                          switchBorder: Border.all(color: Colors.black54),
                          activeColor: ApplicationColors.whiteColor,
                          activeToggleColor: ApplicationColors.redColor67,
                          toggleColor: ApplicationColors.black4240,
                          inactiveColor: ApplicationColors.whiteColor,
                          value: floationAlert,
                          onToggle: (val) {
                            setState(() {
                              floationAlert = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Text(
                          "${getTranslated(context, "sms_notification")}",
                          style: Textstyle1.text14,
                        ),
                        Expanded(
                          child: SizedBox(width: 20),
                        ),
                        FlutterSwitch(
                          toggleSize: 10,
                          padding: 2,
                          height: height * .021,
                          width: width * .09,
                          switchBorder: Border.all(color: Colors.black54),
                          activeColor: ApplicationColors.whiteColor,
                          activeToggleColor: ApplicationColors.redColor67,
                          toggleColor: ApplicationColors.black4240,
                          inactiveColor: ApplicationColors.whiteColor,
                          value: smsAlert,
                          onToggle: (val) {
                            setState(() {
                              smsAlert = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Text("${getTranslated(context, "email_notification")}",
                            style: Textstyle1.text14),
                        Expanded(
                            child: SizedBox(
                          width: 20,
                        )),
                        FlutterSwitch(
                          toggleSize: 10,
                          padding: 2,
                          height: height * .021,
                          width: width * .09,
                          switchBorder: Border.all(color: Colors.black54),
                          activeColor: ApplicationColors.whiteColor,
                          activeToggleColor: ApplicationColors.redColor67,
                          toggleColor: ApplicationColors.black4240,
                          inactiveColor: ApplicationColors.whiteColor,
                          value: emailAlert,
                          onToggle: (val) {
                            setState(() {
                              emailAlert = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            );
          },
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: Boxdec.buttonBoxDecRed_r6,
                    child: Center(
                      child: Text(
                        "${getTranslated(context, "cancel")}",
                        style: Textstyle1.text14boldwhite,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    updateUserNotifications();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: Boxdec.buttonBoxDecRed_r6,
                    child: Center(
                      child: Text(
                        "${getTranslated(context, "ok")}",
                        style: Textstyle1.text14boldwhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    getUserData();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    var data = {
      "uid": id,
    };

    userProvider.getUserData(data, "users/getCustumerDetail", context);
  }

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
    voiceAlert = userProvider.useModel.cust.voiceAlert;

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: ApplicationColors.whiteColorF9
              /*color: ApplicationColors.whiteColorF9*/
              ),
        ),
        Scaffold(
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
              "${getTranslated(context, "notification")}",
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
          backgroundColor: Colors.transparent,
          body: userProvider.isLoading
              ? Helper.dialogCall.showLoader()
              : Padding(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                // setState(() {
                                //   floationAlert = userProvider.useModel.cust.alert['ign'].notifStatus;
                                //   smsAlert = userProvider.useModel.cust.alert['ign'].smsStatus;
                                //   emailAlert = userProvider.useModel.cust.alert['ign'].emailStatus;
                                //   selectedValue = name[0];
                                // });
                                //
                                // showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[0],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[0],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      FlutterSwitch(
                                        toggleSize: 10,
                                        padding: 2,
                                        height: height * .021,
                                        width: width * .09,
                                        switchBorder:
                                            Border.all(color: Colors.black54),
                                        activeColor:
                                            ApplicationColors.whiteColor,
                                        activeToggleColor:
                                            ApplicationColors.redColor67,
                                        toggleColor:
                                            ApplicationColors.black4240,
                                        inactiveColor:
                                            ApplicationColors.whiteColor,
                                        value: voiceAlert,
                                        onToggle: (val) {
                                          setState(() {
                                            voiceAlert = val;
                                            setUserSetting(voiceAlert);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['ign'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['ign'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['ign'].emailStatus;
                                  selectedValue = name[1];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[1],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[1],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['poi'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['poi'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['poi'].emailStatus;
                                  selectedValue = name[2];
                                });

                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[2],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[2],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['power'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['power'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['power'].emailStatus;
                                  selectedValue = name[3];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[3],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[3],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['fuel'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['fuel'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['fuel'].emailStatus;
                                  selectedValue = name[4];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[4],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[4],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['geo'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['geo'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['geo'].emailStatus;
                                  selectedValue = name[5];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[5],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[5],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider.useModel.cust
                                      .alert['overspeed'].notifStatus;
                                  smsAlert = userProvider.useModel.cust
                                      .alert['overspeed'].smsStatus;
                                  emailAlert = userProvider.useModel.cust
                                      .alert['overspeed'].emailStatus;
                                  selectedValue = name[6];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[6],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[6],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['AC'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['AC'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['AC'].emailStatus;
                                  selectedValue = name[7];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[7],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[7],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['route'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['route'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['route'].emailStatus;
                                  selectedValue = name[8];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[8],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[8],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider.useModel.cust
                                      .alert['maxstop'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['maxstop'].smsStatus;
                                  emailAlert = userProvider.useModel.cust
                                      .alert['maxstop'].emailStatus;
                                  selectedValue = name[9];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[9],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[9],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['sos'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['sos'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['sos'].emailStatus;
                                  selectedValue = name[10];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[10],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[10],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['sms'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['sms'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['sms'].emailStatus;
                                  selectedValue = name[11];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[11],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[11],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider.useModel.cust
                                      .alert['vibration'].notifStatus;
                                  smsAlert = userProvider.useModel.cust
                                      .alert['vibration'].smsStatus;
                                  emailAlert = userProvider.useModel.cust
                                      .alert['vibration'].emailStatus;
                                  selectedValue = name[12];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[12],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[12],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider.useModel.cust
                                      .alert['lowBattery'].notifStatus;
                                  smsAlert = userProvider.useModel.cust
                                      .alert['lowBattery'].smsStatus;
                                  emailAlert = userProvider.useModel.cust
                                      .alert['lowBattery'].emailStatus;
                                  selectedValue = name[13];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[13],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[13],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider.useModel.cust
                                      .alert['accAlarm'].notifStatus;
                                  smsAlert = userProvider.useModel.cust
                                      .alert['accAlarm'].smsStatus;
                                  emailAlert = userProvider.useModel.cust
                                      .alert['accAlarm'].emailStatus;
                                  selectedValue = name[14];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[14],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[14],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['toll'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['toll'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['toll'].emailStatus;
                                  selectedValue = name[15];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[15],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[15],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider.useModel.cust
                                      .alert['harshBreak'].notifStatus;
                                  smsAlert = userProvider.useModel.cust
                                      .alert['harshBreak'].smsStatus;
                                  emailAlert = userProvider.useModel.cust
                                      .alert['harshBreak'].emailStatus;
                                  selectedValue = name[16];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[16],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[16],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider.useModel.cust
                                      .alert['harshAcceleration'].notifStatus;
                                  smsAlert = userProvider.useModel.cust
                                      .alert['harshAcceleration'].smsStatus;
                                  emailAlert = userProvider.useModel.cust
                                      .alert['harshAcceleration'].emailStatus;
                                  selectedValue = name[17];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[17],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[17],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider.useModel.cust
                                      .alert['over_stopped'].notifStatus;
                                  smsAlert = userProvider.useModel.cust
                                      .alert['over_stopped'].smsStatus;
                                  emailAlert = userProvider.useModel.cust
                                      .alert['over_stopped'].emailStatus;
                                  selectedValue = name[18];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[18],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[18],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider.useModel.cust
                                      .alert['over_idle'].notifStatus;
                                  smsAlert = userProvider.useModel.cust
                                      .alert['over_idle'].smsStatus;
                                  emailAlert = userProvider.useModel.cust
                                      .alert['over_idle'].emailStatus;
                                  selectedValue = name[19];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[19],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[19],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: ApplicationColors.blackColor2E,
                              hoverColor: ApplicationColors.blackColor2E,
                              focusColor: ApplicationColors.blackColor2E,
                              highlightColor: ApplicationColors.blackColor2E,
                              overlayColor: MaterialStateProperty.all(
                                  ApplicationColors.blackColor2E),
                              onTap: () {
                                setState(() {
                                  floationAlert = userProvider
                                      .useModel.cust.alert['theft'].notifStatus;
                                  smsAlert = userProvider
                                      .useModel.cust.alert['theft'].smsStatus;
                                  emailAlert = userProvider
                                      .useModel.cust.alert['theft'].emailStatus;
                                  selectedValue = name[20];
                                });
                                showDialogBox();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        icons[20],
                                        width: 15,
                                        height: 20,
                                        fit: BoxFit.contain,
                                        color: ApplicationColors.redColor67,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          name[20],
                                          style: Textstyle1.text18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/right_arrow_.png',
                                        width: 6,
                                        color: ApplicationColors.redColor67,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
