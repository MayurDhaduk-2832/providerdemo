import 'dart:convert';

List<ParkingModel> parkingModelFromJson(String str) => List<ParkingModel>.from(
    json.decode(str).map((x) => ParkingModel.fromJson(x)));

class ParkingModel {
  ParkingModel({
    this.id,
    this.user,
    this.device,
    this.arrivalTime,
    this.departureTime,
    this.lat,
    this.long,
    this.v,
    this.address,
  });

  String id;
  String user;
  String device;
  DateTime arrivalTime;
  DateTime departureTime;
  String lat;
  String long;
  int v;
  String address;

  factory ParkingModel.fromJson(Map<String, dynamic> json) => ParkingModel(
        id: json["_id"] == null ? null : json["_id"],
        user: json["user"] == null ? null : json["user"],
        device: json["device"] == null ? null : json["device"],
        arrivalTime: json["arrival_time"] == null
            ? null
            : DateTime.parse(json["arrival_time"]).toLocal(),
        departureTime: json["departure_time"] == null
            ? null
            : DateTime.parse(json["departure_time"]).toLocal(),
        lat: json["lat"] == null ? null : json["lat"],
        long: json["long"] == null ? null : json["long"],
        v: json["__v"] == null ? null : json["__v"],
        address: json["address"] == null ? null : json["address"],
      );
}
