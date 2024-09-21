import 'dart:async';

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/ProductsFilterPage/vehicle_filter.dart';
import 'package:oneqlik/utils/colors.dart';

class Loading_unloading_page extends StatefulWidget {
  const Loading_unloading_page({Key key}) : super(key: key);

  @override
  _Loading_unloading_pageState createState() => _Loading_unloading_pageState();
}

class _Loading_unloading_pageState extends State<Loading_unloading_page> {


  var height,width;
  DateTime _selectedDate = DateTime.now();
  TextEditingController datedController=TextEditingController();
  TextEditingController _endDateController=TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  List vehicle_no=["GJ14FT5326","GJ14FT5326"];
  List vehicle_time=["Des 25, 2020, 7:54:30 AM","Des 25, 2020, 7:54:30 AM"];
  List vehicle_location=["Navsari Rd, Silicon Shoppers, Chandanvan Society, Udhana Village, Udhna, Surat, Gujarat 394210","Navsari Rd, Silicon Shoppers, Chandanvan Society, Udhana Village, Udhna, Surat, Gujarat 394210"];



  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return  Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_color_11.png"), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,extendBody: true,resizeToAvoidBottomInset: false,
          appBar: AppBar(automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 13.0,top: 13),
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              },icon:Image.asset("assets/images/vector_icon.png",color: ApplicationColors.redColor67),),
            ),
            title: Text("Loading Unloading Report",style: Textstyle1.appbartextstyle1,overflow: TextOverflow.ellipsis,),
            backgroundColor: ApplicationColors.blackColor2E,elevation: 0,
            actions: [
              /*Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
                child: InkWell(onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductsFilter()));
                },child: Image.asset("assets/images/search_icon.png")),
              ),*/
              Padding(
                padding: const EdgeInsets.only(left: 0.0,bottom: 20,top: 20,right: 0),
                child: InkWell(
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(titlePadding: EdgeInsets.all(0),
                              backgroundColor:
                              Colors.transparent,
                              title: Container(width: width,
                                decoration: BoxDecoration(
                                    color: ApplicationColors
                                        .blackColor2E,
                                    borderRadius:
                                    BorderRadius
                                        .circular(6)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${getTranslated(context, "select_export_option")}",
                                        style: Textstyle1.text18bold,),

                                      SizedBox(height: 10,),

                                      Divider(color: ApplicationColors.dropdownColor3D,thickness: 2,height: 0,),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Image.asset("assets/images/red_rount_icon.png",width: 10,),
                                          SizedBox(width: 10,),
                                          Text("${getTranslated(context, "export_pdf")}",style: Textstyle1.text11,),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Image.asset("assets/images/red_rount_icon.png",width: 10,),
                                          SizedBox(width: 10,),
                                          Text("${getTranslated(context, "export_pdf")}",style: Textstyle1.text11,),
                                        ],
                                      ),
                                      SizedBox(height: 15,),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(onTap: (){
                                              Navigator.pop(context);
                                            },child: Container(height: height*.04,padding: EdgeInsets.all(5),decoration: Boxdec.buttonBoxDecRed_r6,child: Center(child: Text("CANCEL",style: Textstyle1.text14bold.copyWith(fontSize: 12),)))),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: InkWell(onTap: (){
                                              Navigator.pop(context);
                                            },child: Container(height: height*.04,padding: EdgeInsets.all(5),decoration: Boxdec.buttonBoxDecRed_r6,child: Center(child: Text(
                                              "${getTranslated(context, "export")}",
                                              style: Textstyle1.text14bold.copyWith(fontSize: 12),)))),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              )));
                      //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>GroupsScreen()));
                    },
                    child: Image.asset("assets/images/threen_verticle_options_icon.png",width: 30,)),
              ),
              SizedBox(width: 10,),
            ],),


          body: SingleChildScrollView(physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(decoration: BoxDecoration(color: ApplicationColors.blackColor2E),
                  //height: height*.074,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(padding: EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width / 2.6,
                                height: MediaQuery.of(context).size.height * .06,
                                child:
                                // TextFormField(onTap: (){ _selectDate(context);},controller: selectDate,),
                                TextFormField(
                                  readOnly: true,
                                  style: Textstyle1.signupText.copyWith(fontSize: 12,color: Colors.white),
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
                                        datedController
                                          ..text = DateFormat("dd-MMM-yyyy")
                                              .format(_selectedDate)
                                          ..selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset:
                                                  currentdateController
                                                      .text.length,
                                                  affinity:
                                                  TextAffinity.upstream));
                                      });
                                    }
                                  },
                                  decoration: fieldStyle.copyWith(isDense: true,
                                    hintText: "From Date",
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Image.asset(
                                        "assets/images/date_icon.png",
                                        width: 5,height: 5,
                                      ),
                                    ),
                                    hintStyle: Textstyle1.signupText.copyWith(
                                      color: Colors.white,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
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
                                child: Center(
                                    child: Text(
                                      "${getTranslated(context,"to")}",
                                      style: Textstyle1.signupText
                                          .copyWith(color: Colors.white),
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.6,
                                height: MediaQuery.of(context).size.height * .06,
                                child: TextFormField(
                                  readOnly: true,
                                  style: Textstyle1.signupText.copyWith(fontSize: 12,color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  controller: _endDateController,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();

                                    DateTime newSelectedDate =
                                    await _selecttDate(context);
                                    if (newSelectedDate != null) {
                                      setState(() {
                                        _selectedDate = newSelectedDate;
                                        //initializeDateFormatting('es');
                                        _endDateController
                                          ..text = DateFormat("dd-MMM-yyyy")
                                              .format(_selectedDate)
                                          ..selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset:
                                                  currentdateController
                                                      .text.length,
                                                  affinity:
                                                  TextAffinity.upstream));
                                      });
                                    }
                                  },
                                  decoration: fieldStyle.copyWith(
                                    hintStyle: Textstyle1.signupText.copyWith(
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Image.asset(
                                        "assets/images/date_icon.png",
                                        width: 5,height: 5,
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
                              ),
                            )
                          ],
                        ),


                      ],
                    ),
                  ),),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    // physics: BouncingScrollPhysics(),
                      itemCount: 2,
                      shrinkWrap: true,
                      itemBuilder: (context,i) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: Boxdec.conrad6colorblack,child: Column(children: [
                              Row(children: [
                                Image.asset("assets/images/car_icon.png",width: 15,),
                                SizedBox(width:10,),
                                Text(vehicle_no[i],style: Textstyle1.text14bold,),
                                Expanded(child: SizedBox(width:10,)),
                                Text("Unloading",style: Textstyle1.text12,),
                                SizedBox(width:8,),
                                Image.asset("assets/images/traced_icon.png",width: 15,)
                              ],),
                              SizedBox(height: 20,),
                              Row(children: [
                                Image.asset("assets/images/clock_icon_vehicle_Page.png",width: 10,),
                                SizedBox(width:10,),
                                Text(vehicle_time[i],style: Textstyle1.text10,),
                              ],),
                              SizedBox(height: 7,),
                              Row(children: [
                                Image.asset("assets/images/red_rount_icon.png",width: 10,color: ApplicationColors.greenColor370,),
                                SizedBox(width:10,),
                                Expanded(child: Text(vehicle_location[i],style: Textstyle1.text10,)),
                              ],)
                            ],),
                            ),
                            SizedBox(height: 10,)
                          ],
                        );
                      }
                  ),
                ),


              ],
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
        firstDate: DateTime(2015),
        lastDate: DateTime(2100),
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
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

