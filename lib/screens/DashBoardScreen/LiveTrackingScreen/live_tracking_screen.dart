import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/socket_model.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui'as ui;
import 'package:vector_math/vector_math.dart';
import '../../../Provider/vehicle_list_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:label_marker/label_marker.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({Key key}) : super(key: key);

  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen>  with TickerProviderStateMixin {
  VehicleListProvider vehicleListProvider;

  // Set<Marker> carMarker = {};
  GoogleMapController mapController;
  List carData = [];
  List<LatLng> latLgnList = [];


  final List<Marker> carMarker = <Marker>[];
  Animation<double> _animation;
  final _mapMarkerSC = StreamController<List<Marker>>();
  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;
  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;
  Timer timer;

  getVehicleList()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");
    bool isDealer = sharedPreferences.getBool("isDealer");


    var data = isDealer ? {
      "id":id,
      "email":email,
      "dealer" :id
    } : {
      "id":id,
      "email":email
    } ;

    await vehicleListProvider.getVehicleList(data, "devices/getDeviceByUserMobile","live");

    if(vehicleListProvider.isSucces == false){

      if(vehicleListProvider.vehicleList.isNotEmpty){

        for(int i = 0; i<vehicleListProvider.vehicleList.length; i++){
          latLgnList.clear();
          if( vehicleListProvider.vehicleList[i].lastLocation != null ){
            latLgnList.add(
              LatLng(
                vehicleListProvider.vehicleList[i].lastLocation.lat,
                vehicleListProvider.vehicleList[i].lastLocation.long,
              ),
            );
          }

          var data = {
            "id":"${vehicleListProvider.vehicleList[i].id}",
            "value":vehicleListProvider.vehicleListModel.devices[i],
            "latLogList":latLgnList,
          };

          print("data ==> $data");

          carData.add(data);

          print("print data here ===> ${carData[0]["value"].id}");

          if(carData[i]["value"].lastLocation != null){

            /*carMarker.addLabelMarker(
                LabelMarker(
                  label: "${vehicleListProvider.vehicleList[i].deviceName}",

                  markerId: MarkerId("id$i"),
                  position: LatLng(
                    carData[i]["value"].lastLocation.lat,
                    //carData[i]["value"].lastLocation.lat + 0.00004,
                    carData[i]["value"].lastLocation.long,
                  ),

                  backgroundColor: ApplicationColors.greenColor,
                )
            );
*/
            carMarker.add(
                Marker(
                    markerId: MarkerId("${vehicleListProvider.vehicleList[i].deviceId}"),
                    position: LatLng(
                      carData[i]["value"].lastLocation.lat,
                      carData[i]["value"].lastLocation.long,
                    ),
                    icon:BitmapDescriptor.fromBytes(
                        carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bike"
                            ?
                        bikeGreen
                            :
                        carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bike"
                            ?
                        bikeYellow
                            :
                        carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bike"
                            ?
                        bikeBlue
                            :
                        carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bike"
                            ?
                        bikeOrange
                            :
                        carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bike"
                            ?
                        bikeRed
                            :
                        carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bike"
                            ?
                        bikePurple
                            :
                        carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "car"
                            ?
                        carGreen
                            :
                        carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "car"
                            ?
                        carYellow
                            :
                        carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "car"
                            ?
                        carBlue
                            :
                        carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "car"
                            ?
                        carOrange
                            :
                        carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "car"
                            ?
                        carRed
                            :
                        carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "car"
                            ?
                        carPurple
                            :
                        carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "truck"
                            ?
                        longTruckGreen
                            :
                        carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "truck"
                            ?
                        longTruckYellow
                            :
                        carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "truck"
                            ?
                        longTruckBlue
                            :
                        carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "truck"
                            ?
                        longTruckOrange
                            :
                        carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "truck"
                            ?
                        longTruckRed
                            :
                        carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "truck"
                            ?
                        longTruckPurple
                            :
                        carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bus"
                            ?
                        bikeGreen
                            :
                        carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bus"
                            ?
                        busYellow
                            :
                        carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bus"
                            ?
                        busBlue
                            :
                        carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bus"
                            ?
                        busOrange
                            :
                        carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bus"
                            ?
                        busRed
                            :
                        carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bus"
                            ?
                        busPurple
                            :
                        carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "jcb"
                            ?
                        jcbGreen
                            :
                        carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "jcb"
                            ?
                        jcbYellow
                            :
                        carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "jcb"
                            ?
                        jcbBlue
                            :
                        carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "jcb"
                            ?
                        jcbOrange
                            :
                        carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "jcb"
                            ?
                        jcbRed
                            :
                        carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "jcb"
                            ?
                        jcbPurple
                            :
                        carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "tracktor"
                            ?
                        tractorGreen
                            :
                        carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "tracktor"
                            ?
                        tractorYellow
                            :
                        carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "tracktor"
                            ?
                        tractorBlue
                            :
                        carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "tracktor"
                            ?
                        tractorOrange
                            :
                        carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "tracktor"
                            ?
                        tractorRed
                            :
                        carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "tracktor"
                            ?
                        tractorPurple
                            :
                        carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pickup"
                            ?
                        smallTruckGreen
                            :
                        carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pickup"
                            ?
                        smallTruckYellow
                            :
                        carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pickup"
                            ?
                        smallTruckBlue
                            :
                        carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pickup"
                            ?
                        smallTruckOrange
                            :
                        carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pickup"
                            ?
                        smallTruckRed
                            :
                        carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pickup"
                            ?
                        smallTruckPurple
                            :
                        carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "scooter"
                            ?
                        scooterGreen
                            :
                        carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "scooter"
                            ?
                        scooterYellow
                            :
                        carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "scooter"
                            ?
                        scooterBlue
                            :
                        carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "scooter"
                            ?
                        scooterOrange
                            :
                        carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "scooter"
                            ?
                        scooterRed
                            :
                        carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "scooter"
                            ?
                        scooterPurple
                            :
                        carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pet"
                            ?
                        petGreen
                            :
                        carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pet"
                            ?
                        petYellow
                            :
                        carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pet"
                            ?
                        petBlue
                            :
                        carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pet"
                            ?
                        petOrange
                            :
                        carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pet"
                            ?
                        petRed
                            :
                        carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pet"
                            ?
                        petPurple
                            :

                        carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "user"
                            ?
                        userGreen
                            :
                        carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "user"
                            ?
                        userYellow
                            :
                        carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "user"
                            ?
                        userBlue
                            :
                        carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "user"
                            ?
                        userOrange
                            :
                        carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "user"
                            ?
                        userRed
                            :
                        carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "user"
                            ?
                        userPurple
                            :
                        locationIcon
                    ),
                    infoWindow: InfoWindow(title: "${vehicleListProvider
                        .vehicleList[i].deviceName}",
                      snippet: "value",
                    )
                )
            );

            _mapMarkerSC.add(carMarker);
          }

        }
        // connectSocketIo();
      }
    }
  }

  IO.Socket socket;
  List<SocketModelClass>socketList = [];
  SocketModelClass socketModelClass;
  var address = "Address not found";
  List<LatLng> listOfLatLog = [];

  var lat = 21.1702;
  var log = 72.8311;

  bool isMarkerLoad = false;


  connectSocketIo(){

    socket = IO.io('https://www.oneqlik.in/gps', <String, dynamic>{
      "secure": true,
      "rejectUnauthorized": false,
      "transports":["websocket", "polling"],
      "upgrade": false
    });

    socket.connect();

    socket.onConnect((data) async {

      print("Socket is connected");

      for(int i = 0; i<vehicleListProvider.vehicleList.length; i++){
        if(carData[i]["id"] == "${vehicleListProvider.vehicleList[i].id}"){
          carMarkerAdd(vehicleListProvider.vehicleList[i].deviceId,i);
        }
      }
    });
  }

  carMarkerAdd(id,i){
    socket.emit("acc","$id");

    socket.on("${id}acc", (data) async {
      if(data[3] != null){

        var resonance = data[3];
        setState(() {
          var list = SocketModelClass.fromJson(resonance);

            print("car data index $i");
            print("car resonance $resonance");

            //print(list);

          if(carData[i]["latLogList"].length == 2){

            carData[i]["latLogList"].removeAt(0);

            carData[i]["id"] = list.id;
            carData[i]["value"] = list;

            carData[i]["latLogList"].add(
              LatLng(
                list.lastLocation.lat,
                list.lastLocation.long,
              ),
            );
          }else{
            carData[i]["id"] = list.id;
            carData[i]["value"] = list;
            carData[i]["latLogList"].add(
              LatLng(
                list.lastLocation.lat,
                list.lastLocation.long,
              ),
            );
          }


            if(carData[i]['value'].lastLocation != null){

              if(carMarker.isNotEmpty){

                carMarker.remove("${vehicleListProvider.vehicleList[i].deviceId}");
                carMarker.remove("id$i");

                if(carData[i]["value"].lastLocation != null){
                  carMarker.add(
                      Marker(
                          markerId: MarkerId("${vehicleListProvider.vehicleList[i].deviceId}"),
                          position: LatLng(
                            carData[i]["value"].lastLocation.lat,
                            carData[i]["value"].lastLocation.long,
                          ),
                          icon:BitmapDescriptor.fromBytes(
                              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bike"
                                  ?
                              bikeGreen
                                  :
                              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bike"
                                  ?
                              bikeYellow
                                  :
                              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bike"
                                  ?
                              bikeBlue
                                  :
                              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bike"
                                  ?
                              bikeOrange
                                  :
                              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bike"
                                  ?
                              bikeRed
                                  :
                              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bike"
                                  ?
                              bikePurple
                                  :
                              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "car"
                                  ?
                              carGreen
                                  :
                              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "car"
                                  ?
                              carYellow
                                  :
                              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "car"
                                  ?
                              carBlue
                                  :
                              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "car"
                                  ?
                              carOrange
                                  :
                              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "car"
                                  ?
                              carRed
                                  :
                              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "car"
                                  ?
                              carPurple
                                  :
                              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "truck"
                                  ?
                              longTruckGreen
                                  :
                              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "truck"
                                  ?
                              longTruckYellow
                                  :
                              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "truck"
                                  ?
                              longTruckBlue
                                  :
                              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "truck"
                                  ?
                              longTruckOrange
                                  :
                              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "truck"
                                  ?
                              longTruckRed
                                  :
                              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "truck"
                                  ?
                              longTruckPurple
                                  :
                              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bus"
                                  ?
                              bikeGreen
                                  :
                              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bus"
                                  ?
                              busYellow
                                  :
                              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bus"
                                  ?
                              busBlue
                                  :
                              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bus"
                                  ?
                              busOrange
                                  :
                              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bus"
                                  ?
                              busRed
                                  :
                              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bus"
                                  ?
                              busPurple
                                  :
                              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "jcb"
                                  ?
                              jcbGreen
                                  :
                              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "jcb"
                                  ?
                              jcbYellow
                                  :
                              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "jcb"
                                  ?
                              jcbBlue
                                  :
                              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "jcb"
                                  ?
                              jcbOrange
                                  :
                              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "jcb"
                                  ?
                              jcbRed
                                  :
                              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "jcb"
                                  ?
                              jcbPurple
                                  :
                              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "tracktor"
                                  ?
                              tractorGreen
                                  :
                              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "tracktor"
                                  ?
                              tractorYellow
                                  :
                              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "tracktor"
                                  ?
                              tractorBlue
                                  :
                              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "tracktor"
                                  ?
                              tractorOrange
                                  :
                              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "tracktor"
                                  ?
                              tractorRed
                                  :
                              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "tracktor"
                                  ?
                              tractorPurple
                                  :
                              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pickup"
                                  ?
                              smallTruckGreen
                                  :
                              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pickup"
                                  ?
                              smallTruckYellow
                                  :
                              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pickup"
                                  ?
                              smallTruckBlue
                                  :
                              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pickup"
                                  ?
                              smallTruckOrange
                                  :
                              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pickup"
                                  ?
                              smallTruckRed
                                  :
                              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pickup"
                                  ?
                              smallTruckPurple
                                  :
                              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "scooter"
                                  ?
                              scooterGreen
                                  :
                              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "scooter"
                                  ?
                              scooterYellow
                                  :
                              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "scooter"
                                  ?
                              scooterBlue
                                  :
                              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "scooter"
                                  ?
                              scooterOrange
                                  :
                              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "scooter"
                                  ?
                              scooterRed
                                  :
                              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "scooter"
                                  ?
                              scooterPurple
                                  :
                              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pet"
                                  ?
                              petGreen
                                  :
                              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pet"
                                  ?
                              petYellow
                                  :
                              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pet"
                                  ?
                              petBlue
                                  :
                              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pet"
                                  ?
                              petOrange
                                  :
                              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pet"
                                  ?
                              petRed
                                  :
                              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pet"
                                  ?
                              petPurple
                                  :

                              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "user"
                                  ?
                              userGreen
                                  :
                              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "user"
                                  ?
                              userYellow
                                  :
                              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "user"
                                  ?
                              userBlue
                                  :
                              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "user"
                                  ?
                              userOrange
                                  :
                              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "user"
                                  ?
                              userRed
                                  :
                              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "user"
                                  ?
                              userPurple
                                  :
                              locationIcon
                          ),
                          infoWindow: InfoWindow(title: "${vehicleListProvider
                              .vehicleList[i].deviceName}")
                      )
                  );
                  /*carMarker.addLabelMarker(

                      LabelMarker(
                        label: "${vehicleListProvider.vehicleList[i].deviceName}",

                        markerId: MarkerId("id$i"),
                        position: LatLng(
                          carData[i]["value"].lastLocation.lat,
                          carData[i]["value"].lastLocation.long,
                        ),
                        backgroundColor: ApplicationColors.greenColor,
                      )
                  );*/
                }

              }else{

                carMarker.add(
                    Marker(
                        markerId: MarkerId("${vehicleListProvider.vehicleList[i].deviceId}"),
                        position: LatLng(
                          carData[i]["value"].lastLocation.lat,
                          carData[i]["value"].lastLocation.long,
                        ),
                        icon:BitmapDescriptor.fromBytes(
                            carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bike"
                                ?
                            bikeGreen
                                :
                            carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bike"
                                ?
                            bikeYellow
                                :
                            carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bike"
                                ?
                            bikeBlue
                                :
                            carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bike"
                                ?
                            bikeOrange
                                :
                            carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bike"
                                ?
                            bikeRed
                                :
                            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bike"
                                ?
                            bikePurple
                                :
                            carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "car"
                                ?
                            carGreen
                                :
                            carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "car"
                                ?
                            carYellow
                                :
                            carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "car"
                                ?
                            carBlue
                                :
                            carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "car"
                                ?
                            carOrange
                                :
                            carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "car"
                                ?
                            carRed
                                :
                            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "car"
                                ?
                            carPurple
                                :
                            carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "truck"
                                ?
                            longTruckGreen
                                :
                            carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "truck"
                                ?
                            longTruckYellow
                                :
                            carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "truck"
                                ?
                            longTruckBlue
                                :
                            carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "truck"
                                ?
                            longTruckOrange
                                :
                            carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "truck"
                                ?
                            longTruckRed
                                :
                            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "truck"
                                ?
                            longTruckPurple
                                :
                            carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bus"
                                ?
                            bikeGreen
                                :
                            carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bus"
                                ?
                            busYellow
                                :
                            carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bus"
                                ?
                            busBlue
                                :
                            carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bus"
                                ?
                            busOrange
                                :
                            carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bus"
                                ?
                            busRed
                                :
                            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bus"
                                ?
                            busPurple
                                :
                            carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "jcb"
                                ?
                            jcbGreen
                                :
                            carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "jcb"
                                ?
                            jcbYellow
                                :
                            carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "jcb"
                                ?
                            jcbBlue
                                :
                            carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "jcb"
                                ?
                            jcbOrange
                                :
                            carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "jcb"
                                ?
                            jcbRed
                                :
                            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "jcb"
                                ?
                            jcbPurple
                                :
                            carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "tracktor"
                                ?
                            tractorGreen
                                :
                            carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "tracktor"
                                ?
                            tractorYellow
                                :
                            carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "tracktor"
                                ?
                            tractorBlue
                                :
                            carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "tracktor"
                                ?
                            tractorOrange
                                :
                            carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "tracktor"
                                ?
                            tractorRed
                                :
                            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "tracktor"
                                ?
                            tractorPurple
                                :
                            carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pickup"
                                ?
                            smallTruckGreen
                                :
                            carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pickup"
                                ?
                            smallTruckYellow
                                :
                            carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pickup"
                                ?
                            smallTruckBlue
                                :
                            carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pickup"
                                ?
                            smallTruckOrange
                                :
                            carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pickup"
                                ?
                            smallTruckRed
                                :
                            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pickup"
                                ?
                            smallTruckPurple
                                :
                            carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "scooter"
                                ?
                            scooterGreen
                                :
                            carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "scooter"
                                ?
                            scooterYellow
                                :
                            carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "scooter"
                                ?
                            scooterBlue
                                :
                            carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "scooter"
                                ?
                            scooterOrange
                                :
                            carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "scooter"
                                ?
                            scooterRed
                                :
                            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "scooter"
                                ?
                            scooterPurple
                                :
                            carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pet"
                                ?
                            petGreen
                                :
                            carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pet"
                                ?
                            petYellow
                                :
                            carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pet"
                                ?
                            petBlue
                                :
                            carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pet"
                                ?
                            petOrange
                                :
                            carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pet"
                                ?
                            petRed
                                :
                            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pet"
                                ?
                            petPurple
                                :

                            carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "user"
                                ?
                            userGreen
                                :
                            carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "user"
                                ?
                            userYellow
                                :
                            carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "user"
                                ?
                            userBlue
                                :
                            carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "user"
                                ?
                            userOrange
                                :
                            carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "user"
                                ?
                            userRed
                                :
                            carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "user"
                                ?
                            userPurple
                                :
                            locationIcon
                        ),

                    )
                );

               /* carMarker.addLabelMarker(

                    LabelMarker(
                      label: "${vehicleListProvider.vehicleList[i].deviceName}",

                      markerId: MarkerId("id$i"),
                      position: LatLng(
                        carData[i]["value"].lastLocation.lat,
                        carData[i]["value"].lastLocation.long,
                      ),
                      backgroundColor: ApplicationColors.greenColor,
                    )
                );*/

              }


            carData.add(data);
          }
        });
      }
    });

  }

  Uint8List busRed,busBlue,busGreen,busOrange,busYellow,busPurple;
  Uint8List carRed,carBlue,carGreen,carOrange,carYellow,carPurple;
  Uint8List scooterRed,scooterBlue,scooterGreen,scooterOrange,scooterYellow,scooterPurple;
  Uint8List bikeRed,bikeBlue,bikeGreen,bikeOrange,bikeYellow,bikePurple;
  Uint8List carSuvBlue,carSuvRed,carSuvGreen,carSuvOrange,carSuvYellow,carSuvPurple;
  Uint8List craneBlue,craneRed,craneGreen,craneOrange,craneYellow,cranePurple;
  Uint8List userBlue,userRed,userGreen,userOrange,userYellow,userPurple;
  Uint8List petBlue,petRed,petGreen,petOrange,petYellow,petPurple;
  Uint8List jcbBlue,jcbRed,jcbGreen,jcbOrange,jcbYellow,jcbPurple;
  Uint8List tractorBlue,tractorRed,tractorGreen,tractorOrange,tractorYellow,tractorPurple;
  Uint8List longTruckBlue,longTruckRed,longTruckGreen,longTruckOrange,longTruckYellow,longTruckPurple;
  Uint8List smallTruckBlue,smallTruckRed,smallTruckGreen,smallTruckOrange,smallTruckYellow,smallTruckPurple;
  Uint8List generatorBlue,generatorRed,generatorGreen,generatorOrange,generatorYellow,generatorPurple;
  Uint8List locationIcon;

  createMarker() async {

    setState(() {
      isMarkerLoad = true;
    });

    busRed = await  getBytesFromAsset('assets/images/marker/busMarker/busPink.png', 10);
    busBlue = await  getBytesFromAsset('assets/images/marker/busMarker/busBlue.png', 10);
    busGreen = await  getBytesFromAsset('assets/images/marker/busMarker/busGreen.png', 10);
    busOrange = await  getBytesFromAsset('assets/images/marker/busMarker/busOrange.png', 10);
    busYellow = await  getBytesFromAsset('assets/images/marker/busMarker/busYello.png', 10);
    busPurple = await  getBytesFromAsset('assets/images/marker/busMarker/busPurple.png', 10);


    carBlue = await  getBytesFromAsset('assets/images/marker/carMarker/carBule.png', 10);
    carGreen = await  getBytesFromAsset('assets/images/marker/carMarker/carGreen.png', 10);
    carOrange = await  getBytesFromAsset('assets/images/marker/carMarker/carOrange.png', 10);
    carPurple = await  getBytesFromAsset('assets/images/marker/carMarker/carPurple.png', 10);
    carRed = await  getBytesFromAsset('assets/images/marker/carMarker/carRed.png', 10);
    carYellow = await  getBytesFromAsset('assets/images/marker/carMarker/carYello.png', 10);


    scooterBlue = await  getBytesFromAsset('assets/images/marker/scootyMarker/sccotyBlue.png', 10);
    scooterOrange = await  getBytesFromAsset('assets/images/marker/scootyMarker/sccotyOrange.png', 10);
    scooterRed = await  getBytesFromAsset('assets/images/marker/scootyMarker/sccotyRed.png', 10);
    scooterYellow = await  getBytesFromAsset('assets/images/marker/scootyMarker/sccotyYellow.png', 10);
    scooterGreen = await  getBytesFromAsset('assets/images/marker/scootyMarker/scootyGreen.png', 10);
    scooterPurple = await  getBytesFromAsset('assets/images/marker/scootyMarker/scootyPurple.png', 10);


    bikeBlue = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeBlue.png', 10);
    bikeGreen = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeGreen.png', 10);
    bikeOrange = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeOrange.png', 10);
    bikeRed = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeRed.png', 10);
    bikeYellow = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeYellow.png', 10);
    bikePurple = await  getBytesFromAsset('assets/images/marker/bikeMarker/bikeYellow.png', 10);


    carSuvBlue = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvBlue.png', 10);
    carSuvGreen = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvGreen.png', 10);
    carSuvOrange = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvOrange.png', 10);
    carSuvPurple = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvPurple.png', 10);
    carSuvRed = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvRed.png', 10);
    carSuvYellow = await  getBytesFromAsset('assets/images/marker/carsuvMarker/carsuvYellow.png', 10);


    craneBlue = await  getBytesFromAsset('assets/images/marker/craneMarker/craneBlue.png', 10);
    craneGreen = await  getBytesFromAsset('assets/images/marker/craneMarker/craneGreen.png', 10);
    craneOrange = await  getBytesFromAsset('assets/images/marker/craneMarker/craneOrange.png', 10);
    cranePurple = await  getBytesFromAsset('assets/images/marker/craneMarker/cranePurple.png', 10);
    craneRed = await  getBytesFromAsset('assets/images/marker/craneMarker/craneRed.png', 10);
    craneYellow = await  getBytesFromAsset('assets/images/marker/craneMarker/craneYellow.png', 10);


    userBlue = await  getBytesFromAsset('assets/images/marker/userMarker/userBlue.png', 10);
    userGreen = await  getBytesFromAsset('assets/images/marker/userMarker/userGreen.png', 10);
    userOrange = await  getBytesFromAsset('assets/images/marker/userMarker/userOrange.png', 10);
    userPurple = await  getBytesFromAsset('assets/images/marker/userMarker/userPurple.png', 10);
    userRed = await  getBytesFromAsset('assets/images/marker/userMarker/userRed.png', 10);
    userYellow = await  getBytesFromAsset('assets/images/marker/userMarker/userYellow.png', 10);


    petBlue = await  getBytesFromAsset('assets/images/marker/petMarker/petBlue.png', 10);
    petGreen = await  getBytesFromAsset('assets/images/marker/petMarker/petGreen.png', 10);
    petOrange = await  getBytesFromAsset('assets/images/marker/petMarker/petOrange.png', 10);
    petPurple = await  getBytesFromAsset('assets/images/marker/petMarker/petPurple.png', 10);
    petRed = await  getBytesFromAsset('assets/images/marker/petMarker/petRed.png', 10);
    petYellow = await  getBytesFromAsset('assets/images/marker/petMarker/petYellow.png', 10);


    jcbBlue = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbBlue.png', 10);
    jcbGreen = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbGreen.png', 10);
    jcbOrange = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbOrange.png', 10);
    jcbPurple = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbPurple.png', 10);
    jcbRed = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbRed.png', 10);
    jcbYellow = await  getBytesFromAsset('assets/images/marker/jcbMarker/jcbYellow.png', 10);


    tractorBlue = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorBlue.png', 10);
    tractorGreen = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorGreen.png', 10);
    tractorOrange = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorOrange.png', 10);
    tractorPurple = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorPurple.png', 10);
    tractorRed = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorRed.png', 10);
    tractorYellow = await  getBytesFromAsset('assets/images/marker/tractorMarker/tractorYellow.png', 10);


    longTruckBlue = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckBlue.png', 10);
    longTruckGreen = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckGreen.png', 10);
    longTruckOrange = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckOrange.png', 10);
    longTruckPurple = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckPurple.png', 10);
    longTruckRed = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckRed.png', 10);
    longTruckYellow = await  getBytesFromAsset('assets/images/marker/longTruckMarker/longTruckYellow.png', 10);


    smallTruckBlue = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckBlue.png', 10);
    smallTruckGreen = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckGreen.png', 10);
    smallTruckOrange = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckOrange.png', 10);
    smallTruckPurple = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckPurple.png', 10);
    smallTruckRed = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckRed.png', 10);
    smallTruckYellow = await  getBytesFromAsset('assets/images/marker/smallTruckMarker/smallTruckYellow.png', 10);

    generatorBlue = await  getBytesFromAsset('assets/images/marker/generatorMarker/generatorBlue.png', 10);
    generatorGreen = await  getBytesFromAsset('assets/images/marker/generatorMarker/generatorGreen.png', 10);
    generatorOrange = await  getBytesFromAsset('assets/images/marker/generatorMarker/generatorOrange.png', 10);
    generatorPurple = await  getBytesFromAsset('assets/images/marker/generatorMarker/generatorPurple.png', 10);
    generatorRed = await  getBytesFromAsset('assets/images/marker/generatorMarker/generatorRed.png', 10);
    generatorYellow = await  getBytesFromAsset('assets/images/marker/generatorMarker/generatorYellow.png', 10);

    locationIcon = await  getBytesFromAsset('assets/images/location.png', 10);

    setState(() {
      isMarkerLoad = false;
    });

    getVehicleList();
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }


  void initState() {
    super.initState();
    vehicleListProvider = Provider.of<VehicleListProvider>(context, listen: false);

    vehicleListProvider.vehicleList.clear();
    vehicleListProvider.addressList.clear();

    Future.delayed(Duration.zero,(){
      vehicleListProvider.changeBool(false);
    });

    //getVehicleList();
    createMarker();
  }



  startMarker(int index){
    int i  = 0;
    timer =  Timer.periodic(Duration(seconds: 1), (_) {
      animateCar(
        listOfLatLog[i].latitude,
        listOfLatLog[i].longitude,
        listOfLatLog[i + 1].latitude,
        listOfLatLog[i + 1].longitude,
        _mapMarkerSink,
        this,
        index,
        mapController,
      );
      setState(() {
        timer.cancel();
      });
    });
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
      int i,
      GoogleMapController controller, //Google map controller of our widget
      ) async {
    final double bearing =
    getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));
    // _markers.clear();

    var carMarkers = Marker(
      markerId: const MarkerId("driverMarker"),
      position: LatLng(fromLat, fromLong),
      icon:BitmapDescriptor.fromBytes(
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bike"
              ?
          bikeGreen
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bike"
              ?
          bikeYellow
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bike"
              ?
          bikeBlue
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bike"
              ?
          bikeOrange
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bike"
              ?
          bikeRed
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bike"
              ?
          bikePurple
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "car"
              ?
          carGreen
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "car"
              ?
          carYellow
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "car"
              ?
          carBlue
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "car"
              ?
          carOrange
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "car"
              ?
          carRed
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "car"
              ?
          carPurple
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "truck"
              ?
          longTruckGreen
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "truck"
              ?
          longTruckYellow
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "truck"
              ?
          longTruckBlue
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "truck"
              ?
          longTruckOrange
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "truck"
              ?
          longTruckRed
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "truck"
              ?
          longTruckPurple
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bus"
              ?
          bikeGreen
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bus"
              ?
          busYellow
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bus"
              ?
          busBlue
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bus"
              ?
          busOrange
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bus"
              ?
          busRed
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bus"
              ?
          busPurple
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "jcb"
              ?
          jcbGreen
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "jcb"
              ?
          jcbYellow
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "jcb"
              ?
          jcbBlue
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "jcb"
              ?
          jcbOrange
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "jcb"
              ?
          jcbRed
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "jcb"
              ?
          jcbPurple
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "tracktor"
              ?
          tractorGreen
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "tracktor"
              ?
          tractorYellow
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "tracktor"
              ?
          tractorBlue
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "tracktor"
              ?
          tractorOrange
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "tracktor"
              ?
          tractorRed
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "tracktor"
              ?
          tractorPurple
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pickup"
              ?
          smallTruckGreen
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pickup"
              ?
          smallTruckYellow
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pickup"
              ?
          smallTruckBlue
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pickup"
              ?
          smallTruckOrange
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pickup"
              ?
          smallTruckRed
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pickup"
              ?
          smallTruckPurple
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "scooter"
              ?
          scooterGreen
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "scooter"
              ?
          scooterYellow
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "scooter"
              ?
          scooterBlue
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "scooter"
              ?
          scooterOrange
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "scooter"
              ?
          scooterRed
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "scooter"
              ?
          scooterPurple
              :
          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pet"
              ?
          petGreen
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pet"
              ?
          petYellow
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pet"
              ?
          petBlue
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pet"
              ?
          petOrange
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pet"
              ?
          petRed
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pet"
              ?
          petPurple
              :

          carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "user"
              ?
          userGreen
              :
          carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "user"
              ?
          userYellow
              :
          carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "user"
              ?
          userBlue
              :
          carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "user"
              ?
          userOrange
              :
          carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "user"
              ?
          userRed
              :
          carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "user"
              ?
          userPurple
              :
          locationIcon
      ),
      anchor: const Offset(0.5, 0.5),
      flat: true,
      rotation: bearing,
      draggable: false,
    );

    //Adding initial marker to the start location.
    carMarker.add(carMarkers);
    mapMarkerSink.add(carMarker);

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

        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: newPos, zoom: 15.5)));
        //Removing old marker if present in the marker array
        if (carMarker.contains(carMarker)) carMarker.remove(carMarker);

        //New marker location
        carMarkers = Marker(
          markerId: const MarkerId("driverMarker"),
          position: newPos,
          icon:BitmapDescriptor.fromBytes(
              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bike"
                  ?
              bikeGreen
                  :
              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bike"
                  ?
              bikeYellow
                  :
              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bike"
                  ?
              bikeBlue
                  :
              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bike"
                  ?
              bikeOrange
                  :
              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bike"
                  ?
              bikeRed
                  :
              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bike"
                  ?
              bikePurple
                  :
              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "car"
                  ?
              carGreen
                  :
              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "car"
                  ?
              carYellow
                  :
              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "car"
                  ?
              carBlue
                  :
              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "car"
                  ?
              carOrange
                  :
              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "car"
                  ?
              carRed
                  :
              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "car"
                  ?
              carPurple
                  :
              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "truck"
                  ?
              longTruckGreen
                  :
              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "truck"
                  ?
              longTruckYellow
                  :
              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "truck"
                  ?
              longTruckBlue
                  :
              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "truck"
                  ?
              longTruckOrange
                  :
              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "truck"
                  ?
              longTruckRed
                  :
              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "truck"
                  ?
              longTruckPurple
                  :
              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "bus"
                  ?
              bikeGreen
                  :
              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "bus"
                  ?
              busYellow
                  :
              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "bus"
                  ?
              busBlue
                  :
              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "bus"
                  ?
              busOrange
                  :
              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "bus"
                  ?
              busRed
                  :
              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "bus"
                  ?
              busPurple
                  :
              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "jcb"
                  ?
              jcbGreen
                  :
              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "jcb"
                  ?
              jcbYellow
                  :
              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "jcb"
                  ?
              jcbBlue
                  :
              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "jcb"
                  ?
              jcbOrange
                  :
              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "jcb"
                  ?
              jcbRed
                  :
              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "jcb"
                  ?
              jcbPurple
                  :
              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "tracktor"
                  ?
              tractorGreen
                  :
              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "tracktor"
                  ?
              tractorYellow
                  :
              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "tracktor"
                  ?
              tractorBlue
                  :
              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "tracktor"
                  ?
              tractorOrange
                  :
              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "tracktor"
                  ?
              tractorRed
                  :
              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "tracktor"
                  ?
              tractorPurple
                  :
              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pickup"
                  ?
              smallTruckGreen
                  :
              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pickup"
                  ?
              smallTruckYellow
                  :
              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pickup"
                  ?
              smallTruckBlue
                  :
              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pickup"
                  ?
              smallTruckOrange
                  :
              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pickup"
                  ?
              smallTruckRed
                  :
              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pickup"
                  ?
              smallTruckPurple
                  :
              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "scooter"
                  ?
              scooterGreen
                  :
              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "scooter"
                  ?
              scooterYellow
                  :
              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "scooter"
                  ?
              scooterBlue
                  :
              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "scooter"
                  ?
              scooterOrange
                  :
              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "scooter"
                  ?
              scooterRed
                  :
              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "scooter"
                  ?
              scooterPurple
                  :
              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "pet"
                  ?
              petGreen
                  :
              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "pet"
                  ?
              petYellow
                  :
              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "pet"
                  ?
              petBlue
                  :
              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "pet"
                  ?
              petOrange
                  :
              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "pet"
                  ?
              petRed
                  :
              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "pet"
                  ?
              petPurple
                  :

              carData[i]["value"].status == "RUNNING" && carData[i]["value"].iconType == "user"
                  ?
              userGreen
                  :
              carData[i]["value"].status == "IDLING" && carData[i]["value"].iconType == "user"
                  ?
              userYellow
                  :
              carData[i]["value"].status == "OUT OF REACH" && carData[i]["value"].iconType == "user"
                  ?
              userBlue
                  :
              carData[i]["value"].status == "Expired" && carData[i]["value"].iconType == "user"
                  ?
              userOrange
                  :
              carData[i]["value"].status == "STOPPED" && carData[i]["value"].iconType == "user"
                  ?
              userRed
                  :
              carData[i]["value"].status == "NO GPS FIX" && carData[i]["value"].iconType == "user"
                  ?
              userPurple
                  :
              locationIcon
          ),
          anchor: const Offset(0.5, 0.5),
          flat: true,
          rotation: bearing,
          draggable: false,
        );

        //Adding new marker to our list and updating the google map UI.
        carMarker.add(carMarkers);
        mapMarkerSink.add(carMarker);

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


  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  var height,width;

  @override
  Widget build(BuildContext context) {
    vehicleListProvider = Provider.of<VehicleListProvider>(context, listen: true);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: vehicleListProvider.isCommentLoading || isMarkerLoad
            ?
        Helper.dialogCall.showLoader()
            :
        Stack(
          children: [

            Container(
              height: height,
              child: StreamBuilder<List<Marker>>(
                  stream: mapMarkerStream,
                  builder: (context, snapshot) {
                    return GoogleMap(
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition( //innital position in map
                        target: LatLng(lat,log), //initial position
                        zoom: 16.0, //initial zoom level
                      ),
                      mapType: Utils.mapType, //map type
                      markers: Set<Marker>.of(snapshot.data ?? []),
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;

                         /* setState(() {
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
                          );*/


                        });
                      },
                    );
                  }
              ),

              /*GoogleMap(
                initialCameraPosition: CameraPosition( //innital position in map
                  target: LatLng(lat,log,), //initial position
                  zoom: 16.0, //initial zoom level
                ),
                markers: carMarker,
                mapType: Utils.mapType, //map type
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                    mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(20.5937,78.9629),
                              zoom:07
                            ),
                        )
                    );
                  });
                },
              ),*/
            ),

            Positioned(
                top: height*.05,left: width*.05,
                child: Container(
                  width: width*.09,
                  height: height*.04,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),color: ApplicationColors.blackColor2E),
                  child: InkWell(onTap: (){
                  //  Navigator.pop(context);
                  },child: Center(child: Image.asset('assets/images/maap_icon_for_live_screen.png',width: 12))),)),

            Positioned(
                top: height*.05,right: width*.05,
                child:  InkWell(
                  onTap: (){},
                  child: Container(
                    width: width*.09,
                    height: height*.04,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      color: ApplicationColors.blackColor2E,
                    ),
                    child: Center(
                        child: Image.asset(
                          'assets/images/icon_sharedd.png',
                          width: 12,
                        )
                    ),
                  ),
                )
            )

          ],
        ),
    );

  }
}
