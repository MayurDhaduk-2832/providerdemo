import 'dart:async';
import 'dart:convert';
import 'dart:developer' as d;

import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/socket_model.dart';
import 'package:oneqlik/Provider/home_provider.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/Provider/vehicle_list_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/GeofencesPage/Geofeces.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/history.dart';
import 'package:oneqlik/screens/DashBoardScreen/HistoryPage/history_new.dart';
import 'package:oneqlik/screens/DashBoardScreen/LiveForVehicleScreen/live_for_vehicle_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_info/analytics.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_info/device_settings.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_info/documents.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_info/immobilize.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_info/parking_schedular.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_info/tow_schedular.dart';
import 'package:oneqlik/screens/SuparAdmin/AddVehicle/add_vehicle.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

import '../../../Provider/reports_provider.dart';
import '../../SuparAdmin/EditVehicle/edit_vehicle.dart';

class Vehicle_list extends StatefulWidget {
  var status, selecttype;

  Vehicle_list({Key key, this.status, this.selecttype}) : super(key: key);

  @override
  _Vehicle_listState createState() => _Vehicle_listState();
}

class _Vehicle_listState extends State<Vehicle_list>
    with TickerProviderStateMixin {

  bool optionButton_click = false;
  var width, height;
  String usersetting;
  bool firstBool = false;
  List<LatLng> listOfLatLog = [];
  VehicleListProvider vehicleListProvider;
  HomeProvider homeProvider;
  UserProvider _userProvider;
  ReportProvider _reportProvider;
  bool isLoading = false;
  bool _showRefresh = false;
  bool isselect = false;
  int selectedIndex = 0;
  List shareVehicle = ["15 MINS", "1 HOUR", "8 HOURS"];
  var id;
  var setval = 0;
  var selecttype;
  List vehicleInfoCategoriesIcon = [
    "assets/images/LIve_icon.png",
    "assets/images/History_icon.png",
    "assets/images/parking_icon.png",
    "assets/images/immobilize.png",
    "assets/images/Driver_call_icon.png",
    "assets/images/analytics_icon.png",
    "assets/images/setting_icon_11.png",
    "assets/images/Geofence.png",
    "assets/images/google-docs.png",
    "assets/images/share.png",
    "assets/images/satellite.png"
  ];

  int page = 0;
  SharedPreferences sharedPreferences;
  connectSocketIo({String vDeviceId, var vehicleList}) {
    socket = IO.io('https://www.oneqlik.in/gps', <String, dynamic>{
      "secure": true,
      "rejectUnauthorized": false,
      "transports": ["websocket", "polling"],
      "upgrade": false
    });
    socket.connect();

    socket.onConnect((data) {
      print("Socket is connected");

      socket.emit("acc", "$vDeviceId");

      socket.on("${vDeviceId}acc", (data) async {
        print("socket data ===> ${data[3]}");
        if (data[3] != null) {
          var resonance = data[3];

          setState(() {
            socketModelClass = SocketModelClass.fromJson(resonance);
          });

          print("IconType ${socketModelClass.iconType}");
          print("StatUs ${socketModelClass.status}");

          // /*  lat = socketModelClass.lastLocation.lat;
          // lng = socketModelClass.lastLocation.long;*/

          if (socketModelClass.lastLocation != null) {
            var lat = socketModelClass.lastLocation.lat;
            var lng = socketModelClass.lastLocation.long;

            var latlng = LatLng(lat, lng);
            listOfLatLog.add(latlng);
          }
        }
      });
    });
  }
  TextEditingController searchController = TextEditingController();
  bool isSuperAdmin = false;
  bool isDealer = false;
  bool superAdmin = false;

  var vehicleStatus = "";
  var fromDate = "${DateFormat("yyyy-MM-dd").format(
      DateTime.now())}T00:00:00.000Z";
  var toDate = DateTime.now().toString();

  int data;
  String vehiclestatus = " ";
  SharedPreferences prefes;
  IO.Socket socket;
  SocketModelClass socketModelClass;

  FocusNode focusNode = FocusNode();

  ScrollController _scrollViewController = ScrollController();

  // Timer timer;


  getVehicleList(page, searchId) async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      isSuperAdmin = sharedPreferences.getBool("superAdmin");
      superAdmin = sharedPreferences.getBool("isSuperAdmin");
      isDealer = sharedPreferences.getBool("isDealer");
    });

    id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");
    var token = sharedPreferences.getString("token");
    var supAdmin = sharedPreferences.getBool("superAdmin");
    isDealer = sharedPreferences.getBool("isDealer");


    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    print("page $page");
    var data = {
      "id": id,
      "email": email,
      supAdmin == false ? "" : "supAdmin": id ?? "",
      isDealer == false ? "" : "dealer": id ?? "",
      "skip": page.toString(),
      "limit": "10",
      "statuss": Utils.vehicleStatus,
      "search": searchId,
    };

    print(data);
    vehicleListProvider.getVehicleList(
      data, "devices/getDeviceByUserMobile", "vehicle",
    );

    if (vehicleListProvider.isVehicleLoading) {
      setState(() {
        _showRefresh = false;
      });
    }
  }

  checkValidLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("uid");
    var pass = sharedPreferences.getString("pass");
    print(id);
    var data = {
      "user": id,
      "psd": pass ?? '123456',
    };

    print(data);
    vehicleListProvider.getValidateIDPass(
        data, "users/validate_id_pass", context);
  }

  checkDeviceExpiring() async {
    sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("uid");
    print(id);
    var data = {
      "user": id,
      "lte": 15,
      "gte": 0
    };

    print(data);
    vehicleListProvider.getDeviceExpiring(data, "devices/expiring", context);
  }

  distanceReport(vid, vehicleindex, userId) async {
    print("vehicle id:$vid");
    DateTime now = DateTime.now(); // get the current date and time
    DateTime dateAtMidnight = DateTime(
        now.year, now.month, now.day); // set the time to 12:00 am

    //  var fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc())}";
    //var fromDate = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z";
    //  var toDate = DateTime.now().toUtc().toString();

    var fromdate1 = dateAtMidnight.toUtc().toString();
    var toDate1 = DateTime.now().toUtc().toString();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //  var id = sharedPreferences.getString("uid");

    var data = {
      "from": fromdate1,
      "to": toDate1,
      // "from":"2022-02-21T18:30:00.838Z",
      // "to":"2022-02-22T18:29:59.838Z",
      "user": userId,
      "skip": "0",
      "device": vid,
    };

    print("Data is:$data");
    _reportProvider.distancevalue(data, "summary/distance", vehicleindex);
  }

  getVehicleStatusList() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");
    bool isDealer = sharedPreferences.getBool("isDealer");

    bool supAdmin = sharedPreferences.getBool("superAdmin");
    var data = supAdmin ? {
      "id": id,
      "email": email,
      "from": DateTime.now().subtract(Duration(days: 1)).toString(),
      "to": DateTime.now().toString(),
      "supAdmin": id
    } : isDealer ? {
      "id": id,
      "email": email,
      "from": DateTime.now().subtract(Duration(days: 1)).toString(),
      "to": DateTime.now().toString(),
      "dealer": id
    } : {
      "id": id,
      "email": email,
      "from": DateTime.now().subtract(Duration(days: 1)).toString(),
      "to": DateTime.now().toString(),
    };

    await homeProvider.getVehicleStatus(data, "gps/getDashboard1");

    if (homeProvider.isVehicleLoading == false) {
      setState(() {
        _showRefresh = false;
      });
    }
  }

  getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      isSuperAdmin = sharedPreferences.getBool("superAdmin");
      isDealer = sharedPreferences.getBool("isDealer");
    });

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
    };

    await _userProvider.getUserData(data, "users/getCustumerDetail", context);
    // getVehicleStatusList();
  }

  Future<void> _getData() async {
    setState(() {
      page = 0;
      _showRefresh = true;
      vehicleListProvider.isVehicleLoading = false;
      _reportProvider.selectedItems.clear();
      getVehicleStatusList();
      getVehicleList(0, "");
    });
  }

  getUserSettings() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");
    var data = {
      "uid": id
    };

    print('CheckGet-->$data');

    await _userProvider.getUserSettings(
        data, "users/get_user_setting", context);
    showpopup();
  }

  showpopup() {
    var contact;
    var support;
    if (usersetting == "pay now") {
      // contact=
    }
    print("kdhfjdhfdme------");
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Contact Number"),
        content: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50)
          ),
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,

                itemCount: usersetting == "support" ? _userProvider
                    .getUserSettingsModel.support != null ? _userProvider
                    .getUserSettingsModel.support.length : 0
                    : _userProvider.getUserSettingsModel.service != null
                    ? _userProvider.getUserSettingsModel.service.length
                    : 0,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(
                        Icons.call, color: ApplicationColors.redColor67),
                    title: Text(
                        usersetting == "support" ? _userProvider
                            .getUserSettingsModel.support != null
                            ?
                        _userProvider.getUserSettingsModel.support[index]
                            : "No contact found"
                            : _userProvider.getUserSettingsModel.service.isEmpty
                            ? "No contact found"
                            :
                        _userProvider.getUserSettingsModel.service[index]

                    ),
                    onTap: () {
                      // You can add functionality to perform an action when the user taps on a number
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          },
              child: Text("Ok", style: TextStyle(
                  color: ApplicationColors.redColor67, fontSize: 15),))
        ],
      );
    },);
  }

  showDeviceExpirePopUp() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        //title: Text("Reminder"),
        content: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50)
          ),
          width: double.maxFinite,
          child: SizedBox(
            height: 300.0,
            width: 200.0,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 100,
                  width: 200,
                  color: ApplicationColors.redColor67,),
                Text(
                    'Your Device will expire very soon. Please contact to your service provider for renewal().')
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          },
              child: Center(
                child: Container(
                  width: 200.0, height: 40.0,
                  decoration: BoxDecoration(
                    color: ApplicationColors.redColor67,
                    //  border: Border.all(width: 5, color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text("Ok", style: TextStyle(
                        color: ApplicationColors.whiteColor, fontSize: 15),),
                  ),
                ),
              ))
        ],
      );
    },);
  }

  //Future<String>
  getData() async
  {
    prefes = await SharedPreferences.getInstance();
    if (prefes.getInt("data") != null) {
      data = prefes.getInt("data");
      selecttype = data;
    }
    else {
      selecttype = 7;
    }
    //data=2;

    //vehiclestatus="Running";

    print("Data is-----------$data");
    if (data == 0) {
      vehiclestatus = Utils.vehicleStatus = "IDLING";
      print("vehiclestatus1233$vehiclestatus");
    }
    else if (data == 1) {
      vehiclestatus = Utils.vehicleStatus = "NO DATA";
      print("vehiclestatus1233$vehiclestatus");
    }
    else if (data == 2) {
      vehiclestatus = Utils.vehicleStatus = "OUT OF REACH";
      print("vehiclestatus1233$vehiclestatus");
    }
    else if (data == 3) {
      vehiclestatus = Utils.vehicleStatus = "Expired";
      print("vehiclestatus1233$vehiclestatus");
    }
    else if (data == 4) {
      vehiclestatus = Utils.vehicleStatus = "STOPPED";
      print("vehiclestatus1233$vehiclestatus");
    }
    else if (data == 5) {
      vehiclestatus = Utils.vehicleStatus = "RUNNING";
      print("vehiclestatus1233$vehiclestatus");
    }
    else if (data == 6) {
      vehiclestatus = Utils.vehicleStatus = "NO DATA";
      print("vehiclestatus1233$vehiclestatus");
    }
    //return vehiclestatus;

  }

  @override
  void initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    vehicleListProvider =
        Provider.of<VehicleListProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    //_reportProvider = Provider.of<ReportProvider>(context, listen: true);
    //getUserSettings();
    checkValidLogin();
    checkDeviceExpiring();
    getVehicleStatusList();

    vehicleListProvider.vehicleList.clear();
    vehicleListProvider.addressList.clear();
    //_reportProvider.selectedItems.clear();
    Future.delayed(Duration.zero, () {
      vehicleListProvider.changeBool(false);
    });
    // getUserData();
    getData();

    getVehicleList(0, "");

    //  timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _getData());

    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!vehicleListProvider.isSucces) {
          page = page + 1;
          getVehicleList(page, "");
        }
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    vehicleListProvider =
        Provider.of<VehicleListProvider>(context, listen: true);
    homeProvider = Provider.of<HomeProvider>(context, listen: true);
    _userProvider = Provider.of<UserProvider>(context, listen: true);
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
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
      '${getTranslated(context, "documents")}',
      '${getTranslated(context, "Share location")}',
      '${getTranslated(context, "street_view")}'
    ];

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(

            /* image: DecorationImage(
                image: AssetImage("assets/images/dark_background_image.png"), // <-- BACKGROUND IMAGE
                fit: BoxFit.cover,
              ),*/
          ),
        ),
        Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  _userProvider.changeBottomIndex(0);
                },
                child: Icon(
                  Icons.arrow_back_sharp,
                  color: ApplicationColors.white9F9,
                  size: 26,
                ),
              ),
              title: Text("${getTranslated(context, "vehicle_list")}",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Arial',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                InkWell(
                  onTap: () {
                    if (optionButton_click == false) {
                      setState(() {
                        optionButton_click = true;
                        focusNode.requestFocus();
                      });
                    } else if (optionButton_click == true) {
                      setState(() {
                        optionButton_click = false;
                        focusNode.unfocus();
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Image.asset("assets/images/search_icon.png",
                      color: ApplicationColors.whiteColor,),
                  ),
                ),
                isDealer == true || isSuperAdmin == true
                    ? InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddVehiclePage()
                    )
                    );
                  },
                  child: Icon(Icons.add,),) : SizedBox(),
                SizedBox(width: 10),

              ],
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

            backgroundColor: Colors.transparent, //&&
            body: homeProvider.isVehicleLoading || _userProvider.isLoading
                ?
            Helper.dialogCall.showLoader()
                :
            DeclarativeRefreshIndicator(
              color: ApplicationColors.redColor67,
              backgroundColor: ApplicationColors.whiteColor,
              onRefresh: _getData,
              refreshing: _showRefresh,
              child: Column(
                children: [

                  Column(
                    children: [

                      optionButton_click == true
                          ?
                      Container(
                        decoration: Boxdec.conrad6colorblack,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              TextFormField(

                                focusNode: focusNode,
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {});
                                  vehicleListProvider.vehicleList
                                      .clear();
                                  vehicleListProvider.addressList
                                      .clear();
                                  vehicleListProvider.changeBool(
                                      false);
                                  vehicleListProvider
                                      .isCommentLoading = false;
                                  Utils.vehicleStatus = "";
                                  page = 0;
                                  getVehicleList(
                                      page, searchController.text);
                                },
                                keyboardType: TextInputType.emailAddress,
                                style: Textstyle1.text11.copyWith(
                                    color: ApplicationColors.redColor67

                                ),
                                decoration: Textfield1.inputdec.copyWith(
                                  hintText: "${getTranslated(
                                      context, "search_vehicle")}",
                                  /*suffixIcon: searchController.text.isEmpty
                                     ?
                                 SizedBox()
                                     :
                                 InkWell(
                                   onTap: (){
                                     vehicleListProvider.vehicleList.clear();
                                     vehicleListProvider.addressList.clear();
                                     vehicleListProvider.changeBool(false);
                                     vehicleListProvider.isCommentLoading = false;
                                     vehicleStatus = "";
                                     page = 0;

                                     getVehicleList(page, "");
                                     searchController.clear();
                                     focusNode.unfocus();
                                   },
                                   child: Icon(
                                     Icons.cancel_outlined,
                                     color: ApplicationColors.whiteColor,
                                   ),
                                 ),*/
                                  suffixIcon: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        searchController.text.isEmpty
                                            ?
                                        SizedBox()
                                            :
                                        InkWell(
                                          onTap: () {
                                            vehicleListProvider.vehicleList
                                                .clear();
                                            vehicleListProvider.addressList
                                                .clear();
                                            vehicleListProvider.changeBool(
                                                false);
                                            vehicleListProvider
                                                .isCommentLoading = false;
                                            Utils.vehicleStatus = "";
                                            page = 0;

                                            getVehicleList(page, "");
                                            searchController.clear();
                                            focusNode.unfocus();
                                          },
                                          child: Icon(
                                            Icons.cancel_outlined,
                                            color: ApplicationColors
                                                .black4240,
                                          ),
                                        ),

                                        SizedBox(width: 10),
                                        searchController.text.isEmpty
                                            ?
                                        SizedBox()
                                            :
                                        InkWell(
                                          onTap: () {
                                            vehicleListProvider.vehicleList
                                                .clear();
                                            vehicleListProvider.addressList
                                                .clear();
                                            vehicleListProvider.changeBool(
                                                false);
                                            vehicleListProvider
                                                .isCommentLoading = false;
                                            Utils.vehicleStatus = "";
                                            page = 0;
                                            getVehicleList(
                                                page, searchController.text);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                1.0),
                                            child: Image.asset(
                                                "assets/images/search_icon.png",
                                                width: 20,
                                                color: ApplicationColors
                                                    .black4240),
                                          ),
                                        ),
                                        SizedBox(width: 15),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          :
                      SizedBox(height: 0,),

                      SizedBox(height: 10,),

                      homeProvider.vehicleStatusModel == null
                          ?
                      SizedBox()
                          :
                      Container(
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selecttype = 7;
                                        _reportProvider.selectedItems.clear();
                                        vehicleListProvider.vehicleList
                                            .clear();
                                        vehicleListProvider.addressList
                                            .clear();
                                        vehicleListProvider.changeBool(false);
                                        Utils.vehicleStatus = "";
                                        page = 0;

                                        getVehicleList(0, "");
                                      });
                                    },
                                    child: Container(
                                      width: width * .1,
                                      //height: height*.12,
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Container(
                                          height: 20,
                                          width: 25,
                                          child: Center(
                                            child: Image.asset(
                                              "assets/images/running_icon.png",
                                              width: 26,
                                              height: 26,
                                              color: Appcolors.violet,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: width * .15,
                                    height: 3,
                                    color: selecttype == 7 ? ApplicationColors
                                        .redColor67 : Color(0xffF7F7F7),
                                  )
                                ],
                              ),


                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selecttype = 5;
                                        _reportProvider.selectedItems.clear();
                                        vehicleListProvider.changeBool(false);
                                        vehicleListProvider.addressList
                                            .clear();
                                        vehicleListProvider.vehicleList
                                            .clear();
                                        Utils.vehicleStatus = "RUNNING";
                                        page = 0;
                                        getVehicleList(0, "");
                                      });
                                    },
                                    child: Container(
                                      width: width * .1,
                                      // height: height*.12,
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 25,
                                              child: Center(
                                                  child: Image.asset(
                                                    "assets/images/running_icon.png",
                                                    width: 26,
                                                    height: 26,
                                                    color: ApplicationColors
                                                        .greenColor370,
                                                  )
                                              ),


                                            ),
                                          ],
                                        ),
                                      ),


                                    ),
                                  ),

                                  Container(
                                    width: width * .15,
                                    height: 3,
                                    color: selecttype == 5 ? ApplicationColors
                                        .redColor67 : Color(0xffF7F7F7),
                                  )
                                ],
                              ),


                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selecttype = 0;
                                        _reportProvider.selectedItems.clear();
                                        vehicleListProvider.changeBool(false);
                                        vehicleListProvider.addressList
                                            .clear();
                                        vehicleListProvider.vehicleList
                                            .clear();
                                        vehicleListProvider.isCommentLoading =
                                        false;
                                        Utils.vehicleStatus = "IDLING";
                                        page = 0;
                                        getVehicleList(0, "");
                                      });
                                    },
                                    child: Container(
                                      width: width * .1,
                                      // height: height*.12,
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 25,
                                              child: Center(
                                                  child: Image.asset(
                                                    "assets/images/running_icon.png",
                                                    height: 26,
                                                    width: 26,
                                                    color: Appcolors.yellow,
                                                  )
                                              ),

                                            ),

                                          ],
                                        ),
                                      ),

                                    ),
                                  ),

                                  Container(
                                    width: width * .15,
                                    height: 3,
                                    color: selecttype == 0 ? ApplicationColors
                                        .redColor67 : Color(0xffF7F7F7),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selecttype = 4;
                                        _reportProvider.selectedItems.clear();
                                        vehicleListProvider.changeBool(false);
                                        vehicleListProvider.vehicleList
                                            .clear();
                                        vehicleListProvider.addressList
                                            .clear();
                                        vehicleListProvider.isCommentLoading =
                                        false;
                                        Utils.vehicleStatus = "STOPPED";
                                        page = 0;
                                        getVehicleList(0, "");
                                      });
                                    },
                                    child: Container(
                                      width: width * .1,
                                      // height: height*.12,
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 25,
                                              child: Center(
                                                  child: Image.asset(
                                                    "assets/images/running_icon.png",
                                                    height: 26,
                                                    width: 26,
                                                    color: ApplicationColors
                                                        .redColor67,
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ),
                                  ),

                                  Container(
                                    width: width * .15,
                                    height: 3,
                                    color: selecttype == 4 ? ApplicationColors
                                        .redColor67 : Color(0xffF7F7F7),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selecttype = 2;
                                        _reportProvider.selectedItems.clear();
                                        vehicleListProvider.changeBool(false);
                                        vehicleListProvider.vehicleList
                                            .clear();
                                        vehicleListProvider.addressList
                                            .clear();
                                        vehicleListProvider.isCommentLoading =
                                        false;
                                        Utils.vehicleStatus = "OUT OF REACH";
                                        page = 0;
                                        getVehicleList(0, "");
                                      });
                                    },
                                    child: Container(
                                      width: width * .1,
                                      //height: height*.12,
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 25,
                                              child: Center(
                                                child: Image.asset(
                                                  "assets/images/running_icon.png",
                                                  width: 26,
                                                  height: 26,
                                                  color: Appcolors.sky1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                    ),
                                  ),

                                  Container(
                                    width: width * .15,
                                    height: 3,
                                    color: selecttype == 2 ? ApplicationColors
                                        .redColor67 : Color(0xffF7F7F7),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selecttype = 3;
                                        _reportProvider.selectedItems.clear();
                                        vehicleListProvider.changeBool(false);
                                        vehicleListProvider.vehicleList
                                            .clear();
                                        vehicleListProvider.addressList
                                            .clear();
                                        vehicleListProvider.isCommentLoading =
                                        false;
                                        Utils.vehicleStatus = "Expired";
                                        page = 0;
                                        getVehicleList(0, "");
                                      });
                                    },
                                    child: Container(
                                      width: width * .1,
                                      // height: height*.12,
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 25,
                                              child: Center(
                                                  child: Image.asset(
                                                    "assets/images/running_icon.png",
                                                    height: 26,
                                                    width: 26,
                                                    color: ApplicationColors
                                                        .orangeColor3E,
                                                  )
                                              ),

                                            ),
                                          ],
                                        ),
                                      ),

                                    ),
                                  ),

                                  Container(
                                    width: width * .15,
                                    height: 3,
                                    color: selecttype == 3 ? ApplicationColors
                                        .redColor67 : Color(0xffF7F7F7),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selecttype = 1;
                                        _reportProvider.selectedItems.clear();
                                        vehicleListProvider.changeBool(false);
                                        vehicleListProvider.addressList
                                            .clear();
                                        vehicleListProvider.vehicleList
                                            .clear();
                                        vehicleListProvider.isCommentLoading =
                                        false;
                                        Utils.vehicleStatus = "NO DATA";
                                        page = 0;
                                        getVehicleList(0, "");
                                      });
                                    },
                                    child: Container(
                                      width: width * .1,
                                      // height: height*.12,
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 25,
                                              child: Center(
                                                  child: Image.asset(
                                                      "assets/images/running_icon.png",
                                                      width: 26,
                                                      height: 26,
                                                      color: ApplicationColors
                                                          .appColors3
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: width * .15,
                                    height: 3,
                                    color: selecttype == 1 ? ApplicationColors
                                        .redColor67 : Color(0xffF7F7F7),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),


                  SizedBox(height: 10),

                  vehicleListProvider.isVehicleLoading == false &&
                      _showRefresh == false
                      ?
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ApplicationColors.whiteColor,
                        backgroundColor: ApplicationColors.redColor67,
                      ),
                    ),
                  )
                      :
                  SizedBox(),

                  vehicleListProvider.isVehicleLoading == false
                      ?
                  SizedBox()
                      :
                  vehicleListProvider.vehicleList.length == 0
                      ?
                  Expanded(
                    child: Center(
                      child: Text(
                        "${getTranslated(context, "vehicle_not_available")}",
                        textAlign: TextAlign.center,
                        style: Textstyle1.text18.copyWith(
                          fontSize: 18,
                          color: ApplicationColors.redColor67,
                        ),
                      ),
                    ),
                  )
                      :
                  Utils.vehicleStatus == "Expired" ?
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(

                          child: Container(
                            height: 50,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.40,
                            decoration: BoxDecoration(
                                color: Appcolors.profile_black,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(child: Text(
                              "${getTranslated(context, "pay_now")}",
                              style: Textstyle1
                                  .text18boldwhite
                                  .copyWith(
                                  fontSize: 14),)),
                          ),
                          onTap: () {
                            usersetting = "pay now";
                            getUserSettings();
                          },
                        ),
                        InkWell(
                          onTap: () {
                            usersetting = "support";
                            getUserSettings();
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.40,
                            decoration: BoxDecoration(
                                color: Appcolors.profile_black,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(child: Text(
                              "${getTranslated(context, "support")}",
                              style: Textstyle1
                                  .text18boldwhite
                                  .copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),)),
                          ),
                        )
                      ],
                    ),
                  )

                      : SizedBox(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vehicleListProvider.vehicleList.length,
                      controller: _scrollViewController,
                      padding: EdgeInsets.only(bottom: 40),
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var vehicleList = vehicleListProvider
                            .vehicleList[index];

                        //print("-----${vehicleList.statusUpdatedAt}");
                        final utcDate1 = vehicleList.statusUpdatedAt;
                        final localDate = utcDate1.toLocal();
                        final formatter = DateFormat('dd-MMM-yyyy HH:mm:ss');
                        final localDateString = formatter.format(localDate);
                        //print("---ldjkdsjdk$localDateString");


                        String utcDateStr = vehicleList.statusUpdatedAt
                            .toString();
                        DateTime utcDate = DateTime.parse(utcDateStr);

                        // get the current local date and time
                        DateTime currentDate = DateTime.now();

                        // calculate the difference between the UTC date and the current local date and time
                        Duration difference1 = utcDate.toLocal().difference(
                            currentDate);

                        // calculate the total hours and minutes between the two dates
                        int totalHours = difference1.inHours.abs();
                        int totalMinutes = difference1.inMinutes.abs() % 60;

                        //print("Total hours: $totalHours, Total minutes: $totalMinutes");
                        if (vehicleList.status == "Expired") {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Container(

                              height: 70,
                              width: width,
                              decoration: BoxDecoration(
                                  color: Appcolors.profile_black,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              360),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "truck"
                                                  ?
                                              "assets/images/vehicle/truckIcons/truck_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "truck"
                                                  ?
                                              "assets/images/vehicle/truckIcons/truck_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "truck"
                                                  ?
                                              "assets/images/vehicle/truckIcons/truck_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "truck"
                                                  ?
                                              "assets/images/vehicle/truckIcons/truck_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "truck"
                                                  ?
                                              "assets/images/vehicle/truckIcons/truck_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "truck"
                                                  ?
                                              "assets/images/vehicle/truckIcons/truck_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "bus"
                                                  ?
                                              "assets/images/vehicle/busIcons/bus_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "bus"
                                                  ?
                                              "assets/images/vehicle/busIcons/bus_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "bus"
                                                  ?
                                              "assets/images/vehicle/busIcons/bus_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "bus"
                                                  ?
                                              "assets/images/vehicle/busIcons/bus_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "bus"
                                                  ?
                                              "assets/images/vehicle/busIcons/bus_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "bus"
                                                  ?
                                              "assets/images/vehicle/busIcons/bus_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "pickup"
                                                  ?
                                              "assets/images/vehicle/smalltruckIcons/smalltruck_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "pickup"
                                                  ?
                                              "assets/images/vehicle/smalltruckIcons/smalltruck_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "pickup"
                                                  ?
                                              "assets/images/vehicle/smalltruckIcons/smalltruck_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "pickup"
                                                  ?
                                              "assets/images/vehicle/smalltruckIcons/smalltruck_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "pickup"
                                                  ?
                                              "assets/images/vehicle/smalltruckIcons/smalltruck_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "pickup"
                                                  ?
                                              "assets/images/vehicle/smalltruckIcons/smalltruck_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "tractor"
                                                  ?
                                              "assets/images/tractor_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "tractor"
                                                  ?
                                              "assets/images/tractor_ic_stoppage.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "tractor"
                                                  ?
                                              "assets/images/tracktor_ic_idling.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "tractor"
                                                  ?
                                              "assets/images/tractor_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "tractor"
                                                  ?
                                              "assets/images/tractor_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "tractor"
                                                  ?
                                              "assets/images/tracktor_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "car"
                                                  ?
                                              "assets/images/vehicle/carIcons/car_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "scooter"
                                                  ?
                                              "assets/images/vehicle/scootyIcons/scooty_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "scooter"
                                                  ?
                                              "assets/images/vehicle/scootyIcons/scooty_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "scooter"
                                                  ?
                                              "assets/images/vehicle/scootyIcons/scooty_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "scooter"
                                                  ?
                                              "assets/images/vehicle/scootyIcons/scooty_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "scooter"
                                                  ?
                                              "assets/images/vehicle/scootyIcons/scooty_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "scooter"
                                                  ?
                                              "assets/images/vehicle/scootyIcons/scooty_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "bike"
                                                  ?
                                              "assets/images/vehicle/bikeIcons/bike_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "bike"
                                                  ?
                                              "assets/images/vehicle/bikeIcons/bike_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "bike"
                                                  ?
                                              "assets/images/vehicle/bikeIcons/bike_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "bike"
                                                  ?
                                              "assets/images/vehicle/bikeIcons/bike_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "bike"
                                                  ?
                                              "assets/images/vehicle/bikeIcons/bike_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "bike"
                                                  ?
                                              "assets/images/vehicle/bikeIcons/bike_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "user"
                                                  ?
                                              "assets/images/vehicle/userIcons/user_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "user"
                                                  ?
                                              "assets/images/vehicle/userIcons/user_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "user"
                                                  ?
                                              "assets/images/vehicle/userIcons/user_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "user"
                                                  ?
                                              "assets/images/vehicle/userIcons/user_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "user"
                                                  ?
                                              "assets/images/vehicle/userIcons/user_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "user"
                                                  ?
                                              "assets/images/vehicle/userIcons/user_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "pet"
                                                  ?
                                              "assets/images/vehicle/petIcons/pet_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "pet"
                                                  ?
                                              "assets/images/vehicle/petIcons/pet_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "pet"
                                                  ?
                                              "assets/images/vehicle/petIcons/pet_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "pet"
                                                  ?
                                              "assets/images/vehicle/petIcons/pet_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "pet"
                                                  ?
                                              "assets/images/vehicle/petIcons/pet_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "pet"
                                                  ?
                                              "assets/images/vehicle/petIcons/pet_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "jcb"
                                                  ?
                                              "assets/images/vehicle/jcbIcons/jcb_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "jcb"
                                                  ?
                                              "assets/images/vehicle/jcbIcons/jcb_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "jcb"
                                                  ?
                                              "assets/images/vehicle/jcbIcons/jcb_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "jcb"
                                                  ?
                                              "assets/images/vehicle/jcbIcons/jcb_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "jcb"
                                                  ?
                                              "assets/images/vehicle/jcbIcons/jcb_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.iconType ==
                                                      "jcb"
                                                  ?
                                              "assets/images/vehicle/jcbIcons/jcb_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "boat"
                                                  ?
                                              "assets/images/vehicle/boatIcons/boat_running_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "boat"
                                                  ?
                                              "assets/images/vehicle/boatIcons/boat_stopped_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "boat"
                                                  ?
                                              "assets/images/vehicle/boatIcons/boat_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList
                                                      .iconType == "boat"
                                                  ?
                                              "assets/images/vehicle/boatIcons/boat_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "boat"
                                                  ?
                                              "assets/images/vehicle/boatIcons/boat_expired_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.vehicleType
                                                      .iconType == "boat"
                                                  ?
                                              "assets/images/vehicle/boatIcons/boat_nodata_ic.png"
                                                  :
                                              vehicleList.status == "RUNNING" &&
                                                  vehicleList.iconType == "auto"
                                                  ?

                                              "assets/images/vehicle/autoIcons/auto_running_ic.png"
                                                  :
                                              vehicleList.status == "STOPPED" &&
                                                  vehicleList.iconType == "auto"
                                                  ?
                                              "assets/images/vehicle/autoIcons/auto_stopped_ic.png"
                                                  :
                                              vehicleList.status == "IDLING" &&
                                                  vehicleList.iconType == "auto"
                                                  ?
                                              "assets/images/vehicle/autoIcons/auto_idling_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType == "auto"
                                                  ?
                                              "assets/images/vehicle/autoIcons/auto_outreach_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType == "auto"
                                                  ?
                                              "assets/images/vehicle/autoIcons/auto_expired_ic.png"
                                                  :
                                              vehicleList.status == "NO Data" &&
                                                  vehicleList.vehicleType
                                                      .iconType == "auto"
                                                  ?
                                              "assets/images/vehicle/autoIcons/auto_nodata_ic.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "ambulance"
                                                  ?
                                              "assets/images/vehicle/ambulanceIcon/ambulance_green.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "ambulance"
                                                  ?
                                              "assets/images/vehicle/ambulanceIcon/ambulance_red.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "ambulance"
                                                  ?
                                              "assets/images/vehicle/ambulanceIcon/ambulance_yello.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "ambulance"
                                                  ?
                                              "assets/images/vehicle/ambulanceIcon/ambulance_blue.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "ambulance"
                                                  ?
                                              "assets/images/vehicle/ambulanceIcon/ambulance_orange.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.vehicleType
                                                      .iconType == "ambulance"
                                                  ?
                                              "assets/images/vehicle/ambulanceIcon/ambulance_grey.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "crane"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneGreenIcon.png"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "crane"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneRedIcon.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "crane"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneYellowIcon.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "crane"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneBlueIcon.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "crane"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneOrangeIcon.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.vehicleType
                                                      .iconType == "crane"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneGreyIcon.png"
                                                  :
                                              vehicleList.status ==
                                                  "RUNNING" &&
                                                  vehicleList.iconType ==
                                                      "machine"
                                                  ?
                                              "assets/images/vehicle/"
                                                  :
                                              vehicleList.status ==
                                                  "STOPPED" &&
                                                  vehicleList.iconType ==
                                                      "machine"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneRedIcon.png"
                                                  :
                                              vehicleList.status ==
                                                  "IDLING" &&
                                                  vehicleList.iconType ==
                                                      "machine"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneYellowIcon.png"
                                                  :
                                              vehicleList.status ==
                                                  "OUT OF REACH" &&
                                                  vehicleList.iconType ==
                                                      "machine"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneBlueIcon.png"
                                                  :
                                              vehicleList.status ==
                                                  "Expired" &&
                                                  vehicleList.iconType ==
                                                      "machine"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneOrangeIcon.png"
                                                  :
                                              vehicleList.status ==
                                                  "NO Data" &&
                                                  vehicleList.vehicleType
                                                      .iconType == "machine"
                                                  ?
                                              "assets/images/vehicle/craneIcon/craneGreyIcon.png"
                                                  :
                                              "assets/images/vehicle/userIcons/user_nodata_ic.png",
                                              // width: width * .14,
                                              // fit: BoxFit.fill,
                                            ),
                                          )
                                      ),

                                    ),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Text(
                                          vehicleList.deviceName,
                                          style: Textstyle1
                                              .text18boldwhite
                                              .copyWith(
                                              fontSize: 16),
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              "${vehicleList
                                                  .status} : ",
                                              overflow: TextOverflow
                                                  .visible,
                                              maxLines: 1,
                                              textAlign: TextAlign
                                                  .start,
                                              style: Textstyle1
                                                  .texts12.copyWith(
                                                fontSize: 10,
                                                color: "${vehicleList
                                                    .status}" ==
                                                    "RUNNING"
                                                    ?
                                                ApplicationColors
                                                    .greenColor370
                                                    :
                                                "${vehicleList
                                                    .status}" ==
                                                    "IDLING"
                                                    ?
                                                ApplicationColors
                                                    .yellowColorD21
                                                    :
                                                "${vehicleList
                                                    .status}" ==
                                                    "OUT OF REACH"
                                                    ?
                                                ApplicationColors
                                                    .blueColorCE
                                                    :
                                                "${vehicleList
                                                    .status}" ==
                                                    "Expired"
                                                    ?
                                                ApplicationColors
                                                    .orangeColor3E
                                                    :
                                                "${vehicleList
                                                    .status}" ==
                                                    "NO DATA"
                                                    ?
                                                ApplicationColors
                                                    .appColors3
                                                    :
                                                ApplicationColors
                                                    .redColor67,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.45,
                                              child: Text(
                                                "${getTranslated(
                                                    context,
                                                    "since")} "
                                                    "$localDateString",
                                                //"${DateFormat.H().format(vehicleList.statusUpdatedAt)}h ${DateFormat.m().format(vehicleList.statusUpdatedAt)}m",
                                                style: Textstyle1
                                                    .text12black
                                                    .copyWith(
                                                    fontSize: 10,
                                                    color: Colors
                                                        .white),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )

                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        else {
                          return InkWell(
                            onTap: () async {
                              print("status is:----${vehicleList.status}");
                              if (vehicleList.status == "NO DATA" ||
                                  vehicleList.status == "Expired") {

                              }
                              else {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    context: context,
                                    builder: (BuildContext builder) {
                                      return Container(
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.38,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          color: Colors.grey.withOpacity(0.8),),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(height: MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.376,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(
                                                      10)),
                                              color: ApplicationColors
                                                  .containercolor,),
                                            child: Container(


                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    12.0),
                                                child: Column(children: [
                                                  SizedBox(height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height * 0.01),
                                                  Container(height: 3,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                        color: Colors.grey
                                                            .withOpacity(
                                                            0.8),)),
                                                  SizedBox(height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height * 0.01),
                                                  Expanded(
                                                    child: GridView.builder(
                                                        physics: AlwaysScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis
                                                            .vertical,
                                                        padding: EdgeInsets.all(
                                                            0),
                                                        gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio: 3 /
                                                              3,
                                                          crossAxisSpacing: 18,
                                                          mainAxisSpacing: 18,
                                                          crossAxisCount: 4,
                                                        ),
                                                        itemCount: vehicleInfoCategories
                                                            .length,
                                                        itemBuilder: (context,
                                                            index) {
                                                          return InkWell(
                                                            onTap: () async {
                                                              if (vehicleInfoCategories[index] ==
                                                                  '${getTranslated(
                                                                      context,
                                                                      "immobilize")}') {
                                                                // socket.dispose();
                                                                Navigator.pop(
                                                                    context);
                                                                final value = await Navigator
                                                                    .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            Immobilized(
                                                                                vDeviceId: vehicleList
                                                                                    .deviceId,
                                                                                vehicleLisDevice: vehicleList,
                                                                                vName: vehicleList
                                                                                    .deviceName
                                                                            ))
                                                                );
                                                                if (value != null || value == null) {
                                                                  connectSocketIo(
                                                                      vDeviceId: vehicleList.deviceId,
                                                                      vehicleList: vehicleList);
                                                                }
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  '${getTranslated(
                                                                      context,
                                                                      "driver")}') {
                                                                if (vehicleList
                                                                    .contactNumber !=
                                                                    "" ||
                                                                    vehicleList
                                                                        .contactNumber !=
                                                                        null) {
                                                                  String url = 'tel:${vehicleList
                                                                      .contactNumber}';
                                                                  await launch(
                                                                      url);
                                                                } else {
                                                                  Helper
                                                                      .dialogCall
                                                                      .showToast(
                                                                      context,
                                                                      "${getTranslated(
                                                                          context,
                                                                          "Driver_number_not_found")}");
                                                                }
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  '${getTranslated(
                                                                      context,
                                                                      "live")}') {
                                                                // socket.dispose();
                                                                // animationController.dispose();
                                                                print(
                                                                    "===================");

                                                                final value = await Navigator
                                                                    .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            LiveForVehicleScreen(
                                                                              vDeviceId: vehicleList
                                                                                  .deviceId,
                                                                              vehicleLisDevice: vehicleList,
                                                                              vId: vehicleList
                                                                                  .id,
                                                                            )
                                                                    )
                                                                ).then((value){
                                                                  Navigator.pop(context);
                                                                });
                                                                if (value !=
                                                                    null ||
                                                                    value ==
                                                                        null) {
                                                                  connectSocketIo(
                                                                      vDeviceId: vehicleList
                                                                          .deviceId,
                                                                      vehicleList: vehicleList);
                                                                }
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  '${getTranslated(
                                                                      context,
                                                                      "history")}') {
                                                                Navigator.push(context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          HistoryPage(
                                                                            vId: vehicleList.id,
                                                                            deviceId: vehicleList.deviceId,
                                                                            deviceName: vehicleList.deviceName,
                                                                            km: vehicleList.distance != null ? vehicleList.distance.toStringAsFixed(2) : '0',
                                                                            deviceType: vehicleList.iconType,
                                                                            formDate: "${DateFormat("yyyy-MM-dd").format(DateTime.now())}T00:00:00.000Z",
                                                                            toDate: DateTime.now().toUtc().toLocal().toString(),
                                                                          ),
                                                                    )
                                                                ).then((value){
                                                                  _getData();
                                                                  Navigator.pop(context);
                                                                });
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  '${getTranslated(
                                                                      context,
                                                                      "geofence")}') {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            Geofences(
                                                                              value: "value",))
                                                                );
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  '${getTranslated(
                                                                      context,
                                                                      "analytics")}') {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            AnalyticsPage(
                                                                                vDeviceId: vehicleList
                                                                                    .deviceId,
                                                                                vehicleListModel: vehicleList
                                                                            ))
                                                                );
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  '${getTranslated(
                                                                      context,
                                                                      "documents")}') {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          DocumetsPage(
                                                                            vehicleLisDevice: vehicleList,
                                                                          ),
                                                                    )
                                                                );
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  '${getTranslated(
                                                                      context,
                                                                      "setting")}') {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          VehicleListDeviceSettingPage(
                                                                            vehicleLisDevice: vehicleList,
                                                                          ),
                                                                    )
                                                                );
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  '${getTranslated(
                                                                      context,
                                                                      "parking")}') {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            ParkingSchedulerPage(
                                                                                vName: vehicleList
                                                                                    .deviceName,
                                                                                vId: vehicleList
                                                                                    .id))
                                                                );
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  "${getTranslated(
                                                                      context,
                                                                      "tow")}") {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TowSchedulerPage(
                                                                                vName: vehicleList
                                                                                    .deviceName,
                                                                                vId: vehicleList
                                                                                    .id))
                                                                );
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  "${getTranslated(
                                                                      context,
                                                                      "Share location")}") {
                                                                setState(() {
                                                                  selectedIndex =
                                                                  0;
                                                                });
                                                                showModalBottomSheet(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius
                                                                            .only(
                                                                            topLeft: Radius
                                                                                .circular(
                                                                                10),
                                                                            topRight: Radius
                                                                                .circular(
                                                                                10))),
                                                                    context: context,
                                                                    builder: (
                                                                        BuildContext builder) {
                                                                      int secondConvert = 0;
                                                                      TextEditingController custom = TextEditingController();
                                                                      return StatefulBuilder(
                                                                        builder: (
                                                                            context,
                                                                            setStates) {
                                                                          return Container(
                                                                            height: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .height *
                                                                                0.35,
                                                                            width: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .width,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius
                                                                                  .only(
                                                                                  topLeft: Radius
                                                                                      .circular(
                                                                                      10),
                                                                                  topRight: Radius
                                                                                      .circular(
                                                                                      10)),
                                                                              color: Colors
                                                                                  .grey
                                                                                  .withOpacity(
                                                                                  0.8),),
                                                                            child: Align(
                                                                              alignment: Alignment
                                                                                  .bottomCenter,
                                                                              child: Container(
                                                                                height: MediaQuery
                                                                                    .of(
                                                                                    context)
                                                                                    .size
                                                                                    .height *
                                                                                    0.376,
                                                                                width: MediaQuery
                                                                                    .of(
                                                                                    context)
                                                                                    .size
                                                                                    .width,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius
                                                                                      .only(
                                                                                      topLeft: Radius
                                                                                          .circular(
                                                                                          10),
                                                                                      topRight: Radius
                                                                                          .circular(
                                                                                          10)),
                                                                                  color: ApplicationColors
                                                                                      .containercolor,),
                                                                                child: Container(


                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets
                                                                                        .all(
                                                                                        12.0),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                                          .start,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                            height: MediaQuery
                                                                                                .of(
                                                                                                context)
                                                                                                .size
                                                                                                .height *
                                                                                                0.01),
                                                                                        Text(
                                                                                            '${getTranslated(
                                                                                                context,
                                                                                                "Share Live Vehicle")}',
                                                                                            style: Textstyle1
                                                                                                .text14
                                                                                                .copyWith(
                                                                                              fontSize: 16,
                                                                                            )
                                                                                        ),
                                                                                        SizedBox(
                                                                                            height: MediaQuery
                                                                                                .of(
                                                                                                context)
                                                                                                .size
                                                                                                .height *
                                                                                                0.01),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment
                                                                                              .spaceBetween,
                                                                                          children: List
                                                                                              .generate(
                                                                                            shareVehicle.length, (index) =>
                                                                                              InkWell(
                                                                                                onTap: () {
                                                                                                  setStates(() {
                                                                                                    selectedIndex = index;
                                                                                                    if (selectedIndex == 0) {
                                                                                                      secondConvert =
                                                                                                          Duration(minutes: 15).inMilliseconds;
                                                                                                    } else
                                                                                                    if (selectedIndex == 1) {
                                                                                                      secondConvert =
                                                                                                          Duration(
                                                                                                              hours: 1)
                                                                                                              .inMilliseconds;
                                                                                                    } else
                                                                                                    if (selectedIndex ==
                                                                                                        2) {
                                                                                                      secondConvert =
                                                                                                          Duration(
                                                                                                              hours: 8)
                                                                                                              .inMilliseconds;
                                                                                                    }
                                                                                                  });
                                                                                                },
                                                                                                hoverColor: ApplicationColors
                                                                                                    .darkredColor1E,
                                                                                                splashColor: ApplicationColors
                                                                                                    .darkredColor1E,
                                                                                                child: Container(
                                                                                                    height: 40,
                                                                                                    width: 105,
                                                                                                    decoration: BoxDecoration(
                                                                                                        color: selectedIndex ==
                                                                                                            index
                                                                                                            ? ApplicationColors
                                                                                                            .darkredColor1E
                                                                                                            : Colors
                                                                                                            .white,
                                                                                                        boxShadow: [
                                                                                                          BoxShadow(
                                                                                                              color: Colors
                                                                                                                  .black45,
                                                                                                              blurRadius: 5,
                                                                                                              offset: Offset(
                                                                                                                  1.0,
                                                                                                                  2.5))
                                                                                                        ]),
                                                                                                    child: Center(
                                                                                                      child: Text(
                                                                                                          '${shareVehicle[index]}',
                                                                                                          style: Textstyle1
                                                                                                              .text14
                                                                                                              .copyWith(
                                                                                                              color: selectedIndex ==
                                                                                                                  index
                                                                                                                  ? Colors
                                                                                                                  .white
                                                                                                                  : Colors
                                                                                                                  .black,
                                                                                                              fontSize: 13,
                                                                                                              fontWeight: FontWeight
                                                                                                                  .w700
                                                                                                          )
                                                                                                      ),
                                                                                                    )),
                                                                                              ),),),
                                                                                        SizedBox(
                                                                                            height: MediaQuery
                                                                                                .of(
                                                                                                context)
                                                                                                .size
                                                                                                .height *
                                                                                                0.01),
                                                                                        InkWell(

                                                                                          onTap: () {
                                                                                            setStates(() {
                                                                                              selectedIndex =
                                                                                              4;
                                                                                            });
                                                                                            showDialog(
                                                                                                context: context,
                                                                                                builder: (
                                                                                                    context) {
                                                                                                  return Material(
                                                                                                    color: Colors
                                                                                                        .transparent,
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets
                                                                                                          .only(
                                                                                                          left: 30,
                                                                                                          right: 30,
                                                                                                          bottom: 300,
                                                                                                          top: 100),
                                                                                                      child: Center(
                                                                                                        child: Container(
                                                                                                          height: 250,
                                                                                                          decoration: BoxDecoration(
                                                                                                              color: Colors
                                                                                                                  .white,
                                                                                                              borderRadius: BorderRadius
                                                                                                                  .circular(
                                                                                                                  10)),
                                                                                                          child: Padding(
                                                                                                            padding: const EdgeInsets
                                                                                                                .all(
                                                                                                                15.0),
                                                                                                            child: Column(
                                                                                                              crossAxisAlignment: CrossAxisAlignment
                                                                                                                  .center,
                                                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                                                  .center,
                                                                                                              children: [
                                                                                                                SizedBox(
                                                                                                                    height: MediaQuery
                                                                                                                        .of(
                                                                                                                        context)
                                                                                                                        .size
                                                                                                                        .height *
                                                                                                                        0.01),
                                                                                                                Row(
                                                                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                                                                      .center,
                                                                                                                  mainAxisAlignment: MainAxisAlignment
                                                                                                                      .center,
                                                                                                                  children: [
                                                                                                                    Text(
                                                                                                                        '${getTranslated(
                                                                                                                            context,
                                                                                                                            "Custom Duration")}',
                                                                                                                        style: Textstyle1
                                                                                                                            .text14
                                                                                                                            .copyWith(
                                                                                                                          fontSize: 16,
                                                                                                                        )
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                        height: MediaQuery
                                                                                                                            .of(
                                                                                                                            context)
                                                                                                                            .size
                                                                                                                            .width *
                                                                                                                            0.03),
                                                                                                                    IconButton(
                                                                                                                        onPressed: () {
                                                                                                                          Navigator
                                                                                                                              .pop(
                                                                                                                              context);
                                                                                                                        },
                                                                                                                        icon: Icon(
                                                                                                                          Icons
                                                                                                                              .cancel,
                                                                                                                          color: Colors
                                                                                                                              .black,))
                                                                                                                  ],
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                    height: MediaQuery
                                                                                                                        .of(
                                                                                                                        context)
                                                                                                                        .size
                                                                                                                        .height *
                                                                                                                        0.01),
                                                                                                                //       new Expanded(
                                                                                                                new TextField(
                                                                                                                  controller: custom,
                                                                                                                  autofocus: true,
                                                                                                                  keyboardType: TextInputType
                                                                                                                      .number,
                                                                                                                  inputFormatters: <
                                                                                                                      TextInputFormatter>[
                                                                                                                    // for below version 2 use this
                                                                                                                    FilteringTextInputFormatter
                                                                                                                        .allow(
                                                                                                                        RegExp(
                                                                                                                            r'[0-9]')),
// for version 2 and greater youcan also use this
                                                                                                                    FilteringTextInputFormatter
                                                                                                                        .digitsOnly

                                                                                                                  ],
                                                                                                                  decoration: new InputDecoration(
                                                                                                                      labelText: 'Enter Duration',
                                                                                                                      hintText: '',
                                                                                                                      labelStyle: Textstyle1
                                                                                                                          .text14
                                                                                                                          .copyWith(
                                                                                                                        fontSize: 16,
                                                                                                                        fontWeight: FontWeight
                                                                                                                            .w600,
                                                                                                                      ),
                                                                                                                      border: UnderlineInputBorder(
                                                                                                                          borderSide: BorderSide(
                                                                                                                            color: Colors
                                                                                                                                .black,)),
                                                                                                                      enabledBorder: UnderlineInputBorder(
                                                                                                                          borderSide: BorderSide(
                                                                                                                              color: Colors
                                                                                                                                  .black)),
                                                                                                                      focusedBorder: UnderlineInputBorder(
                                                                                                                          borderSide: BorderSide(
                                                                                                                              color: Colors
                                                                                                                                  .black))

                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                    height: MediaQuery.of(context).size.height * 0.015),
                                                                                                                InkWell(
                                                                                                                  onTap: () {
                                                                                                                    setStates(() {
                                                                                                                      secondConvert =
                                                                                                                          Duration(
                                                                                                                              hours: int
                                                                                                                                  .parse(
                                                                                                                                  custom
                                                                                                                                      .text))
                                                                                                                              .inMilliseconds;
                                                                                                                    });
                                                                                                                    Navigator
                                                                                                                        .pop(
                                                                                                                        context);
                                                                                                                  },
                                                                                                                  child: Container(
                                                                                                                      height: 40,
                                                                                                                      decoration: BoxDecoration(
                                                                                                                          color: ApplicationColors
                                                                                                                              .darkredColor1E,
                                                                                                                          boxShadow: [
                                                                                                                            BoxShadow(
                                                                                                                                color: Colors
                                                                                                                                    .black45,
                                                                                                                                blurRadius: 5,
                                                                                                                                offset: Offset(
                                                                                                                                    1.0,
                                                                                                                                    2.5))
                                                                                                                          ]),
                                                                                                                      child: Center(
                                                                                                                        child: Text(
                                                                                                                            'SUBMIT',
                                                                                                                            style: Textstyle1
                                                                                                                                .text14
                                                                                                                                .copyWith(
                                                                                                                                color: Colors
                                                                                                                                    .white,
                                                                                                                                fontSize: 13,
                                                                                                                                fontWeight: FontWeight
                                                                                                                                    .w700
                                                                                                                            )
                                                                                                                        ),
                                                                                                                      )),
                                                                                                                ),


                                                                                                              ],),
                                                                                                          ),

                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                });
                                                                                          },
                                                                                          hoverColor: ApplicationColors
                                                                                              .darkredColor1E,
                                                                                          splashColor: ApplicationColors
                                                                                              .darkredColor1E,
                                                                                          child: Container(
                                                                                              height: 40,
                                                                                              width: 105,
                                                                                              decoration: BoxDecoration(
                                                                                                  color: selectedIndex ==
                                                                                                      4
                                                                                                      ? ApplicationColors
                                                                                                      .darkredColor1E
                                                                                                      : Colors
                                                                                                      .white,
                                                                                                  boxShadow: [
                                                                                                    BoxShadow(
                                                                                                        color: Colors
                                                                                                            .black45,
                                                                                                        blurRadius: 5,
                                                                                                        offset: Offset(
                                                                                                            1.0,
                                                                                                            2.5))
                                                                                                  ]),
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                    'Custom',
                                                                                                    style: Textstyle1
                                                                                                        .text14
                                                                                                        .copyWith(
                                                                                                        color: selectedIndex ==
                                                                                                            4
                                                                                                            ? Colors
                                                                                                            .white
                                                                                                            : Colors
                                                                                                            .black,
                                                                                                        fontSize: 13,
                                                                                                        fontWeight: FontWeight
                                                                                                            .w700
                                                                                                    )
                                                                                                ),
                                                                                              )),
                                                                                        ),
                                                                                        Spacer(),
                                                                                        Align(
                                                                                            alignment: Alignment
                                                                                                .topRight,
                                                                                            child: InkWell(
                                                                                                onTap: () async {
                                                                                                  d
                                                                                                      .log(
                                                                                                      'vehicleList.id===============>${vehicleList
                                                                                                          .id}');
                                                                                                  d
                                                                                                      .log(
                                                                                                      'vehicleList.id===============>${vehicleList
                                                                                                          .deviceId}');
                                                                                                  d
                                                                                                      .log(
                                                                                                      'sharedPreferences.getString("id").id===============>${_userProvider
                                                                                                          .useModel
                                                                                                          .cust
                                                                                                          .id}');
                                                                                                  d
                                                                                                      .log(
                                                                                                      'sharedPreferences.getString("email").id===============>${_userProvider
                                                                                                          .useModel
                                                                                                          .cust
                                                                                                          .email}');
                                                                                                  d
                                                                                                      .log(
                                                                                                      'sharedPreferences.getString("userId").id===============>${_userProvider
                                                                                                          .useModel
                                                                                                          .cust
                                                                                                          .userId}');
                                                                                                  d
                                                                                                      .log(
                                                                                                      'sharedPreferences.getString("name").id===============>${_userProvider
                                                                                                          .useModel
                                                                                                          .cust
                                                                                                          .firstName}${_userProvider
                                                                                                          .useModel
                                                                                                          .cust
                                                                                                          .lastName}');
                                                                                                  d
                                                                                                      .log(
                                                                                                      'sharedPreferences.getString("add").id===============>${_userProvider
                                                                                                          .useModel
                                                                                                          .cust
                                                                                                          .address}');
                                                                                                  d
                                                                                                      .log(
                                                                                                      'sharedPreferences.getString("id").id===============>${sharedPreferences
                                                                                                          .getString(
                                                                                                          "uid")}');
                                                                                                  d
                                                                                                      .log(
                                                                                                      'sharedPreferences.getString("pass").id===============>${sharedPreferences
                                                                                                          .getString(
                                                                                                          "pass")}');

                                                                                                  // --data '{
                                                                                                  // "ttl":21900,
                                                                                                  // "id":"64aa9204dbbc481799283de8",
                                                                                                  // "imei":355172108848506,
                                                                                                  // "sh":"64aa924edbbc481799283def"
                                                                                                  // }'
                                                                                                  var body = {
                                                                                                    "id": vehicleList
                                                                                                        .id,
                                                                                                    "imei": vehicleList
                                                                                                        .deviceId,
                                                                                                    "sh": _userProvider
                                                                                                        .useModel
                                                                                                        .cust
                                                                                                        .id,
                                                                                                    // {
                                                                                                    //   "_id": _userProvider.useModel.cust.id,
                                                                                                    //   "pass": sharedPreferences.getString("pass"),
                                                                                                    //   "first_name": _userProvider.useModel.cust.firstName,
                                                                                                    //   "last_name": _userProvider.useModel.cust.lastName,
                                                                                                    //   "phone": _userProvider.useModel.cust.phone,
                                                                                                    //   "email": _userProvider.useModel.cust.email,
                                                                                                    //   "user_id": _userProvider.useModel.cust.userId,
                                                                                                    //   "address": _userProvider.useModel.cust.address
                                                                                                    // },
                                                                                                    "ttl": 21900
                                                                                                  };
                                                                                                  d
                                                                                                      .log(
                                                                                                      'response====>${body}');

                                                                                                  var response = await http
                                                                                                      .post(
                                                                                                      Uri
                                                                                                          .parse(
                                                                                                          'https://www.oneqlik.in/share'),
                                                                                                      body: jsonEncode(
                                                                                                          body),
                                                                                                      headers: {
                                                                                                        'Content-Type': 'application/json'
                                                                                                      });
                                                                                                  d
                                                                                                      .log(
                                                                                                      'response====>${response
                                                                                                          .body}');
                                                                                                  d
                                                                                                      .log(
                                                                                                      'response====>${response
                                                                                                          .statusCode}');

                                                                                                  var res = jsonDecode(
                                                                                                      response
                                                                                                          .body);

                                                                                                  getDataUrl(
                                                                                                      'https://www.oneqlik.in/share/liveShare?t=${res["t"]}');


                                                                                                  // https://www.oneqlik.in/share/liveShare?t=


                                                                                                  //    Share.share('https://13.126.36.205/share/liveShare?t=${res["t"]}');
                                                                                                },
                                                                                                child: CircleAvatar(
                                                                                                    radius: 20,
                                                                                                    backgroundColor: ApplicationColors
                                                                                                        .darkredColor1E,
                                                                                                    child: Icon(
                                                                                                      Icons
                                                                                                          .send,
                                                                                                      color: Colors
                                                                                                          .white,
                                                                                                      size: 20,)))),
                                                                                        SizedBox(
                                                                                            height: MediaQuery
                                                                                                .of(
                                                                                                context)
                                                                                                .size
                                                                                                .height *
                                                                                                0.01),
                                                                                      ],),
                                                                                  ),
                                                                                ),),
                                                                            ),);
                                                                        },);
                                                                    });
                                                              }
                                                              if (vehicleInfoCategories[index] ==
                                                                  "${getTranslated(
                                                                      context,
                                                                      "street_view")}") {
                                                                // mapLauncher.MapLauncher.showDirections(
                                                                //   mapType:mapLauncher.MapType.tomtomgo,
                                                                //   origin: mapLauncher.Coords(Utils.lat, Utils.lng),
                                                                //   destination: mapLauncher.Coords(24.765, 76.89)
                                                                // );
                                                                String streetViewUrl = getStreetViewUrl(
                                                                    vehicleList
                                                                        .lastLocation
                                                                        .lat,
                                                                    vehicleList
                                                                        .lastLocation
                                                                        .long);
                                                                launch(
                                                                    streetViewUrl);
                                                                //      launch("https://www.google.com/maps/@${Utils.lat},${Utils.lng},3a,75y,256.26h,92.87t/data=!3m7!1e1!3m5!1s1rg31nHmvnyecxanb-50Mw!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D1rg31nHmvnyecxanb-50Mw%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D221.27132%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192?entry=ttu");
                                                                //"https://www.google.com/maps/dir/?api=1&origin=${Utils.lat},${Utils.lng}&streetview=true");
                                                                //https://www.google.com/maps/@26.8874822,75.7669893,3a,75y,66.09h,92.32t/data=!3m7!1e1!3m5!1sTngpGF7QrdzqRN1hRRpzPg!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DTngpGF7QrdzqRN1hRRpzPg%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D97.03477%26pitch%3D0%26thumbfov%3D100!7i13312!8i6656?entry=ttu
                                                              }
                                                            },
                                                            child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    left: 5,
                                                                    right: 5,
                                                                    top: 5,
                                                                    bottom: 5),
                                                                decoration: Boxdec
                                                                    .conrad6colorgrey
                                                                    .copyWith(
                                                                    color: ApplicationColors
                                                                        .blackColor2E
                                                                ),
                                                                // width: width * .05,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .center,
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Image
                                                                          .asset(
                                                                        vehicleInfoCategoriesIcon[index],
                                                                        width: 30,
                                                                        height: 30,
                                                                        color: ApplicationColors
                                                                            .redColor67,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: 10),
                                                                    Text(
                                                                        vehicleInfoCategories[index],
                                                                        textAlign: TextAlign
                                                                            .center,
                                                                        style: Textstyle1
                                                                            .text14
                                                                            .copyWith(
                                                                            fontSize: 10
                                                                        )
                                                                    )
                                                                  ],
                                                                )),
                                                          );
                                                        }),
                                                  ),
                                                ],),
                                              ),
                                            ),),
                                        ),);
                                    });


                                // final value = await Navigator.push(
                                //   context, MaterialPageRoute(
                                //     builder: (context) =>
                                //         VehicleInfoPage(
                                //           vId: vehicleList.id,
                                //           vName: vehicleList.deviceName,
                                //           vDeviceId: vehicleList.deviceId,
                                //           vehicleLisDevice: vehicleList,
                                //         )
                                // ),
                                // );
                                // if (value != null) {
                                //   setState(() {
                                //     page = 0;
                                //   });
                                // }
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                              decoration: Boxdec.conrad6appColors2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Container(
                                    decoration: Boxdec.conrad6colorwhite
                                        .copyWith(


                                      borderRadius: BorderRadius.circular(0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ApplicationColors.greyC4C4,
                                          offset: Offset(5.0, 5.0,),
                                          blurRadius: 8.0,
                                          spreadRadius: 0.3,
                                        ), //BoxShadow
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Image.asset(
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "truck"
                                                    ?
                                                "assets/images/vehicle/truckIcons/truck_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "truck"
                                                    ?
                                                "assets/images/vehicle/truckIcons/truck_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "truck"
                                                    ?
                                                "assets/images/vehicle/truckIcons/truck_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "truck"
                                                    ?
                                                "assets/images/vehicle/truckIcons/truck_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "truck"
                                                    ?
                                                "assets/images/vehicle/truckIcons/truck_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "truck"
                                                    ?
                                                "assets/images/vehicle/truckIcons/truck_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "bus"
                                                    ?
                                                "assets/images/vehicle/busIcons/bus_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "bus"
                                                    ?
                                                "assets/images/vehicle/busIcons/bus_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "bus"
                                                    ?
                                                "assets/images/vehicle/busIcons/bus_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "bus"
                                                    ?
                                                "assets/images/vehicle/busIcons/bus_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "bus"
                                                    ?
                                                "assets/images/vehicle/busIcons/bus_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "bus"
                                                    ?
                                                "assets/images/vehicle/busIcons/bus_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "pickup"
                                                    ?
                                                "assets/images/vehicle/smalltruckIcons/smalltruck_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "pickup"
                                                    ?
                                                "assets/images/vehicle/smalltruckIcons/smalltruck_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "pickup"
                                                    ?
                                                "assets/images/vehicle/smalltruckIcons/smalltruck_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "pickup"
                                                    ?
                                                "assets/images/vehicle/smalltruckIcons/smalltruck_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "pickup"
                                                    ?
                                                "assets/images/vehicle/smalltruckIcons/smalltruck_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "pickup"
                                                    ?
                                                "assets/images/vehicle/smalltruckIcons/smalltruck_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "tractor"
                                                    ?
                                                "assets/images/tractor_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "tractor"
                                                    ?
                                                "assets/images/tracktor_ic_stoppage.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "tractor"
                                                    ?
                                                "assets/images/tracktor_ic_idling.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "tractor"
                                                    ?
                                                "assets/images/tractor_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "tractor"
                                                    ?
                                                "assets/images/tractor_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "tractor"
                                                    ?
                                                "assets/images/tracktor_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "car"
                                                    ?
                                                "assets/images/vehicle/carIcons/car_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "scooter"
                                                    ?
                                                "assets/images/vehicle/scootyIcons/scooty_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "scooter"
                                                    ?
                                                "assets/images/vehicle/scootyIcons/scooty_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "scooter"
                                                    ?
                                                "assets/images/vehicle/scootyIcons/scooty_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "scooter"
                                                    ?
                                                "assets/images/vehicle/scootyIcons/scooty_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "scooter"
                                                    ?
                                                "assets/images/vehicle/scootyIcons/scooty_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "scooter"
                                                    ?
                                                "assets/images/vehicle/scootyIcons/scooty_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "bike"
                                                    ?
                                                "assets/images/vehicle/bikeIcons/bike_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "bike"
                                                    ?
                                                "assets/images/vehicle/bikeIcons/bike_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "bike"
                                                    ?
                                                "assets/images/vehicle/bikeIcons/bike_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "bike"
                                                    ?
                                                "assets/images/vehicle/bikeIcons/bike_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "bike"
                                                    ?
                                                "assets/images/vehicle/bikeIcons/bike_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "bike"
                                                    ?
                                                "assets/images/vehicle/bikeIcons/bike_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "user"
                                                    ?
                                                "assets/images/vehicle/userIcons/user_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "user"
                                                    ?
                                                "assets/images/vehicle/userIcons/user_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "user"
                                                    ?
                                                "assets/images/vehicle/userIcons/user_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "user"
                                                    ?
                                                "assets/images/vehicle/userIcons/user_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "user"
                                                    ?
                                                "assets/images/vehicle/userIcons/user_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "user"
                                                    ?
                                                "assets/images/vehicle/userIcons/user_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "pet"
                                                    ?
                                                "assets/images/vehicle/petIcons/pet_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "pet"
                                                    ?
                                                "assets/images/vehicle/petIcons/pet_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "pet"
                                                    ?
                                                "assets/images/vehicle/petIcons/pet_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "pet"
                                                    ?
                                                "assets/images/vehicle/petIcons/pet_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "pet"
                                                    ?
                                                "assets/images/vehicle/petIcons/pet_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "pet"
                                                    ?
                                                "assets/images/vehicle/petIcons/pet_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "jcb"
                                                    ?
                                                "assets/images/vehicle/jcbIcons/jcb_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "jcb"
                                                    ?
                                                "assets/images/vehicle/jcbIcons/jcb_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "jcb"
                                                    ?
                                                "assets/images/vehicle/jcbIcons/jcb_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "jcb"
                                                    ?
                                                "assets/images/vehicle/jcbIcons/jcb_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "jcb"
                                                    ?
                                                "assets/images/vehicle/jcbIcons/jcb_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.iconType ==
                                                        "jcb"
                                                    ?
                                                "assets/images/vehicle/jcbIcons/jcb_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "boat"
                                                    ?
                                                "assets/images/vehicle/boatIcons/boat_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "boat"
                                                    ?
                                                "assets/images/vehicle/boatIcons/boat_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "boat"
                                                    ?
                                                "assets/images/vehicle/boatIcons/boat_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList
                                                        .iconType == "boat"
                                                    ?
                                                "assets/images/vehicle/boatIcons/boat_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "boat"
                                                    ?
                                                "assets/images/vehicle/boatIcons/boat_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.vehicleType
                                                        .iconType == "boat"
                                                    ?
                                                "assets/images/vehicle/boatIcons/boat_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "auto"
                                                    ?
                                                "assets/images/vehicle/autoIcons/auto_running_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "auto"
                                                    ?
                                                "assets/images/vehicle/autoIcons/auto_stopped_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "auto"
                                                    ?
                                                "assets/images/vehicle/autoIcons/auto_idling_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "auto"
                                                    ?
                                                "assets/images/vehicle/autoIcons/auto_outreach_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "auto"
                                                    ?
                                                "assets/images/vehicle/autoIcons/auto_expired_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.vehicleType
                                                        .iconType == "auto"
                                                    ?
                                                "assets/images/vehicle/autoIcons/auto_nodata_ic.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "ambulance"
                                                    ?
                                                "assets/images/vehicle/ambulanceIcon/ambulance_green.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "ambulance"
                                                    ?
                                                "assets/images/vehicle/ambulanceIcon/ambulance_red.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "ambulance"
                                                    ?
                                                "assets/images/vehicle/ambulanceIcon/ambulance_yello.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "ambulance"
                                                    ?
                                                "assets/images/vehicle/ambulanceIcon/ambulance_blue.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "ambulance"
                                                    ?
                                                "assets/images/vehicle/ambulanceIcon/ambulance_orange.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.vehicleType
                                                        .iconType == "ambulance"
                                                    ?
                                                "assets/images/vehicle/ambulanceIcon/ambulance_grey.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "crane"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneGreenIcon.png"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "crane"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneRedIcon.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "crane"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneYellowIcon.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "crane"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneBlueIcon.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "crane"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneOrangeIcon.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.vehicleType
                                                        .iconType == "crane"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneGreyIcon.png"
                                                    :
                                                vehicleList.status ==
                                                    "RUNNING" &&
                                                    vehicleList.iconType ==
                                                        "machine"
                                                    ?
                                                "assets/images/vehicle/"
                                                    :
                                                vehicleList.status ==
                                                    "STOPPED" &&
                                                    vehicleList.iconType ==
                                                        "machine"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneRedIcon.png"
                                                    :
                                                vehicleList.status ==
                                                    "IDLING" &&
                                                    vehicleList.iconType ==
                                                        "machine"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneYellowIcon.png"
                                                    :
                                                vehicleList.status ==
                                                    "OUT OF REACH" &&
                                                    vehicleList.iconType ==
                                                        "machine"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneBlueIcon.png"
                                                    :
                                                vehicleList.status ==
                                                    "Expired" &&
                                                    vehicleList.iconType ==
                                                        "machine"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneOrangeIcon.png"
                                                    :
                                                vehicleList.status ==
                                                    "NO Data" &&
                                                    vehicleList.vehicleType
                                                        .iconType == "machine"
                                                    ?
                                                "assets/images/vehicle/craneIcon/craneGreyIcon.png"
                                                    :
                                                "assets/images/vehicle/userIcons/user_nodata_ic.png",
                                                width: 40,
                                                fit: BoxFit.fill,
                                              ),

                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [

                                                    Text(
                                                      vehicleList.deviceName,
                                                      style: Textstyle1
                                                          .text18boldBlack
                                                          .copyWith(
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          "${vehicleList
                                                              .status} : ",
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 1,
                                                          textAlign: TextAlign
                                                              .start,
                                                          style: Textstyle1
                                                              .texts12.copyWith(
                                                            fontSize: 10,
                                                            color: "${vehicleList
                                                                .status}" ==
                                                                "RUNNING"
                                                                ?
                                                            ApplicationColors
                                                                .greenColor370
                                                                :
                                                            "${vehicleList
                                                                .status}" ==
                                                                "IDLING"
                                                                ?
                                                            ApplicationColors
                                                                .yellowColorD21
                                                                :
                                                            "${vehicleList
                                                                .status}" ==
                                                                "OUT OF REACH"
                                                                ?
                                                            ApplicationColors
                                                                .blueColorCE
                                                                :
                                                            "${vehicleList
                                                                .status}" ==
                                                                "Expired"
                                                                ?
                                                            ApplicationColors
                                                                .orangeColor3E
                                                                :
                                                            "${vehicleList
                                                                .status}" ==
                                                                "NO DATA"
                                                                ?
                                                            ApplicationColors
                                                                .appColors3
                                                                :
                                                            ApplicationColors
                                                                .redColor67,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            "${getTranslated(
                                                                context,
                                                                "since")} "
                                                                "${totalHours}h ${totalMinutes}m",
                                                            //"${DateFormat.H().format(vehicleList.statusUpdatedAt)}h ${DateFormat.m().format(vehicleList.statusUpdatedAt)}m",
                                                            style: Textstyle1
                                                                .text12black
                                                                .copyWith(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 2),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        /*Image.asset(
                                                        'assets/images/clock_icon_vehicle_Page.png',
                                                        width: 13,
                                                        color: "${vehicleList.status}" == "RUNNING"
                                                            ?
                                                        ApplicationColors.greenColor370
                                                            :
                                                        "${vehicleList.status}" == "IDLING"
                                                            ?
                                                        ApplicationColors.yellowColorD21
                                                            :
                                                        "${vehicleList.status}" == "OUT OF REACH"
                                                            ?
                                                        ApplicationColors.blueColorCE
                                                            :
                                                        "${vehicleList.status}" == "Expired"
                                                            ?
                                                        ApplicationColors.orangeColor3E
                                                            :
                                                        "${vehicleList.status}" == "NO DATA"
                                                            ?
                                                        ApplicationColors.appColors3
                                                            :
                                                        ApplicationColors.redColor67,
                                                      ),*/
                                                        Text("${getTranslated(
                                                            context,
                                                            "last_update")}",
                                                          style: Textstyle1
                                                              .text12black
                                                              .copyWith(
                                                              fontSize: 9,
                                                              color: ApplicationColors
                                                                  .redColor67),),
                                                        SizedBox(width: 5,),
                                                        Expanded(
                                                          child: Text(
                                                            DateFormat(
                                                                "MMM dd,yyyy hh:mm:ss aa")
                                                                .format(
                                                                vehicleList
                                                                    .lastPingOn
                                                                    .toLocal()),
                                                            overflow: TextOverflow
                                                                .visible,
                                                            maxLines: 2,
                                                            textAlign: TextAlign
                                                                .start,
                                                            style: Textstyle1
                                                                .text12black
                                                                .copyWith(
                                                                fontSize: 9,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                          "assets/images/Petrol_icon1.png",
                                                          scale: 3),
                                                      Text(
                                                        "${vehicleList
                                                            .currentFuel == null
                                                            ? 0
                                                            : vehicleList
                                                            .currentFuel} ${_userProvider
                                                            .useModel.cust
                                                            .fuelUnit == "LITER"
                                                            ? "L"
                                                            : "%"}",
                                                        overflow: TextOverflow
                                                            .visible,
                                                        maxLines: 1,
                                                        textAlign: TextAlign
                                                            .end,
                                                        style: Textstyle1
                                                            .text12black
                                                            .copyWith(
                                                            fontSize: 11,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w600
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Column(
                                                    children: [
                                                      // Image.asset("assets/images/Km_icon1.png",scale: 3),
                                                      Text(
                                                        "${NumberFormat(
                                                            "##0.0#", "en_US")
                                                            .format(double
                                                            .parse(
                                                            vehicleList
                                                                .lastSpeed ??
                                                                "0"))}",
                                                        overflow: TextOverflow
                                                            .visible,
                                                        maxLines: 2,
                                                        textAlign: TextAlign
                                                            .start,
                                                        style: Textstyle1
                                                            .text12black
                                                            .copyWith(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w600
                                                        ),),
                                                      Text(
                                                        "${_userProvider
                                                            .useModel
                                                            .cust
                                                            .unitMeasurement ==
                                                            "MKS"
                                                            ? "${getTranslated(
                                                            context, "km_hr")}"
                                                            : "${getTranslated(
                                                            context,
                                                            "Miles_hr")}"}",
                                                        overflow: TextOverflow
                                                            .visible,
                                                        maxLines: 2,
                                                        textAlign: TextAlign
                                                            .start,
                                                        style: Textstyle1
                                                            .text12black
                                                            .copyWith(
                                                            fontSize: 11,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w600
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              superAdmin == true ||
                                                  isDealer == true ||
                                                  isSuperAdmin == true
                                                  ? InkWell(
                                                child: Icon(Icons.more_vert),
                                                onTap: () {
                                                  if( vehicleList.dealer == null){
                                                    Helper.dialogCall
                                                        .showToast(context, "Dealer not assigned to this vehicle.\n Please assign dealer to this vehicle first.");
                                                  }{
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (
                                                              BuildContext context) =>
                                                              EditVehicle(
                                                                id: vehicleList
                                                                    .id,
                                                                devicemodelID: vehicleList
                                                                    .deviceModel
                                                                    .id,
                                                                userID: vehicleList
                                                                    .user.id,
                                                                vehiclemodel: vehicleList
                                                                    .vehicleType
                                                                    .model,
                                                                deviceidimei: vehicleList
                                                                    .deviceId,
                                                                reginumber: vehicleList
                                                                    .deviceName,
                                                                simnumber: vehicleList
                                                                    .simNumber,
                                                                simnumber2: vehicleList
                                                                    .simNumber2,
                                                                drivername: vehicleList
                                                                    .driverName,
                                                                drivermobnumber: "0",
                                                                speedlimit: vehicleList
                                                                    .speedLimit,
                                                                expiredate: vehicleList
                                                                    .expirationDate,
                                                                devicemodel: vehicleList
                                                                    .deviceModel
                                                                    .deviceType,
                                                                dealer: vehicleList.dealer,
                                                                user: vehicleList
                                                                    .user
                                                                    .firstName,
                                                                vehicletype: vehicleList
                                                                    .vehicleType
                                                                    .model,
                                                                vehicletypeID: vehicleList
                                                                    .vehicleType
                                                                    .id,
                                                              )
                                                      )
                                                  ).then((value) {
                                                    if (value == true) {
                                                      if (vehicleListProvider
                                                          .vehicleList !=
                                                          null) {
                                                        vehicleListProvider
                                                            .vehicleList
                                                            .clear();
                                                        getVehicleList(0, "");
                                                      }
                                                    }
                                                  });
                                                }},) : SizedBox()
                                            ],

                                          ),
                                        ),
                                        SizedBox(height: 6,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Image.asset(
                                                  "assets/images/gps1.png",
                                                  width: 10,
                                                  color: ApplicationColors
                                                      .black4240),
                                              SizedBox(width: 10,),
                                              SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.75,
                                                child: Text(
                                                  vehicleListProvider
                                                      .vehicleList[index]
                                                      .address == "NA"
                                                      ? "No address found"
                                                      : vehicleListProvider
                                                      .vehicleList[index]
                                                      .address,
                                                  /* vehicleListProvider.addressList.isEmpty ? "" :
                                                //"${vehicleListProvider.addressList[index]}",
                                                "${vehicleListProvider.addressList[index]}",*/
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: Textstyle1.signupText
                                                      .copyWith(fontSize: 11,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 6,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [


                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: SizedBox(
                                                height: height * .06,
                                                width: width * 0.42,
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Image.asset(
                                                        //"assets/images/power.png",
                                                        "assets/images/key.png",
                                                        width: 16,
                                                        color: vehicleList
                                                            .ignitionSource ==
                                                            null
                                                            ? ApplicationColors
                                                            .greyC4C4
                                                            : vehicleList
                                                            .lastAcc == "0"
                                                            ? ApplicationColors
                                                            .redColor67
                                                            : ApplicationColors
                                                            .greenColor,
                                                      ),
                                                      Image.asset(
                                                        //"assets/images/ac_icon1.png",
                                                        "assets/images/freezer.png",
                                                        width: 16,
                                                        color: vehicleList.ac ==
                                                            null
                                                            ? ApplicationColors
                                                            .greyC4C4
                                                            : vehicleList.ac ==
                                                            "0"
                                                            ? ApplicationColors
                                                            .redColor67
                                                            : ApplicationColors
                                                            .greenColor,

                                                      ),
                                                      Image.asset(
                                                        //"assets/images/petrol_icon_.png",
                                                        "assets/images/Battery.png",
                                                        width: 12,
                                                        color: vehicleList
                                                            .batteryPercent ==
                                                            null
                                                            ? ApplicationColors
                                                            .greyC4C4
                                                            : vehicleList
                                                            .currentFuel == 0
                                                            ? ApplicationColors
                                                            .redColor67
                                                            : ApplicationColors
                                                            .greenColor,

                                                      ),
                                                      Image.asset(
                                                        // "assets/images/Electricity_icon.png",
                                                        "assets/images/power.png",
                                                        width: 16,
                                                        color: vehicleList
                                                            .power == null
                                                            ? ApplicationColors
                                                            .greyC4C4
                                                            : vehicleList
                                                            .power ==
                                                            "0"
                                                            ? ApplicationColors
                                                            .redColor67
                                                            : ApplicationColors
                                                            .greenColor,

                                                      ),
                                                      /*  Image.asset(
                                                      "assets/images/thermometer_icon.png",
                                                      width: 15, height: 18,
                                                      color: vehicleList.temp ==
                                                          ""
                                                          ? ApplicationColors
                                                          .greyC4C4
                                                          : vehicleList.temp ==
                                                          "0"
                                                          ? ApplicationColors
                                                          .redColor67
                                                          : ApplicationColors
                                                          .greenColor,
                                                    ),*/
                                                      /* Image.asset(
                                                      "assets/images/gps_icon1.png",
                                                      width: 15,
                                                      color: vehicleList
                                                          .gpsTracking == null
                                                          ? ApplicationColors
                                                          .greyC4C4
                                                          : vehicleList
                                                          .gpsTracking == "0"
                                                          ? ApplicationColors
                                                          .redColor67
                                                          : ApplicationColors
                                                          .greenColor,

                                                    ),*/
                                                      /* Image.asset(
                                                      "assets/images/Door_icon.png",
                                                      width: 18, height: 20,
                                                      color: vehicleList.door ==
                                                          null
                                                          ? ApplicationColors
                                                          .greyC4C4
                                                          : vehicleList.door ==
                                                          "0"
                                                          ? ApplicationColors
                                                          .redColor67
                                                          : ApplicationColors
                                                          .greenColor,
                                                    ),*/
                                                      Image.asset(
                                                        //"assets/images/arm_icon_immobilized.png",
                                                        "assets/images/secured-lock.png",
                                                        width: 16,
                                                        color: vehicleList
                                                            .ignitionLock == "1"
                                                            ? ApplicationColors
                                                            .redColor67
                                                            : vehicleList
                                                            .ignitionLock == "0"
                                                            ? ApplicationColors
                                                            .greenColor
                                                            : ApplicationColors
                                                            .greyC4C4,
                                                      ),
                                                      Image.asset(
                                                        "assets/images/satellite.png",
                                                        width: 18, height: 20,
                                                        color: vehicleList
                                                            .satellites ==
                                                            null
                                                            ? ApplicationColors
                                                            .greyC4C4
                                                            : vehicleList
                                                            .door ==
                                                            "0"
                                                            ? ApplicationColors
                                                            .redColor67
                                                            : ApplicationColors
                                                            .greenColor,
                                                      ),

                                                    ]
                                                ),

                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (vehicleList.distance ==
                                                    null) {
                                                  _reportProvider
                                                      .toggleSelected(index);
                                                }

                                                await distanceReport(
                                                    vehicleList.id,
                                                    vehicleList,
                                                    vehicleList.user.id
                                                );
                                              },
                                              child: Container(
                                                height: height * .062,
                                                width: width * 0.40,
                                                decoration: BoxDecoration(

                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/vehiclelistbg.png"),
                                                      fit: BoxFit.cover
                                                  ),
                                                  //color: Colors.red
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(top: 13, left: 20),
                                                  child: Column(
                                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                                    //mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // Image.asset("assets/images/km_icon.png",width: 15,),
                                                      Text("${getTranslated(
                                                          context,
                                                          "today_odo")}",
                                                        style: Textstyle1.text12
                                                            .copyWith(
                                                          fontSize: 10,
                                                        ),),
                                                      SizedBox(height: 5,),
                                                      _reportProvider
                                                          .selectedItems
                                                          .contains(index)
                                                          ? Text(
                                                          vehicleList
                                                              .distance == null
                                                              ? '' //"0.0 Km"
                                                              : /* _reportProvider.isDistanceReportLoading==true?"":*/
                                                          "${vehicleList
                                                              .distance
                                                              .toStringAsFixed(
                                                              2)}Km",
                                                          style: Textstyle1
                                                              .text12.copyWith(
                                                            fontSize: 10,
                                                          ))
                                                          : Image.asset(
                                                        "assets/images/refresh_ic.png",
                                                        scale: 8,)
                                                    ],

                                                  ),
                                                ),
                                              ),

                                            )
                                          ],
                                        ),
                                        Container(
                                          height: height * .025,
                                          color: Colors.black,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Row(
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: width * 0.42,
                                                  child: Text(
                                                    "Licence Purchased on - ${DateFormat(
                                                        "MMM dd yyyy").format(
                                                        vehicleList
                                                            .createdOn)} ",

                                                    style: Textstyle1.text10
                                                        .copyWith(
                                                        fontSize: 9,
                                                        color: Colors.white
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * 0.27,
                                                  child: Text(
                                                    "Expire on - ${DateFormat(
                                                        "MMM dd yyyy").format(
                                                        vehicleList
                                                            .expirationDate)}",
                                                    style: Textstyle1.text10
                                                        .copyWith(
                                                        fontSize: 9,
                                                        color: Colors.white
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),


                                                /*  Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "${getTranslated(context, "licence_expires")} ",
                                                          style: Textstyle1.text10.copyWith(
                                                              fontSize: 11,color: Colors.white
                                                          ),
                                                        ),

                                                        TextSpan(
                                                          text: "${DateFormat("MMM dd yyyy").format(vehicleList.createdOn)}",
                                                          style: Textstyle1.text10.copyWith(
                                                              fontSize: 11,color: Colors.white
                                                          ),
                                                        ),

                                                        TextSpan(
                                                          text: "  ${getTranslated(context, "to")}  ",
                                                          style: Textstyle1.text10.copyWith(
                                                              fontSize: 11,color: Colors.white
                                                          ),
                                                        ),

                                                        TextSpan(
                                                          text:  DateFormat("MMM dd yyyy").format(vehicleList.expirationDate),
                                                          style: Textstyle1.text10.copyWith(
                                                              fontSize: 11,color: Colors.white
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ),*/

                                              ],
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),

                                  /* ExpansionTile(
                                  iconColor: ApplicationColors.redColor67,
                                  collapsedIconColor:ApplicationColors.redColor67 ,

                                  initiallyExpanded: false,
                                  trailing: vehicleListProvider.listExpand[index]
                                      ?
                                  Image.asset(
                                    "assets/images/arrow_up.png",
                                    width: 11,color: ApplicationColors.whiteColor,
                                  )
                                      :
                                  Image.asset(
                                    "assets/images/dropdows_icon.png",color: ApplicationColors.whiteColor,
                                    width: 10,
                                  ),
                                  onExpansionChanged: (value) {
                                    vehicleListProvider.changeBoolIndex(value, index);
                                  },
                                  title: Row(
                                    children: [
                                      Image.asset("assets/images/gps1.png",width: 15,color: ApplicationColors.whiteColor),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Text(
                                          vehicleListProvider.addressList.isEmpty ? "" :
                                          "${vehicleListProvider.addressList[index]}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Textstyle1.signupText.copyWith(fontSize: 12,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10,bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "${getTranslated(context, "licence_expires")} ",
                                                      style: Textstyle1.text10.copyWith(
                                                        fontSize: 11,color: Colors.white
                                                      ),
                                                    ),

                                                    TextSpan(
                                                      text: "${DateFormat("MMM dd yyyy").format(vehicleList.createdOn)}",
                                                      style: Textstyle1.text10.copyWith(
                                                        fontSize: 11,color: Colors.white
                                                      ),
                                                    ),

                                                    TextSpan(
                                                      text: "  ${getTranslated(context, "to")}  ",
                                                      style: Textstyle1.text10.copyWith(
                                                        fontSize: 11,color: Colors.white
                                                      ),
                                                    ),

                                                    TextSpan(
                                                      text:  DateFormat("MMM dd yyyy").format(vehicleList.expirationDate),
                                                      style: Textstyle1.text10.copyWith(
                                                        fontSize: 11,color: Colors.white
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(right: 10,left: 10,bottom: 10),
                                        child:  SizedBox(
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
                                                            "assets/images/setting_icon_vehicle_lis.png",
                                                            width: 15,
                                                            color: vehicleList.lastAcc == null ? ApplicationColors.greyC4C4 : vehicleList.lastAcc == "0" ?ApplicationColors.redColor67 :ApplicationColors.greenColor,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2,),
                                                        Text(
                                                          "${getTranslated(context, "ign")}",
                                                          overflow: TextOverflow.ellipsis,
                                                          style: Textstyle1.text12.copyWith(fontSize: 10,color: Colors.black),
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
                                                              "assets/images/ac_icon1.png",
                                                              width: 15,
                                                              color: vehicleList.ac == null ? ApplicationColors.greyC4C4 :vehicleList.ac == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,

                                                            ),
                                                          ),
                                                          SizedBox(height: 2,),
                                                          Text(
                                                            "${getTranslated(context, "ac")}",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Textstyle1.text12.copyWith(fontSize: 10,color: Colors.black),
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
                                                              "assets/images/petrol_icon_.png",
                                                              width: 15,
                                                              color:vehicleList.currentFuel == null ? ApplicationColors.greyC4C4 : vehicleList.currentFuel == 0 ? ApplicationColors.redColor67 : ApplicationColors.greenColor,

                                                            ),
                                                          ),
                                                          SizedBox(height: 2,),
                                                          Text(
                                                            "${getTranslated(context, "fuel")}",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Textstyle1.text12.copyWith(fontSize: 10,color: Colors.black),
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
                                                              "assets/images/Electricity_icon.png",
                                                              width: 15,
                                                              color:vehicleList.power == null ? ApplicationColors.greyC4C4 : vehicleList.power == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,

                                                            ),
                                                          ),
                                                          SizedBox(height: 2,),
                                                          Text(
                                                            "${getTranslated(context, "power")}",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Textstyle1.text12.copyWith(fontSize: 10,color:Colors.black),
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
                                                              "assets/images/thermometer_icon.png",
                                                              width: 15,
                                                              color:vehicleList.temp == "" ? ApplicationColors.greyC4C4 : vehicleList.temp == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,
                                                            ),
                                                          ),
                                                          SizedBox(height: 2,),
                                                          Text(
                                                            "${getTranslated(context, "temp")}",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Textstyle1.text12.copyWith(fontSize: 10,color: Colors.black),
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
                                                              "assets/images/gps_icon1.png",
                                                              width: 15,
                                                              color:vehicleList.gpsTracking == null ? ApplicationColors.greyC4C4 : vehicleList.gpsTracking == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,

                                                            ),
                                                          ),
                                                          SizedBox(height: 2,),
                                                          Text(
                                                            "${getTranslated(context, "gps")}",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Textstyle1.text12.copyWith(fontSize: 10,color: Colors.black),
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
                                                              color:vehicleList.door == null ? ApplicationColors.greyC4C4 :vehicleList.door == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,
                                                            ),
                                                          ),
                                                          SizedBox(height: 2,),
                                                          Text(
                                                            "${getTranslated(context, "door")}",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Textstyle1.text12.copyWith(fontSize: 10,color: Colors.black),
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
                                                              "assets/images/arm_icon_immobilized.png",
                                                              width: 15,
                                                              color: vehicleList.ignitionLock == null ? ApplicationColors.greyC4C4 :vehicleList.ignitionLock == "0" ? ApplicationColors.redColor67 : ApplicationColors.greenColor,
                                                            ),
                                                          ),
                                                          SizedBox(height: 2,),
                                                          Text(
                                                            "${getTranslated(context, "lock")}",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Textstyle1.text12.copyWith(fontSize: 10,color: Colors.black),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                            )
                                        )
                                    )
                                  ],
                                ),*/
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),


                  vehicleListProvider.isVehicleLoading == false || _showRefresh
                      ?
                  SizedBox()
                      :
                  vehicleListProvider.isCommentLoading
                      ?
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Helper.dialogCall.showLoader(),
                              SizedBox(width: 20),
                              Text(
                                  "${getTranslated(context, "loading_more")}",
                                  style: Textstyle1.text10
                              )
                            ],
                          ),
                          SizedBox(height: 65),
                        ],
                      )
                  )
                      :
                  SizedBox(),

                ],
              ),
            )
        ),
      ],

    );
  }

  // String getStreetViewUrl(double lat, double lng) {
  //   final String url = "https://www.google.com/maps/@?api=1&map_action=pano&pano=";
  //   final String coordinates = "$lat,$lng";
  //   final String parameters = "&heading=0&pitch=0&fov=90";
  //
  //   return url + coordinates + parameters;
  // }

  // String getStreetViewUrl(double latitude, double longitude) {
  //   final String url = "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=$latitude,$longitude&fov=90&heading=235&pitch=10&key=AIzaSyAdonwbTHNYYyJKwQVo2qY23FaX9PL9qSc";
  //
  //   return url;
  // }

  String getStreetViewUrl(double lat, double lng) {
    final String url = "https://www.google.com/maps/@$lat,$lng,15z/data=!3m1!1e3";

    return url;
  }


  @override
  void dispose() {
    if (socket != null) {
      socket.dispose();
      socket.disconnect();
    }

    //timer?.cancel();
    // animationController.dispose();
    if (data != null) {
      prefes.remove('data');
      data = null;
    }
    vehiclestatus = " ";
    super.dispose();
  }


  getDataUrl(String urlencoded_url) async {
    final response = await http.get(
        Uri.parse("http://tinyurl.com/api-create.php?url=$urlencoded_url"));
    String res =response.body;
    String newUrl = res.replaceFirst('https', 'http');
    print(response.body);
    Share.share(newUrl);
  }

// getUrl(url) async {
//   final client = HttpClient();
//   var uri = Uri.parse(url);
//   var request = await client.getUrl(uri);
//   request.followRedirects = false;
//   var response = await request.close();
//   while (response.isRedirect) {
//     response.drain();
//     final location = response.headers.value(HttpHeaders.locationHeader);
//
//     if (location != null) {
//       uri = uri.resolve(location);
//       request = await client.getUrl(uri);
//       // Set the body or headers as desired.
//
//       if (location.toString().conFtains('https://www.xxxxx.com')) {
//         return location.toString();
//       }
//       request.followRedirects = false;
//       response = await request.close();
//
//       print(response);
//     }
//   }
// }


}
