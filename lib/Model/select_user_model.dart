// To parse this JSON data, do
//
//     final selectUserModel = selectUserModelFromJson(jsonString);

import 'dart:convert';

List<SelectUserModel> selectUserModelFromJson(String str) => List<SelectUserModel>.from(json.decode(str).map((x) => SelectUserModel.fromJson(x)));

String selectUserModelToJson(List<SelectUserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SelectUserModel {
  SelectUserModel({
    this.id,
    this.hash,
    this.salt,
    this.firstName,
    this.role,
    this.lastName,
    this.email,
    this.orgName,
    this.phone,
    this.v,
    this.emailVerfi,
    this.phoneVerfi,
    this.idEmailVer,
    this.otp,
    this.getNotif,
    this.isDealer,
    this.imei,
    this.os,
    this.deactivatedBy,
    this.activatedBy,
    this.reportInterval,
    this.feedback,
    this.rating,
    this.tripGeneration,
    this.enableSmsNotifications,
    this.pass,
    this.scheduleSchool,
    this.lastLogin,
    this.loginType,
    this.userAgent,
    this.lastActivityOn,
    this.organisationName,
    this.emergencyContact,
    this.announcement,
    this.showAnnouncement,
    this.digitalInput,
    this.labelSetting,
    this.engineCutPsd,
    this.renewalCharges,
    this.relayTimer,
    this.speedLimit,
    this.driverManagement,
    this.outOfReach,
    this.support1,
    this.support2,
    this.dataPullInterval,
    this.bussinessType,
    this.paymentgateway,
    this.kycApproval,
    this.devicePermission,
    this.userPermission,
    this.selfRegister,
    this.relation,
    this.kycStatus,
    this.sosNumbers,
    this.reportConfig,
    this.reportEmailid,
    this.reportLastdate,
    this.timezone,
    this.dashboardColumn,
    this.reportPreference,
    this.userSettings,
    this.imageDoc,
    this.currencyCode,
    this.languageCode,
    this.accountSuspended,
    this.isOrganisation,
    this.isOperator,
    this.dealerAlert,
    this.adminAlert,
    this.custAddPermission,
    this.deviceAddPermission,
    this.isSuperAdmin,
    this.activatedOn,
    this.deactivatedOn,
    this.createdOn,
    this.status,
    this.voiceAlert,
    this.alert,
    this.unitMeasurement,
    this.fuelUnit,
    this.group,
    this.notificationSound,
    this.pushNotification,
    this.poiService,
    this.scheduledExcelReport,
    this.pointSharedOther,
    this.pointAllocated,
    this.dealer,
    this.expireDate,
    this.userId,
    this.ac,
    this.fuel,
    this.geo,
    this.ign,
    this.maxstop,
    this.overspeed,
    this.poi,
    this.power,
    this.route,
    this.sos,
    this.supAdmin,
    this.address,
    this.custumerid,
    this.dealerid,
    this.org,
    this.organisation,
    this.pullData,
    this.lastDataPulledOn,
    this.menuSetting,
    this.deletedUser,
    this.kycVerificationMail,
    this.welcomeMsg,
    this.stdCode,
    this.immobilizeSetting,
    this.parkingSetting,
    this.towSetting,
    this.customerRole,
  });

  String id;
  String hash;
  String salt;
  String firstName;
  String role;
  String lastName;
  String email;
  String orgName;
  String phone;
  int v;
  bool emailVerfi;
  bool phoneVerfi;
  String idEmailVer;
  String otp;
  bool getNotif;
  bool isDealer;
  String imei;
  String os;
  String deactivatedBy;
  String activatedBy;
  String reportInterval;
  String feedback;
  int rating;
  String tripGeneration;
  bool enableSmsNotifications;
  String pass;
  List<dynamic> scheduleSchool;
  DateTime lastLogin;
  String loginType;
  String userAgent;
  DateTime lastActivityOn;
  String organisationName;
  EmergencyContact emergencyContact;
  String announcement;
  bool showAnnouncement;
  int digitalInput;
  bool labelSetting;
  String engineCutPsd;
  int renewalCharges;
  bool relayTimer;
  int speedLimit;
  bool driverManagement;
  String outOfReach;
  String support1;
  String support2;
  int dataPullInterval;
  String bussinessType;
  bool paymentgateway;
  bool kycApproval;
  Permission devicePermission;
  Permission userPermission;
  bool selfRegister;
  dynamic relation;
  String kycStatus;
  List<dynamic> sosNumbers;
  ReportConfig reportConfig;
  List<String> reportEmailid;
  ReportLastdate reportLastdate;
  String timezone;
  DashboardColumn dashboardColumn;
  Map<String, ReportPreference> reportPreference;
  UserSettings userSettings;
  List<dynamic> imageDoc;
  String currencyCode;
  String languageCode;
  bool accountSuspended;
  bool isOrganisation;
  bool isOperator;
  bool dealerAlert;
  bool adminAlert;
  bool custAddPermission;
  bool deviceAddPermission;
  bool isSuperAdmin;
  DateTime activatedOn;
  DateTime deactivatedOn;
  DateTime createdOn;
  bool status;
  bool voiceAlert;
  Map<String, Ac> alert;
  String unitMeasurement;
  String fuelUnit;
  List<String> group;
  bool notificationSound;
  List<dynamic> pushNotification;
  bool poiService;
  bool scheduledExcelReport;
  int pointSharedOther;
  int pointAllocated;
  String dealer;
  DateTime expireDate;
  String userId;
  Ac ac;
  Ac fuel;
  Ac geo;
  Ac ign;
  Ac maxstop;
  Ac overspeed;
  Ac poi;
  Ac power;
  Ac route;
  Ac sos;
  String supAdmin;
  String address;
  String custumerid;
  String dealerid;
  String org;
  String organisation;
  bool pullData;
  DateTime lastDataPulledOn;
  Map<String, bool> menuSetting;
  bool deletedUser;
  bool kycVerificationMail;
  bool welcomeMsg;
  dynamic stdCode;
  bool immobilizeSetting;
  bool parkingSetting;
  bool towSetting;
  String customerRole;

  factory SelectUserModel.fromJson(Map<String, dynamic> json) => SelectUserModel(
    id: json["_id"] == null ? null : json["_id"],
    hash: json["hash"] == null ? null : json["hash"],
    salt: json["salt"] == null ? null : json["salt"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    role: json["role"] == null ? null : json["role"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    email: json["email"] == null ? null : json["email"],
    orgName: json["org_name"] == null ? null : json["org_name"],
    phone: json["phone"] == null ? null : json["phone"],
    v: json["__v"] == null ? null : json["__v"],
    emailVerfi: json["email_verfi"] == null ? null : json["email_verfi"],
    phoneVerfi: json["phone_verfi"] == null ? null : json["phone_verfi"],
    idEmailVer: json["id_email_ver"] == null ? null : json["id_email_ver"],
    otp: json["otp"] == null ? null : json["otp"],
    getNotif: json["GET_notif"] == null ? null : json["GET_notif"],
    isDealer: json["isDealer"] == null ? null : json["isDealer"],
    imei: json["imei"] == null ? null : json["imei"],
    os: json["os"] == null ? null : json["os"],
    deactivatedBy: json["deactivated_by"] == null ? null : json["deactivated_by"],
    activatedBy: json["activated_by"] == null ? null : json["activated_by"],
    reportInterval: json["report_interval"] == null ? null : json["report_interval"],
    feedback: json["feedback"] == null ? null : json["feedback"],
    rating: json["rating"] == null ? null : json["rating"],
    tripGeneration: json["tripGeneration"] == null ? null : json["tripGeneration"],
    enableSmsNotifications: json["enableSmsNotifications"] == null ? null : json["enableSmsNotifications"],
    pass: json["pass"] == null ? null : json["pass"],
    scheduleSchool: json["scheduleSchool"] == null ? null : List<dynamic>.from(json["scheduleSchool"].map((x) => x)),
    lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
    loginType: json["login_type"] == null ? null : json["login_type"],
    userAgent: json["user_agent"] == null ? null : json["user_agent"],
    lastActivityOn: json["last_activity_on"] == null ? null : DateTime.parse(json["last_activity_on"]),
    organisationName: json["organisation_name"] == null ? null : json["organisation_name"],
    emergencyContact: json["emergency_contact"] == null ? null : EmergencyContact.fromJson(json["emergency_contact"]),
    announcement: json["announcement"] == null ? null : json["announcement"],
    showAnnouncement: json["show_announcement"] == null ? null : json["show_announcement"],
    digitalInput: json["digital_input"] == null ? null : json["digital_input"],
    labelSetting: json["label_setting"] == null ? null : json["label_setting"],
    engineCutPsd: json["engine_cut_psd"] == null ? null : json["engine_cut_psd"],
    renewalCharges: json["renewal_charges"] == null ? null : json["renewal_charges"],
    relayTimer: json["relay_timer"] == null ? null : json["relay_timer"],
    speedLimit: json["SpeedLimit"] == null ? null : json["SpeedLimit"],
    driverManagement: json["driverManagement"] == null ? null : json["driverManagement"],
    outOfReach: json["outOfReach"] == null ? null : json["outOfReach"],
    support1: json["support1"] == null ? null : json["support1"],
    support2: json["support2"] == null ? null : json["support2"],
    dataPullInterval: json["DataPullInterval"] == null ? null : json["DataPullInterval"],
    bussinessType: json["bussinessType"] == null ? null : json["bussinessType"],
    paymentgateway: json["paymentgateway"] == null ? null : json["paymentgateway"],
    kycApproval: json["kycApproval"] == null ? null : json["kycApproval"],
    devicePermission: json["devicePermission"] == null ? null : Permission.fromJson(json["devicePermission"]),
    userPermission: json["userPermission"] == null ? null : Permission.fromJson(json["userPermission"]),
    selfRegister: json["selfRegister"] == null ? null : json["selfRegister"],
    relation: json["relation"],
    kycStatus: json["kycStatus"] == null ? null : json["kycStatus"],
    sosNumbers: json["sosNumbers"] == null ? null : List<dynamic>.from(json["sosNumbers"].map((x) => x)),
    reportConfig: json["report_config"] == null ? null : ReportConfig.fromJson(json["report_config"]),
    reportEmailid: json["report_emailid"] == null ? null : List<String>.from(json["report_emailid"].map((x) => x)),
    reportLastdate: json["report_lastdate"] == null ? null : ReportLastdate.fromJson(json["report_lastdate"]),
    timezone: json["timezone"] == null ? null : json["timezone"],
    dashboardColumn: json["dashboard_column"] == null ? null : DashboardColumn.fromJson(json["dashboard_column"]),
    reportPreference: json["report_preference"] == null ? null : Map.from(json["report_preference"]).map((k, v) => MapEntry<String, ReportPreference>(k, ReportPreference.fromJson(v))),
    userSettings: json["user_settings"] == null ? null : UserSettings.fromJson(json["user_settings"]),
    imageDoc: json["imageDoc"] == null ? null : List<dynamic>.from(json["imageDoc"].map((x) => x)),
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    languageCode: json["language_code"] == null ? null : json["language_code"],
    accountSuspended: json["accountSuspended"] == null ? null : json["accountSuspended"],
    isOrganisation: json["isOrganisation"] == null ? null : json["isOrganisation"],
    isOperator: json["isOperator"] == null ? null : json["isOperator"],
    dealerAlert: json["dealerAlert"] == null ? null : json["dealerAlert"],
    adminAlert: json["adminAlert"] == null ? null : json["adminAlert"],
    custAddPermission: json["cust_add_permission"] == null ? null : json["cust_add_permission"],
    deviceAddPermission: json["device_add_permission"] == null ? null : json["device_add_permission"],
    isSuperAdmin: json["isSuperAdmin"] == null ? null : json["isSuperAdmin"],
    activatedOn: json["activated_on"] == null ? null : DateTime.parse(json["activated_on"]),
    deactivatedOn: json["deactivated_on"] == null ? null : DateTime.parse(json["deactivated_on"]),
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
    status: json["status"] == null ? null : json["status"],
    voiceAlert: json["voice_alert"] == null ? null : json["voice_alert"],
    alert: json["alert"] == null ? null : Map.from(json["alert"]).map((k, v) => MapEntry<String, Ac>(k, Ac.fromJson(v))),
    unitMeasurement: json["unit_measurement"] == null ? null : json["unit_measurement"],
    fuelUnit: json["fuel_unit"] == null ? null : json["fuel_unit"],
    group: json["group"] == null ? null : List<String>.from(json["group"].map((x) => x)),
    notificationSound: json["notification_sound"] == null ? null : json["notification_sound"],
    pushNotification: json["pushNotification"] == null ? null : List<dynamic>.from(json["pushNotification"].map((x) => x)),
    poiService: json["poiService"] == null ? null : json["poiService"],
    scheduledExcelReport: json["scheduled_excel_report"] == null ? null : json["scheduled_excel_report"],
    pointSharedOther: json["point_Shared_Other"] == null ? null : json["point_Shared_Other"],
    pointAllocated: json["point_Allocated"] == null ? null : json["point_Allocated"],
    dealer: json["Dealer"] == null ? null : json["Dealer"],
    expireDate: json["expire_date"] == null ? null : DateTime.parse(json["expire_date"]),
    userId: json["user_id"] == null ? null : json["user_id"],
    ac: json["AC"] == null ? null : Ac.fromJson(json["AC"]),
    fuel: json["fuel"] == null ? null : Ac.fromJson(json["fuel"]),
    geo: json["geo"] == null ? null : Ac.fromJson(json["geo"]),
    ign: json["ign"] == null ? null : Ac.fromJson(json["ign"]),
    maxstop: json["maxstop"] == null ? null : Ac.fromJson(json["maxstop"]),
    overspeed: json["overspeed"] == null ? null : Ac.fromJson(json["overspeed"]),
    poi: json["poi"] == null ? null : Ac.fromJson(json["poi"]),
    power: json["power"] == null ? null : Ac.fromJson(json["power"]),
    route: json["route"] == null ? null : Ac.fromJson(json["route"]),
    sos: json["sos"] == null ? null : Ac.fromJson(json["sos"]),
    supAdmin: json["supAdmin"] == null ? null : json["supAdmin"],
    address: json["address"] == null ? null : json["address"],
    custumerid: json["custumerid"] == null ? null : json["custumerid"],
    dealerid: json["dealerid"] == null ? null : json["dealerid"],
    org: json["org"] == null ? null : json["org"],
    organisation: json["organisation"] == null ? null : json["organisation"],
    pullData: json["pullData"] == null ? null : json["pullData"],
    lastDataPulledOn: json["lastDataPulledOn"] == null ? null : DateTime.parse(json["lastDataPulledOn"]),
    menuSetting: json["menu_setting"] == null ? null : Map.from(json["menu_setting"]).map((k, v) => MapEntry<String, bool>(k, v)),
    deletedUser: json["DeletedUser"] == null ? null : json["DeletedUser"],
    kycVerificationMail: json["kyc_verification_mail"] == null ? null : json["kyc_verification_mail"],
    welcomeMsg: json["welcome_msg"] == null ? null : json["welcome_msg"],
    stdCode: json["std_code"],
    immobilizeSetting: json["immobilize_setting"] == null ? null : json["immobilize_setting"],
    parkingSetting: json["parking_setting"] == null ? null : json["parking_setting"],
    towSetting: json["tow_setting"] == null ? null : json["tow_setting"],
    customerRole: json["customer_role"] == null ? null : json["customer_role"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "hash": hash == null ? null : hash,
    "salt": salt == null ? null : salt,
    "first_name": firstName == null ? null : firstName,
    "role": role == null ? null : role,
    "last_name": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "org_name": orgName == null ? null : orgName,
    "phone": phone == null ? null : phone,
    "__v": v == null ? null : v,
    "email_verfi": emailVerfi == null ? null : emailVerfi,
    "phone_verfi": phoneVerfi == null ? null : phoneVerfi,
    "id_email_ver": idEmailVer == null ? null : idEmailVer,
    "otp": otp == null ? null : otp,
    "GET_notif": getNotif == null ? null : getNotif,
    "isDealer": isDealer == null ? null : isDealer,
    "imei": imei == null ? null : imei,
    "os": os == null ? null : os,
    "deactivated_by": deactivatedBy == null ? null : deactivatedBy,
    "activated_by": activatedBy == null ? null : activatedBy,
    "report_interval": reportInterval == null ? null : reportInterval,
    "feedback": feedback == null ? null : feedback,
    "rating": rating == null ? null : rating,
    "tripGeneration": tripGeneration == null ? null : tripGeneration,
    "enableSmsNotifications": enableSmsNotifications == null ? null : enableSmsNotifications,
    "pass": pass == null ? null : pass,
    "scheduleSchool": scheduleSchool == null ? null : List<dynamic>.from(scheduleSchool.map((x) => x)),
    "last_login": lastLogin == null ? null : lastLogin.toIso8601String(),
    "login_type": loginType == null ? null : loginType,
    "user_agent": userAgent == null ? null : userAgent,
    "last_activity_on": lastActivityOn == null ? null : lastActivityOn.toIso8601String(),
    "organisation_name": organisationName == null ? null : organisationName,
    "emergency_contact": emergencyContact == null ? null : emergencyContact.toJson(),
    "announcement": announcement == null ? null : announcement,
    "show_announcement": showAnnouncement == null ? null : showAnnouncement,
    "digital_input": digitalInput == null ? null : digitalInput,
    "label_setting": labelSetting == null ? null : labelSetting,
    "engine_cut_psd": engineCutPsd == null ? null : engineCutPsd,
    "renewal_charges": renewalCharges == null ? null : renewalCharges,
    "relay_timer": relayTimer == null ? null : relayTimer,
    "SpeedLimit": speedLimit == null ? null : speedLimit,
    "driverManagement": driverManagement == null ? null : driverManagement,
    "outOfReach": outOfReach == null ? null : outOfReach,
    "support1": support1 == null ? null : support1,
    "support2": support2 == null ? null : support2,
    "DataPullInterval": dataPullInterval == null ? null : dataPullInterval,
    "bussinessType": bussinessType == null ? null : bussinessType,
    "paymentgateway": paymentgateway == null ? null : paymentgateway,
    "kycApproval": kycApproval == null ? null : kycApproval,
    "devicePermission": devicePermission == null ? null : devicePermission.toJson(),
    "userPermission": userPermission == null ? null : userPermission.toJson(),
    "selfRegister": selfRegister == null ? null : selfRegister,
    "relation": relation,
    "kycStatus": kycStatus == null ? null : kycStatus,
    "sosNumbers": sosNumbers == null ? null : List<dynamic>.from(sosNumbers.map((x) => x)),
    "report_config": reportConfig == null ? null : reportConfig.toJson(),
    "report_emailid": reportEmailid == null ? null : List<dynamic>.from(reportEmailid.map((x) => x)),
    "report_lastdate": reportLastdate == null ? null : reportLastdate.toJson(),
    "timezone": timezone == null ? null : timezone,
    "dashboard_column": dashboardColumn == null ? null : dashboardColumn.toJson(),
    "report_preference": reportPreference == null ? null : Map.from(reportPreference).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "user_settings": userSettings == null ? null : userSettings.toJson(),
    "imageDoc": imageDoc == null ? null : List<dynamic>.from(imageDoc.map((x) => x)),
    "currency_code": currencyCode == null ? null : currencyCode,
    "language_code": languageCode == null ? null : languageCode,
    "accountSuspended": accountSuspended == null ? null : accountSuspended,
    "isOrganisation": isOrganisation == null ? null : isOrganisation,
    "isOperator": isOperator == null ? null : isOperator,
    "dealerAlert": dealerAlert == null ? null : dealerAlert,
    "adminAlert": adminAlert == null ? null : adminAlert,
    "cust_add_permission": custAddPermission == null ? null : custAddPermission,
    "device_add_permission": deviceAddPermission == null ? null : deviceAddPermission,
    "isSuperAdmin": isSuperAdmin == null ? null : isSuperAdmin,
    "activated_on": activatedOn == null ? null : activatedOn.toIso8601String(),
    "deactivated_on": deactivatedOn == null ? null : deactivatedOn.toIso8601String(),
    "created_on": createdOn == null ? null : createdOn.toIso8601String(),
    "status": status == null ? null : status,
    "voice_alert": voiceAlert == null ? null : voiceAlert,
    "alert": alert == null ? null : Map.from(alert).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "unit_measurement": unitMeasurement == null ? null : unitMeasurement,
    "fuel_unit": fuelUnit == null ? null : fuelUnit,
    "group": group == null ? null : List<dynamic>.from(group.map((x) => x)),
    "notification_sound": notificationSound == null ? null : notificationSound,
    "pushNotification": pushNotification == null ? null : List<dynamic>.from(pushNotification.map((x) => x)),
    "poiService": poiService == null ? null : poiService,
    "scheduled_excel_report": scheduledExcelReport == null ? null : scheduledExcelReport,
    "point_Shared_Other": pointSharedOther == null ? null : pointSharedOther,
    "point_Allocated": pointAllocated == null ? null : pointAllocated,
    "Dealer": dealer == null ? null : dealer,
    "expire_date": expireDate == null ? null : expireDate.toIso8601String(),
    "user_id": userId == null ? null : userId,
    "AC": ac == null ? null : ac.toJson(),
    "fuel": fuel == null ? null : fuel.toJson(),
    "geo": geo == null ? null : geo.toJson(),
    "ign": ign == null ? null : ign.toJson(),
    "maxstop": maxstop == null ? null : maxstop.toJson(),
    "overspeed": overspeed == null ? null : overspeed.toJson(),
    "poi": poi == null ? null : poi.toJson(),
    "power": power == null ? null : power.toJson(),
    "route": route == null ? null : route.toJson(),
    "sos": sos == null ? null : sos.toJson(),
    "supAdmin": supAdmin == null ? null : supAdmin,
    "address": address == null ? null : address,
    "custumerid": custumerid == null ? null : custumerid,
    "dealerid": dealerid == null ? null : dealerid,
    "org": org == null ? null : org,
    "organisation": organisation == null ? null : organisation,
    "pullData": pullData == null ? null : pullData,
    "lastDataPulledOn": lastDataPulledOn == null ? null : lastDataPulledOn.toIso8601String(),
    "menu_setting": menuSetting == null ? null : Map.from(menuSetting).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "DeletedUser": deletedUser == null ? null : deletedUser,
    "kyc_verification_mail": kycVerificationMail == null ? null : kycVerificationMail,
    "welcome_msg": welcomeMsg == null ? null : welcomeMsg,
    "std_code": stdCode,
    "immobilize_setting": immobilizeSetting == null ? null : immobilizeSetting,
    "parking_setting": parkingSetting == null ? null : parkingSetting,
    "tow_setting": towSetting == null ? null : towSetting,
    "customer_role": customerRole == null ? null : customerRole,
  };
}

class Ac {
  Ac({
    this.smsStatus,
    this.emailStatus,
    this.notifStatus,
    this.priority,
    this.emails,
    this.phones,
    this.sound,
    this.phone,
  });

  bool smsStatus;
  bool emailStatus;
  bool notifStatus;
  int priority;
  List<String> emails;
  List<String> phones;
  String sound;
  List<dynamic> phone;

  factory Ac.fromJson(Map<String, dynamic> json) => Ac(
    smsStatus: json["sms_status"] == null ? null : json["sms_status"],
    emailStatus: json["email_status"] == null ? null : json["email_status"],
    notifStatus: json["notif_status"] == null ? null : json["notif_status"],
    priority: json["priority"] == null ? null : json["priority"],
    emails: json["emails"] == null ? null : List<String>.from(json["emails"].map((x) => x)),
    phones: json["phones"] == null ? null : List<String>.from(json["phones"].map((x) => x)),
    sound: json["sound"] == null ? null : json["sound"],
    phone: json["phone"] == null ? null : List<dynamic>.from(json["phone"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "sms_status": smsStatus == null ? null : smsStatus,
    "email_status": emailStatus == null ? null : emailStatus,
    "notif_status": notifStatus == null ? null : notifStatus,
    "priority": priority == null ? null : priority,
    "emails": emails == null ? null : List<dynamic>.from(emails.map((x) => x)),
    "phones": phones == null ? null : List<dynamic>.from(phones.map((x) => x)),
    "sound": sound == null ? null : sound,
    "phone": phone == null ? null : List<dynamic>.from(phone.map((x) => x)),
  };
}

class DashboardColumn {
  DashboardColumn({
    this.chargingColumn,
    this.tempColumn,
    this.doorColumn,
    this.extVolt,
    this.ignitionColumn,
    this.gsmColumn,
    this.powerColumn,
    this.acColumn,
    this.gpsColumn,
    this.ignitionLock,
  });

  bool chargingColumn;
  bool tempColumn;
  bool doorColumn;
  bool extVolt;
  bool ignitionColumn;
  bool gsmColumn;
  bool powerColumn;
  bool acColumn;
  bool gpsColumn;
  bool ignitionLock;

  factory DashboardColumn.fromJson(Map<String, dynamic> json) => DashboardColumn(
    chargingColumn: json["charging_column"] == null ? null : json["charging_column"],
    tempColumn: json["temp_column"] == null ? null : json["temp_column"],
    doorColumn: json["door_column"] == null ? null : json["door_column"],
    extVolt: json["ext_volt"] == null ? null : json["ext_volt"],
    ignitionColumn: json["ignition_column"] == null ? null : json["ignition_column"],
    gsmColumn: json["gsm_column"] == null ? null : json["gsm_column"],
    powerColumn: json["power_column"] == null ? null : json["power_column"],
    acColumn: json["ac_column"] == null ? null : json["ac_column"],
    gpsColumn: json["gps_column"] == null ? null : json["gps_column"],
    ignitionLock: json["ignitionLock"] == null ? null : json["ignitionLock"],
  );

  Map<String, dynamic> toJson() => {
    "charging_column": chargingColumn == null ? null : chargingColumn,
    "temp_column": tempColumn == null ? null : tempColumn,
    "door_column": doorColumn == null ? null : doorColumn,
    "ext_volt": extVolt == null ? null : extVolt,
    "ignition_column": ignitionColumn == null ? null : ignitionColumn,
    "gsm_column": gsmColumn == null ? null : gsmColumn,
    "power_column": powerColumn == null ? null : powerColumn,
    "ac_column": acColumn == null ? null : acColumn,
    "gps_column": gpsColumn == null ? null : gpsColumn,
    "ignitionLock": ignitionLock == null ? null : ignitionLock,
  };
}

class Permission {
  Permission({
    this.delete,
    this.edit,
    this.add,
  });

  bool delete;
  bool edit;
  bool add;

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
    delete: json["Delete"] == null ? null : json["Delete"],
    edit: json["Edit"] == null ? null : json["Edit"],
    add: json["Add"] == null ? null : json["Add"],
  );

  Map<String, dynamic> toJson() => {
    "Delete": delete == null ? null : delete,
    "Edit": edit == null ? null : edit,
    "Add": add == null ? null : add,
  };
}

class EmergencyContact {
  EmergencyContact({
    this.contact2,
    this.contact1,
  });

  Contact contact2;
  Contact contact1;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) => EmergencyContact(
    contact2: json["contact2"] == null ? null : Contact.fromJson(json["contact2"]),
    contact1: json["contact1"] == null ? null : Contact.fromJson(json["contact1"]),
  );

  Map<String, dynamic> toJson() => {
    "contact2": contact2 == null ? null : contact2.toJson(),
    "contact1": contact1 == null ? null : contact1.toJson(),
  };
}

class Contact {
  Contact({
    this.phone2,
    this.phone1,
    this.name,
    this.cell2,
    this.cell1,
  });

  String phone2;
  String phone1;
  String name;
  String cell2;
  String cell1;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    phone2: json["phone2"] == null ? null : json["phone2"],
    phone1: json["phone1"] == null ? null : json["phone1"],
    name: json["name"] == null ? null : json["name"],
    cell2: json["cell2"] == null ? null : json["cell2"],
    cell1: json["cell1"] == null ? null : json["cell1"],
  );

  Map<String, dynamic> toJson() => {
    "phone2": phone2 == null ? null : phone2,
    "phone1": phone1 == null ? null : phone1,
    "name": name == null ? null : name,
    "cell2": cell2 == null ? null : cell2,
    "cell1": cell1 == null ? null : cell1,
  };
}

class ImageDocClass {
  ImageDocClass({
    this.url,
    this.type,
    this.headers,
    this.statusText,
    this.ok,
    this.status,
    this.body,
    this.doctype,
    this.image,
    this.phone,
    this.ext,
  });

  String url;
  int type;
  Headers headers;
  String statusText;
  bool ok;
  int status;
  String body;
  String doctype;
  String image;
  String phone;
  String ext;

  factory ImageDocClass.fromJson(Map<String, dynamic> json) => ImageDocClass(
    url: json["url"] == null ? null : json["url"],
    type: json["type"] == null ? null : json["type"],
    headers: json["headers"] == null ? null : Headers.fromJson(json["headers"]),
    statusText: json["statusText"] == null ? null : json["statusText"],
    ok: json["ok"] == null ? null : json["ok"],
    status: json["status"] == null ? null : json["status"],
    body: json["_body"] == null ? null : json["_body"],
    doctype: json["doctype"] == null ? null : json["doctype"],
    image: json["image"] == null ? null : json["image"],
    phone: json["phone"] == null ? null : json["phone"],
    ext: json["ext"] == null ? null : json["ext"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "type": type == null ? null : type,
    "headers": headers == null ? null : headers.toJson(),
    "statusText": statusText == null ? null : statusText,
    "ok": ok == null ? null : ok,
    "status": status == null ? null : status,
    "_body": body == null ? null : body,
    "doctype": doctype == null ? null : doctype,
    "image": image == null ? null : image,
    "phone": phone == null ? null : phone,
    "ext": ext == null ? null : ext,
  };
}

class Headers {
  Headers({
    this.contentType,
  });

  List<String> contentType;

  factory Headers.fromJson(Map<String, dynamic> json) => Headers(
    contentType: json["content-type"] == null ? null : List<String>.from(json["content-type"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "content-type": contentType == null ? null : List<dynamic>.from(contentType.map((x) => x)),
  };
}

class ReportConfig {
  ReportConfig({
    this.daily,
    this.distance,
    this.sos,
    this.fuel,
    this.summary,
    this.trip,
    this.stoppage,
    this.geofencing,
    this.rViolation,
    this.ignition,
    this.overspeed,
  });

  bool daily;
  bool distance;
  bool sos;
  bool fuel;
  bool summary;
  bool trip;
  bool stoppage;
  bool geofencing;
  bool rViolation;
  bool ignition;
  bool overspeed;

  factory ReportConfig.fromJson(Map<String, dynamic> json) => ReportConfig(
    daily: json["Daily"] == null ? null : json["Daily"],
    distance: json["Distance"] == null ? null : json["Distance"],
    sos: json["sos"] == null ? null : json["sos"],
    fuel: json["fuel"] == null ? null : json["fuel"],
    summary: json["summary"] == null ? null : json["summary"],
    trip: json["trip"] == null ? null : json["trip"],
    stoppage: json["stoppage"] == null ? null : json["stoppage"],
    geofencing: json["Geofencing"] == null ? null : json["Geofencing"],
    rViolation: json["rViolation"] == null ? null : json["rViolation"],
    ignition: json["ignition"] == null ? null : json["ignition"],
    overspeed: json["overspeed"] == null ? null : json["overspeed"],
  );

  Map<String, dynamic> toJson() => {
    "Daily": daily == null ? null : daily,
    "Distance": distance == null ? null : distance,
    "sos": sos == null ? null : sos,
    "fuel": fuel == null ? null : fuel,
    "summary": summary == null ? null : summary,
    "trip": trip == null ? null : trip,
    "stoppage": stoppage == null ? null : stoppage,
    "Geofencing": geofencing == null ? null : geofencing,
    "rViolation": rViolation == null ? null : rViolation,
    "ignition": ignition == null ? null : ignition,
    "overspeed": overspeed == null ? null : overspeed,
  };
}

class ReportLastdate {
  ReportLastdate({
    this.stoppage,
    this.summary,
    this.overspeed,
    this.ignition,
    this.rViolation,
    this.geofencing,
    this.trip,
    this.fuel,
  });

  DateTime stoppage;
  DateTime summary;
  DateTime overspeed;
  DateTime ignition;
  DateTime rViolation;
  DateTime geofencing;
  DateTime trip;
  DateTime fuel;

  factory ReportLastdate.fromJson(Map<String, dynamic> json) => ReportLastdate(
    stoppage: json["stoppage"] == null ? null : DateTime.parse(json["stoppage"]),
    summary: json["summary"] == null ? null : DateTime.parse(json["summary"]),
    overspeed: json["overspeed"] == null ? null : DateTime.parse(json["overspeed"]),
    ignition: json["ignition"] == null ? null : DateTime.parse(json["ignition"]),
    rViolation: json["rViolation"] == null ? null : DateTime.parse(json["rViolation"]),
    geofencing: json["Geofencing"] == null ? null : DateTime.parse(json["Geofencing"]),
    trip: json["trip"] == null ? null : DateTime.parse(json["trip"]),
    fuel: json["fuel"] == null ? null : DateTime.parse(json["fuel"]),
  );

  Map<String, dynamic> toJson() => {
    "stoppage": stoppage == null ? null : stoppage.toIso8601String(),
    "summary": summary == null ? null : summary.toIso8601String(),
    "overspeed": overspeed == null ? null : overspeed.toIso8601String(),
    "ignition": ignition == null ? null : ignition.toIso8601String(),
    "rViolation": rViolation == null ? null : rViolation.toIso8601String(),
    "Geofencing": geofencing == null ? null : geofencing.toIso8601String(),
    "trip": trip == null ? null : trip.toIso8601String(),
    "fuel": fuel == null ? null : fuel.toIso8601String(),
  };
}

class ReportPreference {
  ReportPreference({
    this.rstatus,
    this.astatus,
  });

  bool rstatus;
  bool astatus;

  factory ReportPreference.fromJson(Map<String, dynamic> json) => ReportPreference(
    rstatus: json["Rstatus"] == null ? null : json["Rstatus"],
    astatus: json["Astatus"] == null ? null : json["Astatus"],
  );

  Map<String, dynamic> toJson() => {
    "Rstatus": rstatus == null ? null : rstatus,
    "Astatus": astatus == null ? null : astatus,
  };
}

class StdCodeClass {
  StdCodeClass({
    this.dialcode,
    this.countryCode,
  });

  String dialcode;
  String countryCode;

  factory StdCodeClass.fromJson(Map<String, dynamic> json) => StdCodeClass(
    dialcode: json["dialcode"] == null ? null : json["dialcode"],
    countryCode: json["countryCode"] == null ? null : json["countryCode"],
  );

  Map<String, dynamic> toJson() => {
    "dialcode": dialcode == null ? null : dialcode,
    "countryCode": countryCode == null ? null : countryCode,
  };
}

class UserSettings {
  UserSettings({
    this.sateliteValue,
    this.zoomLevel,
    this.errorMessage,
    this.errorCode,
    this.relayTimer,
    this.satelite,
    this.temp,
    this.fuel,
    this.parking,
    this.tow,
    this.share,
    this.immoblizer,
    this.door,
    this.ac,
  });

  dynamic sateliteValue;
  dynamic zoomLevel;
  bool errorMessage;
  bool errorCode;
  bool relayTimer;
  bool satelite;
  bool temp;
  bool fuel;
  bool parking;
  bool tow;
  bool share;
  bool immoblizer;
  bool door;
  bool ac;

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
    sateliteValue: json["sateliteValue"],
    zoomLevel: json["zoomLevel"],
    errorMessage: json["errorMessage"] == null ? null : json["errorMessage"],
    errorCode: json["errorCode"] == null ? null : json["errorCode"],
    relayTimer: json["relay_timer"] == null ? null : json["relay_timer"],
    satelite: json["satelite"] == null ? null : json["satelite"],
    temp: json["temp"] == null ? null : json["temp"],
    fuel: json["fuel"] == null ? null : json["fuel"],
    parking: json["parking"] == null ? null : json["parking"],
    tow: json["tow"] == null ? null : json["tow"],
    share: json["share"] == null ? null : json["share"],
    immoblizer: json["immoblizer"] == null ? null : json["immoblizer"],
    door: json["door"] == null ? null : json["door"],
    ac: json["ac"] == null ? null : json["ac"],
  );

  Map<String, dynamic> toJson() => {
    "sateliteValue": sateliteValue,
    "zoomLevel": zoomLevel,
    "errorMessage": errorMessage == null ? null : errorMessage,
    "errorCode": errorCode == null ? null : errorCode,
    "relay_timer": relayTimer == null ? null : relayTimer,
    "satelite": satelite == null ? null : satelite,
    "temp": temp == null ? null : temp,
    "fuel": fuel == null ? null : fuel,
    "parking": parking == null ? null : parking,
    "tow": tow == null ? null : tow,
    "share": share == null ? null : share,
    "immoblizer": immoblizer == null ? null : immoblizer,
    "door": door == null ? null : door,
    "ac": ac == null ? null : ac,
  };
}
