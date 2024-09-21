// To parse this JSON data, do
//
//     final getPoiListModel = getPoiListModelFromJson(jsonString);

import 'dart:convert';

GetPoiListModel getPoiListModelFromJson(String str) => GetPoiListModel.fromJson(json.decode(str));

String getPoiListModelToJson(GetPoiListModel data) => json.encode(data.toJson());

class GetPoiListModel {
  GetPoiListModel({
    this.data,
  });

  List<GetPoiList> data;

  factory GetPoiListModel.fromJson(Map<String, dynamic> json) => GetPoiListModel(
    data: List<GetPoiList>.from(json["data"].map((x) => GetPoiList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GetPoiList {
  GetPoiList({
    this.poi,
    this.untrackedDevice,
    this.status,
    this.haltNotif,
    this.heading,
    this.sbUsers,
    this.functionality,
    this.h,
    this.m,
    this.id,
    this.radius,
    this.user,
    this.createdOn,
    this.ppickup,
    this.v,
  });

  Poi poi;
  List<dynamic> untrackedDevice;
  bool status;
  bool haltNotif;
  dynamic heading;
  List<dynamic> sbUsers;
  dynamic functionality;
  dynamic h;
  dynamic m;
  String id;
  dynamic radius;
  String user;
  DateTime createdOn;
  List<dynamic> ppickup;
  int v;

  factory GetPoiList.fromJson(Map<String, dynamic> json) => GetPoiList(
    poi: Poi.fromJson(json["poi"]),
    untrackedDevice: List<dynamic>.from(json["untrackedDevice"].map((x) => x)),
    status: json["status"],
    haltNotif: json["halt_notif"],
    heading: json["heading"],
    sbUsers: List<dynamic>.from(json["sbUsers"].map((x) => x)),
    functionality: json["functionality"],
    h: json["H"],
    m: json["M"],
    id: json["_id"],
    radius: json["radius"],
    user: json["user"],
    createdOn: DateTime.parse(json["createdOn"]),
    ppickup: json["ppickup"] == null ? null : List<dynamic>.from(json["ppickup"].map((x) => x)),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "poi": poi.toJson(),
    "untrackedDevice": List<dynamic>.from(untrackedDevice.map((x) => x)),
    "status": status,
    "halt_notif": haltNotif,
    "heading": heading,
    "sbUsers": List<dynamic>.from(sbUsers.map((x) => x)),
    "functionality": functionality,
    "H": h,
    "M": m,
    "_id": id,
    "radius": radius,
    "user": user,
    "createdOn": createdOn.toIso8601String(),
    "ppickup": ppickup == null ? null : List<dynamic>.from(ppickup.map((x) => x)),
    "__v": v,
  };
}

class Poi {
  Poi({
    this.location,
    this.poiname,
    this.address,
    this.poiType,
  });

  Location location;
  String poiname;
  String address;
  String poiType;

  factory Poi.fromJson(Map<String, dynamic> json) => Poi(
    location: Location.fromJson(json["location"]),
    poiname: json["poiname"],
    address: json["address"],
    poiType: json["poi_type"] == null ? null : json["poi_type"],
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "poiname": poiname,
    "address": address,
    "poi_type": poiType == null ? null : poiType,
  };
}

class Location {
  Location({
    this.type,
    this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}
