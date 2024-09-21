import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/contactUs_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/CustomerSupportPages/ContactUsScreen/add_contact_us.dart';
import 'package:oneqlik/screens/ProductsFilterPage/vehicle_filter.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/utils.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key key}) : super(key: key);

  @override
  ContactUsScreenState createState() => ContactUsScreenState();
}

class ContactUsScreenState extends State<ContactUsScreen> {
  var height, width;
  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  var selectValue = "";

  ContactUsProvider contactUsProvider;
  ReportProvider _reportProvider;
  UserProvider userProvider;

  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toUtc().toString();

  getDeviceByUserDropdown() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");

    var data = {"email": email, "id": id};

    await _reportProvider.getVehicleDropdown(
        data, "devices/getDeviceByUserDropdown");
  }

  getContactUs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "user": id,
      "from": fromDate.toString(),
      "to": toDate.toString(),
    };

    print('Data-->$data');

    contactUsProvider.getContactUs(data, "customer_support/getCustomerIssues");
  }

  getUserSettings() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var data = {"uid": id};

    print('CheckGet-->$data');

    userProvider.getUserSettings(data, "users/get_user_setting", context);
  }

  contactCount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "user": "$id",
    };

    print('ContactCount-->$data');

    contactUsProvider.contactCount(data, "customer_support/getCount");
  }

  showDialogBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ApplicationColors.blackColor2E,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        titlePadding: EdgeInsets.fromLTRB(15, 15, 15, 05),
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        scrollable: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${getTranslated(context, "contact_us")}',
              textAlign: TextAlign.center,
              style: Textstyle1.text14bold.copyWith(fontSize: 18),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: ApplicationColors.blackbackcolor,
              ),
            ),
          ],
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userProvider.getUserSettingsModel.service == null &&
                          userProvider.getUserSettingsModel.support == null
                      ? Text(
                          '${getTranslated(context, "contact_number_not_available")}',
                          style:
                              Textstyle1.text10.copyWith(letterSpacing: 0.02),
                        )
                      : SizedBox(),
                  SizedBox(height: 10),
                  userProvider.getUserSettingsModel.service == null
                      ? SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: ApplicationColors.textfieldBorderColor,
                            ),
                            SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Text(
                                "${getTranslated(context, "service")}"
                                    .toUpperCase(),
                                style: Textstyle1.text14
                                    .copyWith(letterSpacing: 0.02),
                              ),
                            ),
                            SizedBox(height: 3),
                            Divider(
                              color: ApplicationColors.textfieldBorderColor,
                            ),
                          ],
                        ),
                  userProvider.getUserSettingsModel.service == null
                      ? SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: userProvider.getUserSettingsModel.service
                              .map((e) {
                            return InkWell(
                              onTap: () async {
                                String url = 'tel:' + e;
                                await launch(url);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/PhoneCall.png",
                                      width: 26,
                                      height: 26,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "$e",
                                      style: Textstyle1.text14.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                  userProvider.getUserSettingsModel.support == null
                      ? SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                              child: Text(
                                "${getTranslated(context, "support")}"
                                    .toUpperCase(),
                                style: Textstyle1.text14
                                    .copyWith(letterSpacing: 0.02),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: 10),
                  userProvider.getUserSettingsModel.support == null
                      ? SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: userProvider.getUserSettingsModel.support
                              .map((e) {
                            return InkWell(
                              onTap: () async {
                                String url = 'tel:' + e;
                                await launch(url);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 10, 10),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/PhoneCall.png",
                                      color: ApplicationColors.redColor67,
                                      width: 26,
                                      height: 26,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "$e",
                                      style: Textstyle1.text14.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    contactUsProvider = Provider.of<ContactUsProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    datedController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy-hh:mm a").format(DateTime.now())}";
    _endDateController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy-hh:mm a").format(DateTime.now())}";
    contactUsProvider.contactUsList.clear();
    getContactUs();
    getDeviceByUserDropdown();
    contactCount();
    getUserSettings();
  }

  @override
  Widget build(BuildContext context) {
    contactUsProvider = Provider.of<ContactUsProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    userProvider = Provider.of<UserProvider>(context, listen: true);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: /*FloatingActionButton(*/

          Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            isExtended: true,
            backgroundColor: ApplicationColors.whiteColor,
            onPressed: () async {
              showDialogBox();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/contact_icon.png",
              ),
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            isExtended: true,
            backgroundColor: Color(0xfff70d40),
            onPressed: () async {
              var value = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AddContact(),
                ),
              );
              if (value != null) {
                setState(() {
                  datedController = TextEditingController()
                    ..text =
                        "${DateFormat("dd MMM yyyy").format(DateTime.now())}";
                  _endDateController = TextEditingController()
                    ..text =
                        "${DateFormat("dd MMM yyyy").format(DateTime.now())}";
                  selectValue = "";
                });
              }
            },
            child: Icon(Icons.add, color: ApplicationColors.whiteColor),
          ),
          SizedBox(height: 15),
        ],
      ),
      backgroundColor: Colors.white,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_sharp,
            color: ApplicationColors.whiteColor,
            size: 26,
          ),
        ),
        title: Text(
          '${getTranslated(context, "contact_us")}',
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 20,
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
      body:
          // contactUsProvider.isContactCountLoading || contactUsProvider.isContactLoading || userProvider.isUserSetingsLoading
          //     ?
          //     Helper.dialogCall.showLoader()
          //     :
          Column(
        children: [
          Container(
            decoration: BoxDecoration(color: ApplicationColors.blackColor2E),
            //height: height*.074,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "From Date",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black,
                              ),
                            ),
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.red,
                              ),
                              keyboardType: TextInputType.number,
                              controller: datedController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                dateTimeSelect();
                                // setState(() {
                                //   datedController.text = DateFormat("dd MMM yyyy").format(dateTimeSelect());
                                // });
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                hintText:
                                    '${getTranslated(context, "from_date")}',
                                hintStyle: Textstyle1.signupText1,
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "To Date",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black,
                              ),
                            ),
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.red,
                              ),
                              keyboardType: TextInputType.number,
                              controller: _endDateController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                endDateTimeSelect();
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                hintText:
                                    '${getTranslated(context, "end_date")}',
                                hintStyle: Textstyle1.signupText1,
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectValue = "OPEN";
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Color(0xff86e52f),
                        shape: BoxShape.circle,
                      ),
                      child: contactUsProvider.body != null
                          ? Text(
                              "${contactUsProvider.body["OPEN"]}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Textstyle1.text18boldwhite,
                            )
                          : Text(
                              '0',
                              style: Textstyle1.text18boldwhite,
                            ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${getTranslated(context, "open_capital_word")}',
                    style: Textstyle1.text14,
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectValue = "IN PROGRESS";
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Color(0xffe9b511),
                        shape: BoxShape.circle,
                      ),
                      child: contactUsProvider.body != null
                          ? Text(
                              "${contactUsProvider.body["WIP"]}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Textstyle1.text18boldwhite,
                            )
                          : Text(
                              '0',
                              style: Textstyle1.text18boldwhite,
                            ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${getTranslated(context, "in_progress")}',
                    style: Textstyle1.text14,
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectValue = "CLOSE";
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Color(0xffef6447),
                        shape: BoxShape.circle,
                      ),
                      child: contactUsProvider.body != null
                          ? Text(
                              "${contactUsProvider.body["CLOSED"]}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Textstyle1.text18boldwhite,
                            )
                          : Text(
                              '0',
                              style: Textstyle1.text18boldwhite,
                            ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${getTranslated(context, "closed_capital_word")}',
                    style: Textstyle1.text14,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 2,
                    color: selectValue == "OPEN"
                        ? ApplicationColors.redColor67
                        : ApplicationColors.dropdownColor3D,
                  ),
                ),
                Container(
                  width: selectValue == "CLOSE" ? 20 : 15,
                  height: 2,
                  color: ApplicationColors.dropdownColor3D,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    color: selectValue == "CLOSE"
                        ? ApplicationColors.redColor67
                        : ApplicationColors.dropdownColor3D,
                  ),
                ),
                Container(
                  width: selectValue == "IN PROGRESS" ? 00 : 35,
                  height: 2,
                  color: ApplicationColors.dropdownColor3D,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    color: selectValue == "IN PROGRESS"
                        ? ApplicationColors.redColor67
                        : ApplicationColors.dropdownColor3D,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: contactUsProvider.isContactLoading &&
                    _reportProvider.isDropDownLoading
                ? Helper.dialogCall.showLoader()
                : contactUsProvider.contactUsList.isEmpty
                    ? Center(
                        child: Text(
                          '${getTranslated(context, "contact_not_available")}',
                          textAlign: TextAlign.center,
                          style: Textstyle1.text18.copyWith(
                            fontSize: 18,
                            color: ApplicationColors.redColor67,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 90),
                        itemCount: contactUsProvider.contactUsList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          var list = contactUsProvider.contactUsList[i];
                          print(selectValue);
                          return list.supportStatus == selectValue
                              ? Container(
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: Boxdec.conrad6colorblack,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: list.supportStatus == "CLOSE"
                                                ? ApplicationColors.redColor67
                                                : list.supportStatus == "OPEN"
                                                    ? ApplicationColors
                                                        .greenColor370
                                                    : ApplicationColors
                                                        .yellowColorD21,
                                            size: 15,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "${list.ticketId}",
                                              style: Textstyle1.text14bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${DateFormat("dd MMM yyyy").format(list.postedOn)}",
                                            style: Textstyle1.text11,
                                          ),
                                        ],
                                      ),

                                      /*SizedBox(height: 10),

                        Row(
                          children: [
                            Image.asset(
                              "assets/images/car_icon.png",
                              width: 20,
                              height: 20,
                            ),

                            SizedBox(width: 20),

                            Text(
                              "${list.id}",
                              style: Textstyle1.text12,
                            )
                          ],
                        ),
*/
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "${list.message}",
                                        style: Textstyle1.text10,
                                      )
                                    ],
                                  ),
                                )
                              : selectValue == ""
                                  ? Container(
                                      padding: EdgeInsets.all(20),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: Boxdec.conrad6colorblack,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color: list.supportStatus ==
                                                        "CLOSE"
                                                    ? ApplicationColors
                                                        .redColor67
                                                    : list.supportStatus ==
                                                            "OPEN"
                                                        ? ApplicationColors
                                                            .greenColor370
                                                        : ApplicationColors
                                                            .yellowColorD21,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${list.ticketId}",
                                                  style: Textstyle1.text14bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${DateFormat("dd MMM yyyy").format(list.postedOn)}",
                                                style: Textstyle1.text11,
                                              ),
                                            ],
                                          ),

                                          /*SizedBox(height: 10),

                        Row(
                          children: [
                            Image.asset(
                              "assets/images/car_icon.png",
                              width: 20,
                              height: 20,
                            ),

                            SizedBox(width: 20),

                            Text(
                              "${list.id}",
                              style: Textstyle1.text12,
                            )
                          ],
                        ),
*/
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            "${list.message}",
                                            style: Textstyle1.text10,
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox();
                        }),
          ),
        ],
      ),
    );
  }

  DateTime date;
  TimeOfDay time;

  DateTime fromDatePicked = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.now();

  DateTime endDatePicked = DateTime.now();
  TimeOfDay endPickedTime = TimeOfDay.now();

  dateTimeSelect() async {
    date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.redColor67,
              onPrimary: Colors.white,
              surface: ApplicationColors.redColor67,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    );

    time = await showTimePicker(
      context: context,
      initialTime: pickedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.grey,
              onPrimary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: ApplicationColors.whiteColor,
          ),
          child: child,
        );
      },
    );

    if (date != null) {
      setState(() {
        this.fromDatePicked =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        datedController.text =
            "${DateFormat("dd MMM yyyy hh:mm aa").format(fromDatePicked)}";
        fromDate = datedController.text;
      });

      if (datedController.text.isNotEmpty) {
        getContactUs();
      }
    }
  }

  endDateTimeSelect() async {
    date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.redColor67,
              onPrimary: Colors.white,
              surface: ApplicationColors.redColor67,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    );

    time = await showTimePicker(
      context: context,
      initialTime: endPickedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey,
              onPrimary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    );

    if (date != null) {
      setState(() {
        this.endDatePicked =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        _endDateController.text =
            "${DateFormat("dd MMM yyyy hh:mm aa").format(endDatePicked)}";
        toDate = _endDateController.text;
      });

      if (_endDateController.text.isNotEmpty) {
        getContactUs();
      }
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
