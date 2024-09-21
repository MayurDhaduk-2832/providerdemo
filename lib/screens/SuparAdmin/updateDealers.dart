import 'dart:convert';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Provider/customer_dealer_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateDealers extends StatefulWidget {
  final userId,
      firstName,
      lastName,
      emailId,
      postalCode,
      mobileNo,
      address,
      id,
      expDate;
  const UpdateDealers(
      {Key key,
      this.userId,
      this.firstName,
      this.lastName,
      this.emailId,
      this.postalCode,
      this.mobileNo,
      this.address,
      this.id,
      this.expDate})
      : super(key: key);

  @override
  UpdateDealersState createState() => UpdateDealersState();
}

class UpdateDealersState extends State<UpdateDealers> {
  TextEditingController editUserIdController = TextEditingController();
  TextEditingController editFirstNameController = TextEditingController();
  TextEditingController editLastNameController = TextEditingController();
  TextEditingController editEmailIDController = TextEditingController();
  TextEditingController editMobileController = TextEditingController();
  TextEditingController editAddressController = TextEditingController();
  TextEditingController datedController = TextEditingController();

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  CustomerDealerProvider customerDealerProvider;

  editDealers() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    bool superAdmin = sharedPreferences.getBool("superAdmin");
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();

    var data = {
      "first_name": editFirstNameController.text,
      "last_name": editLastNameController.text,
      "address": editAddressController.text,
      "user_id": editUserIdController.text,
      "email": editEmailIDController.text,
      "phone": editMobileController.text,
      "contactid": widget.id,
      "expire_date": datedController.text,
    };

    print(jsonEncode(data));

    await customerDealerProvider.editDealers(
        data, "users/editUserDetails", context);
  }

  @override
  void initState() {
    super.initState();
    customerDealerProvider =
        Provider.of<CustomerDealerProvider>(context, listen: false);
    editFirstNameController.text = widget.firstName;
    editLastNameController.text = widget.lastName;
    editEmailIDController.text = widget.emailId;
    editMobileController.text = widget.mobileNo;
    editAddressController.text = widget.address;
    editUserIdController.text = widget.userId;
    datedController.text = DateFormat("dd MMM yyyy").format(widget.expDate);

    print('checkEmail->${widget.emailId}');
    print('CheckMo.->${widget.mobileNo}');
  }

  @override
  Widget build(BuildContext context) {
    customerDealerProvider =
        Provider.of<CustomerDealerProvider>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: ApplicationColors.whiteColorF9),
        ),
        Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 9.0, left: 10, top: 13),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image.asset("assets/images/vector_icon.png",
                    color: ApplicationColors.redColor67),
              ),
            ),
            title: Text(
              "${getTranslated(context, "edit_dealers")}",
              textAlign: TextAlign.start,
              style: Textstyle1.appbartextstyle1,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(right: 19, left: 14, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 40),
                    child: Form(
                      key: _forMKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "${getTranslated(context, "userid")}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.blackbackcolor,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          CustomTextField(
                            controller: editUserIdController,
                            textAlign: TextAlign.start,
                            focusedBorder: ApplicationColors.redColor67,
                            borderColor: ApplicationColors.textfieldBorderColor,
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'Enter User ID';
                            //   }
                            //   FocusScope.of(context).unfocus();
                            // },
                          ),
                          SizedBox(height: height * 0.02),
                          Text("${getTranslated(context, "firstname")}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.blackbackcolor)),
                          SizedBox(height: height * 0.01),
                          CustomTextField(
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.start,
                            controller: editFirstNameController,
                            maxLine: 1,
                            focusedBorder: ApplicationColors.redColor67,
                            borderColor: ApplicationColors.textfieldBorderColor,
                            // controller: _loginController.userNameController,
                            // hintText: 'Email',
                            validator: (value) {
                              if (value.isEmpty) {
                                return "${getTranslated(context, "enter_first_name")}";
                              }
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          SizedBox(height: height * 0.02),
                          Text(
                            "${getTranslated(context, "last_name")}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.blackbackcolor,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          CustomTextField(
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            controller: editLastNameController,
                            maxLine: 1,
                            focusedBorder: ApplicationColors.redColor67,
                            borderColor: ApplicationColors.textfieldBorderColor,
                            // controller: _loginController.userNameController,
                            // hintText: 'Email',
                            validator: (value) {
                              if (value.isEmpty) {
                                return "${getTranslated(context, "Enter_lastname")}";
                              }
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          SizedBox(height: height * 0.02),
                          Text(
                            "Email",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.blackbackcolor,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          CustomTextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: editEmailIDController,
                            textAlign: TextAlign.start,
                            focusedBorder: ApplicationColors.redColor67,
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
                          SizedBox(height: height * 0.02),
                          Text('${getTranslated(context, "mobile_no")}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.blackbackcolor)),
                          SizedBox(height: height * 0.01),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {
                                    // _openCountryPickerDialog();
                                  },
                                  child: Container(
                                    width: 75,
                                    height: 58,
                                    decoration: BoxDecoration(
                                        color: ApplicationColors
                                            .textFielfForegroundColor,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: ApplicationColors
                                                .textfieldBorderColor)),
                                    child: Center(
                                      child: Text(
                                        "+ ${widget.postalCode}",
                                        style: TextStyle(
                                          color:
                                              ApplicationColors.blackbackcolor,
                                          fontFamily: "Poppins-Regular",
                                        ),
                                      ),
                                    ),
                                  )),
                              SizedBox(width: 9),
                              Expanded(
                                child: CustomTextField(
                                  keyboardType: TextInputType.phone,
                                  textAlign: TextAlign.start,
                                  focusedBorder: ApplicationColors.redColor67,
                                  borderColor:
                                      ApplicationColors.textfieldBorderColor,
                                  inputFormatter: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  controller: editMobileController,
                                  hintText:
                                      "${getTranslated(context, "enter_num")}",
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
                          SizedBox(height: height * 0.02),
                          Text(
                            '${getTranslated(context, "expiry_date*")}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: FontStyleUtilities.h14(
                              fontColor: ApplicationColors.blackbackcolor,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          TextFormField(
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
                                  datedController.text =
                                      DateFormat("dd-MMM-yyyy")
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

                              fillColor:
                                  ApplicationColors.textFielfForegroundColor,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Image.asset(
                                  "assets/images/date_icon.png",
                                  color: ApplicationColors.redColor67,
                                  width: 20,
                                ),
                              ),
                              hintStyle: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.whiteColor),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ApplicationColors.whiteColor
                                          .withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10)),
                              // contentPadding:
                              // const EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ApplicationColors.textfieldBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Text("${getTranslated(context, "address*")}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.blackbackcolor)),
                          SizedBox(height: height * 0.01),
                          CustomTextField(
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.start,
                            controller: editAddressController,
                            maxLine: 4,
                            focusedBorder: ApplicationColors.redColor67,
                            borderColor: ApplicationColors.textfieldBorderColor,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "${getTranslated(context, "enter_address")}";
                              }
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          SizedBox(height: height * 0.07),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ApplicationColors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  Row(
                    children: [
                      Expanded(
                          child: CustomElevatedButton(
                        onPressed: () async {
                          if (_forMKey.currentState.validate()) {
                            editDealers();
                          }
                        },
                        buttonText: '${getTranslated(context, "submit")}',
                        buttonColor: ApplicationColors.redColor67,
                      )),
                    ],
                  ),
                  SizedBox(height: height * 0.04),
                ],
              ),
            ),
          ),
        ),
      ],
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
