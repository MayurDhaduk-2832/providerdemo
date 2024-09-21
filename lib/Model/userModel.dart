import 'dart:convert';

UseModel useModelFromJson(String str) => UseModel.fromJson(json.decode(str));


class UseModel {
  UseModel({
    this.cust,
    this.custumerToken,
  });

  Cust cust;
  String custumerToken;

  factory UseModel.fromJson(Map<String, dynamic> json) => UseModel(
    cust: json["cust"] == null ? null : Cust.fromJson(json["cust"]),
    custumerToken: json["custumer_token"] == null ? null : json["custumer_token"],
  );
}

class Cust {
  Cust({
    this.id,
    this.engineCutPsd,
    this.pass,
    this.hash,
    this.salt,
    this.firstName,
    this.lastName,
    this.phone,
    this.supAdmin,
    this.email,
    this.emailVerfi,
    this.phoneVerfi,
    this.isDealer,
    this.pullData,
    this.dealer,
    this.custumerid,
    this.userId,
    this.address,
    this.expireDate,
    this.stdCode,
    this.v,
    this.lastActivityOn,
    this.lastLogin,
    this.loginType,
    this.userAgent,
    this.lastDataPulledOn,
    this.getNotif,
    this.orgName,
    this.apiKey,
    this.tripGeneration,
    this.digitalInput,
    this.showAnnouncement,
    this.labelSetting,
    this.immobilizeSetting,
    this.parkingSetting,
    this.towSetting,
    this.driverManagement,
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
  });

  String id;
  String engineCutPsd;
  String pass;
  String hash;
  String salt;
  String firstName;
  String lastName;
  String phone;
  String supAdmin;
  String email;
  bool emailVerfi;
  bool phoneVerfi;
  bool isDealer;
  bool pullData;
  Dealer dealer;
  String custumerid;
  String userId;
  dynamic address;
  DateTime expireDate;
  dynamic stdCode;
  int v;
  DateTime lastActivityOn;
  DateTime lastLogin;
  String loginType;
  String userAgent;
  DateTime lastDataPulledOn;
  bool getNotif;
  String orgName;
  String apiKey;
  String tripGeneration;
  String digitalInput;
  bool showAnnouncement;
  bool labelSetting;
  bool immobilizeSetting;
  dynamic parkingSetting;
  dynamic towSetting;
  bool driverManagement;
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
  Map<String, Alert> alert;
  String unitMeasurement;
  String fuelUnit;
  List<String> group;
  bool notificationSound;
  List<PushNotification> pushNotification;
  bool poiService;
  bool scheduledExcelReport;
  int pointSharedOther;
  int pointAllocated;

  factory Cust.fromJson(Map<String, dynamic> json) => Cust(
    id: json["_id"] == null ? null : json["_id"],
    engineCutPsd: json["engine_cut_psd"] == null ? null : json["engine_cut_psd"],
    pass: json["pass"] == null ? null : json["pass"],
    hash: json["hash"] == null ? null : json["hash"],
    salt: json["salt"] == null ? null : json["salt"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    phone: json["phone"] == null ? null : json["phone"],
    supAdmin: json["supAdmin"] == null ? null : json["supAdmin"],
    email: json["email"] == null ? null : json["email"],
    emailVerfi: json["email_verfi"] == null ? null : json["email_verfi"],
    phoneVerfi: json["phone_verfi"] == null ? null : json["phone_verfi"],
    isDealer: json["isDealer"] == null ? null : json["isDealer"],
    pullData: json["pullData"] == null ? null : json["pullData"],
    dealer: json["Dealer"] == null ? null : Dealer.fromJson(json["Dealer"]),
    custumerid: json["custumerid"] == null ? null : json["custumerid"],
    userId: json["user_id"] == null ? null : json["user_id"],
    address: json["address"] == null ? " " : json["address"],
    expireDate: json["expire_date"] == null ? null : DateTime.parse(json["expire_date"]),
    stdCode: json["std_code"] == null ? null : json["std_code"],
    v: json["__v"] == null ? null : json["__v"],
    lastActivityOn: json["last_activity_on"] == null ? null : DateTime.parse(json["last_activity_on"]),
    lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
    loginType: json["login_type"] == null ? null : json["login_type"],
    userAgent: json["user_agent"] == null ? null : json["user_agent"],
    lastDataPulledOn: json["lastDataPulledOn"] == null ? null : DateTime.parse(json["lastDataPulledOn"]),
    getNotif: json["GET_notif"] == null ? null : json["GET_notif"],
    orgName: json["org_name"] == null ? null : json["org_name"],
    apiKey: json["api_key"] == null ? null : json["api_key"],
    tripGeneration: json["tripGeneration"] == null ? null : json["tripGeneration"],
    digitalInput: json["digital_input"] == null ? "" : json["digital_input"].toString(),
    showAnnouncement: json["show_announcement"] == null ? null : json["show_announcement"],
    labelSetting: json["label_setting"] == null ? false : json["label_setting"],
    immobilizeSetting: json["immobilize_setting"] == null ? null : json["immobilize_setting"],
    parkingSetting: json["parking_setting"],
    towSetting: json["tow_setting"],
    driverManagement: json["driverManagement"] == null ? false : json["driverManagement"],
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
    reportEmailid: json["report_emailid"] == null ? null : List<String>.from(json["report_emailid"].map((x) => x == null ? null : x)),
    reportLastdate: json["report_lastdate"] == null ? null : ReportLastdate.fromJson(json["report_lastdate"]),
    timezone: json["timezone"] == null ? null : json["timezone"],
    dashboardColumn: json["dashboard_column"] == null ? null : DashboardColumn.fromJson(json["dashboard_column"]),
    reportPreference: json["report_preference"] == null ? null : Map.from(json["report_preference"]).map((k, v) => MapEntry<String, ReportPreference>(k, ReportPreference.fromJson(v))),
    userSettings: json["user_settings"] == null ? null : UserSettings.fromJson(json["user_settings"]),
    imageDoc: json["imageDoc"] == null ? null : List<dynamic>.from(json["imageDoc"].map((x) => x)),
    currencyCode: json["currency_code"] == null ? "INR" : json["currency_code"],
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
    alert: json["alert"] == null ? null : Map.from(json["alert"]).map((k, v) => MapEntry<String, Alert>(k, Alert.fromJson(v))),
    unitMeasurement: json["unit_measurement"] == null ? null : json["unit_measurement"],
    fuelUnit: json["fuel_unit"] == null ? null : json["fuel_unit"],
    group: json["group"] == null ? null : List<String>.from(json["group"].map((x) => x)),
    notificationSound: json["notification_sound"] == null ? null : json["notification_sound"],
    pushNotification: json["pushNotification"] == null ? null : List<PushNotification>.from(json["pushNotification"].map((x) => PushNotification.fromJson(x))),
    poiService: json["poiService"] == null ? null : json["poiService"],
    scheduledExcelReport: json["scheduled_excel_report"] == null ? null : json["scheduled_excel_report"],
    pointSharedOther: json["point_Shared_Other"] == null ? null : json["point_Shared_Other"],
    pointAllocated: json["point_Allocated"] == null ? null : json["point_Allocated"],
  );

}

class Alert {
  Alert({
    this.emailStatus,
    this.smsStatus,
    this.notifStatus,
    this.priority,
    this.emails,
    this.phones,
  });

  bool emailStatus;
  bool smsStatus;
  bool notifStatus;
  int priority;
  List<dynamic> emails;
  List<dynamic> phones;

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    emailStatus: json["email_status"] == null ? null : json["email_status"],
    smsStatus: json["sms_status"] == null ? null : json["sms_status"],
    notifStatus: json["notif_status"] == null ? null : json["notif_status"],
    priority: json["priority"] == null ? null : json["priority"],
    emails: json["emails"] == null ? null : List<dynamic>.from(json["emails"].map((x) => x)),
    phones: json["phones"] == null ? null : List<dynamic>.from(json["phones"].map((x) => x)),
  );
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
}

class Dealer {
  Dealer({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  String id;
  String firstName;
  String lastName;
  String email;
  String phone;

  factory Dealer.fromJson(Map<String, dynamic> json) => Dealer(
    id: json["_id"] == null ? null : json["_id"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
  );

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
}

class PushNotification {
  PushNotification({
    this.os,
    this.token,
  });

  String os;
  String token;

  factory PushNotification.fromJson(Map<String, dynamic> json) => PushNotification(
    os: json["os"] == null ? null : json["os"],
    token: json["token"] == null ? null : json["token"],
  );

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
}

class ReportLastdate {
  ReportLastdate({
    this.stoppage,
    this.geofencing,
    this.rViolation,
    this.ignition,
    this.overspeed,
    this.trip,
  });

  DateTime stoppage;
  DateTime geofencing;
  DateTime rViolation;
  DateTime ignition;
  DateTime overspeed;
  DateTime trip;

  factory ReportLastdate.fromJson(Map<String, dynamic> json) => ReportLastdate(
    stoppage: json["stoppage"] == null ? null : DateTime.parse(json["stoppage"]),
    geofencing: json["Geofencing"] == null ? null : DateTime.parse(json["Geofencing"]),
    rViolation: json["rViolation"] == null ? null : DateTime.parse(json["rViolation"]),
    ignition: json["ignition"] == null ? null : DateTime.parse(json["ignition"]),
    overspeed: json["overspeed"] == null ? null : DateTime.parse(json["overspeed"]),
    trip: json["trip"] == null ? null : DateTime.parse(json["trip"]),
  );
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
}

class UserSettings {
  UserSettings({
    this.sateliteValue,
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

  int sateliteValue;
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
    sateliteValue: json["sateliteValue"] == null ? null : json["sateliteValue"],
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
}

