import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/socket_model.dart';
import 'package:oneqlik/Model/vehicle_list_model.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/Provider/vehicle_list_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/GeofencesPage/Geofeces.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/history.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/history_new.dart';
import 'package:oneqlik/screens/DashBoardScreen/LiveForVehicleScreen/live_for_vehicle_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_info/parking_schedular.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_info/tow_schedular.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math.dart';

import 'analytics.dart';
import 'device_settings.dart';
import 'documents.dart';
import 'immobilize.dart';

class VehicleInfoPage extends StatefulWidget {
  final vName, vId,vDeviceId;
  VehicleLisDevice vehicleLisDevice;
  VehicleInfoPage({Key key, this.vName, this.vId, this.vDeviceId,this.vehicleLisDevice}) : super(key: key);

  @override
  _VehicleInfoPageState createState() => _VehicleInfoPageState();
}

class _VehicleInfoPageState extends State<VehicleInfoPage>  with TickerProviderStateMixin{


  List vehicleInfoCategoriesIcon = [
    "assets/images/LIve_icon.png",
    "assets/images/History_icon.png",
    "assets/images/parking_icon.png",
    "assets/images/immobilize.png",
    "assets/images/Driver_call_icon.png",
    "assets/images/analytics_icon.png",
    "assets/images/Tow_icon.png",
    "assets/images/setting_icon_11.png",
    "assets/images/Geofence.png",
    "assets/images/document_icon.png"
  ];

  GoogleMapController mapController;

  bool selectedGeofances = true;

  UserProvider _userProvider;
  VehicleListProvider vehicleListProvider;

  TextEditingController textEditingController = TextEditingController();
 int totalHours;
 int totalMinutes;

  IO.Socket socket;

  var data ;
  bool isLoading = true,loadMarker = false;
  SocketModelClass socketModelClass;
  var address = "Address not found";

  Uint8List carMarker;

  Uint8List busRed,busBlue,busGreen,busOrange,busYellow,busGrey;
  Uint8List carRed,carBlue,carGreen,carOrange,carYellow,carGrey;
  Uint8List scooterRed,scooterBlue,scooterGreen,scooterOrange,scooterYellow,scooterGrey;
  Uint8List bikeRed,bikeBlue,bikeGreen,bikeOrange,bikeYellow,bikeGrey;
  Uint8List carSuvBlue,carSuvRed,carSuvGreen,carSuvOrange,carSuvYellow,carSuvGrey;
  Uint8List craneBlue,craneRed,craneGreen,craneOrange,craneYellow,craneGrey;
  Uint8List userBlue,userRed,userGreen,userOrange,userYellow,userGrey;
  Uint8List petBlue,petRed,petGreen,petOrange,petYellow,petGrey;
  Uint8List jcbBlue,jcbRed,jcbGreen,jcbOrange,jcbYellow,jcbGrey;
  Uint8List tractorBlue,tractorRed,tractorGreen,tractorOrange,tractorYellow,tractorGrey;
  Uint8List longTruckBlue,longTruckRed,longTruckGreen,longTruckOrange,longTruckYellow,longTruckGrey;
  Uint8List smallTruckBlue,smallTruckRed,smallTruckGreen,smallTruckOrange,smallTruckYellow,smallTruckGrey;
  Uint8List generatorBlue,generatorRed,generatorGreen,generatorOrange,generatorYellow,generatorGrey;
  Uint8List rickshawBlue,rickshawRed,rickshawGreen,rickshawOrange,rickshawYellow,rickshawGrey;
  Uint8List ambulanceBlue,ambulanceRed,ambulanceGreen,ambulanceOrange,ambulanceYellow,ambulanceGrey;
  Uint8List boatBlue,boatRed,boatGreen,boatOrange,boatYellow,boatGrey;
  Uint8List locationIcon;

  createMarker() async {

    setState(() {
      loadMarker = true;
    });

    busRed = await  getBytesFromAsset('assets/images/marker/busMarker/busPink.png',);
    busBlue = await  getBytesFromAsset('assets/images/marker/busMarker/busBlue.png',);
    busGreen = await  getBytesFromAsset('assets/images/marker/busMarker/busGreen.png',);
    busOrange = await  getBytesFromAsset('assets/images/marker/busMarker/busOrange.png',);
    busYellow = await  getBytesFromAsset('assets/images/marker/busMarker/busYello.png',);
    busGrey = await  getBytesFromAsset('assets/images/marker/busMarker/busGrey.png',);


    carBlue = await  getBytesFromAsset('assets/images/marker/carMarker/carBule.png',);
    carGreen = await  getBytesFromAsset('assets/images/marker/carMarker/carGreen.png',);
    carOrange = await  getBytesFromAsset('assets/images/marker/carMarker/carOrange.png',);
    carGrey = await  getBytesFromAsset('assets/images/marker/carMarker/carGrey.png',);
    carRed = await  getBytesFromAsset('assets/images/marker/carMarker/carRed.png',);
    carYellow = await  getBytesFromAsset('assets/images/marker/carMarker/carYello.png',);


    scooterBlue = await  getBytesFromAsset('assets/images/marker/scootyMarker/sccotyBlue.png',);
    scooterOrange = await  getBytesFromAsset('assets/images/marker/scootyMarker/sccotyOrange.png',);
    scooterRed = await  getBytesFromAsset('assets/images/marker/scootyMarker/sccotyRed.png',);
    scooterYellow = await  getBytesFromAsset('assets/images/marker/scootyMarker/sccotyYellow.png',);
    scooterGreen = await  getBytesFromAsset('assets/images/marker/scootyMarker/scootyGreen.png',);
    scooterGrey = await  getBytesFromAsset('assets/images/marker/scootyMarker/scootyGrey.png',);


    bikeBlue = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeBlue.png',);
    bikeGreen = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeGreen.png',);
    bikeOrange = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeOrange.png',);
    bikeRed = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeRed.png',);
    bikeYellow = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeYellow.png',);
    bikeGrey = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeGrey.png',);


    carSuvBlue = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvBlue.png',);
    carSuvGreen = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvGreen.png',);
    carSuvOrange = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvOrange.png',);
    carSuvGrey = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvGrey.png',);
    carSuvRed = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvRed.png',);
    carSuvYellow = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvYellow.png',);


    craneBlue = await  getBytesFromAsset('assets/images/marker/craneMarker/craneBlue.png',);
    craneGreen = await  getBytesFromAsset('assets/images/marker/craneMarker/craneGreen.png',);
    craneOrange = await  getBytesFromAsset('assets/images/marker/craneMarker/craneOrange.png',);
    craneGrey = await  getBytesFromAsset('assets/images/marker/craneMarker/craneGrey.png',);
    craneRed = await  getBytesFromAsset('assets/images/marker/craneMarker/craneRed.png',);
    craneYellow = await  getBytesFromAsset('assets/images/marker/craneMarker/craneYellow.png',);


    userBlue = await  getBytesFromAsset('assets/images/marker/userMarker/userBlue.png',);
    userGreen = await  getBytesFromAsset('assets/images/marker/userMarker/userGreen.png',);
    userOrange = await  getBytesFromAsset('assets/images/marker/userMarker/userOrange.png',);
    userGrey = await  getBytesFromAsset('assets/images/vehicle/userIcons/user_nodata_ic.png',);
    userRed = await  getBytesFromAsset('assets/images/marker/userMarker/userRed.png',);
    userYellow = await  getBytesFromAsset('assets/images/marker/userMarker/userYellow.png',);


    petBlue = await  getBytesFromAsset('assets/images/marker/petMarker/petBlue.png',);
    petGreen = await  getBytesFromAsset('assets/images/marker/petMarker/petGreen.png',);
    petOrange = await  getBytesFromAsset('assets/images/marker/petMarker/petOrange.png',);
    petGrey = await  getBytesFromAsset('assets/images/vehicle/petIcons/pet_nodata_ic.png',);
    petRed = await  getBytesFromAsset('assets/images/marker/petMarker/petRed.png',);
    petYellow = await  getBytesFromAsset('assets/images/marker/petMarker/petYellow.png',);


    jcbBlue = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbBlue.png',);
    jcbGreen = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbGreen.png',);
    jcbOrange = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbOrange.png',);
    jcbGrey = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbGrey.png',);
    jcbRed = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbRed.png',);
    jcbYellow = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbYellow.png',);


    tractorBlue = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorBlue.png',);
    tractorGreen = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorGreen.png',);
    tractorOrange = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorOrange.png',);
    tractorGrey = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorGrey.png',);
    tractorRed = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorRed.png',);
    tractorYellow = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorYellow.png',);


    longTruckBlue = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckBlue.png',);
    longTruckGreen = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckGreen.png',);
    longTruckOrange = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckOrange.png',);
    longTruckGrey = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckGrey.png',);
    longTruckRed = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckRed.png',);
    longTruckYellow = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckYellow.png',);


    smallTruckBlue = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckBlue.png',);
    smallTruckGreen = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckGreen.png',);
    smallTruckOrange = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckOrange.png',);
    smallTruckGrey = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckGrey.png',);
    smallTruckRed = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckRed.png',);
    smallTruckYellow = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckYellow.png',);

    generatorBlue = await  getBytesFromAsset('assets/images/marker/generatorMarker/genratorBlue.png',);
    generatorGreen = await  getBytesFromAsset('assets/images/marker/generatorMarker/genratorGreen.png',);
    generatorOrange = await  getBytesFromAsset('assets/images/marker/generatorMarker/genratorOrange.png',);
    generatorGrey = await  getBytesFromAsset('assets/images/marker/generatorMarker/genratorGrey.png',);
    generatorRed = await  getBytesFromAsset('assets/images/marker/generatorMarker/genratorRed.png',);
    generatorYellow = await  getBytesFromAsset('assets/images/marker/generatorMarker/genratorYellow.png',);

    rickshawBlue = await  getBytesFromAsset('assets/images/marker/rickshawMarker/ricshowBlue.png',);
    rickshawGreen = await  getBytesFromAsset('assets/images/marker/rickshawMarker/ricshowGreen.png',);
    rickshawOrange = await  getBytesFromAsset('assets/images/marker/rickshawMarker/ricshowOrange.png',);
    rickshawGrey = await  getBytesFromAsset('assets/images/marker/rickshawMarker/ricshowGrey.png',);
    rickshawRed = await  getBytesFromAsset('assets/images/marker/rickshawMarker/ricshowRed.png',);
    rickshawYellow = await  getBytesFromAsset('assets/images/marker/rickshawMarker/ricshowYellow.png',);

    ambulanceBlue = await  getBytesFromAsset('assets/images/marker/ambulanceMarker/ambulanceBlue.png',);
    ambulanceGreen = await  getBytesFromAsset('assets/images/marker/ambulanceMarker/ambulanceGreen.png',);
    ambulanceOrange = await  getBytesFromAsset('assets/images/marker/ambulanceMarker/ambulanceOrange.png',);
    ambulanceGrey = await  getBytesFromAsset('assets/images/marker/ambulanceMarker/ambulanceGrey.png',);
    ambulanceRed = await  getBytesFromAsset('assets/images/marker/ambulanceMarker/ambulanceRed.png',);
    ambulanceYellow = await  getBytesFromAsset('assets/images/marker/ambulanceMarker/ambulanceYellow.png',);

    boatBlue = await  getBytesFromAsset('assets/images/marker/boatMarker/boatBlue.png',);
    boatGreen = await  getBytesFromAsset('assets/images/marker/boatMarker/boatGreen.png',);
    boatOrange = await  getBytesFromAsset('assets/images/marker/boatMarker/boatOrange.png',);
    boatGrey = await  getBytesFromAsset('assets/images/marker/boatMarker/boatGrey.png',);
    boatRed = await  getBytesFromAsset('assets/images/marker/boatMarker/boatRed.png',);
    boatYellow = await  getBytesFromAsset('assets/images/marker/boatMarker/boatYellow.png',);

    locationIcon = await  getBytesFromAsset('assets/images/location.png',);

    addMarkers();

    setState(() {
      loadMarker = false;
    });

    connectSocketIo();

  }

  Future<Uint8List> getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }
  bool firstBool = false;


  List<LatLng> listOfLatLog = [];

  connectSocketIo(){

    socket = IO.io('https://www.oneqlik.in/gps', <String, dynamic>{
      "secure": true,
      "rejectUnauthorized": false,
      "transports":["websocket", "polling"],
      "upgrade": false
    });
    socket.connect();

    socket.onConnect((data) {
      print("Socket is connected");

      socket.emit("acc","${widget.vDeviceId}");

      socket.on("${widget.vDeviceId}acc", (data) async {
        print("socket data ===> ${data[3]}");
        if(data[3] != null){

          var resonance = data[3];

          setState(() {
            socketModelClass =  SocketModelClass.fromJson(resonance);
          });

          print("IconType ${socketModelClass.iconType}");
          print("StatUs ${socketModelClass.status}");

        /*  lat = socketModelClass.lastLocation.lat;
          lng = socketModelClass.lastLocation.long;*/

          if(socketModelClass.lastLocation != null ){
            List<Placemark> placemarks = await placemarkFromCoordinates(socketModelClass.lastLocation.lat, socketModelClass.lastLocation.long);
            LatLng lng = LatLng(socketModelClass.lastLocation.lat, socketModelClass.lastLocation.long);

            // print("$data");
            setState(()  {

              if(firstBool){

                if(listOfLatLog.length == 2){
                  listOfLatLog.removeAt(0);
                  print("listoflatLon");
                  print(listOfLatLog);
                  if(listOfLatLog.last != lng){
                    listOfLatLog.add(lng);
                    startMarker();
                  }else{
                    print("getting same location");
                  }
                }else{
                  listOfLatLog.add(lng);
                }

                address = "${placemarks.first.name}"
                    " ${placemarks.first.subLocality}"
                    " ${placemarks.first.locality}"
                    " ${placemarks.first.subAdministrativeArea} "
                    "${placemarks.first.administrativeArea},"
                    "${placemarks.first.postalCode}";

              }else{
                if(widget.vehicleLisDevice.lastLocation == null){
                  mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(0, 0),
                        zoom: 14,
                      ),
                    ),
                  );
                }else{
                  mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                            widget.vehicleLisDevice.lastLocation.lat,
                            widget.vehicleLisDevice.lastLocation.long

                        ),
                        zoom: 14,
                      ),
                    ),
                  );
                }
              }

              isLoading = false;
            });
          }


        }
      });
    });
  }

  final List<Marker> _markers = <Marker>[];
  Animation<double> _animation;
  final _mapMarkerSC = StreamController<List<Marker>>();
  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;
  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;

  startMarker(){
    int i  = 0;

    print("car location here");

    print( listOfLatLog[i].latitude);
    print (listOfLatLog[i].longitude);
    print(listOfLatLog[i + 1].latitude);
    print( listOfLatLog[i + 1].longitude);

    animateCar(
      listOfLatLog[i].latitude,
      listOfLatLog[i].longitude,
      listOfLatLog[i + 1].latitude,
      listOfLatLog[i + 1].longitude,
      _mapMarkerSink,
      this,
      mapController,
    );
  }

  AnimationController animationController;
  animateCar(
      double fromLat, //Starting latitude
      double fromLong, //Starting longitude
      double toLat, //Ending latitude
      double toLong, //Ending longitude
      StreamSink<List<Marker>>
      mapMarkerSink, //Stream build of map to update the UI
      TickerProvider
      provider, //Ticker provider of the widget. This is used for animation
      GoogleMapController controller, //Google map controller of our widget
      ) async {
    final double bearing =
    getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));

    _markers.clear();

    // var carMarkers = Marker(
    //   markerId: const MarkerId("driverMarker"),
    //   position: LatLng(fromLat, fromLong),
    //   anchor: const Offset(0.5, 0.5),
    //   flat: true,
    //   rotation: bearing,
    //   draggable: false,
    //   icon:BitmapDescriptor.fromBytes(
    //       socketModelClass.status == "RUNNING" && socketModelClass.iconType == "bike"
    //           ?
    //       bikeGreen
    //           :
    //       socketModelClass.status == "IDLING" && socketModelClass.iconType == "bike"
    //           ?
    //       bikeYellow
    //           :
    //       socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "bike"
    //           ?
    //       bikeBlue
    //           :
    //       socketModelClass.status == "Expired" && socketModelClass.iconType == "bike"
    //           ?
    //       bikeOrange
    //           :
    //       socketModelClass.status == "STOPPED" && socketModelClass.iconType == "bike"
    //           ?
    //       bikeRed
    //           :
    //       socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "bike"
    //           ?
    //       bikeGrey
    //           :
    //       socketModelClass.status == "RUNNING" && socketModelClass.iconType == "car"
    //           ?
    //       carGreen
    //           :
    //       socketModelClass.status == "IDLING" && socketModelClass.iconType == "car"
    //           ?
    //       carYellow
    //           :
    //       socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "car"
    //           ?
    //       carBlue
    //           :
    //       socketModelClass.status == "Expired" && socketModelClass.iconType == "car"
    //           ?
    //       carOrange
    //           :
    //       socketModelClass.status == "STOPPED" && socketModelClass.iconType == "car"
    //           ?
    //       carRed
    //           :
    //       socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "car"
    //           ?
    //       carGrey
    //           :
    //       socketModelClass.status == "RUNNING" && socketModelClass.iconType == "truck"
    //           ?
    //       longTruckGreen
    //           :
    //       socketModelClass.status == "IDLING" && socketModelClass.iconType == "truck"
    //           ?
    //       longTruckYellow
    //           :
    //       socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "truck"
    //           ?
    //       longTruckBlue
    //           :
    //       socketModelClass.status == "Expired" && socketModelClass.iconType == "truck"
    //           ?
    //       longTruckOrange
    //           :
    //       socketModelClass.status == "STOPPED" && socketModelClass.iconType == "truck"
    //           ?
    //       longTruckRed
    //           :
    //       socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "truck"
    //           ?
    //       longTruckGrey
    //           :
    //       socketModelClass.status == "RUNNING" && socketModelClass.iconType == "bus"
    //           ?
    //       busGreen
    //           :
    //       socketModelClass.status == "IDLING" && socketModelClass.iconType == "bus"
    //           ?
    //       busYellow
    //           :
    //       socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "bus"
    //           ?
    //       busBlue
    //           :
    //       socketModelClass.status == "Expired" && socketModelClass.iconType == "bus"
    //           ?
    //       busOrange
    //           :
    //       socketModelClass.status == "STOPPED" && socketModelClass.iconType == "bus"
    //           ?
    //       busRed
    //           :
    //       socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "bus"
    //           ?
    //       busGrey
    //           :
    //       socketModelClass.status == "RUNNING" && socketModelClass.iconType == "jcb"
    //           ?
    //       jcbGreen
    //           :
    //       socketModelClass.status == "IDLING" && socketModelClass.iconType == "jcb"
    //           ?
    //       jcbYellow
    //           :
    //       socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "jcb"
    //           ?
    //       jcbBlue
    //           :
    //       socketModelClass.status == "Expired" && socketModelClass.iconType == "jcb"
    //           ?
    //       jcbOrange
    //           :
    //       socketModelClass.status == "STOPPED" && socketModelClass.iconType == "jcb"
    //           ?
    //       jcbRed
    //           :
    //       socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "jcb"
    //           ?
    //       jcbGrey
    //           :
    //       socketModelClass.status == "RUNNING" && socketModelClass.iconType == "tracktor"
    //           ?
    //       tractorGreen
    //           :
    //       socketModelClass.status == "IDLING" && socketModelClass.iconType == "tracktor"
    //           ?
    //       tractorYellow
    //           :
    //       socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "tracktor"
    //           ?
    //       tractorBlue
    //           :
    //       socketModelClass.status == "Expired" && socketModelClass.iconType == "tracktor"
    //           ?
    //       tractorOrange
    //           :
    //       socketModelClass.status == "STOPPED" && socketModelClass.iconType == "tracktor"
    //           ?
    //       tractorRed
    //           :
    //       socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "tracktor"
    //           ?
    //       tractorGrey
    //           :
    //       socketModelClass.status == "RUNNING" && socketModelClass.iconType == "pickup"
    //           ?
    //       smallTruckGreen
    //           :
    //       socketModelClass.status == "IDLING" && socketModelClass.iconType == "pickup"
    //           ?
    //       smallTruckYellow
    //           :
    //       socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "pickup"
    //           ?
    //       smallTruckBlue
    //           :
    //       socketModelClass.status == "Expired" && socketModelClass.iconType == "pickup"
    //           ?
    //       smallTruckOrange
    //           :
    //       socketModelClass.status == "STOPPED" && socketModelClass.iconType == "pickup"
    //           ?
    //       smallTruckRed
    //           :
    //       socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "pickup"
    //           ?
    //       smallTruckGrey
    //           :
    //       socketModelClass.status == "RUNNING" && socketModelClass.iconType == "scooter"
    //           ?
    //       scooterGreen
    //           :
    //       socketModelClass.status == "IDLING" && socketModelClass.iconType == "scooter"
    //           ?
    //       scooterYellow
    //           :
    //       socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "scooter"
    //           ?
    //       scooterBlue
    //           :
    //       socketModelClass.status == "Expired" && socketModelClass.iconType == "scooter"
    //           ?
    //       scooterOrange
    //           :
    //       socketModelClass.status == "STOPPED" && socketModelClass.iconType == "scooter"
    //           ?
    //       scooterRed
    //           :
    //       socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "scooter"
    //           ?
    //       scooterGrey
    //           :
    //       socketModelClass.status == "RUNNING" && socketModelClass.iconType == "pet"
    //           ?
    //       petGreen
    //           :
    //       socketModelClass.status == "IDLING" && socketModelClass.iconType == "pet"
    //           ?
    //       petYellow
    //           :
    //       socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "pet"
    //           ?
    //       petBlue
    //           :
    //       socketModelClass.status == "Expired" && socketModelClass.iconType == "pet"
    //           ?
    //       petOrange
    //           :
    //       socketModelClass.status == "STOPPED" && socketModelClass.iconType == "pet"
    //           ?
    //       petRed
    //           :
    //       socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "pet"
    //           ?
    //       petGrey
    //           :
    //
    //       socketModelClass.status == "RUNNING" && socketModelClass.iconType == "user"
    //           ?
    //       userGreen
    //           :
    //       socketModelClass.status == "IDLING" && socketModelClass.iconType == "user"
    //           ?
    //       userYellow
    //           :
    //       socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "user"
    //           ?
    //       userBlue
    //           :
    //       socketModelClass.status == "Expired" && socketModelClass.iconType == "user"
    //           ?
    //       userOrange
    //           :
    //       socketModelClass.status == "STOPPED" && socketModelClass.iconType == "user"
    //           ?
    //       userRed
    //           :
    //       socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "user"
    //           ?
    //       userGrey
    //           :
    //       locationIcon
    //   ),
    // );
    //
    // //Adding initial marker to the start location.
    // _markers.add(carMarkers);
    // mapMarkerSink.add(_markers);

    animationController = AnimationController(
      duration: const Duration(seconds: 5), //Animation duration of marker
      vsync: provider, //From the widget
    );

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController)
      ..addListener(() async {
        //We are calculating new latitude and logitude for our marker
        final v = _animation.value;
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);

        controller.moveCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: newPos, zoom: 14)));
        //Removing old marker if present in the marker array
        if (_markers.contains("driverMarker")) _markers.remove("driverMarker");

        //New marker location
        var carMarkers = Marker(
          markerId: const MarkerId("driverMarker"),
          position: newPos,
          anchor: const Offset(0.5, 0.5),
          flat: true,
          rotation: bearing,
          draggable: false,
          icon:BitmapDescriptor.fromBytes(
              socketModelClass.status == "RUNNING" && socketModelClass.iconType == "bike"
                  ?
              bikeGreen
                  :
              socketModelClass.status == "IDLING" && socketModelClass.iconType == "bike"
                  ?
              bikeYellow
                  :
              socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "bike"
                  ?
              bikeBlue
                  :
              socketModelClass.status == "Expired" && socketModelClass.iconType == "bike"
                  ?
              bikeOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass.iconType == "bike"
                  ?
              bikeRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "bike"
                  ?
              bikeGrey
                  :
              socketModelClass.status == "RUNNING" && socketModelClass.iconType == "car"
                  ?
              carGreen
                  :
              socketModelClass.status == "IDLING" && socketModelClass.iconType == "car"
                  ?
              carYellow
                  :
              socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "car"
                  ?
              carBlue
                  :
              socketModelClass.status == "Expired" && socketModelClass.iconType == "car"
                  ?
              carOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass.iconType == "car"
                  ?
              carRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "car"
                  ?
              carGrey
                  :
              socketModelClass.status == "RUNNING" && socketModelClass.iconType == "truck"
                  ?
              longTruckGreen
                  :
              socketModelClass.status == "IDLING" && socketModelClass.iconType == "truck"
                  ?
              longTruckYellow
                  :
              socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "truck"
                  ?
              longTruckBlue
                  :
              socketModelClass.status == "Expired" && socketModelClass.iconType == "truck"
                  ?
              longTruckOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass.iconType == "truck"
                  ?
              longTruckRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "truck"
                  ?
              longTruckGrey
                  :
              socketModelClass.status == "RUNNING" && socketModelClass.iconType == "bus"
                  ?
              busGreen
                  :
              socketModelClass.status == "IDLING" && socketModelClass.iconType == "bus"
                  ?
              busYellow
                  :
              socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "bus"
                  ?
              busBlue
                  :
              socketModelClass.status == "Expired" && socketModelClass.iconType == "bus"
                  ?
              busOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass.iconType == "bus"
                  ?
              busRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "bus"
                  ?
              busGrey
                  :
              socketModelClass.status == "RUNNING" && socketModelClass.iconType == "jcb"
                  ?
              jcbGreen
                  :
              socketModelClass.status == "IDLING" && socketModelClass.iconType == "jcb"
                  ?
              jcbYellow
                  :
              socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "jcb"
                  ?
              jcbBlue
                  :
              socketModelClass.status == "Expired" && socketModelClass.iconType == "jcb"
                  ?
              jcbOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass.iconType == "jcb"
                  ?
              jcbRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "jcb"
                  ?
              jcbGrey
                  :
              socketModelClass.status == "RUNNING" && socketModelClass.iconType == "tracktor"
                  ?
              tractorGreen
                  :
              socketModelClass.status == "IDLING" && socketModelClass.iconType == "tracktor"
                  ?
              tractorYellow
                  :
              socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "tracktor"
                  ?
              tractorBlue
                  :
              socketModelClass.status == "Expired" && socketModelClass.iconType == "tracktor"
                  ?
              tractorOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass.iconType == "tracktor"
                  ?
              tractorRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "tracktor"
                  ?
              tractorGrey
                  :
              socketModelClass.status == "RUNNING" && socketModelClass.iconType == "pickup"
                  ?
              smallTruckGreen
                  :
              socketModelClass.status == "IDLING" && socketModelClass.iconType == "pickup"
                  ?
              smallTruckYellow
                  :
              socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "pickup"
                  ?
              smallTruckBlue
                  :
              socketModelClass.status == "Expired" && socketModelClass.iconType == "pickup"
                  ?
              smallTruckOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass.iconType == "pickup"
                  ?
              smallTruckRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "pickup"
                  ?
              smallTruckGrey
                  :
              socketModelClass.status == "RUNNING" && socketModelClass.iconType == "scooter"
                  ?
              scooterGreen
                  :
              socketModelClass.status == "IDLING" && socketModelClass.iconType == "scooter"
                  ?
              scooterYellow
                  :
              socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "scooter"
                  ?
              scooterBlue
                  :
              socketModelClass.status == "Expired" && socketModelClass.iconType == "scooter"
                  ?
              scooterOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass.iconType == "scooter"
                  ?
              scooterRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "scooter"
                  ?
              scooterGrey
                  :
              socketModelClass.status == "RUNNING" && socketModelClass.iconType == "pet"
                  ?
              petGreen
                  :
              socketModelClass.status == "IDLING" && socketModelClass.iconType == "pet"
                  ?
              petYellow
                  :
              socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "pet"
                  ?
              petBlue
                  :
              socketModelClass.status == "Expired" && socketModelClass.iconType == "pet"
                  ?
              petOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass.iconType == "pet"
                  ?
              petRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "pet"
                  ?
              petGrey
                  :

              socketModelClass.status == "RUNNING" && socketModelClass.iconType == "user"
                  ?
              userGreen
                  :
              socketModelClass.status == "IDLING" && socketModelClass.iconType == "user"
                  ?
              userYellow
                  :
              socketModelClass.status == "OUT OF REACH" && socketModelClass.iconType == "user"
                  ?
              userBlue
                  :
              socketModelClass.status == "Expired" && socketModelClass.iconType == "user"
                  ?
              userOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass.iconType == "user"
                  ?
              userRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass.iconType == "user"
                  ?
              userGrey
                  :
              locationIcon
          ),
        );

        //Adding new marker to our list and updating the google map UI.
        _markers.add(carMarkers);
        mapMarkerSink.add(_markers);

        //Moving the google camera to the new animated location.

      });

    //Starting the animation
    animationController.forward();
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


  addMarkers(){

    _markers.add(
      Marker(
        markerId: MarkerId("endPoint"),
        position: LatLng(
          widget.vehicleLisDevice.lastLocation.lat,
          widget.vehicleLisDevice.lastLocation.long,
        ),
        icon:BitmapDescriptor.fromBytes(
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "car"
                ?
            carGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "car"
                ?
            carYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "car"
                ?
            carBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "car"
                ?
            carOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "car"
                ?
            carRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "car"
                ?
            carGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "bus"
                ?
            busGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "bus"
                ?
            busYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "bus"
                ?
            busBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "bus"
                ?
            busOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "bus"
                ?
            busRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "bus"
                ?
            busGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "tracktor"
                ?
            tractorGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "tracktor"
                ?
            tractorYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "tracktor"
                ?
            tractorBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "tracktor"
                ?
            tractorOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "tracktor"
                ?
            tractorRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "tracktor"
                ?
            tractorGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "pet"
                ?
            petGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "pet"
                ?
            petYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "pet"
                ?
            petBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "pet"
                ?
            petOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "pet"
                ?
            petRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "pet"
                ?
            petGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "user"
                ?
            userGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "user"
                ?
            userYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "user"
                ?
            userBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "user"
                ?
            userOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "user"
                ?
            userRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "user"
                ?
            userGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawGrey
                :


            widget.vehicleLisDevice.status == "RUNNING" && widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" && widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceBlue
                :
            widget.vehicleLisDevice.status == "Expired" && widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" && widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceGrey
                :
            locationIcon
        ),
        rotation: double.parse("${widget.vehicleLisDevice.heading??"0"}")
      ),
    );

    _mapMarkerSink.add(_markers);

  }



  var time;
  share()async{

    if(sharedTime == "15"){
      time = 15;
    }
    else if (sharedTime == "1"){
      time = 60;
    }
    else if (sharedTime == "8"){
      time = 6*60;
    }


    var data = {
      "id": "${widget.vehicleLisDevice.id}",
      "imei": "${widget.vehicleLisDevice.deviceId}",
      "sh": "${_userProvider.useModel.cust.id}",
      "ttl": time
    };


    await _userProvider.sharedApi(data, "share", context, widget.vehicleLisDevice.deviceName);
  }
  var sharedTime = "15";
  TextEditingController customController = TextEditingController();
  showSharedBottom(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: ApplicationColors.blackColor2E,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
          )
        ),
        builder: (context){
          return SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context,setState) {
                return Container(
                  margin: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  height: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "${getTranslated(context, "Share_Vehicle_Live_Location")}",
                          style: Textstyle1.text12.copyWith(
                            fontSize: 15,
                            color: ApplicationColors.blackbackcolor,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  sharedTime = "15";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ApplicationColors.greyC4C4,
                                        offset: Offset(5.0, 5.0,),
                                        blurRadius: 8.0,
                                        spreadRadius: 0.3,
                                      ), //BoxShadow
                                    ],
                                  color: sharedTime ==  "15" ? ApplicationColors.redColor67 : ApplicationColors.blackColor2E,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child:  Text(
                                  "15 ${getTranslated(context, "Min")}",
                                  textAlign: TextAlign.center,
                                  style: Textstyle1.text12.copyWith(
                                    fontSize: 15,
                                    color:sharedTime ==  "15"? ApplicationColors.whiteColor:ApplicationColors.blackbackcolor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  sharedTime = "1";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ApplicationColors.greyC4C4,
                                        offset: Offset(5.0, 5.0,),
                                        blurRadius: 8.0,
                                        spreadRadius: 0.3,
                                      ), //BoxShadow
                                    ],
                                  color: sharedTime ==  "1" ? ApplicationColors.redColor67 : ApplicationColors.blackColor2E,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child:  Text(
                                  "1 ${getTranslated(context, 'hour')}",
                                  textAlign: TextAlign.center,
                                  style: Textstyle1.text12.copyWith(
                                    fontSize: 15,
                                    color:sharedTime ==  "1"? ApplicationColors.whiteColor:ApplicationColors.blackbackcolor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  sharedTime = "8";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ApplicationColors.greyC4C4,
                                        offset: Offset(5.0, 5.0,),
                                        blurRadius: 8.0,
                                        spreadRadius: 0.3,
                                      ), //BoxShadow
                                    ],
                                  color: sharedTime ==  "8" ? ApplicationColors.redColor67 : ApplicationColors.blackColor2E,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child:  Text(
                                  "8 ${getTranslated(context, "hour")}",
                                  textAlign: TextAlign.center,
                                  style: Textstyle1.text12.copyWith(
                                    fontSize: 15,
                                    color:sharedTime ==  "8"? ApplicationColors.whiteColor:ApplicationColors.blackbackcolor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: ApplicationColors.greyC4C4,
                                      offset: Offset(5.0, 5.0,),
                                      blurRadius: 8.0,
                                      spreadRadius: 0.3,
                                    ), //BoxShadow
                                  ],
                                  color: sharedTime == "custom" ? ApplicationColors.redColor67 : ApplicationColors.blackColor2E,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: TextFormField(
                                cursorColor: ApplicationColors.whiteColor,
                                style:  Textstyle1.text12.copyWith(
                                    color: ApplicationColors.whiteColor,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 15
                                ),
                                onTap: (){
                                  setState((){
                                    sharedTime = "custom";
                                  });
                                },
                                keyboardType: TextInputType.number,
                                controller: customController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: "${getTranslated(context, 'custom')}",
                                  hintStyle:  Textstyle1.text12.copyWith(
                                      color:sharedTime ==  "custom"? ApplicationColors.whiteColor:ApplicationColors.blackbackcolor,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Expanded(child: SizedBox())
                        ],
                      ),

                      InkWell(
                        onTap: (){
                          share();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ApplicationColors.redColor67
                          ),
                          child: Icon(
                            Icons.send,
                            color: ApplicationColors.whiteColor,
                          ),
                        ),
                      )

                    ],
                  ),
                );
              }
            ),
          );
        }
    ).whenComplete(() {
      setState(() {});
    });
  }
var fualpercent;
  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    createMarker();
    connectSocketIo();
    //fualpercent=int.parse(widget.vehicleLisDevice.fuelPercent).toStringAsFixed(2);
    //print("--------------${fualpercent}");
      if(widget.vehicleLisDevice.statusUpdatedAt.toString() !=null) {
        String utcDateStr = widget.vehicleLisDevice.statusUpdatedAt.toString();
        DateTime utcDate = DateTime.parse(utcDateStr);

        // get the current local date and time
        DateTime currentDate = DateTime.now();

        // calculate the difference between the UTC date and the current local date and time
        Duration difference1 = utcDate.toLocal().difference(currentDate);

        // calculate the total hours and minutes between the two dates
         totalHours = difference1.inHours.abs();
        totalMinutes = difference1.inMinutes.abs() % 60;

        print("Total hours: $totalHours, Total minutes: $totalMinutes");
      }

    if(widget.vehicleLisDevice.lastLocation == null) {
      listOfLatLog.add(LatLng(0,0));
    }else {
      listOfLatLog.add(
        LatLng(
          widget.vehicleLisDevice.lastLocation.lat,
          widget.vehicleLisDevice.lastLocation.long,
        ),
      );
    }
  }

  @override
  void dispose() {
    socket.dispose();
    socket.disconnect();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;


    List vehicleInfoCategories = [
      '${getTranslated(context, "live")}',
      '${getTranslated(context, "history")}',
      '${getTranslated(context, "parking")}',
      '${getTranslated(context, "immobilize")}',
      '${getTranslated(context, "driver")}',
      '${getTranslated(context, "analytics")}',
     // '${getTranslated(context, "tow")}',
      '${getTranslated(context, "setting")}',
      '${getTranslated(context, "geofence")}',
      '${getTranslated(context, "documents")}'
    ];

      return Scaffold(
      backgroundColor: ApplicationColors.whiteColorF9,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    height: height * .4,
                    child: StreamBuilder<List<Marker>>(
                        stream: mapMarkerStream,
                        builder: (context, snapshot) {
                          return GoogleMap(
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target:widget.vehicleLisDevice.lastLocation == null ?
                              LatLng(0,0):
                              LatLng(
                                widget.vehicleLisDevice.lastLocation.lat,
                                widget.vehicleLisDevice.lastLocation.long,
                              ), //initial position
                              zoom: 15.5, //initial zoom level
                            ),
                            mapType: Utils.mapType, //map type
                            markers: Set<Marker>.of(snapshot.data ?? []),
                            onMapCreated: (controller) {
                              setState(() {
                                mapController = controller;

                                setState(() {
                                  firstBool = true;
                                });

                                mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: isLoading
                                          ?
                                      LatLng(
                                          widget.vehicleLisDevice.lastLocation.lat,
                                          widget.vehicleLisDevice.lastLocation.long
                                      )
                                          :
                                      LatLng(
                                        socketModelClass.lastLocation.lat,
                                        socketModelClass.lastLocation.long,
                                      ),
                                      zoom: 15.5,
                                    ),
                                  ),
                                );


                              });
                            },
                          );
                        }
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: height,
                padding: EdgeInsets.only(top: height * .25),
                child: Column(
                  children: [
                    Container(
                      decoration: Boxdec.conrad6colorblack.copyWith(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 17, vertical: 14
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        height: 25,
                                        width: 25,
                                        padding: EdgeInsets.all(4),
                                        child: Image.asset(
                                            "assets/images/Subtract.png",
                                          fit: BoxFit.contain,
                                        ),
                                        decoration: Boxdec.squareBoxshadow.copyWith(
                                          color: ApplicationColors.redColor67,
                                        )
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      isLoading
                                          ?
                                      "${NumberFormat("##0.0#", "en_US").format(widget.vehicleLisDevice.totalOdo)} ""${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "${getTranslated(context, "Km")}" : "${getTranslated(context, "Miles")}"}"
                                          :
                                      "${NumberFormat("##0.0#", "en_US").format(socketModelClass.todayOdo)} ""${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "${getTranslated(context, "Km")}" : "${getTranslated(context, "Miles")}"}",
                                      overflow: TextOverflow.visible,
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: Textstyle1.text12b
                                    ),

                                    SizedBox(width: 10),
                                    Container(
                                        height: 25,
                                        width: 25,
                                        child: Center(
                                            child: Image.asset(
                                              "assets/images/petrol_icon_.png",
                                              width: 11,
                                              color: ApplicationColors.whiteColor,
                                            )
                                        ),
                                        decoration: Boxdec.squareBoxshadow.copyWith(
                                          color: ApplicationColors.redColor67,
                                        )
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        isLoading
                                            ?
                                        "${_userProvider.useModel.cust.fuelUnit == "LITER" ? "${double.parse(widget.vehicleLisDevice.fuelUnit).toStringAsFixed(2)}L" : "${widget.vehicleLisDevice.fuelPercent == null ? 0: double.parse(widget.vehicleLisDevice.fuelPercent).toStringAsFixed(2)}%"}"
                                            :
                                        "${_userProvider.useModel.cust.fuelUnit == "LITER" ? "${double.parse(socketModelClass.fuelUnit).toStringAsFixed(2)}L" : "${socketModelClass.fuelPercent == null ? 0: double.parse(socketModelClass.fuelPercent).toStringAsFixed(2)}%"}",
                                        overflow: TextOverflow.visible,
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                        style: Textstyle1.text12b
                                    ),
                                  
                                    SizedBox(width: 10),
                                    Container(
                                        height: 25,
                                        width: 25,
                                        child: Center(
                                            child: Image.asset(
                                              "assets/images/km2nd_icon.png",
                                              width: 15,

                                            )
                                        ),
                                        decoration: Boxdec.squareBoxshadow.copyWith(
                                          color: ApplicationColors.redColor67,
                                        ),
                                    ),

                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        isLoading
                                            ?
                                        "${NumberFormat("##0.0#", "en_US").format(int.parse(widget.vehicleLisDevice.lastSpeed ?? "0"))} ""${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "${getTranslated(context, "km_hr")}" : "${getTranslated(context, "Miles")}"}"
                                            :
                                        "${NumberFormat("##0.0#", "en_US").format(int.parse(socketModelClass.lastSpeed??"0"))} ""${_userProvider.useModel.cust.unitMeasurement == "MKS" ? "${getTranslated(context, "km_hr")}" : "${getTranslated(context, "Miles")}"}",
                                        overflow: TextOverflow.visible,
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        style: Textstyle1.text12b
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          isLoading
                                              ?
                                          "${widget.vehicleLisDevice.deviceName}"
                                              :
                                          "${socketModelClass.deviceName}",
                                          style: Textstyle1.text18bold.copyWith(
                                              fontSize: 16
                                          )
                                      ),
                                    ),

                                    RichText(
                                      overflow: TextOverflow.visible,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: isLoading
                                                  ?
                                              "${widget.vehicleLisDevice.status} : "
                                                  :
                                              "${socketModelClass.status} : ",
                                                style: Textstyle1.text12b.copyWith(

                                                  color:isLoading
                                                      ?
                                                  "${widget.vehicleLisDevice.status}" == "RUNNING"
                                                      ?
                                                  ApplicationColors.greenColor370
                                                      :
                                                  "${widget.vehicleLisDevice.status}" ==  "IDLING"
                                                      ?
                                                  ApplicationColors.yellowColorD21
                                                      :
                                                  "${widget.vehicleLisDevice.status}" == "OUT OF REACH"
                                                      ?
                                                  ApplicationColors.blueColorCE
                                                      :
                                                  "${widget.vehicleLisDevice.status}" == "Expired"
                                                      ?
                                                  ApplicationColors.orangeColor3E
                                                      :
                                                  "${widget.vehicleLisDevice.status}" == "NO DATA"
                                                      ?
                                                  ApplicationColors.radiusColorFB
                                                      :
                                                  ApplicationColors.redColor67
                                                      :
                                                  "${socketModelClass.status}" == "RUNNING"
                                                      ?
                                                  ApplicationColors.greenColor370
                                                      :
                                                  "${socketModelClass.status}" == "IDLING"
                                                      ?
                                                  ApplicationColors.yellowColorD21
                                                      :
                                                  "${socketModelClass.status}" == "OUT OF REACH"
                                                      ?
                                                  ApplicationColors.blueColorCE
                                                      :
                                                  "${socketModelClass.status}" == "Expired"
                                                      ?
                                                  ApplicationColors.orangeColor3E
                                                      :
                                                  "${socketModelClass.status}" == "NO DATA"
                                                      ?
                                                  ApplicationColors.radiusColorFB
                                                      :
                                                  ApplicationColors.redColor67,
                                                )
                                            ),

                                            TextSpan(
                                             text: isLoading
                                                  ?
                                              widget.vehicleLisDevice.statusUpdatedAt == null
                                                  ?
                                              ""
                                                  :"${getTranslated(context, "since")}${totalHours}h ${totalMinutes}m"
                                             // "${getTranslated(context, "since")} ${DateFormat.H().format(widget.vehicleLisDevice.statusUpdatedAt)}h ${DateFormat.M().format(widget.vehicleLisDevice.statusUpdatedAt)}m"
                                                  :"${getTranslated(context, "since")} ${totalHours}h ${totalMinutes}m",
                                            //  "${getTranslated(context, "since")} ${DateFormat.H().format(socketModelClass.statusUpdatedAt)}h ${DateFormat.M().format(socketModelClass.statusUpdatedAt)}m",
                                              style: Textstyle1.text12b
                                            ),
                                          ]
                                        ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                        'assets/images/clock_icon_vehicle_Page.png',
                                        width: 13,
                                      color: ApplicationColors.redColor67,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "${getTranslated(context, "last_update")} ",
                                      style: Textstyle1.text12b.copyWith(
                                        fontSize: 10,
                                        //color: ApplicationColors.black4240,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        isLoading
                                            ?
                                        widget.vehicleLisDevice.lastPingOn == null ?
                                        ""
                                            :
                                        "${DateFormat("MMM dd yyyy hh:mm:ss aa").format(widget.vehicleLisDevice.lastPingOn.toLocal())}"
                                            :
                                        "${DateFormat("MMM dd yyyy hh:mm:ss aa").format(socketModelClass.lastPingOn.toLocal())}",
                                        overflow: TextOverflow.visible,
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        style: Textstyle1.text12b
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/images/gps1.png",
                                      width: 13,
                                      color:
                                      ApplicationColors.redColor67,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${widget.vehicleLisDevice.address}",
                                        overflow: TextOverflow.visible,
                                        style: Textstyle1.text12b.copyWith(
                                            fontSize: 10,

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "${getTranslated(context, "licence_expires")}  ",
                                                style: Textstyle1.text10.copyWith(
                                                  fontSize: 10,
                                                ),
                                              ),

                                              TextSpan(
                                                text:isLoading
                                                    ?
                                                "${DateFormat("MMM dd yyyy").format(widget.vehicleLisDevice.createdOn)}"
                                                    :
                                                "${DateFormat("MMM dd yyyy").format(socketModelClass.createdOn)}",
                                                style: Textstyle1.text10.copyWith(
                                                  fontSize: 10,
                                                ),
                                              ),

                                              TextSpan(
                                                text: "  ${getTranslated(context, "to")}  ",
                                                style: Textstyle1.text10.copyWith(
                                                  fontSize: 10,
                                                ),
                                              ),

                                              TextSpan(

                                                text:isLoading
                                                    ?
                                                "${DateFormat("MMM dd yyyy").format(widget.vehicleLisDevice.expirationDate)}"
                                                    :
                                                "${DateFormat("MMM dd yyyy").format(socketModelClass.expirationDate)}",
                                                style: Textstyle1.text10.copyWith(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),

                                SizedBox(
                                    height: height*.07,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        children:[
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 7),
                                            width:width *.148,
                                            height: height *.07,
                                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                            decoration: Boxdec.conrad6colorgrey,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Image.asset(
                                                      "assets/images/key.png",
                                                      width: 15,
                                                      color:
                                                    //  isLoading
                                                        //  ?
                                                      widget.vehicleLisDevice.ignitionSource == null ? ApplicationColors.greyC4C4 : widget.vehicleLisDevice.ignitionSource == "0" ? ApplicationColors.redColor67 :ApplicationColors.greenColor
                                                        //  :
                                                     // socketModelClass.ignitionLock == "" ? ApplicationColors.greyC4C4 : socketModelClass.ignitionLock == "0" ? ApplicationColors.redColor67 :ApplicationColors.greenColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text(
                                                    "${getTranslated(context, "key")}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Textstyle1.text12b.copyWith(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 7),
                                            width:width *.148,
                                            height: height *.07,
                                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                            decoration: Boxdec.conrad6colorgrey,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Image.asset(
                                                      "assets/images/freezer.png",
                                                      width: 15,
                                                      color:isLoading
                                                          ?
                                                      widget.vehicleLisDevice.ac == null ? ApplicationColors.greyC4C4 : widget.vehicleLisDevice.ac == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor
                                                          :
                                                      socketModelClass.ac == null ? ApplicationColors.greyC4C4 : socketModelClass.ac == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text(
                                                    "${getTranslated(context, "ac")}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Textstyle1.text12b.copyWith(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 7),
                                            width:width *.148,
                                            height: height *.07,
                                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                            decoration: Boxdec.conrad6colorgrey,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Image.asset(
                                                      "assets/images/power.png",
                                                      width: 15,
                                                      color:isLoading
                                                          ?
                                                      widget.vehicleLisDevice.power == null ? ApplicationColors.greyC4C4 : widget.vehicleLisDevice.power == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor
                                                          :
                                                      socketModelClass.power == "" ? ApplicationColors.greyC4C4 : socketModelClass.power == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,

                                                    ),
                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text(
                                                    "${getTranslated(context, "power")}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Textstyle1.text12b.copyWith(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 7),
                                            width:width *.148,
                                            height: height *.07,
                                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                            decoration: Boxdec.conrad6colorgrey,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Image.asset(
                                                      "assets/images/Battery.png",
                                                      width: 12,
                                                      color: isLoading
                                                          ?
                                                      widget.vehicleLisDevice.batteryPercent == "" ? ApplicationColors.greyC4C4 : widget.vehicleLisDevice.batteryPercent == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor
                                                          :
                                                      socketModelClass.fuelUnit == "" ? ApplicationColors.greyC4C4 : socketModelClass.fuelUnit == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text(
                                                    "${getTranslated(context, "battery")}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Textstyle1.text12b.copyWith(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 7),
                                            width:width *.148,
                                            height: height *.07,
                                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                            decoration: Boxdec.conrad6colorgrey,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Image.asset(
                                                      "assets/images/satellite.png",
                                                      width: 15,
                                                      color: isLoading
                                                          ?
                                                      widget.vehicleLisDevice.satellites == null ? ApplicationColors.greyC4C4 :  widget.vehicleLisDevice.gpsTracking == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor
                                                          :
                                                      socketModelClass.gpsTracking == "" ? ApplicationColors.greyC4C4 : socketModelClass.gpsTracking == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text(
                                                    "${getTranslated(context, "gps")}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Textstyle1.text12b.copyWith(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 7),
                                            width:width *.148,
                                            height: height *.07,
                                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                            decoration: Boxdec.conrad6colorgrey,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Image.asset(
                                                      "assets/images/Door_icon.png",
                                                      width: 15,
                                                      color: isLoading
                                                          ?
                                                      widget.vehicleLisDevice.door == null ? ApplicationColors.greyC4C4 :  widget.vehicleLisDevice.door == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor
                                                          :
                                                      socketModelClass.door == "" ? ApplicationColors.greyC4C4 : socketModelClass.door == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text(
                                                    "${getTranslated(context, "Door")}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Textstyle1.text12b.copyWith(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 7),
                                            width:width *.148,
                                            height: height *.07,
                                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                            decoration: Boxdec.conrad6colorgrey,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Image.asset(
                                                      "assets/images/secured-lock.png",
                                                      width: 15,
                                                      color:  isLoading
                                                          ?
                                                      widget.vehicleLisDevice.ignitionLock == null ? ApplicationColors.greyC4C4 : widget.vehicleLisDevice.ignitionLock == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor
                                                          :
                                                      socketModelClass.ignitionLock == null ? ApplicationColors.greyC4C4 : socketModelClass.ignitionLock == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text(
                                                    "${getTranslated(context, "lock")}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Textstyle1.text12b.copyWith(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]
                                    )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),

                    Expanded(
                      child: GridView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.all(0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  // childAspectRatio: 3/2,
                                  crossAxisSpacing: 18,
                                  mainAxisSpacing: 18,
                                  crossAxisCount: 3,
                              ),
                          itemCount: vehicleInfoCategories.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                if (vehicleInfoCategories[index] == '${getTranslated(context, "immobilize")}') {
                                  socket.dispose();
                                  final value = await  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Immobilized(
                                              vDeviceId:widget.vDeviceId,
                                              vehicleLisDevice: widget.vehicleLisDevice,
                                              vName:widget.vName
                                          ))
                                  );
                                  if(value != null || value == null){
                                    connectSocketIo();
                                  }
                                }
                                if(vehicleInfoCategories[index] == '${getTranslated(context, "driver")}'){
                                  if(widget.vehicleLisDevice.contactNumber != "" || widget.vehicleLisDevice.contactNumber != null) {
                                    String url = 'tel:${widget.vehicleLisDevice.contactNumber}' ;
                                    await launch(url);
                                  }else{
                                    Helper.dialogCall.showToast(context, "${getTranslated(context, "Driver_number_not_found")}");
                                  }
                                }
                                if (vehicleInfoCategories[index] == '${getTranslated(context, "live")}') {
                                  socket.dispose();
                                  // animationController.dispose();

                                  final value = await  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LiveForVehicleScreen(
                                                vDeviceId: widget.vDeviceId,
                                                vehicleLisDevice: widget.vehicleLisDevice,
                                                vId: widget.vId,
                                              )
                                      )
                                  );
                                 if(value != null || value == null){
                                   connectSocketIo();
                                 }
                                }
                                if (vehicleInfoCategories[index] == '${getTranslated(context, "history")}') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HistoryPage(
                                            vId: widget.vehicleLisDevice.id,
                                            deviceId: widget.vehicleLisDevice.deviceId,
                                            deviceName: widget.vehicleLisDevice.deviceName,
                                            formDate: "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z",
                                            toDate: DateTime.now().toUtc().toString(),
                                          ),
                                      )
                                  );
                                }
                                if (vehicleInfoCategories[index] == '${getTranslated(context, "geofence")}') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Geofences(value: "value",))
                                  );
                                }
                                if (vehicleInfoCategories[index] == '${getTranslated(context, "analytics")}') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AnalyticsPage(
                                             vDeviceId:widget.vDeviceId,
                                              vehicleListModel:widget.vehicleLisDevice
                                          ))
                                  );
                                }
                                if (vehicleInfoCategories[index] == '${getTranslated(context, "documents")}') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DocumetsPage(
                                            vehicleLisDevice: widget.vehicleLisDevice,
                                          ),
                                      )
                                  );
                                }
                                if (vehicleInfoCategories[index] == '${getTranslated(context, "setting")}') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VehicleListDeviceSettingPage(
                                                vehicleLisDevice: widget.vehicleLisDevice,
                                              ),
                                      )
                                  );
                                }
                                if (vehicleInfoCategories[index] == '${getTranslated(context, "parking")}') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ParkingSchedulerPage(
                                                  vName: widget.vName,
                                                  vId: widget.vId))
                                  );
                                }
                                if (vehicleInfoCategories[index] == "${getTranslated(context, "tow")}") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TowSchedulerPage(
                                                  vName: widget.vName,
                                                  vId: widget.vId))
                                  );
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 18, right: 18, top: 20, bottom: 0),
                                  decoration: Boxdec.conrad6colorgrey.copyWith(
                                      color: ApplicationColors.blackColor2E
                                  ),
                                  width: width * .05,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Image.asset(
                                                vehicleInfoCategoriesIcon[index],
                                                width: 37,
                                              color: ApplicationColors.redColor67,
                                            )
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                            child: Text(vehicleInfoCategories[index],
                                                style: Textstyle1.text14.copyWith(
                                                    fontSize: 10
                                                )
                                            )
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          }),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            Positioned(
                top: height * .05,
                left: width * .05,
                child: Container(
                  width: width * .09,
                  height: height * .04,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: ApplicationColors.blackColor2E),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                          child: Image.asset(
                              'assets/images/back_icon_.png',  color:ApplicationColors.redColor67 ,


                              width: 7
                          )
                      )
                  ),
                )
            ),

            Positioned(
              top: height * .05,
              right: width * .05,
              child: InkWell(
                onTap: (){
                  setState(() {
                    sharedTime = "15";
                  });
                  showSharedBottom();
                },
                child: Container(
                  width: width * .09,
                  height: height * .04,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: ApplicationColors.blackColor2E
                  ),
                  child: Center(
                      child: Image.asset(
                          'assets/images/icon_sharedd.png',  color:ApplicationColors.redColor67 ,


                          width: 12
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
