// To parse this JSON data, do
//
//     final getGroupListModel = getGroupListModelFromJson(jsonString);

import 'dart:convert';

GetGroupListModel getGroupListModelFromJson(String str) => GetGroupListModel.fromJson(json.decode(str));

String getGroupListModelToJson(GetGroupListModel data) => json.encode(data.toJson());

class GetGroupListModel {
  GetGroupListModel({
    this.groupDetails,
    this.noOfVehicles,
  });

  List<GroupDetail> groupDetails;
  int noOfVehicles;

  factory GetGroupListModel.fromJson(Map<String, dynamic> json) => GetGroupListModel(
    groupDetails: List<GroupDetail>.from(json["group_details"].map((x) => GroupDetail.fromJson(x))),
    noOfVehicles: json["no_of_vehicles"],
  );

  Map<String, dynamic> toJson() => {
    "group_details": List<dynamic>.from(groupDetails.map((x) => x.toJson())),
    "no_of_vehicles": noOfVehicles,
  };
}

class GroupDetail {
  GroupDetail({
    this.id,
    this.name,
    this.status,
    this.logoPath,
    this.user,
    this.createdBy,
    this.address,
    this.contactNo,
    this.v,
    this.contactEmail,
    this.lastModified,
    this.dev,
    this.geofence,
    this.vehicles,
    this.devices,
  });

  String id;
  String name;
  bool status;
  String logoPath;
  String user;
  String createdBy;
  String address;
  int contactNo;
  int v;
  List<dynamic> contactEmail;
  DateTime lastModified;
  List<dynamic> dev;
  List<dynamic> geofence;
  List<dynamic> vehicles;
  List<dynamic> devices;

  factory GroupDetail.fromJson(Map<String, dynamic> json) => GroupDetail(
    id: json["_id"],
    name: json["name"],
    status: json["status"],
    logoPath: json["logoPath"] == null ? null : json["logoPath"],
    user: json["user"],
    createdBy: json["created_by"],
    address: json["address"] == null ? null : json["address"],
    contactNo: json["contact_no"] == null ? null : json["contact_no"],
    v: json["__v"],
    contactEmail: List<dynamic>.from(json["contact_email"].map((x) => x)),
    lastModified: DateTime.parse(json["last_modified"]),
    dev: List<dynamic>.from(json["dev"].map((x) => x)),
    geofence: List<dynamic>.from(json["geofence"].map((x) => x)),
    vehicles: List<dynamic>.from(json["vehicles"].map((x) => x)),
    devices: List<dynamic>.from(json["devices"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "status": status,
    "logoPath": logoPath == null ? null : logoPath,
    "user": user,
    "created_by": createdBy,
    "address": address == null ? null : address,
    "contact_no": contactNo == null ? null : contactNo,
    "__v": v,
    "contact_email": List<dynamic>.from(contactEmail.map((x) => x)),
    "last_modified": lastModified.toIso8601String(),
    "dev": List<dynamic>.from(dev.map((x) => x)),
    "geofence": List<dynamic>.from(geofence.map((x) => x)),
    "vehicles": List<dynamic>.from(vehicles.map((x) => x)),
    "devices": List<dynamic>.from(devices.map((x) => x)),
  };
}
