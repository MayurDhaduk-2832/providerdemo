import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/MapSuggestion.dart';
import 'package:oneqlik/Provider/geofence_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/GeofencesPage/AddGeofenceScreen.dart';
import 'package:oneqlik/screens/DashBoardScreen/GeofencesPage/update_geofence.dart';
import 'package:oneqlik/screens/DashBoardScreen/GeofencesPage/update_poi.dart';
import 'package:oneqlik/screens/DashBoardScreen/dashboard_screen.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/utils/map_json.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Geofences extends StatefulWidget {
  var value;

  Geofences({Key key, this.value}) : super(key: key);

  @override
  _GeofencesState createState() => _GeofencesState();
}

class _GeofencesState extends State<Geofences> {
  GoogleMapController mapController;

  GoogleMapController mapControllerPoly;

  FocusNode focusNode;

  bool searchValue = true;
  bool isShow = true;
  List<MapSuggestion> suggestionList = [];
  TextEditingController searchController = TextEditingController();

  BitmapDescriptor sourceIcon;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 6.0),
        "assets/images/location.png");
  }

  bool selectedPoi = true;
  var height, width;
  bool _alertSetting = true;
  bool _alertSetting1 = true;
  bool _alertSetting2 = true;
  bool polyLoading = false;

  GeofencesProvider _geofencesProvider;
  List<Polygon> mainPloyList = [];

  getAllGeofence() async {
    setState(() {
      polyLoading = true;
      mainPloyList.clear();
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
    };

    await _geofencesProvider.getAllGeofence(
        data, "geofencingV2/getallgeofence", "geo", context);
    if (_geofencesProvider.geoSuccess) {
      for (int i = 0; i < _geofencesProvider.getAllGeofenceList.length; i++) {
        if (_geofencesProvider.latLng.isNotEmpty) {
          mainPloyList.add(Polygon(
              polygonId: PolygonId('polygon$i'),
              points: _geofencesProvider.latLng[i],
              strokeWidth: 2,
              strokeColor: Color(0xffF84A67),
              fillColor: Color(0xffF84A67).withOpacity(0.15)));
          print("mainPloyList => $mainPloyList");
        }
      }
    }

    setState(() {
      polyLoading = false;
    });
  }

  List<Circle> listOfCircle = [];
  List<Marker> markerList = [];

  bool isCircleLoading = false;

  getPoiList() async {
    setState(() {
      isCircleLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "user": id,
    };

    await _geofencesProvider.getPoiList(data, "poiV2/getPois", "geo");

    if (_geofencesProvider.isSuccess) {
      for (int i = 0; i < _geofencesProvider.getPoiDetailsList.length; i++) {
        markerList.add(
          Marker(
            markerId: MarkerId("myLoc"),
            position: LatLng(
              _geofencesProvider
                  .getPoiDetailsList[i].poi.location.coordinates[0],
              _geofencesProvider
                  .getPoiDetailsList[i].poi.location.coordinates[1],
            ),
            icon: sourceIcon,
          ),
        );
        listOfCircle.add(
          Circle(
            circleId: CircleId('circle_123'),
            center: LatLng(
              _geofencesProvider
                  .getPoiDetailsList[i].poi.location.coordinates[0],
              _geofencesProvider
                  .getPoiDetailsList[i].poi.location.coordinates[1],
            ),
            radius: _geofencesProvider.getPoiDetailsList[i].radius == null
                ? 0.0
                : double.parse(
                    "${_geofencesProvider.getPoiDetailsList[i].radius}"),
            strokeColor: const Color(0xffF84A67).withOpacity(0.15),
            fillColor: const Color(0xffF84A67).withOpacity(0.15),
            strokeWidth: 1,
          ),
        );
      }
    }

    setState(() {
      isCircleLoading = false;
    });
  }

  deleteGeofence(id) async {
    var data = {
      "id": "$id",
    };
    await _geofencesProvider.deleteGeofence(
        data, "geofencing/deletegeofence", context);

    if (_geofencesProvider.isdeleteGeofenceLoading) {
      getPoiList();
      getAllGeofence();
    }
  }

  deletePoi(id) async {
    var data = {
      "_id": "$id",
    };

    await _geofencesProvider.deletePoi(data, "poi/deletePoi", context);
    if (_geofencesProvider.isdeletePoiLoading) {
      getPoiList();
      getAllGeofence();
    }
  }

  showCircularDialog(poiListForCircular) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              backgroundColor: ApplicationColors.whiteColor,
              title: Container(
                decoration: BoxDecoration(
                    color: ApplicationColors.whiteColor,
                    borderRadius: BorderRadius.circular(6)),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        var id = '${poiListForCircular.id}';
                        var location =
                            poiListForCircular.poi.location.coordinates;
                        var name = '${poiListForCircular.poi.poiname}';
                        var radius = poiListForCircular.radius == null
                            ? "0.0"
                            : '${poiListForCircular.radius}';

                        final value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePoi(
                              id: id,
                              location: location,
                              name: name,
                              radius: radius,
                            ),
                          ),
                        );

                        if (value != null) {
                          getAllGeofence();
                          getPoiList();
                        }
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/Edit_icon.png',
                            width: 20,
                            color: ApplicationColors.redColor67,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "${getTranslated(context, "edit")}",
                            style: Textstyle1.text14.copyWith(
                                color: ApplicationColors.blackColor00),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        deleteDialog(poiListForCircular.id);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/delete_icon.png',
                            width: 20,
                            color: ApplicationColors.redColor67,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "${getTranslated(context, "delete")}",
                            style: Textstyle1.text14.copyWith(
                                color: ApplicationColors.blackColor00),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text("${getTranslated(context, "display_map")}",
                            style: Textstyle1.text14),
                        Expanded(
                          child: SizedBox(
                            width: 20,
                          ),
                        ),
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
                          value: _alertSetting,
                          onToggle: (val) {
                            setState(() {
                              _alertSetting = val;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                            "${getTranslated(context, "notification_entering")}",
                            style: Textstyle1.text14),
                        Expanded(
                            child: SizedBox(
                          width: 20,
                        )),
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
                          value: _alertSetting1,
                          onToggle: (val) {
                            setState(() {
                              _alertSetting1 = val;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [],
                    ),
                    //SizedBox(height: 20,),
                  ],
                ),
              ));
        });
      },
    );
  }

  // showPolygonDialog(allGeoFenceDetails, index) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return AlertDialog(
  //           backgroundColor: ApplicationColors.whiteColor,
  //           title: Container(
  //             decoration: BoxDecoration(
  //                 color: ApplicationColors.whiteColor,
  //                 borderRadius: BorderRadius.circular(6)),
  //             child: Column(
  //               children: [
  //                 InkWell(
  //                   onTap: () async {
  //                     Navigator.pop(context);
  //
  //                     var id = '${allGeoFenceDetails.id}';
  //                     var isEntering = allGeoFenceDetails.entering;
  //                     var isExiting = allGeoFenceDetails.exiting;
  //                     var polygonName = allGeoFenceDetails.geoname;
  //                     List<LatLng> polyGonList =
  //                         _geofencesProvider.latLng[index];
  //                     List polyList = _geofencesProvider
  //                         .getAllGeofenceList[index].geofence.coordinates;
  //
  //                     final value = await Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => UpdateGeofence(
  //                             id: id,
  //                             isEntering: isEntering,
  //                             isExiting: isExiting,
  //                             name: polygonName,
  //                             poyList: polyList,
  //                             polyGonList: polyGonList),
  //                       ),
  //                     );
  //
  //                     if (value != null) {
  //                       getAllGeofence();
  //                       getPoiList();
  //                     }
  //                   },
  //                   child: Row(
  //                     children: [
  //                       Image.asset(
  //                         'assets/images/Edit_icon.png',
  //                         width: 20,
  //                         color: ApplicationColors.redColor67,
  //                       ),
  //                       SizedBox(
  //                         width: 15,
  //                       ),
  //                       Text(
  //                         "${getTranslated(context, "edit")}",
  //                         style: Textstyle1.text14,
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(height: 20),
  //                 Row(
  //                   children: [
  //                     Image.asset(
  //                       'assets/images/delete_icon.png',
  //                       width: 20,
  //                       color: ApplicationColors.redColor67,
  //                     ),
  //                     SizedBox(
  //                       width: 15,
  //                     ),
  //                     InkWell(
  //                       onTap: () {
  //                         deletePolygonDialog(allGeoFenceDetails.id);
  //                       },
  //                       child: Text(
  //                         "${getTranslated(context, "delete")}",
  //                         style: Textstyle1.text14,
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 SizedBox(height: 20),
  //                 Row(
  //                   children: [
  //                     Text("${getTranslated(context, "display_map")}",
  //                         style: Textstyle1.text14),
  //                     Expanded(
  //                         child: SizedBox(
  //                       width: 20,
  //                     )),
  //                     FlutterSwitch(
  //                       toggleSize: 10,
  //                       padding: 2,
  //                       height: height * .021,
  //                       width: width * .09,
  //                       switchBorder: Border.all(color: Colors.black54),
  //                       activeColor: ApplicationColors.whiteColor,
  //                       activeToggleColor: ApplicationColors.redColor67,
  //                       toggleColor: ApplicationColors.black4240,
  //                       inactiveColor: ApplicationColors.whiteColor,
  //                       value: _alertSetting,
  //                       onToggle: (val) {
  //                         setState(() {
  //                           _alertSetting = val;
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 20),
  //                 Row(
  //                   children: [],
  //                 ),
  //                 SizedBox(height: 20),
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "${getTranslated(context, "notification_exiting")}",
  //                       style: Textstyle1.text14,
  //                     ),
  //                     Expanded(
  //                       child: SizedBox(
  //                         width: 20,
  //                       ),
  //                     ),
  //                     FlutterSwitch(
  //                       toggleSize: 10,
  //                       padding: 2,
  //                       height: height * .021,
  //                       width: width * .09,
  //                       switchBorder: Border.all(color: Colors.black54),
  //                       activeColor: ApplicationColors.whiteColor,
  //                       activeToggleColor: ApplicationColors.redColor67,
  //                       toggleColor: ApplicationColors.black4240,
  //                       inactiveColor: ApplicationColors.whiteColor,
  //                       value: _alertSetting2,
  //                       onToggle: (val) {
  //                         setState(() {
  //                           _alertSetting2 = val;
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  deleteDialog(id) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            backgroundColor: ApplicationColors.blackColor2E,
            title: Text(
              "${getTranslated(context, "Are_you_sure_you_want_to_delete_this_poi")}",
              textAlign: TextAlign.center,
              style: Textstyle1.appbartextstyle1.copyWith(fontSize: 14),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SimpleElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      buttonName: "${getTranslated(context, "cancel")}",
                      style: FontStyleUtilities.s18(
                          fontColor: ApplicationColors.whiteColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: ApplicationColors.redColor67,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SimpleElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        deletePoi(id);
                      },
                      buttonName: "${getTranslated(context, "ok")}",
                      style: FontStyleUtilities.s18(
                          fontColor: ApplicationColors.whiteColor),
                      fixedSize: Size(118, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: ApplicationColors.redColor67,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  deletePolygonDialog(id) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            backgroundColor: ApplicationColors.blackColor2E,
            title: Text(
              "${getTranslated(context, "Are_you_sure_you_want_to_delete_this_polygon")}",
              textAlign: TextAlign.center,
              style: Textstyle1.appbartextstyle1.copyWith(fontSize: 14),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SimpleElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      buttonName: "${getTranslated(context, "cancel")}",
                      style: FontStyleUtilities.s18(
                          fontColor: ApplicationColors.whiteColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: ApplicationColors.redColor67,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SimpleElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        deleteGeofence(id);
                      },
                      buttonName: "${getTranslated(context, "ok")}",
                      style: FontStyleUtilities.s18(
                          fontColor: ApplicationColors.whiteColor),
                      fixedSize: Size(118, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: ApplicationColors.redColor67,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

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
    setSourceAndDestinationIcons();
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: false);
    getPoiList();
    getAllGeofence();
  }

  @override
  void dispose() {
    mapController.dispose();
    mapControllerPoly.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
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
          getTranslated(context, "geofence"),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Arial',
            color: ApplicationColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () async {
                var value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddGeofenceScreen()));

                if (value == null) {
                  getAllGeofence();
                  getPoiList();
                }
              },
              child: Center(
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
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
      backgroundColor: ApplicationColors.containercolor,
      body: isCircleLoading || polyLoading
          ? Helper.dialogCall.showLoader()
          : Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPoi = true;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              color: selectedPoi == true
                                  ? ApplicationColors.greenColor
                                  : ApplicationColors.greyC4C4,
                              shape: BoxShape.circle,
                            ),
                            width: height * .04,
                            height: height * .04,
                            child: selectedPoi == true
                                ? Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${getTranslated(context, "circular")}",
                          style: Textstyle1.text18.copyWith(
                            color: ApplicationColors.blackColor00,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPoi = false;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              color: selectedPoi == false
                                  ? ApplicationColors.greenColor
                                  : ApplicationColors.greyC4C4,
                              shape: BoxShape.circle,
                            ),
                            width: height * .04,
                            height: height * .04,
                            child: selectedPoi == false
                                ? Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${getTranslated(context, "polygon")}",
                          style: Textstyle1.text18.copyWith(
                            color: ApplicationColors.blackColor00,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // circle
              selectedPoi
                  ? _geofencesProvider.isGetPoiListLoading
                      ? Expanded(child: Helper.dialogCall.showLoader())
                      : _geofencesProvider.getPoiDetailsList.length == 0
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  "${getTranslated(context, "poi_list_not_available")}",
                                  textAlign: TextAlign.center,
                                  style: Textstyle1.text18.copyWith(
                                    fontSize: 18,
                                    color: ApplicationColors.redColor67,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: _geofencesProvider
                                      .getPoiDetailsList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var poiListForCircular = _geofencesProvider
                                        .getPoiDetailsList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Card(
                                        elevation: 5,
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: height * .12,
                                                width: height * .12,
                                                child: GoogleMap(
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                    target: LatLng(
                                                        poiListForCircular
                                                            .poi
                                                            .location
                                                            .coordinates[0],
                                                        poiListForCircular
                                                            .poi
                                                            .location
                                                            .coordinates[1]),
                                                    zoom:
                                                        10, //initial zoom level
                                                  ),
                                                  zoomControlsEnabled: false,
                                                  markers: Set<Marker>.of([
                                                    Marker(
                                                      markerId:
                                                          MarkerId("myLoc"),
                                                      position: LatLng(
                                                        poiListForCircular
                                                            .poi
                                                            .location
                                                            .coordinates[0],
                                                        poiListForCircular
                                                            .poi
                                                            .location
                                                            .coordinates[1],
                                                      ),
                                                      icon: BitmapDescriptor
                                                          .defaultMarker,
                                                    ),
                                                  ]),
                                                  mapType: Utils.mapType,
                                                  //map type
                                                  circles: Set<Circle>.of(
                                                      listOfCircle),
                                                  // polygons: selectedPoi == false ? Set<Polygon>.of(mainPloyList) : {},
                                                  onMapCreated: (controller) {
                                                    mapController = controller;
                                                    controller.setMapStyle(
                                                        MyMapStyle
                                                            .googleMapStyle);
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${poiListForCircular.poi.poiname}",
                                                    style: FontStyleUtilities.s24(
                                                        fontColor:
                                                            ApplicationColors
                                                                .blackColor00),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    poiListForCircular.radius ==
                                                            null
                                                        ? "${getTranslated(context, "radius")}: 0.0"
                                                        : '${getTranslated(context, "radius")} : ${NumberFormat("##0.0#", "en_US").format(poiListForCircular.radius)}',
                                                    overflow:
                                                        TextOverflow.visible,
                                                    style: Textstyle1.text12
                                                        .copyWith(
                                                      color: Colors.purple,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on),
                                                      Text(
                                                        _geofencesProvider
                                                                    .poiAddress
                                                                    .isEmpty ||
                                                                _geofencesProvider
                                                                            .poiAddress[
                                                                        index] ==
                                                                    null
                                                            ? "Address Not Found"
                                                            // "${getTranslated(context, "address_not_found")}"
                                                            : " ${_geofencesProvider.poiAddress[index]}",
                                                        overflow: TextOverflow
                                                            .visible,
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: 2,
                                                        style: Textstyle1.text12
                                                            .copyWith(
                                                                fontSize: 10,
                                                                color: ApplicationColors
                                                                    .blackColor00),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      showCircularDialog(
                                                          poiListForCircular);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 24,
                                                        vertical: 6,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: ApplicationColors
                                                            .redColor67,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          20,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "${getTranslated(context, "DELETE")}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                  : SizedBox(),

              // Polygon
              selectedPoi == false
                  ? _geofencesProvider.isGeofenceLoading
                      ? Expanded(child: Helper.dialogCall.showLoader())
                      : _geofencesProvider.getAllGeofenceList.length == 0
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  "${getTranslated(context, "geofences_list_not_available")}",
                                  textAlign: TextAlign.center,
                                  style: Textstyle1.text18.copyWith(
                                    fontSize: 18,
                                    color: ApplicationColors.redColor67,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: _geofencesProvider
                                      .getAllGeofenceList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var allGeoFenceDetails = _geofencesProvider
                                        .getAllGeofenceList[index];

                                    return InkWell(
                                      onTap: () {
                                        mapControllerPoly.animateCamera(
                                            CameraUpdate.newLatLngBounds(
                                                _createBounds(_geofencesProvider
                                                    .latLng[index]),
                                                100));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        child: Column(
                                          children: [
                                            Card(
                                              elevation: 4,
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                decoration:
                                                    Boxdec.conrad6colorblack,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${allGeoFenceDetails.geoname}",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins-Regular',
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                        Spacer(),
                                                        InkWell(
                                                          onTap: () async {
                                                            var id =
                                                                '${allGeoFenceDetails.id}';
                                                            var isEntering =
                                                                allGeoFenceDetails
                                                                    .entering;
                                                            var isExiting =
                                                                allGeoFenceDetails
                                                                    .exiting;
                                                            var polygonName =
                                                                allGeoFenceDetails
                                                                    .geoname;
                                                            List<LatLng>
                                                                polyGonList =
                                                                _geofencesProvider
                                                                        .latLng[
                                                                    index];
                                                            List polyList =
                                                                _geofencesProvider
                                                                    .getAllGeofenceList[
                                                                        index]
                                                                    .geofence
                                                                    .coordinates;

                                                            final value =
                                                                await Navigator
                                                                    .push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => UpdateGeofence(
                                                                    id: id,
                                                                    isEntering:
                                                                        isEntering,
                                                                    isExiting:
                                                                        isExiting,
                                                                    name:
                                                                        polygonName,
                                                                    poyList:
                                                                        polyList,
                                                                    polyGonList:
                                                                        polyGonList),
                                                              ),
                                                            );

                                                            if (value != null) {
                                                              getAllGeofence();
                                                              getPoiList();
                                                            }
                                                          },
                                                          child: Icon(
                                                            Icons.edit,
                                                            size: 30,
                                                            color:
                                                                ApplicationColors
                                                                    .greenColor,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        InkWell(
                                                          onTap: () {
                                                            deletePolygonDialog(
                                                                allGeoFenceDetails
                                                                    .id);
                                                          },
                                                          child: Icon(
                                                            Icons.delete,
                                                            color:
                                                                ApplicationColors
                                                                    .redColor,
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "Number Of Vehicles - ${allGeoFenceDetails.v}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            FlutterSwitch(
                                                              toggleSize: 16,
                                                              padding: 2,
                                                              height:
                                                                  height * .021,
                                                              width:
                                                                  width * .09,
                                                              activeColor: Colors
                                                                  .red
                                                                  .withOpacity(
                                                                0.3,
                                                              ),
                                                              activeToggleColor:
                                                                  ApplicationColors
                                                                      .redColor67,
                                                              inactiveToggleColor:
                                                                  ApplicationColors
                                                                      .whiteColor,
                                                              toggleColor:
                                                                  ApplicationColors
                                                                      .black4240,
                                                              inactiveColor:
                                                                  ApplicationColors
                                                                      .greyC4C4,
                                                              value:
                                                                  _alertSetting,
                                                              onToggle: (val) {
                                                                setState(() {
                                                                  _alertSetting =
                                                                      val;
                                                                });
                                                              },
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                                "${getTranslated(context, "display_map")}",
                                                                style: Textstyle1
                                                                    .text10),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                        ),
                                                        Column(
                                                          children: [
                                                            FlutterSwitch(
                                                              toggleSize: 16,
                                                              padding: 2,
                                                              height:
                                                                  height * .021,
                                                              width:
                                                                  width * .09,
                                                              activeColor: Colors
                                                                  .red
                                                                  .withOpacity(
                                                                0.3,
                                                              ),
                                                              activeToggleColor:
                                                                  ApplicationColors
                                                                      .redColor67,
                                                              inactiveToggleColor:
                                                                  ApplicationColors
                                                                      .whiteColor,
                                                              toggleColor:
                                                                  ApplicationColors
                                                                      .black4240,
                                                              inactiveColor:
                                                                  ApplicationColors
                                                                      .greyC4C4,
                                                              value:
                                                                  _alertSetting1,
                                                              onToggle: (val) {
                                                                setState(() {
                                                                  _alertSetting1 =
                                                                      val;
                                                                });
                                                              },
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                                "${getTranslated(context, "notification_entering")}",
                                                                style: Textstyle1
                                                                    .text10),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                        ),
                                                        Column(
                                                          children: [
                                                            FlutterSwitch(
                                                              toggleSize: 16,
                                                              padding: 2,
                                                              height:
                                                                  height * .021,
                                                              width:
                                                                  width * .09,
                                                              activeColor: Colors
                                                                  .red
                                                                  .withOpacity(
                                                                0.3,
                                                              ),
                                                              activeToggleColor:
                                                                  ApplicationColors
                                                                      .redColor67,
                                                              inactiveToggleColor:
                                                                  ApplicationColors
                                                                      .whiteColor,
                                                              toggleColor:
                                                                  ApplicationColors
                                                                      .black4240,
                                                              inactiveColor:
                                                                  ApplicationColors
                                                                      .greyC4C4,
                                                              value:
                                                                  _alertSetting2,
                                                              onToggle: (val) {
                                                                setState(() {
                                                                  _alertSetting2 =
                                                                      val;
                                                                });
                                                              },
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                                "${getTranslated(context, "notification_exiting")}",
                                                                style: Textstyle1
                                                                    .text10),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                  : SizedBox(),
            ]),
    );
  }
}
