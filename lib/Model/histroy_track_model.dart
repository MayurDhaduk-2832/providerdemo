// To parse this JSON data, do
//
//     final HistoryTrackModel = HistoryTrackModelFromJson(jsonString);

import 'dart:convert';

List<HistoryTrackModel> HistoryTrackModelFromJson(String str) => List<HistoryTrackModel>.from(json.decode(str).map((x) => HistoryTrackModel.fromJson(x)));


class HistoryTrackModel {
  HistoryTrackModel({
    this.imei,
    this.raw,
    this.speed,
    this.heading,
    this.distanceFromPrevious,
    this.interpolated,
    this.insertionTime,
    this.insTime,
    this.lat,
    this.lng,
  });

  String imei;
  String raw;
  String speed;
  String heading;
  double distanceFromPrevious;
  List<dynamic> interpolated;
  DateTime insertionTime;
  DateTime insTime;
  double lat;
  double lng;

  factory HistoryTrackModel.fromJson(Map<String, dynamic> json) => HistoryTrackModel(
    imei: json["imei"] == null ? null : json["imei"],
    raw: json["raw"] == null ? null : json["raw"],
    speed: json["speed"] == null ? null : json["speed"],
    heading: json["heading"] == null ? null : json["heading"],
    distanceFromPrevious: json["distanceFromPrevious"] == null ? null : json["distanceFromPrevious"].toDouble(),
    interpolated: json["interpolated"] == null ? null : List<dynamic>.from(json["interpolated"].map((x) => x)),
    insertionTime: json["insertionTime"] == null ? null : DateTime.parse(json["insertionTime"]),
    insTime: json["insTime"] == null ? null : DateTime.parse(json["insTime"]),
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    lng: json["lng"] == null ? null : json["lng"].toDouble(),
  );
}
