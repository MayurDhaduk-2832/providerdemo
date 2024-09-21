// To parse this JSON data, do
//
//     final getdaywiseReportModel = getdaywiseReportModelFromJson(jsonString);

import 'dart:convert';

List<GetdaywiseReportModel> getdaywiseReportModelFromJson(String str) => List<GetdaywiseReportModel>.from(json.decode(str).map((x) => GetdaywiseReportModel.fromJson(x)));

String getdaywiseReportModelToJson(List<GetdaywiseReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetdaywiseReportModel {
  GetdaywiseReportModel({
    this.date,
    this.vrn,
    this.deviceId,
    this.startLocation,
    this.endLocation,
    this.distanceKms,
    this.movingTime,
    this.stoppageTime,
    this.idleTime,
  });

  DateTime date;
  String vrn;
  String deviceId;
  Location startLocation;
  Location endLocation;
  double distanceKms;
  double movingTime;
  double stoppageTime;
  int idleTime;

  factory GetdaywiseReportModel.fromJson(Map<String, dynamic> json) => GetdaywiseReportModel(
    date: DateTime.parse(json["Date"]),
    vrn: json["VRN"],
    deviceId: json["Device_ID"],
    startLocation: Location.fromJson(json["start_location"]),
    endLocation: Location.fromJson(json["end_location"]),
    distanceKms: json["Distance(Kms)"].toDouble(),
    movingTime: json["Moving Time"].toDouble(),
    stoppageTime: json["Stoppage Time"].toDouble(),
    idleTime: json["Idle Time"],
  );

  Map<String, dynamic> toJson() => {
    "Date": date.toIso8601String(),
    "VRN": vrn,
    "Device_ID": deviceId,
    "start_location": startLocation.toJson(),
    "end_location": endLocation.toJson(),
    "Distance(Kms)": distanceKms,
    "Moving Time": movingTime,
    "Stoppage Time": stoppageTime,
    "Idle Time": idleTime,
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
    lat: json["lat"].toDouble(),
    long: json["long"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "long": long,
  };
}
