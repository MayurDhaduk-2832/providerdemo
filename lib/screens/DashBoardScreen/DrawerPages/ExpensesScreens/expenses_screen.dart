import 'dart:async';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/currency_model.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/expenses_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ExpensesScreens/add_expenses_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ExpensesScreens/type_expenses_screen.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Provider/user_provider.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key key}) : super(key: key);

  @override
  ExpensesScreenState createState() => ExpensesScreenState();
}

class ExpensesScreenState extends State<ExpensesScreen> {
  int serviceOfIndex = 0;
  var height, width;
  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  ExpensesProvider _expensesProvider;
  UserProvider _userProvider;
  ReportProvider _reportProvider;

  var fromDate = DateTime.now().subtract(Duration(days: 1)).toString();
  var toDate = DateTime.now().toString();
  var vehicleId = "",
      vehicleName = "";

  getDeviceByUserDropdown() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");

    var data = {"email": email, "id": id};

    await _reportProvider.getVehicleDropdown(
        data, "devices/getDeviceByUserDropdown");
  }

  expensesList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = vehicleId == ""
        ? {
      "user": id,
      "fdate": fromDate,
      "tdate": toDate,
    }
        : {
      "user": id,
      "fdate": fromDate,
      "tdate": toDate,
      "vehicle": vehicleId
    };

    print(data);

    _expensesProvider.expensesLists(data, "expense/expensebycateogry");
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
    };

    await _userProvider.getUserData(data, "users/getCustumerDetail", context);
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
      if (a.code == _userProvider.useModel.cust.currencyCode) {
        setState(() {
          currency = a.symbol;
        });
        break;
      }
    }

    print("currency := $currency");
  }

  getType() async {
    var data = {"type": "expense"};

    await _expensesProvider.getExpensesType(data, "typeMaster/get");
  }

  @override
  void initState() {
    super.initState();
    datedController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}";
    _endDateController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}";
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _expensesProvider = Provider.of<ExpensesProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _expensesProvider.getExpensesLists.clear();
    getType();
    getUserData();
    expensesList();
    getCurrency();
    getDeviceByUserDropdown();
  }

  @override
  Widget build(BuildContext context) {
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    _expensesProvider = Provider.of<ExpensesProvider>(context, listen: true);
    _userProvider = Provider.of<UserProvider>(context, listen: true);
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      resizeToAvoidBottomInset: false,
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
          "${getTranslated(context, "expenses")}",
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
          "${getTranslated(context, "total")} $currency ${_expensesProvider
              .totalExpanse}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AddExpensesScreen(
                          vId: vehicleId, vName: vehicleName)));
        },
        child: Icon(Icons.add),
      ),
      body: _expensesProvider.isExpensesListLoading &&
          _reportProvider.isDropDownLoading
          ? Helper.dialogCall.showLoader()
          : Column(
        children: [
          Card(
            elevation: 4,
            child: Column(
              children: [
                Theme(
                  data: ThemeData(
                    textTheme: TextTheme(
                      subtitle1: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  child: DropdownSearch<VehicleList>(
                    popupBackgroundColor: ApplicationColors.blackColor2E,
                    mode: Mode.DIALOG,
                    showSearchBox: true,
                    showAsSuffixIcons: true,
                    dialogMaxWidth: width,
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
                              color:
                              ApplicationColors.textfieldBorderColor,
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
                        "${getTranslated(context, "search_vehicle")}",
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
                      hintText:
                      "${getTranslated(context, "search_vehicle")}",
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
                    items: _reportProvider.userVehicleDropModel == null
                        ? []
                        : _reportProvider.userVehicleDropModel.devices,
                    itemAsString: (VehicleList u) => u.deviceName,
                    onChanged: (VehicleList data) {
                      setState(() {
                        vehicleId = data.id;
                        vehicleName = data.deviceName;
                        expensesList();
                      });
                    },
                  ),
                ),
                Divider(color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text("From Date"),
                                TextFormField(
                                  readOnly: true,
                                  style: Textstyle1.signupText1,
                                  keyboardType: TextInputType.number,
                                  controller: datedController,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  onTap: () async {
                                    DateTime newSelectedDate =
                                    await _selecttDate(context);
                                    if (newSelectedDate != null) {
                                      setState(() {
                                        datedController.text = DateFormat(
                                            "dd-MMM-yyyy hh:mm a")
                                            .format(newSelectedDate);
                                      });
                                      fromDate =
                                          newSelectedDate.toString();
                                      expensesList();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "From Date",
                                    hintStyle: Textstyle1.signupText1,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text("To Date"),
                                TextFormField(
                                  readOnly: true,
                                  style: Textstyle1.signupText1,
                                  keyboardType: TextInputType.number,
                                  controller: _endDateController,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  onTap: () async {
                                    DateTime newSelectedDate =
                                    await _selecttoDate(context);
                                    if (newSelectedDate != null) {
                                      setState(() {
                                        _endDateController.text =
                                            DateFormat(
                                                "dd-MMM-yyyy hh:mm a")
                                                .format(newSelectedDate);
                                      });
                                      toDate = newSelectedDate.toString();
                                      expensesList();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintStyle: Textstyle1.signupText1,
                                    hintText: "End Date",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
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
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: ApplicationColors.whiteColorF9),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, top: 10, bottom: 5),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _expensesProvider.isExpensesListLoading
                          ? Helper.dialogCall.showLoader()
                          : _expensesProvider.getExpensesLists.isEmpty
                          ? Center(
                        child: Text(
                          "${getTranslated(context, "expenses_not_available")}",
                          textAlign: TextAlign.center,
                          style: Textstyle1.text18.copyWith(
                            fontSize: 18,
                            color: ApplicationColors.redColor67,
                          ),
                        ),
                      )
                          : GridView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _expensesProvider
                              .getExpensesLists.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.5 / 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 18,
                          ),
                          itemBuilder: (context, index) {
                            var expensesDetailLists =
                            _expensesProvider
                                .getExpensesLists[index];
                            return InkWell(
                              onTap: () {
                                expensesDetailLists.id
                                    .toLowerCase() ==
                                    "fuel"
                                    ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext
                                    context) =>
                                        TripDetailTypeScreen(
                                          types:
                                          expensesDetailLists
                                              .id,
                                          vId: vehicleId,
                                          fromDate: fromDate
                                              .toString(),
                                          toDate:
                                          toDate.toString(),
                                        ),
                                  ),
                                )
                                    : expensesDetailLists.id
                                    .toLowerCase() ==
                                    "tools"
                                    ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext
                                    context) =>
                                        TripDetailTypeScreen(
                                          types:
                                          expensesDetailLists
                                              .id,
                                          vId: vehicleId,
                                          fromDate: fromDate
                                              .toString(),
                                          toDate: toDate
                                              .toString(),
                                        ),
                                  ),
                                )
                                    : expensesDetailLists.id
                                    .toLowerCase() ==
                                    "salary"
                                    ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext
                                    context) =>
                                        TripDetailTypeScreen(
                                          types:
                                          expensesDetailLists
                                              .id,
                                          vId:
                                          vehicleId,
                                          fromDate: fromDate
                                              .toString(),
                                          toDate: toDate
                                              .toString(),
                                        ),
                                  ),
                                )
                                    : expensesDetailLists
                                    .id
                                    .toLowerCase() ==
                                    "petta"
                                    ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext
                                    context) =>
                                        TripDetailTypeScreen(
                                          types:
                                          expensesDetailLists
                                              .id,
                                          vId:
                                          vehicleId,
                                          fromDate:
                                          fromDate
                                              .toString(),
                                          toDate: toDate
                                              .toString(),
                                        ),
                                  ),
                                )
                                    : expensesDetailLists
                                    .id
                                    .toLowerCase() ==
                                    "food"
                                    ? Navigator
                                    .push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (BuildContext context) =>
                                        TripDetailTypeScreen(
                                          types:
                                          expensesDetailLists.id,
                                          vId:
                                          vehicleId,
                                          fromDate:
                                          fromDate.toString(),
                                          toDate:
                                          toDate.toString(),
                                        ),
                                  ),
                                )
                                    : expensesDetailLists
                                    .id
                                    .toLowerCase() ==
                                    "toll"
                                    ? Navigator
                                    .push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TripDetailTypeScreen(
                                          types: expensesDetailLists.id,
                                          vId: vehicleId,
                                          fromDate: fromDate.toString(),
                                          toDate: toDate.toString(),
                                        ),
                                  ),
                                )
                                    : expensesDetailLists.id.toLowerCase() ==
                                    "service"
                                    ? Navigator
                                    .push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TripDetailTypeScreen(
                                          types: expensesDetailLists.id,
                                          vId: vehicleId,
                                          fromDate: fromDate.toString(),
                                          toDate: toDate.toString(),
                                        ),
                                  ),
                                )
                                    : expensesDetailLists.id.toLowerCase() ==
                                    "labor"
                                    ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TripDetailTypeScreen(
                                          types: expensesDetailLists.id,
                                          vId: vehicleId,
                                          fromDate: fromDate.toString(),
                                          toDate: toDate.toString(),
                                        ),
                                  ),
                                )
                                    : expensesDetailLists.id.toLowerCase() ==
                                    "others"
                                    ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TripDetailTypeScreen(
                                          types: expensesDetailLists.id,
                                          vId: vehicleId,
                                          fromDate: fromDate.toString(),
                                          toDate: toDate.toString(),
                                        ),
                                  ),
                                )
                                    : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TripDetailTypeScreen(
                                          types: expensesDetailLists.id,
                                          vId: vehicleId,
                                          fromDate: fromDate.toString(),
                                          toDate: toDate.toString(),
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 14, top: 14),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center,
                                      children: [
                                        Container(
                                          padding:
                                          EdgeInsets.all(6),
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                              child: expensesDetailLists
                                                  .id
                                                  .toLowerCase() ==
                                                  "fuel"
                                                  ? listOfExpensesServices[0]
                                              ['image']
                                                  : expensesDetailLists
                                                  .id
                                                  .toLowerCase() ==
                                                  "tools"
                                                  ? listOfExpensesServices[
                                              1][
                                              'image']
                                                  : expensesDetailLists.id
                                                  .toLowerCase() ==
                                                  "salary"
                                                  ? listOfExpensesServices[2]
                                              [
                                              'image']
                                                  : expensesDetailLists.id
                                                  .toLowerCase() ==
                                                  "petta"
                                                  ? listOfExpensesServices[3]['image']
                                                  : expensesDetailLists.id
                                                  .toLowerCase() == "food"
                                                  ? listOfExpensesServices[5]['image']
                                                  : expensesDetailLists.id
                                                  .toLowerCase() == "toll"
                                                  ? listOfExpensesServices[6]['image']
                                                  : expensesDetailLists.id
                                                  .toLowerCase() == "service"
                                                  ? listOfExpensesServices[4]['image']
                                                  : expensesDetailLists.id
                                                  .toLowerCase() == "labor"
                                                  ? listOfExpensesServices[7]['image']
                                                  : expensesDetailLists.id
                                                  .toLowerCase() == "others"
                                                  ? listOfExpensesServices[8]['image']
                                                  : listOfExpensesServices[8]['image']),
                                          decoration:
                                          BoxDecoration(
                                            color: expensesDetailLists
                                                .id
                                                .toLowerCase() ==
                                                "fuel"
                                                ? listOfExpensesServices[0]
                                            ['color']
                                                : expensesDetailLists
                                                .id
                                                .toLowerCase() ==
                                                "tools"
                                                ? listOfExpensesServices[1]
                                            ['color']
                                                : expensesDetailLists
                                                .id
                                                .toLowerCase() ==
                                                "salary"
                                                ? listOfExpensesServices[
                                            2]
                                            [
                                            'color']
                                                : expensesDetailLists.id
                                                .toLowerCase() ==
                                                "petta"
                                                ? listOfExpensesServices[3]
                                            [
                                            'color']
                                                : expensesDetailLists.id
                                                .toLowerCase() == "food"
                                                ? listOfExpensesServices[5]['color']
                                                : expensesDetailLists.id
                                                .toLowerCase() == "toll"
                                                ? listOfExpensesServices[6]['color']
                                                : expensesDetailLists.id
                                                .toLowerCase() == "service"
                                                ? listOfExpensesServices[4]['color']
                                                : expensesDetailLists.id
                                                .toLowerCase() == "labor"
                                                ? listOfExpensesServices[7]['color']
                                                : expensesDetailLists.id
                                                .toLowerCase() == "others"
                                                ? listOfExpensesServices[8]['color']
                                                : listOfExpensesServices[8]['color'],
                                            borderRadius:
                                            BorderRadius
                                                .circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                ApplicationColors
                                                    .whiteColor,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                                blurRadius: 10.0,
                                                spreadRadius: -8,
                                              ), //BoxShadow
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 9),
                                        Flexible(
                                          child: Text(
                                            expensesDetailLists
                                                .id,
                                            overflow: TextOverflow
                                                .ellipsis,
                                            maxLines: 1,
                                            textAlign:
                                            TextAlign.center,
                                            style: FontStyleUtilities.h12(
                                                fontColor:
                                                ApplicationColors
                                                    .blackbackcolor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Flexible(
                                      child: Text(
                                        "${expensesDetailLists.total}",
                                        overflow:
                                        TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign:
                                        TextAlign.center,
                                        style: FontStyleUtilities.h18(
                                            fontColor:
                                            ApplicationColors
                                                .blackbackcolor),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "${getTranslated(
                                            context, "total_generate")}",
                                        overflow:
                                        TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign:
                                        TextAlign.center,
                                        style: FontStyleUtilities
                                            .hS12(
                                          fontColor:
                                          ApplicationColors
                                              .blackbackcolor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  color: serviceOfIndex == index
                                      ? ApplicationColors
                                      .darkGreyBGColor
                                      : ApplicationColors
                                      .darkGreyBGColor,
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _selecttDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        // firstDate: DateTime.now().subtract(Duration(days: 10)),
        firstDate: DateTime(2015),
        lastDate: DateTime.now(),
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

  _selecttoDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        // firstDate: DateTime.now().subtract(Duration(days: 10)),
        firstDate: DateTime(2015),
        lastDate: DateTime.now(),
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

List listOfExpensesServices = [
  {
    'name': 'Fuel',
    'color': ApplicationColors.greenColor370,
    'image': Image.asset("assets/images/fuel_icon.png")
  },
  {
    'name': 'Tools',
    'color': ApplicationColors.yellowColorD21,
    'image': Image.asset("assets/images/tools_icon.png")
  },
  {
    'name': 'Salary',
    'color': ApplicationColors.blueColorCE,
    'image': Image.asset("assets/images/money_icon.png")
  },
  {
    'name': 'Petta',
    'color': ApplicationColors.orangeColor3E,
    'image': Image.asset("assets/images/protection_icon.png")
  },
  {
    'name': 'Service',
    'color': ApplicationColors.radiusColorFB,
    'image': Image.asset("assets/images/service_icon.png")
  },
  {
    'name': 'Food',
    'color': ApplicationColors.pinkColorC3,
    'image': Image.asset("assets/images/food_icon.png")
  },
  {
    'name': 'Toll',
    'color': ApplicationColors.darkredColor1E,
    'image': Image.asset("assets/images/toll_icon.png")
  },
  {
    'name': 'Labor',
    'color': ApplicationColors.darkgreyColor1E,
    'image': Image.asset("assets/images/labor_icon.png")
  },
  {
    'name': 'Others',
    'color': ApplicationColors.redColor67,
    'image': Image.asset("assets/images/other_icon.png")
  },
];
