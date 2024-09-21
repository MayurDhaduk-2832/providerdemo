import 'dart:ui';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/get_route_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteViolationReportPage extends StatefulWidget {
  const RouteViolationReportPage({Key key}) : super(key: key);

  @override
  RouteViolationReportPageState createState() => RouteViolationReportPageState();
}

class RouteViolationReportPageState extends State<RouteViolationReportPage> {

  var height,width;
  DateTime _selectedDate = DateTime.now();
  TextEditingController datedController=TextEditingController();
  TextEditingController _endDateController=TextEditingController();
  TextEditingController currentdateController = new TextEditingController();
  var vId;
  var vName;
  ReportProvider _reportProvider;

  var fromDate = DateTime.now().subtract(Duration(days: 1)).toString();
  var toDate = DateTime.now().toString();

  routeViolationReport()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data = {
      "from_date": fromDate,
      "to_date":toDate,
      "_u":id,
      "trackid":"$vId",

      /*"from_date": "2022-04-02T18:30:00.000Z",
      "to_date":"2022-04-05T18:29:59.867Z",
      "_u":"5cee7da97a38f414a4e5dfa3",
      "trackid":"61c42598eea8f225940e13da",*/
    };


    await _reportProvider.routeViolationReport(data, "notifs/RouteVoilationReprot");

  }


  getAlRoute() async {
    print("in  getalrountfunction calling------------");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    print(id);
    await _reportProvider.getAllRoute("trackRoute/user/5cee7da97a38f414a4e5dfa3");
  }

  @override
  void initState() {
    super.initState();
    datedController=TextEditingController()..text = "${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}";
    _endDateController=TextEditingController()..text = "${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}";
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _reportProvider.routeViolationReportList.clear();
    _reportProvider.isRouteViolationLoading =false;
    getAlRoute();
  }

  var exportType = "excel";

  @override
  Widget build(BuildContext context) {
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return  Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: ApplicationColors.whiteColorF9
           /* image: DecorationImage(
              image: AssetImage("assets/images/background_color_11.png"), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),*/
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 10.0,top: 10),
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                  },
                icon:Image.asset(
                    "assets/images/vector_icon.png",
                  color:ApplicationColors.redColor67 ,

                )
              ),
            ),
            title: Text(
                "${getTranslated(context, "route_violation_report")}",
                style: Textstyle1.appbartextstyle1
            ),
            backgroundColor: ApplicationColors.blackColor2E,elevation: 0,
           /* actions: [
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
                                              "Select Export option",
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
                                                    "Export to Excel",
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
                                                    "Export to PDF",
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
                                                          "CANCEL",
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
                      width: 30,
                    )),
              ),
              SizedBox(width: 10,),
            ],*/

            actions: [
              //SizedBox(width: 40,),
              /* InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsFilter()));
                },
                child:Padding(
                  padding: const EdgeInsets.only(left: 10,right: 5),
                  child: Image.asset("assets/images/search_icon.png",width: 20),
                ),
              ),*/
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
                                                        color:
                                                        exportType == "pdf"
                                                            ?
                                                        ApplicationColors.redColor67
                                                            :
                                                        Colors.transparent,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: ApplicationColors.redColor67
                                                        ),
                                                      )
                                                  ),
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
                                                          style: Textstyle1.text14boldwhite.copyWith(
                                                              fontSize: 12
                                                          ),
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
                                                          for (int i = 0; i < _reportProvider.routeViolationReportList.length; i++) {
                                                            sendList.add(
                                                                ""
                                                                "Vehicle Name : ${_reportProvider.routeViolationReportList[i].vehicleName}"
                                                                "\n"
                                                                "Route : ${_reportProvider.routeViolationReportList[i].route}"
                                                                "\n"
                                                                "Date & Time : ${ DateFormat("MMM dd, yyyy hh:mm aa").format(_reportProvider.routeViolationReportList[i].timestamp)}"
                                                                "\n"
                                                                "Address : ${_reportProvider.routeAddressList[i]}"
                                                                "\n"
                                                            );
                                                          }

                                                          if(sendList.isNotEmpty){
                                                            generatePdf(sendList,
                                                                vId);
                                                          }
                                                          else{
                                                            Helper.dialogCall.showToast(
                                                                context,
                                                                "${getTranslated(context, "vehicle_report_is_empty")}"
                                                            );
                                                          }
                                                          // generatePdf(sendList,
                                                          //     "vehicleName");
                                                        } else {
                                                          List sendList = [];
                                                          for (int i = 0; i < _reportProvider.routeViolationReportList.length; i++) {
                                                            var data = {
                                                              "a": "${_reportProvider.routeViolationReportList[i].vehicleName}",
                                                              "b": "${_reportProvider.routeViolationReportList[i].route}",
                                                              "c": "${DateFormat("MMM dd,yyyy hh:mm aa").format(_reportProvider.routeViolationReportList[i].timestamp)}",
                                                              "d": "${_reportProvider.routeAddressList[i]}",
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
                                                            'Route',
                                                            'Date & Time',
                                                            'Address',
                                                            "",
                                                            "",
                                                            "",
                                                            "",
                                                            "",
                                                            "",
                                                            "",
                                                            "",
                                                          ];

                                                          if(sendList.isNotEmpty){
                                                            generateExcel(
                                                                sendList,
                                                                vId,
                                                                excelTitle);
                                                          }
                                                          else{
                                                            Helper.dialogCall.showToast(
                                                                context,
                                                                "${getTranslated(context, "vehicle_report_is_empty")}"
                                                            );
                                                          }

                                                          // generateExcel(
                                                          //     sendList,
                                                          //     "vehicleName",
                                                          //     excelTitle);
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
                                                              .text14boldwhite
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
            ],
          ),

          body: _reportProvider.isGetRouteLoading
              ?
          Helper.dialogCall.showLoader()
              :
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ApplicationColors.blackColor2E,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                                // setState(() {
                                //   datedController.text = DateFormat("dd MMM yyyy").format(dateTimeSelect());
                                // });
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
                                hintStyle: Textstyle1.signupText1,
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

                      Theme(
                        data: ThemeData(
                          textTheme: TextTheme(subtitle1: TextStyle(color: Colors.black)),
                        ),
                        child: DropdownSearch<GetRouteModel>(
                          popupBackgroundColor: ApplicationColors.blackColor2E,
                          mode: Mode.DIALOG,
                          showSearchBox: true,
                          showAsSuffixIcons: true,
                          dialogMaxWidth: width,

                          popupItemBuilder: (context, item, isSelected) {

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: Text(
                                item.name,
                                style: TextStyle(
                                    color: ApplicationColors.black4240,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75
                                ),
                              ),
                            );
                          },

                          emptyBuilder: (context,string){
                            return Center(
                              child: Text(
                                "${getTranslated(context, "vehicle_not_found")}",
                                style: TextStyle(
                                    color: ApplicationColors.black4240,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Regular",
                                    letterSpacing: 0.75
                                ),
                              ),
                            );
                          },

                          searchFieldProps: TextFieldProps(
                            style: TextStyle(
                                color: ApplicationColors.black4240,
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
                                  )
                              ),
                              hintText: "${getTranslated(context, "search_route")}",
                              hintStyle: TextStyle(
                                  color: ApplicationColors.black4240,
                                  fontSize: 15,
                                  fontFamily: "Poppins-Regular",
                                  letterSpacing: 0.75
                              ),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          dropdownSearchBaseStyle: TextStyle(
                              color: ApplicationColors.black4240,
                              fontSize: 15,
                              fontFamily: "Poppins-Regular",
                              letterSpacing: 0.75
                          ),

                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: ApplicationColors.textfieldBorderColor,
                                  width: 1,
                                )
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Image.asset(
                                "assets/images/search_icon.png",
                                color:ApplicationColors.redColor67 ,

                                height: 10,
                                width: 10,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: ApplicationColors.textfieldBorderColor,
                                  width: 1,
                                )
                            ),
                            hintText: "${getTranslated(context, "search_route")}",
                            hintStyle: TextStyle(
                                color: ApplicationColors.black4240,
                                fontSize: 15,
                                fontFamily: "Poppins-Regular",
                                letterSpacing: 0.75
                            ),
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),

                          items:_reportProvider.getRouteList,
                          itemAsString: (GetRouteModel u) => u.name,
                          onChanged: (GetRouteModel data) {
                            setState(() {
                              vId = data.id;
                              print("Vid is:$vId");
                              routeViolationReport();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Expanded(
                child:Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _reportProvider.isRouteViolationLoading
                      ?
                  Helper.dialogCall.showLoader()
                      :
                  _reportProvider.routeViolationReportList.isEmpty
                      ?
                  Center(
                    child: Text(
                      "${getTranslated(context, "route_report_not_available")}",
                      textAlign: TextAlign.center,
                      style: Textstyle1.text18.copyWith(
                        fontSize: 18,
                        color: ApplicationColors.redColor67,
                      ),
                    ),
                  )
                      :
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: _reportProvider.routeViolationReportList.length,
                      shrinkWrap: true,
                      itemBuilder: (context,i) {
                        var list = _reportProvider.routeViolationReportList[i];
                        return Column(
                          children: [
                            Container(
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
                                      SizedBox(width:10,),
                                      Text(
                                        "${list.vehicleName}",
                                        style: Textstyle1.text14bold,
                                        overflow: TextOverflow.visible,
                                        maxLines: 1,
                                      ),
                                      Expanded(child: SizedBox(width:10,)),
                                      Text(
                                         "${list.route}",
                                          style: Textstyle1.text12,
                                          overflow: TextOverflow.visible,
                                          maxLines: 1,
                                      ),
                                      SizedBox(width:8),

                                      Image.asset(
                                        //"assets/images/out_ic.png",
                                        list.route == "left"
                                            ?
                                        "assets/images/out_ic.png"
                                            :
                                        "assets/images/in_ic.png",
                                        width: 15,
                                        height: 15,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/clock_icon_vehicle_Page.png",
                                        width: 10
                                      ),
                                      SizedBox(width:10),
                                      Text(
                                         DateFormat("MMM dd,yyyy hh:mm aa").format(list.timestamp),
                                        style: Textstyle1.text10,
                                        overflow: TextOverflow.visible,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7,),
                                  Row(
                                    children: [
                                      Image.asset("assets/images/red_rount_icon.png",width: 10,color: ApplicationColors.greenColor370,),
                                      SizedBox(width:10,),
                                      Expanded(
                                        child: Text(
                                          _reportProvider.routeAddressList.isEmpty ||
                                          _reportProvider.routeAddressList[i] == null
                                              ?
                                              "Address Not Found"
                                              :
                                          "${_reportProvider.routeAddressList[i]}",
                                          style: Textstyle1.text10,
                                          maxLines: 2,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],

                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10,)
                          ],
                        );
                      }
                  ),
                ),
              ),

            ],
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
        fromDate = datedController.text;
      });

      if (vId != null && datedController.text.isNotEmpty) {
        print("before from date getalrountfunction calling------------");
        getAlRoute();
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

      if (vId != null && _endDateController.text.isNotEmpty) {
        print("before end date getalrountfunction calling------------");
        getAlRoute();
      }
    }
  }


}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

