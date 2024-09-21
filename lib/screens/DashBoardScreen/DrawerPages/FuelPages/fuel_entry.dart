import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/currency_model.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/fuel_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ExpensesScreens/expenses_screen.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FuelEntryPage extends StatefulWidget {
  final vId, vName;

  const FuelEntryPage({Key key, this.vId, this.vName}) : super(key: key);

  @override
  _FuelEntryPageState createState() => _FuelEntryPageState();
}

class _FuelEntryPageState extends State<FuelEntryPage> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController datedController = TextEditingController();

  TextEditingController currentdateController = TextEditingController();
  TextEditingController litreController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();
  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  FuelProvider _fuelProvider;
  ReportProvider _reportProvider;
  UserProvider userProvider;

  var vehicleId = "";

  addFuel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "vehicle": widget.vId == "" ? vehicleId : widget.vId,
      "user": "$id",
      "comment": "First fill",
      "date": datedController.text,
      "fuel_type": _fuelProvider.chooseExpenseType,
      "odometer": "0.00",
      "price": amountController.text,
      "quantity": litreController.text,
    };

    _fuelProvider.addFuel(data, "fuel/addFuel", context, vehicleId);

    print('FuelEntry->$data');
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
    _fuelProvider = Provider.of<FuelProvider>(context, listen: false);
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    getCurrency();
  }

  @override
  Widget build(BuildContext context) {
    _fuelProvider = Provider.of<FuelProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    userProvider = Provider.of<UserProvider>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
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
          "${getTranslated(context, "fuel_entery")}",
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
      bottomNavigationBar: InkWell(
        onTap: () async {
          if (_forMKey.currentState.validate()) {
            if (vehicleId != "" || widget.vId != "") {
              addFuel();
            } else {
              Helper.dialogCall.showToast(
                  context, "${getTranslated(context, "search_vehicle")}");
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: _forMKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: ApplicationColors.transparentColors),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationColors.transparentColors),
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
                            color: ApplicationColors.transparentColors),
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "${getTranslated(context, "fuel_type")}",
                        style: FontStyleUtilities.h14(
                            fontColor: ApplicationColors.black4240),
                      ),
                      Spacer(),
                      Container(
                        width: 60,
                        child: DropdownButtonFormField(
                            iconEnabledColor: ApplicationColors.redColor67,
                            isExpanded: true,
                            isDense: true,
                            /*validator: (value){
                              if(value == null){
                                return "Select Fuel Type";
                              }
                              return null;
                            },*/
                            decoration: InputDecoration(
                              hintText: "${getTranslated(context, "cng")}",
                              labelStyle: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                              hintStyle: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                              contentPadding: EdgeInsets.only(left: 1),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ApplicationColors.transparentColors),
                              ),
                            ),
                            dropdownColor: ApplicationColors.whiteColor,
                            value: _fuelProvider.chooseExpenseType,
                            onChanged: (value) {
                              _fuelProvider.chooseExpenseType = value;
                            },
                            items: [
                              "${getTranslated(context, "cng")}",
                              "${getTranslated(context, "petrol")}",
                              "${getTranslated(context, "others")}",
                            ]
                                .map(
                                  (String value) => DropdownMenuItem(
                                    child: Text(
                                      value,
                                      style: FontStyleUtilities.h14(
                                        fontColor: ApplicationColors.black4240,
                                        fontFamily: 'Poppins-Regular',
                                      ),
                                    ),
                                    value: value,
                                  ),
                                )
                                .toList()),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                TextFormField(
                  style: Textstyle1.signupText1,
                  keyboardType: TextInputType.number,
                  controller: litreController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "enter_select_litre")}";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorStyle: FontStyleUtilities.h12(
                      fontColor: ApplicationColors.redColor,
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ApplicationColors.redColor67),
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ApplicationColors.transparentColors),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ApplicationColors.transparentColors),
                    ),
                    hintText: "${getTranslated(context, "liter")}",
                    hintStyle: Textstyle1.signupText.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.green,
                  thickness: 3,
                ),
                TextFormField(
                  style: FontStyleUtilities.h14(
                      fontColor: ApplicationColors.black4240),
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      isDense: true,
                      border: InputBorder.none,
                      hintText:
                          "${getTranslated(context, "enter_amount")} $currency",
                      hintStyle: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.black4240)),
                ),
                Divider(
                  color: Colors.green,
                  thickness: 3,
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
                          color: ApplicationColors.transparentColors),
                    ),
                    // contentPadding:
                    // const EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ApplicationColors.transparentColors),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ApplicationColors.transparentColors),
                    ),
                  ),
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
}

_selecttDate(BuildContext context) async {
  DateTime newSelectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
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
