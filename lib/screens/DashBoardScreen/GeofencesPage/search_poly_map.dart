import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneqlik/Model/MapSuggestion.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/main.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:uuid/uuid.dart';

class SearchPolyMap extends StatefulWidget {
  const SearchPolyMap({Key key}) : super(key: key);

  @override
  _SearchPolyMapState createState() => _SearchPolyMapState();
}

class _SearchPolyMapState extends State<SearchPolyMap> {
  GoogleMapController mapController;

  FocusNode focusNode;

  var apiKey = "AIzaSyCt8g09M4pRLpiK76c4_4jH5FPJDTcVODg";
  //    "AIzaSyDNmQ3sok_q3O9JZ66cFJgzFfiJiDWESmY";

  bool searchValue = true;

  bool isLoading = true, isShow = true;

  List<MapSuggestion> suggestionList = [];

  TextEditingController searchController = TextEditingController();

  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: "AIzaSyCt8g09M4pRLpiK76c4_4jH5FPJDTcVODg");
  Timer _debounce;
  // "AIzaSyDNmQ3sok_q3O9JZ66cFJgzFfiJiDWESmY");

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

  var longitude, latitude;

  BitmapDescriptor sourceIcon;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 6.0),
        "assets/images/location.png");
  }

  final Set<Marker> _markers = {};

  List polyList = [];

  List twoPolyList = [];

  List<LatLng> _listLatLng = [];

  @override
  void initState() {
    super.initState();
    longitude = Utils.lng;
    latitude = Utils.lat;
    setSourceAndDestinationIcons();
    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: IntrinsicHeight(
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              color: ApplicationColors.greyC4C4,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "${getTranslated(context, "Note_Click_on_the_map_to_draw_a_polygon")}",
                        textAlign: TextAlign.center,
                        style: Textstyle1.text18bold.copyWith(
                            fontSize: 15, color: ApplicationColors.black4240),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            Navigator.pop(context, [twoPolyList, _listLatLng]);
                            //print(polyList);
                          });
                        },
                        child: Container(
                          decoration: Boxdec.buttonBoxDecRed_r6,
                          width: width,
                          height: height * .057,
                          child: Center(
                              child: Text(
                            "${getTranslated(context, "confirm_location")}",
                            style: Textstyle1.text18bold,
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
              mapType: Utils.mapType, //map type
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 13.0, //initial zoom level
              ),
              markers: _markers,
              polygons: _listLatLng.isEmpty
                  ? {}
                  : Set<Polygon>.of(<Polygon>[
                      Polygon(
                          polygonId: PolygonId('polygon'),
                          points: _listLatLng,
                          strokeWidth: 2,
                          strokeColor:
                              const Color(0xffF84A67).withOpacity(0.15),
                          fillColor: const Color(0xffF84A67).withOpacity(0.15)),
                    ]),
              onTap: (argument) {
                setState(() {
                  List three = [
                    argument.longitude,
                    argument.latitude,
                  ];
                  twoPolyList.add(three);
                  print(twoPolyList);

                  _listLatLng
                      .add(LatLng(argument.latitude, argument.longitude));
                });
              },
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
                      suggestionList.clear();
                      isLoading = true;
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
                        width: 10,
                        color: ApplicationColors.redColor67,
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
