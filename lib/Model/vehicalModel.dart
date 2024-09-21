import 'dart:convert';

List<VehicleModels> vehicleModelsFromJson(String str) => List<VehicleModels>.from(json.decode(str).map((x) => VehicleModels.fromJson(x)));

class VehicleModels {
  VehicleModels({
    this.id,
    this.deviceType,
    this.configurationCommand,
    this.locationCommand,
    this.immoblizerCommand,
    this.resetCommand,
    this.resumeCommand,
    this.deviceTimezone,
    this.deviceApn,
    this.deviceport,
    this.v,
    this.smsTimezone,
    this.smsApn,
    this.smsIp,
    this.imobliserType,
    this.manufacturer,
    this.smsReset,
  });

  String id;
  String deviceType;
  String configurationCommand;
  String locationCommand;
  String immoblizerCommand;
  String resetCommand;
  String resumeCommand;
  String deviceTimezone;
  String deviceApn;
  int deviceport;
  int v;
  String smsTimezone;
  String smsApn;
  String smsIp;
  int imobliserType;
  String manufacturer;
  String smsReset;

  factory VehicleModels.fromJson(Map<String, dynamic> json) => VehicleModels(
    id: json["_id"] == null ? "" : json["_id"],
    deviceType: json["device_type"] == null ? "" : json["device_type"],
    configurationCommand: json["configuration_command"] == null ? "" : json["configuration_command"],
    locationCommand: json["location_command"] == null ? "" : json["location_command"],
    immoblizerCommand: json["immoblizer_command"] == null ? "" : json["immoblizer_command"],
    resetCommand: json["reset_command"] == null ? "" : json["reset_command"],
    resumeCommand: json["resume_command"] == null ? "" : json["resume_command"],
    deviceTimezone: json["device_timezone"] == null ? "" : json["device_timezone"],
    deviceApn: json["device_apn"] == null ? "" : json["device_apn"],
    deviceport: json["deviceport"] == null ? 0 : json["deviceport"],
    v: json["__v"] == null ? 0 : json["__v"],
    smsTimezone: json["sms_timezone"] == null ? "" : json["sms_timezone"],
    smsApn: json["sms_apn"] == null ? "" : json["sms_apn"],
    smsIp: json["sms_ip"] == null ? "" : json["sms_ip"],
    imobliserType: json["imobliser_type"] == null ? 0 : json["imobliser_type"],
    manufacturer: json["Manufacturer"] == null ? "" : json["Manufacturer"],
    smsReset: json["sms_reset"] == null ? "" : json["sms_reset"],
  );

}
