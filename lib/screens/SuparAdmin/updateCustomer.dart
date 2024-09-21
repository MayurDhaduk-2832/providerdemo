import 'dart:convert';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Model/DealerModel.dart';
import 'package:oneqlik/Provider/customer_dealer_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:oneqlik/widgets/simple_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class UpdateCustomer extends StatefulWidget {
  final userId,
      firstName,
      lastName,
      emailId,
      postalCode,
      mobileNo,
      id,
      ex,
      address;

  const UpdateCustomer(
      {Key key,
      this.userId,
      this.firstName,
      this.lastName,
      this.emailId,
      this.postalCode,
      this.mobileNo,
      this.id,
      this.ex,
      this.address})
      : super(key: key);

  @override
  UpdateCustomerState createState() => UpdateCustomerState();
}

class UpdateCustomerState extends State<UpdateCustomer> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController editFirstNameController = TextEditingController();
  TextEditingController editLastNameController = TextEditingController();
  TextEditingController editEmailIDController = TextEditingController();
  TextEditingController editMobileController = TextEditingController();
  TextEditingController datedController = TextEditingController();

  CustomerDealerProvider _customerDealerProvider;

  DealerModel _dealerModel;

  editCustomer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();

    var data = {
      "first_name": editFirstNameController.text,
      "last_name": editLastNameController.text,
      "user_id": userIdController.text,
      "address": "",
      "contactid": widget.id,
      "expire_date": datedController.text,
      "email": editEmailIDController.text,
      "phone": editMobileController.text,
      "emergencyContact": {
        "contact1": {
          "name": "",
          "cell1": "",
          "cell2": "",
          "phone1": "",
          "phone2": ""
        },
        "contact2": {
          "name": "",
          "cell1": "",
          "cell2": "",
          "phone1": "",
          "phone2": ""
        }
      }
    };

    print(jsonEncode(data));

    _customerDealerProvider.editCustomer(
        data, "users/editUserDetails", context);
  }

  @override
  void initState() {
    super.initState();
    _customerDealerProvider =
        Provider.of<CustomerDealerProvider>(context, listen: false);
    editFirstNameController.text = widget.firstName;
    editLastNameController.text = widget.lastName;
    editEmailIDController.text = widget.emailId;
    editMobileController.text = widget.mobileNo;
    userIdController.text = widget.userId;
    datedController.text = DateFormat("dd MMM yyyy").format(widget.ex);
    print(widget.id);
  }

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _customerDealerProvider =
        Provider.of<CustomerDealerProvider>(context, listen: true);

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
          "${getTranslated(context, "edit_customer")}",
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
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 60,
        width: width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            tileMode: TileMode.clamp,
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF574e51),
              Color(0xFF1f2326),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '${getTranslated(context, "submit")}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // bottomNavigationBar: CustomElevatedButton(
      //   onPressed: () async {
      //     if (_forMKey.currentState.validate()) {
      //       editCustomer();
      //     }
      //   },
      //   buttonText: '${getTranslated(context, "submit")}',
      //   buttonColor: ApplicationColors.redColor67,
      // ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _forMKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${getTranslated(context, "userid")}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.blackbackcolor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SimpleTextField(
                        controller: userIdController,
                        textAlign: TextAlign.start,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "enter_id")}";
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: ApplicationColors.greenColor,
                  thickness: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${getTranslated(context, "firstname")}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.blackbackcolor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SimpleTextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        controller: editFirstNameController,
                        maxLine: 1,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "enter_first_name")}";
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: ApplicationColors.greenColor,
                  thickness: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${getTranslated(context, "last_name")}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.blackbackcolor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SimpleTextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        controller: editLastNameController,
                        maxLine: 1,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "Enter_lastname")}";
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: ApplicationColors.greenColor,
                  thickness: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${getTranslated(context, "email_id")}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.blackbackcolor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SimpleTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: editEmailIDController,
                        textAlign: TextAlign.start,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        validator: (value) {
                          bool validEmail = RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(value ?? '');
                          if (value == null || value == '') {
                            return "${getTranslated(context, "enter_email_id")}";
                          } else if (validEmail == false) {
                            return "${getTranslated(context, "enter_valid_email")}";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: ApplicationColors.greenColor,
                  thickness: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${getTranslated(context, "mobile_no")}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.blackbackcolor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SimpleTextField(
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.start,
                        borderColor: ApplicationColors.textfieldBorderColor,
                        inputFormatter: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        controller: editMobileController,
                        hintText: "${getTranslated(context, "enter_num")}",
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "entervalid_num")}";
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: ApplicationColors.greenColor,
                  thickness: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${getTranslated(context, "expiry_date*")}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.blackbackcolor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        style: FontStyleUtilities.h14(
                            fontColor: ApplicationColors.blackbackcolor),
                        keyboardType: TextInputType.datetime,
                        controller: datedController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "select_date")}";
                          }
                          return null;
                        },
                        focusNode: AlwaysDisabledFocusNode(),
                        onTap: () async {
                          FocusScope.of(context).unfocus();

                          DateTime newSelectedDate =
                              await _selecttDate(context);
                          if (newSelectedDate != null) {
                            setState(() {
                              datedController.text = DateFormat("dd-MMM-yyyy")
                                  .format(newSelectedDate);
                            });
                          }
                        },
                        decoration: fieldStyle.copyWith(
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ApplicationColors.redColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          errorStyle: FontStyleUtilities.h12(
                            fontColor: ApplicationColors.redColor,
                          ),

                          hintStyle: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.blackbackcolor),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ApplicationColors.transparentColors,
                            ),
                          ),
                          // contentPadding:
                          // const EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ApplicationColors.transparentColors,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ApplicationColors.transparentColors,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: ApplicationColors.greenColor,
                  thickness: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selecttDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        // firstDate: DateTime.now().subtract(Duration(days: 10)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget child) {
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
        });
    return newSelectedDate;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
