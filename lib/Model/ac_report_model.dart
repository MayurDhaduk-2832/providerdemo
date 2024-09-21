import 'dart:convert';

List<AcReportsModel> AcReportsModelFromJson(String str) => List<AcReportsModel>.from(json.decode(str).map((x) => AcReportsModel.fromJson(x)));



class AcReportsModel {
  String deviceID;
  String deviceName;
  String workingHours;
  String stopHours;
  List<Ign> ign;
  List<Ac> ac;

  AcReportsModel({this.deviceID, this.deviceName, this.workingHours, this.stopHours, this.ign, this.ac});

  AcReportsModel.fromJson(Map<String, dynamic> json) {
    deviceID = json['Device_ID'];
    deviceName = json['deviceName'];
    workingHours = json['workingHours'];
    stopHours = json['stopHours'];
    if (json['ign'] != null) {
      ign = <Ign>[];
      json['ign'].forEach((v) { ign.add(new Ign.fromJson(v)); });
    }
    if (json['ac'] != null) {
      ac = <Ac>[];
      json['ac'].forEach((v) { ac.add(new Ac.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Device_ID'] = this.deviceID;
    data['deviceName'] = this.deviceName;
    data['workingHours'] = this.workingHours;
    data['stopHours'] = this.stopHours;
    if (this.ign != null) {
      data['ign'] = this.ign.map((v) => v.toJson()).toList();
    }
    if (this.ac != null) {
      data['ac'] = this.ac.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ign {
  String ignSwitch;
  String timestamp;
  String vehicleName;
  String imei;

  Ign({this.ignSwitch, this.timestamp, this.vehicleName, this.imei});

  Ign.fromJson(Map<String, dynamic> json) {
    ignSwitch = json['switch'];
    timestamp = json['timestamp'];
    vehicleName = json['vehicleName'];
    imei = json['imei'];
    }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['switch'] = this.ignSwitch;
    data['timestamp'] = this.timestamp;
    data['vehicleName'] = this.vehicleName;
    data['imei'] = this.imei;
    return data;
  }
}

class Ac {
  String ignSwitch;
  String timestamp;
  String vehicleName;
  String imei;

  Ac({this.ignSwitch, this.timestamp, this.vehicleName, this.imei});

  Ac.fromJson(Map<String, dynamic> json) {
    ignSwitch = json['switch'];
    timestamp = json['timestamp'];
    vehicleName = json['vehicleName'];
    imei = json['imei'];
    }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['switch'] = this.ignSwitch;
    data['timestamp'] = this.timestamp;
    data['vehicleName'] = this.vehicleName;
    data['imei'] = this.imei;
    return data;
  }
}


// class AcReportsModel {
//   AcReportsModel({
//     this.deviceId,
//     this.deviceName,
//     this.workingHours,
//     this.stopHours,
//     this.ign,
//   });
//
//
//   String deviceId;
//   String deviceName;
//   String workingHours;
//   String stopHours;
//   List<Ign> ign;
//
//   factory AcReportsModel.fromJson(Map<String, dynamic> json) => AcReportsModel(
//     deviceId: json["Device_ID"] == null ? null : json["Device_ID"],
//     deviceName: json["deviceName"] == null ? null : json["deviceName"],
//     workingHours: json["workingHours"] == null ? null : json["workingHours"],
//     stopHours: json["stopHours"] == null ? null : json["stopHours"],
//     ign: json["ign"] == null ? null : List<Ign>.from(json["ign"].map((x) => Ign.fromJson(x))),
//   );
//
// }
//
// class Ign {
//   Ign({
//     this.ignSwitch,
//     this.timestamp,
//   });
//
//   String ignSwitch;
//   DateTime timestamp;
//
//   factory Ign.fromJson(Map<String, dynamic> json) => Ign(
//     ignSwitch: json["switch"] == null ? null : json["switch"],
//     timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
//   );
//
// }