import 'dart:convert';

List<RouteReportsModel> routeReportsModelFromJson(String str) => List<RouteReportsModel>.from(json.decode(str).map((x) => RouteReportsModel.fromJson(x)));

class RouteReportsModel {
  RouteReportsModel({
    this.item,
    this.seen,
    this.id,
    this.device,
    this.user,
    this.odo,
    this.group,
    this.org,
    this.type,
    this.priority,
    this.track,
    this.route,
    this.vehicleName,
    this.long,
    this.lat,
    this.timestamp,
    this.v,
  });

  Item item;
  bool seen;
  String id;
  String device;
  String user;
  double odo;
  dynamic group;
  dynamic org;
  String type;
  int priority;
  Track track;
  String route;
  String vehicleName;
  double long;
  double lat;
  DateTime timestamp;
  int v;

  factory RouteReportsModel.fromJson(Map<String, dynamic> json) => RouteReportsModel(
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
    seen: json["seen"] == null ? null : json["seen"],
    id: json["_id"] == null ? null : json["_id"],
    device: json["device"] == null ? null : json["device"],
    user: json["user"] == null ? null : json["user"],
    odo: json["odo"] == null ? null : json["odo"].toDouble(),
    group: json["group"],
    org: json["org"],
    type: json["type"] == null ? null : json["type"],
    priority: json["priority"] == null ? null : json["priority"],
    track: json["track"] == null ? null : Track.fromJson(json["track"]),
    route: json["route"] == null ? null : json["route"],
    vehicleName: json["vehicleName"] == null ? null : json["vehicleName"],
    long: json["long"] == null ? null : json["long"].toDouble(),
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    v: json["__v"] == null ? null : json["__v"],
  );

}

class Item {
  Item({
    this.type,
    this.sentence,
  });

  String type;
  String sentence;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    type: json["_type"] == null ? null : json["_type"],
    sentence: json["sentence"] == null ? null : json["sentence"],
  );

}

class Track {
  Track({
    this.id,
    this.name,
    this.source,
    this.destination,
  });

  String id;
  String name;
  String source;
  String destination;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    id: json["_id"] == null ? null : json["_id"],
    name: json["name"] == null ? null : json["name"],
    source: json["source"] == null ? null : json["source"],
    destination: json["destination"] == null ? null : json["destination"],
  );

}
