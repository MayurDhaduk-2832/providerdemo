
import 'dart:convert';

AnalyticChartModel analyticChartModelFromJson(String str) => AnalyticChartModel.fromJson(json.decode(str));

String analyticChartModelToJson(AnalyticChartModel data) => json.encode(data.toJson());

class AnalyticChartModel {
  AnalyticChartModel({
    this.data,
    this.total,
  });

  List<AnalyticsDatum> data;
  Total total;

  factory AnalyticChartModel.fromJson(Map<String, dynamic> json) => AnalyticChartModel(
    data: json["data"] == null ? null : List<AnalyticsDatum>.from(json["data"].map((x) => AnalyticsDatum.fromJson(x))),
    total: json["total"] == null ? null : Total.fromJson(json["total"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "total": total == null ? null : total.toJson(),
  };
}

class AnalyticsDatum {
  AnalyticsDatum({
    this.date,
    this.vrn,
    this.deviceId,
    this.mileage,
    this.distanceKms,
    this.fuel,
    this.money,
  });

  DateTime date;
  String vrn;
  String deviceId;
  String mileage;
  dynamic distanceKms;
  String fuel;
  String money;

  factory AnalyticsDatum.fromJson(Map<String, dynamic> json) => AnalyticsDatum(
    date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
    vrn: json["VRN"] == null ? null : json["VRN"],
    deviceId: json["Device_ID"] == null ? null : json["Device_ID"],
    mileage: json["Mileage"] == null ? null : json["Mileage"],
    distanceKms: json["Distance(Kms)"] == null ? null : json["Distance(Kms)"],
    fuel: json["fuel"] == null ? null : json["fuel"],
    money: json["money"] == null ? null : json["money"],
  );

  Map<String, dynamic> toJson() => {
    "Date": date == null ? null : date.toIso8601String(),
    "VRN": vrn == null ? null : vrn,
    "Device_ID": deviceId == null ? null : deviceId,
    "Mileage": mileage == null ? null : mileage,
    "Distance(Kms)": distanceKms == null ? null : distanceKms,
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
