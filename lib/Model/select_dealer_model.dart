// To parse this JSON data, do
//
//     final selectDealerModel = selectDealerModelFromJson(jsonString);

import 'dart:convert';

List<SelectDealerModel> selectDealerModelFromJson(String str) => List<SelectDealerModel>.from(json.decode(str).map((x) => SelectDealerModel.fromJson(x)));

String selectDealerModelToJson(List<SelectDealerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SelectDealerModel {
  SelectDealerModel({
    this.id,
    this.pass,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.userId,
    this.expireDate,
    this.stdCode,
    this.customerRole,
    this.imageDoc,
    this.accountSuspended,
    this.custAddPermission,
    this.deviceAddPermission,
    this.createdOn,
    this.status,
    this.pointSharedOther,
    this.pointAllocated,
    this.lastLogin,
    this.loginType,
    this.lastActivityOn,
    this.totalVehicle,
    this.delDevices,
    this.notificationTokenCount,
    this.address,
  });

  String id;
  String pass;
  String firstName;
  String lastName;
  String email;
  String phone;
  String userId;
  DateTime expireDate;
  StdCode stdCode;
  String customerRole;
  List<String> imageDoc;
  bool accountSuspended;
  bool custAddPermission;
  bool deviceAddPermission;
  DateTime createdOn;
  bool status;
  int pointSharedOther;
  int pointAllocated;
  DateTime lastLogin;
  String loginType;
  DateTime lastActivityOn;
  int totalVehicle;
  int delDevices;
  int notificationTokenCount;
  String address;

  factory SelectDealerModel.fromJson(Map<String, dynamic> json) => SelectDealerModel(
    id: json["_id"] == null ? null : json["_id"],
    pass: json["pass"] == null ? null : json["pass"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    userId: json["user_id"] == null ? null : json["user_id"],
    expireDate: json["expire_date"] == null ? null : DateTime.parse(json["expire_date"]),
  //  stdCode: json["std_code"] == null ? null : StdCode.fromJson(json["std_code"]),
    customerRole: json["customer_role"] == null ? null : json["customer_role"],
    accountSuspended: json["accountSuspended"] == null ? null : json["accountSuspended"],
    custAddPermission: json["cust_add_permission"] == null ? null : json["cust_add_permission"],
    deviceAddPermission: json["device_add_permission"] == null ? null : json["device_add_permission"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
    status: json["status"] == null ? null : json["status"],
    pointSharedOther: json["point_Shared_Other"] == null ? null : json["point_Shared_Other"],
    pointAllocated: json["point_Allocated"] == null ? null : json["point_Allocated"],
    lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
    loginType: json["login_type"] == null ? null : json["login_type"],
    lastActivityOn: json["last_activity_on"] == null ? null : DateTime.parse(json["last_activity_on"]),
    totalVehicle: json["total_vehicle"] == null ? null : json["total_vehicle"],
    delDevices: json["delDevices"] == null ? null : json["delDevices"],
    notificationTokenCount: json["notificationTokenCount"] == null ? null : json["notificationTokenCount"],
    address: json["address"] == null ? null : json["address"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "pass": pass == null ? null : pass,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
    "user_id": userId == null ? null : userId,
    "expire_date": expireDate == null ? null : expireDate.toIso8601String(),
    "std_code": stdCode == null ? null : stdCode.toJson(),
    "customer_role": customerRole == null ? null : customerRole,
    "imageDoc": imageDoc == null ? null : List<dynamic>.from(imageDoc.map((x) => x)),
    "accountSuspended": accountSuspended == null ? null : accountSuspended,
    "cust_add_permission": custAddPermission == null ? null : custAddPermission,
    "device_add_permission": deviceAddPermission == null ? null : deviceAddPermission,
    "created_on": createdOn == null ? null : createdOn.toIso8601String(),
    "status": status == null ? null : status,
    "point_Shared_Other": pointSharedOther == null ? null : pointSharedOther,
    "point_Allocated": pointAllocated == null ? null : pointAllocated,
    "last_login": lastLogin == null ? null : lastLogin.toIso8601String(),
    "login_type": loginType == null ? null : loginType,
    "last_activity_on": lastActivityOn == null ? null : lastActivityOn.toIso8601String(),
    "total_vehicle": totalVehicle == null ? null : totalVehicle,
    "delDevices": delDevices == null ? null : delDevices,
    "notificationTokenCount": notificationTokenCount == null ? null : notificationTokenCount,
    "address": address == null ? null : address,
  };
}

class StdCode {
  StdCode({
    this.countryCode,
    this.dialcode,
  });

  String countryCode;
  String dialcode;

  factory StdCode.fromJson(Map<String, dynamic> json) => StdCode(
    countryCode: json["countryCode"] == null ? null : json["countryCode"],
    dialcode: json["dialcode"] == null ? null : json["dialcode"],
  );

  Map<String, dynamic> toJson() => {
    "countryCode": countryCode == null ? null : countryCode,
    "dialcode": dialcode == null ? null : dialcode,
  };
}
