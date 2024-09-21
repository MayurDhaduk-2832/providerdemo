import 'dart:async';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/TypeModel.dart';
import 'package:oneqlik/Model/currency_model.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/expenses_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/widgets/simple_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExpensesScreen extends StatefulWidget {
  final vId, vName;

  const AddExpensesScreen({Key key, this.vId, this.vName}) : super(key: key);

  @override
  _AddExpensesScreenState createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  TextEditingController datedController = TextEditingController();
  TextEditingController currentdateController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();

  GlobalKey<FormState> key = GlobalKey();
  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  ExpensesProvider _expensesProvider;
  ReportProvider _reportProvider;
  UserProvider userProvider;
  var vehicleId = "";
  var paymentMode = "";
  var code = "INR";

  addExpenses() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "user": id,
      "currency": userProvider.useModel.cust.currencyCode ?? "INR",
      "vehicle": widget.vId == "" ? vehicleId : widget.vId,
      "date": datedController.text,
      "odometer": 0,
      "payment_mode": paymentMode,
      "type": _expensesProvider.chooseExpenseType,
      "amount": amountController.text,
    };

    print("check-->${json.encode(data)}");

    await _expensesProvider.addExpense(data, "expense/addExpense", context);
  }

  List<CurrencyModel> listCurrency = [];
  var currency = "₹";

  getCurrency() async {
    final String response =
        await rootBundle.loadString('assets/currency_file.json');
    var body = jsonDecode(response);
    List<CurrencyModel> list;

    List client = body as List;
    list = client
        .map<CurrencyModel>((json) => CurrencyModel.fromJson(json))
        .toList();
    listCurrency.addAll(list);
    for (var a in listCurrency) {
      if (a.code == userProvider.useModel.cust.currencyCode) {
        setState(() {
          currency = a.symbol;
        });
        break;
      }
    }

    print("currency := $currency");
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _expensesProvider = Provider.of<ExpensesProvider>(context, listen: false);
    getCurrency();
    code = userProvider.useModel.cust.currencyCode;
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    _expensesProvider = Provider.of<ExpensesProvider>(context, listen: true);
    _expensesProvider.choosePaymentMode = "";

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () async {
          if (_forMKey.currentState.validate()) {
            if (vehicleId != "" || widget.vId != "") {
              addExpenses();
            } else {
              Helper.dialogCall.showToast(
                context,
                "${getTranslated(context, "search_vehicle")}",
              );
            }
          }
        },
        child: Container(
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
      ),
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
          "${getTranslated(context, "add_expenses")}",
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: _forMKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Theme(
                  data: ThemeData(
                    textTheme:
                        TextTheme(subtitle1: TextStyle(color: Colors.black)),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        hintText: "${getTranslated(context, "search_vehicle")}",
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
                          color: ApplicationColors.transparentColors,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ApplicationColors.transparentColors,
                        ),
                      ),
                      hintText: widget.vName != ""
                          ? widget.vName
                          : "${getTranslated(context, "search_vehicle")}",
                      hintStyle: TextStyle(
                          color: ApplicationColors.black4240,
                          fontSize: 15,
                          fontFamily: "Poppins-Regular",
                          letterSpacing: 0.75),
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ApplicationColors.transparentColors,
                        ),
                      ),
                    ),

                    items: _reportProvider.userVehicleDropModel.devices,
                    itemAsString: (VehicleList u) => u.deviceName,
                    onChanged: (VehicleList data) {
                      setState(() {
                        vehicleId = data.id;
                      });
                    },
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<TypeModel>(
                      validator: (value) {
                        if (value == null) {
                          return "${getTranslated(context, "select_expanse")}";
                        }
                        return null;
                      },
                      iconEnabledColor: ApplicationColors.redColor67,
                      isExpanded: true,
                      isDense: true,
                      decoration: InputDecoration(
                        hintText: "${getTranslated(context, "expense_type")}",
                        labelStyle: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.black4240,
                        ),
                        hintStyle: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.black4240,
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ApplicationColors.transparentColors,
                          ),
                        ),
                        errorStyle: FontStyleUtilities.h12(
                          fontColor: ApplicationColors.redColor,
                        ),
                        contentPadding: EdgeInsets.only(left: 10),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ApplicationColors.transparentColors,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ApplicationColors.transparentColors,
                          ),
                        ),
                      ),
                      dropdownColor: ApplicationColors.dropdownColor3D,
                      onChanged: (value) {
                        setState(() {
                          _expensesProvider.chooseExpenseType = value.name;
                        });
                      },
                      items: /* [
                        "${getTranslated(context, "fuel_small")}",
                        "${getTranslated(context, "tools")}",
                        "${getTranslated(context, "salary")}",
                        "${getTranslated(context, "labor")}",
                        "${getTranslated(context, "food")}",
                        "${getTranslated(context, "toll")}",
                        "${getTranslated(context, "other")}",
                        "${getTranslated(context, "service")}",
                        "${getTranslated(context, "petta")}",
                      ]
                        */
                          _expensesProvider.expensesTypeList
                              .map((TypeModel value) => DropdownMenuItem(
                                    child: Text(
                                      value.name,
                                      style: FontStyleUtilities.h14(
                                          fontColor:
                                              ApplicationColors.black4240,
                                          fontFamily: 'Poppins-Regular'),
                                    ),
                                    value: value,
                                  ))
                              .toList()),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Container(
                  width: width,
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ApplicationColors.transparentColors,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "$code",
                    style: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                      iconEnabledColor: ApplicationColors.redColor67,
                      isExpanded: true,
                      isDense: true,
                      validator: (value) {
                        if (value == null) {
                          return "${getTranslated(context, "select_paymet")}";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "${getTranslated(context, "payment_mode")}",
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ApplicationColors.transparentColors,
                          ),
                        ),
                        errorStyle: FontStyleUtilities.h12(
                          fontColor: ApplicationColors.redColor,
                        ),
                        labelStyle: FontStyleUtilities.h14(
                            fontColor: ApplicationColors.black4240),
                        hintStyle: FontStyleUtilities.h14(
                            fontColor: ApplicationColors.black4240),
                        contentPadding: EdgeInsets.only(left: 10),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ApplicationColors.transparentColors,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ApplicationColors.transparentColors,
                          ),
                        ),
                      ),
                      dropdownColor: ApplicationColors.dropdownColor3D,
                      onChanged: (value) {
                        paymentMode = value;
                      },
                      items: [
                        "${getTranslated(context, "cash")}",
                        "${getTranslated(context, "debit")}",
                        "${getTranslated(context, "credit_card")}",
                        "${getTranslated(context, "neft")}",
                        "${getTranslated(context, "upi")}",
                        "${getTranslated(context, "rtgs")}",
                        "${getTranslated(context, "cheque")}",
                        "${getTranslated(context, "demand_draft")}",
                        "${getTranslated(context, "fuel_card")}",
                        "${getTranslated(context, "other")}",
                      ]
                          .map((String value) => DropdownMenuItem(
                                child: Text(
                                  value,
                                  style: FontStyleUtilities.h14(
                                      fontColor: ApplicationColors.black4240,
                                      fontFamily: 'Poppins-Regular'),
                                ),
                                value: value,
                              ))
                          .toList()),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                TextFormField(
                  readOnly: true,
                  style: FontStyleUtilities.h14(
                      fontColor: ApplicationColors.black4240),
                  keyboardType: TextInputType.number,
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

                    DateTime newSelectedDate = await _selecttDate(context);
                    if (newSelectedDate != null) {
                      setState(() {
                        datedController.text =
                            DateFormat("dd-MMM-yyyy").format(newSelectedDate);
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
                    hintText: "${getTranslated(context, "select_date")}",

                    hintStyle: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ApplicationColors.transparentColors,
                      ),
                    ),
                    // contentPadding:
                    // const EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ApplicationColors.transparentColors,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ApplicationColors.transparentColors,
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                TextFormField(
                  style: FontStyleUtilities.h14(
                      fontColor: ApplicationColors.black4240),
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    isDense: true,
                    border: InputBorder.none,
                    hintText:
                        "${getTranslated(context, "enter_amount")} $currency",
                    hintStyle: FontStyleUtilities.h14(
                        fontColor: ApplicationColors.black4240),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                TextFormField(
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: ApplicationColors.black4240),
                    hintText: "${getTranslated(context, "reference")}",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ApplicationColors.transparentColors,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 15, right: 15),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ApplicationColors.transparentColors,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ApplicationColors.transparentColors,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_reference")}";
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
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
        firstDate: DateTime(2015),
        lastDate: DateTime(2100),
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
