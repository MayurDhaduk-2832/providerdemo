import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ExpensesScreens/expenses_screen.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ConfirmLocationScreen extends StatefulWidget {
  const ConfirmLocationScreen({Key key}) : super(key: key);

  @override
  _ConfirmLocationScreenState createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {

  Position position;
  Widget _child;
  GoogleMapController _controller;
  GoogleMapController mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyAdonwbTHNYYyJKwQVo2qY23FaX9PL9qSc";
     // "AIzaSyDNmQ3sok_q3O9JZ66cFJgzFfiJiDWESmY";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  // LatLng startLocation = LatLng(27.66836199, 85.3101895);
  LatLng startLocation = LatLng(21.1607672, 72.8175179);
  //LatLng startLocation ;
  LatLng endLocation = LatLng(21.1609081, 72.8255265);

  Set<Marker> _createMarker() {
    markers.add( Marker(
      markerId: MarkerId("HomePage"),
      position:LatLng(21.1607672, 72.8175179),
      //position:LatLng(position.latitude,position.longitude),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: "Current Place",
      ),
    ));
    markers.add(Marker( //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: InfoWindow( //popup info
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
  }
  var height,width;
  double _value=0.0;
  int _ivalue=0;

  @override
  Widget build(BuildContext context) {



    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        bottomNavigationBar: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
                color: ApplicationColors.blackColor2E,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 38,right: 38,top: 20,bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Location",style: FontStyleUtilities.h12(fontColor: ApplicationColors.whiteColor,fontFamily: "Poppins-Regular"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Chandanvan society",
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.s16(fontColor: ApplicationColors.whiteColor,fontFamily: "Poppins-Regular"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/gps1.png",
                            width: 15,height: 15,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Text(
                                "Mahavir Market, Udhna Main Road, udhna, Surat, Gujarat - 394210 (India)",
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: FontStyleUtilities.h12(fontColor: ApplicationColors.whiteColor),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SimpleElevatedButton(
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>LiveForVehicleScreen()));

                        // Navigator.of(context).pop();
                      },
                      buttonName: 'CONFIRM LOCATION',
                      style: FontStyleUtilities.s18(fontColor: ApplicationColors.whiteColor),
                      fixedSize: Size(height*0.41, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: ApplicationColors.redColor67,
                    ),
                  ],
                ),
                Expanded(child: SizedBox(height: height*0.03)),
              ],
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,

        body: Stack(
          children: [
            Container(
              height: height,
              child:
              GoogleMap( //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                initialCameraPosition: CameraPosition( //innital position in map
                  target: startLocation, //initial position
                  zoom: 16.0, //initial zoom level
                ),
                markers: markers, //markers to show on map
                polylines: Set<Polyline>.of(polylines.values), //polylines
                mapType: MapType.normal, //map type
                onMapCreated: (controller) { //method called when map is created
                  setState(() {
                    mapController = controller;
                  });
                },
              ),
            ),
            Positioned(
              top: 45,
              left: 15,
              right: 83,
              child: SizedBox(
                height: 48,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ExpensesScreen()));
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        style: FontStyleUtilities.h14(fontColor: ApplicationColors.whiteColor),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: "${getTranslated(context, "search_location")}",
                          hintStyle: TextStyle(
                              color: ApplicationColors.whiteColor,fontSize: 14,letterSpacing: 0.75),
                          // prefixIcon: Icon(Icons.search,color: ApplicationColors.blackColor33.withOpacity(0.5)),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset("assets/images/search_icon.png"),
                          ),

                          // ],
                        ),

                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ApplicationColors.blackColor2E,
                        border: Border.all(
                            color: ApplicationColors.textfieldBorderColor, width: 1),
                      )),
                ),
              ),
            ),
            Positioned(
                top: 45,
                right: 20,
                child:      InkWell(onTap: (){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(backgroundColor: ApplicationColors.blackColor2E,
                        title: Container(decoration: BoxDecoration(color: ApplicationColors.blackColor2E,borderRadius: BorderRadius.circular(6)),
                          child: Column(children: [
                            Row(
                              children: [
                                Text("Filter",style:FontStyleUtilities.h24(fontColor: ApplicationColors.whiteColor)),
                              ],
                            ),
                            SizedBox(height: 15),
                            CustomTextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              // controller: _loginController.userNameController,
                              hintText: "${getTranslated(context, 'enter_radius')}",
                                validator: (value) {
                                if (value.isEmpty) {
                                  return "${getTranslated(context, 'enter_phone_email')}";
                                }
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:15),
                              child: Row(
                                children: [
                                  SimpleElevatedButton(
                                    onPressed: () {},
                                    buttonName: "${getTranslated(context, "cancel")}",
                                    style: FontStyleUtilities.s18(
                                        fontColor: ApplicationColors.whiteColor),
                                    fixedSize: Size(122, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    color: ApplicationColors.redColor67,
                                  ),
                                  SizedBox(width: width * 0.035),
                                  SimpleElevatedButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (BuildContext context) =>
                                      //             ExpensesScreen()));
                                    },
                                    buttonName: 'DONE',
                                    style: FontStyleUtilities.s18(
                                        fontColor: ApplicationColors.whiteColor),
                                    fixedSize: Size(122, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    color: ApplicationColors.redColor67,
                                  ),
                                ],
                              ),
                            ),

                          ],),
                        )
                    ),
                  );
                },
                  child: Container(
                    width: 45,
                    height: 45,
                    padding: EdgeInsets.all(10),
                    child: Image.asset("assets/images/filter.png"),
                    decoration: BoxDecoration(
                      color: ApplicationColors.blackColor2E,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                )
            ),
          ],
        ));

  }
}



showFilterDialogue(BuildContext context) {
  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    content: IntrinsicHeight(
      child: Container(
        width: 320,

        decoration: BoxDecoration(
          color: ApplicationColors.blackColor2E,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ApplicationColors.blackColor2E, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Set Immobilize Password',overflow: TextOverflow.visible,
                    maxLines: 2,
                    textAlign: TextAlign.start,style: FontStyleUtilities.h24(fontColor: ApplicationColors.whiteColor),),
                  Text('Enter Password for engine cut',overflow: TextOverflow.visible,
                    maxLines: 2,
                    textAlign: TextAlign.center,style: FontStyleUtilities.h18(fontColor: ApplicationColors.whiteColor,fontFamily: "Poppins-Regular"),),
                ],
              ),
            ),
            Divider(
              color: ApplicationColors.textfieldBorderColor,
              thickness: 1,
              endIndent: 0.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                ],
              ),
            ),

          ],
        ),
      ),
    ),
  );


}