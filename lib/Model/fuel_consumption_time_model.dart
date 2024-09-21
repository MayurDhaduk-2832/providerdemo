// To parse this JSON data, do
//
//     final fuelConsumptionTimeModel = fuelConsumptionTimeModelFromJson(jsonString);

import 'dart:convert';

List<FuelConsumptionTimeModel> fuelConsumptionTimeModelFromJson(String str) =>
    List<FuelConsumptionTimeModel>.from(
        json.decode(str).map((x) => FuelConsumptionTimeModel.fromJson(x)));

String fuelConsumptionTimeModelToJson(List<FuelConsumptionTimeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FuelConsumptionTimeModel {
  FuelConsumptionTimeModel({
    this.imei,
    this.vehicleName,
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
    this.i,
  });

  String imei;
  String vehicleName;
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
  int i;

  factory FuelConsumptionTimeModel.fromJson(Map<String, dynamic> json) =>
      FuelConsumptionTimeModel(
        imei: json["imei"] == null ? null : json["imei"],
        vehicleName: json["vehicle_name"] == null ? null : json["vehicle_name"],
        startFuel:
            json["startFuel"] == null ? null : json["startFuel"].toDouble(),
        endFuel: json["endFuel"] == null ? null : json["endFuel"].toDouble(),
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        startLocation: json["start_location"] == null
            ? null
            : json["start_location"] == "NA" ? null : Location.fromJson(json["start_location"]),
        inEventCount:
            json["in_event_count"] == null ? null : json["in_event_count"],
        outEventCount:
            json["out_event_count"] == null ? null : json["out_event_count"],
        endLocation: json["end_location"] == null
            ? null
            : json["end_location"] == "NA" ? null : Location.fromJson(json["end_location"]),
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        fuelConsumed:
            json["fuel_consumed"] == null ? null : json["fuel_consumed"].toDouble(),
        i: json["i"] == null ? null : json["i"],
      );

  Map<String, dynamic> toJson() => {
        "imei": imei == null ? null : imei,
        "vehicle_name": vehicleName == null ? null : vehicleName,
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
        "i": i == null ? null : i,
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
