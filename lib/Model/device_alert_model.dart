// To parse this JSON data, do
//
//     final deviceAlertModel = deviceAlertModelFromJson(jsonString);

import 'dart:convert';

DeviceAlertModel deviceAlertModelFromJson(String str) => DeviceAlertModel.fromJson(json.decode(str));

String deviceAlertModelToJson(DeviceAlertModel data) => json.encode(data.toJson());

class DeviceAlertModel {
  DeviceAlertModel({
    this.theftAlert,
    this.towAlert,
    this.id,
  });

  bool theftAlert;
  bool towAlert;
  String id;

  factory DeviceAlertModel.fromJson(Map<String, dynamic> json) => DeviceAlertModel(
    theftAlert: json["theftAlert"] == null ? null : json["theftAlert"],
    towAlert: json["towAlert"] == null ? null : json["towAlert"],
    id: json["_id"] == null ? null : json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "theftAlert": theftAlert == null ? null : theftAlert,
    "towAlert": towAlert == null ? null : towAlert,
    "_id": id == null ? null : id,
  };
}
