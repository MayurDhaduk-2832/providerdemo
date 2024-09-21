import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/histroy_track_model.dart';
import 'package:oneqlik/Provider/histroy_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math.dart';

class MapProvider extends ChangeNotifier {
  TextEditingController datedController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  bool isChangeMap = false;
  MapType mapType = MapType.normal;

  GoogleMapController mapController;

  bool isSelected = false;
  var val;
  String selectedtype;
  Future init(BuildContext context) {}

//T00:00:00.000Z
  var fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc())}";

  //var fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toUtc().toString();

  Uint8List carPoint, endPoint, startPoint, parkingPoint;

  createMarker() async {
    carPoint = await getBytesFromAsset('assets/images/car2.png', 40);
    parkingPoint = await getBytesFromAsset('assets/images/parking_point.png', 40);
    startPoint = await getBytesFromAsset('assets/images/start_point.png', 50);
    endPoint = await getBytesFromAsset('assets/images/stop_point.png', 50);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  var vehicleId = "", vId = "";

  List<Marker> markers = <Marker>[];
  Animation<double> _animation;
  var mapMarkerSC = StreamController<List<Marker>>();

  StreamSink<List<Marker>> get mapMarkerSink => mapMarkerSC.sink;

  Stream<List<Marker>> get mapMarkerStream => mapMarkerSC.stream;

  int trackListLength = 0;
  double playerTimeLine = 0;
  var getId = "", getIMEINo = "";
  LatLng newPos1;

  Timer timer;
  Timer timer2;
  int i = 0;
  bool replay = false, hidePolyline = false, pause = false;

  var startLat = 0.0;
  var startLag = 0.0;

  var address = "", dateTime = "", speed = "0", deviceName;
  dynamic previousDis = 0.0;

  getTrack(BuildContext context, HistoryProvider historyProvider) async {
    /* var localDatefrom = DateFormat('yyyy-MM-dd HH:mm:ss').parse(fromDate).toLocal();
    var localDateto = DateFormat('yyyy-MM-dd HH:mm:ss').parse(toDate).toLocal();

    var formattedDateFrom = DateFormat('yyyy-MM-dd HH:mm:ss').format(localDatefrom);
    var formattedDateTo = DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateto);

    print("----------utc from date:$fromDate");
    print("----------utc to date:$toDate");
    print("--------local from date :$formattedDateFrom");
    print("--------local to date :$formattedDateTo");
    datedController.text=formattedDateFrom.toString();
    _endDateController.text=formattedDateTo.toString();*/

    print("----------utc from date:$fromDate");
    print("----------utc to date:$toDate");

    var data = {
      "id": "$getIMEINo",
      "from": fromDate,
      "to": toDate,
    };
    print(data);

    await historyProvider.getTrack(data, "gps", context);

    if (historyProvider.isSuccess) {
      if (historyProvider.trackList.isNotEmpty && historyProvider.trackLat.isNotEmpty) {
        trackListLength = historyProvider.trackList.length;
        notifyListeners();

        getUserAddress(historyProvider.trackLat.first.latitude, historyProvider.trackLat.first.longitude);

        List<Marker> list = [
          Marker(
            markerId: MarkerId("startPoint"),
            position: historyProvider.trackLat.first,
            icon: BitmapDescriptor.fromBytes(startPoint),
          ),
          Marker(
            markerId: MarkerId("endPoint"),
            position: historyProvider.trackLat.last,
            icon: BitmapDescriptor.fromBytes(endPoint),
          ),
        ];

        await Future.delayed(const Duration(milliseconds: 500));

        markers.addAll(list);
        mapMarkerSink.add(markers);
        getParkingMark(context, historyProvider);
        print("method list${historyProvider.trackLat.length}");
        notifyListeners();
      } else {
        print("Data is not available");
        address = "";
        dateTime = "";
        speed = "0";
        previousDis = 0.0;
        historyProvider.parkingList.clear();
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(34.0479, 100.6197), zoom: 3),
          ),
        );
      }
    }
  }

  getParkingMark(BuildContext context, HistoryProvider historyProvider) async {
    print("time is:$fromDate");
    print("time is:$toDate");
    // var fromDate2 = "${DateFormat("yyyy-MM-dd HH:mm:ss").format(fromdate1)}";
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var id = preferences.getString("uid");
    var data = {
      "uId": "$id",
      "device": "$getId",
      "from_date": fromDate,
      "to_date": toDate,
    };

    print("parking data $data");

    await historyProvider.getParkingData(data, "stoppage/stoppage_detail");

    if (historyProvider.isSuccessParking) {
      if (historyProvider.parkingList.isNotEmpty) {
        print("Lengjht : ${historyProvider.parkingList.length}");
        for (int i = 0; i < historyProvider.parkingList.length; i++) {
          print("Marker Id :${historyProvider.parkingList.length - i}");
          int differenceInMinutes = historyProvider.parkingList[i].departureTime
              .difference(historyProvider.parkingList[i].arrivalTime)
              .inMinutes;
          var address;
          Duration duration = Duration(minutes: differenceInMinutes);

          String twoDigits(int n) => n.toString().padLeft(2, "0");
          String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
          String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

          String formattedDuration =
              "${twoDigits(duration.inHours)}Hrs ${twoDigitMinutes}Min ${twoDigitSeconds}Sec";
          var headers = {
            'sec-ch-ua': '"Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"',
            'Accept': 'application/json, text/plain, /',
            'content-type': 'application/json',
            'Referer': 'https://www.oneqlik.in/glocation',
            'sec-ch-ua-mobile': '?0',
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
            'sec-ch-ua-platform': '"Windows"'
          };
          var request =
              http.Request('POST', Uri.parse('https://www.oneqlik.in/googleAddress/getGoogleAddress'));
          request.body = json.encode(
              {"lat": historyProvider.parkingList[i].lat, "long": historyProvider.parkingList[i].long});
          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
            var data = await response.stream.bytesToString();
            address = json.decode(data)["address"];
            // print(await response.stream.bytesToString());
          } else {
            print(response.reasonPhrase);
          }

          markers.add(
            Marker(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Dialog(
                          child: Container(
                            // alignment: Alignment.center,
                            color: ApplicationColors.greyC4C4.withOpacity(0.8),
                            // height: 170,
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Wrap(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "P$i -",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "${address ?? ""}",
                                                    maxLines: 3,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(color: ApplicationColors.blackbackcolor),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          // historyProvider.parkingList[i]
                                          //                 .departureTime
                                          //                 .difference(
                                          //                     historyProvider
                                          //                         .parkingList[
                                          //                             i]
                                          //                         .arrivalTime)
                                          //                 .inMinutes ==
                                          //             0 ||
                                          //         historyProvider.parkingList[i]
                                          //                 .departureTime
                                          //                 .difference(
                                          //                     historyProvider
                                          //                         .parkingList[
                                          //                             i]
                                          //                         .arrivalTime)
                                          //                 .inMinutes ==
                                          //             1
                                          //     ? "${historyProvider.parkingList[i].departureTime.difference(historyProvider.parkingList[i].arrivalTime).inMinutes.toString() ?? "0"} Min"
                                          //     :
                                          "${formattedDuration ?? "0"}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Total Picked Time",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(color: ApplicationColors.blackbackcolor),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                DateFormat("dd-MM-yyyy hh:mm:ss aa")
                                                        .format(historyProvider.parkingList[i].arrivalTime) ??
                                                    "",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "${getTranslated(context, "arrival_time")}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                DateFormat("dd-MM-yyyy hh:mm:ss aa").format(
                                                        historyProvider.parkingList[i].departureTime) ??
                                                    "",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "${getTranslated(context, "departure_time")}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return StatefulBuilder(builder: (context, setState) {
                //         return AlertDialog(
                //           titlePadding: EdgeInsets.all(0),
                //           title: Container(
                //             width: width,
                //             decoration: BoxDecoration(
                //                 color: ApplicationColors.blackColor2E,
                //                 borderRadius: BorderRadius.circular(6)),
                //             child: Padding(
                //               padding: const EdgeInsets.all(15),
                //               child: Column(
                //                 children: [
                //                   Row(
                //                     children: [
                //                       Text(
                //                         "${getTranslated(context, "departure_time")}:",
                //                         style: Textstyle1.text10,
                //                       ),
                //                       Spacer(),
                //                       Text(
                //                         DateFormat("dd MMM yyyy hh:mm:ss aa")
                //                                 .format(historyProvider
                //                                     .parkingList[i]
                //                                     .departureTime) ??
                //                             "",
                //                         style: Textstyle1.text10,
                //                       ),
                //                     ],
                //                   ),
                //                   SizedBox(height: 5),
                //                   Row(
                //                     children: [
                //                       Text(
                //                         "${getTranslated(context, "arrival_time")}:",
                //                         style: Textstyle1.text10,
                //                       ),
                //                       Spacer(),
                //                       Text(
                //                         DateFormat("dd MMM yyyy hh:mm:ss aa")
                //                                 .format(historyProvider
                //                                     .parkingList[i]
                //                                     .arrivalTime) ??
                //                             "",
                //                         style: Textstyle1.text10,
                //                       ),
                //                     ],
                //                   ),
                //                   SizedBox(height: 5),
                //                   Row(
                //                     children: [
                //                       Text(
                //                         "${getTranslated(context, "duration")}:",
                //                         style: Textstyle1.text10,
                //                       ),
                //                       Spacer(),
                //                       Text(
                //                         historyProvider.parkingList[i]
                //                                         .departureTime
                //                                         .difference(
                //                                             historyProvider
                //                                                 .parkingList[i]
                //                                                 .arrivalTime)
                //                                         .inMinutes ==
                //                                     0 ||
                //                                 historyProvider.parkingList[i]
                //                                         .departureTime
                //                                         .difference(
                //                                             historyProvider
                //                                                 .parkingList[i]
                //                                                 .arrivalTime)
                //                                         .inMinutes ==
                //                                     1
                //                             ? "${historyProvider.parkingList[i].departureTime.difference(historyProvider.parkingList[i].arrivalTime).inMinutes.toString() ?? "0"} Min"
                //                             : "${historyProvider.parkingList[i].departureTime.difference(historyProvider.parkingList[i].arrivalTime).inMinutes.toString() ?? "0"} Mins",
                //                         style: Textstyle1.text10,
                //                       ),
                //                     ],
                //                   ),
                //                   SizedBox(height: 5),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceBetween,
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       Text(
                //                         "${getTranslated(context, "address")}:  ",
                //                         style: Textstyle1.text10,
                //                       ),
                //                       Expanded(
                //                         child: Text(
                //                           historyProvider
                //                                   .parkingList[i].address ??
                //                               "",
                //                           style: Textstyle1.text10,
                //                           textAlign: TextAlign.end,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         );
                //       });
                //     });
              },
              markerId: MarkerId("parking$i"),
              position: LatLng(
                double.parse(historyProvider.parkingList[i].lat),
                double.parse(historyProvider.parkingList[i].long),
              ),
              icon: await getMarkerIcon("assets/images/parking_point.png", Size(140, 140),
                  "${(historyProvider.parkingList.length - i) - 1}"),
            ),
          );

          mapMarkerSink.add(markers);
        }

        // for(int i=0; i<historyProvider.parkingList.length; i++) {
        //
        //   _markers.add(
        //       Marker(
        //         onTap: (){
        //           showDialog(
        //               context: context,
        //               builder: (context) {
        //                 return StatefulBuilder(
        //                     builder: (context, setState) {
        //                       return AlertDialog(
        //                         titlePadding: EdgeInsets.all(0),
        //                         title: Container(
        //                           width: width,
        //                           decoration: BoxDecoration(
        //                               color: ApplicationColors.blackColor2E,
        //                               borderRadius: BorderRadius.circular(6)),
        //                           child: Padding(
        //                             padding: const EdgeInsets.all(15),
        //                             child: Column(
        //                               children: [
        //                                 Row(
        //                                   children: [
        //                                     Text(
        //                                       "${getTranslated(context, "departure_time")}:",
        //                                       style: Textstyle1.text10,
        //                                     ),
        //                                     Spacer(),
        //                                     Text( DateFormat("dd MMM yyyy hh:mm:ss aa").format(historyProvider.parkingList[i].departureTime)??"",
        //                                       style: Textstyle1.text10,
        //                                     ),
        //                                   ],
        //                                 ),
        //                                 SizedBox(height: 5),
        //                                 Row(
        //                                   children: [
        //                                     Text(
        //                                       "${getTranslated(context, "arrival_time")}:",
        //                                       style: Textstyle1.text10,
        //                                     ),
        //                                     Spacer(),
        //                                     Text( DateFormat("dd MMM yyyy hh:mm:ss aa").format(historyProvider.parkingList[i].arrivalTime)??"",
        //                                       style: Textstyle1.text10,
        //                                     ),
        //                                   ],
        //                                 ),
        //                                 SizedBox(height: 5),
        //                                 Row(
        //                                   children: [
        //                                     Text(
        //                                       "${getTranslated(context, "duration")}:",
        //                                       style: Textstyle1.text10,
        //                                     ),
        //                                     Spacer(),
        //                                     Text(historyProvider
        //                                         .parkingList[i].departureTime
        //                                         .difference(historyProvider
        //                                         .parkingList[i].arrivalTime)
        //                                         .inMinutes == 0||
        //                                   historyProvider
        //                                       .parkingList[i].departureTime
        //                                       .difference(historyProvider
        //                                       .parkingList[i].arrivalTime)
        //                                       .inMinutes == 1?"${
        //                                         historyProvider
        //                                             .parkingList[i].departureTime
        //                                             .difference(historyProvider
        //                                             .parkingList[i].arrivalTime)
        //                                             .inMinutes
        //                                             .toString()??"0"
        //                                     } Min":"${
        //                                 historyProvider
        //                                     .parkingList[i].departureTime
        //                                     .difference(historyProvider
        //                                         .parkingList[i].arrivalTime)
        //                                     .inMinutes
        //                                     .toString()??"0"
        //                               } Mins",
        //                                       style: Textstyle1.text10,
        //                                     ),
        //                                   ],
        //                                 ),
        //                                 SizedBox(height: 5),
        //                                 Row(
        //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                                   crossAxisAlignment: CrossAxisAlignment.start,
        //                                   children: [
        //                                     Text(
        //                                       "${getTranslated(context, "address")}:  ",
        //                                       style: Textstyle1.text10,
        //                                     ),
        //                                     Expanded(
        //                                       child: Text(historyProvider.parkingList[i].address??"",
        //                                         style: Textstyle1.text10,
        //                                         textAlign: TextAlign.end,
        //                                       ),
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                       );
        //                     });
        //               });
        //         },
        //           markerId: MarkerId("parking$i"),
        //           position: LatLng(
        //             double.parse(historyProvider.parkingList[i].lat),
        //             double.parse(historyProvider.parkingList[i].long),
        //           ),
        //           icon: await getMarkerIcon("assets/images/parking_point.png",Size(140,140),"${i+1}"),
        //       )
        //   );
        //
        //     _mapMarkerSink.add(_markers);
        //
        //   setState(() { });
        // }
      }
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    mapController.animateCamera(CameraUpdate.newLatLngBounds(createBounds(historyProvider.trackLat), 100));
  }

  getDistance(HistoryProvider historyProvider) async {
    var data = {
      "imei": "$getIMEINo",
      "from": fromDate,
      "to": toDate,
    };

    print("distance$data");

    await historyProvider.getDistance(data, "gps/getDistanceSpeed");
  }

  getUserAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    address = "${placemarks.first.name}"
        " ${placemarks.first.subLocality}"
        " ${placemarks.first.locality}"
        " ${placemarks.first.subAdministrativeArea} "
        "${placemarks.first.administrativeArea},"
        "${placemarks.first.postalCode}";
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

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size, String carName) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final double tagWidth = 40.0;

    // Add tag text

    TextSpan span = TextSpan(
      text: '$carName',
      style: Textstyle1.text18bold.copyWith(
        color: ApplicationColors.black4240,
        fontSize: 25,
      ),
    );

    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    // container here
    var paint1 = Paint()
      ..color = ApplicationColors.transparentColors
      ..style = PaintingStyle.fill;

    RRect fullRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(size.width - textPainter.width / 2, tagWidth - textPainter.height),
          width: 350,
          height: 80),
      Radius.circular(60),
    );

    canvas.drawRRect(fullRect, paint1);

    textPainter.paint(canvas, Offset((size.width - textPainter.width) * 0.5, tagWidth - textPainter.height));

    // Oval for the image
    Rect oval = Rect.fromLTWH(0.0, 30.0, size.width, size.height - textPainter.height);

    // Add image
    ui.Image image = await getImageFromPath(imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.scaleDown);

    // Convert canvas to image
    final ui.Image markerAsImage =
        await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  AnimationController animationController;

  startMarker(i, TickerProvider provider, HistoryProvider historyProvider) {
    if (previousDis == 0.0 || replay == true) {
      //  setState(() {
      previousDis = 0.0;
      //  });
    }

    timer = Timer.periodic(Duration(seconds: 0), (_) {
      if (pause) {
        if (i + 1 == historyProvider.trackList.length) {
          //   setState(() {
          timer.cancel();
          timer2.cancel();
          animationController.dispose();
          pause = false;
          //     });
        } else {
          getDistance(historyProvider);
          timer.cancel();
          if (historyProvider.trackList.length > i) {
            if (pause) {
              print(historyProvider.trackList.length);
              print(i);

              startLat = historyProvider.trackList[i].lat;
              startLag = historyProvider.trackList[i].lng;
              notifyListeners();
            }

            var distance = Geolocator.distanceBetween(
              startLat,
              startLag,
              historyProvider.trackList[i + 1].lat,
              historyProvider.trackList[i + 1].lng,
            );

            if (historyProvider.speedValue == 1) {
              print("speed 1x");

              historyProvider.changeNewMakerSpeed(100 * distance.round());
              print(historyProvider.moveSpeedInSeconds);
            } else if (historyProvider.speedValue == 2) {
              print("speed 2x");

              historyProvider.changeNewMakerSpeed((90 * distance.round() - (20 * distance.round())));
              print(historyProvider.moveSpeedInSeconds);
            } else if (historyProvider.speedValue == 4) {
              print("speed 4x");

              historyProvider.changeNewMakerSpeed((80 * distance.round() - (40 * distance.round())));
              print(historyProvider.moveSpeedInSeconds);
            } else if (historyProvider.speedValue == 6) {
              print("speed 6x");

              historyProvider.changeNewMakerSpeed((70 * distance.round() - (50 * distance.round())));
              print(historyProvider.moveSpeedInSeconds);
            } else if (historyProvider.speedValue == 8) {
              print("speed 8x");

              historyProvider.changeNewMakerSpeed((60 * distance.round() - (45 * distance.round())));
              print(historyProvider.moveSpeedInSeconds);
            } else if (historyProvider.speedValue == 10) {
              print("speed 10x");

              historyProvider.changeNewMakerSpeed((50 * distance.round() - (40 * distance.round())));

              print(historyProvider.moveSpeedInSeconds);
            }
          }

          if (trackListLength > playerTimeLine) {
            double value = 1 / trackListLength;
            playerTimeLine = playerTimeLine + value;

            print("playerTimeLine ==>$playerTimeLine");
          }
          notifyListeners();

          print("new Speed ${historyProvider.moveSpeedInSeconds}");

          print(i);
          newAddress(historyProvider.trackList[i]);

          animateCar(
            startLat,
            startLag,
            historyProvider.trackList[i + 1].lat,
            historyProvider.trackList[i + 1].lng,
            mapMarkerSink,
            provider,
            historyProvider,
            mapController,
          );

          i = i + 1;
          timer2 = Timer.periodic(Duration(milliseconds: historyProvider.moveSpeedInSeconds), (_) {
            timer2.cancel();
            startMarker(i, provider, historyProvider);
          });
          notifyListeners();
        }
      }
    });
  }

  animateCar(
    double fromLat, //Starting latitude
    double fromLong, //Starting longitude
    double toLat, //Ending latitude
    double toLong, //Ending longitude
    StreamSink<List<Marker>> mapMarkerSink,
    //Stream build of map to update the UI
    TickerProvider provider,
    HistoryProvider historyProvider,
    //Ticker provider of the widget. This is used for animation
    GoogleMapController controller,
  ) async {
    final double bearing = getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));

    // var carMarkers = Marker(
    //   markerId: const MarkerId("driverMarker"),
    //   position: LatLng(fromLat, fromLong),
    //   icon:BitmapDescriptor.fromBytes(carPoint),
    //   anchor: const Offset(0.5, 0.5),
    //   flat: true,
    //   rotation: bearing,
    //   draggable: false,
    // );
    //
    // //Adding initial marker to the start location.
    // _markers.add(carMarkers);
    // mapMarkerSink.add(_markers);

    animationController = AnimationController(
      duration: Duration(milliseconds: historyProvider.moveSpeedInSeconds),
      //Animation duration of marker
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
        newPos1 = LatLng(lat, lng);
        // setState(() {
        Future.delayed(const Duration(seconds: 1), () {
          controller
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newPos, zoom: 15.5)));
        });
        //  });
        //  setState(() {

        //});

        if (pause == false) {
          // setState(() {
          startLat = newPos.latitude;
          startLag = newPos.longitude;
          // });
        }

        //

        //    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newPos, zoom: 15.5)));
        //Removing old marker if present in the marker array
        if (markers.contains(carPoint)) markers.remove(carPoint);

        //New marker location
        markers.remove("driverMarker");
        var carMarkers = Marker(
          markerId: const MarkerId("driverMarker"),
          position: newPos,
          icon: BitmapDescriptor.fromBytes(carPoint),
          anchor: const Offset(0.5, 0.5),
          flat: true,
          rotation: bearing,
          draggable: false,
        );

        //Adding new marker to our list and updating the google map UI.

        markers.add(carMarkers);
        await Future.delayed(const Duration(milliseconds: 500));
        mapMarkerSink.add(markers);

        //Moving the google camera to the new animated location.
        notifyListeners();
      });

    //Starting the animation
    animationController.forward();
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return degrees(math.atan(lng / lat));
    } else if (begin.latitude >= end.latitude && begin.longitude < end.longitude) {
      return (90 - degrees(math.atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude && begin.longitude >= end.longitude) {
      return degrees(math.atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude && begin.longitude >= end.longitude) {
      return (90 - degrees(math.atan(lng / lat))) + 270;
    }
    return -1;
  }

  newAddress(HistoryTrackModel latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.lat, latLng.lng);

    dateTime = latLng.insTime.toString();
    speed = latLng.speed;
    previousDis = previousDis + latLng.distanceFromPrevious;
    address = "${placemarks.first.name}"
        " ${placemarks.first.subLocality}"
        " ${placemarks.first.locality}"
        " ${placemarks.first.subAdministrativeArea} "
        "${placemarks.first.administrativeArea},"
        "${placemarks.first.postalCode}";
    notifyListeners();
  }

  LatLngBounds createBounds(List<LatLng> positions) {
    final southwestLat = positions
        .map((p) => p.latitude)
        .reduce((value, element) => value < element ? value : element); // smallest
    final southwestLon =
        positions.map((p) => p.longitude).reduce((value, element) => value < element ? value : element);
    final northeastLat = positions
        .map((p) => p.latitude)
        .reduce((value, element) => value > element ? value : element); // biggest
    final northeastLon =
        positions.map((p) => p.longitude).reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon), northeast: LatLng(northeastLat, northeastLon));
  }

  //TimeOfDay pickedTime = TimeOfDay.now();

  playPauseButton(BuildContext context, TickerProvider provider, HistoryProvider historyProvider) async {
    if (getId != "" || getIMEINo != "" || vehicleId != "") {
      if (pause == false) {
        pause = true;
        notifyListeners();
        startMarker(i, provider, historyProvider);
        await Future.delayed(const Duration(milliseconds: 100));
        mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newPos1, zoom: 15.5)));
      } else {
        pause = false;
        timer.cancel();
        timer2.cancel();
        animationController.dispose();
        notifyListeners();
      }
    } else {
      Helper.dialogCall.showToast(context, "${getTranslated(context, "select_vehicle")}");
    }
  }

  sliderOnChanges(double value, TickerProvider provider, HistoryProvider historyProvider) {
    notifyListeners();
    playerTimeLine = value;

    print(playerTimeLine);
    print(trackListLength.round().toString());
    timer.cancel();
    timer2.cancel();

    //     _markers = <Marker>[];
    //      _mapMarkerSC = StreamController<List<Marker>>();
    if (markers.contains(carPoint)) markers.remove(carPoint);
    //New marker location
    markers.remove("driverMarker");
    animationController.stop();
    mapController.dispose();

    int intValue = playerTimeLine.toInt();
    print(intValue); // This will print: 969
    //  await Future.delayed(const Duration(milliseconds: 500));
    startMarker(intValue, provider, historyProvider);
    // setState(() {
    //
    // });
    // staticMarker(60);
    //  await Future.delayed(const Duration(milliseconds: 1000));
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: newPos1,
          zoom: 15.5,
        ),
      ),
    );
    notifyListeners();
  }

  searchTap(BuildContext context, HistoryProvider historyProvider) {
    markers = <Marker>[];
    if (markers.contains(carPoint)) markers.remove(carPoint);
    markers.remove("driverMarker");
    markers.clear();
    notifyListeners();
    //New marker location
    address = "";
    playerTimeLine = 0;
    pause = false;
    timer != null ? timer.cancel() : "";
    timer2 != null ? timer2.cancel() : "";
    animationController != null ? animationController.stop() : "";
    //timer.cancel();
    //timer2.cancel();
    //animationController.stop();
    mapController.dispose();
    getTrack(context, historyProvider);
    getDistance(historyProvider);
  }

  oneHoure(BuildContext context, HistoryProvider historyProvider) async {
    var hour = DateTime.now().subtract(Duration(hours: 1));

    print("Fromdate is----------${fromDate}");
    print("todate is----------${DateTime.now().toUtc().toString()}");
    var fromDate1 = "${DateTime.now().subtract(Duration(hours: 1))}";

    fromDate = hour.toUtc().toString();
    toDate = DateTime.now().toUtc().toString();

    datedController.text =
        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(fromDate1).toLocal())}";
    endDateController.text = "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now().toLocal())}";

    // =========
    await Future.delayed(const Duration(milliseconds: 500));

    //  if(vehicleId != ""){
    // selectedtype = newValue;

    markers = <Marker>[];
    mapMarkerSC = StreamController<List<Marker>>();

    if (markers.contains(carPoint)) markers.remove(carPoint);
    //New marker location
    markers.remove("driverMarker");

    notifyListeners();
    address = "";
    playerTimeLine = 0;
    pause = false;
    timer != null ? timer.cancel() : "";
    timer2 != null ? timer.cancel() : "";
    //  timer.cancel();
    //timer2.cancel();
    animationController != null ? animationController.stop() : "";
    mapController.dispose();
    getTrack(context, historyProvider);
    getDistance(historyProvider);
  }

  todayOnTap(BuildContext context, HistoryProvider historyProvider) async {
    //T00:00:00.000Z
    DateTime now = DateTime.now(); // get the current date and time
    DateTime dateAtMidnight = DateTime(now.year, now.month, now.day, 0, 0, 0); // set the time to 12:00 am

    fromDate = dateAtMidnight.toUtc().toString();
    // fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
    toDate = DateTime.now().toUtc().toString();

    datedController.text =
        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight.toLocal().toString()))}";
    endDateController.text = "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now().toLocal())}";

    // =========
    await Future.delayed(const Duration(milliseconds: 500));

    //  if(vehicleId != ""){
    // selectedtype = newValue;

    markers = <Marker>[];
    mapMarkerSC = StreamController<List<Marker>>();

    if (markers.contains(carPoint)) markers.remove(carPoint);
    //New marker location
    markers.remove("driverMarker");

    notifyListeners();
    address = "";
    playerTimeLine = 0;
    pause = false;
    timer != null ? timer.cancel() : "";
    timer2 != null ? timer.cancel() : "";
    //  timer.cancel();
    //timer2.cancel();
    animationController != null ? animationController.stop() : "";
    mapController.dispose();
    getTrack(context, historyProvider);
    getDistance(historyProvider);
  }

  yesterdayOnTap(BuildContext context, HistoryProvider historyProvider) async {
    var yesterday = DateTime.now().subtract(Duration(days: 1));
    DateTime dateAtMidnight = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
    fromDate = dateAtMidnight.toUtc().toString();

    DateTime dateAtMidnight2 = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
    toDate = dateAtMidnight2.toUtc().toString();

    datedController.text =
        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight.toLocal().toString()))}";
    endDateController.text =
        "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight2.toLocal().toString()))}";

    // =========
    await Future.delayed(const Duration(milliseconds: 500));

    //  if(vehicleId != ""){
    // selectedtype = newValue;

    markers = <Marker>[];
    mapMarkerSC = StreamController<List<Marker>>();

    if (markers.contains(carPoint)) markers.remove(carPoint);
    //New marker location
    markers.remove("driverMarker");

    notifyListeners();
    address = "";
    playerTimeLine = 0;
    pause = false;
    timer != null ? timer.cancel() : "";
    timer2 != null ? timer.cancel() : "";
    //  timer.cancel();
    //timer2.cancel();
    animationController != null ? animationController.stop() : "";
    mapController.dispose();
    getTrack(context, historyProvider);
    getDistance(historyProvider);
  }

  weekOnTap(BuildContext context, HistoryProvider historyProvider) async {
    DateTime currentDateTime = DateTime.now();

    // Calculate the difference between the current day of the week and Sunday (0)
    int daysUntilLastSunday = currentDateTime.weekday - DateTime.sunday;

    // Subtract the difference in days to get the date of the last Sunday
    DateTime lastSundayDateTime = currentDateTime.subtract(Duration(days: daysUntilLastSunday + 7));

    DateTime dateAtMidnight =
        DateTime(lastSundayDateTime.year, lastSundayDateTime.month, lastSundayDateTime.day, 0, 0, 0);

    fromDate = dateAtMidnight.toUtc().toString();
    toDate = DateTime.now().toUtc().toString();

    datedController.text = "${DateFormat("dd MMM yyyy hh:ss aa").format(dateAtMidnight.toLocal())}";
    endDateController.text = "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now().toLocal())}";

    // =========
    await Future.delayed(const Duration(milliseconds: 500));

    //  if(vehicleId != ""){
    // selectedtype = newValue;

    markers = <Marker>[];
    mapMarkerSC = StreamController<List<Marker>>();

    if (markers.contains(carPoint)) markers.remove(carPoint);
    //New marker location
    markers.remove("driverMarker");

    notifyListeners();
    address = "";
    playerTimeLine = 0;
    pause = false;
    timer != null ? timer.cancel() : "";
    timer2 != null ? timer.cancel() : "";
    //  timer.cancel();
    //timer2.cancel();
    animationController != null ? animationController.stop() : "";
    mapController.dispose();
    getTrack(context, historyProvider);
    getDistance(historyProvider);
  }

  iconForLive() {
    isChangeMap = true;
    if (mapType == MapType.normal) {
      mapType = MapType.satellite;
    } else if (mapType == MapType.satellite) {
      mapType = MapType.terrain;
    } else if (mapType == MapType.terrain) {
      mapType = MapType.hybrid;
    } else if (mapType == MapType.hybrid) {
      mapType = MapType.normal;
    }
    notifyListeners();
  }

  forDistanceReport() {
    hidePolyline = !hidePolyline;
    notifyListeners();
  }

//   {
//   //T00:00:00.000Z
//   DateTime now = DateTime.now(); // get the current date and time
//   DateTime dateAtMidnight =
//   DateTime(now.year, now.month, now.day, 0, 0, 0); // set the time to 12:00 am
//
//   mapProvider.fromDate = dateAtMidnight.toUtc().toString();
//   // fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
//   mapProvider.toDate = DateTime.now().toUtc().toString();
//
//   mapProvider.datedController.text =
//   "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight.toLocal().toString()))}";
//   mapProvider.endDateController.text =
//   "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now().toLocal())}";
//
//   // =========
//   await Future.delayed(const Duration(milliseconds: 500));
//
//   //  if(vehicleId != ""){
//   // selectedtype = newValue;
//
//   mapProvider.markers = <Marker>[];
//   mapProvider.mapMarkerSC = StreamController<List<Marker>>();
//
//   if (mapProvider.markers.contains(mapProvider.carPoint))
//   mapProvider.markers.remove(mapProvider.carPoint);
//   //New marker location
//   mapProvider.markers.remove("driverMarker");
//
//   setState(() {});
//   mapProvider.address = "";
//   mapProvider.playerTimeLine = 0;
//   mapProvider.pause = false;
//   mapProvider.timer != null ? mapProvider.timer.cancel() : "";
//   mapProvider.timer2 != null ? mapProvider.timer.cancel() : "";
//   //  timer.cancel();
//   //timer2.cancel();
//   mapProvider.animationController != null ? mapProvider.animationController.stop() : "";
//   mapProvider.mapController.dispose();
//   mapProvider.getTrack(context);
//   mapProvider.getDistance();
// },
}
