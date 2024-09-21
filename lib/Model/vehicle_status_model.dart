import 'dart:convert';

VehicleStatusModel vehicleStatusModelFromJson(String str) => VehicleStatusModel.fromJson(json.decode(str));


class VehicleStatusModel {
  VehicleStatusModel({
    this.data,
    this.graph,
  });

  VehicleStatus data;
  List<Graph> graph;

  factory VehicleStatusModel.fromJson(Map<String, dynamic> json) => VehicleStatusModel(
    data: json["data"] == null ? [] : VehicleStatus.fromJson(json["data"]),
    graph: json["graph"] == null ? null : List<Graph>.from(json["graph"].map((x) => Graph.fromJson(x))),
  );

}

class VehicleStatus{
  VehicleStatus({
    this.totalVech,
    this.idealDevices,
    this.noData,
    this.outOfReach,
    this.expireStatus,
    this.offDevices,
    this.runningDevices,
    this.noGpsFixDevices,
  });

  int totalVech;
  int idealDevices;
  int noData;
  int outOfReach;
  int expireStatus;
  int offDevices;
  int runningDevices;
  int noGpsFixDevices;

  factory VehicleStatus.fromJson(Map<String, dynamic> json) => VehicleStatus(
    totalVech: json["Total_Vech"] == null ? null : json["Total_Vech"],
    idealDevices: json["Ideal Devices"] == null ? null : json["Ideal Devices"],
    noData: json["no_data"] == null ? null : json["no_data"],
    outOfReach: json["OutOfReach"] == null ? null : json["OutOfReach"],
    expireStatus: json["expire_status"] == null ? null : json["expire_status"],
    offDevices: json["OFF Devices"] == null ? null : json["OFF Devices"],
    runningDevices: json["running_devices"] == null ? null : json["running_devices"],
    noGpsFixDevices: json["no_gps_fix_devices"] == null ? null : json["no_gps_fix_devices"],
  );

}

class Graph {
  Graph({
    this.name,
    this.value,
    this.colour,
  });

  String name;
  double value;
  String colour;

  factory Graph.fromJson(Map<String, dynamic> json) => Graph(
    name: json["name"] == null ? null : json["name"],
    value: json["value"] == null ? null : json["value"].toDouble(),
    colour: json["colour"] == null ? null : json["colour"],
  );

}
