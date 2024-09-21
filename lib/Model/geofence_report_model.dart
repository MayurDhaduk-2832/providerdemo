// To parse this JSON data, do
//
//     final geofencingReportModel = geofencingReportModelFromJson(jsonString);

import 'dart:convert';

GeofencingReportModel geofencingReportModelFromJson(String str) => GeofencingReportModel.fromJson(json.decode(str));

String geofencingReportModelToJson(GeofencingReportModel data) => json.encode(data.toJson());

class GeofencingReportModel {
  GeofencingReportModel({
    this.data,
  });

  List<GeofenceReportDetails> data;

  factory GeofencingReportModel.fromJson(Map<String, dynamic> json) => GeofencingReportModel(
    data: List<GeofenceReportDetails>.from(json["data"].map((x) => GeofenceReportDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GeofenceReportDetails {
  GeofenceReportDetails({
    this.id,
    this.device,
    this.direction,
    this.geoid,
    this.lat,
    this.long,
    this.vehicleName,
    this.timestamp,
  });

  String id;
  Device device;
  String direction;
  Geoid geoid;
  double lat;
  double long;
  String vehicleName;
  DateTime timestamp;

  factory GeofenceReportDetails.fromJson(Map<String, dynamic> json) => GeofenceReportDetails(
    id: json["_id"],
    device: Device.fromJson(json["device"]),
    direction: json["direction"],
    geoid: Geoid.fromJson(json["geoid"]),
    lat: json["lat"].toDouble(),
    long: json["long"].toDouble(),
    vehicleName: json["vehicleName"],
    timestamp: DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "device": device.toJson(),
    "direction": direction,
    "geoid": geoid.toJson(),
    "lat": lat,
    "long": long,
    "vehicleName": vehicleName,
    "timestamp": timestamp.toIso8601String(),
  };
}

class Device {
  Device({
    this.iconType,
    this.lastAcc,
  });

  String iconType;
  String lastAcc;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    iconType: json["iconType"],
    lastAcc: json["last_ACC"],
  );

  Map<String, dynamic> toJson() => {
    "iconType": iconType,
    "last_ACC": lastAcc,
  };
}

class Geoid {
  Geoid({
    this.geoname,
  });

  String geoname;

  factory Geoid.fromJson(Map<String, dynamic> json) => Geoid(
    geoname: json["geoname"],
  );

  Map<String, dynamic> toJson() => {
    "geoname": geoname,
  };
}
