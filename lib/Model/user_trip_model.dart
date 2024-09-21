import 'dart:convert';

List<UserTripDetailModel> userTripDetailModelFromJson(String str) => List<UserTripDetailModel>.from(json.decode(str).map((x) => UserTripDetailModel.fromJson(x)));

class UserTripDetailModel {
  UserTripDetailModel({
    this.id,
    this.user,
    this.device,
    this.startTime,
    this.endTime,
    this.startLat,
    this.startLong,
    this.endLat,
    this.endLong,
    this.distance,
    this.createdOn,
  });

  String id;
  String user;
  Device device;
  DateTime startTime;
  DateTime endTime;
  String startLat;
  String startLong;
  String endLat;
  String endLong;
  double distance;
  DateTime createdOn;

  factory UserTripDetailModel.fromJson(Map<String, dynamic> json) => UserTripDetailModel(
    id: json["_id"] == null ? null : json["_id"],
    user: json["user"] == null ? null : json["user"],
    device: json["device"] == null ? null : Device.fromJson(json["device"]),
    startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    startLat: json["start_lat"] == null ? null : json["start_lat"],
    startLong: json["start_long"] == null ? null : json["start_long"],
    endLat: json["end_lat"] == null ? null : json["end_lat"],
    endLong: json["end_long"] == null ? null : json["end_long"],
    distance: json["distance"] == null ? null : json["distance"].toDouble(),
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
  );

}

class Device {
  Device({
    this.id,
    this.deviceName,
  });

  String id;
  String deviceName;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json["_id"] == null ? null : json["_id"],
    deviceName: json["Device_Name"] == null ? null : json["Device_Name"],
  );

}
