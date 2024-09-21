// To parse this JSON data, do
//
//     final idleReportModel = idleReportModelFromJson(jsonString);

import 'dart:convert';

IdleReportModel idleReportModelFromJson(String str) => IdleReportModel.fromJson(json.decode(str));

String idleReportModelToJson(IdleReportModel data) => json.encode(data.toJson());

class IdleReportModel {
  IdleReportModel({
    this.data,
  });

  List<IdleReportList> data;

  factory IdleReportModel.fromJson(Map<String, dynamic> json) => IdleReportModel(
    data: List<IdleReportList>.from(json["data"].map((x) => IdleReportList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class IdleReportList {
  IdleReportList({
    this.idleLocation,
    this.id,
    this.user,
    this.device,
    this.startTime,
    this.endTime,
    this.long,
    this.acStatus,
    this.idleTime,
    this.lat,
    this.v,
    this.address,
  });

  IdleLocation idleLocation;
  String id;
  String user;
  Device device;
  DateTime startTime;
  DateTime endTime;
  String long;
  dynamic acStatus;
  int idleTime;
  String lat;
  int v;
  String address;

  factory IdleReportList.fromJson(Map<String, dynamic> json) => IdleReportList(
    idleLocation: IdleLocation.fromJson(json["idle_location"]),
    id: json["_id"],
    user: json["user"],
    device: Device.fromJson(json["device"]),
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    long: json["long"],
    acStatus: json["ac_status"],
    idleTime: json["idle_time"],
    lat: json["lat"],
    v: json["__v"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "idle_location": idleLocation.toJson(),
    "_id": id,
    "user": user,
    "device": device.toJson(),
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "long": long,
    "ac_status": acStatus,
    "idle_time": idleTime,
    "lat": lat,
    "__v": v,
    "address": address,
  };
}

class Device {
  Device({
    this.id,
    this.deviceName,
  });

  String id;
  String deviceName;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json["_id"],
    deviceName: json["Device_Name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "Device_Name": deviceName,
  };
}

class IdleLocation {
  IdleLocation({
    this.long,
    this.lat,
  });

  double long;
  double lat;

  factory IdleLocation.fromJson(Map<String, dynamic> json) => IdleLocation(
    long: json["long"].toDouble(),
    lat: json["lat"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "long": long,
    "lat": lat,
  };
}
