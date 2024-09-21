import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/get_fuel_entry_model.dart';
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

class EditFuelEntryPage extends StatefulWidget {
  final vId,vName,index;
  const EditFuelEntryPage({Key key, this.vId, this.vName,this.index}) : super(key: key);

  @override
  _EditFuelEntryPageState createState() => _EditFuelEntryPageState();
}

class _EditFuelEntryPageState extends State<EditFuelEntryPage> {


  TextEditingController datedController = TextEditingController();
  TextEditingController litreController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  TextEditingController vehicleController = new TextEditingController();

  GlobalKey<FormState> key = GlobalKey();
  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  FuelProvider _fuelProvider;
  ReportProvider _reportProvider;
  UserProvider userProvider;

  var chooseExpenseType = "";


  var expDate = "";


  List<GetFuelEntryModel> getFuelEntryList = [];

  updateFuel() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data =
    {
      "vehicle": getFuelEntryList[widget.index].vehicle.id,
      "comment": "First fill",
      "date": expDate,
      "fuel_type": "$chooseExpenseType",
      "odometer": "0.00",
      "price": amountController.text,
      "quantity": litreController.text,
      "_id": getFuelEntryList[widget.index].id,
    };

    _fuelProvider.updateFuel(data, "fuel/updateFuel", context,getFuelEntryList[widget.index].vehicle.id);

    // print('EditFuelEntry->$data');

    print("called");
    print(jsonEncode(data));
  }



  @override
  void initState() {
    super.initState();
    amountController = TextEditingController()..text = "0";
    _fuelProvider = Provider.of<FuelProvider>(context,listen: false);
    _reportProvider = Provider.of<ReportProvider>(context,listen: false);
    userProvider = Provider.of<UserProvider>(context,listen: false);
    getFuelEntryList = _fuelProvider.getFuelEntryList;

    litreController.text = "${getFuelEntryList[widget.index].quantity}";
    datedController.text = DateFormat("dd-MMM-yyyy").format(getFuelEntryList[widget.index].date);
    expDate = getFuelEntryList[widget.index].date.toString();
    chooseExpenseType = getFuelEntryList[widget.index].fuelType;
    amountController.text = "${getFuelEntryList[widget.index].price}";
    vehicleController.text = "${widget.vName}";

  }

  @override
  Widget build(BuildContext context) {
    _fuelProvider = Provider.of<FuelProvider>(context,listen: true);
    _reportProvider = Provider.of<ReportProvider>(context,listen: true);
    userProvider = Provider.of<UserProvider>(context,listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ApplicationColors.whiteColorF9
          ),
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
                icon: Image.asset("assets/images/vector_icon.png",color: ApplicationColors.redColor67),
              ),
            ),
            title: Text(
              "${getTranslated(context, "edit_fuel_entry")}",
              style: Textstyle1.appbartextstyle1,),

            backgroundColor: Colors.transparent, elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(right: 19,left: 14,top: 45),
              child: Form(
                key: _forMKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 25,right: 25,top: 40,bottom: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /* SizedBox(
                            height: 50,
                            child: Container(
                                child: TextField(
                                  style: FontStyleUtilities.h14(
                                    fontColor: ApplicationColors.whiteColor,
                                  ),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    hintText: 'Search vehicle',
                                    hintStyle: TextStyle(
                                        color: ApplicationColors.whiteColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins-Regular",
                                        letterSpacing: 0.2),
                                    // prefixIcon: Icon(Icons.search,color: ApplicationColors.blackColor33.withOpacity(0.5)),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset(
                                          "assets/images/search_icon.png",
                                          color: ApplicationColors.whiteColor,
                                      ),
                                    ),

                                    // ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ApplicationColors.blackColor2E
                                      .withOpacity(0.5),
                                  border: Border.all(
                                      color: ApplicationColors
                                          .redColor67,
                                      width: 1),
                                )),
                          ),*/

                         /* Theme(
                            data: ThemeData(
                              textTheme: TextTheme(subtitle1: TextStyle(color: Colors.white)),
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
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: Text(
                                    item.deviceName,
                                    style: TextStyle(
                                        color: ApplicationColors.whiteColor,
                                        fontSize: 15,
                                        fontFamily: "Poppins-Regular",
                                        letterSpacing: 0.75
                                    ),
                                  ),
                                );
                              },
                              searchFieldProps: TextFieldProps(
                                style: TextStyle(
                                    color: ApplicationColors.whiteColor,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75
                                ),
                                decoration:InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: ApplicationColors.textfieldBorderColor,
                                        width: 1,
                                      )
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: ApplicationColors.textfieldBorderColor,
                                      width: 1,
                                    ),
                                  ),
                                  hintText: "Search vehicle",
                                  hintStyle: TextStyle(
                                      color: ApplicationColors.whiteColor,
                                      fontSize: 15,
                                      fontFamily: "Poppins-Regular",
                                      letterSpacing: 0.75
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              dropdownSearchBaseStyle: TextStyle(
                                  color: ApplicationColors.whiteColor,
                                  fontSize: 15,
                                  fontFamily: "Poppins-Regular",
                                  letterSpacing: 0.75
                              ),

                              dropdownSearchDecoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: ApplicationColors.redColor67,
                                      width: 1,
                                    )
                                ),

                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: ApplicationColors.whiteColor,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: ApplicationColors.redColor67,
                                      width: 1,
                                    )
                                ),
                                hintText: widget.vName != "" ? widget.vName : "Search vehicle",
                                hintStyle: TextStyle(
                                    color: ApplicationColors.whiteColor,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75
                                ),
                                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),

                              items:_reportProvider.userVehicleDropModel.devices,
                              itemAsString: (VehicleList u) => u.deviceName,
                              onChanged: (VehicleList data) {
                                setState(() {
                                  vehicleId = data.id;
                                });
                              },
                            ),
                          ),*/

                          Center(
                            child: TextFormField(
                              style: Textstyle1.signupText1,
                              keyboardType: TextInputType.number,
                              controller: vehicleController,
                             readOnly: true,
                             /* validator: (value){
                                if(value.isEmpty){
                                  return "Select Litre";
                                }
                                return null;
                              },*/
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorStyle: FontStyleUtilities.h12(
                                  fontColor: ApplicationColors.redColor,
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: ApplicationColors.redColor67),
                                    borderRadius: BorderRadius.circular(5)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ApplicationColors.whiteColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ApplicationColors.textfieldBorderColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintStyle: Textstyle1.signupText.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: ApplicationColors.textfieldBorderColor,
                                )
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
                                  width: 90,
                                  child: DropdownButtonFormField(
                                      iconEnabledColor:
                                      ApplicationColors.redColor67,
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
                                          border: InputBorder.none
                                      ),
                                      dropdownColor:
                                      ApplicationColors.whiteColor,

                                      value: _fuelProvider.chooseExpenseType,
                                      onChanged: (value) {
                                        _fuelProvider.chooseExpenseType = value;
                                      },
                                      items: [
                                        "${getTranslated(context, "cng")}",
                                        "${getTranslated(context, "petrol")}",
                                        "${getTranslated(context, "others")}",
                                      ].map((String value) =>
                                          DropdownMenuItem(
                                            child: Text(
                                              value,
                                              style: FontStyleUtilities.h14(
                                                fontColor: ApplicationColors.black4240,
                                                fontFamily: 'Poppins-Regular',
                                              ),
                                            ),
                                            value: value,
                                          ),
                                      ).toList()),
                                ),

                                SizedBox(width: 10),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          /*  Center(
                            child: TextFormField(
                              validator: (value){
                                if(value.isEmpty){
                                  return "Select Date";
                                }
                                return null;
                              },
                              readOnly: true,
                              style: Textstyle1.signupText,
                              keyboardType: TextInputType.number,
                              controller: datedController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                DateTime newSelectedDate =
                                await _selecttDate(context);
                                if (newSelectedDate != null) {
                                  setState(() {
                                    _selectedDate = newSelectedDate;
                                    // initializeDateFormatting('es');
                                    datedController..text = DateFormat("dd-MMM-yyyy")
                                          .format(_selectedDate)..selection = TextSelection.fromPosition(
                                        TextPosition(
                                            offset: currentdateController.text.length,
                                            affinity: TextAffinity.upstream,
                                        ),
                                    );
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ApplicationColors.whiteColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ApplicationColors.textfieldBorderColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                hintText: "Select Date",

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Image.asset(
                                    "assets/images/date_icon.png",
                                    width: 0,
                                  ),
                                ),
                                hintStyle: Textstyle1.signupText.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),*/

                          TextFormField(
                            readOnly: true,
                            style: FontStyleUtilities.h14(fontColor: ApplicationColors.black4240),
                            keyboardType: TextInputType.number,
                            controller: datedController,
                            validator: (value) {
                              if(value.isEmpty){
                                return "${getTranslated(context, "enter_select_date")}";
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
                                  datedController.text = DateFormat("dd-MMM-yyyy").format(newSelectedDate);
                                  expDate = newSelectedDate.toUtc().toString();
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
                              fillColor: ApplicationColors.whiteColor,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Image.asset(
                                  "assets/images/date_icon.png",  color:ApplicationColors.redColor67 ,
                                  width: 20,
                                ),
                              ),
                              hintStyle: FontStyleUtilities.h14(fontColor: ApplicationColors.whiteColor
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ApplicationColors.whiteColor.withOpacity(0.5)),
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

                          SizedBox(height: 18),

                          Center(
                            child: TextFormField(
                              style: Textstyle1.signupText1,
                              keyboardType: TextInputType.number,
                              controller: litreController,
                              validator: (value){
                                if(value.isEmpty){
                                  return "${getTranslated(context, "select_litre")}";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorStyle: FontStyleUtilities.h12(
                                  fontColor: ApplicationColors.redColor,
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: ApplicationColors.redColor67),
                                    borderRadius: BorderRadius.circular(5)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ApplicationColors.black4240),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ApplicationColors.textfieldBorderColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "${getTranslated(context, "liter")}",
                                hintStyle: Textstyle1.signupText.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 34),

                          Center(
                            child: IntrinsicWidth(
                              child: TextFormField(
                                style: FontStyleUtilities.h36().copyWith(
                                    color: ApplicationColors.black4240,
                                    overflow: TextOverflow.ellipsis
                                ),
                                keyboardType: TextInputType.number,
                                controller: amountController,
                                decoration: InputDecoration(
                                    prefixIcon: Text(
                                      "${getTranslated(context, "₹")}",
                                      overflow: TextOverflow.visible,
                                      style: FontStyleUtilities.h36(fontColor: ApplicationColors.black4240),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: "0",
                                    hintStyle: FontStyleUtilities.h36(fontColor: ApplicationColors.black4240)
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.002),

                          Center(
                            child: Text(
                                "${getTranslated(context, "enter_amount")}",
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: FontStyleUtilities.h14(fontColor: ApplicationColors.black4240)),
                          ),

                          SizedBox(height: height * 0.1),

                        ],
                      ),
                      decoration: BoxDecoration(
                        color: ApplicationColors.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(height: height*0.035),
                    Row(
                      children: [
                        Expanded(
                            child: CustomElevatedButton(
                              onPressed: () async {
                                if(_forMKey.currentState.validate()){
                                    updateFuel();
                                }
                              },
                              buttonText: "${getTranslated(context, "submit")}",
                              buttonColor: ApplicationColors.redColor67,
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.035),

                  ],
                ),
              ),
            ),
          ),
        ),


      ],
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
              primary:ApplicationColors.blackColor2E,
              onPrimary: Colors.white,
              surface: ApplicationColors.redColor67,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      }
  );
  return newSelectedDate;
}
