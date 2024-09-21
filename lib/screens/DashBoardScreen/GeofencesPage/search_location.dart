import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Model/MapSuggestion.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Search_location extends StatefulWidget {
  const Search_location({Key key}) : super(key: key);

  @override
  _Search_locationState createState() => _Search_locationState();
}

class _Search_locationState extends State<Search_location> {
  GoogleMapController mapController;

  FocusNode focusNode;

  var apiKey = "AIzaSyCt8g09M4pRLpiK76c4_4jH5FPJDTcVODg";
  //"AIzaSyDNmQ3sok_q3O9JZ66cFJgzFfiJiDWESmY";
  Timer _debounce;
  bool searchValue = true;
  bool isLoading = true, isShow = true;
  List<MapSuggestion> suggestionList = [];
  TextEditingController searchController = TextEditingController();

  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: "AIzaSyCt8g09M4pRLpiK76c4_4jH5FPJDTcVODg");
  //"AIzaSyDNmQ3sok_q3O9JZ66cFJgzFfiJiDWESmY");

  fetchSuggestions(
    String input,
  ) async {
    final sessionToken = Uuid().v4();

    String request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=${Localizations.localeOf(context).languageCode}&components=country:in&key=$apiKey&sessiontoken=$sessionToken';
    print(request);
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      print(result);
      if (result['status'] == 'OK') {
        List<MapSuggestion> list;
        List client = result['predictions'] as List;
        list = client
            .map<MapSuggestion>((json) => MapSuggestion.fromJson(json))
            .toList();
        suggestionList.addAll(list);
        setState(() {
          isLoading = false;
        });
      }
      if (result['status'] == 'ZERO_RESULTS') {
        setState(() {
          isLoading = false;
        });
        return [];
      }
      //throw Exception(result['error_message']);
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to fetch suggestion');
    }
  }

  getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      longitude = position.longitude;
      latitude = position.latitude;
    });
  }

  var longitude, latitude;

  BitmapDescriptor sourceIcon;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 6.0),
        "assets/images/location.png");
  }

  final Set<Marker> _markers = {};

  var min = 100.0, max = 500.0;

  var getCircleAddress = "";
  getAddress() async {
    print("condition call");
    if (latitude != null || longitude != null) {
      print("condition in");
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      setState(() {
        getCircleAddress =
            "${placemarks.first.name} ${placemarks.first.subLocality} ${placemarks.first.locality} ${placemarks.first.subAdministrativeArea} ${placemarks.first.administrativeArea},${placemarks.first.postalCode}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    longitude = Utils.lng;
    latitude = Utils.lat;
    print(latitude);
    setSourceAndDestinationIcons();
    getAddress();
    focusNode = FocusNode();
  }

  double _value = 100;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: IntrinsicHeight(
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                color: ApplicationColors.whiteColor),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/gps1.png",
                            color: ApplicationColors.redColor67,
                            width: 15,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            searchController.text.isEmpty
                                ? "${getCircleAddress}"
                                : "${searchController.text}",
                            style: Textstyle1.signupText
                                .copyWith(fontSize: 12, color: Colors.black),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${getTranslated(context, "select_radius")}",
                            style: Textstyle1.text18,
                          ),
                          Text(
                            "${NumberFormat("##0.0#", "en_US").format(_value)}",
                            style: Textstyle1.text18,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      //Row(children: [],),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "${min.round()}${getTranslated(context, "m")}",
                                style: Textstyle1.text12.copyWith(
                                    fontSize: 10, color: Colors.black),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (max > 100) {
                                        if (max > _value) {
                                          max = max - 100;
                                        } else {
                                          max = 100;
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: ApplicationColors.redColor67,
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                    child: Center(
                                        child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    )),
                                  )
                                  /*  Image.asset(
                                    'assets/images/minus_icon_wit_round_back.png',
                                    width: 30,)*/

                                  ),
                            ],
                          ),
                          Expanded(
                            child: Slider(
                              activeColor: ApplicationColors.redColor67,
                              min: min,
                              max: max,
                              value: _value,
                              onChanged: (double value) {
                                setState(() {
                                  _value = value;
                                });
                              },
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "${max.round()}${getTranslated(context, "m")}",
                                style: Textstyle1.text12.copyWith(
                                    fontSize: 10, color: Colors.black),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (max >= 100) {
                                        max = max + 100;
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: ApplicationColors.redColor67,
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                    child: Center(
                                        child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    )),
                                  )

                                  /*Image.asset(
                                    'assets/images/plus_icon_with_round_back.png',
                                    width: 30,
                                  )*/
                                  ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(
                              context, ["$latitude", "$longitude", "$_value"]);
                        },
                        child: Container(
                          decoration: Boxdec.buttonBoxDecRed_r6,
                          width: width,
                          height: height * .057,
                          child: Center(
                              child: Text(
                            "${getTranslated(context, "confirm_location")}",
                            style: Textstyle1.text18boldwhite,
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            )),
      ),
      body: Stack(
        children: [
          Container(
            height: height,
            child:
                //_child
                GoogleMap(
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 18.0, //initial zoom level
              ),
              markers: _markers,
              // mapType: MapType.normal,
              mapType: Utils.mapType, //map type
              onTap: (argument) {
                setState(() {
                  latitude = argument.latitude;
                  longitude = argument.longitude;
                  getAddress();
                  _markers.add(Marker(
                    markerId: MarkerId("myLoc"),
                    position: LatLng(
                      latitude,
                      longitude,
                    ),
                    icon: sourceIcon,
                  ));
                });
              },
              circles: {
                Circle(
                  circleId: CircleId('circle_123'),
                  center: LatLng(latitude, longitude),
                  radius: _value,
                  strokeColor: const Color(0xffF84A67).withOpacity(0.15),
                  fillColor: const Color(0xffF84A67).withOpacity(0.15),
                  strokeWidth: 1,
                ),
              }, //map type
              onMapCreated: (controller) {
                setState(() {
                  _markers.add(Marker(
                    markerId: MarkerId("myLoc"),
                    position: LatLng(
                      latitude,
                      longitude,
                    ),
                    icon: sourceIcon,
                  ));
                });
                mapController = controller;
              },
            ),
          ),
          Positioned(
              child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: height * .055),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      isLoading = true;
                      suggestionList.clear();
                      isShow = true;
                    });
                    if (_debounce?.isActive ?? false) _debounce.cancel();
                    _debounce = Timer(const Duration(milliseconds: 1000), () {
                      fetchSuggestions(value);
                    });
                  },
                  focusNode: focusNode,
                  onTap: () {
                    setState(() {
                      searchValue = true;
                    });
                  },
                  controller: searchController,
                  style: Textstyle1.text14,
                  decoration: Textfield1.inputdec.copyWith(
                    fillColor: ApplicationColors.whiteColor,
                    hintText: "${getTranslated(context, "search_location")}",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Image.asset(
                        'assets/images/search_icon.png',
                        color: ApplicationColors.redColor67,
                        width: 10,
                      ),
                    ),
                  ),
                ),
                searchController.text.isEmpty || searchValue == false
                    ? Container()
                    : Container(
                        alignment: Alignment.center,
                        height: 250,
                        width: width,
                        padding: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: ApplicationColors.whiteColor,
                            border: Border(
                              right: BorderSide(
                                  color: ApplicationColors.redColor67),
                              left: BorderSide(
                                  color: ApplicationColors.redColor67),
                              bottom: BorderSide(
                                  color: ApplicationColors.redColor67),
                            )),
                        child: suggestionList.isEmpty
                            ? isLoading
                                ? SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ApplicationColors.redColor67,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "${getTranslated(context, "location_not_fund")}",
                                      style: Textstyle1.text14,
                                    ),
                                  )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: suggestionList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      PlacesDetailsResponse detail =
                                          await _places.getDetailsByPlaceId(
                                              suggestionList[index].placeId);
                                      latitude =
                                          detail.result.geometry.location.lat;
                                      longitude =
                                          detail.result.geometry.location.lng;
                                      _markers.clear();

                                      mapController.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            target: LatLng(latitude, longitude),
                                            zoom: 18.0,
                                          ),
                                        ),
                                      );

                                      setState(() {
                                        searchController.text =
                                            suggestionList[index].description;
                                        focusNode.unfocus();
                                        searchValue = false;
                                        _markers.add(Marker(
                                          markerId: MarkerId("myLocation"),
                                          position: LatLng(
                                            latitude,
                                            longitude,
                                          ),
                                          icon: sourceIcon,
                                        ));
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0, left: 10, right: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/gps1.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Text(
                                              "${suggestionList[index].description}",
                                              style: Textstyle1.text14,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
