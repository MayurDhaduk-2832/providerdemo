import 'dart:convert';

List<GetRouteModel> getRouteModelFromJson(String str) => List<GetRouteModel>.from(json.decode(str).map((x) => GetRouteModel.fromJson(x)));

String getRouteModelToJson(List<GetRouteModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetRouteModel {
  GetRouteModel({
    this.id,
    this.name,
    this.source,
    this.destination,
    this.user,
    this.status,
    this.createdOn,
    this.v,
    this.trackedDevice,
    this.routeDevice,
    this.waypoints,
  });

  String id;
  String name;
  String source;
  String destination;
  String user;
  String status;
  DateTime createdOn;
  int v;
  List<String> trackedDevice;
  List<String> routeDevice;
  List<Waypoint> waypoints;

  factory GetRouteModel.fromJson(Map<String, dynamic> json) => GetRouteModel(
    id: json["_id"] == null ? null : json["_id"],
    name: json["name"] == null ? null : json["name"],
    source: json["source"] == null ? null : json["source"],
    destination: json["destination"] == null ? null : json["destination"],
    user: json["user"] == null ? null : json["user"],
    status: json["status"] == null ? null : json["status"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    v: json["__v"] == null ? null : json["__v"],
    trackedDevice: json["trackedDevice"] == null ? null : List<String>.from(json["trackedDevice"].map((x) => x)),
    routeDevice: json["route_device"] == null ? null : List<String>.from(json["route_device"].map((x) => x)),
    waypoints: json["waypoints"] == null ? null : List<Waypoint>.from(json["waypoints"].map((x) => Waypoint.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "name": name == null ? null : name,
    "source": source == null ? null : source,
    "destination": destination == null ? null : destination,
    "user": user == null ? null : user,
    "status": status == null ? null : status,
    "createdOn": createdOn == null ? null : createdOn.toIso8601String(),
    "__v": v == null ? null : v,
    "trackedDevice": trackedDevice == null ? null : List<dynamic>.from(trackedDevice.map((x) => x)),
    "route_device": routeDevice == null ? null : List<dynamic>.from(routeDevice.map((x) => x)),
    "waypoints": waypoints == null ? null : List<dynamic>.from(waypoints.map((x) => x.toJson())),
  };
}

class Waypoint {
  Waypoint({
    this.id,
    this.location,
  });

  String id;
  Location location;

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
    id: json["_id"] == null ? null : json["_id"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "location": location == null ? null : location.toJson(),
  };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    lng: json["lng"] == null ? null : json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat == null ? null : lat,
    "lng": lng == null ? null : lng,
  };
}
