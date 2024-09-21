// To parse this JSON data, do
//
//     final fuelConsumptionDailyModel = fuelConsumptionDailyModelFromJson(jsonString);

import 'dart:convert';

List<FuelConsumptionDailyModel> fuelConsumptionDailyModelFromJson(String str) => List<FuelConsumptionDailyModel>.from(json.decode(str).map((x) => FuelConsumptionDailyModel.fromJson(x)));

String fuelConsumptionDailyModelToJson(List<FuelConsumptionDailyModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FuelConsumptionDailyModel {
  FuelConsumptionDailyModel({
    this.imei,
    this.startFuel,
    this.endFuel,
    this.distance,
    this.startLocation,
    this.inEventCount,
    this.outEventCount,
    this.endLocation,
    this.startTime,
    this.endTime,
    this.fuelConsumed,
    this.k,
  });

  String imei;
  double startFuel;
  double endFuel;
  double distance;
  Location startLocation;
  int inEventCount;
  int outEventCount;
  Location endLocation;
  DateTime startTime;
  DateTime endTime;
  double fuelConsumed;
  int k;

  factory FuelConsumptionDailyModel.fromJson(Map<String, dynamic> json) => FuelConsumptionDailyModel(
    imei: json["imei"] == null ? null : json["imei"],
    startFuel: json["startFuel"] == null ? null : json["startFuel"].toDouble(),
    endFuel: json["endFuel"] == null ? null : json["endFuel"].toDouble(),
    distance: json["distance"] == null ? null : json["distance"].toDouble(),
    startLocation: json["start_location"] == null ? null : json["start_location"] == "NA"? null :Location.fromJson(json["start_location"]),
    inEventCount: json["in_event_count"] == null ? null : json["in_event_count"],
    outEventCount: json["out_event_count"] == null ? null : json["out_event_count"],
    endLocation: json["end_location"] == null ? null : json["end_location"] == "NA"? null : Location.fromJson(json["end_location"]),
    startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    fuelConsumed: json["fuel_consumed"] == null ? null : json["fuel_consumed"].toDouble(),
    k: json["k"] == null ? null : json["k"],
  );

  Map<String, dynamic> toJson() => {
    "imei": imei == null ? null : imei,
    "startFuel": startFuel == null ? null : startFuel,
    "endFuel": endFuel == null ? null : endFuel,
    "distance": distance == null ? null : distance,
    "start_location": startLocation == null ? null : startLocation.toJson(),
    "in_event_count": inEventCount == null ? null : inEventCount,
    "out_event_count": outEventCount == null ? null : outEventCount,
    "end_location": endLocation == null ? null : endLocation.toJson(),
    "start_time": startTime == null ? null : startTime.toIso8601String(),
    "end_time": endTime == null ? null : endTime.toIso8601String(),
    "fuel_consumed": fuelConsumed == null ? null : fuelConsumed,
    "k": k == null ? null : k,
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
