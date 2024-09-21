// To parse this JSON data, do
//
//     final vehicleTypeModel = vehicleTypeModelFromJson(jsonString);

import 'dart:convert';

List<VehicleTypeModel> vehicleTypeModelFromJson(String str) => List<VehicleTypeModel>.from(json.decode(str).map((x) => VehicleTypeModel.fromJson(x)));

class VehicleTypeModel {
  VehicleTypeModel({
    this.id,
    this.brand,
    this.description,
    this.model,
    this.tankSize,
    this.mileage,
    this.v,
    this.lastModified,
    this.iconType,
    this.tempCalibration,
    this.voltageCalibration,
    this.user,
  });

  String id;
  String brand;
  String description;
  String model;
  double tankSize;
  double mileage;
  int v;
  DateTime lastModified;
  String iconType;
  List<TempCalibration> tempCalibration;
  List<VoltageCalibration> voltageCalibration;
  User user;

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) => VehicleTypeModel(
    id: json["_id"] == null ? "" : json["_id"],
    brand: json["brand"] == null ? "" : json["brand"],
    description: json["description"] == null ? "" : json["description"],
    model: json["model"] == null ? "" : json["model"],
    tankSize: json["tank_size"] == null ? 0 : json["tank_size"].toDouble(),
    mileage: json["mileage"] == null ? 0 : json["mileage"].toDouble(),
    v: json["__v"] == null ? 0 : json["__v"],
    lastModified: json["last_modified"] == null ? DateTime.now() : DateTime.parse(json["last_modified"]),
    iconType: json["iconType"] == null ? "" : json["iconType"],
    tempCalibration: json["temp_calibration"] == null ? [] : List<TempCalibration>.from(json["temp_calibration"].map((x) => TempCalibration.fromJson(x))),
    voltageCalibration: json["voltage_calibration"] == null ? [] : List<VoltageCalibration>.from(json["voltage_calibration"].map((x) => VoltageCalibration.fromJson(x))),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

}

class TempCalibration {
  TempCalibration({
    this.voltage,
    this.temp,
    this.id,
  });

  int voltage;
  int temp;
  String id;

  factory TempCalibration.fromJson(Map<String, dynamic> json) => TempCalibration(
    voltage: json["voltage"] == null ? null : json["voltage"],
    temp: json["temp"] == null ? null : json["temp"],
    id: json["_id"] == null ? null : json["_id"],
  );

}

class User {
  User({
    this.id,
    this.firstName,
  });

  String id;
  String firstName;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"] == null ? null : json["_id"],
    firstName: json["first_name"] == null ? null : json["first_name"],
  );
}

class VoltageCalibration {
  VoltageCalibration({
    this.voltage,
    this.fuel,
    this.id,
  });

  double voltage;
  double fuel;
  String id;

  factory VoltageCalibration.fromJson(Map<String, dynamic> json) => VoltageCalibration(
    voltage: json["voltage"] == null ? null : json["voltage"].toDouble(),
    fuel: json["fuel"] == null ? null : json["fuel"].toDouble(),
    id: json["_id"] == null ? null : json["_id"],
  );

}

