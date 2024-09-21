import 'dart:convert';

List<DealerModel> dealerModelFromJson(String str) => List<DealerModel>.from(
    json.decode(str).map((x) => DealerModel.fromJson(x)));

class DealerModel {
  DealerModel({
    this.id,
    this.pass,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.userId,
    this.address,
    this.expireDate,
    this.stdCode,
    this.imageDoc,
    this.accountSuspended,
    this.custAddPermission,
    this.deviceAddPermission,
    this.createdOn,
    this.status,
    this.pointSharedOther,
    this.pointAllocated,
    this.totalVehicle,
    this.delDevices,
    this.notificationTokenCount,
    this.customerRole,
    this.lastLogin,
    this.loginType,
    this.lastActivityOn,
  });

  String id;
  String pass;
  String firstName;
  String lastName;
  String email;
  String phone;
  String userId;
  String address;
  DateTime expireDate;
  StdCode stdCode;
  List<dynamic> imageDoc;
  bool accountSuspended;
  bool custAddPermission;
  bool deviceAddPermission;
  DateTime createdOn;
  bool status;
  int pointSharedOther;
  int pointAllocated;
  int totalVehicle;
  int delDevices;
  int notificationTokenCount;
  String customerRole;
  DateTime lastLogin;
  String loginType;
  DateTime lastActivityOn;

  factory DealerModel.fromJson(Map<String, dynamic> json) => DealerModel(
        id: json["_id"] == null ? null : json["_id"],
        pass: json["pass"] == null ? null : json["pass"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        userId: json["user_id"] == null ? null : json["user_id"],
        address: json["address"] == null ? null : json["address"],
        expireDate: json["expire_date"] == null
            ? null
            : DateTime.parse(json["expire_date"]),
        // stdCode: json["std_code"] == null
        //     ? null
        //     : StdCode.fromJson( json["std_code"]),
        imageDoc: json["imageDoc"] == null
            ? null
            : List<dynamic>.from(json["imageDoc"].map((x) => x)),
        accountSuspended:
            json["accountSuspended"] == null ? null : json["accountSuspended"],
        custAddPermission: json["cust_add_permission"] == null
            ? null
            : json["cust_add_permission"],
        deviceAddPermission: json["device_add_permission"] == null
            ? null
            : json["device_add_permission"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        status: json["status"] == null ? null : json["status"],
        pointSharedOther: json["point_Shared_Other"] == null
            ? null
            : json["point_Shared_Other"],
        pointAllocated:
            json["point_Allocated"] == null ? null : json["point_Allocated"],
        totalVehicle:
            json["total_vehicle"] == null ? null : json["total_vehicle"],
        delDevices: json["delDevices"] == null ? null : json["delDevices"],
        notificationTokenCount: json["notificationTokenCount"] == null
            ? null
            : json["notificationTokenCount"],
        customerRole:
            json["customer_role"] == null ? null : json["customer_role"],
        lastLogin: json["last_login"] == null
            ? null
            : DateTime.parse(json["last_login"]),
        loginType: json["login_type"] == null ? null : json["login_type"],
        lastActivityOn: json["last_activity_on"] == null
            ? null
            : DateTime.parse(json["last_activity_on"]),
      );
}

class StdCode {
  StdCode({
    this.dialcode,
    this.countryCode,
  });

  String dialcode;
  String countryCode;

  factory StdCode.fromJson(Map<String, dynamic> json) => StdCode(
        dialcode: json["dialcode"] == null ? null : json["dialcode"],
        countryCode: json["countryCode"] == null ? null : json["countryCode"],
      );
}
