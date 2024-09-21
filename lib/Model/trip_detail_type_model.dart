import 'dart:convert';

List<TripDetailTypeModel> tripDetailTypeModelFromJson(String str) => List<TripDetailTypeModel>.from(json.decode(str).map((x) => TripDetailTypeModel.fromJson(x)));

class TripDetailTypeModel {
  TripDetailTypeModel({
    this.id,
    this.vehicle,
    this.currency,
    this.paymentMode,
    this.user,
    this.odometer,
    this.amount,
    this.type,
    this.lastModified,
    this.date,
  });

  String id;
  Vehicle vehicle;
  String currency;
  String paymentMode;
  String user;
  String odometer;
  int amount;
  String type;
  DateTime lastModified;
  DateTime date;

  factory TripDetailTypeModel.fromJson(Map<String, dynamic> json) => TripDetailTypeModel(
    id: json["_id"] == null ? null : json["_id"],
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    currency: json["currency"] == null ? null : json["currency"],
    paymentMode: json["payment_mode"] == null ? null : json["payment_mode"],
    user: json["user"] == null ? null : json["user"],
    odometer: json["odometer"] == null ? null : json["odometer"],
    amount: json["amount"] == null ? null : json["amount"],
    type: json["type"] == null ? null : json["type"],
    lastModified: json["last_modified"] == null ? null : DateTime.parse(json["last_modified"]),
    date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
  );

}

class Vehicle {
  Vehicle({
    this.id,
    this.deviceName,

  });

  String id;
  String deviceName;


  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["_id"] == null ? null : json["_id"],
    deviceName: json["Device_Name"] == null ? null : json["Device_Name"],

  );

}
