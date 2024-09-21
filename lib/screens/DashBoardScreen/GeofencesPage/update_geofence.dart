import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/geofence_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/GeofencesPage/search_poly_map.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateGeofence extends StatefulWidget {
  final id, name, polygonid, isExiting, isEntering, polygeoname;
  List poyList;
  List<LatLng> polyGonList;

  UpdateGeofence(
      {Key key,
      this.poyList,
      this.id,
      this.name,
      this.polyGonList,
      this.polygonid,
      this.isExiting,
      this.isEntering,
      this.polygeoname})
      : super(key: key);

  @override
  _UpdateGeofenceState createState() => _UpdateGeofenceState();
}

class _UpdateGeofenceState extends State<UpdateGeofence> {
  TextEditingController _updatefenceName = TextEditingController();

  List polyList = [];
  List polyAddressList = [];

  bool mapSetting = true;
  bool updateisEnterSetting = true;
  bool updateisExitSetting = true;
  GlobalKey<FormState> key = GlobalKey();

  bool loading = false;
  var getCircleAddress = "";
  GeofencesProvider _geofencesProvider;

  GoogleMapController polygonController;

  getAddress() async {
    for (int i = 0; i < widget.poyList.length; i++) {
      polyList.add([widget.poyList[i].lat, widget.poyList[i].long]);

      if (widget.poyList[i].lat != null || widget.poyList[i].log != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          widget.poyList[i].lat,
          widget.poyList[i].long,
        ).catchError((error) {
          polyAddressList.add("Address not found");
        });
        setState(() {
          polyAddressList.add(
            "${placemarks.first.name} "
            "${placemarks.first.subLocality} "
            "${placemarks.first.locality} "
            "${placemarks.first.subAdministrativeArea} "
            "${placemarks.first.administrativeArea},"
            "${placemarks.first.postalCode}",
          );
        });

        if (i == widget.poyList.length - 2) break;
      } else {
        polyAddressList.add("Address not found");
      }
    }

    setState(() {
      loading = false;
    });
  }

  updateGeofencePoly() async {
    if (polyList[polyList.length - 1].contains(polyList[0])) {
      print("list contains data");
    } else {
      polyList.insert(polyList.length, polyList[0]);
    }

    List sendList = [];

    sendList.add(polyList);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
      "geofence": sendList,
      "geoname": _updatefenceName.text,
      "entering": updateisEnterSetting,
      "exiting": updateisExitSetting,
      "type": "Unloading",
      "halt_notif": true,
      "halt_time": "60",
      "_id": widget.id,
    };

    print(jsonEncode(data));

    _geofencesProvider.updateGeofencePoly(
        data, "geofencing/updateGeoFence", context);
  }

  List polyGonList = [];

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
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: false);

    super.initState();

    _updatefenceName.text = widget.name;
    updateisExitSetting = widget.isExiting;
    updateisEnterSetting = widget.isEntering;

    if (widget.polyGonList.isNotEmpty) {
      polyGonList = widget.polyGonList;
      print(polyGonList);
    }
    /*if(widget.poyList.isNotEmpty){
      setState(() {
        loading = true;
      });
      Future.delayed(Duration.zero,(){
        getAddress();
      });
    }*/
  }

  @override
  void dispose() {
    polygonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return loading
        ? Helper.dialogCall.showLoader()
        : Scaffold(
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
                      onTap: () {
                        if (key.currentState.validate()) {
                          if (polyAddressList.isEmpty) {
                            Helper.dialogCall.showToast(context,
                                "${getTranslated(context, "select_polygon_area")}");
                          } else {
                            updateGeofencePoly();
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
                          "${getTranslated(context, "update_btn")}"
                              .toUpperCase(),
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
                "${getTranslated(context, "edit_geofence")}",
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return "${getTranslated(context, "Enter_Fence_Name")}";
                          } else {
                            return null;
                          }
                        },
                        style: Textstyle1.text12
                            .copyWith(color: ApplicationColors.black4240),
                        decoration: Textfield1.inputdec.copyWith(
                            fillColor: ApplicationColors.whiteColor,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ApplicationColors.redColor67),
                            ),
                            errorStyle: TextStyle(
                                color: ApplicationColors.redColor67,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 10),
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

                                /* for(int i=0;i<polyList.length; i++){
                            List<Placemark> placemarks = await placemarkFromCoordinates(polyList[i][0], polyList[i][1]);
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
                                      color: ApplicationColors.white9F9,
                                      width: 14,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Center(
                                        child: Text(
                                      "${getTranslated(context, "search_location")}",
                                      style: Textstyle1.text14
                                          .copyWith(color: Color(0xffFFFFFF)),
                                    )),
                                  ],
                                )),
                          ),

                          SizedBox(
                            height: polyAddressList.isEmpty ? 0 : 20,
                          ),

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
                                      polygons: Set<Polygon>.of(<Polygon>[
                                        Polygon(
                                            polygonId: PolygonId('polygon'),
                                            points: polyGonList,
                                            strokeWidth: 2,
                                            strokeColor: const Color(0xffF84A67)
                                                .withOpacity(0.15),
                                            fillColor: const Color(0xffF84A67)
                                                .withOpacity(0.15)),
                                      ]),
                                      onMapCreated: (controller) {
                                        polygonController = controller;
                                        polygonController.animateCamera(
                                            CameraUpdate.newLatLngBounds(
                                                _createBounds(polyGonList),
                                                100));
                                      }),
                                ),

                          /* ListView.builder(
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
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      polyAddressList.removeAt(index);
                                    });
                                  },
                                  child: Image.asset(
                                    'assets/images/close_icon.png',
                                    width: 15,
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    ),*/
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text("${getTranslated(context, "alertg_setting")}",
                          style: Textstyle1.text18),
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
                          Text(
                              "${getTranslated(context, "notification_entering")}",
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
