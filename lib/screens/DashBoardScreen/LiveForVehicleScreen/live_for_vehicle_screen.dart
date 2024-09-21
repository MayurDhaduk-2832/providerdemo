import 'dart:async';
import 'dart:convert';
import 'dart:developer' as d;
import 'dart:math';

import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Api/api.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/socket_model.dart';
import 'package:oneqlik/Provider/geofence_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/history.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/history_new.dart';
import 'package:oneqlik/screens/DashBoardScreen/LiveForVehicleScreen/live_for_vehicle_screen_Two.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math.dart' as v;

import '../../../Model/vehicle_list_model.dart';
import '../../../components/styleandborder.dart';
import '../DrawerPages/ReportsScreen/trip_report.dart';
import '../DrawerPages/VehicleMaintenancePages/maintenance_reminder.dart';
import '../HomePage/NotificationPage/notification_screen.dart';


class LiveForVehicleScreen extends StatefulWidget {
  final vDeviceId, vId;
  VehicleLisDevice vehicleLisDevice;

  LiveForVehicleScreen(
      {Key key, this.vDeviceId, this.vehicleLisDevice, this.vId})
      : super(key: key);

  @override
  _LiveForVehicleScreenState createState() => _LiveForVehicleScreenState();
}

class _LiveForVehicleScreenState extends State<LiveForVehicleScreen>
    with TickerProviderStateMixin {
  Set<Polyline> polylines = {};
  bool isRouteShow = false;

  LatLng pos1;
  LatLng pos2;
  stepPolyLine(
      double fromLat,
      double fromLong,
      double lat,
      double lng,
      double v,
      ) {
    if (v.toStringAsFixed(1) == "0.4") {
      createPolyLine(
        fromLat,
        fromLong,
        lat,
        lng,
      );
    } else if (v.toStringAsFixed(1) == "0.8") {
      createPolyLine(
        fromLat,
        fromLong,
        lat,
        lng,
      );
    } else if (v.toStringAsFixed(1) == "1.0") {
      createPolyLine(
        fromLat,
        fromLong,
        lat,
        lng,
      );
    }
  }

  createPolyLine(
      double fromLat,
      double fromLong,
      double toLat,
      double toLong,
      ) {
    if (pos2 == null) {
      pos1 = LatLng(fromLat, fromLong);
    } else {
      pos1 = pos2;
    }
    pos2 = LatLng(toLat, toLong);

    polylines.add(Polyline(
      polylineId: PolylineId(pos2.toString()),
      visible: true,
      width: 4,
      points: [
        pos1,
        pos2,
      ],
      color: ApplicationColors.greenColor370, //color of polyline
    ));
  }

  bool isMarkerLoad = false;
  IO.Socket socket;

  GoogleMapController mapController;
  var data;

  bool isLoading = true,
      loadMarker = false;
  SocketModelClass  socketModelClass;
  var address = "Address not found";
  double _zoomLevel = 16.0;
  UserProvider _userProvider;
  var fromDate =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toUtc().toString();
  Uint8List carMarker;

  Uint8List busRed, busBlue, busGreen, busOrange, busYellow, busGrey;
  Uint8List carRed, carBlue, carGreen, carOrange, carYellow, carGrey;
  Uint8List scooterRed, scooterBlue, scooterGreen, scooterOrange, scooterYellow,
      scooterGrey;
  Uint8List bikeRed, bikeBlue, bikeGreen, bikeOrange, bikeYellow, bikeGrey;
  Uint8List carSuvBlue, carSuvRed, carSuvGreen, carSuvOrange, carSuvYellow,
      carSuvGrey;
  Uint8List craneBlue, craneRed, craneGreen, craneOrange, craneYellow,
      craneGrey;
  Uint8List userBlue, userRed, userGreen, userOrange, userYellow, userGrey;
  Uint8List petBlue, petRed, petGreen, petOrange, petYellow, petGrey;
  Uint8List jcbBlue, jcbRed, jcbGreen, jcbOrange, jcbYellow, jcbGrey;
  Uint8List tractorBlue, tractorRed, tractorGreen, tractorOrange, tractorYellow,
      tractorGrey;
  Uint8List longTruckBlue, longTruckRed, longTruckGreen, longTruckOrange,
      longTruckYellow, longTruckGrey;
  Uint8List smallTruckBlue, smallTruckRed, smallTruckGreen, smallTruckOrange,
      smallTruckYellow, smallTruckGrey;
  Uint8List generatorBlue, generatorRed, generatorGreen, generatorOrange,
      generatorYellow, generatorGrey;
  Uint8List rickshawBlue, rickshawRed, rickshawGreen, rickshawOrange,
      rickshawYellow, rickshawGrey;
  Uint8List ambulanceBlue, ambulanceRed, ambulanceGreen, ambulanceOrange,
      ambulanceYellow, ambulanceGrey;
  Uint8List boatBlue, boatRed, boatGreen, boatOrange, boatYellow, boatGrey;
  Uint8List locationIcon;

  bool firstBool = false;

  List<LatLng> listOfLatLog = [];
  var lat = 0.0,
      lng = 0.0;

  final List<Marker> _markers = <Marker>[];
  Set<Marker> _markers2 = Set<Marker>();
  Animation<double> _animation;

  AnimationController animationController;
  bool traffic = false;

  final _mapMarkerSC = StreamController<List<Marker>>();

  GeofencesProvider _geofencesProvider;
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool mayTypeChange = false;
  MapType mapType = MapType.normal;
  double currentZoom = 16.0;

  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;

  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;
  double bearing;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..repeat(reverse: true);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: false);

    if (widget.vehicleLisDevice.lastLocation != null) {
      lat = widget.vehicleLisDevice.lastLocation.lat;
      lng = widget.vehicleLisDevice.lastLocation.long;

      listOfLatLog.add(
        LatLng(
          widget.vehicleLisDevice.lastLocation.lat,
          widget.vehicleLisDevice.lastLocation.long,
        ),
      );

      // if (widget.vehicleLisDevice.status == "RUNNING") {
        listOfLatLog.add(
          LatLng(
            widget.vehicleLisDevice.secLastLocation.lat,
            widget.vehicleLisDevice.secLastLocation.long,
          ),
        );
        startMarker();
      // }
      getAddress();
      createMarker();
    }

  }

  @override
  void dispose() {
    socket.dispose();
    if(animationController !=null) {
      animationController.dispose();
    }
    mapController.dispose();
    _mapMarkerSC.isClosed;
    _mapMarkerSC.close();
    socket.close();
    socket.ondisconnect();
    socket.disconnect();
    socket.destroy();
    socket.clearListeners();
    socket.dispose();
    _controller.dispose();
    socketModelClass = null;
    super.dispose();
  }

  startMarker() {
    int i = 0;
    setState(() {
      print(_markers.length);
    });


    print("car location here");

    print(listOfLatLog[i].latitude);
    print(listOfLatLog[i].longitude);
    print(listOfLatLog[i + 1].latitude);
    print(listOfLatLog[i + 1].longitude);

    if (socketModelClass != null) {
      animateCar(
        listOfLatLog[i].latitude,
        listOfLatLog[i].longitude,
        listOfLatLog[i + 1].latitude,
        listOfLatLog[i + 1].longitude,
        // _mapMarkerSink,
        this,
        mapController,
      );
    }
  }

  connectSocketIo() {
    socket = IO.io('https://www.oneqlik.in/gps', <String, dynamic>{
      "secure": true,
      "rejectUnauthorized": false,
      "transports": ["websocket", "polling"],
      "upgrade": false
    });
    socket.connect();

    socket.onConnect((data) {
      print("Socket is connected");
      print("widget.vDeviceId==>>>> ${widget.vDeviceId}");
      socket.emit("acc", "${widget.vDeviceId}");

      socket.on("${widget.vDeviceId}acc", (data) async {
        if (data[3] != null) {
          var resonance = data[3];
          setState(() {
            socketModelClass = SocketModelClass.fromJson(resonance);
          });

          print("IconType ${socketModelClass.iconType}");
          print("StatUs ${socketModelClass.status}");

          lat = socketModelClass.lastLocation.lat;
          lng = socketModelClass.lastLocation.long;

          if (socketModelClass.lastLocation != null) {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              socketModelClass.lastLocation.lat,
              socketModelClass.lastLocation.long,);
            LatLng lng = LatLng(socketModelClass.lastLocation.lat,
                socketModelClass.lastLocation.long);
            // print("$data");
            setState(() {
              if (firstBool) {
                if (listOfLatLog.length == 2) {
                  listOfLatLog.removeAt(0);

                  print("listoflatLon");
                  print(listOfLatLog);
                  if (listOfLatLog.last != lng) {
                    listOfLatLog.add(lng);
                    startMarker();
                  } else {
                    print("getting same location");
                  }
                } else {
                  listOfLatLog.add(lng);
                }

                address = "${placemarks.first.name}"
                    " ${placemarks.first.subLocality}"
                    " ${placemarks.first.locality}"
                    " ${placemarks.first.subAdministrativeArea} "
                    "${placemarks.first.administrativeArea},"
                    "${placemarks.first.postalCode}";
              } else {
                if (widget.vehicleLisDevice.lastLocation == null) {
                  mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                            socketModelClass.lastLocation.lat,
                            socketModelClass.lastLocation.long
                        ),
                        zoom: _zoomLevel,
                      ),
                    ),
                  );
                }
                else {
                  restoreZoomLevel();
                }
              }
              isLoading = false;
            });

          }
        }
      });
    });
  }

  void restoreZoomLevel() async {
    double currentZoom = await mapController
        .getZoomLevel(); // Retrieve the current zoom level
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              widget.vehicleLisDevice.lastLocation.lat,
              widget.vehicleLisDevice.lastLocation.long
          ),
          zoom: currentZoom, // Restore the previous zoom level
        ),
      ),
    );
  }

  createMarker() async {
    setState(() {
      isMarkerLoad = true;
    });
    longTruckBlue = await getBytesFromAsset(
        'assets/images/marker/longTruckMarker/longTruckBlue.png',
        Size(40, 90));
    longTruckGreen = await getBytesFromAsset(
        'assets/images/marker/longTruckMarker/longTruckGreen.png',
        Size(40, 90));
    longTruckOrange = await getBytesFromAsset(
        'assets/images/marker/longTruckMarker/longTruckOrange.png',
        Size(40, 90));
    longTruckGrey = await getBytesFromAsset(
        'assets/images/marker/longTruckMarker/longTruckGrey.png',
        Size(40, 90));
    longTruckRed = await getBytesFromAsset(
        'assets/images/marker/longTruckMarker/longTruckRed.png',
        Size(40, 90));
    longTruckYellow = await getBytesFromAsset(
        'assets/images/marker/longTruckMarker/longTruckYellow.png',
        Size(40, 90));

    d.log('hello==============>');
    busRed =
    await getBytesFromAsset(
        'assets/images/marker/busMarker/busPink.png', Size(80, 90));
    busBlue =
    await getBytesFromAsset(
        'assets/images/marker/busMarker/busBlue.png', Size(80, 90));
    busGreen =
    await getBytesFromAsset(
        'assets/images/marker/busMarker/busGreen.png', Size(80, 90));
    busOrange =
    await getBytesFromAsset(
        'assets/images/marker/busMarker/busOrange.png', Size(80, 90));
    busYellow =
    await getBytesFromAsset(
        'assets/images/marker/busMarker/busYello.png', Size(80, 90));
    busGrey =
    await getBytesFromAsset(
        'assets/images/marker/busMarker/busGrey.png', Size(80, 90));


    carBlue =
    await getBytesFromAsset(
        'assets/images/marker/carMarker/carBule.png', Size(100, 110));
    carGreen =
    await getBytesFromAsset(
        'assets/images/marker/carMarker/carGreen.png', Size(100, 110));
    carOrange =
    await getBytesFromAsset(
        'assets/images/marker/carMarker/carOrange.png', Size(100, 110));
    carGrey =
    await getBytesFromAsset(
        'assets/images/marker/carMarker/carGrey.png', Size(100, 110));
    carRed =
    await getBytesFromAsset(
        'assets/images/marker/carMarker/carRed.png', Size(100, 110));
    carYellow =
    await getBytesFromAsset(
        'assets/images/marker/carMarker/carYello.png', Size(100, 110));


    scooterBlue = await getBytesFromAsset(
        'assets/images/marker/scootyMarker/sccotyBlue.png', Size(100, 110));
    scooterOrange = await getBytesFromAsset(
        'assets/images/marker/scootyMarker/sccotyOrange.png', Size(100, 110));
    scooterRed =
    await getBytesFromAsset(
        'assets/images/marker/scootyMarker/sccotyRed.png', Size(100, 110));
    scooterYellow = await getBytesFromAsset(
        'assets/images/marker/scootyMarker/sccotyYellow.png', Size(100, 110));
    scooterGreen = await getBytesFromAsset(
        'assets/images/marker/scootyMarker/scootyGreen.png', Size(100, 110));
    scooterGrey = await getBytesFromAsset(
        'assets/images/marker/scootyMarker/scootyGrey.png', Size(100, 110));


    bikeBlue =
    await getBytesFromAsset(
        'assets/images/marker/bikeMarker/bikeBlue.png', Size(100, 110));
    bikeGreen =
    await getBytesFromAsset(
        'assets/images/marker/bikeMarker/bikeGreen.png', Size(100, 110));
    bikeOrange =
    await getBytesFromAsset(
        'assets/images/marker/bikeMarker/bikeOrange.png', Size(100, 110));
    bikeRed =
    await getBytesFromAsset(
        'assets/images/marker/bikeMarker/bikeRed.png', Size(100, 110));
    bikeYellow =
    await getBytesFromAsset(
        'assets/images/marker/bikeMarker/bikeYellow.png', Size(100, 110));
    bikeGrey =
    await getBytesFromAsset(
        'assets/images/marker/bikeMarker/bikeGrey.png', Size(100, 110));


    carSuvBlue = await getBytesFromAsset(
        'assets/images/marker/carsuvMarker/carsuvBlue.png', Size(100, 110));
    carSuvGreen = await getBytesFromAsset(
        'assets/images/marker/carsuvMarker/carsuvGreen.png', Size(100, 110));
    carSuvOrange = await getBytesFromAsset(
        'assets/images/marker/carsuvMarker/carsuvOrange.png', Size(100, 110));
    carSuvGrey = await getBytesFromAsset(
        'assets/images/marker/carsuvMarker/carsuvGrey.png', Size(100, 110));
    carSuvRed =
    await getBytesFromAsset(
        'assets/images/marker/carsuvMarker/carsuvRed.png', Size(100, 110));
    carSuvYellow = await getBytesFromAsset(
        'assets/images/marker/carsuvMarker/carsuvYellow.png', Size(100, 110));


    craneBlue =
    await getBytesFromAsset(
        'assets/images/marker/craneMarker/craneBlue.png', Size(100, 110));
    craneGreen =
    await getBytesFromAsset(
        'assets/images/marker/craneMarker/craneGreen.png', Size(100, 110));
    craneOrange = await getBytesFromAsset(
        'assets/images/marker/craneMarker/craneOrange.png', Size(100, 110));
    craneGrey =
    await getBytesFromAsset(
        'assets/images/marker/craneMarker/craneGrey.png', Size(100, 110));
    craneRed =
    await getBytesFromAsset(
        'assets/images/marker/craneMarker/craneRed.png', Size(100, 110));
    craneYellow = await getBytesFromAsset(
        'assets/images/marker/craneMarker/craneYellow.png', Size(100, 110));


    userBlue =
    await getBytesFromAsset(
        'assets/images/marker/userMarker/userBlue.png', Size(100, 110));
    userGreen =
    await getBytesFromAsset(
        'assets/images/marker/userMarker/userGreen.png', Size(100, 110));
    userOrange =
    await getBytesFromAsset(
        'assets/images/marker/userMarker/userOrange.png', Size(100, 110));
    userGrey = await getBytesFromAsset(
        'assets/images/vehicle/userIcons/user_nodata_ic.png', Size(100, 110));
    userRed =
    await getBytesFromAsset(
        'assets/images/marker/userMarker/userRed.png', Size(100, 110));
    userYellow =
    await getBytesFromAsset(
        'assets/images/marker/userMarker/userYellow.png', Size(100, 110));


    petBlue =
    await getBytesFromAsset(
        'assets/images/marker/petMarker/petBlue.png', Size(100, 110));
    petGreen =
    await getBytesFromAsset(
        'assets/images/marker/petMarker/petGreen.png', Size(100, 110));
    petOrange =
    await getBytesFromAsset(
        'assets/images/marker/petMarker/petOrange.png', Size(100, 110));
    petGrey =
    await getBytesFromAsset(
        'assets/images/vehicle/petIcons/pet_nodata_ic.png', Size(100, 110));
    petRed =
    await getBytesFromAsset(
        'assets/images/marker/petMarker/petRed.png', Size(100, 110));
    petYellow =
    await getBytesFromAsset(
        'assets/images/marker/petMarker/petYellow.png', Size(100, 110));


    jcbBlue =
    await getBytesFromAsset(
        'assets/images/marker/jcbMarker/jcbBlue.png', Size(100, 110));
    jcbGreen =
    await getBytesFromAsset(
        'assets/images/marker/jcbMarker/jcbGreen.png', Size(100, 110));
    jcbOrange =
    await getBytesFromAsset(
        'assets/images/marker/jcbMarker/jcbOrange.png', Size(100, 110));
    jcbGrey =
    await getBytesFromAsset(
        'assets/images/marker/jcbMarker/jcbGrey.png', Size(100, 110));
    jcbRed =
    await getBytesFromAsset(
        'assets/images/marker/jcbMarker/jcbRed.png', Size(100, 110));
    jcbYellow =
    await getBytesFromAsset(
        'assets/images/marker/jcbMarker/jcbYellow.png', Size(100, 110));


    tractorBlue = await getBytesFromAsset(
        'assets/images/marker/tractorMarker/tractorBlue.png', Size(100, 110));
    tractorGreen = await getBytesFromAsset(
        'assets/images/marker/tractorMarker/tractorGreen.png', Size(100, 110));
    tractorOrange = await getBytesFromAsset(
        'assets/images/marker/tractorMarker/tractorOrange.png', Size(100, 110));
    tractorGrey = await getBytesFromAsset(
        'assets/images/marker/tractorMarker/tractorGrey.png', Size(100, 110));
    tractorRed = await getBytesFromAsset(
        'assets/images/marker/tractorMarker/tractorRed.png', Size(100, 110));
    tractorYellow = await getBytesFromAsset(
        'assets/images/marker/tractorMarker/tractorYellow.png', Size(100, 110));
    smallTruckBlue = await getBytesFromAsset(
        'assets/images/marker/smallTruckMarker/smallTruckBlue.png',
        Size(40, 90));
    smallTruckGreen = await getBytesFromAsset(
        'assets/images/marker/smallTruckMarker/smallTruckGreen.png',
        Size(40, 90));
    smallTruckOrange = await getBytesFromAsset(
        'assets/images/marker/smallTruckMarker/smallTruckOrange.png',
        Size(10, 90));
    smallTruckGrey = await getBytesFromAsset(
        'assets/images/marker/smallTruckMarker/smallTruckGrey.png',
        Size(40, 90));
    smallTruckRed = await getBytesFromAsset(
        'assets/images/marker/smallTruckMarker/smallTruckRed.png',
        Size(40, 90));
    smallTruckYellow = await getBytesFromAsset(
        'assets/images/marker/smallTruckMarker/smallTruckYellow.png',
        Size(40, 90));

    generatorBlue = await getBytesFromAsset(
        'assets/images/marker/generatorMarker/genratorBlue.png',
        Size(100, 110));
    generatorGreen = await getBytesFromAsset(
        'assets/images/marker/generatorMarker/genratorGreen.png',
        Size(100, 110));
    generatorOrange = await getBytesFromAsset(
        'assets/images/marker/generatorMarker/genratorOrange.png',
        Size(100, 110));
    generatorGrey = await getBytesFromAsset(
        'assets/images/marker/generatorMarker/genratorGrey.png',
        Size(100, 110));
    generatorRed = await getBytesFromAsset(
        'assets/images/marker/generatorMarker/genratorRed.png', Size(100, 110));
    generatorYellow = await getBytesFromAsset(
        'assets/images/marker/generatorMarker/genratorYellow.png',
        Size(100, 110));

    rickshawBlue = await getBytesFromAsset(
        'assets/images/marker/rickshawMarker/ricshowBlue.png', Size(100, 110));
    rickshawGreen = await getBytesFromAsset(
        'assets/images/marker/rickshawMarker/ricshowGreen.png', Size(100, 110));
    rickshawOrange = await getBytesFromAsset(
        'assets/images/marker/rickshawMarker/ricshowOrange.png',
        Size(100, 110));
    rickshawGrey = await getBytesFromAsset(
        'assets/images/marker/rickshawMarker/ricshowGrey.png', Size(100, 110));
    rickshawRed = await getBytesFromAsset(
        'assets/images/marker/rickshawMarker/ricshowRed.png', Size(100, 110));
    rickshawYellow = await getBytesFromAsset(
        'assets/images/marker/rickshawMarker/ricshowYellow.png',
        Size(100, 110));

    ambulanceBlue = await getBytesFromAsset(
        'assets/images/marker/ambulanceMarker/ambulanceBlue.png',
        Size(100, 110));
    ambulanceGreen = await getBytesFromAsset(
        'assets/images/marker/ambulanceMarker/ambulanceGreen.png',
        Size(100, 110));
    ambulanceOrange = await getBytesFromAsset(
        'assets/images/marker/ambulanceMarker/ambulanceOrange.png',
        Size(100, 110));
    ambulanceGrey = await getBytesFromAsset(
        'assets/images/marker/ambulanceMarker/ambulanceGrey.png',
        Size(100, 110));
    ambulanceRed = await getBytesFromAsset(
        'assets/images/marker/ambulanceMarker/ambulanceRed.png',
        Size(100, 110));
    ambulanceYellow = await getBytesFromAsset(
        'assets/images/marker/ambulanceMarker/ambulanceYellow.png',
        Size(100, 110));

    boatBlue =
    await getBytesFromAsset(
        'assets/images/marker/boatMarker/boatBlue.png', Size(100, 110));
    boatGreen =
    await getBytesFromAsset(
        'assets/images/marker/boatMarker/boatGreen.png', Size(100, 110));
    boatOrange =
    await getBytesFromAsset(
        'assets/images/marker/boatMarker/boatOrange.png', Size(100, 110));
    boatGrey =
    await getBytesFromAsset(
        'assets/images/marker/boatMarker/boatGrey.png', Size(100, 110));
    boatRed =
    await getBytesFromAsset(
        'assets/images/marker/boatMarker/boatRed.png', Size(100, 110));
    boatYellow =
    await getBytesFromAsset(
        'assets/images/marker/boatMarker/boatYellow.png', Size(100, 110));

    locationIcon =
    await getBytesFromAsset('assets/images/location.png', Size(100, 110));

    if (widget.vehicleLisDevice.status == "RUNNING") {
      addMarkersRunningStatus();
      setState(() {
        isMarkerLoad = false;
      });


    } else {
      addMarkers();
      setState(() {
        isMarkerLoad = false;
      });


    }

    connectSocketIo();
  }

  Future<Uint8List> getBytesFromAsset(String path, Size size) async {

    ByteData data = await rootBundle.load(path);

    return data.buffer.asUint8List();
    // ByteData data = await rootBundle.load(path);
    // ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
    //     targetWidth: size.width.toInt(), targetHeight: size.height.toInt());
    // ui.FrameInfo fi = await codec.getNextFrame();
    // return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
    //     .buffer
    //     .asUint8List();
  }


  animateCar(double fromLat,
      double fromLong,
      double toLat,
      double toLong,
      TickerProvider provider,
      GoogleMapController controller,
      ) async {
    bearing = getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));

    animationController = AnimationController(
      duration: const Duration(seconds: 4), //Animation duration of marker
      vsync: provider, //From the widget
    );

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController)
      ..addListener(() async {
        final v = _animation.value;
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newPos, zoom: _zoomLevel)));
        if (isRouteShow)
          Future.delayed(
            Duration(milliseconds: 400),
                () {
              stepPolyLine(fromLat, fromLong, lat, lng, v);
            },
          );
        // //Removing old marker if present in the marker array
        if (_markers.contains("driverMarker")) _markers.remove("driverMarker");

        //New marker location
        var carMarkers = Marker(
          markerId: const MarkerId("driverMarker"),
          position: newPos,
          anchor: const Offset(0.5, 0.5),
          flat: true,
          rotation: bearing,
          draggable: false,

          infoWindow: InfoWindow(title: "${widget.vehicleLisDevice.deviceName}",
            snippet: "$address",),
          icon: BitmapDescriptor.fromBytes(
              socketModelClass.status == "RUNNING" &&
                  socketModelClass.iconType == "bike"
                  ?
              bikeGreen
                  :
              socketModelClass.status == "IDLING" &&
                  socketModelClass.iconType == "bike"
                  ?
              bikeYellow
                  :
              socketModelClass.status == "OUT OF REACH" &&
                  socketModelClass.iconType == "bike"
                  ?
              bikeBlue
                  :
              socketModelClass.status == "Expired" &&
                  socketModelClass.iconType == "bike"
                  ?
              bikeOrange
                  :
              socketModelClass.status == "STOPPED" &&
                  socketModelClass.iconType == "bike"
                  ?
              bikeRed
                  :
              socketModelClass.status == "NO GPS FIX" &&
                  socketModelClass.iconType == "bike"
                  ?
              bikeGrey
                  :
              socketModelClass.status == "RUNNING" &&
                  socketModelClass.iconType == "car"
                  ?
              carGreen
                  :
              socketModelClass.status == "IDLING" &&
                  socketModelClass.iconType == "car"
                  ?
              carYellow
                  :
              socketModelClass.status == "OUT OF REACH" &&
                  socketModelClass.iconType == "car"
                  ?
              carBlue
                  :
              socketModelClass.status == "Expired" &&
                  socketModelClass.iconType == "car"
                  ?
              carOrange
                  :
              socketModelClass.status == "STOPPED" &&
                  socketModelClass.iconType == "car"
                  ?
              carRed
                  :
              socketModelClass.status == "NO GPS FIX" &&
                  socketModelClass.iconType == "car"
                  ?
              carGrey
                  :
              socketModelClass.status == "RUNNING" &&
                  socketModelClass.iconType == "truck"
                  ?
              longTruckGreen
                  :
              socketModelClass.status == "IDLING" &&
                  socketModelClass.iconType == "truck"
                  ?
              longTruckYellow
                  :
              socketModelClass.status == "OUT OF REACH" &&
                  socketModelClass.iconType == "truck"
                  ?
              longTruckBlue
                  :
              socketModelClass.status == "Expired" &&
                  socketModelClass.iconType == "truck"
                  ?
              longTruckOrange
                  :
              socketModelClass.status == "STOPPED" &&
                  socketModelClass.iconType == "truck"
                  ?
              longTruckRed
                  :
              socketModelClass.status == "NO GPS FIX" &&
                  socketModelClass.iconType == "truck"
                  ?
              longTruckGrey
                  :
              socketModelClass.status == "RUNNING" &&
                  socketModelClass.iconType == "bus"
                  ?
              busGreen
                  :
              socketModelClass.status == "IDLING" &&
                  socketModelClass.iconType == "bus"
                  ?
              busYellow
                  :
              socketModelClass.status == "OUT OF REACH" &&
                  socketModelClass.iconType == "bus"
                  ?
              busBlue
                  :
              socketModelClass.status == "Expired" &&
                  socketModelClass.iconType == "bus"
                  ?
              busOrange
                  :
              socketModelClass.status == "STOPPED" && socketModelClass
                  .iconType == "bus"
                  ?
              busRed
                  :
              socketModelClass.status == "NO GPS FIX" && socketModelClass
                  .iconType == "bus"
                  ?
              busGrey
                  :
              socketModelClass.status == "RUNNING" &&
                  socketModelClass.iconType == "jcb"
                  ?
              jcbGreen
                  :
              socketModelClass.status == "IDLING" &&
                  socketModelClass.iconType == "jcb"
                  ?
              jcbYellow
                  :
              socketModelClass.status == "OUT OF REACH" &&
                  socketModelClass.iconType == "jcb"
                  ?
              jcbBlue
                  :
              socketModelClass.status == "Expired" &&
                  socketModelClass.iconType == "jcb"
                  ?
              jcbOrange
                  :
              socketModelClass.status == "STOPPED" &&
                  socketModelClass.iconType == "jcb"
                  ?
              jcbRed
                  :
              socketModelClass.status == "NO GPS FIX" &&
                  socketModelClass.iconType == "jcb"
                  ?
              jcbGrey
                  :
              socketModelClass.status == "RUNNING" &&
                  socketModelClass.iconType == "tractor"
                  ?
              tractorGreen
                  :
              socketModelClass.status == "IDLING" &&
                  socketModelClass.iconType == "tractor"
                  ?
              tractorYellow
                  :
              socketModelClass.status == "OUT OF REACH" &&
                  socketModelClass.iconType == "tractor"
                  ?
              tractorBlue
                  :
              socketModelClass.status == "Expired" &&
                  socketModelClass.iconType == "tractor"
                  ?
              tractorOrange
                  :
              socketModelClass.status == "STOPPED" &&
                  socketModelClass.iconType == "tractor"
                  ?
              tractorRed
                  :
              socketModelClass.status == "NO GPS FIX" &&
                  socketModelClass.iconType == "tractor"
                  ?
              tractorGrey
                  :
              socketModelClass.status == "RUNNING" &&
                  socketModelClass.iconType == "pickup"
                  ?
              smallTruckGreen
                  :
              socketModelClass.status == "IDLING" &&
                  socketModelClass.iconType == "pickup"
                  ?
              smallTruckYellow
                  :
              socketModelClass.status == "OUT OF REACH" &&
                  socketModelClass.iconType == "pickup"
                  ?
              smallTruckBlue
                  :
              socketModelClass.status == "Expired" &&
                  socketModelClass.iconType == "pickup"
                  ?
              smallTruckOrange
                  :
              socketModelClass.status == "STOPPED" &&
                  socketModelClass.iconType == "pickup"
                  ?
              smallTruckRed
                  :
              socketModelClass.status == "NO GPS FIX" &&
                  socketModelClass.iconType == "pickup"
                  ?
              smallTruckGrey
                  :
              socketModelClass.status == "RUNNING" &&
                  socketModelClass.iconType == "scooter"
                  ?
              scooterGreen
                  :
              socketModelClass.status == "IDLING" &&
                  socketModelClass.iconType == "scooter"
                  ?
              scooterYellow
                  :
              socketModelClass.status == "OUT OF REACH" &&
                  socketModelClass.iconType == "scooter"
                  ?
              scooterBlue
                  :
              socketModelClass.status == "Expired" &&
                  socketModelClass.iconType == "scooter"
                  ?
              scooterOrange
                  :
              socketModelClass.status == "STOPPED" &&
                  socketModelClass.iconType == "scooter"
                  ?
              scooterRed
                  :
              socketModelClass.status == "NO GPS FIX" &&
                  socketModelClass.iconType == "scooter"
                  ?
              scooterGrey
                  :
              socketModelClass.status == "RUNNING" &&
                  socketModelClass.iconType == "pet"
                  ?
              petGreen
                  :
              socketModelClass.status == "IDLING" &&
                  socketModelClass.iconType == "pet"
                  ?
              petYellow
                  :
              socketModelClass.status == "OUT OF REACH" &&
                  socketModelClass.iconType == "pet"
                  ?
              petBlue
                  :
              socketModelClass.status == "Expired" &&
                  socketModelClass.iconType == "pet"
                  ?
              petOrange
                  :
              socketModelClass.status == "STOPPED" &&
                  socketModelClass.iconType == "pet"
                  ?
              petRed
                  :
              socketModelClass.status == "NO GPS FIX" &&
                  socketModelClass.iconType == "pet"
                  ?
              petGrey
                  :

              socketModelClass.status == "RUNNING" &&
                  socketModelClass.iconType == "user"
                  ?
              userGreen
                  :
              socketModelClass.status == "IDLING" &&
                  socketModelClass.iconType == "user"
                  ?
              userYellow
                  :
              socketModelClass.status == "OUT OF REACH" &&
                  socketModelClass.iconType == "user"
                  ?
              userBlue
                  :
              socketModelClass.status == "Expired" &&
                  socketModelClass.iconType == "user"
                  ?
              userOrange
                  :
              socketModelClass.status == "STOPPED" &&
                  socketModelClass.iconType == "user"
                  ?
              userRed
                  :
              socketModelClass.status == "NO GPS FIX" &&
                  socketModelClass.iconType == "user"
                  ?
              userGrey
                  :
              locationIcon
          ),
        );

        //Adding new marker to our list and updating the google map UI.
        _markers.remove("driverMarker");
        _markers.add(carMarkers);
        print(_markers.length);

        await Future.delayed(const Duration(milliseconds: 500));
        _mapMarkerSink.add(_markers);



        //Moving the google camera to the new animated location.

      });

    //Starting the animation
    animationController.forward();
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return v.degrees(atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - v.degrees(atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return v.degrees(atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - v.degrees(atan(lng / lat))) + 270;
    }
    return -1;
  }

  getAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      widget.vehicleLisDevice.lastLocation.lat,
      widget.vehicleLisDevice.lastLocation.long,
    );

    address = "${placemarks.first.name}"
        " ${placemarks.first.subLocality}"
        " ${placemarks.first.locality}"
        " ${placemarks.first.subAdministrativeArea} "
        "${placemarks.first.administrativeArea},"
        "${placemarks.first.postalCode}";
  }

  addMarkers() async {

    final pickupMarker = Marker(
        markerId: const MarkerId("driverMarker"),
        position: LatLng(
          widget.vehicleLisDevice.lastLocation.lat,
          widget.vehicleLisDevice.lastLocation.long,
        ),
        icon: BitmapDescriptor.fromBytes(
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "bike"
                ?
            bikeGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "car"
                ?
            carGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "car"
                ?
            carYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "car"
                ?
            carBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "car"
                ?
            carOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "car"
                ?
            carRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "car"
                ?
            carGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "truck"
                ?
            longTruckGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "bus"
                ?
            busGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "bus"
                ?
            busYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "bus"
                ?
            busBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "bus"
                ?
            busOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "bus"
                ?
            busRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "bus"
                ?
            busGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "jcb"
                ?
            jcbRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" && widget
                .vehicleLisDevice.iconType == "jcb"
                ?
            jcbGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" && widget
                .vehicleLisDevice.iconType == "tractor"
                ?
            tractorGreen
                :
            widget.vehicleLisDevice.status == "IDLING" && widget
                .vehicleLisDevice.iconType == "tractor"
                ?
            tractorYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "tractor"
                ?
            tractorBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "tractor"
                ?
            tractorOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "tractor"
                ?
            tractorRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "tractor"
                ?
            tractorGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "pickup"
                ?
            smallTruckGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "scooter"
                ?
            scooterGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "pet"
                ?
            petGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "pet"
                ?
            petYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "pet"
                ?
            petBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "pet"
                ?
            petOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "pet"
                ?
            petRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "pet"
                ?
            petGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "user"
                ?
            userGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "user"
                ?
            userYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "user"
                ?
            userBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "user"
                ?
            userOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "user"
                ?
            userRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "user"
                ?
            userGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "auto"
                ?
            rickshawGrey
                :
            widget.vehicleLisDevice.status == "RUNNING" &&
                widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceGreen
                :
            widget.vehicleLisDevice.status == "IDLING" &&
                widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceYellow
                :
            widget.vehicleLisDevice.status == "OUT OF REACH" &&
                widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceBlue
                :
            widget.vehicleLisDevice.status == "Expired" &&
                widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceOrange
                :
            widget.vehicleLisDevice.status == "STOPPED" &&
                widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceRed
                :
            widget.vehicleLisDevice.status == "NO GPS FIX" &&
                widget.vehicleLisDevice.iconType == "ambulance"
                ?
            ambulanceGrey
                :
            locationIcon
        ),
        rotation: double.parse("${widget.vehicleLisDevice.heading ?? "0"}")
    );

    //  Adding a delay and then showing the marker on screen
    print("addMarkers()");
    await Future.delayed(const Duration(milliseconds: 500));
    _markers.clear();
    _markers.add(pickupMarker);
    _mapMarkerSink.add(_markers);
  }

  addMarkersRunningStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    print("addMarkersRunningStatus()");
    _mapMarkerSink.add(_markers);
  }

  openNearbyDialog() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: ApplicationColors.blackColor2E,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: ApplicationColors.appColors2,
                  height: 50,
                  child: Center(
                    child: Text(
                      "${getTranslated(context, "near_by")}",
                      style: FontStyleUtilities.h24().copyWith(
                          color: ApplicationColors.whiteColor,
                          fontSize: 18
                      ),
                    ),
                  ),
                ),

                // Divider(
                //   color: ApplicationColors.textfieldBorderColor,
                //   thickness: 1,
                // ),

                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),

                      InkWell(
                        onTap: () {
                          launch(
                            "https://www.google.com/maps/search/?api=1&query=ATMS+$address",
                          );
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/atm.png",
                              height: 25,
                              width: 25, color: ApplicationColors.appColors2,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "${getTranslated(context, "ATMS")}",
                              overflow:
                              TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontStyleUtilities.h14(
                                  fontweight: FWT.semiBold,
                                  fontColor: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      InkWell(
                        onTap: () {
                          launch(
                              "https://www.google.com/maps/search/?api=1&query=Petrol+pumps+$address");
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/hospital.png",
                              height: 25,
                              width: 25, color: ApplicationColors.appColors2,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "${getTranslated(context, "Petrol_Pumps")}",
                              overflow:
                              TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontStyleUtilities.h14(
                                  fontweight: FWT.semiBold,
                                  fontColor: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      InkWell(
                        onTap: () {
                          launch(
                              "https://www.google.com/maps/search/?api=1&query=Hospitals+$address");
                          //  launch("https://www.google.com/maps/search/?api=1&query=Hospitals&center=-33.712206%2C150.311941");
                          //  launch("https://www.google.com/maps/search/?api=1&query=47.5951518C-122.3316393");
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/hospital.png",
                              height: 25,
                              width: 25, color: ApplicationColors.appColors2,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "${getTranslated(context, "Hospitals")}",
                              overflow:
                              TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontStyleUtilities.h14(
                                  fontweight: FWT.semiBold,
                                  fontColor: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      InkWell(
                        onTap: () {
                          launch(
                              "https://www.google.com/maps/search/?api=1&query=Police+Stations+$address");
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/police.png",
                              height: 25,
                              width: 25, color: ApplicationColors.appColors2,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "${getTranslated(context, "Police_Stations")}",
                              overflow:
                              TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontStyleUtilities.h14(
                                  fontweight: FWT.semiBold,
                                  fontColor: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      InkWell(
                        onTap: () {
                          launch(
                              "https://www.google.com/maps/search/?api=1&query=Service+Points+$address");
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/servicePoint.png",
                              height: 25,
                              width: 25, color: ApplicationColors.appColors2,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "${getTranslated(context, "Service_Points")}",
                              overflow:
                              TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontStyleUtilities.h14(
                                  fontweight: FWT.semiBold,
                                  fontColor: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      InkWell(
                        onTap: () {
                          launch(
                              "https://www.google.com/maps/search/?api=1&query=Restaurants+$address");
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/hotel.png",
                              height: 25,
                              width: 25, color: ApplicationColors.appColors2,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "${getTranslated(context, "Restaurants")}",
                              overflow:
                              TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontStyleUtilities.h14(
                                  fontweight: FWT.semiBold,
                                  fontColor: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      InkWell(
                        onTap: () {
                          launch(
                              "https://www.google.com/maps/search/?api=1&query=Parking+$address");
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/parkingPont.png",
                              height: 25,
                              width: 25, color: ApplicationColors.appColors2,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "${getTranslated(context, "parking")}",
                              overflow:
                              TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontStyleUtilities.h14(
                                  fontweight: FWT.semiBold,
                                  fontColor: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),


                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    },
    );
  }

  addPoi() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "poi": [
        {
          "location": {
            "type": "Point",
            "coordinates": [
              lat, lng
            ]
          },
          "poiname": nameController.text,
          "status": "Active",
          "user": id,
          "radius": 30.0,
          "entering": true,
          "exiting": true
        }
      ],
      "halt_notif": true,
      "halt_time": "60"
    };

    print('addGeofenceCircle-->${jsonEncode(data)}');

    _geofencesProvider.addGeofenceCircle(data, "poi/addpoi", context);
  }

  reLoad() async {
    Map<String, dynamic> data = {
      "deviceId": widget.vDeviceId ?? "004170614484"
    };

    var response = await CallApi().getDataAsParams(
        data, "devices/getDevicebyID");
    var body = json.decode(response.body);

    print("reload $body");

    if (response.statusCode == 200) {
      if (body != null) {
        var resonance = body;
        connectSocketIo();
        setState(() {
          socketModelClass = SocketModelClass.fromJson(resonance);
        });

        print("IconType ${socketModelClass.iconType}");
        print("StatUs ${socketModelClass.status}");

        lat = socketModelClass.lastLocation.lat;
        lng = socketModelClass.lastLocation.long;

        if (socketModelClass.lastLocation != null) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            socketModelClass.lastLocation.lat,
            socketModelClass.lastLocation.long,
          );

          LatLng lng = LatLng(socketModelClass.lastLocation.lat,
              socketModelClass.lastLocation.long);
          mapController.moveCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: lng, zoom: _zoomLevel)));
          // print("$data");
          setState(() {
            if (firstBool) {
              if (listOfLatLog.length == 2) {
                listOfLatLog.removeAt(0);
                print("listoflatLon");
                print(listOfLatLog);
                if (listOfLatLog.last != lng) {
                  listOfLatLog.add(lng);
                  startMarker();
                } else {
                  print("getting same location");
                }
              } else {
                listOfLatLog.add(lng);
              }

              address = "${placemarks.first.name}"
                  " ${placemarks.first.subLocality}"
                  " ${placemarks.first.locality}"
                  " ${placemarks.first.subAdministrativeArea} "
                  "${placemarks.first.administrativeArea},"
                  "${placemarks.first.postalCode}";
            } else {
              if (widget.vehicleLisDevice.lastLocation == null) {
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(0, 0),
                      zoom: _zoomLevel,
                    ),
                  ),
                );
              }
              else {
                restoreZoomLevel();
              }
            }
            isLoading = false;
          });
        }
      }



    }
  }

  showAddPoiDialog() {
    showDialog(
      context: context,
      builder: (context) {
        var width = MediaQuery
            .of(context)
            .size
            .width;
        var height = MediaQuery
            .of(context)
            .size
            .height;
        addressController.text = address;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                color: ApplicationColors.blackColor2E,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: ApplicationColors.blackColor2E, width: 2),
              ),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 10, top: 10),
                      child: Text(
                        "${getTranslated(context, "add_poi")}",
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: FontStyleUtilities.h24().copyWith(
                            color: ApplicationColors.whiteColor,
                            fontSize: 22
                        ),
                      ),
                    ),

                    Divider(
                      color: ApplicationColors.textfieldBorderColor,
                      thickness: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.03),
                          CustomTextField(
                            controller: nameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "${getTranslated(
                                    context, "enter_poi_name")}";
                              }
                              return null;
                            },
                            textAlign: TextAlign.start,
                            hintText: "${getTranslated(context, "name_*")}",

                          ),
                          SizedBox(height: height * 0.025),
                          CustomTextField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "${getTranslated(
                                    context, "enter_address")}";
                              }
                              return null;
                            },
                            textAlign: TextAlign.start,
                            controller: addressController,
                            hintText: "${getTranslated(context, "address")}",
                          ),
                          SizedBox(height: height * 0.02),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SimpleElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttonName: "${getTranslated(
                                      context, "cancel")}",
                                  style: FontStyleUtilities.s18(
                                      fontColor: ApplicationColors.whiteColor),
                                  fixedSize: Size(118, 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: ApplicationColors.redColor67,
                                ),
                                SizedBox(width: width * 0.025),
                                SimpleElevatedButton(
                                  onPressed: () {
                                    if (key.currentState.validate()) {
                                      addPoi();
                                    }
                                  },
                                  buttonName: "${getTranslated(
                                      context, "add_poi")}",
                                  style: FontStyleUtilities.s18(
                                      fontColor: ApplicationColors.whiteColor),
                                  fixedSize: Size(118, 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: ApplicationColors.redColor67,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AnimationController _controller;
  void onCameraMove(CameraPosition position) {
    setState(() {
      currentZoom = position.zoom; // Update the current zoom level whenever the camera position changes
    });
  }
  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: true);
    _geofencesProvider = Provider.of<GeofencesProvider>(context, listen: true);

    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;

    return
      Scaffold(
        extendBody: true,

        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              // _userProvider.changeBottomIndex(0);
            },
            child: Icon(
              Icons.arrow_back_sharp,
              color: ApplicationColors.white9F9,
              size: 26,
            ),
          ),
          title: Text("Live For ${widget.vehicleLisDevice.deviceName}",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Arial',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  Color(0xffd21938),
                  Color(0xff751c1e),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: BottomAppBar(
            notchMargin: 8,
            color: ApplicationColors.whiteColorF9,

          shape: CircularNotchedRectangle(),
          child: IntrinsicHeight(
            child: DraggableBottomSheet(
              previewWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ApplicationColors.whiteColorF9,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "${getTranslated(
                                context, "last_updated")}",
                            style: FontStyleUtilities.h12(
                              fontColor: Colors.blue,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: isLoading
                                    ? ' : ${DateFormat(
                                    "MMM dd yyyy hh:mm:ss aa").format(
                                    widget.vehicleLisDevice.lastPingOn
                                        .toLocal())}'
                                    : ' : ${DateFormat(
                                    "MMM dd yyyy hh:mm:ss aa").format(
                                    socketModelClass.lastPingOn
                                        .toLocal())}',
                                style: FontStyleUtilities.h12(
                                  fontColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                "assets/images/Battery.png",
                                width: 10,
                                // color: isLoading
                                //?
                                color: widget.vehicleLisDevice
                                    .batteryPercent ==
                                    ""
                                    ? ApplicationColors.greyC4C4
                                    : widget.vehicleLisDevice
                                    .batteryPercent ==
                                    "0"
                                    ? ApplicationColors
                                    .redColor67
                                    : ApplicationColors
                                    .greenColor
                              //   :
                              // socketModelClass.temp == "" ? ApplicationColors.greyC4C4 : socketModelClass.temp == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "${getTranslated(context, "battery")} (${widget
                                  .vehicleLisDevice.batteryPercent == null ||
                                  widget.vehicleLisDevice.batteryPercent ==
                                      "NaN" ? '0' : widget.vehicleLisDevice
                                  .batteryPercent}%)",
                              overflow: TextOverflow.ellipsis,
                              style: Textstyle1.text12b
                                  .copyWith(fontSize: 8),
                            )
                          ],
                        ),
                      ],
                    ),

                      Row(
                        children: [
                          // Expanded(
                          //   child: Row(
                          //     children: [
                          //
                          //
                          //       Expanded(
                          //         child: Padding(
                          //           padding: const EdgeInsets.only(left: 8.0),
                          //           child: Text(
                          //               isLoading ? "${widget.vehicleLisDevice
                          //                   .deviceName}" : "${socketModelClass
                          //                   .deviceName}",
                          //               overflow: TextOverflow.fade,
                          //               maxLines: 2,
                          //               textAlign: TextAlign.start,
                          //               style: FontStyleUtilities.s16(
                          //                   fontColor: ApplicationColors
                          //                       .black4240
                          //               )
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Row(
                          //   children: [
                          //
                          //     Text(
                          //         isLoading
                          //             ? "  ${widget.vehicleLisDevice.totalOdo
                          //             .round()} ${getTranslated(context, "Km")}"
                          //             : "  ${socketModelClass.totalOdo
                          //             .round()} ${getTranslated(
                          //             context, "Km")}",
                          //         overflow: TextOverflow.visible,
                          //         maxLines: 1,
                          //         textAlign: TextAlign.start,
                          //         style: FontStyleUtilities.s16(
                          //             fontColor: ApplicationColors.black4240
                          //         )
                          //     ),
                          //   ],
                          // ),

                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  SizedBox(
                                    width: width * 0.6,
                                    child: Text(
                                      '${widget.vehicleLisDevice.address}',
                                      overflow: TextOverflow.visible,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      style: FontStyleUtilities.h12(
                                          fontColor: ApplicationColors.black4240
                                      ),
                                    ),
                                  ),

                                ],
                              ),

                            ],
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (BuildContext context) =>
                          //                 LiveForVehicleScreenTwo(
                          //                   vDeviceId: widget.vDeviceId,
                          //                   vehicleLisDevice: widget
                          //                       .vehicleLisDevice,
                          //                   vId: widget.vId,
                          //                 )
                          //         )
                          //     );
                          //   },
                          //   child: Container(
                          //     width: 48,
                          //     height: 48,
                          //     padding: EdgeInsets.all(10),
                          //     child: Image.asset(
                          //         "assets/images/car_repair_ic.png"
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: ApplicationColors.redColor67,
                          //       borderRadius: BorderRadius.circular(5),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),

                    ],
                  ),
                ),
                expandedWidget: Container(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 18)
                        .copyWith(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ApplicationColors.whiteColorF9,
                    ),
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "${getTranslated(
                                      context, "last_updated")}",
                                  style: FontStyleUtilities.h12(
                                    fontColor: Colors.blue,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: isLoading
                                          ? ' : ${DateFormat(
                                          "MMM dd yyyy hh:mm:ss aa").format(
                                          widget.vehicleLisDevice.lastPingOn
                                              .toLocal())}'
                                          : ' : ${DateFormat(
                                          "MMM dd yyyy hh:mm:ss aa").format(
                                          socketModelClass.lastPingOn
                                              .toLocal())}',
                                      style: FontStyleUtilities.h12(
                                        fontColor: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ), Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      "assets/images/Battery.png",
                                      width: 10,
                                      // color: isLoading
                                      //?
                                      color: widget.vehicleLisDevice
                                          .batteryPercent ==
                                          ""
                                          ? ApplicationColors.greyC4C4
                                          : widget.vehicleLisDevice
                                          .batteryPercent ==
                                          "0"
                                          ? ApplicationColors
                                          .redColor67
                                          : ApplicationColors
                                          .greenColor
                                    //   :
                                    // socketModelClass.temp == "" ? ApplicationColors.greyC4C4 : socketModelClass.temp == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "${getTranslated(
                                        context, "battery")} (${widget
                                        .vehicleLisDevice.batteryPercent ==
                                        null ||
                                        widget.vehicleLisDevice
                                            .batteryPercent ==
                                            "NaN" ? '0' : widget
                                        .vehicleLisDevice
                                        .batteryPercent}%)",
                                    overflow: TextOverflow.ellipsis,
                                    style: Textstyle1.text12b
                                        .copyWith(fontSize: 8),
                                  )
                                ],
                              ),
                            ],
                          ),
                          // SizedBox(height: 20),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Row(
                          //         children: [
                          //           Image.asset(
                          //             "assets/images/car_icon.png", height: 15,
                          //             width: 15,
                          //             color: ApplicationColors.redColor67,),
                          //
                          //           Text(
                          //               isLoading
                          //                   ? "  ${widget.vehicleLisDevice
                          //                   .deviceName}"
                          //                   : "  ${socketModelClass
                          //                   .deviceName}",
                          //               overflow: TextOverflow.visible,
                          //               maxLines: 1,
                          //               textAlign: TextAlign.start,
                          //               style: FontStyleUtilities.s16(
                          //                   fontColor: ApplicationColors
                          //                       .black4240
                          //               )
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //
                          //     Row(
                          //       children: [
                          //         Image.asset(
                          //           "assets/images/vehicle_page_icon.png",
                          //           height: 18,
                          //           width: 18,
                          //           color: ApplicationColors.redColor67,),
                          //
                          //         Text(
                          //             isLoading
                          //                 ? "  ${widget.vehicleLisDevice
                          //                 .totalOdo.round()} ${getTranslated(
                          //                 context, "Km")}"
                          //                 : "  ${socketModelClass
                          //                 .totalOdo.round()} ${getTranslated(
                          //                 context, "Km")}",
                          //             overflow: TextOverflow.visible,
                          //             maxLines: 1,
                          //             textAlign: TextAlign.start,
                          //             style: FontStyleUtilities.s16(
                          //                 fontColor: ApplicationColors.black4240
                          //             )
                          //         ),
                          //       ],
                          //     ),
                          //
                          //   ],
                          // ),
                          // SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: [

                              SizedBox(
                                width: width * 0.6,
                                child: Text(
                                  '${widget.vehicleLisDevice.address}',
                                  overflow: TextOverflow.visible,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: FontStyleUtilities.h12(
                                      fontColor: ApplicationColors
                                          .black4240
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //
                          //
                          //
                          //       ],
                          //     ),
                          //     // InkWell(
                          //     //   onTap: () {
                          //     //     Navigator.push(
                          //     //         context,
                          //     //         MaterialPageRoute(
                          //     //             builder: (BuildContext context) =>
                          //     //                 LiveForVehicleScreenTwo(
                          //     //                   vDeviceId: widget.vDeviceId,
                          //     //                   vehicleLisDevice: widget
                          //     //                       .vehicleLisDevice,
                          //     //                   vId: widget.vId,
                          //     //                 )
                          //     //         )
                          //     //     );
                          //     //   },
                          //     //   child: Container(
                          //     //     width: 48,
                          //     //     height: 48,
                          //     //     padding: EdgeInsets.all(10),
                          //     //     child: Image.asset(
                          //     //         "assets/images/car_repair_ic.png"
                          //     //     ),
                          //     //     decoration: BoxDecoration(
                          //     //       color: ApplicationColors.redColor67,
                          //     //       borderRadius: BorderRadius.circular(5),
                          //     //     ),
                          //     //   ),
                          //     // ),
                          //   ],
                          // ),
                          SizedBox(height: 10),
                          Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.9,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: LiveForVehicleScreenTwo(
                              vDeviceId: widget.vDeviceId,
                              vehicleLisDevice: widget.vehicleLisDevice,
                              vId: widget.vId,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                minExtent: 165,
                maxExtent: MediaQuery
                    .of(context)
                    .size
                    .height,
                backgroundWidget: Container(color: Colors.white),),
            ),
          ),
        ),

        body: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: isMarkerLoad
              ?
          Helper.dialogCall.showLoader()
              : Stack(
            children: [
              Container(
                height: height,
                width: width,
                child: StreamBuilder<List<Marker>>(
                  stream: mapMarkerStream,
                  builder: (context, snapshot) {
                    final List<Marker> newMarkers = snapshot.data ?? [];
                    // Create a new set with the updated markers.
                    Set<Marker> updatedMarkers = Set<Marker>.from(newMarkers);
                    return GoogleMap(
                      zoomControlsEnabled: false,
                      trafficEnabled: traffic,
                      polylines: polylines,
                      onCameraMove: (position) {
                        setState(() {
                          _zoomLevel = position.zoom;
                        });
                      },
                      zoomGesturesEnabled: true,
                      initialCameraPosition: CameraPosition(
                        bearing: 90,
                        target: widget.vehicleLisDevice.lastLocation == null
                            ? LatLng(20.5937, 78.9629)
                            : LatLng(
                          widget.vehicleLisDevice.lastLocation.lat,
                          widget.vehicleLisDevice.lastLocation.long,
                        ),

                        zoom: widget.vehicleLisDevice.lastLocation == null
                            ? 5.0
                            : _zoomLevel,

                      ),
                      mapType: mayTypeChange ? mapType : Utils.mapType,
                      markers: updatedMarkers,

                      // Use the updated markers
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;
                          setState(() {
                            firstBool = true;
                          });
                        });
                      },
                    );
                  },
                ),
              ),
              Container(
                color: ApplicationColors.whiteColor,
                alignment: Alignment.center,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: ApplicationColors.redColor,
                              size: 35,
                            ),
                            SizedBox(
                                height: 4
                            ),
                            Container(
                              height: 2,
                              // width: 80,
                              color: ApplicationColors.redColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: InkWell(
                          onTap: () {


                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HistoryPage(

                                      deviceId: widget.vehicleLisDevice
                                          .deviceId,
                                      deviceName: widget.vehicleLisDevice
                                          .deviceName,
                                      formDate: fromDate,
                                      toDate: toDate,
                                      vId: widget.vId,

                                    ),
                              ),
                            );
                          },
                          child: Image.asset(
                            "assets/images/car_time.png",
                            color: ApplicationColors.redColor,
                            height: 30,
                            width: 30,
                          ),
                        )
                    ),
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TripReportScreen(
                                          deviceId: widget.vId,
                                          vName: widget.vehicleLisDevice
                                              .deviceName,
                                        )));
                          },
                          child: Image.asset(
                            "assets/images/user_trip.png",
                            color: ApplicationColors.redColor,
                            height: 30,
                            width: 30,
                          ),
                        )
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationScreen(
                                        vehicleLisDevice: widget
                                            .vehicleLisDevice,)));
                        },
                        child: Icon(Icons.notifications,
                          color: ApplicationColors.redColor, size: 35,),
                      ),
                    ),

                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MaintenanceReminderPage(
                                    deviceId: widget.vId,
                                    deviceName: widget.vehicleLisDevice
                                        .deviceName,),),);
                        },
                        child: Image.asset(
                          "assets/images/car_repair_ic.png",
                          color: ApplicationColors.redColor,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),


                  ],
                ),
              ),

              Positioned(
                top: 70,
                left: 15,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      mayTypeChange = true;
                    });

                    if (mapType == MapType.normal) {
                      mapType = MapType.hybrid;
                    } else if (mapType == MapType.satellite) {
                      mapType = MapType.terrain;
                    } else {
                      mapType = MapType.normal;
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xfffc0b40),
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(
                      "assets/images/direction_ic.png",
                      color: ApplicationColors.whiteColor,
                    ),

                  ),
                ),
              ),
              Positioned(
                top: 120,
                left: 15,
                child: InkWell(
                  onTap: () {
                    isRouteShow = !isRouteShow;
                    setState(() {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,

                    decoration: BoxDecoration(
                      color: Color(0xfffc0b40),
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                    isRouteShow ? Icons.route : Icons.route,
                    color: isRouteShow
                        ? ApplicationColors.greenColor
                        :  ApplicationColors.whiteColor,
                  ),

                  ),
                ),
              ),
              Positioned(
                top: 80,
                left: 160,
                child: FadeTransition(
                  opacity: _controller,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          isLoading
                              ?
                          widget.vehicleLisDevice.lastSpeed == null
                              ?
                          "0"
                              :
                          "${widget.vehicleLisDevice.lastSpeed}"
                              :
                          '${socketModelClass.lastSpeed}',
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: FontStyleUtilities.h18(
                              fontColor: Color(0xfff29ac2c)
                          )
                      ),
                      Text(
                        " ${_userProvider.useModel.cust.unitMeasurement == "MKS"
                            ? "${getTranslated(context, "km_h")}"
                            : "${getTranslated(context, "Miles_H")}"}",
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: FontStyleUtilities.h18(
                            fontColor: Color(0xfff29ac2c)
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 300,
                left: 15,
                right: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,

                          decoration: BoxDecoration(
                            color: Color(0xfffc0b40),
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.circular(5),
                          ),
                          child: InkWell(
                              onTap: () {
                                openNearbyDialog();
                              },
                              child: Icon(Icons.location_on_rounded,
                                color: ApplicationColors.whiteColor,
                                size: 18,
                              )
                          ),

                        ), SizedBox(height: 5),

                        Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ApplicationColors.redColor,
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.circular(5),
                          ),
                          child: InkWell(
                              onTap: () {
                                reLoad();
                              },
                              child: Image.asset(
                                "assets/images/refresh_ic.png",
                                color: ApplicationColors.whiteColor,
                              )
                          ),

                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ApplicationColors.redColor,
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.circular(5),
                          ),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  traffic = !traffic;
                                });
                              },
                              child: Image.asset(
                                "assets/images/traffic-light.png",
                                color: ApplicationColors.whiteColor,
                              )
                          ),
                        ),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            launch(
                                "https://www.google.com/maps/dir/?api=1&origin=${Utils
                                    .lat},${Utils
                                    .lng}&destination=$lat,$lng&travelmode=driving");
                            // new SimpleDialog(
                            //   title: Container(color:ApplicationColors.blackColor2E,height: 30, ),
                            //   children: <Widget>[
                            //     new RadioListTile(
                            //       title: new Text('Testing'), value: null, groupValue: null, onChanged: (value) {},
                            //     )
                            //   ],
                            // );

                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ApplicationColors.redColor,
                              shape: BoxShape.circle,
                              // borderRadius: BorderRadius.circular(5),
                            ),
                            child: Image.asset(
                              "assets/images/near-me.png",
                              color: ApplicationColors.whiteColor,
                            ),

                          ),
                        ),
                        SizedBox(height: 5,),


                      ],
                    ),

                  ],
                ),
              ),

              Positioned(
                  top: 300,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target:
                                  isLoading
                                      ?
                                  widget.vehicleLisDevice.lastLocation == null
                                      ?
                                  LatLng(20.5937, 78.9629)
                                      :
                                  LatLng(
                                      widget.vehicleLisDevice.lastLocation.lat,
                                      widget.vehicleLisDevice.lastLocation.long
                                  )
                                      :
                                  LatLng(lat, lng),
                                  zoom: widget.vehicleLisDevice.lastLocation ==
                                      null
                                      ? 05
                                      : 16,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: ApplicationColors.redColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                    "assets/images/current_location_ic.png"),
                              ),
                            ],
                          ),
                        ), SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            mapController.animateCamera(CameraUpdate.zoomIn());
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ApplicationColors.redColor,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset("assets/images/add_ic.png"),
                          ),
                        ),
                        SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            mapController.animateCamera(CameraUpdate.zoomOut());
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: ApplicationColors.redColor,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset("assets/images/minimise_ic.png"),
                          ),
                        ),
                      ],
                    ),
                  )
              ),


              // add button
              Positioned(
                  top: 60,
                  right: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SpeedDial(
                        buttonSize: Size(40.0, 40.0),
                        switchLabelPosition: true,
                        elevation: 0,
                        direction: SpeedDialDirection.down,
                        activeChild: Icon(Icons.close, size: 30,),
                        child: Icon(Icons.arrow_drop_down, size: 30,),
                        activeBackgroundColor: ApplicationColors.redColor,
                        backgroundColor: ApplicationColors.redColor,

                        visible: true,
                        curve: Curves.bounceIn,
                        children: [

                          SpeedDialChild(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 20),
                              child: Image.asset(
                                  "assets/images/navigation_ic.png"),
                            ),
                            labelWidget: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "${getTranslated(context, "navigation")}",
                                    style: FontStyleUtilities.s16(
                                      fontColor: ApplicationColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: ApplicationColors.redColor,
                            onTap: () {
                              launch(
                                  "https://www.google.com/maps/dir/?api=1&origin=${Utils
                                      .lat},${Utils
                                      .lng}&destination=$lat,$lng&travelmode=driving");

                              // MapsLauncher.launchCoordinates(lat,lng,);
                            },
                          ),

                          SpeedDialChild(

                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(Icons.traffic_outlined,
                                color: ApplicationColors.whiteColor,),
                            ),
                            backgroundColor: ApplicationColors.redColor,
                            onTap: () {
                              setState(() {
                                traffic = !traffic;
                              });
                            },
                            labelWidget: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "${getTranslated(context, "traffic")}",
                                    style: FontStyleUtilities.s16(
                                      fontColor: ApplicationColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ),

                          SpeedDialChild(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Image.asset("assets/images/poi_ic.png"),
                            ),
                            backgroundColor: ApplicationColors.redColor,
                            onTap: () {
                              showAddPoiDialog();
                            },
                            labelWidget: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "${getTranslated(context, "add_poi")}",
                                    style: FontStyleUtilities.s16(
                                        fontColor: ApplicationColors
                                            .blackbackcolor
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ),

                          SpeedDialChild(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Image.asset("assets/images/near_ic.png"),
                            ),
                            backgroundColor: ApplicationColors.redColor,
                            onTap: () {
                              openNearbyDialog();
                            },
                            labelWidget: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "${getTranslated(context, "near_by")}",
                                    style: FontStyleUtilities.s16(
                                      fontColor: ApplicationColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ),

                        ],
                      ),
                    ],
                  )
              ),

            ],
          ),
        ),
      );
  }

}
