// To parse this JSON data, do
//
//     final fuelConsumptionTripModel = fuelConsumptionTripModelFromJson(jsonString);

import 'dart:convert';

List<FuelConsumptionTripModel> fuelConsumptionTripModelFromJson(String str) => List<FuelConsumptionTripModel>.from(json.decode(str).map((x) => FuelConsumptionTripModel.fromJson(x)));

String fuelConsumptionTripModelToJson(List<FuelConsumptionTripModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FuelConsumptionTripModel {
  FuelConsumptionTripModel({
    this.imei,
    this.startFuel,
    this.endFuel,
    this.vehicleName,
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
  double startFuel;
  double endFuel;
  String vehicleName;
  double distance;
  Location startLocation;
  int inEventCount;
  int outEventCount;
  Location endLocation;
  DateTime startTime;
  DateTime endTime;
  double fuelConsumed;
  int i;

  factory FuelConsumptionTripModel.fromJson(Map<String, dynamic> json) => FuelConsumptionTripModel(
    imei: json["imei"] == null ? null : json["imei"],
    startFuel: json["startFuel"] == null ? null : json["startFuel"].toDouble(),
    endFuel: json["endFuel"] == null ? null : json["endFuel"].toDouble(),
    vehicleName: json["vehicle_name"] == null ? "" : json["vehicle_name"],
    distance: json["distance"] == null ? 0.0 : json["distance"].toDouble(),
    startLocation: json["start_location"] == null ? null : json["start_location"] == "NA" ? null : Location.fromJson(json["start_location"]),
    inEventCount: json["in_event_count"] == null ? null : json["in_event_count"],
    outEventCount: json["out_event_count"] == null ? null : json["out_event_count"],
    endLocation: json["end_location"] == null ? null:  json["end_location"] == "NA" ? null : Location.fromJson(json["end_location"]),
    startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    fuelConsumed: json["fuel_consumed"] == null ? null : json["fuel_consumed"].toDouble(),
    i: json["i"] == null ? null : json["i"],
  );

  Map<String, dynamic> toJson() => {
    "imei": imei == null ? null : imei,
    "startFuel": startFuel == null ? null : startFuel,
    "endFuel": endFuel == null ? null : endFuel,
    "vehicle_name": vehicleName == null ? null : vehicleName,
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

  String lat;
  String lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"] == null ? null : json["lat"],
    lng: json["lng"] == null ? null : json["lng"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat == null ? null : lat,
    "lng": lng == null ? null : lng,
  };
}
