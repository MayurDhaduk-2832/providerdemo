// To parse this JSON data, do
//
//     final getFuelPrice = getFuelPriceFromJson(jsonString);

import 'dart:convert';

GetFuelPrice getFuelPriceFromJson(String str) => GetFuelPrice.fromJson(json.decode(str));

String getFuelPriceToJson(GetFuelPrice data) => json.encode(data.toJson());

class GetFuelPrice {
  GetFuelPrice({
    this.data,
  });

  List<Datum> data;

  factory GetFuelPrice.fromJson(Map<String, dynamic> json) => GetFuelPrice(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.date,
    this.state,
    this.dieselYesterday,
    this.petrolYesterday,
    this.diesel,
    this.petrol,
    this.city,
  });

  String date;
  String state;
  String dieselYesterday;
  String petrolYesterday;
  String diesel;
  String petrol;
  String city;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    date: json["date"],
    state: json["state"],
    dieselYesterday: json["diesel_yesterday"],
    petrolYesterday: json["petrol_yesterday"],
    diesel: json["diesel"],
    petrol: json["petrol"],
    city: json["city"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "state": state,
    "diesel_yesterday": dieselYesterday,
    "petrol_yesterday": petrolYesterday,
    "diesel": diesel,
    "petrol": petrol,
    "city": city,
  };
}
