// To parse this JSON data, do
//
//     final getUserSettingsModel = getUserSettingsModelFromJson(jsonString);

import 'dart:convert';

GetUserSettingsModel getUserSettingsModelFromJson(String str) => GetUserSettingsModel.fromJson(json.decode(str));

class GetUserSettingsModel {
  GetUserSettingsModel({
    this.languageCode,
    this.fuelUnit,
    this.notificationSound,
    this.engineCutPsd,
    this.voiceAlert,
    this.currencyCode,
    this.unitMeasurement,
    this.timezone,
    this.adminAlert,
    this.announcement,
    this.showAnnouncement,
    this.isSuperAdmin,
    this.isDealer,
    this.digitalInput,
    this.selfRegister,
    this.support1,
    this.support2,
    this.service1,
    this.service2,
    this.service,
    this.support,
    this.paymentgateway,
    this.bussinessType,
  });

  String languageCode;
  String fuelUnit;
  bool notificationSound;
  String engineCutPsd;
  bool voiceAlert;
  String currencyCode;
  String unitMeasurement;
  String timezone;
  bool adminAlert;
  String announcement;
  bool showAnnouncement;
  bool isSuperAdmin;
  bool isDealer;
  int digitalInput;
  bool selfRegister;
  String support1;
  String support2;
  String service1;
  String service2;
  List<String> service;
  List<String> support;
  bool paymentgateway;
  String bussinessType;

  factory GetUserSettingsModel.fromJson(Map<String, dynamic> json) => GetUserSettingsModel(
    languageCode: json["language_code"] == null ? null : json["language_code"],
    fuelUnit: json["fuel_unit"] == null ? null : json["fuel_unit"],
    notificationSound: json["notification_sound"] == null ? null : json["notification_sound"],
    engineCutPsd: json["engine_cut_psd"] == null ? null : json["engine_cut_psd"],
    voiceAlert: json["voice_alert"] == null ? null : json["voice_alert"],
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    unitMeasurement: json["unit_measurement"] == null ? null : json["unit_measurement"],
    timezone: json["timezone"] == null ? null : json["timezone"],
    adminAlert: json["adminAlert"] == null ? null : json["adminAlert"],
    announcement: json["announcement"] == null ? null : json["announcement"],
    showAnnouncement: json["show_announcement"] == null ? null : json["show_announcement"],
    isSuperAdmin: json["isSuperAdmin"] == null ? null : json["isSuperAdmin"],
    isDealer: json["isDealer"] == null ? null : json["isDealer"],
    digitalInput: json["digital_input"] == null ? null : json["digital_input"],
    selfRegister: json["selfRegister"] == null ? null : json["selfRegister"],
    support1: json["support1"] == null ? null : json["support1"],
    support2: json["support2"] == null ? null : json["support2"],
    service1: json["service1"] == null ? null : json["service1"],
    service2: json["service2"] == null ? null : json["service2"],
    service: json["Service"] == null ? null : List<String>.from(json["Service"].map((x) => x)),
    support: json["Support"] == null ? null : List<String>.from(json["Support"].map((x) => x)),
    paymentgateway: json["paymentgateway"] == null ? null : json["paymentgateway"],
    bussinessType: json["bussinessType"] == null ? null : json["bussinessType"],
  );

}
