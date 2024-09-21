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

class AddGeofenceScreen extends StatefulWidget {
  const AddGeofenceScreen({Key key}) : super(key: key);

  @override
  _AddGeofenceScreenState createState() => _AddGeofenceScreenState();
}

class _AddGeofenceScreenState extends State<AddGeofenceScreen> {
  TextEditingController _enterfenceName = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool mapSetting = true;
  bool enteringSetting = true;
  bool exitSetting = true;

  GlobalKey<FormState> key = GlobalKey();
  GoogleMapController circleController;
  GoogleMapController polygonController;

  var selectGeo = "circular";
  var width, height;
  GeofencesProvider _geofencesProvider;

  var latitude = "", longitude = "", radius = "";

  addGeofenceCircle() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "poi": [
        {
          "location": {
            "type": "Point",
            "coordinates": [
              double.parse("$latitude"),
              double.parse("$longitude"),
            ]
          },
          "poiname": _enterfenceName.text,
          "status": "Active",
          "user": id,
          "radius": double.parse(radius),
          "entering": exitSetting,
          "exiting": enteringSetting
        }
      ],
      "halt_notif": true,
      "halt_time": "60"
    };

    print('addGeofenceCircle-->${jsonEncode(data)}');

    _geofencesProvider.addGeofenceCircle(data, "poi/addpoi", context);
  }

  addGeofencePoly() async {
    polyList.insert(polyList.length, polyList[0]);

    List sendList = [];

    sendList.add(polyList);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
      "geofence": sendList,
      "geoname": _enterfenceName.text,
      "entering": enteringSetting,
      "exiting": exitSetting,
      "type": "Loading",
      "halt_notif": true,
      "halt_time": "60"
    };

    print(jsonEncode(data));

    _geofencesProvider.addGeofencePoly(data, "geofencing/addgeofence", context);
  }

  List polyList = [];
  List polyGonList = [];
  List polyAddress = [];
  List polyAddressList = [];

  var getCircleAddress = "";

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }

  @override
  void initState() {
    super.initState();
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: false);
  }

  onMapCreate(GoogleMapController controller) {
    print("hello circle and polygon");
    circleController = controller;
    polygonController = controller;
  }

  @override
  void dispose() {
    circleController.dispose();
    polygonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  print(polyList);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ApplicationColors.redColor67,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                      child: Text(
                    "${getTranslated(context, "cancel")}",
                    style: Textstyle1.text18bold.copyWith(color: Colors.white),
                  )),
                  height: height * .06,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (key.currentState.validate()) {
                    if (selectGeo == "poly") {
                      if (polyAddressList.isEmpty) {
                        Helper.dialogCall.showToast(context,
                            "${getTranslated(context, "select_polygon_area")}");
                      } else {
                        addGeofencePoly();
                      }
                    } else {
                      if (latitude == "" || longitude == "") {
                        Helper.dialogCall.showToast(context,
                            "${getTranslated(context, "select_circular_area")}");
                      } else {
                        addGeofenceCircle();
                      }
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
                    "${getTranslated(context, "apply")}",
                    style: Textstyle1.text18bold.copyWith(color: Colors.white),
                  )),
                  height: height * .06,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: ApplicationColors.whiteColor,
            size: 26,
          ),
        ),
        title: Text(
          "${getTranslated(context, "add_geofences")}",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 22,
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
      body: Container(
        width: width,
        decoration: BoxDecoration(
            color: ApplicationColors.whiteColorF9,
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
                  controller: _enterfenceName,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "${getTranslated(context, "Enter_Fence_Name")}";
                    } else {
                      return null;
                    }
                  },
                  style: Textstyle1.text12
                      .apply(color: ApplicationColors.blackbackcolor),
                  decoration: Textfield1.inputdec.copyWith(
                      fillColor: ApplicationColors.whiteColor,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ApplicationColors.redColor67),
                      ),
                      errorStyle: TextStyle(
                          color: ApplicationColors.redColor67, fontSize: 12)),
                ),

                SizedBox(height: 10),

                // type selection
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectGeo = "circular";
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: width * .06,
                            height: height * .026,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: selectGeo == "circular"
                                    ? ApplicationColors.redColor67
                                    : ApplicationColors.whiteColor,
                                border: Border.all(
                                    color: ApplicationColors.redColor67)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${getTranslated(context, "circular")}",
                            style: Textstyle1.text18,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectGeo = "poly";
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: width * .06,
                            height: height * .026,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: selectGeo == "poly"
                                    ? ApplicationColors.redColor67
                                    : ApplicationColors.whiteColor,
                                border: Border.all(
                                    color: ApplicationColors.redColor67)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${getTranslated(context, "polygon")}",
                            style: Textstyle1.text18,
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25),

                selectGeo == "circular"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add Location
                          Text(
                            "${getTranslated(context, "add_location")}",
                            style: Textstyle1.text14,
                          ),

                          SizedBox(height: 10),

                          InkWell(
                            onTap: () async {
                              var value = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Search_location()));
                              print('check->${value}');
                              if (value != null) {
                                setState(() {
                                  latitude = value[0];
                                  longitude = value[1];
                                  radius = value[2];
                                });

                                circleController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                  target: LatLng(double.parse(latitude),
                                      double.parse(longitude)),
                                  zoom: 15,
                                )));
/*                                List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(latitude), double.parse(longitude));
                            getCircleAddress = "${placemarks.first.name} ${placemarks.first.subLocality} ${placemarks.first.locality} ${placemarks.first.subAdministrativeArea} ${placemarks.first.administrativeArea},${placemarks.first.postalCode}";
                          */
                              }
                            },
                            child: Container(
                                height: height * .06,
                                width: width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            ApplicationColors.dropdownColor3D),
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
                                      style: Textstyle1.text14.copyWith(
                                          color: ApplicationColors.black4240),
                                    )),
                                  ],
                                )),
                          ),

                          SizedBox(
                            height: getCircleAddress == "" ? 0 : 20,
                          ),

                          latitude == "" && longitude == ""
                              ? SizedBox()
                              : Container(
                                  margin: EdgeInsets.only(top: 30),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 250,
                                  child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(Utils.lat, Utils.lng),
                                        zoom: 15,
                                      ),
                                      circles: longitude != "" && latitude != ""
                                          ? {
                                              Circle(
                                                circleId: CircleId("circle"),
                                                radius: double.parse(radius),
                                                center: LatLng(
                                                    double.parse(latitude),
                                                    double.parse(longitude)),
                                                strokeColor:
                                                    const Color(0xffF84A67)
                                                        .withOpacity(0.15),
                                                fillColor:
                                                    const Color(0xffF84A67)
                                                        .withOpacity(0.15),
                                                strokeWidth: 1,
                                              )
                                            }
                                          : {},
                                      onMapCreated: onMapCreate),
                                )

                          /* Row(
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
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add Location
                          Text(
                            "${getTranslated(context, "add_location")}",
                            style: Textstyle1.text14,
                          ),

                          SizedBox(height: 10),

                          InkWell(
                            onTap: () async {
                              var value = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPolyMap(),
                                ),
                              );

                              print(' value == >$value');

                              if (value != null) {
                                setState(() {
                                  polyList = value[0];
                                  polyGonList = value[1];
                                });

                                polygonController.animateCamera(
                                    CameraUpdate.newLatLngBounds(
                                        _createBounds(polyGonList), 100));

                                /*for(int i=0;i<polyList.length; i++){
                                List<Placemark> placemarks = await placemarkFromCoordinates(polyList[i][1], polyList[i][0]);
                                setState(() {
                                  polyAddressList.add("${placemarks.first.name} ${placemarks.first.subLocality} ${placemarks.first.locality} ${placemarks.first.subAdministrativeArea} ${placemarks.first.administrativeArea},${placemarks.first.postalCode}",);
                                });
                            }*/
                              }
                            },
                            child: Container(
                                height: height * .06,
                                width: width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            ApplicationColors.dropdownColor3D),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Image.asset(
                                      'assets/images/search_icon.png',
                                      color: ApplicationColors.blackbackcolor,
                                      width: 14,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Center(
                                        child: Text(
                                      "${getTranslated(context, "search_location")}",
                                      style: Textstyle1.text14.copyWith(
                                          color:
                                              ApplicationColors.blackbackcolor),
                                    )),
                                  ],
                                )),
                          ),

                          SizedBox(
                            height: polyAddressList.isEmpty ? 0 : 20,
                          ),

                          /*ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: polyAddressList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/gps1.png",
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${polyAddressList[index]}",
                                        style: FontStyleUtilities.h14().copyWith(
                                          color: ApplicationColors.whiteColor
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),*/

                          polyGonList.isEmpty
                              ? SizedBox()
                              : Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 250,
                                  child: GoogleMap(
                                      mapType: Utils.mapType,
                                      //map type
                                      zoomGesturesEnabled: true,
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(Utils.lat, Utils.lng),
                                        zoom: 12.0, //initial zoom level
                                      ),
                                      polygons: polyGonList.isEmpty
                                          ? {}
                                          : Set<Polygon>.of(<Polygon>[
                                              Polygon(
                                                  polygonId:
                                                      PolygonId('polygon'),
                                                  points: polyGonList,
                                                  strokeWidth: 2,
                                                  strokeColor:
                                                      const Color(0xffF84A67)
                                                          .withOpacity(0.15),
                                                  fillColor:
                                                      const Color(0xffF84A67)
                                                          .withOpacity(0.15)),
                                            ]),
                                      onMapCreated: onMapCreate),
                                ),
                        ],
                      ),

                SizedBox(
                  height: 25,
                ),

                Text("${getTranslated(context, "alertg_setting")}",
                    style: Textstyle1.text18),

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
                SizedBox(
                  height: 20,
                ),

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
                      value: enteringSetting,
                      onToggle: (val) {
                        setState(() {
                          enteringSetting = val;
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

                SizedBox(
                  height: 20,
                ),

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
                      value: exitSetting,
                      onToggle: (val) {
                        setState(() {
                          exitSetting = val;
                        });
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("${getTranslated(context, "notification_exiting")}",
                        style: Textstyle1.text14),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
