import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/create_excel.dart';
import 'package:oneqlik/Helper/create_pdf.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/use_drop_down_vehicle_model.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Provider/user_provider.dart';

class DailyReportsScreen extends StatefulWidget {
  const DailyReportsScreen({Key key}) : super(key: key);

  @override
  _DailyReportsScreenState createState() => _DailyReportsScreenState();
}

class _DailyReportsScreenState extends State<DailyReportsScreen> {


  ReportProvider _reportProvider;
  UserProvider _userProvider;

  var exportType = "excel";
  var vId;
  var vName;
  dailyReportList() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "user":id,
      "date":DateTime.now().toString(),
      "device":vId,
      // "device":"004204317545",
    };

    print(data);

    _reportProvider.dailyReportList(data, "devices/dailyReport");
  }


  @override
  void initState() {
    super.initState();
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _reportProvider.getDailyReportList.clear();
  }


  @override
  Widget build(BuildContext context) {
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    _userProvider = Provider.of<UserProvider>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ApplicationColors.whiteColor
            /*color: ApplicationColors.whiteColorF9*/
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
              "${getTranslated(context, "daily_report")}",
              textAlign: TextAlign.start,
              style: Textstyle1.appbartextstyle1,
            ),
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
                                          color: ApplicationColors.whiteColor,
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
                                                              .text14boldwhite
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
                                                          List<String> sendList =
                                                          [];
                                                          for (int i = 0;
                                                          i <
                                                              _reportProvider
                                                                  .getDailyReportList
                                                                  .length;
                                                          i++) {
                                                            sendList.add(""
                                                                "Vehicle Name : ${_reportProvider.getDailyReportList[i].deviceName}"
                                                                "\n"
                                                                'Running : ${_reportProvider.getDailyReportList[i].todayRunning == null ? "0" : _reportProvider.getDailyReportList[i].todayRunning.toString().split(":").first}:${_reportProvider.getDailyReportList[i].todayRunning.toString().split(":").last}'
                                                                "\n"
                                                                'Stop : ${_reportProvider.getDailyReportList[i].todayStopped == null ? "0" :_reportProvider.getDailyReportList[i].todayStopped.toString().split(":").first}:${_reportProvider.getDailyReportList[i].todayStopped.toString().split(":").last} Hr/Min'
                                                                "\n"
                                                                'Idle : ${_reportProvider.getDailyReportList[i].tOfr == null ? "0" : _reportProvider.getDailyReportList[i].tOfr.toString().split(":").first}:${_reportProvider.getDailyReportList[i].tOfr.toString().split(":").last} Hr/Min'
                                                                "\n"
                                                                "Out Of Reach : ${_reportProvider.getDailyReportList[i].todayOdo == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[i].todayOdo)} ' '${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "Kms" : "Miles"}"
                                                                "\n"
                                                                "Distance : ${_reportProvider.getDailyReportList[i].todayOdo == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[i].todayOdo)}" "${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "Kms" : "Miles"}"
                                                                "\n"
                                                                'Over Speed : ${_reportProvider.getDailyReportList[i].maxSpeed == null ? "0" : _reportProvider.getDailyReportList[i].maxSpeed} Km/hr'
                                                                "\n"
                                                                'Trip : ${_reportProvider.getDailyReportList[i].todayTrips == null ?"" : _reportProvider.getDailyReportList[i].todayTrips}'
                                                                "\n"
                                                                'Fuel Consumption : ${_reportProvider.getDailyReportList[i].mileage == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[i].todayOdo/int.parse(_reportProvider.getDailyReportList[i].mileage))} ' '${_userProvider.useModel.cust.unitMeasurement == "LITER" ? "Litre" : "Pr"}'
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
                                                          for (int i = 0; i < _reportProvider.getDailyReportList.length; i++) {
                                                            var data = {
                                                              "a":
                                                              "${_reportProvider.getDailyReportList[i].deviceName}",
                                                              "b":
                                                              '${_reportProvider.getDailyReportList[i].todayRunning == null ? "0" :_reportProvider.getDailyReportList[0].todayRunning.toString().split(":").first}:${_reportProvider.getDailyReportList[0].todayRunning.toString().split(":").last} Hr/Min',
                                                              "c":
                                                              '${_reportProvider.getDailyReportList[i].todayStopped == null ? "0" :_reportProvider.getDailyReportList[0].todayStopped.toString().split(":").first}:${_reportProvider.getDailyReportList[0].todayStopped.toString().split(":").last} Hr/Min',
                                                              "d":
                                                              '${_reportProvider.getDailyReportList[i].tOfr == null ? "0" :_reportProvider.getDailyReportList[0].tOfr.toString().split(":").first}:${_reportProvider.getDailyReportList[0].tOfr.toString().split(":").last} Hr/Min',
                                                              "e":
                                                              "${_reportProvider.getDailyReportList[i].todayOdo == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[0].todayOdo)} Kms",
                                                              "f":
                                                              "${_reportProvider.getDailyReportList[i].todayOdo == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[i].todayOdo)} Kms",
                                                              "g":
                                                              '${_reportProvider.getDailyReportList[i].maxSpeed == null ? "0" :_reportProvider.getDailyReportList[i].maxSpeed} Km/hr',
                                                              "h":
                                                              '${_reportProvider.getDailyReportList[i].todayTrips == null ? "0" :_reportProvider.getDailyReportList[i].todayTrips}',
                                                              "i":
                                                              '${_reportProvider.getDailyReportList[i].mileage == null ? "0" : NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[0].todayOdo/int.parse(_reportProvider.getDailyReportList[0].mileage))} Litre',
                                                              "j": "",
                                                              "k": "",
                                                              "l": "",
                                                            };

                                                            sendList.add(data);
                                                          }

                                                          List excelTitle = [
                                                            'Device Name',
                                                            'Running',
                                                            'Stop',
                                                            'Idle',
                                                            'Out Of Reach',
                                                            'Distance',
                                                            'Over Speed',
                                                            'Trip',
                                                            'Fuel Consumption',
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
                      color: ApplicationColors.redColor67,
                      width: 30,
                    )),
              ),
            ],
            backgroundColor: Colors.transparent, elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 14,left: 14,top: 15,bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Theme(
                    data: ThemeData(
                      textTheme: TextTheme(subtitle1: TextStyle(color: Colors.black)),
                    ),
                    child: DropdownSearch<VehicleList>(
                      popupBackgroundColor: ApplicationColors.whiteColor,
                      mode: Mode.DIALOG,
                      showSearchBox: true,
                      showAsSuffixIcons: true,
                      dialogMaxWidth: width,

                      popupItemBuilder: (context, item, isSelected) {

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Text(
                            item.deviceName,
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
                          hintText: "${getTranslated(context, "search_vehicle")}",
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
                            height: 10,
                            width: 10,
                            color:  ApplicationColors.redColor67,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: ApplicationColors.textfieldBorderColor,
                              width: 1,
                            )
                        ),
                        hintText: "${getTranslated(context, "search_vehicle")}",
                        hintStyle: TextStyle(
                            color: ApplicationColors.black4240,
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
                          vId = data.deviceId;
                          vName = data.deviceName;
                          dailyReportList();
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    height: height*0.8,
                    width: width,
                    child:  _reportProvider.isDailyReportListLoading
                        ?
                    Helper.dialogCall.showLoader()
                        :
                    _reportProvider.getDailyReportList.length == 0
                        ?
                    Center(
                      child: Text(
                        "${getTranslated(context,"daily_report_empty")}",
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
                        itemCount: _reportProvider.getDailyReportList.length,
                        shrinkWrap: true,
                        itemBuilder: (context,index) {
                          var getDailyReportList = _reportProvider.getDailyReportList[index];
                          return Column(
                            children: [
                              SizedBox(width: width*0.90,height: 20),
                              Container(
                                padding: EdgeInsets.only(left: 12,top: 14,right: 5),
                                height: 150,
                                width: width*0.88,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/images/vehicle_icon.png",color: ApplicationColors.redColor67,width: width*0.05,),
                                          SizedBox(width: width*0.02),
                                          Flexible(child: Text(
                                              "${getDailyReportList.deviceName}",
                                              style: FontStyleUtilities.s16(fontColor: ApplicationColors.black4240),overflow: TextOverflow.visible,maxLines: 1,textAlign: TextAlign.start)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Container(
                                                          height:15,
                                                          width: 15,
                                                          child: Center(child: Image.asset("assets/images/running_icon.png",width: 10)),
                                                          decoration: BoxDecoration(
                                                            color: ApplicationColors.greenColor370,
                                                            borderRadius: BorderRadius.circular(12),
                                                            boxShadow:  [
                                                              BoxShadow(
                                                                color: ApplicationColors.whiteColor,
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
                                                      ),
                                                      SizedBox(width: 3),
                                                      Flexible(
                                                        child: Text(
                                                          "${getTranslated(context, "running")}",
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: true,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.start,
                                                          style: Textstyle1.text10,),
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: width*0.5,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5.0),
                                                      child: Text(
                                                        getDailyReportList.todayRunning == null ? "" : "${getDailyReportList.todayRunning.toString().split(":").first}h ${getDailyReportList.todayRunning.toString().split(":").last}m",
                                                          style: Textstyle1.textb10.copyWith(color: Colors.black),
                                                          overflow: TextOverflow.visible,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.start,
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: ApplicationColors.textfieldBorderColor,
                                                    thickness: 1.5,indent: 0,
                                                    endIndent: 0,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: Text(
                                                      "${getTranslated(context, "distance")}",
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      maxLines: 1,
                                                      //textAlign: TextAlign.center,
                                                      style: Textstyle1.text10,),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: SizedBox(
                                                      width: width*0.5,
                                                      child: Text(
                                                          "${NumberFormat("##0.0#", "en_US").format(getDailyReportList.todayOdo)} " "${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "Kms" : "Miles"}",
                                                          style: Textstyle1.textb10.copyWith(color: Colors.black),overflow: TextOverflow.visible,maxLines: 1,textAlign: TextAlign.start),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          VerticalDivider(
                                            color: ApplicationColors.textfieldBorderColor,
                                            thickness: 1.5,
                                            width: 0,

                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Container(
                                                          height:15,
                                                          width: 15,
                                                          child: Center(child: Image.asset("assets/images/running_icon.png",width: 10)),
                                                          decoration: BoxDecoration(
                                                            color: ApplicationColors.redColor67,
                                                            borderRadius: BorderRadius.circular(12),
                                                            boxShadow:  [
                                                              BoxShadow(
                                                                color: ApplicationColors.whiteColor,
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
                                                      ),
                                                      SizedBox(width: 3),
                                                      Flexible(
                                                        child: Text(
                                                          "${getTranslated(context, "stop")}",
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: true,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.start,
                                                          style: Textstyle1.text10,),
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: width*0.5,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5.0),
                                                      child: Text(
                                                          getDailyReportList.todayStopped == null ? "" :"${getDailyReportList.todayStopped.toString().split(":").first}h ${getDailyReportList.todayStopped.toString().split(":").last}m",
                                                          style: Textstyle1.textb10.copyWith(color: Colors.black),overflow: TextOverflow.visible,maxLines: 1,textAlign: TextAlign.start),
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: ApplicationColors.textfieldBorderColor,
                                                    thickness: 1.5,indent: 0,
                                                    endIndent: 0,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: Text(
                                                      "${getTranslated(context, "over_speed")}",
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      maxLines: 1,
                                                      //textAlign: TextAlign.center,
                                                      style: Textstyle1.text10,),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: SizedBox(
                                                      width: width*0.5,
                                                      child: Text(
                                                          '${getDailyReportList.maxSpeed} ${_userProvider.useModel.cust.unitMeasurement == "${getTranslated(context, "mks")}" ? "${getTranslated(context, "Km")}" : "${getTranslated(context, "Miles")}"}/${getTranslated(context, "hr_small_word")}',
                                                          style: Textstyle1.textb10.copyWith(color: Colors.black),overflow: TextOverflow.visible,maxLines: 1,textAlign: TextAlign.start),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          VerticalDivider(
                                            color: ApplicationColors.textfieldBorderColor,
                                            thickness: 1.5,
                                            width: 0,

                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Container(
                                                          height:15,
                                                          width: 15,
                                                          child: Center(child: Image.asset("assets/images/running_icon.png",width: 10)),
                                                          decoration: BoxDecoration(
                                                            color: ApplicationColors.yellowColorD21,
                                                            borderRadius: BorderRadius.circular(12),
                                                            boxShadow:  [
                                                              BoxShadow(
                                                                color: ApplicationColors.whiteColor,
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
                                                      ),
                                                      SizedBox(width: 3),
                                                      Flexible(
                                                        child: Text(
                                                          "${getTranslated(context, "idle")}",
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: true,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.start,
                                                          style: Textstyle1.text10,),
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: width*0.5,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5.0),
                                                      child: Text(
                                                          getDailyReportList.tIdling == null ? "" : "${getDailyReportList.tIdling.toString().split(":").first}h ${getDailyReportList.tIdling.toString().split(":").last}m",
                                                          style: Textstyle1.textb10.copyWith(color: Colors.black),overflow: TextOverflow.visible,maxLines: 1,textAlign: TextAlign.start),
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: ApplicationColors.textfieldBorderColor,
                                                    thickness: 1.5,indent: 0,
                                                    endIndent: 0,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: Text(
                                                      "${getTranslated(context, "trip")}",
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      maxLines: 1,
                                                      //textAlign: TextAlign.center,
                                                      style: Textstyle1.text10,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: SizedBox(
                                                      width: width*0.5,
                                                      child: Text(
                                                          '${getDailyReportList.todayTrips}',
                                                          style: Textstyle1.textb10.copyWith(color: Colors.black),overflow: TextOverflow.visible,maxLines: 1,textAlign: TextAlign.start),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          VerticalDivider(
                                            color: ApplicationColors.textfieldBorderColor,
                                            thickness: 1.5,
                                            width: 0,

                                          ),

                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Container(
                                                          height:15,
                                                          width: 15,
                                                          child: Center(child: Image.asset("assets/images/running_icon.png",width: 10)),
                                                          decoration: BoxDecoration(
                                                            color: ApplicationColors.blueColorCE,
                                                            borderRadius: BorderRadius.circular(12),
                                                            boxShadow:  [
                                                              BoxShadow(
                                                                color: ApplicationColors.whiteColor,
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
                                                      ),
                                                      SizedBox(width: 3),
                                                      Flexible(
                                                        child: Text(
                                                          "${getTranslated(context, "out_reach")}",
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: true,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.start,
                                                          style: Textstyle1.text10,),
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: width*0.5,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5.0),
                                                      child: Text(
                                                        getDailyReportList.tOfr== null ? "" : '${getDailyReportList.tOfr.toString().split(":").first}h ${getDailyReportList.tOfr.toString().split(":").last}m',
                                                          style: Textstyle1.textb10.copyWith(color: Colors.black),
                                                          overflow: TextOverflow.visible,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.start,
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: ApplicationColors.textfieldBorderColor,
                                                    thickness: 1.5,indent: 0,
                                                    endIndent: 0,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: Text(
                                                      "${getTranslated(context, "fuel_con")}",
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.center,
                                                      style: Textstyle1.text10,),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: SizedBox(
                                                      width: width*0.5,
                                                      child: Text(''
                                                          '${NumberFormat("##0.0#", "en_US").format(_reportProvider.getDailyReportList[0].todayOdo/int.parse(_reportProvider.getDailyReportList[0].mileage))} ''${_userProvider.useModel.cust.unitMeasurement == "LITER" ? "Liter" : "Per"}',
                                                          style: Textstyle1.textb10.copyWith(color: Colors.black),overflow: TextOverflow.visible,maxLines: 1,textAlign: TextAlign.start),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: ApplicationColors.textFielfForegroundColor,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow:  [
                                    BoxShadow(
                                      color: ApplicationColors.textfieldBorderColor,
                                      offset: Offset(
                                        0,
                                        0,
                                      ),
                                      blurRadius: 10.0,
                                      spreadRadius: -4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );



                        }
                    ),

                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}



