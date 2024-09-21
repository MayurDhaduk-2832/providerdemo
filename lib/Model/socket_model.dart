// To parse this JSON data, do
//
//     final socketModel = socketModelFromJson(jsonString);

import 'dart:convert';

List<dynamic> socketModelFromJson(String str) => List<dynamic>.from(json.decode(str).map((x) => x));


class SocketModelClass {
  SocketModelClass({
    this.id,
    this.deviceName,
    this.expirationDate,
    this.door,
    this.gpsTracking,
    this.lastAcc,
    this.lastPingOn,
    this.power,
    this.statusUpdatedAt,
    this.ac,
    this.distFromLastStop,
    this.fuelPercent,
    this.heading,
    this.lastDeviceTime,
    this.lastSpeed,
    this.lastSpeedZeroAt,
    this.license,
    this.active,
    this.arm,
    this.ignitionLock,
    this.createdOn,
    this.fuelUnit,
    this.status,
    this.totalOdo,
    this.todayOdo,
    this.lastLocation,
    this.iconType,
    this.temp,
  });

  String id;
  String deviceName;
  DateTime expirationDate;
  String door;
  String gpsTracking;
  String lastAcc;
  DateTime lastPingOn;
  String power;
  String temp;
  DateTime statusUpdatedAt;
  dynamic ac;
  dynamic fuelPercent;
  double distFromLastStop;
  String heading;
  DateTime lastDeviceTime;
  String lastSpeed;
  DateTime lastSpeedZeroAt;
  String license;
  bool active;
  String arm;
  String ignitionLock;
  DateTime createdOn;
  String fuelUnit;
  String status;
  double totalOdo;
  double todayOdo;
  TLocation lastLocation;
  String iconType;

  factory SocketModelClass.fromJson(Map<String, dynamic> json) => SocketModelClass(
    id: json["_id"] == null ? null : json["_id"],
    deviceName: json["Device_Name"] == null ? "" : json["Device_Name"],
    temp: json["temp"] == null ? "" : json["temp"],
    expirationDate: json["expiration_date"] == null ? DateTime.now() : DateTime.parse(json["expiration_date"]),
    door: json["door"] == null ? "" : json["door"],
    gpsTracking: json["gpsTracking"] == null ? "" : json["gpsTracking"],
    lastAcc: json["last_ACC"] == null ? "" : json["last_ACC"],
     lastPingOn: json["last_ping_on"] == null ? DateTime.now() : DateTime.parse(json["last_ping_on"]),
    power: json["power"] == null ? "" : json["power"],
    statusUpdatedAt: json["status_updated_at"] == null ? DateTime.now() : DateTime.parse(json["status_updated_at"]),
    ac: json["ac"] == null ?null : json["ac"],
    distFromLastStop: json["distFromLastStop"] == null ? null : json["distFromLastStop"].toDouble(),
    fuelPercent: json["fuel_percent"] == null ? null : json["fuel_percent"],
    heading: json["heading"] == null ? null : json["heading"],
    lastDeviceTime: json["last_device_time"] == null ? null : DateTime.parse(json["last_device_time"]),
    lastSpeed: json["last_speed"] == null ? null : json["last_speed"],
    lastSpeedZeroAt: json["last_speed_zero_at"] == null ? null : DateTime.parse(json["last_speed_zero_at"]),
   license: json["License"] == null ? null : json["License"],
    active: json["active"] == null ? null : json["active"],
    arm: json["arm"] == null ? null : json["arm"],
    ignitionLock: json["ignitionLock"] == null ? null : json["ignitionLock"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
     fuelUnit: json["fuel_unit"] == null ? "" : json["fuel_unit"],
    status: json["status"] == null ? "" : json["status"],
    totalOdo: json["total_odo"] == null ? null : json["total_odo"].toDouble(),
    todayOdo: json["today_odo"] == null ? 0 : json["today_odo"].toDouble(),
    lastLocation: json["last_location"] == null ? null : TLocation.fromJson(json["last_location"]),
    iconType: json["iconType"] == null ? null : json["iconType"],
  );
}


class TLocation {
  TLocation({
    this.lat,
    this.long,
  });

  double lat;
  double long;

  factory TLocation.fromJson(Map<String, dynamic> json) => TLocation(
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    long: json["long"] == null ? null : json["long"].toDouble(),
  );

}
