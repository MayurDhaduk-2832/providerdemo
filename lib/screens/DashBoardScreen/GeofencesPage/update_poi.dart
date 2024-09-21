import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/geofence_provider.dart';
import 'package:oneqlik/SearchLocationPage/search_location.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/GeofencesPage/search_location.dart';
import 'package:oneqlik/screens/DashBoardScreen/GeofencesPage/search_poly_map.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding_platform_interface/src/models/placemark.dart';

class UpdatePoi extends StatefulWidget {
  final id,location,name,radius,polygonid,isExiting,isEntering,polygeoname;
  const UpdatePoi({Key key, this.id, this.location, this.name, this.radius, this.polygonid, this.isExiting, this.isEntering, this.polygeoname}) : super(key: key);

  @override
  _UpdatePoiState createState() => _UpdatePoiState();
}

class _UpdatePoiState extends State<UpdatePoi> {

  TextEditingController _updatefenceName = TextEditingController();

  bool mapSetting= true;
  bool updateisEnterSetting = true;
  bool updateisExitSetting = true;

  GlobalKey<FormState> key = GlobalKey();
  GoogleMapController circleController;

  GeofencesProvider _geofencesProvider;

  var latitude = "", longitude = "", radius = "";
  var getCircleAddress = "";


  updateGeofenceCircle() async{

    var data = {
      "location": {
        "type": "Point",
        "coordinates": [
          double.parse("$latitude"),
          double.parse("$longitude"),
        ]
      },
      "poiid": widget.id,
      "address": getCircleAddress,
      "radius":  double.parse(radius),
      "poi_type": "garage",
    };

    print('${'updateGeofenceCircle-->$data'}');

    _geofencesProvider.updateGeofenceCircle(data, "poi/updatePOI", context);

  }



  List polyList = [];
  List polyAddress = [];
  List polyAddressList = [];


  getAddress()async{
    if(latitude != null || longitude != null){
      List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(latitude), double.parse(longitude));
      setState(() {
        getCircleAddress = "${placemarks.first.name} ${placemarks.first.subLocality} ${placemarks.first.locality} ${placemarks.first.subAdministrativeArea} ${placemarks.first.administrativeArea},${placemarks.first.postalCode}";
      });
    }
   }

  @override
  void initState() {
    super.initState();
    _geofencesProvider = Provider.of<GeofencesProvider>(context,listen: false);
    _updatefenceName.text = widget.name;
    radius = widget.radius;


     if(widget.location!=null){
       latitude = "${widget.location[0]}";
       longitude = "${widget.location[1]}";
       /*Future.delayed(Duration(seconds: 1),(){
         getAddress();
       });*/
     }

  }

  @override
  void dispose() {
    circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _geofencesProvider = Provider.of<GeofencesProvider>(context,listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: ApplicationColors.whiteColorF9
          /*  image: DecorationImage(
              image: AssetImage(
                  "assets/images/dark_background_image.png"), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,

            ),*/
          ),
        ),
        Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      print(polyList);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ApplicationColors.redColor67,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                          child: Text(
                            "${getTranslated(context, "cancel")}".toUpperCase(),
                            style: Textstyle1.text18boldwhite,
                          )),
                      height: height * .06,

                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      if(key.currentState.validate()){
                          if(latitude == "" || longitude == ""){
                            Helper.dialogCall.showToast(context, "${getTranslated(context, "select_circular_area")}");
                          }else{
                            updateGeofenceCircle();
                          }
                        }
                  },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ApplicationColors.redColor67,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                          child: Text(
                            "${getTranslated(context, "update_btn")}".toUpperCase(),
                            style: Textstyle1.text18boldwhite,
                          )),
                      height: height * .06,
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 13.0, top: 13),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset("assets/images/vector_icon.png",color: ApplicationColors.redColor67),
              ),
            ),
            title: Text(
              "${getTranslated(context, "edit_geofence")}",
              style: Textstyle1.appbartextstyle1,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            width: width,
            decoration: BoxDecoration(
                color: ApplicationColors.whiteColor,
                borderRadius: BorderRadius.circular(9)),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 5),
                    Text(
                      "${getTranslated(context, "Enter_Fence_Name")}",
                      style: Textstyle1.text14,
                    ),

                    SizedBox(height: 10),

                    TextFormField(
                      controller: _updatefenceName,
                      validator: (value){
                        if(value.isEmpty){
                          return "${getTranslated(context, "Enter_Fence_Name")}";
                        }
                        else{
                          return null;
                        }
                      },
                      style: Textstyle1.text12.copyWith(color: ApplicationColors.black4240),
                      decoration: Textfield1.inputdec.copyWith(
                          fillColor: ApplicationColors.whiteColor,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ApplicationColors.redColor67),
                        ),
                        errorStyle: TextStyle(color: ApplicationColors.redColor67, fontSize: 12)
                      ),
                    ),

                    SizedBox(height: 10),

                    // type selection
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           selectGeo = "circular";
                    //         });
                    //       },
                    //       child: Row(
                    //         children: [
                    //           Container(
                    //             width: width * .06,
                    //             height: height * .026,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(60),
                    //                 color: selectGeo == "circular"
                    //                     ? ApplicationColors.redColor67
                    //                     : ApplicationColors.dropdownColor3D,
                    //                 border: Border.all(
                    //                     color: ApplicationColors.redColor67)),
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Text(
                    //             "Circular",
                    //             style: Textstyle1.text18,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 20,
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           selectGeo = "poly";
                    //         });
                    //       },
                    //       child: Row(
                    //         children: [
                    //           Container(
                    //             width: width * .06,
                    //             height: height * .026,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(60),
                    //                 color: selectGeo == "poly"
                    //                     ? ApplicationColors.redColor67
                    //                     : ApplicationColors.dropdownColor3D,
                    //                 border: Border.all(
                    //                     color: ApplicationColors.redColor67)),
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Text(
                    //             "polygon",
                    //             style: Textstyle1.text18,
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    SizedBox(height: 25),


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add Location
                        Text(
                          "${getTranslated(context, "update_location")}",
                          style: Textstyle1.text14,
                        ),

                        SizedBox(height: 10),

                        InkWell(
                            onTap: () async {
                              var value = await
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Search_location()));
                              print('check->${value}');
                              if(value!=null){
                                setState(() {
                                  latitude = value[0];
                                  longitude = value[1];
                                  radius = value[2];

                                });

                                circleController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: LatLng(double.parse(latitude), double.parse(longitude)),
                                          zoom: 15,
                                        )
                                    )
                                );
                               /* List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(latitude), double.parse(longitude));
                                setState(() {
                                 getCircleAddress = "${placemarks.first.name} ${placemarks.first.subLocality} ${placemarks.first.locality} ${placemarks.first.subAdministrativeArea} ${placemarks.first.administrativeArea},${placemarks.first.postalCode}";

                                });*/
                              }
                            },
                            child: Container(
                                height: height * .06,
                                width: width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ApplicationColors.dropdownColor3D),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Image.asset(
                                      'assets/images/search_icon.png',
                                      color: ApplicationColors.black4240,
                                      width: 14,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Center(
                                        child: Text(
                                          "${getTranslated(context, "search_location")}",
                                          style: Textstyle1.text14
                                             ,
                                        )),
                                  ],
                                )
                              ),
                        ),

                        SizedBox(
                          height: getCircleAddress == "" ? 0 : 20,
                        ),

                        longitude == "" && latitude == ""
                            ?
                        SizedBox()
                            :
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          height: 250,
                          child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(double.parse(latitude), double.parse(longitude)),
                                zoom: 15,
                              ),
                              circles: longitude !="" && latitude!="" ? {
                                Circle(
                                  circleId: CircleId("circle"),
                                  radius: double.parse(radius),
                                  center: LatLng(double.parse(latitude), double.parse(longitude)),
                                  strokeColor: const Color(0xffF84A67).withOpacity(0.15),
                                  fillColor: const Color(0xffF84A67).withOpacity(0.15),
                                  strokeWidth: 1,
                                )
                              }:{},
                              onMapCreated:(controller){
                                circleController = controller;
                              }
                          ),
                        )
                        /*Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/gps1.png",
                              width: 15,
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$getCircleAddress",
                                    style: FontStyleUtilities.h14().copyWith(
                                        color: ApplicationColors.whiteColor
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "${getTranslated(context, "radius")} : ${NumberFormat("##0.0#", "en_US").format(double.parse(radius))}",
                                    style: Textstyle1.text12.copyWith(
                                        fontSize: 10,
                                        color: ApplicationColors.redColor67),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 10),

                            InkWell(
                              onTap: (){
                                setState(() {
                                  getCircleAddress = "";
                                  radius = "";
                                  longitude = "";
                                  longitude = "";
                                });
                              },
                              child: Image.asset(
                                'assets/images/close_icon.png',
                                width: 15,
                              ),
                            )
                          ],
                        ),*/
                      ],
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    Text("${getTranslated(context, "alertg_setting")}", style: Textstyle1.text18),

                    /*SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        FlutterSwitch(
                          toggleSize: 10,
                          padding: 2,
                          height: height * .021,
                          width: width * .09,
                          switchBorder: Border.all(color: Colors.white),
                          activeColor: ApplicationColors.blackColor2E,
                          activeToggleColor: ApplicationColors.redColor67,
                          toggleColor: ApplicationColors.white9F9,
                          inactiveColor: ApplicationColors.blackColor2E,
                          value: mapSetting,
                          onToggle: (val) {
                            setState(() {
                              mapSetting= val;
                            });
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Display on map", style: Textstyle1.text14),
                      ],
                    ),
*/

                    SizedBox(height: 20),

                    Row(
                      children: [
                        FlutterSwitch(
                          toggleSize: 10,
                          padding: 2,
                          height: height * .021,
                          width: width * .09,
                          switchBorder: Border.all(color: Colors.black54),
                          activeColor: ApplicationColors.whiteColor,
                          activeToggleColor: ApplicationColors.redColor67,
                          toggleColor: ApplicationColors.black4240,
                          inactiveColor: ApplicationColors.whiteColor,
                          value: updateisEnterSetting,
                          onToggle: (val) {
                            setState(() {
                              updateisEnterSetting = val;
                            });
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("${getTranslated(context, "notification_entering")}",
                            style: Textstyle1.text14),
                      ],
                    ),

                    SizedBox(height: 20),

                    Row(
                      children: [
                        FlutterSwitch(
                          toggleSize: 10,
                          padding: 2,
                          height: height * .021,
                          width: width * .09,
                          switchBorder: Border.all(color: Colors.black54),
                          activeColor: ApplicationColors.whiteColor,
                          activeToggleColor: ApplicationColors.redColor67,
                          toggleColor: ApplicationColors.black4240,
                          inactiveColor: ApplicationColors.whiteColor,
                          value: updateisExitSetting,
                          onToggle: (val) {
                            setState(() {
                              updateisExitSetting = val;
                            });
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                            "${getTranslated(context, "notification_exiting")}",
                            style: Textstyle1.text14),
                      ],
                    ),

                    SizedBox(height: 20),

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
