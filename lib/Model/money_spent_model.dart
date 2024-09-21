// To parse this JSON data, do
//
//     final moneySpentModel = moneySpentModelFromJson(jsonString);

import 'dart:convert';

MoneySpentModel moneySpentModelFromJson(String str) => MoneySpentModel.fromJson(json.decode(str));

String moneySpentModelToJson(MoneySpentModel data) => json.encode(data.toJson());

class MoneySpentModel {
  MoneySpentModel({
    this.data,
    this.total,
  });

  List<MoneySpentDatum> data;
  Total total;

  factory MoneySpentModel.fromJson(Map<String, dynamic> json) => MoneySpentModel(
    data: json["data"] == null ? null : List<MoneySpentDatum>.from(json["data"].map((x) => MoneySpentDatum.fromJson(x))),
    total: json["total"] == null ? null : Total.fromJson(json["total"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "total": total == null ? null : total.toJson(),
  };
}

class MoneySpentDatum {
  MoneySpentDatum({
    this.date,
    this.distanceKms,
    this.mileage,
    this.fuel,
    this.money,
  });

  DateTime date;
  dynamic distanceKms;
  String mileage;
  String fuel;
  String money;

  factory MoneySpentDatum.fromJson(Map<String, dynamic> json) => MoneySpentDatum(
    date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
    distanceKms: json["Distance(Kms)"] == null ? null : json["Distance(Kms)"],
    mileage: json["Mileage"] == null ? null : json["Mileage"],
    fuel: json["fuel"] == null ? null : json["fuel"],
    money: json["money"] == null ? null : json["money"],
  );

  Map<String, dynamic> toJson() => {
    "Date": date == null ? null : date.toIso8601String(),
    "Distance(Kms)": distanceKms == null ? null : distanceKms,
    "Mileage": mileage == null ? null : mileage,
    "fuel": fuel == null ? null : fuel,
    "money": money == null ? null : money,
  };
}

class Total {
  Total({
    this.totalKm,
    this.fuel,
    this.expense,
  });

  String totalKm;
  String fuel;
  String expense;

  factory Total.fromJson(Map<String, dynamic> json) => Total(
    totalKm: json["totalKm"] == null ? null : json["totalKm"],
    fuel: json["Fuel"] == null ? null : json["Fuel"],
    expense: json["expense"] == null ? null : json["expense"],
  );

  Map<String, dynamic> toJson() => {
    "totalKm": totalKm == null ? null : totalKm,
    "Fuel": fuel == null ? null : fuel,
    "expense": expense == null ? null : expense,
  };
}
