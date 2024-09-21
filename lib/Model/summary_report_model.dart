// To parse this JSON data, do
//
//     final summaryReportModel = summaryReportModelFromJson(jsonString);

import 'dart:convert';

List<SummaryReportModel> summaryReportModelFromJson(String str) => List<SummaryReportModel>.from(json.decode(str).map((x) => SummaryReportModel.fromJson(x)));

String summaryReportModelToJson(List<SummaryReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SummaryReportModel {
  SummaryReportModel({
    this.id,
    this.todayOdo,
    this.startLocation,
    this.endLocation,
    this.totalOdo,
    this.todayRunning,
    this.tIdling,
    this.tOfr,
    this.tNoGps,
    this.todayStopped,
    this.todayTrips,
    this.todayRouteViolations,
    this.todayOverspeeds,
    this.todayMaxSpeed,
    this.devObj,
  });

  String id;
  double todayOdo;
  Location startLocation;
  Location endLocation;
  double totalOdo;
  int todayRunning;
  int tIdling;
  int tOfr;
  int tNoGps;
  int todayStopped;
  int todayTrips;
  int todayRouteViolations;
  int todayOverspeeds;
  int todayMaxSpeed;
  List<SummaryReportList> devObj;

  factory SummaryReportModel.fromJson(Map<String, dynamic> json) => SummaryReportModel(
    id: json["_id"] == null ? null : json["_id"],
    todayOdo: json["today_odo"] == null ? null : json["today_odo"].toDouble(),
    startLocation: json["start_location"] == null ? null : Location.fromJson(json["start_location"]),
    endLocation: json["end_location"] == null ? null : Location.fromJson(json["end_location"]),
    totalOdo: json["total_odo"] == null ? null : json["total_odo"].toDouble(),
    todayRunning: json["today_running"] == null ? null : json["today_running"],
    tIdling: json["t_idling"] == null ? null : json["t_idling"],
    tOfr: json["t_ofr"] == null ? null : json["t_ofr"],
    tNoGps: json["t_noGps"] == null ? null : json["t_noGps"],
    todayStopped: json["today_stopped"] == null ? null : json["today_stopped"],
    todayTrips: json["today_trips"] == null ? null : json["today_trips"],
    todayRouteViolations: json["today_routeViolations"] == null ? null : json["today_routeViolations"],
    todayOverspeeds: json["today_overspeeds"] == null ? null : json["today_overspeeds"],
    todayMaxSpeed: json["today_maxSpeed"] == null ? null : json["today_maxSpeed"],
    devObj: json["devObj"] == null ? null : List<SummaryReportList>.from(json["devObj"].map((x) => SummaryReportList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "today_odo": todayOdo == null ? null : todayOdo,
    "start_location": startLocation == null ? null : startLocation.toJson(),
    "end_location": endLocation == null ? null : endLocation.toJson(),
    "total_odo": totalOdo == null ? null : totalOdo,
    "today_running": todayRunning == null ? null : todayRunning,
    "t_idling": tIdling == null ? null : tIdling,
    "t_ofr": tOfr == null ? null : tOfr,
    "t_noGps": tNoGps == null ? null : tNoGps,
    "today_stopped": todayStopped == null ? null : todayStopped,
    "today_trips": todayTrips == null ? null : todayTrips,
    "today_routeViolations": todayRouteViolations == null ? null : todayRouteViolations,
    "today_overspeeds": todayOverspeeds == null ? null : todayOverspeeds,
    "today_maxSpeed": todayMaxSpeed == null ? null : todayMaxSpeed,
    "devObj": devObj == null ? null : List<dynamic>.from(devObj.map((x) => x.toJson())),
  };
}

class SummaryReportList {
  SummaryReportList({
    this.id,
    this.deviceName,
    this.deviceId,
    this.emailId,
    this.supAdmin,
    this.dealer,
    this.token,
    this.typeOfDevice,
    this.simNumber,
    this.user,
    this.speedAlert,
    this.deviceModel,
    this.expirationDate,
    this.vehicleType,
    this.createdBy,
    this.speedLimit,
    this.distanceVariation,
    this.mileage,
    this.speedChart,
    this.doMap,
    this.dIMap,
    this.sos,
    this.capacity,
    this.tripType,
    this.todayTrips,
    this.todayMaxspeed,
    this.todayRouteViolations,
    this.todayOverspeeds,
    this.overspeeding,
    this.sosTo,
    this.ignitionSource,
    this.deviceImage,
    this.accountSuspended,
    this.license,
    this.active,
    this.arm,
    this.ignitionLock,
    this.createdOn,
    this.engineStatus,
    this.currentTripStatus,
    this.imageDoc,
    this.fuelMeasurement,
    this.snaps,
    this.fuelUnit,
    this.maxStoppageAlerted,
    this.maxStoppageAlert,
    this.status,
    this.maxSpeed,
    this.tripCount,
    this.totalOdo,
    this.todayOdo,
    this.lastLoc,
    this.iconType,
    this.shared,
    this.overIdleLimit,
    this.overStoppedLimit,
    this.towAlert,
    this.theftAlert,
    this.maintenance,
    this.hardWare,
    this.v,
    this.ac,
    this.battery,
    this.currentFuel,
    this.currentFuelVoltage,
    this.distFromLastStop,
    this.fuelPercent,
    this.gpsTracking,
    this.gsmSignal,
    this.heading,
    this.ip,
    this.lastAcc,
    this.lastAccChangeOn,
    this.lastAccOn,
    this.lastDeviceTime,
    this.lastLocation,
    this.lastPingOn,
    this.lastSpeed,
    this.lastSpeedZeroAt,
    this.port,
    this.power,
    this.satellites,
    this.secLastLocation,
    this.secLastSpeed,
    this.todayStartLocation,
    this.currentRoute,
    this.lastStoppedAt,
    this.statusUpdatedAt,
    this.lastIgnChangeAt,
    this.todayIgnOff,
    this.todayStopped,
    this.currentToll,
    this.currentTollName,
    this.currentPoi,
    this.currentPoiName,
    this.sb3CurrentPoi,
    this.lastIdleAt,
    this.timeAtLastStop,
    this.todayIgnOn,
    this.tIdling,
    this.timezone,
    this.todayRunning,
    this.tNoGps,
    this.tOfr,
    this.tRunning,
    this.tStopped,
    this.lastOverspeedTime,
    this.lastOverStoppedAlertOn,
    this.lastOverIdleAlertOn,
  });

  String id;
  String deviceName;
  String deviceId;
  String emailId;
  String supAdmin;
  String dealer;
  String token;
  String typeOfDevice;
  String simNumber;
  String user;
  bool speedAlert;
  String deviceModel;
  DateTime expirationDate;
  String vehicleType;
  String createdBy;
  int speedLimit;
  String distanceVariation;
  String mileage;
  Map<String, int> speedChart;
  DoMap doMap;
  DIMap dIMap;
  bool sos;
  int capacity;
  int tripType;
  int todayTrips;
  int todayMaxspeed;
  int todayRouteViolations;
  int todayOverspeeds;
  bool overspeeding;
  List<dynamic> sosTo;
  String ignitionSource;
  List<dynamic> deviceImage;
  bool accountSuspended;
  String license;
  bool active;
  String arm;
  String ignitionLock;
  DateTime createdOn;
  bool engineStatus;
  String currentTripStatus;
  List<dynamic> imageDoc;
  String fuelMeasurement;
  List<dynamic> snaps;
  String fuelUnit;
  bool maxStoppageAlerted;
  bool maxStoppageAlert;
  String status;
  int maxSpeed;
  int tripCount;
  double totalOdo;
  double todayOdo;
  LastLoc lastLoc;
  String iconType;
  List<dynamic> shared;
  int overIdleLimit;
  int overStoppedLimit;
  bool towAlert;
  bool theftAlert;
  bool maintenance;
  String hardWare;
  int v;
  dynamic ac;
  String battery;
  double currentFuel;
  int currentFuelVoltage;
  double distFromLastStop;
  String fuelPercent;
  String gpsTracking;
  String gsmSignal;
  String heading;
  String ip;
  String lastAcc;
  DateTime lastAccChangeOn;
  DateTime lastAccOn;
  DateTime lastDeviceTime;
  Location lastLocation;
  DateTime lastPingOn;
  String lastSpeed;
  DateTime lastSpeedZeroAt;
  String port;
  String power;
  dynamic satellites;
  Location secLastLocation;
  String secLastSpeed;
  Location todayStartLocation;
  dynamic currentRoute;
  DateTime lastStoppedAt;
  DateTime statusUpdatedAt;
  DateTime lastIgnChangeAt;
  int todayIgnOff;
  int todayStopped;
  dynamic currentToll;
  dynamic currentTollName;
  dynamic currentPoi;
  dynamic currentPoiName;
  dynamic sb3CurrentPoi;
  DateTime lastIdleAt;
  int timeAtLastStop;
  int todayIgnOn;
  int tIdling;
  String timezone;
  int todayRunning;
  int tNoGps;
  int tOfr;
  int tRunning;
  int tStopped;
  DateTime lastOverspeedTime;
  DateTime lastOverStoppedAlertOn;
  DateTime lastOverIdleAlertOn;

  factory SummaryReportList.fromJson(Map<String, dynamic> json) => SummaryReportList(
    id: json["_id"] == null ? null : json["_id"],
    deviceName: json["Device_Name"] == null ? null : json["Device_Name"],
    deviceId: json["Device_ID"] == null ? null : json["Device_ID"],
    emailId: json["Email_ID"] == null ? null : json["Email_ID"],
    supAdmin: json["supAdmin"] == null ? null : json["supAdmin"],
    dealer: json["Dealer"] == null ? null : json["Dealer"],
    token: json["token"] == null ? null : json["token"],
    typeOfDevice: json["type_of_device"] == null ? null : json["type_of_device"],
    simNumber: json["sim_number"] == null ? null : json["sim_number"],
    user: json["user"] == null ? null : json["user"],
    speedAlert: json["SpeedAlert"] == null ? null : json["SpeedAlert"],
    deviceModel: json["device_model"] == null ? null : json["device_model"],
    expirationDate: json["expiration_date"] == null ? null : DateTime.parse(json["expiration_date"]),
    vehicleType: json["vehicleType"] == null ? null : json["vehicleType"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    speedLimit: json["SpeedLimit"] == null ? null : json["SpeedLimit"],
    distanceVariation: json["distanceVariation"] == null ? null : json["distanceVariation"],
    mileage: json["Mileage"] == null ? null : json["Mileage"],
    speedChart: json["speedChart"] == null ? null : Map.from(json["speedChart"]).map((k, v) => MapEntry<String, int>(k, v)),
    doMap: json["doMap"] == null ? null : DoMap.fromJson(json["doMap"]),
    dIMap: json["dIMap"] == null ? null : DIMap.fromJson(json["dIMap"]),
    sos: json["sos"] == null ? null : json["sos"],
    capacity: json["capacity"] == null ? null : json["capacity"],
    tripType: json["tripType"] == null ? null : json["tripType"],
    todayTrips: json["today_trips"] == null ? null : json["today_trips"],
    todayMaxspeed: json["today_maxspeed"] == null ? null : json["today_maxspeed"],
    todayRouteViolations: json["today_routeViolations"] == null ? null : json["today_routeViolations"],
    todayOverspeeds: json["today_overspeeds"] == null ? null : json["today_overspeeds"],
    overspeeding: json["overspeeding"] == null ? null : json["overspeeding"],
    sosTo: json["sosTo"] == null ? null : List<dynamic>.from(json["sosTo"].map((x) => x)),
    ignitionSource: json["ignitionSource"] == null ? null : json["ignitionSource"],
    deviceImage: json["deviceImage"] == null ? null : List<dynamic>.from(json["deviceImage"].map((x) => x)),
    accountSuspended: json["accountSuspended"] == null ? null : json["accountSuspended"],
    license: json["License"] == null ? null : json["License"],
    active: json["active"] == null ? null : json["active"],
    arm: json["arm"] == null ? null : json["arm"],
    ignitionLock: json["ignitionLock"] == null ? null : json["ignitionLock"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
    engineStatus: json["engine_status"] == null ? null : json["engine_status"],
    currentTripStatus: json["currentTripStatus"] == null ? null : json["currentTripStatus"],
    imageDoc: json["imageDoc"] == null ? null : List<dynamic>.from(json["imageDoc"].map((x) => x)),
    fuelMeasurement: json["fuelMeasurement"] == null ? null : json["fuelMeasurement"],
    snaps: json["snaps"] == null ? null : List<dynamic>.from(json["snaps"].map((x) => x)),
    fuelUnit: json["fuel_unit"] == null ? null : json["fuel_unit"],
    maxStoppageAlerted: json["maxStoppageAlerted"] == null ? null : json["maxStoppageAlerted"],
    maxStoppageAlert: json["maxStoppageAlert"] == null ? null : json["maxStoppageAlert"],
    status: json["status"] == null ? null : json["status"],
    maxSpeed: json["maxSpeed"] == null ? null : json["maxSpeed"],
    tripCount: json["tripCount"] == null ? null : json["tripCount"],
    totalOdo: json["total_odo"] == null ? null : json["total_odo"].toDouble(),
    todayOdo: json["today_odo"] == null ? null : json["today_odo"].toDouble(),
    lastLoc: json["last_loc"] == null ? null : LastLoc.fromJson(json["last_loc"]),
    iconType: json["iconType"] == null ? null : json["iconType"],
    shared: json["Shared"] == null ? null : List<dynamic>.from(json["Shared"].map((x) => x)),
    overIdleLimit: json["overIdleLimit"] == null ? null : json["overIdleLimit"],
    overStoppedLimit: json["overStoppedLimit"] == null ? null : json["overStoppedLimit"],
    towAlert: json["towAlert"] == null ? null : json["towAlert"],
    theftAlert: json["theftAlert"] == null ? null : json["theftAlert"],
    maintenance: json["maintenance"] == null ? null : json["maintenance"],
    hardWare: json["HardWare"] == null ? null : json["HardWare"],
    v: json["__v"] == null ? null : json["__v"],
    ac: json["ac"],
    battery: json["battery"] == null ? null : json["battery"],
    currentFuel: json["currentFuel"] == null ? null : json["currentFuel"].toDouble(),
    currentFuelVoltage: json["currentFuelVoltage"] == null ? null : json["currentFuelVoltage"],
    distFromLastStop: json["distFromLastStop"] == null ? null : json["distFromLastStop"].toDouble(),
    fuelPercent: json["fuel_percent"] == null ? null : json["fuel_percent"],
    gpsTracking: json["gpsTracking"] == null ? null : json["gpsTracking"],
    gsmSignal: json["gsmSignal"] == null ? null : json["gsmSignal"],
    heading: json["heading"] == null ? null : json["heading"],
    ip: json["ip"] == null ? null : json["ip"],
    lastAcc: json["last_ACC"] == null ? null : json["last_ACC"],
    lastAccChangeOn: json["last_ACC_change_on"] == null ? null : DateTime.parse(json["last_ACC_change_on"]),
    lastAccOn: json["last_ACC_on"] == null ? null : DateTime.parse(json["last_ACC_on"]),
    lastDeviceTime: json["last_device_time"] == null ? null : DateTime.parse(json["last_device_time"]),
    lastLocation: json["last_location"] == null ? null : Location.fromJson(json["last_location"]),
    lastPingOn: json["last_ping_on"] == null ? null : DateTime.parse(json["last_ping_on"]),
    lastSpeed: json["last_speed"] == null ? null : json["last_speed"],
    lastSpeedZeroAt: json["last_speed_zero_at"] == null ? null : DateTime.parse(json["last_speed_zero_at"]),
    port: json["port"] == null ? null : json["port"],
    power: json["power"] == null ? null : json["power"],
    satellites: json["satellites"],
    secLastLocation: json["sec_last_location"] == null ? null : Location.fromJson(json["sec_last_location"]),
    secLastSpeed: json["sec_last_speed"] == null ? null : json["sec_last_speed"],
    todayStartLocation: json["today_start_location"] == null ? null : Location.fromJson(json["today_start_location"]),
    currentRoute: json["currentRoute"],
    lastStoppedAt: json["lastStoppedAt"] == null ? null : DateTime.parse(json["lastStoppedAt"]),
    statusUpdatedAt: json["status_updated_at"] == null ? null : DateTime.parse(json["status_updated_at"]),
    lastIgnChangeAt: json["lastIgnChangeAt"] == null ? null : DateTime.parse(json["lastIgnChangeAt"]),
    todayIgnOff: json["today_ign_off"] == null ? null : json["today_ign_off"],
    todayStopped: json["today_stopped"] == null ? null : json["today_stopped"],
    currentToll: json["currentToll"],
    currentTollName: json["currentTollName"],
    currentPoi: json["currentPOI"],
    currentPoiName: json["currentPOIName"],
    sb3CurrentPoi: json["sb3CurrentPOI"],
    lastIdleAt: json["last_idle_at"] == null ? null : DateTime.parse(json["last_idle_at"]),
    timeAtLastStop: json["timeAtLastStop"] == null ? null : json["timeAtLastStop"],
    todayIgnOn: json["today_ign_on"] == null ? null : json["today_ign_on"],
    tIdling: json["t_idling"] == null ? null : json["t_idling"],
    timezone: json["timezone"] == null ? null : json["timezone"],
    todayRunning: json["today_running"] == null ? null : json["today_running"],
    tNoGps: json["t_noGps"] == null ? null : json["t_noGps"],
    tOfr: json["t_ofr"] == null ? null : json["t_ofr"],
    tRunning: json["t_running"] == null ? null : json["t_running"],
    tStopped: json["t_stopped"] == null ? null : json["t_stopped"],
    lastOverspeedTime: json["last_overspeed_time"] == null ? null : DateTime.parse(json["last_overspeed_time"]),
    lastOverStoppedAlertOn: json["lastOverStoppedAlertOn"] == null ? null : DateTime.parse(json["lastOverStoppedAlertOn"]),
    lastOverIdleAlertOn: json["lastOverIdleAlertOn"] == null ? null : DateTime.parse(json["lastOverIdleAlertOn"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "Device_Name": deviceName == null ? null : deviceName,
    "Device_ID": deviceId == null ? null : deviceId,
    "Email_ID": emailId == null ? null : emailId,
    "supAdmin": supAdmin == null ? null : supAdmin,
    "Dealer": dealer == null ? null : dealer,
    "token": token == null ? null : token,
    "type_of_device": typeOfDevice == null ? null : typeOfDevice,
    "sim_number": simNumber == null ? null : simNumber,
    "user": user == null ? null : user,
    "SpeedAlert": speedAlert == null ? null : speedAlert,
    "device_model": deviceModel == null ? null : deviceModel,
    "expiration_date": expirationDate == null ? null : expirationDate.toIso8601String(),
    "vehicleType": vehicleType == null ? null : vehicleType,
    "created_by": createdBy == null ? null : createdBy,
    "SpeedLimit": speedLimit == null ? null : speedLimit,
    "distanceVariation": distanceVariation == null ? null : distanceVariation,
    "Mileage": mileage == null ? null : mileage,
    "speedChart": speedChart == null ? null : Map.from(speedChart).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "doMap": doMap == null ? null : doMap.toJson(),
    "dIMap": dIMap == null ? null : dIMap.toJson(),
    "sos": sos == null ? null : sos,
    "capacity": capacity == null ? null : capacity,
    "tripType": tripType == null ? null : tripType,
    "today_trips": todayTrips == null ? null : todayTrips,
    "today_maxspeed": todayMaxspeed == null ? null : todayMaxspeed,
    "today_routeViolations": todayRouteViolations == null ? null : todayRouteViolations,
    "today_overspeeds": todayOverspeeds == null ? null : todayOverspeeds,
    "overspeeding": overspeeding == null ? null : overspeeding,
    "sosTo": sosTo == null ? null : List<dynamic>.from(sosTo.map((x) => x)),
    "ignitionSource": ignitionSource == null ? null : ignitionSource,
    "deviceImage": deviceImage == null ? null : List<dynamic>.from(deviceImage.map((x) => x)),
    "accountSuspended": accountSuspended == null ? null : accountSuspended,
    "License": license == null ? null : license,
    "active": active == null ? null : active,
    "arm": arm == null ? null : arm,
    "ignitionLock": ignitionLock == null ? null : ignitionLock,
    "created_on": createdOn == null ? null : createdOn.toIso8601String(),
    "engine_status": engineStatus == null ? null : engineStatus,
    "currentTripStatus": currentTripStatus == null ? null : currentTripStatus,
    "imageDoc": imageDoc == null ? null : List<dynamic>.from(imageDoc.map((x) => x)),
    "fuelMeasurement": fuelMeasurement == null ? null : fuelMeasurement,
    "snaps": snaps == null ? null : List<dynamic>.from(snaps.map((x) => x)),
    "fuel_unit": fuelUnit == null ? null : fuelUnit,
    "maxStoppageAlerted": maxStoppageAlerted == null ? null : maxStoppageAlerted,
    "maxStoppageAlert": maxStoppageAlert == null ? null : maxStoppageAlert,
    "status": status == null ? null : status,
    "maxSpeed": maxSpeed == null ? null : maxSpeed,
    "tripCount": tripCount == null ? null : tripCount,
    "total_odo": totalOdo == null ? null : totalOdo,
    "today_odo": todayOdo == null ? null : todayOdo,
    "last_loc": lastLoc == null ? null : lastLoc.toJson(),
    "iconType": iconType == null ? null : iconType,
    "Shared": shared == null ? null : List<dynamic>.from(shared.map((x) => x)),
    "overIdleLimit": overIdleLimit == null ? null : overIdleLimit,
    "overStoppedLimit": overStoppedLimit == null ? null : overStoppedLimit,
    "towAlert": towAlert == null ? null : towAlert,
    "theftAlert": theftAlert == null ? null : theftAlert,
    "maintenance": maintenance == null ? null : maintenance,
    "HardWare": hardWare == null ? null : hardWare,
    "__v": v == null ? null : v,
    "ac": ac,
    "battery": battery == null ? null : battery,
    "currentFuel": currentFuel == null ? null : currentFuel,
    "currentFuelVoltage": currentFuelVoltage == null ? null : currentFuelVoltage,
    "distFromLastStop": distFromLastStop == null ? null : distFromLastStop,
    "fuel_percent": fuelPercent == null ? null : fuelPercent,
    "gpsTracking": gpsTracking == null ? null : gpsTracking,
    "gsmSignal": gsmSignal == null ? null : gsmSignal,
    "heading": heading == null ? null : heading,
    "ip": ip == null ? null : ip,
    "last_ACC": lastAcc == null ? null : lastAcc,
    "last_ACC_change_on": lastAccChangeOn == null ? null : lastAccChangeOn.toIso8601String(),
    "last_ACC_on": lastAccOn == null ? null : lastAccOn.toIso8601String(),
    "last_device_time": lastDeviceTime == null ? null : lastDeviceTime.toIso8601String(),
    "last_location": lastLocation == null ? null : lastLocation.toJson(),
    "last_ping_on": lastPingOn == null ? null : lastPingOn.toIso8601String(),
    "last_speed": lastSpeed == null ? null : lastSpeed,
    "last_speed_zero_at": lastSpeedZeroAt == null ? null : lastSpeedZeroAt.toIso8601String(),
    "port": port == null ? null : port,
    "power": power == null ? null : power,
    "satellites": satellites,
    "sec_last_location": secLastLocation == null ? null : secLastLocation.toJson(),
    "sec_last_speed": secLastSpeed == null ? null : secLastSpeed,
    "today_start_location": todayStartLocation == null ? null : todayStartLocation.toJson(),
    "currentRoute": currentRoute,
    "lastStoppedAt": lastStoppedAt == null ? null : lastStoppedAt.toIso8601String(),
    "status_updated_at": statusUpdatedAt == null ? null : statusUpdatedAt.toIso8601String(),
    "lastIgnChangeAt": lastIgnChangeAt == null ? null : lastIgnChangeAt.toIso8601String(),
    "today_ign_off": todayIgnOff == null ? null : todayIgnOff,
    "today_stopped": todayStopped == null ? null : todayStopped,
    "currentToll": currentToll,
    "currentTollName": currentTollName,
    "currentPOI": currentPoi,
    "currentPOIName": currentPoiName,
    "sb3CurrentPOI": sb3CurrentPoi,
    "last_idle_at": lastIdleAt == null ? null : lastIdleAt.toIso8601String(),
    "timeAtLastStop": timeAtLastStop == null ? null : timeAtLastStop,
    "today_ign_on": todayIgnOn == null ? null : todayIgnOn,
    "t_idling": tIdling == null ? null : tIdling,
    "timezone": timezone == null ? null : timezone,
    "today_running": todayRunning == null ? null : todayRunning,
    "t_noGps": tNoGps == null ? null : tNoGps,
    "t_ofr": tOfr == null ? null : tOfr,
    "t_running": tRunning == null ? null : tRunning,
    "t_stopped": tStopped == null ? null : tStopped,
    "last_overspeed_time": lastOverspeedTime == null ? null : lastOverspeedTime.toIso8601String(),
    "lastOverStoppedAlertOn": lastOverStoppedAlertOn == null ? null : lastOverStoppedAlertOn.toIso8601String(),
    "lastOverIdleAlertOn": lastOverIdleAlertOn == null ? null : lastOverIdleAlertOn.toIso8601String(),
  };
}

class DIMap {
  DIMap({
    this.di3,
    this.di2,
    this.di1,
  });

  String di3;
  String di2;
  String di1;

  factory DIMap.fromJson(Map<String, dynamic> json) => DIMap(
    di3: json["di3"] == null ? null : json["di3"],
    di2: json["di2"] == null ? null : json["di2"],
    di1: json["di1"] == null ? null : json["di1"],
  );

  Map<String, dynamic> toJson() => {
    "di3": di3 == null ? null : di3,
    "di2": di2 == null ? null : di2,
    "di1": di1 == null ? null : di1,
  };
}

class DoMap {
  DoMap({
    this.ignitionLock,
  });

  String ignitionLock;

  factory DoMap.fromJson(Map<String, dynamic> json) => DoMap(
    ignitionLock: json["ignitionLock"] == null ? null : json["ignitionLock"],
  );

  Map<String, dynamic> toJson() => {
    "ignitionLock": ignitionLock == null ? null : ignitionLock,
  };
}

class LastLoc {
  LastLoc({
    this.coordinates,
    this.type,
  });

  List<double> coordinates;
  String type;

  factory LastLoc.fromJson(Map<String, dynamic> json) => LastLoc(
    coordinates: json["coordinates"] == null ? null : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": coordinates == null ? null : List<dynamic>.from(coordinates.map((x) => x)),
    "type": type == null ? null : type,
  };
}

class Location {
  Location({
    this.lat,
    this.long,
  });

  double lat;
  double long;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    long: json["long"] == null ? null : json["long"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
  };
}
