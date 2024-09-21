import 'dart:convert';

GetPoiReportModel getPoiReportModelFromJson(String str) => GetPoiReportModel.fromJson(json.decode(str));

String getPoiReportModelToJson(GetPoiReportModel data) => json.encode(data.toJson());

class GetPoiReportModel {
  GetPoiReportModel({
    this.data,
  });

  List<GetPoiReportList> data;

  factory GetPoiReportModel.fromJson(Map<String, dynamic> json) => GetPoiReportModel(
    data: List<GetPoiReportList>.from(json["data"].map((x) => GetPoiReportList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GetPoiReportList {
  GetPoiReportList({
    this.id,
    this.device,
    this.poi,
    this.user,
    this.arrivalTime,
    this.lat,
    this.long,
    this.v,
    this.departureTime,
    this.group,
    this.vehicle,
  });

  String id;
  Device device;
  DatumPoi poi;
  String user;
  DateTime arrivalTime;
  String lat;
  String long;
  int v;
  DateTime departureTime;
  String group;
  dynamic vehicle;

  factory GetPoiReportList.fromJson(Map<String, dynamic> json) => GetPoiReportList(
    id: json["_id"],
    device: Device.fromJson(json["device"]),
    poi: json["poi"] == null ? null : DatumPoi.fromJson(json["poi"]),
    user: json["user"],
    arrivalTime: DateTime.parse(json["arrivalTime"]),
    lat: json["lat"],
    long: json["long"],
    v: json["__v"],
    departureTime: json["departureTime"] == null ? null : DateTime.parse(json["departureTime"]),
    group: json["group"] == null ? null : json["group"],
    vehicle: json["vehicle"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "device": device.toJson(),
    "poi": poi == null ? null : poi.toJson(),
    "user": user,
    "arrivalTime": arrivalTime.toIso8601String(),
    "lat": lat,
    "long": long,
    "__v": v,
    "departureTime": departureTime == null ? null : departureTime.toIso8601String(),
    "group": group == null ? null : group,
    "vehicle": vehicle,
  };
}

class Device {
  Device({
    this.id,
    this.deviceName,
    this.deviceId,
  });

  String id;
  String deviceName;
  String deviceId;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json["_id"],
    deviceName: json["Device_Name"],
    deviceId: json["Device_ID"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "Device_Name": deviceName,
    "Device_ID": deviceId,
  };
}

class DatumPoi {
  DatumPoi({
    this.poi,
    this.id,
  });

  PoiPoi poi;
  String id;

  factory DatumPoi.fromJson(Map<String, dynamic> json) => DatumPoi(
    poi: PoiPoi.fromJson(json["poi"]),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "poi": poi.toJson(),
    "_id": id,
  };
}

class PoiPoi {
  PoiPoi({
    this.poiname,
  });

  String poiname;

  factory PoiPoi.fromJson(Map<String, dynamic> json) => PoiPoi(
    poiname: json["poiname"] == null ? "" : json["poiname"],
  );

  Map<String, dynamic> toJson() => {
    "poiname": poiname,
  };
}
