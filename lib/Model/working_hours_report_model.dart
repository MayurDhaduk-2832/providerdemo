// To parse this JSON data, do
//
//     final workingHoursReportModel = workingHoursReportModelFromJson(jsonString);

import 'dart:convert';

List<WorkingHoursReportModel> workingHoursReportModelFromJson(String str) => List<WorkingHoursReportModel>.from(json.decode(str).map((x) => WorkingHoursReportModel.fromJson(x)));

String workingHoursReportModelToJson(List<WorkingHoursReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkingHoursReportModel {
  WorkingHoursReportModel({
    this.deviceName,
    this.workingHours,
    this.stopHours,
    this.ign,
  });

  String deviceName;
  String workingHours;
  String stopHours;
  List<Ign> ign;

  factory WorkingHoursReportModel.fromJson(Map<String, dynamic> json) => WorkingHoursReportModel(
    deviceName: json["deviceName"],
    workingHours: json["workingHours"],
    stopHours: json["stopHours"],
    ign: List<Ign>.from(json["ign"].map((x) => Ign.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "deviceName": deviceName,
    "workingHours": workingHours,
    "stopHours": stopHours,
    "ign": List<dynamic>.from(ign.map((x) => x.toJson())),
  };
}

class Ign {
  Ign({
    this.id,
    this.device,
    this.long,
    this.lat,
    this.ignSwitch,
    this.vehicleName,
    this.timestamp,
  });

  String id;
  Device device;
  double long;
  double lat;
  String ignSwitch;
  String vehicleName;
  DateTime timestamp;

  factory Ign.fromJson(Map<String, dynamic> json) => Ign(
    id: json["_id"],
    device: Device.fromJson(json["device"]),
    long: json["long"].toDouble(),
    lat: json["lat"].toDouble(),
    ignSwitch: json["switch"],
    vehicleName: json["vehicleName"],
    timestamp: DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "device": device.toJson(),
    "long": long,
    "lat": lat,
    "switch": ignSwitch,
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
