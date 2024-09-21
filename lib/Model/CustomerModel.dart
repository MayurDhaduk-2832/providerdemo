import 'dart:convert';

List<CustomerModel> customerModelFromJson(String str) => List<CustomerModel>.from(json.decode(str).map((x) => CustomerModel.fromJson(x)));

class CustomerModel {
  CustomerModel({
    this.id,
    this.pass,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.phoneVerfi,
    this.userId,
    this.expireDate,
    this.stdCode,
    this.kycStatus,
    this.imageDoc,
    this.accountSuspended,
    this.dealerAlert,
    this.adminAlert,
    this.createdOn,
    this.status,
    this.pointAllocated,
    this.dealerDetails,
    this.totalVehicle,
    this.delDevices,
    this.notificationTokenCount,
    this.lastActivityOn,
    this.lastLogin,
    this.loginType,
  });

  String id;
  String pass;
  String firstName;
  String lastName;
  String email;
  String phone;
  bool phoneVerfi;
  String userId;
  DateTime expireDate;
  dynamic stdCode;
  String kycStatus;
  List<dynamic> imageDoc;
  bool accountSuspended;
  bool dealerAlert;
  bool adminAlert;
  DateTime createdOn;
  bool status;
  int pointAllocated;
  List<DealerDetail> dealerDetails;
  int totalVehicle;
  int delDevices;
  int notificationTokenCount;
  DateTime lastActivityOn;
  DateTime lastLogin;
  String loginType;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json["_id"] == null ? null : json["_id"],
    pass: json["pass"] == null ? null : json["pass"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    phoneVerfi: json["phone_verfi"] == null ? null : json["phone_verfi"],
    userId: json["user_id"] == null ? null : json["user_id"],
    expireDate: json["expire_date"] == null ? null : DateTime.parse(json["expire_date"]),
    // stdCode: json["std_code"] == null ? null : StdCode.fromJson(json["std_code"]),
   // stdCode: json["std_code"] == null ? null : json["std_code"],
    kycStatus: json["kycStatus"] == null ? null : json["kycStatus"],
    imageDoc: json["imageDoc"] == null ? null : List<dynamic>.from(json["imageDoc"].map((x) => x)),
    accountSuspended: json["accountSuspended"] == null ? null : json["accountSuspended"],
    dealerAlert: json["dealerAlert"] == null ? null : json["dealerAlert"],
    adminAlert: json["adminAlert"] == null ? null : json["adminAlert"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
    status: json["status"] == null ? null : json["status"],
    pointAllocated: json["point_Allocated"] == null ? null : json["point_Allocated"],
    dealerDetails: json["DealerDetails"] == null ? null : List<DealerDetail>.from(json["DealerDetails"].map((x) => DealerDetail.fromJson(x))),
    totalVehicle: json["total_vehicle"] == null ? null : json["total_vehicle"],
    delDevices: json["delDevices"] == null ? null : json["delDevices"],
    notificationTokenCount: json["notificationTokenCount"] == null ? null : json["notificationTokenCount"],
    lastActivityOn: json["last_activity_on"] == null ? null : DateTime.parse(json["last_activity_on"]),
    lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
    loginType: json["login_type"] == null ? null : json["login_type"],
  );
}

class DealerDetail {
  DealerDetail({
    this.firstName,
    this.lastName,
  });

  String firstName;
  String lastName;

  factory DealerDetail.fromJson(Map<String, dynamic> json) => DealerDetail(
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
  );
}

/*class StdCode {
  StdCode({
    this.dialcode,
    this.countryCode,
  });

  dynamic dialcode;
  String countryCode;

  factory StdCode.fromJson(Map<String, dynamic> json) => StdCode(
    dialcode: json["dialcode"] == null ? null : json["dialcode"],
    countryCode: json["countryCode"] == null ? null : json["countryCode"],
  );

}*/
