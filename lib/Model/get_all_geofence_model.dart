// To parse this JSON data, do
//
//     final getAllGeofenceModel = getAllGeofenceModelFromJson(jsonString);

import 'dart:convert';

GetAllGeofenceModel getAllGeofenceModelFromJson(String str) => GetAllGeofenceModel.fromJson(json.decode(str));

String getAllGeofenceModelToJson(GetAllGeofenceModel data) => json.encode(data.toJson());

class GetAllGeofenceModel {
  GetAllGeofenceModel({
    this.data,
  });

  List<Datum> data;

  factory GetAllGeofenceModel.fromJson(Map<String, dynamic> json) => GetAllGeofenceModel(
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.geofence,
    this.trackedDevice,
    this.devicesWithin,
    this.haltNotif,
    this.haltTime,
    this.devWithin,
    this.untrackedDevice,
    this.id,
    this.uid,
    this.geoname,
    this.entering,
    this.exiting,
    this.type,
    this.status,
    this.circleCenter,
    this.v,
    this.vehicleGroup,
  });

  Geofence geofence;
  List<dynamic> trackedDevice;
  List<dynamic> devicesWithin;
  bool haltNotif;
  String haltTime;
  List<dynamic> devWithin;
  List<dynamic> untrackedDevice;
  String id;
  String uid;
  String geoname;
  bool entering;
  bool exiting;
  String type;
  bool status;
  List<dynamic> circleCenter;
  int v;
  dynamic vehicleGroup;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    geofence: json["geofence"] == null ? null : Geofence.fromJson(json["geofence"]),
    trackedDevice: json["trackedDevice"] == null ? null : List<dynamic>.from(json["trackedDevice"].map((x) => x)),
    devicesWithin: json["devicesWithin"] == null ? null : List<dynamic>.from(json["devicesWithin"].map((x) => x)),
    haltNotif: json["halt_notif"] == null ? null : json["halt_notif"],
    haltTime: json["halt_time"] == null ? null : json["halt_time"],
    devWithin: json["devWithin"] == null ? null : List<dynamic>.from(json["devWithin"].map((x) => x)),
    untrackedDevice: json["untrackedDevice"] == null ? null : List<dynamic>.from(json["untrackedDevice"].map((x) => x)),
    id: json["_id"] == null ? null : json["_id"],
    uid: json["uid"] == null ? null : json["uid"],
    geoname: json["geoname"] == null ? null : json["geoname"],
    entering: json["entering"] == null ? null : json["entering"],
    exiting: json["exiting"] == null ? null : json["exiting"],
    type: json["type"] == null ? null : json["type"],
    status: json["status"] == null ? null : json["status"],
    circleCenter: json["circle_center"] == null ? null : List<dynamic>.from(json["circle_center"].map((x) => x)),
    v: json["__v"] == null ? null : json["__v"],
    vehicleGroup: json["vehicleGroup"],
  );

  Map<String, dynamic> toJson() => {
    "geofence": geofence == null ? null : geofence.toJson(),
    "trackedDevice": trackedDevice == null ? null : List<dynamic>.from(trackedDevice.map((x) => x)),
    "devicesWithin": devicesWithin == null ? null : List<dynamic>.from(devicesWithin.map((x) => x)),
    "halt_notif": haltNotif == null ? null : haltNotif,
    "halt_time": haltTime == null ? null : haltTime,
    "devWithin": devWithin == null ? null : List<dynamic>.from(devWithin.map((x) => x)),
    "untrackedDevice": untrackedDevice == null ? null : List<dynamic>.from(untrackedDevice.map((x) => x)),
    "_id": id == null ? null : id,
    "uid": uid == null ? null : uid,
    "geoname": geoname == null ? null : geoname,
    "entering": entering == null ? null : entering,
    "exiting": exiting == null ? null : exiting,
    "type": type == null ? null : type,
    "status": status == null ? null : status,
    "circle_center": circleCenter == null ? null : List<dynamic>.from(circleCenter.map((x) => x)),
    "__v": v == null ? null : v,
    "vehicleGroup": vehicleGroup,
  };
}

class Geofence {
  Geofence({
    this.type,
    this.coordinates,
  });

  String type;
  List<Coordinate> coordinates;

  factory Geofence.fromJson(Map<String, dynamic> json) => Geofence(
    type: json["type"] == null ? null : json["type"],
    coordinates: json["coordinates"] == null ? null : List<Coordinate>.from(json["coordinates"].map((x) => Coordinate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "coordinates": coordinates == null ? null : List<dynamic>.from(coordinates.map((x) => x.toJson())),
  };
}

class Coordinate {
  Coordinate({
    this.lat,
    this.long,
  });

  double lat;
  double long;

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    long: json["long"] == null ? null : json["long"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
  };
}
