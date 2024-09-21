// To parse this JSON data, do
//
//     final sosReportModel = sosReportModelFromJson(jsonString);

import 'dart:convert';

List<SosReportModel> sosReportModelFromJson(String str) => List<SosReportModel>.from(json.decode(str).map((x) => SosReportModel.fromJson(x)));

String sosReportModelToJson(List<SosReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SosReportModel {
  SosReportModel({
    this.id,
    this.device,
    this.long,
    this.lat,
    this.vehicleName,
    this.timestamp,
  });

  String id;
  Device device;
  double long;
  double lat;
  String vehicleName;
  DateTime timestamp;

  factory SosReportModel.fromJson(Map<String, dynamic> json) => SosReportModel(
    id: json["_id"] == null ? null : json["_id"],
    device: json["device"] == null ? null : Device.fromJson(json["device"]),
    long: json["long"] == null ? null : json["long"].toDouble(),
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    vehicleName: json["vehicleName"] == null ? null : json["vehicleName"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "device": device == null ? null : device.toJson(),
    "long": long == null ? null : long,
    "lat": lat == null ? null : lat,
    "vehicleName": vehicleName == null ? null : vehicleName,
    "timestamp": timestamp == null ? null : timestamp.toIso8601String(),
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
    iconType: json["iconType"] == null ? null : json["iconType"],
    lastAcc: json["last_ACC"] == null ? null : json["last_ACC"],
  );

  Map<String, dynamic> toJson() => {
    "iconType": iconType == null ? null : iconType,
    "last_ACC": lastAcc == null ? null : lastAcc,
  };
 }
