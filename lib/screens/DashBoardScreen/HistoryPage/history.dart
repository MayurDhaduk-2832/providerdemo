import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/histroy_track_model.dart';
import 'package:oneqlik/Provider/histroy_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/histoy_vehicle_filter.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math.dart';

import '../../ProductsFilterPage/vehicle_filter.dart';

class HistoryPage extends StatefulWidget {
  String formDate, toDate, deviceId, vId, deviceName, km, deviceType;

  HistoryPage(
      {Key key,
      this.formDate,
      this.toDate,
      this.deviceId,
      this.vId,
      this.deviceName,
      this.km,
      this.deviceType})
      : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  var height, width;
  TextEditingController datedController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController currentdateController = new TextEditingController();

  bool isChangeMap = false;
  MapType mapType = MapType.normal;

  HistoryProvider historyProvider;
  GoogleMapController mapController;

  bool isSelected = false;
  var val;
  String selectedtype;

  List<DropdownMenuItem<String>> get dropdownTypeItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text('${getTranslated(context, "today")}'), value: "Today"),
      DropdownMenuItem(
          child: Text('${getTranslated(context, "1_hour")}'), value: "1 Hour"),
      DropdownMenuItem(
          child: Text('${getTranslated(context, "yesterday")}'),
          value: "Yesterday"),
      DropdownMenuItem(
          child: Text('${getTranslated(context, "week")}'), value: "Week"),
    ];
    return menuItems;
  }

  var fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc())}";
  var toDate = DateTime.now().toUtc().toString();

  Uint8List carPoint, endPoint, startPoint, parkingPoint;

  createMarker() async {
    carPoint = await getBytesFromAsset('assets/images/car2.png', 40);
    parkingPoint =
        await getBytesFromAsset('assets/images/parking_point.png', 40);
    startPoint = await getBytesFromAsset('assets/images/start_point.png', 50);
    endPoint = await getBytesFromAsset('assets/images/stop_point.png', 50);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  var vehicleId = "", vId = "";
  Animation<double> _animation;
  Set<Marker> markers = {};
  Set<Marker> drawMarkers = {};

  int trackListLength = 0;
  double playerTimeLine = 0;
  var getId = "", getIMEINo = "";
  LatLng newPos1;

  getTrack() async {
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
      if (historyProvider.trackList.isNotEmpty &&
          historyProvider.trackLat.isNotEmpty) {
        setState(() {
          trackListLength = historyProvider.trackList.length;
        });

        getUserAddress(historyProvider.trackLat.first.latitude,
            historyProvider.trackLat.first.longitude);
        markers.clear();
        debugPrint('markers ---------->>>>>>>> ${markers}');
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
        setState(() {
          markers.addAll(list);
          // _mapMarkerSink.add(_markers);
          getParkingMark();
          print("method list${historyProvider.trackLat.length}");
        });
      } else {
        print("Data is not available");
        address = "";
        dateTime = "";
        speed = "0";
        previousDis = 0.0;
        historyProvider.parkingList.clear();
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(34.0479, 100.6197), zoom: 4),
          ),
        );
      }
    }
  }

  getParkingMark() async {
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
            'sec-ch-ua':
                '"Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"',
            'Accept': 'application/json, text/plain, /',
            'content-type': 'application/json',
            'Referer': 'https://www.oneqlik.in/glocation',
            'sec-ch-ua-mobile': '?0',
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
            'sec-ch-ua-platform': '"Windows"'
          };
          var request = http.Request(
              'POST',
              Uri.parse(
                  'https://www.oneqlik.in/googleAddress/getGoogleAddress'));
          request.body = json.encode({
            "lat": historyProvider.parkingList[i].lat,
            "long": historyProvider.parkingList[i].long
          });
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
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
                                    Divider(
                                        color:
                                            ApplicationColors.blackbackcolor),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    Divider(
                                        color:
                                            ApplicationColors.blackbackcolor),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                DateFormat("dd-MM-yyyy hh:mm:ss aa")
                                                        .format(historyProvider
                                                            .parkingList[i]
                                                            .arrivalTime) ??
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
                                                DateFormat("dd-MM-yyyy hh:mm:ss aa")
                                                        .format(historyProvider
                                                            .parkingList[i]
                                                            .departureTime) ??
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
              icon: await getMarkerIcon(
                  "assets/images/parking_point.png",
                  Size(140, 140),
                  "${(historyProvider.parkingList.length - i) - 1}"),
            ),
          );

          // _mapMarkerSink.add(_markers);
        }
      }
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    mapController.animateCamera(CameraUpdate.newLatLngBounds(
        _createBounds(historyProvider.trackLat), 100));
  }

  getDistance() async {
    var data = {
      "imei": "$getIMEINo",
      "from": fromDate,
      "to": toDate,
    };

    print("distance$data");

    await historyProvider.getDistance(data, "gps/getDistanceSpeed");
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

  Future<BitmapDescriptor> getMarkerIcon(
      String imagePath, Size size, String carName) async {
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
          center: Offset(size.width - textPainter.width / 2,
              tagWidth - textPainter.height),
          width: 350,
          height: 80),
      Radius.circular(60),
    );

    canvas.drawRRect(fullRect, paint1);

    textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) * 0.5,
            tagWidth - textPainter.height));

    // Oval for the image
    Rect oval =
        Rect.fromLTWH(0.0, 30.0, size.width, size.height - textPainter.height);

    // Add image
    ui.Image image = await getImageFromPath(
        imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.scaleDown);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Timer timer;
  Timer timer2;
  int i = 0;
  bool replay = false, hidePolyline = false, pause = false;

  var startLat = 0.0;
  var startLag = 0.0;

  var address = "", dateTime = "", speed = "0", deviceName;
  dynamic previousDis = 0.0;

  startMarker(i) {
    if (previousDis == 0.0 || replay == true) {
      previousDis = 0.0;
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
          getDistance();
          timer.cancel();
          if (historyProvider.trackList.length > i) {
            if (pause) {
              print(historyProvider.trackList.length);
              print(i);
              setState(() {
                startLat = historyProvider.trackList[i].lat;
                startLag = historyProvider.trackList[i].lng;
              });
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

              historyProvider.changeNewMakerSpeed(
                  (90 * distance.round() - (20 * distance.round())));
              print(historyProvider.moveSpeedInSeconds);
            } else if (historyProvider.speedValue == 4) {
              print("speed 4x");

              historyProvider.changeNewMakerSpeed(
                  (80 * distance.round() - (40 * distance.round())));
              print(historyProvider.moveSpeedInSeconds);
            } else if (historyProvider.speedValue == 6) {
              print("speed 6x");

              historyProvider.changeNewMakerSpeed(
                  (70 * distance.round() - (50 * distance.round())));
              print(historyProvider.moveSpeedInSeconds);
            } else if (historyProvider.speedValue == 8) {
              print("speed 8x");

              historyProvider.changeNewMakerSpeed(
                  (60 * distance.round() - (45 * distance.round())));
              print(historyProvider.moveSpeedInSeconds);
            } else if (historyProvider.speedValue == 10) {
              print("speed 10x");

              historyProvider.changeNewMakerSpeed(
                  (50 * distance.round() - (40 * distance.round())));

              print(historyProvider.moveSpeedInSeconds);
            }
          }

          setState(() {
            if (trackListLength > playerTimeLine) {
              double value = 1 / trackListLength;
              playerTimeLine = playerTimeLine + value;

              print("playerTimeLine ==>$playerTimeLine");
            }
          });

          print("new Speed ${historyProvider.moveSpeedInSeconds}");

          print(i);
          newAddress(historyProvider.trackList[i]);

          animateCar(
            startLat,
            startLag,
            historyProvider.trackList[i + 1].lat,
            historyProvider.trackList[i + 1].lng,
            // _mapMarkerSink,
            this,
            mapController,
          );

          setState(() {
            i = i + 1;
            timer2 = Timer.periodic(
                Duration(milliseconds: historyProvider.moveSpeedInSeconds),
                (_) {
              timer2.cancel();
              startMarker(i);
            });
          });
        }
      }
    });
  }

  AnimationController animationController;

  animateCar(
    double fromLat, //Starting latitude
    double fromLong, //Starting longitude
    double toLat, //Ending latitude
    double toLong, //Ending longitude
    // StreamSink<List<Marker>> mapMarkerSink,
    //Stream build of map to update the UI
    TickerProvider provider,
    //Ticker provider of the widget. This is used for animation
    GoogleMapController controller,
  ) async {
    final double bearing =
        getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));

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
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: newPos, zoom: 15.5)));
        });

        if (pause == false) {
          startLat = newPos.latitude;
          startLag = newPos.longitude;
        }

        if (drawMarkers.contains(carPoint)) drawMarkers.remove(carPoint);

        //New marker location
        drawMarkers.remove("driverMarker");
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

        drawMarkers.add(carMarkers);
        await Future.delayed(const Duration(milliseconds: 500));
        // mapMarkerSink.add(_markers);

        //Moving the google camera to the new animated location.
        if (mounted) {
          setState(() {});
        }
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

  newAddress(HistoryTrackModel latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.lat, latLng.lng);

    setState(() {
      dateTime = latLng.insTime.toString();
      speed = latLng.speed;
      previousDis = previousDis + latLng.distanceFromPrevious;
      address = "${placemarks.first.name}"
          " ${placemarks.first.subLocality}"
          " ${placemarks.first.locality}"
          " ${placemarks.first.subAdministrativeArea} "
          "${placemarks.first.administrativeArea},"
          "${placemarks.first.postalCode}";
    });
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

  UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    markers.clear();
    drawMarkers.clear();
    if (widget.deviceId != null) {
      setState(() {
        markers.clear();
        drawMarkers.clear();
        address = "";
        playerTimeLine = 0;

        getId = widget.vId;
        getIMEINo = widget.deviceId;
        fromDate = widget.formDate;
        toDate = widget.toDate;
        deviceName = widget.deviceName;

        print("back data $getId,$getIMEINo,$fromDate,$toDate");
      });

      getTrack();
      getDistance();
    }
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    historyProvider = Provider.of<HistoryProvider>(context, listen: false);

    historyProvider.distance = "0.0";
    historyProvider.trackLat.clear();
    historyProvider.parkingList.clear();
    markers.clear();
    drawMarkers.clear();
    createMarker();

    if (widget.deviceName != null &&
        widget.vId != null &&
        widget.deviceId != null &&
        widget.toDate != null &&
        widget.formDate != null) {
      getIMEINo = widget.deviceId;
      getId = "${widget.vId}";
      fromDate = "${widget.formDate}";
      toDate = "${widget.toDate}";
      deviceName = '${widget.deviceName}';

      DateTime now = DateTime.now(); // get the current date and time
      DateTime dateAtMidnight = DateTime(now.year, now.month, now.day);
      fromDate = dateAtMidnight.toUtc().toString();
      // fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
      toDate = DateTime.now().toUtc().toString();

      Future.delayed(Duration(microseconds: 100), () {
        datedController.text =
            "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight.toString()))}";
        _endDateController.text =
            "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now())}";
        getTrack();
        getDistance();
      });
    }
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

  // DateTime date;
  TimeOfDay fromPickedTime;
  TimeOfDay endPickedTime;
  DateTime fromDatePicked;
  DateTime endDatePicked;

  //TimeOfDay pickedTime = TimeOfDay.now();
  dateTimeSelect() async {
    fromDatePicked = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: fromDatePicked == null ? DateTime.now() : fromDatePicked,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.redColor67,
              onPrimary: ApplicationColors.whiteColor,
              surface: ApplicationColors.redColor67,
              onSurface: ApplicationColors.blackbackcolor,
            ),
            dialogBackgroundColor: ApplicationColors.whiteColor,
          ),
          child: child,
        );
      },
    );

    fromPickedTime = await showTimePicker(
      context: context,
      initialTime: fromPickedTime == null ? TimeOfDay.now() : fromPickedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: ApplicationColors.primaryTextColor,
              onPrimary: ApplicationColors.blackbackcolor,
              surface: ApplicationColors.whiteColor,
              onSurface: ApplicationColors.blackbackcolor,
            ),
            dialogBackgroundColor: ApplicationColors.whiteColor,
          ),
          child: child,
        );
      },
    );

    if (fromDatePicked != null) {
      //  setState(() {
      this.fromDatePicked = DateTime(fromDatePicked.year, fromDatePicked.month,
          fromDatePicked.day, fromPickedTime.hour, fromPickedTime.minute);
      datedController.text =
          "${DateFormat("dd MMM yyyy hh:mm a").format(fromDatePicked.toLocal())}";
      fromDate = fromDatePicked.toUtc().toString();
      //  });

      /* if (datedController.text != null && _selectedVehicle.isNotEmpty) {
        acReport();
      }*/
    }
  }

  endDateTimeSelect() async {
    endDatePicked = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: endDatePicked == null ? DateTime.now() : endDatePicked,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.redColor67,
              onPrimary: ApplicationColors.whiteColor,
              surface: ApplicationColors.redColor67,
              onSurface: ApplicationColors.blackbackcolor,
            ),
            dialogBackgroundColor: ApplicationColors.whiteColor,
          ),
          child: child,
        );
      },
    );

    endPickedTime = await showTimePicker(
      context: context,
      initialTime: endPickedTime == null ? TimeOfDay.now() : endPickedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.primaryTextColor,
              onPrimary: ApplicationColors.blackbackcolor,
              surface: ApplicationColors.whiteColor,
              onSurface: ApplicationColors.blackbackcolor,
            ),
            dialogBackgroundColor: ApplicationColors.whiteColor,
            backgroundColor: ApplicationColors.whiteColor,
          ),
          child: child,
        );
      },
    );

    if (endDatePicked != null) {
      //  setState(() {
      this.endDatePicked = DateTime(endDatePicked.year, endDatePicked.month,
          endDatePicked.day, endPickedTime.hour, endPickedTime.minute);
      _endDateController.text =
          "${DateFormat("dd MMM yyyy hh:mm a").format(endDatePicked.toLocal())}";
      toDate = endDatePicked.toUtc().toString();
      //   });

      /*  if (_endDateController.text != null && _selectedVehicle.length != 0) {
        acReport();
      }*/
    }
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    if (timer2 != null) {
      timer2.cancel();
    }
    if (animationController != null) {
      animationController.dispose();
    }
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: true);
    historyProvider = Provider.of<HistoryProvider>(context, listen: true);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          getTranslated(context, "view history"),
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
                Color(0xffb751c1e),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        elevation: 0,
        color: ApplicationColors.blackColor2E,
        shape: CircularNotchedRectangle(),
        child: IntrinsicHeight(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                address == ""
                    ? Container()
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  "assets/images/gps1.png",
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  "$address",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Textstyle1.signupText.copyWith(
                                      fontSize: 12,
                                      color: ApplicationColors.black4240),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/Battery.png",
                                      color: ApplicationColors.redColor67,
                                      width: 12,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "0 ${getTranslated(context, "v")}",
                                      style: Textstyle1.signupText.copyWith(
                                        fontSize: 15,
                                        color: ApplicationColors.black4240,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: ApplicationColors.greyC4C4,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (getId != "" ||
                                        getIMEINo != "" ||
                                        vehicleId != "") {
                                      if (pause == false) {
                                        setState(() {
                                          pause = true;
                                        });
                                        startMarker(i);
                                        await Future.delayed(
                                            const Duration(milliseconds: 100));
                                        mapController.moveCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: newPos1,
                                                    zoom: 15.5)));
                                      } else {
                                        setState(() {
                                          pause = false;
                                          timer.cancel();
                                          timer2.cancel();
                                          animationController.dispose();
                                        });
                                      }
                                    } else {
                                      Helper.dialogCall.showToast(context,
                                          "${getTranslated(context, "select_vehicle")}");
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: ApplicationColors.redColor67,
                                      ),
                                    ),
                                    child: pause
                                        ? Icon(
                                            Icons.pause,
                                            color: ApplicationColors.redColor67,
                                          )
                                        : Image.asset(
                                            "assets/images/play_icon.png",
                                            scale: 5,
                                            color: ApplicationColors.redColor67,
                                          ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: ApplicationColors.greyC4C4,
                                ),
                                Expanded(
                                  child: Slider(
                                    value: playerTimeLine,
                                    label: trackListLength.round().toString(),
                                    min: 0,
                                    max: trackListLength.toDouble(),
                                    activeColor: ApplicationColors.redColor67,
                                    inactiveColor:
                                        ApplicationColors.dropdownColor3D,
                                    onChanged: (double value) {
                                      playerTimeLine = value;

                                      print(playerTimeLine);
                                      print(trackListLength.round().toString());
                                      timer.cancel();
                                      timer2.cancel();

                                      if (drawMarkers.contains(carPoint))
                                        drawMarkers.remove(carPoint);
                                      drawMarkers.remove("driverMarker");
                                      animationController.stop();
                                      mapController.dispose();
                                      int intValue = playerTimeLine.toInt();
                                      print(intValue); // This will print: 969
                                      startMarker(intValue);
                                      mapController.moveCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            target: newPos1,
                                            zoom: 15.5,
                                          ),
                                        ),
                                      );

                                      if (mounted) {
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (historyProvider.speedValue == 1) {
                                      historyProvider.changeSpeedValue(2);
                                    } else if (historyProvider.speedValue ==
                                        2) {
                                      historyProvider.changeSpeedValue(4);
                                    } else if (historyProvider.speedValue ==
                                        4) {
                                      historyProvider.changeSpeedValue(6);
                                    } else if (historyProvider.speedValue ==
                                        6) {
                                      historyProvider.changeSpeedValue(8);
                                    } else if (historyProvider.speedValue ==
                                        8) {
                                      historyProvider.changeSpeedValue(10);
                                    } else if (historyProvider.speedValue ==
                                        10) {
                                      historyProvider.changeSpeedValue(1);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "${historyProvider.speedValue}px",
                                        style: Textstyle1.signupText.copyWith(
                                            fontSize: 14,
                                            color: ApplicationColors
                                                .blackbackcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Appcolors.text_grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: ApplicationColors.greyC4C4,
                          ),
                        ],
                      ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/clock_icon_vehicle_Page.png",
                            color: Appcolors.text_grey,
                            width: 20,
                          ),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              dateTime == ""
                                  ? SizedBox()
                                  : Text(
                                      "${DateFormat("dd MMM yy").format(DateTime.parse(dateTime).toLocal())}",
                                      style: Textstyle1.signupText.copyWith(
                                        fontSize: 10,
                                        color: ApplicationColors.black4240,
                                      ),
                                    ),
                              Text(
                                dateTime == ""
                                    ? "00:00:00"
                                    : "${DateFormat("hh:mm:ss").format(DateTime.parse(dateTime).toUtc().toLocal())}",
                                style: Textstyle1.signupText.copyWith(
                                  fontSize: 12,
                                  color: ApplicationColors.black4240,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Image.asset("assets/images/vehicle_page_icon.png",
                              width: 20, color: ApplicationColors.redColor67),
                          SizedBox(width: 10),
                          Text(
                            "$speed"
                            "${_userProvider.useModel.cust.unitMeasurement == "${getTranslated(context, "mks")}" ? "${getTranslated(context, "km_hr")}" : "${getTranslated(context, "Miles_hr")}"} ",
                            style: Textstyle1.signupText.copyWith(
                              fontSize: 12,
                              color: ApplicationColors.black4240,
                            ),
                          ),
                          Spacer(),
                          Image.asset("assets/images/vehicle_page_icon2.png",
                              width: 20, color: ApplicationColors.redColor67),
                          SizedBox(width: 10),
                          Text(
                            "${NumberFormat("##0.0#", "en_US").format((previousDis))}"
                            "${_userProvider.useModel.cust.unitMeasurement == "${getTranslated(context, "mks")}" ? "${getTranslated(context, "kms")}" : "${getTranslated(context, "Miles")}"}",
                            style: Textstyle1.signupText.copyWith(
                              fontSize: 12,
                              color: ApplicationColors.black4240,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: ApplicationColors.greyC4C4,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      deviceName == null
                          ? Container()
                          : Text(
                              deviceName,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.normal,
                                color: ApplicationColors.black4240,
                              ),
                            ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/route_icon.png",
                            color: ApplicationColors.redColor67,
                            width: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "${historyProvider.distance == null ? 0 : "${historyProvider.distance}"}"
                            "${_userProvider.useModel.cust.unitMeasurement == "${getTranslated(context, "mks")}" ? "${getTranslated(context, "kms")}" : "${getTranslated(context, "Miles")}"}",
                            style: Textstyle1.signupText.copyWith(
                              fontSize: 15,
                              color: ApplicationColors.black4240,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: historyProvider.trackLat.first,
                                      zoom: 15.5)));
                              if (vehicleId != "") {
                                //  setState(() async {
                                timer.cancel();
                                timer2.cancel();
                                drawMarkers.clear();
                                markers.clear();
                                // _mapMarkerSink.done;
                                replay = true;
                                pause = true;
                                i = 0;
                                playerTimeLine = 0;

                                double value = 1 / trackListLength;
                                playerTimeLine = playerTimeLine + value;
                                List<Marker> list = [
                                  Marker(
                                    markerId: MarkerId("startPoint"),
                                    position: historyProvider.trackLat.first,
                                    icon:
                                        BitmapDescriptor.fromBytes(startPoint),
                                  ),
                                  Marker(
                                    markerId: MarkerId("endPoint"),
                                    position: historyProvider.trackLat.last,
                                    icon: BitmapDescriptor.fromBytes(endPoint),
                                  ),
                                ];
                                markers.addAll(list);
                                // _mapMarkerSink.add(_markers);

                                //   });
                                startMarker(0);
                              }
                            },
                            child: Image.asset(
                              "assets/images/rewind_icon_.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                hidePolyline = !hidePolyline;
                              });
                            },
                            child: Container(
                              height: 34,
                              width: 34,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/images/distance_reports_.png",
                                color: ApplicationColors.redColor67,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                var value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HistoryFilter(
                              selectedId: getId,
                              fromDate: fromDate,
                              toDate: toDate,
                              getIMEINo: getIMEINo,
                              deviceName: deviceName,
                            )));

                if (value != null) {
                  print("VALUE : $value");

                  //   setState(() {
                  markers.clear();
                  drawMarkers.clear();
                  address = "";
                  playerTimeLine = 0;

                  getId = value[0];
                  getIMEINo = value[1];
                  fromDate = value[2];
                  toDate = value[3];
                  deviceName = value[4];

                  print("back data $getId,$getIMEINo,$fromDate,$toDate");
                  //   });

                  getTrack();
                  getDistance();
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
                    deviceName == null
                        ? Container()
                        : Text(
                            deviceName,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.normal,
                              color: ApplicationColors.black4240,
                            ),
                          ),
                    Icon(Icons.arrow_drop_down_sharp),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              //color: ApplicationColors.GreyColorC0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            maxLines: 2,
                            readOnly: true,
                            style: Textstyle1.signupText1,
                            keyboardType: TextInputType.number,
                            controller: datedController,
                            focusNode: AlwaysDisabledFocusNode(),
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              dateTimeSelect();
                            },
                            decoration: fieldStyle.copyWith(
                              fillColor: ApplicationColors.transparentColors,
                              isDense: true,
                              hintText: "From Date\n$fromDate",
                              prefixIcon: Icon(
                                Icons.access_time_sharp,
                                size: 30,
                                color: ApplicationColors.greenColor,
                              ),
                              hintStyle: Textstyle1.signupText.copyWith(
                                color: ApplicationColors.blackbackcolor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ApplicationColors.transparentColors,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ApplicationColors.transparentColors,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ApplicationColors.transparentColors,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            maxLines: 2,
                            readOnly: true,
                            style: Textstyle1.signupText1,
                            keyboardType: TextInputType.number,
                            controller: _endDateController,
                            focusNode: AlwaysDisabledFocusNode(),
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              endDateTimeSelect();
                            },
                            decoration: fieldStyle.copyWith(
                              fillColor: ApplicationColors.transparentColors,
                              hintStyle: Textstyle1.signupText.copyWith(
                                color: ApplicationColors.blackbackcolor,
                              ),
                              prefixIcon: Icon(
                                Icons.access_time_sharp,
                                size: 30,
                                color: ApplicationColors.redColor,
                              ),
                              hintText: "End Date\n$fromDate",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ApplicationColors.transparentColors,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ApplicationColors.transparentColors,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ApplicationColors.transparentColors,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            markers = Set();
                            if (drawMarkers.contains(carPoint))
                              drawMarkers.remove(carPoint);
                            drawMarkers.remove("driverMarker");
                            markers.clear();
                            drawMarkers.clear();
                            setState(() {});
                            //New marker location
                            address = "";
                            playerTimeLine = 0;
                            pause = false;
                            timer != null ? timer.cancel() : "";
                            timer2 != null ? timer2.cancel() : "";
                            animationController != null
                                ? animationController.stop()
                                : "";
                            //timer.cancel();
                            //timer2.cancel();
                            //animationController.stop();
                            mapController.dispose();
                            getTrack();
                            getDistance();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.search,
                              size: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        var hour = DateTime.now().subtract(Duration(hours: 1));

                        print("Fromdate is----------$fromDate");
                        print(
                            "todate is----------${DateTime.now().toUtc().toString()}");
                        var fromDate1 =
                            "${DateTime.now().subtract(Duration(hours: 1))}";

                        fromDate = hour.toUtc().toString();
                        toDate = DateTime.now().toUtc().toString();

                        datedController.text =
                            "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(fromDate1).toLocal())}";
                        _endDateController.text =
                            "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now().toLocal())}";

                        // =========
                        await Future.delayed(const Duration(milliseconds: 500));

                        //  if(vehicleId != ""){
                        // selectedtype = newValue;

                        markers = {};
                        // _mapMarkerSC = StreamController<List<Marker>>();

                        if (drawMarkers.contains(carPoint))
                          drawMarkers.remove(carPoint);
                        //New marker location
                        drawMarkers.remove("driverMarker");

                        setState(() {});
                        address = "";
                        playerTimeLine = 0;
                        pause = false;
                        timer != null ? timer.cancel() : "";
                        timer2 != null ? timer.cancel() : "";
                        //  timer.cancel();
                        //timer2.cancel();
                        animationController != null
                            ? animationController.stop()
                            : "";
                        mapController.dispose();
                        getTrack();
                        getDistance();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xffee851c),
                        ),
                        child: Text(
                          "1 HOUR",
                          style: TextStyle(
                            fontSize: 12,
                            color: ApplicationColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () async {
                        //T00:00:00.000Z
                        DateTime now =
                            DateTime.now(); // get the current date and time
                        DateTime dateAtMidnight = DateTime(now.year, now.month,
                            now.day, 0, 0, 0); // set the time to 12:00 am

                        fromDate = dateAtMidnight.toUtc().toString();
                        // fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
                        toDate = DateTime.now().toUtc().toString();

                        datedController.text =
                            "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight.toLocal().toString()))}";
                        _endDateController.text =
                            "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now().toLocal())}";

                        // =========
                        await Future.delayed(const Duration(milliseconds: 500));

                        //  if(vehicleId != ""){
                        // selectedtype = newValue;

                        markers = {};
                        // _mapMarkerSC = StreamController<List<Marker>>();

                        if (drawMarkers.contains(carPoint))
                          drawMarkers.remove(carPoint);
                        //New marker location
                        drawMarkers.remove("driverMarker");
                        markers.clear();
                        setState(() {});
                        address = "";
                        playerTimeLine = 0;
                        pause = false;
                        timer != null ? timer.cancel() : "";
                        timer2 != null ? timer.cancel() : "";
                        //  timer.cancel();
                        //timer2.cancel();
                        animationController != null
                            ? animationController.stop()
                            : "";
                        mapController.dispose();
                        getTrack();
                        getDistance();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xffee851c),
                        ),
                        child: Text(
                          "TODAY",
                          style: TextStyle(
                            fontSize: 12,
                            color: ApplicationColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () async {
                        var yesterday =
                            DateTime.now().subtract(Duration(days: 1));
                        DateTime dateAtMidnight = DateTime(yesterday.year,
                            yesterday.month, yesterday.day, 0, 0, 0);
                        fromDate = dateAtMidnight.toUtc().toString();

                        DateTime dateAtMidnight2 = DateTime(yesterday.year,
                            yesterday.month, yesterday.day, 23, 59, 59);
                        toDate = dateAtMidnight2.toUtc().toString();

                        datedController.text =
                            "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight.toLocal().toString()))}";
                        _endDateController.text =
                            "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.parse(dateAtMidnight2.toLocal().toString()))}";

                        // =========
                        await Future.delayed(const Duration(milliseconds: 500));

                        //  if(vehicleId != ""){
                        // selectedtype = newValue;

                        markers = {};
                        // _mapMarkerSC = StreamController<List<Marker>>();

                        if (drawMarkers.contains(carPoint))
                          drawMarkers.remove(carPoint);
                        //New marker location
                        drawMarkers.remove("driverMarker");

                        setState(() {});
                        address = "";
                        playerTimeLine = 0;
                        pause = false;
                        timer != null ? timer.cancel() : "";
                        timer2 != null ? timer.cancel() : "";
                        //  timer.cancel();
                        //timer2.cancel();
                        animationController != null
                            ? animationController.stop()
                            : "";
                        mapController.dispose();
                        getTrack();
                        getDistance();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xffee851c),
                        ),
                        child: Text(
                          "YESTERDAY",
                          style: TextStyle(
                            fontSize: 12,
                            color: ApplicationColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () async {
                        DateTime currentDateTime = DateTime.now();

                        // Calculate the difference between the current day of the week and Sunday (0)
                        int daysUntilLastSunday =
                            currentDateTime.weekday - DateTime.sunday;

                        // Subtract the difference in days to get the date of the last Sunday
                        DateTime lastSundayDateTime = currentDateTime
                            .subtract(Duration(days: daysUntilLastSunday + 7));

                        DateTime dateAtMidnight = DateTime(
                            lastSundayDateTime.year,
                            lastSundayDateTime.month,
                            lastSundayDateTime.day,
                            0,
                            0,
                            0);

                        fromDate = dateAtMidnight.toUtc().toString();
                        toDate = DateTime.now().toUtc().toString();

                        datedController.text =
                            "${DateFormat("dd MMM yyyy hh:ss aa").format(dateAtMidnight.toLocal())}";
                        _endDateController.text =
                            "${DateFormat("dd MMM yyyy hh:ss aa").format(DateTime.now().toLocal())}";

                        // =========
                        await Future.delayed(const Duration(milliseconds: 500));

                        //  if(vehicleId != ""){
                        // selectedtype = newValue;

                        markers = {};
                        // _mapMarkerSC = StreamController<List<Marker>>();

                        if (drawMarkers.contains(carPoint))
                          drawMarkers.remove(carPoint);
                        //New marker location
                        drawMarkers.remove("driverMarker");

                        setState(() {});
                        address = "";
                        playerTimeLine = 0;
                        pause = false;
                        timer != null ? timer.cancel() : "";
                        timer2 != null ? timer.cancel() : "";
                        //  timer.cancel();
                        //timer2.cancel();
                        animationController != null
                            ? animationController.stop()
                            : "";
                        mapController.dispose();
                        getTrack();
                        getDistance();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xffee851c),
                        ),
                        child: Text(
                          "WEEK",
                          style: TextStyle(
                            fontSize: 12,
                            color: ApplicationColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                SizedBox(
                  height: height * 0.80,
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(34.0479, 100.6197), zoom: 4),
                    mapType: isChangeMap ? mapType : Utils.mapType,
                    //map type
                    markers: Set.from(markers)..addAll(drawMarkers),
                    polylines: historyProvider.trackLat.isEmpty || hidePolyline
                        ? {}
                        : Set<Polyline>.of(
                            <Polyline>[
                              Polyline(
                                polylineId: PolylineId("start"),
                                visible: true,
                                points: historyProvider.trackLat,
                                width: 2,
                                color: ApplicationColors.black4240,
                              ),
                            ],
                          ),
                    onMapCreated: (controller) {
                      //   setState(() {
                      mapController = controller;
                      if (historyProvider.trackLat.isNotEmpty) {
                        mapController.animateCamera(
                            CameraUpdate.newLatLngBounds(
                                _createBounds(historyProvider.trackLat), 100));
                      }
                      // });
                    },
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 15,
                  child: InkWell(
                    onTap: () {
                      setState(() {
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
                      });
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ApplicationColors.blackColor2E,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        "assets/images/maap_icon_for_live_screen.png",
                        color: Color(0xfff70b3c),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 240,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          mapController.animateCamera(CameraUpdate.zoomIn());
                        },
                        child: Container(
                          width: 37,
                          height: 37,
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/images/add_ic.png",
                            color: ApplicationColors.redColor67,
                          ),
                          decoration: const BoxDecoration(
                            color: ApplicationColors.blackColor2E,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7),
                              topRight: Radius.circular(7),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          mapController.animateCamera(CameraUpdate.zoomOut());
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 1),
                          width: 37,
                          height: 37,
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/images/minimise_ic.png",
                            color: ApplicationColors.redColor67,
                          ),
                          decoration: const BoxDecoration(
                            color: ApplicationColors.blackColor2E,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 330,
                    right: 10,
                    child: Container(
                      width: 41,
                      height: 41,
                      padding: EdgeInsets.all(10),
                      child:
                          Image.asset("assets/images/current_location_ic.png"),
                      decoration: BoxDecoration(
                        color: ApplicationColors.redColor67,
                        borderRadius: BorderRadius.circular(41),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

/*DateTime date;
  TimeOfDay time;

  DateTime fromDatePicked = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.now();

  DateTime endDatePicked = DateTime.now();
  TimeOfDay endPickedTime = TimeOfDay.now();

  dateTimeSelect() async {
    date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.blackColor2E,
              onPrimary: ApplicationColors.black4240,
              surface: ApplicationColors.redColor67,
              onSurface: ApplicationColors.blackColor00,
            ),
            dialogBackgroundColor: ApplicationColors.black4240,
          ),
          child: child,
        );
      },
    );

    time = await showTimePicker(
      context: context,
      initialTime: pickedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: ApplicationColors.greyColors,
              onPrimary: ApplicationColors.blackColor00,
              surface: ApplicationColors.black4240,
              onSurface: ApplicationColors.blackColor00,
            ),
            dialogBackgroundColor: ApplicationColors.black4240,
          ),
          child: child,
        );
      },
    );

    if (date != null) {
      setState(() {
        this.fromDatePicked =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        datedController.text =
        "${DateFormat("dd MMM yyyy hh:mm aa").format(fromDatePicked)}";
        fromDate = datedController.text;
      });

      if (vehicleId != null && datedController.text.isNotEmpty) {
        _markers.clear();
        address = "";
        playerTimeLine = 0;
       getTrack();
       getDistance();
      }
    }
  }

  endDateTimeSelect() async {
    date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.blackColor2E,
              onPrimary: ApplicationColors.black4240,
              surface: ApplicationColors.redColor67,
              onSurface: ApplicationColors.blackColor00,
            ),
            dialogBackgroundColor: ApplicationColors.black4240,
          ),
          child: child,
        );
      },
    );

    time = await showTimePicker(
      context: context,
      initialTime: endPickedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColors.greyColors,
              onPrimary: ApplicationColors.blackColor00,
              surface: ApplicationColors.black4240,
              onSurface: ApplicationColors.blackColor00,
            ),
            dialogBackgroundColor: ApplicationColors.black4240,
            backgroundColor: ApplicationColors.black4240,
          ),
          child: child,
        );
      },
    );

    if (date != null) {
      setState(() {
        this.endDatePicked =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        _endDateController.text =
        "${DateFormat("dd MMM yyyy hh:mm aa").format(endDatePicked)}";
        toDate = _endDateController.text;
      });

      if (vehicleId != null && _endDateController.text.isNotEmpty) {
        _markers.clear();
        address = "";
        playerTimeLine =0;
        getTrack();
        getDistance();

      }
    }
  }*/
}
