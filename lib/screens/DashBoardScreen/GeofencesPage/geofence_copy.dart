import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
import 'package:oneqlik/utils/colors.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeofencesCopy extends StatefulWidget {
  const GeofencesCopy({Key key}) : super(key: key);
  @override
  _GeofencesCopyState createState() => _GeofencesCopyState();
}

class _GeofencesCopyState extends State<GeofencesCopy> {

  List<GoogleMapController> mapController = [];
  List<GoogleMapController> mapControllerPoly = [];

  FocusNode focusNode;

  var  apiKey = "AIzaSyAdonwbTHNYYyJKwQVo2qY23FaX9PL9qSc";
   //   "AIzaSyDNmQ3sok_q3O9JZ66cFJgzFfiJiDWESmY";
  bool searchValue = true;
  bool isLoading = true,isShow = true;
  List<MapSuggestion> suggestionList = [];
  TextEditingController searchController = TextEditingController();

  BitmapDescriptor sourceIcon;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 6.0), "assets/images/location.png");
  }

  bool selectedPoi = true;
  var height, width;
  bool _alertSetting = true;
  bool _alertSetting1 = true;
  bool _alertSetting2 = true;


  GeofencesProvider _geofencesProvider;

  getAllGeofence() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
    };

    print("id pritn $data");
    _geofencesProvider.getAllGeofence(data, "geofencingV2/getallgeofence","geo",context);
  }


  getPoiList() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "user": id,
    };

    _geofencesProvider.getPoiList(data, "poiV2/getPois","geo");

    if(_geofencesProvider.isSuccess){
      for(int i = 0; i<_geofencesProvider.poiAddress.length;i++){
        GoogleMapController controller;
        mapController.add(controller);
      }
    }

  }

  deleteGeofences(id) async {
    var data = {
      // "id": "61c054573c380a1e6d9fa4c0",
      "id": "$id",
    };

    // print('data->${data}');

    _geofencesProvider.deleteGeofence(data, "geofencing/deletegeofence",context);
  }

  deletePoi(id) async {
    var data = {
      "_id": "$id",
    };

    _geofencesProvider.deletePoi(data, "poi/deletePoi",context);
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
    for(int i = 0; i<mapController.length; i++){
      mapController[i].dispose();
    }
    super.dispose();
  }

  showCircularDialog(poiListForCircular){
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              backgroundColor: ApplicationColors.blackColor2E,
              title: Container(
                decoration: BoxDecoration(color: ApplicationColors.blackColor2E, borderRadius: BorderRadius.circular(6)),
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        var id = '${poiListForCircular.id}';
                        var location = poiListForCircular.poi.location.coordinates;
                        var name = '${poiListForCircular.poi.poiname}';
                        var radius = poiListForCircular.radius == null ? "0.0" :'${poiListForCircular.radius}';
                        /// TODO:IMPLEMENT EXITING AND ENTERING
                        /* var isExit = '${poiListForCircular.heading}';
                                                                     var isEntry = '${poiListForCircular.id}';*/
                        Navigator.push(
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
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/Edit_icon.png',
                            width: 20,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "${getTranslated(context, "edit")}",

                            style: Textstyle1.text14,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        deletePoi(poiListForCircular.id);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/delete_icon.png',
                            width: 20,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "${getTranslated(context, "delete")}",
                            style: Textstyle1.text14,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text("${getTranslated(context, "display_map")}", style: Textstyle1.text14),
                        Expanded(
                            child: SizedBox(
                              width: 20,
                            )),
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
                        Text("Notification Entering", style: Textstyle1.text14),
                        Expanded(
                            child: SizedBox(
                              width: 20,
                            )),
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
                      children: [
                        Text("Notification Exiting", style: Textstyle1.text14),
                        Expanded(
                            child: SizedBox(
                              width: 20,
                            )),
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
                          value: _alertSetting2,
                          onToggle: (val) {
                            setState(() {
                              _alertSetting2 = val;
                            });
                          },
                        ),
                      ],
                    ),
                    //SizedBox(height: 20,),
                  ],
                ),
              ));
        });
      },
    );
  }

  showPolygonDialog(allGeoFenceDetails,index){
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: ApplicationColors.blackColor2E,
            title: Container(
              decoration: BoxDecoration(color: ApplicationColors.blackColor2E, borderRadius: BorderRadius.circular(6)),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);

                      var id = '${allGeoFenceDetails.id}';
                      var isEntering = allGeoFenceDetails.entering;
                      var isExiting = allGeoFenceDetails.exiting;
                      var polygonName = allGeoFenceDetails.geoname;
                      List polyList = _geofencesProvider.getAllGeofenceList[index].geofence.coordinates;


                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateGeofence(
                            id: id,
                            isEntering: isEntering,
                            isExiting: isExiting,
                            name: polygonName,
                            poyList: polyList,
                          ),
                        ),
                      );

                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/Edit_icon.png',
                          width: 20,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "${getTranslated(context, "edit")}",
                          style: Textstyle1.text14,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/delete_icon.png',
                        width: 20,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          deleteGeofences(allGeoFenceDetails.id);
                        },
                        child: Text(
                          "${getTranslated(context, "delete")}",
                          style: Textstyle1.text14,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text("${getTranslated(context, "display_map")}", style: Textstyle1.text14),
                      Expanded(
                          child: SizedBox(
                            width: 20,
                          )),
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
                        value: _alertSetting,
                        onToggle: (val) {
                          setState(() {
                            _alertSetting = val;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Notification Entering", style: Textstyle1.text14),
                      Expanded(
                          child: SizedBox(
                            width: 20,
                          )),
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
                        value: _alertSetting1,
                        onToggle: (val) {
                          setState(() {
                            _alertSetting1 = val;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Notification Exiting",
                        style: Textstyle1.text14,
                      ),
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
                        switchBorder: Border.all(color: Colors.white),
                        activeColor: ApplicationColors.blackColor2E,
                        activeToggleColor: ApplicationColors.redColor67,
                        toggleColor: ApplicationColors.white9F9,
                        inactiveColor: ApplicationColors.blackColor2E,
                        value: _alertSetting2,
                        onToggle: (val) {
                          setState(() {
                            _alertSetting2 = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  LatLngBounds _bounds(List<LatLng> markers) {
    if (markers == null || markers.isEmpty) return null;
    return _createBounds(markers);
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce((value, element) => value < element ? value : element); // smallest
    final southwestLon = positions.map((p) => p.longitude).reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce((value, element) => value > element ? value : element); // biggest
    final northeastLon = positions.map((p) => p.longitude).reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon)
    );
  }

  @override
  Widget build(BuildContext context) {
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/dark_background_image.png",
              ), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),
          ),
        ),

        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Geofences",
              style: Textstyle1.appbartextstyle1,
            ),
            actions: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                decoration: BoxDecoration(
                  color: ApplicationColors.redColor67,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddGeofenceScreen()));
                  },
                  child: Center(
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding:
            const EdgeInsets.fromLTRB(20,10,20,0),
            child: Column(
                children: [
                  Container(
                    decoration: Boxdec.bcgreyrad25,
                    height: height * .06,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPoi = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration: Boxdec.bcgreyrad25.copyWith(
                                color: selectedPoi == true
                                    ?
                                ApplicationColors.redColor67
                                    :
                                ApplicationColors.blackColor2E,
                                border: Border.all(
                                  color: ApplicationColors.blackColor2E,
                                ),
                              ),
                              width: width / 2.319,
                              height: height * .05,
                              child: Center(
                                child: Text(
                                  "Circular",
                                  style: Textstyle1.text18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPoi = false;

                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 3.2),
                              decoration: Boxdec.bcgreyrad25.copyWith(
                                color: selectedPoi == false
                                    ?
                                ApplicationColors.redColor67
                                    :
                                ApplicationColors.blackColor2E,
                                border: Border.all(color: ApplicationColors.blackColor2E,
                                ),
                              ),
                              width: width / 2.3,
                              height: height * .05,
                              child: Center(
                                child: Text(
                                  "Polygon",
                                  style: Textstyle1.text18,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 20),


                  // circle
                  selectedPoi
                      ?
                  _geofencesProvider.isGetPoiListLoading
                      ?
                  Expanded(child: Helper.dialogCall.showLoader())
                      :
                  _geofencesProvider.getPoiDetailsList.length == 0
                      ?
                  Expanded(
                    child: Center(
                      child: Text(
                        "Poi List is not available",
                        textAlign: TextAlign.center,
                        style: Textstyle1.text18.copyWith(
                          fontSize: 18,
                          color: ApplicationColors
                              .redColor67,
                        ),
                      ),
                    ),
                  )
                      :
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _geofencesProvider.getPoiDetailsList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var poiListForCircular = _geofencesProvider.getPoiDetailsList[index];

                          return  Container(
                            height: height*.22,
                            margin: EdgeInsets.only(bottom: 13),
                            decoration: Boxdec.bcgreyrad6.copyWith(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(2),
                            child: Stack(
                              children: [
                                GoogleMap(
                                  zoomControlsEnabled: false,
                                  zoomGesturesEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                    target:  LatLng(poiListForCircular.poi.location.coordinates[0],poiListForCircular.poi.location.coordinates[1]),
                                    zoom: 16.0, //initial zoom level
                                  ),
                                 // markers: _geofencesProvider.markerList.isEmpty ? {} : _geofencesProvider.markerList[index],
                                  mapType: Utils.mapType, //map type
                                  circles: {
                                    Circle(
                                      circleId: CircleId('circle_123'),
                                        center: LatLng(poiListForCircular.poi.location.coordinates[0], poiListForCircular.poi.location.coordinates[1]),
                                      radius: poiListForCircular.radius == null ? 0.0:double.parse(poiListForCircular.radius.toString()),
                                      strokeColor: const Color(0xffF84A67).withOpacity(0.15),
                                      fillColor: const Color(0xffF84A67).withOpacity(0.15),
                                      strokeWidth: 1,
                                    ),
                                  },//map type

                                  onLongPress:(value){
                                    mapController[index].animateCamera(
                                        CameraUpdate.zoomOut()
                                    );
                                  },

                                  onMapCreated: (controller) {
                                    if(_geofencesProvider.isSuccess){
                                      mapController[index] = controller;
                                    }
                                  },
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 70,
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 6),
                                    decoration: Boxdec.bcgreyrad25.copyWith(
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              " ${poiListForCircular.poi.poiname}",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.visible,
                                              maxLines: 1,
                                              style:
                                              Textstyle1.text14,
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Expanded(
                                              child: Row(
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
                                                  SizedBox(
                                                      width: width*0.7,
                                                      child:Text(
                                                        _geofencesProvider.poiAddress.isEmpty ? "":
                                                        " ${_geofencesProvider.poiAddress[index]}",
                                                        overflow: TextOverflow.visible,
                                                        textAlign: TextAlign.start,
                                                        maxLines:2,
                                                        style: Textstyle1.text12.copyWith(fontSize: 10),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: width * 0.18,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showCircularDialog(poiListForCircular);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                                            child: Image.asset(
                                              "assets/images/threen_verticle_options_icon.png",
                                              width: 04, height: 20,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 75,
                                    left: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal:10,vertical: 07),
                                      decoration: Boxdec.bcgreyrad25.copyWith(
                                          borderRadius: BorderRadius.circular(6),
                                          color: ApplicationColors.redColor67),
                                      child: Center(
                                          child: Text(
                                            poiListForCircular.radius == null
                                                ?
                                            "Radius: 0.0"
                                                :
                                            'Radius: ${NumberFormat("##0.0#", "en_US").format(poiListForCircular.radius)}',
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.visible,
                                            maxLines: 1,
                                            style: Textstyle1.text12.copyWith(
                                              fontSize: 11,
                                            ),
                                          )),
                                    )),
                              ],
                            ),
                          );
                        }),
                  )
                      :
                  SizedBox(),


                  // Polygon
                  selectedPoi == false
                      ?
                  _geofencesProvider.isGeofenceLoading
                      ?
                  Expanded(child: Helper.dialogCall.showLoader())
                      :
                  _geofencesProvider.getAllGeofenceList.length == 0
                      ?
                  Expanded(
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
                      :
                  Expanded(
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: _geofencesProvider.getAllGeofenceList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var allGeoFenceDetails = _geofencesProvider.getAllGeofenceList[index];

                          print("polygonList");
                          print("mainList");
                          print(_geofencesProvider.getAllGeofenceList.length);

                          return Container(
                            height: height*.22,
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: Boxdec.bcgreyrad6.copyWith(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(8)),
                            padding: EdgeInsets.all(2),
                            child: Stack(
                              children: [
                                GoogleMap(
                                  zoomControlsEnabled: false,
                                //  cameraTargetBounds: CameraTargetBounds(_bounds(_geofencesProvider.polygonLatLng2[index])),

                                  initialCameraPosition: CameraPosition(
                                   // target:_geofencesProvider.polygonLatLng2[index].first,
                                    zoom: 10.0, //initial zoom level
                                  ),
                                  // polygons: _geofencesProvider.polygonList[index],

                                  //  markers: _markers,
                                  //   mapType: MapType.normal,
                                  mapType: Utils.mapType, //map type
                                  onMapCreated: (controller) {

                                    // mapController[i] = controller;
                                  },
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: Boxdec.bcgreyrad25.copyWith(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${allGeoFenceDetails.geoname}",
                                            style:
                                            Textstyle1.text14,
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              width: width * 0.18,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showPolygonDialog(allGeoFenceDetails,index);
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(vertical: 20.0),
                                              child: Image.asset(
                                                "assets/images/threen_verticle_options_icon.png",
                                                width: 04,
                                                height: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                      :
                  SizedBox(),
                ]
            ),
          ),
        ),
      ],
    );
  }
}
