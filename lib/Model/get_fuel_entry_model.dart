// To parse this JSON data, do
//
//     final getFuelEntryModel = getFuelEntryModelFromJson(jsonString);

import 'dart:convert';

List<GetFuelEntryModel> getFuelEntryModelFromJson(String str) => List<GetFuelEntryModel>.from(json.decode(str).map((x) => GetFuelEntryModel.fromJson(x)));

String getFuelEntryModelToJson(List<GetFuelEntryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetFuelEntryModel {
  GetFuelEntryModel({
    this.id,
    this.vehicle,
    this.user,
    this.quantity,
    this.odometer,
    this.price,
    this.fuelType,
    this.comment,
    this.v,
    this.lastModified,
    this.date,
  });

  String id;
  Vehicle vehicle;
  String user;
  String quantity;
  String odometer;
  dynamic price;
  String fuelType;
  String comment;
  int v;
  DateTime lastModified;
  DateTime date;

  factory GetFuelEntryModel.fromJson(Map<String, dynamic> json) => GetFuelEntryModel(
    id: json["_id"] == null ? null : json["_id"],
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    user: json["user"] == null ? null : json["user"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    odometer: json["odometer"] == null ? null : json["odometer"],
    price: json["price"] == null ? null : json["price"],
    fuelType: json["fuel_type"] == null ? null : json["fuel_type"],
    comment: json["comment"] == null ? null : json["comment"],
    v: json["__v"] == null ? null : json["__v"],
    lastModified: json["last_modified"] == null ? null : DateTime.parse(json["last_modified"]),
    date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "vehicle": vehicle == null ? null : vehicle.toJson(),
    "user": user == null ? null : user,
    "quantity": quantity == null ? null : quantity,
    "odometer": odometer == null ? null : odometer,
    "price": price == null ? null : price,
    "fuel_type": fuelType == null ? null : fuelType,
    "comment": comment == null ? null : comment,
    "__v": v == null ? null : v,
    "last_modified": lastModified == null ? null : lastModified.toIso8601String(),
    "Date": date == null ? null : date.toIso8601String(),
  };
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

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "Device_Name": deviceName == null ? null : deviceName,
  };
}
