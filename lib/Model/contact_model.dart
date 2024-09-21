import 'dart:convert';

List<ContactUsModel> contactUsModelFromJson(String str) => List<ContactUsModel>.from(json.decode(str).map((x) => ContactUsModel.fromJson(x)));

String contactUsModelToJson(List<ContactUsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class ContactUsModel {
  ContactUsModel({
    this.id,
    this.ticketId,
    this.user,
    this.superAdmin,
    this.message,
    this.postedOn,
    this.postedBy,
    this.email,
    this.assignedTo,
    this.role,
    this.v,
    this.supportStatus,
  });

  String id;
  int ticketId;
  String user;
  String superAdmin;
  String message;
  DateTime postedOn;
  PostedBy postedBy;
  String email;
  AssignedTo assignedTo;
  String role;
  int v;
  String supportStatus;

  factory ContactUsModel.fromJson(Map<String, dynamic> json) => ContactUsModel(
    id: json["_id"] == null ? null : json["_id"],
    ticketId: json["ticketId"] == null ? null : json["ticketId"],
    user: json["user"] == null ? null : json["user"],
    superAdmin: json["superAdmin"] == null ? null : json["superAdmin"],
    message: json["message"] == null ? null : json["message"],
    postedOn: json["posted_on"] == null ? null : DateTime.parse(json["posted_on"]),
    postedBy: json["posted_by"] == null ? null : PostedBy.fromJson(json["posted_by"]),
    email: json["email"] == null ? null : json["email"],
    assignedTo: json["assigned_to"] == null ? null : AssignedTo.fromJson(json["assigned_to"]),
    role: json["role"] == null ? null : json["role"],
    v: json["__v"] == null ? null : json["__v"],
    supportStatus: json["support_status"] == null ? null : json["support_status"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "ticketId": ticketId == null ? null : ticketId,
    "user": user == null ? null : user,
    "superAdmin": superAdmin == null ? null : superAdmin,
    "message": message == null ? null : message,
    "posted_on": postedOn == null ? null : postedOn.toIso8601String(),
    "posted_by": postedBy == null ? null : postedBy.toJson(),
    "email": email == null ? null : email,
    "assigned_to": assignedTo == null ? null : assignedTo.toJson(),
    "role": role == null ? null : role,
    "__v": v == null ? null : v,
    "support_status": supportStatus == null ? null : supportStatus,
  };
}

class AssignedTo {
  AssignedTo({
    this.id,
    this.firstName,
    this.lastName,
  });

  String id;
  String firstName;
  String lastName;

  factory AssignedTo.fromJson(Map<String, dynamic> json) => AssignedTo(
    id: json["_id"] == null ? null : json["_id"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
  };
}

class PostedBy {
  PostedBy({
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

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
    id: json["_id"] == null ? null : json["_id"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
  };
}