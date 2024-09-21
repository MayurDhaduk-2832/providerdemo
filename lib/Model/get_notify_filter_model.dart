// To parse this JSON data, do
//
//     final getNotifyFilterModel = getNotifyFilterModelFromJson(jsonString);

import 'dart:convert';

List<GetNotifyFilterModel> getNotifyFilterModelFromJson(String str) => List<GetNotifyFilterModel>.from(json.decode(str).map((x) => GetNotifyFilterModel.fromJson(x)));

String getNotifyFilterModelToJson(List<GetNotifyFilterModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetNotifyFilterModel {
  GetNotifyFilterModel({
    this.id,
    this.device,
    this.deviceId,
    this.user,
    this.dealer,
    this.group,
    this.odo,
    this.org,
    this.type,
    this.priority,
    this.long,
    this.lat,
    this.getNotifyFilterModelSwitch,
    this.vehicleName,
    this.v,
    this.commentSaved,
    this.seen,
    this.item,
    this.timestamp,
    this.overSpeed,
  });

  String id;
  String device;
  String deviceId;
  String user;
  String dealer;
  String group;
  double odo;
  dynamic org;
  String type;
  int priority;
  double long;
  double lat;
  String getNotifyFilterModelSwitch;
  String vehicleName;
  int v;
  bool commentSaved;
  bool seen;
  Item item;
  DateTime timestamp;
  String overSpeed;

  factory GetNotifyFilterModel.fromJson(Map<String, dynamic> json) => GetNotifyFilterModel(
    id: json["_id"] == null ? null : json["_id"],
    device: json["device"] == null ? null : json["device"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    user: json["user"] == null ? null : json["user"],
    dealer: json["dealer"] == null ? null : json["dealer"],
    group: json["group"] == null ? null : json["group"],
    odo: json["odo"] == null ? 0.0 : json["odo"].toDouble(),
    org: json["org"],
    type: json["type"] == null ? null : json["type"],
    priority: json["priority"] == null ? null : json["priority"],
    long: json["long"] == null ? null : json["long"].toDouble(),
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    getNotifyFilterModelSwitch: json["switch"] == null ? null : json["switch"],
    vehicleName: json["vehicleName"] == null ? null : json["vehicleName"],
    v: json["__v"] == null ? null : json["__v"],
    commentSaved: json["commentSaved"] == null ? null : json["commentSaved"],
    seen: json["seen"] == null ? null : json["seen"],
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    overSpeed: json["overSpeed"] == null ? null : json["overSpeed"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "device": device == null ? null : device,
    "device_id": deviceId == null ? null : deviceId,
    "user": user == null ? null : user,
    "dealer": dealer == null ? null : dealer,
    "group": group == null ? null : group,
    "odo": odo == null ? null : odo,
    "org": org,
    "type": type == null ? null : type,
    "priority": priority == null ? null : priority,
    "long": long == null ? null : long,
    "lat": lat == null ? null : lat,
    "switch": getNotifyFilterModelSwitch == null ? null : getNotifyFilterModelSwitch,
    "vehicleName": vehicleName == null ? null : vehicleName,
    "__v": v == null ? null : v,
    "commentSaved": commentSaved == null ? null : commentSaved,
    "seen": seen == null ? null : seen,
    "item": item == null ? null : item.toJson(),
    "timestamp": timestamp == null ? null : timestamp.toIso8601String(),
    "overSpeed": overSpeed == null ? null : overSpeed,
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
