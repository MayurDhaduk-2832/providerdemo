import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/custom_dialog.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ProductsFilterPage/vehicle_filter.dart';


class UserTripReportScreen extends StatefulWidget {
  const UserTripReportScreen({Key key}) : super(key: key);

  @override
  _UserTripReportScreenState createState() => _UserTripReportScreenState();
}

class _UserTripReportScreenState extends State<UserTripReportScreen> {

  ReportProvider _reportProvider;

  var height,width;
  TextEditingController datedController=TextEditingController();
  TextEditingController _endDateController=TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  var fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toUtc().toString();

  var vehicleId = "", vehicleName = "";

  userTripReport() async {

    var idList = "";
    String list;
    if (_selectedVehicle.isNotEmpty) {
      for (int i = 0; i < _selectedVehicle.length; i++) {
        idList = idList + "${_selectedVehicle[i].id},";
      }
    }

    list = idList.substring(0, idList.length - 1);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uId": "$id",
      "from_date": fromDate.toString(),
      "to_date": toDate.toString(),
      "device": list,
    };

    print('UserTripData-->$data');

    _reportProvider.getUserTrip(data, "user_trip/trip_detail");
  }

  List _selectedVehicle = [];

  var exportType = "excel";

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        final _items = _reportProvider.userVehicleDropModel.devices
            .map((vehicle) =>
            MultiSelectItem<VehicleList>(vehicle, vehicle.deviceName))
            .toList();
        return MultiSelectDialog(
          items: _items,
          onConfirm: (values) {
            _selectedVehicle = values;
            if (_selectedVehicle.isNotEmpty) {
              userTripReport();
            }
            setState(() {});
          },
          closeSearchIcon: Icon(
            Icons.close,
            color: ApplicationColors.black4240,
          ),
          searchIcon: Icon(
            Icons.search,
            color: ApplicationColors.black4240,
          ),
          confirmText: Text(
            "${getTranslated(context, "apply_small_word")}",
            style: TextStyle(
                color: ApplicationColors.whiteColor,
                fontFamily: "Poppins-Regular",
                fontSize: 18),
          ),
          cancelText: Text(
            "${getTranslated(context, "cancel_small_word")}",
            style: TextStyle(
                color: ApplicationColors.whiteColor,
                fontFamily: "Poppins-Regular",
                fontSize: 18),
          ),
          searchHintStyle: TextStyle(
              color: ApplicationColors.black4240,
              fontFamily: "Poppins-Regular",
              fontSize: 14),
          searchable: true,
          title: Text(
            "${getTranslated(context, "search")}",
            style: TextStyle(
                color: ApplicationColors.black4240,
                fontFamily: "Poppins-Regular",
                fontSize: 14),
          ),
          backgroundColor: ApplicationColors.blackColor2E,
          selectedColor: ApplicationColors.redColor67,
          unselectedColor: ApplicationColors.textfieldBorderColor,
          searchTextStyle: TextStyle(
              color: ApplicationColors.black4240,
              fontFamily: "Poppins-SemiBold",
              fontSize: 15),
          itemsTextStyle: TextStyle(
              color: ApplicationColors.black4240,
              fontFamily: "Poppins-SemiBold",
              fontSize: 15),
          selectedItemsTextStyle: TextStyle(
              color: ApplicationColors.black4240,
              fontFamily: "Poppins-SemiBold",
              fontSize: 15),
          checkColor: ApplicationColors.redColor67,
          initialValue: _selectedVehicle,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    datedController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}";
    _endDateController = TextEditingController()
      ..text = "${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}";
    _reportProvider.userTripList.clear();
    _reportProvider.isUserTripLoading = false;
  }


  @override
  Widget build(BuildContext context) {
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: ApplicationColors.whiteColorF9
            /*image: DecorationImage(
              image: AssetImage(
                  "assets/images/background_color_11.png"
              ), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),*/
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            titleSpacing: -5,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 13.0,top: 13),
              child: IconButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  },
                icon: Image.asset(
                    "assets/images/vector_icon.png",
                  color:ApplicationColors.redColor67 ,
                ),
              ),
            ),
            title: Text(
                "${getTranslated(context, "trip_report")}",
                style: Textstyle1.appbartextstyle1,
              overflow: TextOverflow.ellipsis
            ),
            backgroundColor: ApplicationColors.blackColor2E,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, bottom: 20, top: 20, right: 0),
                child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    titlePadding: EdgeInsets.all(0),
                                    backgroundColor: Colors.transparent,
                                    title: Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                          color: ApplicationColors.blackColor2E,
                                          borderRadius: BorderRadius.circular(6)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Text(
                                              "${getTranslated(context, "select_export_option")}",
                                              style: Textstyle1.text18bold,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Divider(
                                              color:
                                              ApplicationColors.dropdownColor3D,
                                              thickness: 2,
                                              height: 0,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  exportType = "excel";
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                        color: exportType == "excel"
                                                            ? ApplicationColors
                                                            .redColor67
                                                            : Colors.transparent,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: ApplicationColors
                                                                .redColor67),
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "${getTranslated(context, "export_excel")}",
                                                    style: Textstyle1.text11,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  exportType = "pdf";
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                        color: exportType == "pdf"
                                                            ? ApplicationColors
                                                            .redColor67
                                                            : Colors.transparent,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: ApplicationColors
                                                                .redColor67),
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "${getTranslated(context, "export_pdf")}",
                                                    style: Textstyle1.text11,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      height: height * .04,
                                                      padding: EdgeInsets.all(5),
                                                      decoration:
                                                      Boxdec.buttonBoxDecRed_r6,
                                                      child: Center(
                                                        child: Text(
                                                          "${getTranslated(context, "cancel")}",
                                                          style: Textstyle1
                                                              .text14bold
                                                              .copyWith(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      if ("vehicleId" != "") {
                                                        if (exportType == "pdf") {
                                                          List<String> sendList = [];
                                                          for (int i = 0;
                                                          i <
                                                              _reportProvider
                                                                  .userTripList
                                                                  .length;
                                                          i++) {
                                                            var list = _reportProvider.userTripList[i];
                                                            var time;
                                                            if (list.startTime != null &&
                                                                list.endTime != null) {
                                                              var avTime = DateFormat("HH:mm")
                                                                  .format(DateTime.parse(
                                                                "${list.startTime}",
                                                              ));
                                                              var dvTime = DateFormat("HH:mm")
                                                                  .format(DateTime.parse(
                                                                  "${list.endTime}"
                                                              ));
                                                              var format = DateFormat("HH:mm");
                                                              var one = format.parse(avTime);
                                                              var two = format.parse(dvTime);
                                                              time = two.difference(one);
                                                            }
                                                            sendList.add(""
                                                                'Vehicle Name : "${list.device.deviceName}"'
                                                                "\n\n"
                                                                "Date : "
                                                                "${DateFormat("dd MMM yyyy").format(DateTime.parse(
                                                                "${list.createdOn}"
                                                            ))}" "\t"
                                                                "${DateFormat.jm().format(DateTime.parse("${list.createdOn}"
                                                            ))}"
                                                                "\n\n"
                                                                "Time Duration : ${time.toString().split(":").first} Hr : ${time.toString().split(":")[1]} Min"
                                                                "\n\n"
                                                                'Address : ${_reportProvider.userTripStartAddressList[i]}"'
                                                                "\n\n"
                                                            );
                                                          }

                                                          var idList = "";
                                                          String list;
                                                          if (_selectedVehicle.isNotEmpty) {
                                                            for (int i = 0; i < _selectedVehicle.length; i++) {
                                                              idList = idList + "${_selectedVehicle[i].deviceName},\n";
                                                            }
                                                          }

                                                          list = idList.substring(0, idList.length - 2);

                                                          if (sendList.isNotEmpty) {
                                                            generatePdf(sendList,
                                                                list);
                                                          } else {
                                                            Helper.dialogCall.showToast(
                                                                context,
                                                                "${getTranslated(context, "vehicle_report_is_empty")}"
                                                            );
                                                          }
                                                        } else {
                                                          List sendList = [];
                                                          for (int i = 0;
                                                          i <
                                                              _reportProvider
                                                                  .userTripList
                                                                  .length;
                                                          i++) {
                                                            var list = _reportProvider.userTripList[i];
                                                            var time;
                                                            if (list.startTime !=
                                                                null &&
                                                                list.endTime !=
                                                                    null) {
                                                              var avTime = DateFormat("HH:mm")
                                                                  .format(DateTime.parse(
                                                                "${list.startTime}",
                                                              ));
                                                              var dvTime = DateFormat("HH:mm")
                                                                  .format(DateTime.parse(
                                                                  "${list.endTime}"
                                                              ));
                                                              var format = DateFormat("HH:mm");
                                                              var one = format.parse(avTime);
                                                              var two = format.parse(dvTime);
                                                              time = two.difference(one);
                                                            }
                                                            var data = {
                                                              "a":
                                                              "${list.device.deviceName}",
                                                              "b":
                                                              "${DateFormat("dd MMM yyyy").format(DateTime.parse(
                                                                  "${list.createdOn}"
                                                              ))}"
                                                              "${DateFormat.jm().format(DateTime.parse(
                                                                  "${list.createdOn}"
                                                              ))}",
                                                              "c":
                                                              "${time.toString().split(":").first} Hr : ${time.toString().split(":")[1]} Min",
                                                              "d":
                                                              "${_reportProvider.userTripStartAddressList[i]}",
                                                              "e": "",
                                                              "f": "",
                                                              "g": "",
                                                              "h": "",
                                                              "i": "",
                                                              "j": "",
                                                              "k": "",
                                                              "l": "",
                                                            };

                                                            sendList.add(data);
                                                          }

                                                          List excelTitle = [
                                                            'Vehicle Name',
                                                            'Date ',
                                                            'Time Duration',
                                                            'Address',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                          ];

                                                          var idList = "";
                                                          String list;
                                                          if (_selectedVehicle.isNotEmpty) {
                                                            for (int i = 0; i < _selectedVehicle.length; i++) {
                                                              idList = idList + "${_selectedVehicle[i].deviceName},\n";
                                                            }
                                                          }

                                                          list = idList.substring(0, idList.length - 1);

                                                          if (sendList.isNotEmpty) {
                                                            generateExcel(
                                                                sendList,
                                                                list,
                                                                excelTitle);
                                                          } else {
                                                            Helper.dialogCall.showToast(
                                                                context,
                                                                "${getTranslated(context, "vehicle_report_is_empty")}"
                                                            );
                                                          }
                                                        }
                                                        //  Navigator.pop(context);
                                                      } else {
                                                        Helper.dialogCall.showToast(
                                                            context,
                                                            "${getTranslated(context, "select_vehicle")}"
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      height: height * .04,
                                                      padding: EdgeInsets.all(5),
                                                      decoration:
                                                      Boxdec.buttonBoxDecRed_r6,
                                                      child: Center(
                                                        child: Text(
                                                          "${getTranslated(context, "export")}",
                                                          style: Textstyle1
                                                              .text14bold
                                                              .copyWith(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          });
                      //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>GroupsScreen()));
                    },
                    child: Image.asset(
                      "assets/images/threen_verticle_options_icon.png",
                      color:ApplicationColors.redColor67 ,
                      width: 30,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),

          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20,0,20,15),
                  decoration: BoxDecoration(
                      color: ApplicationColors.blackColor2E
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              style: Textstyle1.signupText1,
                              keyboardType: TextInputType.number,
                              controller: datedController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                dateTimeSelect();
                              },
                              decoration: fieldStyle.copyWith(
                                isDense: true,
                                hintText: "From Date",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Image.asset(
                                    "assets/images/date_icon.png",
                                    color:ApplicationColors.redColor67 ,
                                    width: 5,
                                    height: 5,
                                  ),
                                ),
                                hintStyle: Textstyle1.signupText1,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Center(
                              child: Text(
                                "${getTranslated(context,"to")}",
                                style: Textstyle1.signupText
                                    .copyWith(color: Colors.black),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              style: Textstyle1.signupText1,
                              keyboardType: TextInputType.number,
                              controller: _endDateController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                endDateTimeSelect();
                              },
                              decoration: fieldStyle.copyWith(
                                hintStyle: Textstyle1.signupText.copyWith(
                                  color: Colors.white,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Image.asset(
                                    "assets/images/date_icon.png",
                                    color:ApplicationColors.redColor67 ,
                                    width: 5,
                                    height: 5,
                                  ),
                                ),
                                hintText: "End Date",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          _showMultiSelect(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: ApplicationColors.textfieldBorderColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/search_icon.png",
                                color:ApplicationColors.redColor67 ,
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: _selectedVehicle.isNotEmpty
                                    ? Container(
                                  height: 30,
                                  padding: EdgeInsets.only(top: 3),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _selectedVehicle.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Text(
                                            "${_selectedVehicle[index].deviceName}, ",
                                            style: TextStyle(
                                                color: ApplicationColors
                                                    .black4240,
                                                fontSize: 14,
                                                fontFamily:
                                                "Poppins-Regular",
                                                letterSpacing: 0.75),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                                    : Text(
                                  "${getTranslated(context, "search_vehicle")}",
                                  style: TextStyle(
                                      color: ApplicationColors.black4240,
                                      fontSize: 15,
                                      fontFamily: "Poppins-Regular",
                                      letterSpacing: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 25,top: 20),
                  child: Container(
                    height: height - 260,
                    width: width,
                    child:
                    _reportProvider.isUserTripLoading
                        ?
                    Helper.dialogCall.showLoader()
                        :
                    _reportProvider.userTripList.isEmpty
                        ?
                    Center(
                      child: Text(
                        "${getTranslated(context, "user_trip_not_available")}",
                        textAlign: TextAlign.center,
                        style: Textstyle1.text18.copyWith(
                          fontSize: 18,
                          color: ApplicationColors.redColor67,
                        ),
                      ),
                    )
                        :
                    ListView.builder(
                        itemCount: _reportProvider.userTripList.length,
                        shrinkWrap: true,
                        itemBuilder: (context,i) {
                          var list = _reportProvider.userTripList[i];
                          var time;
                          if (list.startTime !=
                              null &&
                              list.endTime !=
                                  null) {
                            var avTime = DateFormat("HH:mm")
                                .format(DateTime.parse(
                              "${list.startTime}",
                            ));
                            var dvTime = DateFormat("HH:mm")
                                .format(DateTime.parse(
                              "${list.endTime}"
                            ));
                            var format = DateFormat("HH:mm");
                            var one = format.parse(avTime);
                            var two = format.parse(dvTime);
                            time = two.difference(one);
                            print("time is-----------: $time");
                          }
                          return Column(
                            children: [
                              IntrinsicHeight(
                                child: Container(
                                  decoration: Boxdec.bcgreyrad6.copyWith(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.all(2),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          decoration: Boxdec.conrad6colorblack,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      "assets/images/car_icon.png",
                                                      width: 15
                                                  ),
                                                  SizedBox(width:10),
                                                  Text(
                                                    "${list.device.deviceName}",
                                                    style: Textstyle1.text14bold,
                                                    overflow: TextOverflow.visible,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Text(
                                                    "${getTranslated(context, "user_trip")}",
                                                    style: Textstyle1.text11,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.visible,
                                                  ),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/clock_icon_vehicle_Page.png",
                                                    width: 10
                                                  ),
                                                  SizedBox(width:10),
                                                  Text(
                                                    "${DateFormat("dd MMM yyyy").format(
                                                        DateTime.parse(
                                                        "${list.createdOn}"
                                                        )
                                                    )}",
                                                    style: Textstyle1.text10,
                                                    overflow: TextOverflow.visible,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "${DateFormat.jm().format(
                                                        DateTime.parse(
                                                            "${list.createdOn}"
                                                        ))}",
                                                    style: Textstyle1.text10,
                                                    overflow: TextOverflow.visible,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start,
                                                  ),
                                            Expanded(child: SizedBox()),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                                              decoration: Boxdec.buttonBoxDecRed_r6,
                                              child: Center(
                                                child: Text(
                                                  "${time.toString().split(":").first} Hr : ${time.toString().split(":")[1]} Min",

                                                  style: Textstyle1.text10white,
                                                  overflow: TextOverflow.visible,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            )
                                          ],),
                                          SizedBox(height: 7,),
                                          Row(
                                            children: [
                                            Image.asset(
                                              "assets/images/red_rount_icon.png",
                                              width: 10,
                                              color: ApplicationColors.greenColor370
                                            ),
                                            SizedBox(width:10,),
                                            Expanded(
                                                child: Text(
                                                  _reportProvider.userTripStartAddressList.isEmpty ||
                                                      _reportProvider.userTripStartAddressList[i] == null
                                                      ?
                                                      "Address Not Found"
                                                      :
                                                  "${_reportProvider.userTripStartAddressList[i]}",
                                                  style: Textstyle1.text10,
                                                  overflow: TextOverflow.visible,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                )
                                            ),
                                          ],)
                                        ],),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: height*0.02),
                            ],
                          );
                        }
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
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
        fromDate = fromDatePicked.toUtc().toString();
      });

      if (datedController.text != null && _selectedVehicle.isNotEmpty) {
        userTripReport();
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
        toDate = endDatePicked.toUtc().toString();
      });

      if (_endDateController.text != null && _selectedVehicle.length != 0) {
        userTripReport();
      }
    }
  }

}















