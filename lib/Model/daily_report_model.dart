// To parse this JSON data, do
//
//     final dailyReportModel = dailyReportModelFromJson(jsonString);

import 'dart:convert';

DailyReportModel dailyReportModelFromJson(String str) => DailyReportModel.fromJson(json.decode(str));


class DailyReportModel {
  DailyReportModel({
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  int draw;
  int recordsTotal;
  int recordsFiltered;
  List<DailyReportList> data;

  factory DailyReportModel.fromJson(Map<String, dynamic> json) => DailyReportModel(
    draw: json["draw"] == null ? null : json["draw"],
    recordsTotal: json["recordsTotal"] == null ? null : json["recordsTotal"],
    recordsFiltered: json["recordsFiltered"] == null ? null : json["recordsFiltered"],
    data: json["data"] == null ? null : List<DailyReportList>.from(json["data"].map((x) => DailyReportList.fromJson(x))),
  );

}

class DailyReportList {
  DailyReportList({
    this.id,
    this.deviceName,
    this.deviceId,
    this.distanceVariation,
    this.todayTrips,
    this.maxSpeed,
    this.todayOdo,
    this.lastLocation,
    this.todayStartLocation,
    this.tIdling,
    this.todayStopped,
    this.todayRunning,
    this.tNoGps,
    this.tOfr,
    this.mileage,
    this.avgSpeed,
    this.devObj,
    this.totalOdo,
  });

  String id;
  String deviceName;
  String deviceId;
  String distanceVariation;
  int todayTrips;
  int maxSpeed;
  double todayOdo;
  double totalOdo;
  double avgSpeed;
  TLocation lastLocation;
  TLocation todayStartLocation;
  dynamic tIdling;
  dynamic todayStopped;
  int todayRunning;
  int tNoGps;
  dynamic tOfr;
  String mileage;
  DevObj devObj;

  factory DailyReportList.fromJson(Map<String, dynamic> json) => DailyReportList(
    id: json["_id"] == null ? null : json["_id"],
    deviceName: json["Device_Name"] == null ? null : json["Device_Name"],
    deviceId: json["Device_ID"] == null ? null : json["Device_ID"],
    distanceVariation: json["distanceVariation"] == null ? null : json["distanceVariation"],
    todayTrips: json["today_trips"] == null ? null : json["today_trips"],
    maxSpeed: json["maxSpeed"] == null ? null : json["maxSpeed"],
    todayOdo: json["today_odo"] == null ? 0.0 : json["today_odo"].toDouble(),
    totalOdo: json["total_odo"] == null ? 0.0 : json["total_odo"].toDouble(),
    avgSpeed: json["avgSpeed"] == null ? 0.0 : json["avgSpeed"].toDouble(),
    lastLocation: json["last_location"] == null ? null : TLocation.fromJson(json["last_location"]),
    devObj: json["devObj"] == null ? null : DevObj.fromJson(json["devObj"]),
    todayStartLocation: json["today_start_location"] == null ? null : TLocation.fromJson(json["today_start_location"]),
    tIdling: json["t_idling"] == null ? null : json["t_idling"],
    todayStopped: json["today_stopped"] == null ? null : json["today_stopped"],
    todayRunning: json["today_running"] == 0 ? null : json["today_running"],
    tNoGps: json["t_noGps"] == null ? null : json["t_noGps"],
    tOfr: json["t_ofr"] == null ? null : json["t_ofr"],
    mileage: json["Mileage"] == null ? "0"  : json["Mileage"],
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

class DevObj {
  DevObj({
    this.Mileage,
  });

  String Mileage;

  factory DevObj.fromJson(Map<String, dynamic> json) => DevObj(
    Mileage: json["Mileage"] == null ? "0" : json["Mileage"],
  );

}
