// To parse this JSON data, do
//
//     final speedChartModel = speedChartModelFromJson(jsonString);

import 'dart:convert';

List<SpeedChartModel> speedChartModelFromJson(String str) => List<SpeedChartModel>.from(json.decode(str).map((x) => SpeedChartModel.fromJson(x)));

String speedChartModelToJson(List<SpeedChartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpeedChartModel {
  SpeedChartModel({
    this.speedChart,
    this.id,
    this.deviceName,
  });

  Map<String, int> speedChart;
  String id;
  String deviceName;

  factory SpeedChartModel.fromJson(Map<String, dynamic> json) => SpeedChartModel(
    speedChart: json["speedChart"] == null ? null : Map.from(json["speedChart"]).map((k, v) => MapEntry<String, int>(k, v)),
    id: json["_id"] == null ? null : json["_id"],
    deviceName: json["Device_Name"] == null ? null : json["Device_Name"],
  );

  Map<String, dynamic> toJson() => {
    "speedChart": speedChart == null ? null : Map.from(speedChart).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "_id": id == null ? null : id,
    "Device_Name": deviceName == null ? null : deviceName,
  };
}
