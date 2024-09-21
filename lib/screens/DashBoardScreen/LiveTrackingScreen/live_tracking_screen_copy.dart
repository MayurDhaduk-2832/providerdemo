import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/socket_model.dart';
import 'package:oneqlik/Provider/geofence_provider.dart';
import 'package:oneqlik/Provider/histroy_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/screens/DashBoardScreen/LiveTrackingScreen/live_vehicle_filter.dart';
import 'package:oneqlik/screens/DashBoardScreen/dashboard_screen.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/map_json.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Provider/vehicle_list_provider.dart';
import 'package:vector_math/vector_math.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/services.dart' show rootBundle;

import '../../../local/localization/language_constants.dart';
import '../LiveForVehicleScreen/live_for_vehicle_screen.dart';

class LiveTrackingScreenCopy extends StatefulWidget {
  const LiveTrackingScreenCopy({Key key}) : super(key: key);

  @override
  _LiveTrackingScreenCopyState createState() => _LiveTrackingScreenCopyState();
}

class _LiveTrackingScreenCopyState extends State<LiveTrackingScreenCopy>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  VehicleListProvider vehicleListProvider;
  GeofencesProvider geofenceProvider;
  Completer<GoogleMapController> mapController2 = Completer();
  GoogleMapController mapController;
  bool isChangeMap = false;
  MapType mapType = MapType.normal;

  List carData = [];
  List<LatLng> latLgnList = [];
  List<LatLng> latLgnBoundList = [];
  List deviceImeiList = [];
  List<SocketModelClass>socketList = [];
  List<Marker> carMarker = <Marker>[];
  Completer completer = Completer();
  Uint8List poiPoints;

  getVehicleList() async {
    poiPoints = await getBytesFromAsset('assets/images/poi.png', 40);

    setState(() {
      vehicleListProvider.vehicleList.clear();
      carMarker.clear();
      carData.clear();
      latLgnBoundList.clear();
      latLgnList.clear();
      socketList.clear();
    });

    var idList = "";
    String list = "";

    if (deviceImeiList.isNotEmpty) {
      for (int i = 0; i < deviceImeiList.length; i++) {
        idList = idList + "${deviceImeiList[i]},";
      }
      list = idList.substring(0, idList.length - 1);
    }


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");
    var supAdmin = sharedPreferences.getBool("superAdmin");
    bool isDealer = sharedPreferences.getBool("isDealer");


    var data = list == ""
        ?
    {
      "id": id,
      "email": email,
      supAdmin == false ? "" : "supAdmin": id ?? "",
      isDealer == false ? "" : "dealer": id ?? ""
    }
        :
    {
      "id": id,
      "email": email,
      supAdmin == false ? "" : "supAdmin": id ?? "",
      isDealer == false ? "" : "dealer": id ?? "",
      "dev": "$list"
    };


    print("Data is:$data");
    print("get vehicle api call");

    await vehicleListProvider.getVehicleList(
        data, "devices/getDeviceByUserMobile", "live");

    if (vehicleListProvider.isSucces == false) {
      if (vehicleListProvider.vehicleList.isNotEmpty) {
        for (int i = 0; i < vehicleListProvider.vehicleList.length; i++) {
          print("Hariom : " + i.toString());
          print("Gupta : " + vehicleListProvider.vehicleList.length.toString());

          latLgnList.clear();
          if (vehicleListProvider.vehicleList[i].lastLocation != null) {
            latLgnList.add(
              LatLng(
                vehicleListProvider.vehicleList[i].lastLocation.lat,
                vehicleListProvider.vehicleList[i].lastLocation.long,
              ),
            );
          }
          // print("print i => $i");

          var data = {
            "id": "${vehicleListProvider.vehicleList[i].id}",
            "value": vehicleListProvider.vehicleListModel.devices[i],
            "latLogList": [],
          };
          latLgnBoundList.addAll(latLgnList);
          carData.add(data);

          // print("carData==> $carData");


          if (carData[i]["value"].lastLocation != null) {
            carMarker.add(
                Marker(
                  markerId: MarkerId(
                      "${vehicleListProvider.vehicleList[i].deviceId}"),
                  position: LatLng(
                    carData[i]["value"].lastLocation.lat,
                    carData[i]["value"].lastLocation.long,
                  ),
                  rotation: double.tryParse(
                      "${vehicleListProvider.vehicleList[i].heading ?? "0"}"),
                  icon: carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "bike"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/bikeMarker/bikeGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "bike"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/bikeMarker/bikeYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "bike"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/bikeMarker/bikeBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "bike"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/bikeMarker/bikeOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "bike"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/bikeMarker/bikeRed.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "bike"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/bikeMarker/bikePurple.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "car"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/carMarker/carGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "car"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/carMarker/carYello.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "car"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/carMarker/carBule.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "car"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/carMarker/carOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "car"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/carMarker/carRed.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "car"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/carMarker/carPurple.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "truck"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/longTruckMarker/longTruckGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "truck"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/longTruckMarker/longTruckYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "truck"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/longTruckMarker/longTruckBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "truck"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/longTruckMarker/longTruckOrange.png",
                      Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                      .deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "truck"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/longTruckMarker/longTruckRed.png",
                      Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                      .deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "truck"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/longTruckMarker/longTruckPurple.png",
                      Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                      .deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "bus"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/busMarker/busGreen.png", Size(
                      100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                      .deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "bus"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/busMarker/busYello.png", Size(
                      100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                      .deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "bus"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/busMarker/busBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" && carData[i]["value"]
                      .iconType == "bus"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/busMarker/busOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" && carData[i]["value"]
                      .iconType == "bus"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/busMarker/busPink.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "bus"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/busMarker/busPurple.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "jcb"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/jcbMarker/jcbGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "jcb"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/jcbMarker/jcbYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "jcb"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/jcbMarker/jcbBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "jcb"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/jcbMarker/jcbOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "jcb"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/jcbMarker/jcbRed.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "jcb"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/jcbMarker/jcbPurple.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "tractor"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/tractorMarker/tractorGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "tractor"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/tractorMarker/tractorYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "tractor"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/tractorMarker/tractorBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "tractor"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/tractorMarker/tractorOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "tractor"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/tractorMarker/tractorOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "tractor"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/tractorMarker/tractorPurple.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "pickup"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/smallTruckMarker/smallTruckGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "pickup"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/smallTruckMarker/smallTruckYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "pickup"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/smallTruckMarker/smallTruckBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "pickup"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/smallTruckMarker/smallTruckOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "pickup"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/smallTruckMarker/smallTruckRed.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "pickup"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/smallTruckMarker/smallTruckPurple.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "scooter"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/scootyMarker/scootyGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "scooter"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/scootyMarker/sccotyYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "scooter"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/scootyMarker/sccotyBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "scooter"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/scootyMarker/sccotyOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "scooter"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/scootyMarker/sccotyRed.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "scooter"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/scootyMarker/scootyPurple.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "pet"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/petMarker/petGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "pet"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/petMarker/petYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "pet"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/petMarker/petBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "pet"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/petMarker/petOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "pet"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/petMarker/petRed.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "pet"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/petMarker/petPurple.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "user"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/userMarker/userGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "user"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/userMarker/userYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "user"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/userMarker/userBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "user"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/userMarker/userOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "user"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/userMarker/userRed.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "user"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/userMarker/userPurple.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "auto"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/rickshawMarker/ricshowGreen.png",
                      Size(150.0, 160.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "auto"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/rickshawMarker/ricshowYellow.png",
                      Size(150.0, 160.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "auto"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/rickshawMarker/ricshowBlue.png",
                      Size(150.0, 160.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "auto"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/rickshawMarker/ricshowOrange.png",
                      Size(150.0, 160.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "auto"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/rickshawMarker/ricshowRed.png",
                      Size(150.0, 160.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "auto"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/rickshawMarker/ricshowGrey.png",
                      Size(150.0, 160.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "ambulance"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/ambulanceMarker/ambulanceGreen.png",
                      Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                      .deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "ambulance"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/ambulanceMarker/ambulanceYellow.png",
                      Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                      .deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "ambulance"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/ambulanceMarker/ambulanceBlue.png",
                      Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                      .deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "ambulance"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/ambulanceMarker/ambulanceOrange.png",
                      Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                      .deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "ambulance"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/ambulanceMarker/ambulanceRed.png",
                      Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                      .deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "ambulance"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/ambulanceMarker/ambulanceGrey.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" && carData[i]["value"]
                      .iconType == "crane"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/craneMarker/craneGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" && carData[i]["value"]
                      .iconType == "crane"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/craneMarker/craneYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "crane"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/craneMarker/craneBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "crane"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/craneMarker/craneOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "crane"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/craneMarker/craneRed.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "crane"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/craneMarker/craneGrey.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "machine"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/generatorMarker/genratorGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "machine"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/generatorMarker/genratorYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "machine"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/generatorMarker/genratorBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "machine"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/generatorMarker/genratorOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "machine"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/generatorMarker/genratorRed.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "machine"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/generatorMarker/genratorGrey.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "RUNNING" &&
                      carData[i]["value"].iconType == "boat"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/boatMarker/boatGreen.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "IDLING" &&
                      carData[i]["value"].iconType == "boat"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/boatMarker/boatYellow.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "OUT OF REACH" &&
                      carData[i]["value"].iconType == "boat"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/boatMarker/boatBlue.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "Expired" &&
                      carData[i]["value"].iconType == "boat"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/boatMarker/boatOrange.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "STOPPED" &&
                      carData[i]["value"].iconType == "boat"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/boatMarker/boatRed.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  carData[i]["value"].status == "NO GPS FIX" &&
                      carData[i]["value"].iconType == "boat"
                      ?
                  await getMarkerIcon(
                      "assets/images/marker/boatMarker/boatGrey.png",
                      Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}")
                      :
                  await getMarkerIcon(
                      "assets/images/location.png", Size(100.0, 110.0),
                      "${vehicleListProvider.vehicleList[i].deviceName}"),

                )
            );

            // setState(() {
            _mapMarkerSC.add(carMarker);
            //  });
          }

          animationControllerList.add(
              AnimationController(
                duration: const Duration(seconds: 0),
                //Animation duration of marker
                vsync: this, //From the widget
              )
          );
        }

        print("Animation controller $animationControllerList");
        print("Animation controller length ${animationControllerList.length}");
        print("car data here $carData");

        connectSocketIo();
      }
    }
  }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    ByteData data = await rootBundle.load(imagePath);
    Uint8List imageBytes = data.buffer.asUint8List();

    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size,
      String carName) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final double tagWidth = 60.0;

    // Add tag text

    TextSpan span = TextSpan(
        text: ' ( ${carName} ) ',
        style: Textstyle1.text18bold.copyWith(
            color: ApplicationColors.black4240,
            fontSize: 17,
            backgroundColor: ApplicationColors.containercolor
        )
    );

    // TextPainter textPainter = TextPainter(text: span , textDirection: TextDirection.ltr,textAlign: TextAlign.center,);
    //
    // textPainter.layout(minWidth: 100, maxWidth: 800);

    TextPainter textPainter = TextPainter(text: span,
      // textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,);

    textPainter.layout(minWidth: 100, maxWidth: 800);


    textPainter.paint(
        canvas,
        new Offset(5.0, 5.0)
      // Offset((size.width - textPainter.width) * 0.8, tagWidth  - textPainter.height)
    );

    // Oval for the image
    Rect oval = Rect.fromLTWH(
        0.0,
        40.0,
        size.width + 50,
        size.height - textPainter.height
    );

    //
    // textPainter.paint(
    //     canvas,
    //     Offset((size.width - textPainter.width) * 0.8, tagWidth  - textPainter.height)
    // );

    // // Oval for the image
    // Rect oval = Rect.fromLTWH(
    //     0.0,
    //     80.0,
    //     size.width,
    //     size.height - textPainter.height
    // );

    // Add image
    ui.Image image = await getImageFromPath(
        imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.scaleDown);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
        150, //size.width.toInt(),
        (size.height + 60).toInt()
    );

    // Convert image to bytes
    final ByteData byteData = await markerAsImage.toByteData(
        format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer
        .asUint8List();
  }

  var height, width;

  IO.Socket socket;
  SocketModelClass socketModelClass;


  connectSocketIo() {
    socket = IO.io('https://www.oneqlik.in/gps', <String, dynamic>{
      "secure": true,
      "rejectUnauthorized": false,
      "transports": ["websocket", "polling"],
      "upgrade": false
    });

    socket.connect();

    socket.onConnect((data) async {
      print("socket Connected");
      for (int i = 0; i < vehicleListProvider.vehicleList.length; i++) {
        // print("HAriom");

        if (carData[i]["id"] == "${vehicleListProvider.vehicleList[i].id}") {
          print("inside if => ${carData[i]["id"]}");

          await carMarkerAdd(vehicleListProvider.vehicleList[i].deviceId, i);
        }
      }
    });
  }

  carMarkerAdd(id, i) async {
    socket.emit("acc", "$id");

    socket.on("${id}acc", (data) async {
      //print("Socket Data == > ${data[3]}");

      if (data[3] != null) {
        var resonance = data[3];

        print("socket Index $i");

        var list = SocketModelClass.fromJson(resonance);
        print("socket id => ${list.id}");
        print("socket id 2 => $id");


        if (list.lastLocation != null && list.lastLocation.lat != null &&
            list.lastLocation.long != null) {
          print("Socket car data  == > name: ${list.deviceName}, lat:${list
              .lastLocation.lat}, lgn: ${list.lastLocation.long}");

          if (carData[i]["latLogList"].length == 2) {
            LatLng latLng = LatLng(
              list.lastLocation.lat,
              list.lastLocation.long,
            );
            if (carData[i]["latLogList"][1] == latLng) {
              print("same location");
            } else {
              setState(() {
                carData[i]["latLogList"].removeAt(0);
                carData[i]["id"] = list.id;
                carData[i]["value"] = list;


                carData[i]["latLogList"].add(
                  LatLng(
                    list.lastLocation.lat,
                    list.lastLocation.long,
                  ),
                );

                // print("socket car data ==> ${carData[i]}");
              });

              print(carData);

              startMarker(i);
            }
          }

          else {
            setState(() {
              carData[i]["id"] = list.id;
              carData[i]["value"] = list;
              carData[i]["latLogList"].add(
                LatLng(
                  list.lastLocation.lat,
                  list.lastLocation.long,
                ),
              );
            });
          }
        }
      }
    });
  }

  Animation<double> _animation;
  final _mapMarkerSC = StreamController<List<Marker>>();

  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;

  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;

  startMarker(int index) {
    int i = 0;

    animateCar(
      carData[index]["latLogList"][i].latitude,
      carData[index]["latLogList"][i].longitude,
      carData[index]["latLogList"][i + 1].latitude,
      carData[index]["latLogList"][i + 1].longitude,
      _mapMarkerSink,
      this,
      index,
      mapController,
    );
  }

  AnimationController animationController;
  List<AnimationController> animationControllerList = [];

  animateCar(double fromLat, //Starting latitude
      double fromLong, //Starting longitude
      double toLat, //Ending latitude
      double toLong, //Ending longitude
      StreamSink<List<Marker>> mapMarkerSink,
      //Stream build of map to update the UI
      TickerProvider provider,
      //Ticker provider of the widget. This is used for animation
      int i,
      GoogleMapController controller, //Google map controller of our widget
      ) async {
    final double bearing = getBearing(
        LatLng(fromLat, fromLong), LatLng(toLat, toLong));


    var carMarkers = Marker(
      markerId: MarkerId("${vehicleListProvider.vehicleList[i].deviceId}"),
      position: LatLng(fromLat, fromLong),
      anchor: const Offset(0.5, 0.5),
      flat: true,
      draggable: false,
      onTap: () {
        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(fromLat, fromLong), zoom: 15),
          ),
        );
      },
      rotation: bearing,
      icon: carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "bike"
          ?
      await getMarkerIcon(
          "assets/images/marker/bikeMarker/bikeGreen.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "bike"
          ?
      await getMarkerIcon(
          "assets/images/marker/bikeMarker/bikeYellow.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "bike"
          ?
      await getMarkerIcon(
          "assets/images/marker/bikeMarker/bikeBlue.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "bike"
          ?
      await getMarkerIcon(
          "assets/images/marker/bikeMarker/bikeOrange.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "bike"
          ?
      await getMarkerIcon(
          "assets/images/marker/bikeMarker/bikeRed.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "bike"
          ?
      await getMarkerIcon(
          "assets/images/marker/bikeMarker/bikePurple.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "car"
          ?
      await getMarkerIcon(
          "assets/images/marker/carMarker/carGreen.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "car"
          ?
      await getMarkerIcon(
          "assets/images/marker/carMarker/carYello.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "car"
          ?
      await getMarkerIcon(
          "assets/images/marker/carMarker/carBule.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "car"
          ?
      await getMarkerIcon(
          "assets/images/marker/carMarker/carOrange.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "car"
          ?
      await getMarkerIcon(
          "assets/images/marker/carMarker/carRed.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "car"
          ?
      await getMarkerIcon(
          "assets/images/marker/carMarker/carPurple.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "truck"
          ?
      await getMarkerIcon(
          "assets/images/marker/longTruckMarker/longTruckGreen.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "truck"
          ?
      await getMarkerIcon(
          "assets/images/marker/longTruckMarker/longTruckYellow.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "truck"
          ?
      await getMarkerIcon(
          "assets/images/marker/longTruckMarker/longTruckBlue.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "truck"
          ?
      await getMarkerIcon(
          "assets/images/marker/longTruckMarker/longTruckOrange.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "truck"
          ?
      await getMarkerIcon(
          "assets/images/marker/longTruckMarker/longTruckRed.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "truck"
          ?
      await getMarkerIcon(
          "assets/images/marker/longTruckMarker/longTruckPurple.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "bus"
          ?
      await getMarkerIcon(
          "assets/images/marker/busMarker/busGreen.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "bus"
          ?
      await getMarkerIcon(
          "assets/images/marker/busMarker/busYello.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "bus"
          ?
      await getMarkerIcon(
          "assets/images/marker/busMarker/busBlue.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "bus"
          ?
      await getMarkerIcon(
          "assets/images/marker/busMarker/busOrange.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "bus"
          ?
      await getMarkerIcon(
          "assets/images/marker/busMarker/busPink.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "bus"
          ?
      await getMarkerIcon(
          "assets/images/marker/busMarker/busPurple.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "jcb"
          ?
      await getMarkerIcon(
          "assets/images/marker/jcbMarker/jcbGreen.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "jcb"
          ?
      await getMarkerIcon(
          "assets/images/marker/jcbMarker/jcbYellow.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "jcb"
          ?
      await getMarkerIcon(
          "assets/images/marker/jcbMarker/jcbBlue.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "jcb"
          ?
      await getMarkerIcon(
          "assets/images/marker/jcbMarker/jcbOrange.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "jcb"
          ?
      await getMarkerIcon(
          "assets/images/marker/jcbMarker/jcbRed.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "jcb"
          ?
      await getMarkerIcon(
          "assets/images/marker/jcbMarker/jcbPurple.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "tracktor"
          ?
      await getMarkerIcon(
          "assets/images/marker/tractorMarker/tractorGreen.png", Size(100.0,
          110.0), "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "tracktor"
          ?
      await getMarkerIcon(
          "assets/images/marker/tractorMarker/tractorYellow.png", Size(
          100.0, 110.0), "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "tracktor"
          ?
      await getMarkerIcon(
          "assets/images/marker/tractorMarker/tractorBlue.png", Size(
          100.0, 110.0), "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "tracktor"
          ?
      await getMarkerIcon(
          "assets/images/marker/tractorMarker/tractorOrange.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType ==
          "tracktor"
          ?
      await getMarkerIcon(
          "assets/images/marker/tractorMarker/tractorOrange.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"]
          .iconType == "tracktor"
          ?
      await getMarkerIcon(
          "assets/images/marker/tractorMarker/tractorPurple.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "pickup"
          ?
      await getMarkerIcon(
          "assets/images/marker/smallTruckMarker/smallTruckGreen.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "pickup"
          ?
      await getMarkerIcon(
          "assets/images/marker/smallTruckMarker/smallTruckYellow.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "pickup"
          ?
      await getMarkerIcon(
          "assets/images/marker/smallTruckMarker/smallTruckBlue.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "pickup"
          ?
      await getMarkerIcon(
          "assets/images/marker/smallTruckMarker/smallTruckOrange.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "pickup"
          ?
      await getMarkerIcon(
          "assets/images/marker/smallTruckMarker/smallTruckRed.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "pickup"
          ?
      await getMarkerIcon(
          "assets/images/marker/smallTruckMarker/smallTruckPurple.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "scooter"
          ?
      await getMarkerIcon("assets/images/marker/scootyMarker/scootyGreen.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "scooter"
          ?
      await getMarkerIcon("assets/images/marker/scootyMarker/sccotyYellow.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "scooter"
          ?
      await getMarkerIcon("assets/images/marker/scootyMarker/sccotyBlue.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "scooter"
          ?
      await getMarkerIcon("assets/images/marker/scootyMarker/sccotyOrange.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "scooter"
          ?
      await getMarkerIcon(
          "assets/images/marker/scootyMarker/sccotyRed.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "scooter"
          ?
      await getMarkerIcon("assets/images/marker/scootyMarker/scootyPurple.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "pet"
          ?
      await getMarkerIcon(
          "assets/images/marker/petMarker/petGreen.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "pet"
          ?
      await getMarkerIcon(
          "assets/images/marker/petMarker/petYellow.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "pet"
          ?
      await getMarkerIcon(
          "assets/images/marker/petMarker/petBlue.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "pet"
          ?
      await getMarkerIcon(
          "assets/images/marker/petMarker/petOrange.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "pet"
          ?
      await getMarkerIcon(
          "assets/images/marker/petMarker/petRed.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "pet"
          ?
      await getMarkerIcon(
          "assets/images/marker/petMarker/petPurple.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "user"
          ?
      await getMarkerIcon(
          "assets/images/marker/userMarker/userGreen.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "user"
          ?
      await getMarkerIcon(
          "assets/images/marker/userMarker/userYellow.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "user"
          ?
      await getMarkerIcon(
          "assets/images/marker/userMarker/userBlue.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "user"
          ?
      await getMarkerIcon(
          "assets/images/marker/userMarker/userOrange.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "user"
          ?
      await getMarkerIcon(
          "assets/images/marker/userMarker/userRed.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "user"
          ?
      await getMarkerIcon(
          "assets/images/marker/userMarker/userPurple.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "auto"
          ?
      await getMarkerIcon(
          "assets/images/marker/rickshawMarker/ricshowGreen.png",
          Size(150.0, 160.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "auto"
          ?
      await getMarkerIcon(
          "assets/images/marker/rickshawMarker/ricshowYellow.png",
          Size(150.0, 160.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "auto"
          ?
      await getMarkerIcon("assets/images/marker/rickshawMarker/ricshowBlue.png",
          Size(150.0, 160.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "auto"
          ?
      await getMarkerIcon(
          "assets/images/marker/rickshawMarker/ricshowOrange.png",
          Size(150.0, 160.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "auto"
          ?
      await getMarkerIcon("assets/images/marker/rickshawMarker/ricshowRed.png",
          Size(150.0, 160.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "auto"
          ?
      await getMarkerIcon("assets/images/marker/rickshawMarker/ricshowGrey.png",
          Size(150.0, 160.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "ambulance"
          ?
      await getMarkerIcon(
          "assets/images/marker/ambulanceMarker/ambulanceGreen.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "ambulance"
          ?
      await getMarkerIcon(
          "assets/images/marker/ambulanceMarker/ambulanceYellow.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "ambulance"
          ?
      await getMarkerIcon(
          "assets/images/marker/ambulanceMarker/ambulanceBlue.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "ambulance"
          ?
      await getMarkerIcon(
          "assets/images/marker/ambulanceMarker/ambulanceOrange.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "ambulance"
          ?
      await getMarkerIcon(
          "assets/images/marker/ambulanceMarker/ambulanceRed.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "ambulance"
          ?
      await getMarkerIcon(
          "assets/images/marker/ambulanceMarker/ambulanceGrey.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "crane"
          ?
      await getMarkerIcon(
          "assets/images/marker/craneMarker/craneGreen.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "crane"
          ?
      await getMarkerIcon("assets/images/marker/craneMarker/craneYellow.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "crane"
          ?
      await getMarkerIcon(
          "assets/images/marker/craneMarker/craneBlue.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "crane"
          ?
      await getMarkerIcon("assets/images/marker/craneMarker/craneOrange.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "crane"
          ?
      await getMarkerIcon(
          "assets/images/marker/craneMarker/craneRed.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "crane"
          ?
      await getMarkerIcon(
          "assets/images/marker/craneMarker/craneGrey.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "machine"
          ?
      await getMarkerIcon(
          "assets/images/marker/generatorMarker/genratorGreen.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" &&
          carData[i]["value"].iconType == "machine"
          ?
      await getMarkerIcon(
          "assets/images/marker/generatorMarker/genratorYellow.png",
          Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
          .deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" &&
          carData[i]["value"].iconType == "machine"
          ?
      await getMarkerIcon(
          "assets/images/marker/generatorMarker/genratorBlue.png",
          Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
          .deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "machine"
          ?
      await getMarkerIcon(
          "assets/images/marker/generatorMarker/genratorOrange.png", Size(100.0,
          110.0), "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "machine"
          ?
      await getMarkerIcon(
          "assets/images/marker/generatorMarker/genratorRed.png", Size(
          100.0, 110.0), "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "machine"
          ?
      await getMarkerIcon(
          "assets/images/marker/generatorMarker/genratorGrey.png", Size(
          100.0, 110.0), "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "RUNNING" &&
          carData[i]["value"].iconType == "boat"
          ?
      await getMarkerIcon("assets/images/marker/boatMarker/boatGreen.png",
          Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType ==
          "boat"
          ?
      await getMarkerIcon(
          "assets/images/marker/boatMarker/boatYellow.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"]
          .iconType == "boat"
          ?
      await getMarkerIcon(
          "assets/images/marker/boatMarker/boatBlue.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "Expired" &&
          carData[i]["value"].iconType == "boat"
          ?
      await getMarkerIcon(
          "assets/images/marker/boatMarker/boatOrange.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "STOPPED" &&
          carData[i]["value"].iconType == "boat"
          ?
      await getMarkerIcon(
          "assets/images/marker/boatMarker/boatRed.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      carData[i]["value"].status == "NO GPS FIX" &&
          carData[i]["value"].iconType == "boat"
          ?
      await getMarkerIcon(
          "assets/images/marker/boatMarker/boatGrey.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}")
          :
      await getMarkerIcon("assets/images/location.png", Size(100.0, 110.0),
          "${vehicleListProvider.vehicleList[i].deviceName}"),

    );


    carMarker[i] = carMarkers;
    //mapMarkerSink.add(carMarker);

    /*animationController = AnimationController(
      duration: const Duration(seconds: 5), //Animation duration of marker
      vsync: provider, //From the widget
    );*/

    animationControllerList[i] = AnimationController(
      duration: const Duration(seconds: 5), //Animation duration of marker
      vsync: provider, //From the widget
    );

    Tween<double> tween = Tween(begin: 0, end: 1);


    /* _animation = tween.animate(animationController)..addListener(() async {
        //We are calculating new latitude and logitude for our marker
        final v = _animation.value;
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);



        //carMarker.removeWhere((element) => element.markerId.value == vehicleListProvider.vehicleList[i].deviceId);

        */ /*if (carMarker.contains(vehicleListProvider.vehicleList[i].deviceId)){
          carMarker.remove(vehicleListProvider.vehicleList[i].deviceId);
          carMarker.clear();
        }*/

    /*


        //New marker location
        carMarkers = Marker(
          markerId: MarkerId("${vehicleListProvider.vehicleList[i].deviceId}"),
          position: newPos,
          anchor: const Offset(0.5, 0.5),
          flat: true,
          rotation: bearing,
          onTap: (){
            mapController.moveCamera(
                CameraUpdate.newCameraPosition(
                    CameraPosition(target: newPos,zoom: 15),
                ),
            );
          },
          draggable: false,
          icon:  carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bike"
              ?
          await getMarkerIcon("assets/images/marker/bikeMarker/bikeGreen.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bike"
              ?
          await getMarkerIcon("assets/images/marker/bikeMarker/bikeYellow.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bike"
              ?
          await getMarkerIcon("assets/images/marker/bikeMarker/bikeBlue.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bike"
              ?
          await getMarkerIcon("assets/images/marker/bikeMarker/bikeOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bike"
              ?
          await getMarkerIcon("assets/images/marker/bikeMarker/bikeRed.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bike"
              ?
          await getMarkerIcon("assets/images/marker/bikeMarker/bikePurple.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "car"
              ?
          await getMarkerIcon("assets/images/marker/carMarker/carGreen.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "car"
              ?
          await getMarkerIcon("assets/images/marker/carMarker/carYello.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "car"
              ?
          await getMarkerIcon("assets/images/marker/carMarker/carBule.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "car"
              ?
          await getMarkerIcon("assets/images/marker/carMarker/carOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "car"
              ?
          await getMarkerIcon("assets/images/marker/carMarker/carRed.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "car"
              ?
          await getMarkerIcon("assets/images/marker/carMarker/carPurple.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "truck"
              ?
          await getMarkerIcon("assets/images/marker/longTruckMarker/longTruckGreen.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "truck"
              ?
          await getMarkerIcon("assets/images/marker/longTruckMarker/longTruckYellow.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "truck"
              ?
          await getMarkerIcon("assets/images/marker/longTruckMarker/longTruckBlue.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "truck"
              ?
          await getMarkerIcon("assets/images/marker/longTruckMarker/longTruckOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "truck"
              ?
          await getMarkerIcon("assets/images/marker/longTruckMarker/longTruckRed.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "truck"
              ?
          await getMarkerIcon("assets/images/marker/longTruckMarker/longTruckPurple.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bus"
              ?
          await getMarkerIcon("assets/images/marker/busMarker/busGreen.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bus"
              ?
          await getMarkerIcon("assets/images/marker/busMarker/busYello.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bus"
              ?
          await getMarkerIcon("assets/images/marker/busMarker/busBlue.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bus"
              ?
          await getMarkerIcon("assets/images/marker/busMarker/busOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bus"
              ?
          await getMarkerIcon("assets/images/marker/busMarker/busPink.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bus"
              ?
          await getMarkerIcon("assets/images/marker/busMarker/busPurple.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "jcb"
              ?
          await getMarkerIcon("assets/images/marker/jcbMarker/jcbGreen.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "jcb"
              ?
          await getMarkerIcon("assets/images/marker/jcbMarker/jcbYellow.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "jcb"
              ?
          await getMarkerIcon("assets/images/marker/jcbMarker/jcbBlue.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "jcb"
              ?
          await getMarkerIcon("assets/images/marker/jcbMarker/jcbOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "jcb"
              ?
          await getMarkerIcon("assets/images/marker/jcbMarker/jcbRed.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "jcb"
              ?
          await getMarkerIcon("assets/images/marker/jcbMarker/jcbPurple.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "tracktor"
              ?
          await getMarkerIcon("assets/images/marker/tractorMarker/tractorGreen.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "tracktor"
              ?
          await getMarkerIcon("assets/images/marker/tractorMarker/tractorYellow.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "tracktor"
              ?
          await getMarkerIcon("assets/images/marker/tractorMarker/tractorBlue.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "tracktor"
              ?
          await getMarkerIcon("assets/images/marker/tractorMarker/tractorOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "tracktor"
              ?
          await getMarkerIcon("assets/images/marker/tractorMarker/tractorOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "tracktor"
              ?
          await getMarkerIcon("assets/images/marker/tractorMarker/tractorPurple.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pickup"
              ?
          await getMarkerIcon("assets/images/marker/smallTruckMarker/smallTruckGreen.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pickup"
              ?
          await getMarkerIcon("assets/images/marker/smallTruckMarker/smallTruckYellow.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pickup"
              ?
          await getMarkerIcon("assets/images/marker/smallTruckMarker/smallTruckBlue.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pickup"
              ?
          await getMarkerIcon("assets/images/marker/smallTruckMarker/smallTruckOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pickup"
              ?
          await getMarkerIcon("assets/images/marker/smallTruckMarker/smallTruckRed.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pickup"
              ?
          await getMarkerIcon("assets/images/marker/smallTruckMarker/smallTruckPurple.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "scooter"
              ?
          await getMarkerIcon("assets/images/marker/scootyMarker/scootyGreen.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "scooter"
              ?
          await getMarkerIcon("assets/images/marker/scootyMarker/sccotyYellow.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "scooter"
              ?
          await getMarkerIcon("assets/images/marker/scootyMarker/sccotyBlue.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "scooter"
              ?
          await getMarkerIcon("assets/images/marker/scootyMarker/sccotyOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "scooter"
              ?
          await getMarkerIcon("assets/images/marker/scootyMarker/sccotyRed.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "scooter"
              ?
          await getMarkerIcon("assets/images/marker/scootyMarker/scootyPurple.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pet"
              ?
          await getMarkerIcon("assets/images/marker/petMarker/petGreen.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pet"
              ?
          await getMarkerIcon("assets/images/marker/petMarker/petYellow.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pet"
              ?
          await getMarkerIcon("assets/images/marker/petMarker/petBlue.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pet"
              ?
          await getMarkerIcon("assets/images/marker/petMarker/petOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pet"
              ?
          await getMarkerIcon("assets/images/marker/petMarker/petRed.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pet"
              ?
          await getMarkerIcon("assets/images/marker/petMarker/petPurple.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "user"
              ?
          await getMarkerIcon("assets/images/marker/userMarker/userGreen.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "user"
              ?
          await getMarkerIcon("assets/images/marker/userMarker/userYellow.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "user"
              ?
          await getMarkerIcon("assets/images/marker/userMarker/userBlue.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "user"
              ?
          await getMarkerIcon("assets/images/marker/userMarker/userOrange.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "user"
              ?
          await getMarkerIcon("assets/images/marker/userMarker/userRed.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "user"
              ?
          await getMarkerIcon("assets/images/marker/userMarker/userPurple.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}")
              :
          await getMarkerIcon("assets/images/location.png", Size(100.0, 110.0),"${vehicleListProvider.vehicleList[i].deviceName}"),

        );


        //Adding new marker to our list and updating the google map UI.
        carMarker[i] = carMarkers;
       // MarkerUpdates.from(Set<Marker>.of(carMarker), Set<Marker>.of(carMarker));

        mapMarkerSink.add(carMarker);

        //Moving the google camera to the new animated location.

      });*/

    if (i != null) {
      _animation = tween.animate(animationControllerList[i])
        ..addListener(() async {
          //We are calculating new latitude and logitude for our marker
          final v = _animation.value;
          double lng = v * toLong + (1 - v) * fromLong;
          double lat = v * toLat + (1 - v) * fromLat;
          LatLng newPos = LatLng(lat, lng);


          //carMarker.removeWhere((element) => element.markerId.value == vehicleListProvider.vehicleList[i].deviceId);

          if (carMarker.contains(vehicleListProvider.vehicleList[i].deviceId)) {
            carMarker.remove(vehicleListProvider.vehicleList[i].deviceId);
            carMarker.clear();
          }


          //New marker location
          carMarkers = Marker(
            markerId: MarkerId(
                "${vehicleListProvider.vehicleList[i].deviceId}"),
            position: newPos,
            anchor: const Offset(0.5, 0.5),
            flat: true,
            rotation: bearing,
            onTap: () {
              mapController.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: newPos, zoom: 15),
                ),
              );
            },
            draggable: false,
            icon: carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "bike"
                ?
            await getMarkerIcon("assets/images/marker/bikeMarker/bikeGreen.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "bike"
                ?
            await getMarkerIcon(
                "assets/images/marker/bikeMarker/bikeYellow.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "bike"
                ?
            await getMarkerIcon("assets/images/marker/bikeMarker/bikeBlue.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "bike"
                ?
            await getMarkerIcon(
                "assets/images/marker/bikeMarker/bikeOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" &&
                carData[i]["value"].iconType == "bike"
                ?
            await getMarkerIcon("assets/images/marker/bikeMarker/bikeRed.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" &&
                carData[i]["value"].iconType == "bike"
                ?
            await getMarkerIcon(
                "assets/images/marker/bikeMarker/bikePurple.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "car"
                ?
            await getMarkerIcon("assets/images/marker/carMarker/carGreen.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "car"
                ?
            await getMarkerIcon("assets/images/marker/carMarker/carYello.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "car"
                ?
            await getMarkerIcon("assets/images/marker/carMarker/carBule.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "car"
                ?
            await getMarkerIcon("assets/images/marker/carMarker/carOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" &&
                carData[i]["value"].iconType == "car"
                ?
            await getMarkerIcon(
                "assets/images/marker/carMarker/carRed.png", Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" &&
                carData[i]["value"].iconType == "car"
                ?
            await getMarkerIcon("assets/images/marker/carMarker/carPurple.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :


            /* carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "auto"
                ?
            await getMarkerIcon("assets/images/marker/rickshawMarker/ricshowGreen.png",
                Size(130.0, 140.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "auto"
                ?
            await getMarkerIcon("assets/images/marker/rickshawMarker/ricshowYellow.png",
                Size(130.0, 140.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "auto"
                ?
            await getMarkerIcon("assets/images/marker/rickshawMarker/ricshowBlue.png",
                Size(130.0, 140.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "auto"
                ?
            await getMarkerIcon("assets/images/marker/rickshawMarker/ricshowOrange.png",
                Size(130.0, 140.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" &&
                carData[i]["value"].iconType == "auto"
                ?
            await getMarkerIcon(
                "assets/images/marker/rickshawMarker/ricshowRed.png", Size(130.0, 140.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" &&
                carData[i]["value"].iconType == "auto"
                ?
            await getMarkerIcon("assets/images/marker/rickshawMarker/ricshowPurple.png",
                Size(130.0, 140.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")







*/

            carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "truck"
                ?
            await getMarkerIcon(
                "assets/images/marker/longTruckMarker/longTruckGreen.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "truck"
                ?
            await getMarkerIcon(
                "assets/images/marker/longTruckMarker/longTruckYellow.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "truck"
                ?
            await getMarkerIcon(
                "assets/images/marker/longTruckMarker/longTruckBlue.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "truck"
                ?
            await getMarkerIcon(
                "assets/images/marker/longTruckMarker/longTruckOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" &&
                carData[i]["value"].iconType == "truck"
                ?
            await getMarkerIcon(
                "assets/images/marker/longTruckMarker/longTruckRed.png",
                Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                .deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" &&
                carData[i]["value"].iconType == "truck"
                ?
            await getMarkerIcon(
                "assets/images/marker/longTruckMarker/longTruckPurple.png",
                Size(100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                .deviceName}")
                :
            carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "bus"
                ?
            await getMarkerIcon(
                "assets/images/marker/busMarker/busGreen.png", Size(100.0,
                110.0), "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "bus"
                ?
            await getMarkerIcon(
                "assets/images/marker/busMarker/busYello.png", Size(
                100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                .deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "bus"
                ?
            await getMarkerIcon(
                "assets/images/marker/busMarker/busBlue.png", Size(
                100.0, 110.0), "${vehicleListProvider.vehicleList[i]
                .deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "bus"
                ?
            await getMarkerIcon("assets/images/marker/busMarker/busOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" && carData[i]["value"]
                .iconType == "bus"
                ?
            await getMarkerIcon("assets/images/marker/busMarker/busPink.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"]
                .iconType == "bus"
                ?
            await getMarkerIcon("assets/images/marker/busMarker/busPurple.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "jcb"
                ?
            await getMarkerIcon("assets/images/marker/jcbMarker/jcbGreen.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "jcb"
                ?
            await getMarkerIcon("assets/images/marker/jcbMarker/jcbYellow.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "jcb"
                ?
            await getMarkerIcon("assets/images/marker/jcbMarker/jcbBlue.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "jcb"
                ?
            await getMarkerIcon("assets/images/marker/jcbMarker/jcbOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" &&
                carData[i]["value"].iconType == "jcb"
                ?
            await getMarkerIcon(
                "assets/images/marker/jcbMarker/jcbRed.png", Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" &&
                carData[i]["value"].iconType == "jcb"
                ?
            await getMarkerIcon("assets/images/marker/jcbMarker/jcbPurple.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "tracktor"
                ?
            await getMarkerIcon(
                "assets/images/marker/tractorMarker/tractorGreen.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "tracktor"
                ?
            await getMarkerIcon(
                "assets/images/marker/tractorMarker/tractorYellow.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "tracktor"
                ?
            await getMarkerIcon(
                "assets/images/marker/tractorMarker/tractorBlue.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "tracktor"
                ?
            await getMarkerIcon(
                "assets/images/marker/tractorMarker/tractorOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" &&
                carData[i]["value"].iconType == "tracktor"
                ?
            await getMarkerIcon(
                "assets/images/marker/tractorMarker/tractorOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" &&
                carData[i]["value"].iconType == "tracktor"
                ?
            await getMarkerIcon(
                "assets/images/marker/tractorMarker/tractorPurple.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "pickup"
                ?
            await getMarkerIcon(
                "assets/images/marker/smallTruckMarker/smallTruckGreen.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "pickup"
                ?
            await getMarkerIcon(
                "assets/images/marker/smallTruckMarker/smallTruckYellow.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "pickup"
                ?
            await getMarkerIcon(
                "assets/images/marker/smallTruckMarker/smallTruckBlue.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "pickup"
                ?
            await getMarkerIcon(
                "assets/images/marker/smallTruckMarker/smallTruckOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" &&
                carData[i]["value"].iconType == "pickup"
                ?
            await getMarkerIcon(
                "assets/images/marker/smallTruckMarker/smallTruckRed.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" &&
                carData[i]["value"].iconType == "pickup"
                ?
            await getMarkerIcon(
                "assets/images/marker/smallTruckMarker/smallTruckPurple.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "scooter"
                ?
            await getMarkerIcon(
                "assets/images/marker/scootyMarker/scootyGreen.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "scooter"
                ?
            await getMarkerIcon(
                "assets/images/marker/scootyMarker/sccotyYellow.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "scooter"
                ?
            await getMarkerIcon(
                "assets/images/marker/scootyMarker/sccotyBlue.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "scooter"
                ?
            await getMarkerIcon(
                "assets/images/marker/scootyMarker/sccotyOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" &&
                carData[i]["value"].iconType == "scooter"
                ?
            await getMarkerIcon(
                "assets/images/marker/scootyMarker/sccotyRed.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" &&
                carData[i]["value"].iconType == "scooter"
                ?
            await getMarkerIcon(
                "assets/images/marker/scootyMarker/scootyPurple.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "pet"
                ?
            await getMarkerIcon("assets/images/marker/petMarker/petGreen.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "pet"
                ?
            await getMarkerIcon("assets/images/marker/petMarker/petYellow.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "pet"
                ?
            await getMarkerIcon("assets/images/marker/petMarker/petBlue.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "pet"
                ?
            await getMarkerIcon("assets/images/marker/petMarker/petOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" &&
                carData[i]["value"].iconType == "pet"
                ?
            await getMarkerIcon(
                "assets/images/marker/petMarker/petRed.png", Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" &&
                carData[i]["value"].iconType == "pet"
                ?
            await getMarkerIcon("assets/images/marker/petMarker/petPurple.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "RUNNING" &&
                carData[i]["value"].iconType == "user"
                ?
            await getMarkerIcon("assets/images/marker/userMarker/userGreen.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "IDLING" &&
                carData[i]["value"].iconType == "user"
                ?
            await getMarkerIcon(
                "assets/images/marker/userMarker/userYellow.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "OUT OF REACH" &&
                carData[i]["value"].iconType == "user"
                ?
            await getMarkerIcon("assets/images/marker/userMarker/userBlue.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "Expired" &&
                carData[i]["value"].iconType == "user"
                ?
            await getMarkerIcon(
                "assets/images/marker/userMarker/userOrange.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "STOPPED" &&
                carData[i]["value"].iconType == "user"
                ?
            await getMarkerIcon("assets/images/marker/userMarker/userRed.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            carData[i]["value"].status == "NO GPS FIX" &&
                carData[i]["value"].iconType == "user"
                ?
            await getMarkerIcon(
                "assets/images/marker/userMarker/userPurple.png",
                Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}")
                :
            await getMarkerIcon(
                "assets/images/location.png", Size(100.0, 110.0),
                "${vehicleListProvider.vehicleList[i].deviceName}"),

          );


          //Adding new marker to our list and updating the google map UI.
          carMarker[i] = carMarkers;
          // MarkerUpdates.from(Set<Marker>.of(carMarker), Set<Marker>.of(carMarker));

          //mapMarkerSink.add(carMarker);

          //Moving the google camera to the new animated location.

        });
    }
    //Starting the animation
    animationControllerList[i].forward();
    // animationController.forward();
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return degrees(atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - degrees(atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return degrees(atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - degrees(atan(lng / lat))) + 270;
    }
    return -1;
  }


  List<Polygon> mainPloyList = [];

  getAllGeofence() async {
    Helper.dialogCall.showAlertDialog(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
    };
    print(data);
    await geofenceProvider.getAllGeofence(
        data, "geofencingV2/getallgeofence", "live", context);
    if (geofenceProvider.geoSuccess) {
      for (int i = 0; i < geofenceProvider.getAllGeofenceList.length; i++) {
        if (geofenceProvider.latLng.isNotEmpty) {
          mainPloyList.add(
              Polygon(
                  polygonId: PolygonId('polygon$i'),
                  points: geofenceProvider.latLng[i],
                  strokeWidth: 2,
                  strokeColor: Color(0xffF84A67),
                  fillColor: Color(0xffF84A67).withOpacity(0.15)
              )
          );
          print("mainPloyList => $mainPloyList");
        }
      }
    }

    Navigator.pop(context);
  }

  getPoiList() async {
    Helper.dialogCall.showAlertDialog(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "user": id,
    };

    await geofenceProvider.getPoiList(data, "poiV2/getPois", "geo");

    if (geofenceProvider.isSuccess) {
      for (int i = 0; i < geofenceProvider.getPoiDetailsList.length; i++) {
        if (carMarker.contains("poi$i")) {
          carMarker.remove("poi$i");
        } else {
          carMarker.add(
              Marker(
                  markerId: MarkerId("poi$i"),
                  icon: BitmapDescriptor.fromBytes(poiPoints),
                  position: LatLng(
                    geofenceProvider.getPoiDetailsList[i].poi.location
                        .coordinates[0],
                    geofenceProvider.getPoiDetailsList[i].poi.location
                        .coordinates[1],
                  ),
                  infoWindow: InfoWindow(
                      title: "${geofenceProvider.getPoiDetailsList[i].poi
                          .poiname}"
                  )
              )
          );
          setState(() {
            _mapMarkerSC.add(carMarker);
          });
        }
      }
    }
    Navigator.pop(context);
  }

  UserProvider userProvider;
  SharedPreferences sharedPreferences;

  getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
    };

    await userProvider.getUserData(data, "users/getCustumerDetail", context);
  }

  void initState() {
    latLgnList.clear();
    WidgetsBinding.instance.addObserver(this);

    vehicleListProvider =
        Provider.of<VehicleListProvider>(context, listen: false);
    geofenceProvider = Provider.of<GeofencesProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);

    geofenceProvider.poliyList.clear();
    vehicleListProvider.vehicleList.clear();
    vehicleListProvider.addressList.clear();
    //
    Future.delayed(Duration.zero, () {
      vehicleListProvider.changeBool(false);
      getUserData();
      getVehicleList();
    });
  }

  /* LatLngBounds _bounds(List<Marker> markers) {
    if (markers == null || markers.isEmpty) return null;
    return _createBounds(markers.map((m) => m.position).toList());
  }*/

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce((value,
        element) => value < element ? value : element); // smallest
    final southwestLon = positions.map((p) => p.longitude).reduce((value,
        element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce((value,
        element) => value > element ? value : element); // biggest
    final northeastLon = positions.map((p) => p.longitude).reduce((value,
        element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon)
    );
  }

  @override
  void dispose() {
    if (socket != null) {
      socket.dispose();
    }
    if (animationControllerList.isNotEmpty) {
      for (int i = 0; i < animationControllerList.length; i++) {
        animationControllerList[i].stop();
        animationControllerList[i].dispose();
      }
    }

    super.dispose();
  }

/*
  @override
  void didChangeAppLifecycleState(ui.AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached)return;

    final isBackground = state == AppLifecycleState.paused;

    if(isBackground){
      print("app in background");
      */ /*socket.dispose();
      timer.cancel();
      animationController.dispose();*/ /*
    }else{
     print("app in foreground");
      */ /*  connectSocketIo();*/ /*
    }

  }*/
  String vehicles = "";

  @override
  Widget build(BuildContext context) {
    vehicleListProvider =
        Provider.of<VehicleListProvider>(context, listen: true);
    geofenceProvider = Provider.of<GeofencesProvider>(context, listen: true);
    userProvider = Provider.of<UserProvider>(context, listen: true);

    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;


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
          getTranslated(context, "LIVE TRACKING"),
          overflow: TextOverflow.visible,
          maxLines: 2,
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
                Color(0xffb751c1e),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: height,
            child: StreamBuilder<List<Marker>>(
                stream: mapMarkerStream,
                builder: (context, snapshot) {
                  if (vehicleListProvider.isCommentLoading ||
                      userProvider.isLoading) {
                    return Helper.dialogCall.showLoader();
                  } else {
                    return GoogleMap(
                      zoomControlsEnabled: false,

                      // cameraTargetBounds: snapshot.data == null
                      //     ? CameraTargetBounds.unbounded
                      //     : CameraTargetBounds(_bounds(snapshot.data),
                      // ),
                      //
                      // // initialCameraPosition: CameraPosition( //innital position in map
                      // //   target: LatLng(20.5937, 78.9629), //initial position
                      // //   zoom: 7.0, //initial zoom level
                      // // ),

                      initialCameraPosition: CameraPosition( //innital position in map
                        target:
                        LatLng(
                            20.5937, 78.9629), //initial position
                        zoom: 4, //initial zoom level
                      ),
                      // minMaxZoomPreference: MinMaxZoomPreference(10, 15),
                      mapType: isChangeMap ? mapType : Utils.mapType,
                      markers: Set<Marker>.of(snapshot.data ?? []),
                      polygons: Set<Polygon>.of(mainPloyList),
                      onMapCreated: (GoogleMapController controller) {
                        setState(() {
                          mapController = controller;
                          // mapController2.complete(controller);
                          print("hhhh");
                          // print(controller.mapId);
                          mapController.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                  _createBounds(latLgnBoundList), 10));
                        });
                      },
                    );
                  }
                }
            ),
          ),

          Positioned(
            child: InkWell(
              onTap: () async {
                var value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveVehicleFilter(),),
                );
                print("VVVVVV : $value");
                if (value != null) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //     // LiveTrackingScreenCopy(),
                  //     LiveForVehicleScreen(
                  //
                  //     ),
                  //   ),
                  // );
                  // setState(() {
                  //   deviceImeiList.clear();
                  // });
                  //
                  // setState(() {
                  //   deviceImeiList.addAll(value);
                  // });
                  //
                  // if (socket != null) {
                  //   socket.dispose();
                  // }
                  //
                  // for (int i = 0; i < animationControllerList.length; i++) {
                  //   if (animationControllerList[i].isCompleted ||
                  //       animationControllerList[i].isAnimating == false) {}
                  //   else {
                  //     animationControllerList[i].stop();
                  //     animationControllerList[i].dispose();
                  //   }
                  // }
                  // getVehicleList();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: ApplicationColors.whiteColor,
                height: height * .06,
                width: width,
                child: Row(
                  children: [
                    Text(
                      "${getTranslated(context, "select vehicles")}",
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.normal,
                        color: Appcolors.text_grey,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${vehicles ?? ""}",
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.normal,
                        color: Appcolors.text_grey,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down_sharp),
                  ],
                ),
              ),
            ),
          ),
          // map icon
          Positioned(
            top: height * .1,
            left: width * .05,
            child: InkWell(
              onTap: () async {
                setState(() {
                  isChangeMap = true;
                  if (mapType == MapType.normal) {
                    mapType = MapType.satellite;
                  }
                  else if (mapType == MapType.satellite) {
                    mapType = MapType.terrain;
                  }
                  else if (mapType == MapType.terrain) {
                    mapType = MapType.hybrid;
                  }
                  else if (mapType == MapType.hybrid) {
                    mapType = MapType.normal;
                  }
                });
              },
              child: Container(
                width: width * .12,
                height: height * .12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ApplicationColors.blackColor2E,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/maap_icon_for_live_screen.png',
                    color: Color(0xfff70b3c),
                    width: width * .05,
                    height: height * .025,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),


          // polygon
          // Positioned(
          //     top: height * .13, right: width * .05,
          //     child: InkWell(
          //       onTap: () async {
          //         print("polygon");
          //         getAllGeofence();
          //       },
          //       child: Container(
          //         width: width * .12,
          //         height: height * .12,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Color(0xfff70b3c),
          //         ),
          //         child: Center(
          //           child: Image.asset(
          //             'assets/images/poi_ic.png',
          //             color: ApplicationColors.whiteColor,
          //             width: width * .05,
          //             height: height * .025,
          //             fit: BoxFit.fill,
          //           ),
          //         ),
          //       ),
          //     )
          // ),

          // poi
          Positioned(
              top: height * .19, right: width * .05,
              child: InkWell(
                onTap: () async {
                  getPoiList();
                },
                child: Container(
                  width: width * .12,
                  height: height * .12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xfff70b3c),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/Ellipse 9.png',
                      color: ApplicationColors.whiteColor,
                      width: 18,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
          ),
          // zooIn ZoomOut button
          Positioned(
              bottom: 80,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        mapController.animateCamera(CameraUpdate.zoomIn());
                      },
                      child: Container(
                        width: width * .09,
                        height: height * .04,
                        padding: EdgeInsets.all(10),
                        child: Image.asset("assets/images/add_ic.png",
                          color: ApplicationColors.redColor67,),
                        decoration: BoxDecoration(
                          color: ApplicationColors.blackColor2E,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    InkWell(
                      onTap: () {
                        mapController.animateCamera(CameraUpdate.zoomOut());
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 1),
                        width: width * .09,
                        height: height * .04,
                        padding: EdgeInsets.all(10),
                        child: Image.asset("assets/images/minimise_ic.png",
                          color: ApplicationColors.redColor67,),
                        decoration: BoxDecoration(
                          color: ApplicationColors.blackColor2E,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
