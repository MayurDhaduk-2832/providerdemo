import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/contactUs_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../widgets/simple_text_field.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key key}) : super(key: key);

  @override
  AddContactState createState() => AddContactState();
}

class AddContactState extends State<AddContact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();
  ContactUsProvider contactUsProvider;
  ReportProvider _reportProvider;

  var vName = "", deviceIMEI = "";

  addContact() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data = {
      "user": id,
      "VehicleNo": vName,
      "DeviceIMEI": deviceIMEI,
      "email": emailController.text,
      "mobile": messageController.text,
      "msg": messageController.text
    };

    print(jsonEncode(data));

    contactUsProvider.addContact(
        data, "customer_support/post_inquiry", context);
  }

  @override
  void initState() {
    super.initState();
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    contactUsProvider = Provider.of<ContactUsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    contactUsProvider = Provider.of<ContactUsProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
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
          '${getTranslated(context, "add_contact")}',
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _forMKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Theme(
                      data: ThemeData(
                        textTheme: TextTheme(
                            subtitle1: TextStyle(color: Colors.black)),
                      ),
                      child: DropdownSearch<VehicleList>(
                        popupBackgroundColor: ApplicationColors.blackColor2E,
                        mode: Mode.DIALOG,
                        showSearchBox: true,
                        showAsSuffixIcons: true,
                        dialogMaxWidth: width,
                        // selectedItem: widget.vId,
                        popupItemBuilder: (context, item, isSelected) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              item.deviceName,
                              style: TextStyle(
                                  color: ApplicationColors.black4240,
                                  fontSize: 15,
                                  fontFamily: "Poppins-Regular",
                                  letterSpacing: 0.75),
                            ),
                          );
                        },
                        searchFieldProps: TextFieldProps(
                          style: TextStyle(
                              color: ApplicationColors.black4240,
                              fontSize: 15,
                              fontFamily: "Poppins-Regular",
                              letterSpacing: 0.75),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: ApplicationColors.textfieldBorderColor,
                                  width: 1,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: ApplicationColors.textfieldBorderColor,
                                width: 1,
                              ),
                            ),
                            hintText:
                                '${getTranslated(context, "search_vehicle")}',
                            hintStyle: TextStyle(
                                color: ApplicationColors.black4240,
                                fontSize: 15,
                                fontFamily: "Poppins-Regular",
                                letterSpacing: 0.75),
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                        ),

                        dropdownSearchBaseStyle: TextStyle(
                            color: ApplicationColors.black4240,
                            fontSize: 15,
                            fontFamily: "Poppins-Regular",
                            letterSpacing: 0.75),

                        dropdownSearchDecoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ApplicationColors.blackbackcolor,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ApplicationColors.blackbackcolor,
                            ),
                          ),
                          hintText:
                              '${getTranslated(context, "search_vehicle")}',
                          hintStyle: TextStyle(
                              color: ApplicationColors.black4240,
                              fontSize: 15,
                              fontFamily: "Poppins-Regular",
                              letterSpacing: 0.75),
                          border: OutlineInputBorder(),
                        ),

                        items: _reportProvider.userVehicleDropModel.devices,
                        itemAsString: (VehicleList u) => u.deviceName,
                        onChanged: (VehicleList data) {
                          setState(() {
                            vName = data.deviceName;
                            deviceIMEI = data.deviceId;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      '${getTranslated(context, "name")}',
                      overflow: TextOverflow.ellipsis,
                      style: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240,
                      ),
                    ),
                    SimpleTextField(
                      controller: nameController,
                      hintText: "Write your name here...",
                      borderColor: ApplicationColors.greyC4C4,
                      // controller: _loginController.userNameController,
                      // hintText: 'Group Name',
                      validator: (value) {
                        if (value.isEmpty) {
                          return '${getTranslated(context, "enter_name")}';
                        }
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    Container(
                      color: Colors.grey,
                      height: 2,
                    ),
                    SizedBox(height: height * 0.02),
                    Text('${getTranslated(context, "email")}',
                        overflow: TextOverflow.ellipsis,
                        style: FontStyleUtilities.h14(
                            fontColor: ApplicationColors.black4240)),
                    SimpleTextField(
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Let us how to contact you back...",
                      controller: emailController,
                      borderColor: ApplicationColors.textfieldBorderColor,
                      // controller: _loginController.userNameController,
                      // hintText: 'Email',
                      validator: (value) {
                        bool validEmail = RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(value ?? '');
                        if (value == null || value == '') {
                          return '${getTranslated(context, "enter_email_id")}';
                        } else if (validEmail == false) {
                          return '${getTranslated(context, "enter_valid_email")}';
                        }
                        return null;
                      },
                    ),
                    Container(
                      color: Colors.grey,
                      height: 2,
                    ),
                    SizedBox(height: height * 0.02),
                    Text('${getTranslated(context, "mobile_number")}',
                        overflow: TextOverflow.ellipsis,
                        style: FontStyleUtilities.h14(
                            fontColor: ApplicationColors.black4240)),
                    SimpleTextField(
                      keyboardType: TextInputType.phone,
                      controller: mobileController,
                      hintText: "Let us how to contact you back via mob...",
                      borderColor: ApplicationColors.textfieldBorderColor,
                      inputFormatter: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        FocusScope.of(context).unfocus();
                        if (value == null || value == '') {
                          return '${getTranslated(context, "enter_num")}';
                        } else if (value.length < 10) {
                          return '${getTranslated(context, "entervalid_num")}';
                        } else {
                          return null;
                        }
                      },
                      // controller: _loginController.userNameController,
                      // hintText: 'Number off vehicle',
                    ),
                    Container(
                      color: Colors.grey,
                      height: 2,
                    ),
                    SizedBox(height: height * 0.02),
                    Text('${getTranslated(context, "message")}',
                        overflow: TextOverflow.ellipsis,
                        style: FontStyleUtilities.h14(
                            fontColor: ApplicationColors.black4240)),
                    SimpleTextField(
                      maxLine: 3,
                      keyboardType: TextInputType.text,
                      controller: messageController,
                      hintText: "What would you like to tell us..",
                      borderColor: ApplicationColors.textfieldBorderColor,
                      // controller: _loginController.userNameController,
                      // hintText: 'Number off vehicle',
                      validator: (value) {
                        if (value.isEmpty) {
                          return '${getTranslated(context, "enter_msg")}';
                        }
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    Container(
                      color: Colors.grey,
                      height: 2,
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: ApplicationColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                    onPressed: () async {
                      if (_forMKey.currentState.validate()) {
                        addContact();
                      }
                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>RateUsPage()));
                    },
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 2.0, color: Colors.black),
                        backgroundColor: ApplicationColors.whiteColor),
                    child: Text(
                      '${getTranslated(context, "raise_ticket")}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: height * 0.04),
          ],
        ),
      ),
    );
  }
}
