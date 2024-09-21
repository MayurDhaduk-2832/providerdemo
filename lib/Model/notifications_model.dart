// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

List<NotificationsModel> notificationsModelFromJson(String str) => List<NotificationsModel>.from(json.decode(str).map((x) => NotificationsModel.fromJson(x)));

String notificationsModelToJson(List<NotificationsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationsModel {
  NotificationsModel({
    this.id,
    this.device,
    this.deviceId,
    this.user,
    this.odo,
    this.org,
    this.type,
    this.priority,
    this.long,
    this.lat,
    this.notificationsModelSwitch,
    this.vehicleName,
    this.v,
    this.commentSaved,
    this.seen,
    this.item,
    this.timestamp,
    this.dealer,
    this.trip,
    this.poiAction,
    this.poi,
  });

  String id;
  String device;
  String deviceId;
  String user;
  double odo;
  dynamic org;
  String type;
  int priority;
  double long;
  double lat;
  String notificationsModelSwitch;
  String vehicleName;
  int v;
  bool commentSaved;
  bool seen;
  Item item;
  DateTime timestamp;
  String dealer;
  String trip;
  String poiAction;
  String poi;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
    id: json["_id"] == null ? null : json["_id"],
    device: json["device"] == null ? null : json["device"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    user: json["user"] == null ? null : json["user"],
    odo: json["odo"] == null ? null : json["odo"].toDouble(),
    org: json["org"],
    type: json["type"] == null ? null : json["type"],
    priority: json["priority"] == null ? null : json["priority"],
    long: json["long"] == null ? null : json["long"].toDouble(),
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    notificationsModelSwitch: json["switch"] == null ? null : json["switch"],
    vehicleName: json["vehicleName"] == null ? null : json["vehicleName"],
    v: json["__v"] == null ? null : json["__v"],
    commentSaved: json["commentSaved"] == null ? null : json["commentSaved"],
    seen: json["seen"] == null ? null : json["seen"],
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    dealer: json["dealer"] == null ? null : json["dealer"],
    trip: json["trip"] == null ? null : json["trip"],
    poiAction: json["poiAction"] == null ? null : json["poiAction"],
    poi: json["poi"] == null ? null : json["poi"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "device": device == null ? null : device,
    "device_id": deviceId == null ? null : deviceId,
    "user": user == null ? null : user,
    "odo": odo == null ? null : odo,
    "org": org,
    "type": type == null ? null : type,
    "priority": priority == null ? null : priority,
    "long": long == null ? null : long,
    "lat": lat == null ? null : lat,
    "switch": notificationsModelSwitch == null ? null : notificationsModelSwitch,
    "vehicleName": vehicleName == null ? null : vehicleName,
    "__v": v == null ? null : v,
    "commentSaved": commentSaved == null ? null : commentSaved,
    "seen": seen == null ? null : seen,
    "item": item == null ? null : item.toJson(),
    "timestamp": timestamp == null ? null : timestamp.toIso8601String(),
    "dealer": dealer == null ? null : dealer,
    "trip": trip == null ? null : trip,
    "poiAction": poiAction == null ? null : poiAction,
    "poi": poi == null ? null : poi,
  };
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

  Map<String, dynamic> toJson() => {
    "_type": type == null ? null : type,
    "sentence": sentence == null ? null : sentence,
  };
}
