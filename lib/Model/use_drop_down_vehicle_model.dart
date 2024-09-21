import 'dart:convert';

UserVehicleDropModel userVehicleDropModelFromJson(String str) => UserVehicleDropModel.fromJson(json.decode(str));


class UserVehicleDropModel {
  UserVehicleDropModel({
    this.devices,
  });

  List<VehicleList> devices;

  factory UserVehicleDropModel.fromJson(Map<String, dynamic> json) => UserVehicleDropModel(
    devices: json["devices"] == null ? [] : List<VehicleList>.from(json["devices"].map((x) => VehicleList.fromJson(x))),
  );

}

class VehicleList {
  VehicleList({
    this.id,
    this.deviceName,
    this.deviceId,
    this.user,
    this.distanceVariation,
    this.totalOdo,
    this.iconType,
    this.groupName,
  });

  String id;
  String deviceName;
  String deviceId;
  String user;
  String distanceVariation;
  double totalOdo;
  String iconType;
  String groupName;

  factory VehicleList.fromJson(Map<String, dynamic> json) => VehicleList(
    id: json["_id"] == null ? null : json["_id"],
    deviceName: json["Device_Name"] == null ? null : json["Device_Name"],
    deviceId: json["Device_ID"] == null ? null : json["Device_ID"],
    user: json["user"] == null ? null : json["user"],
    distanceVariation: json["distanceVariation"] == null ? null : json["distanceVariation"],
    totalOdo: json["total_odo"] == null ? null : json["total_odo"].toDouble(),
    iconType: json["iconType"] == null ? null : json["iconType"],
    groupName: json["groupName"] == null ? null : json["groupName"],
  );

}