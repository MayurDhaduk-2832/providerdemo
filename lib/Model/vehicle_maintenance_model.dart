import 'dart:convert';

List<VehicleMaintenanceModel> vehicleMaintenanceModelFromJson(String str) => List<VehicleMaintenanceModel>.from(json.decode(str).map((x) => VehicleMaintenanceModel.fromJson(x)));

String vehicleMaintenanceModelToJson(List<VehicleMaintenanceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleMaintenanceModel {
  VehicleMaintenanceModel({
    this.notificationType,
    this.reminderDate,
    this.id,
    this.createdBy,
    this.user,
    this.device,
    this.reminderType,
    this.priorReminder,
    this.status,
    this.vehicleName,
    this.odo,
    this.createdOn,
    this.v,
    this.dateOfService,
    this.statusChangedOn,
  });

  NotificationType notificationType;
  DateTime reminderDate;
  String id;
  String createdBy;
  String user;
  String device;
  String reminderType;
  int priorReminder;
  String status;
  String vehicleName;
  String odo;
  DateTime createdOn;
  int v;
  DateTime dateOfService;
  DateTime statusChangedOn;

  factory VehicleMaintenanceModel.fromJson(Map<String, dynamic> json) => VehicleMaintenanceModel(
    notificationType: json["notification_type"] == null ? null : NotificationType.fromJson(json["notification_type"]),
    reminderDate: json["reminder_date"] == null ? null : DateTime.parse(json["reminder_date"]),
    id: json["_id"] == null ? null : json["_id"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    user: json["user"] == null ? null : json["user"],
    device: json["device"] == null ? null : json["device"],
    reminderType: json["reminder_type"] == null ? null : json["reminder_type"],
    priorReminder: json["prior_reminder"] == null ? null : json["prior_reminder"],
    status: json["status"] == null ? null : json["status"],
    vehicleName: json["vehicleName"] == null ? null : json["vehicleName"],
    odo: json["odo"] == null ? null : json["odo"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
    v: json["__v"] == null ? null : json["__v"],
    dateOfService: json["date_of_service"] == null ? null : DateTime.parse(json["date_of_service"]),
    statusChangedOn: json["status_changed_on"] == null ? null : DateTime.parse(json["status_changed_on"]),
  );

  Map<String, dynamic> toJson() => {
    "notification_type": notificationType == null ? null : notificationType.toJson(),
    "reminder_date": reminderDate == null ? null : reminderDate.toIso8601String(),
    "_id": id == null ? null : id,
    "created_by": createdBy == null ? null : createdBy,
    "user": user == null ? null : user,
    "device": device == null ? null : device,
    "reminder_type": reminderType == null ? null : reminderType,
    "prior_reminder": priorReminder == null ? null : priorReminder,
    "status": status == null ? null : status,
    "vehicleName": vehicleName == null ? null : vehicleName,
    "odo": odo == null ? null : odo,
    "created_on": createdOn == null ? null : createdOn.toIso8601String(),
    "__v": v == null ? null : v,
    "date_of_service": dateOfService == null ? null : dateOfService.toIso8601String(),
    "status_changed_on": statusChangedOn == null ? null : statusChangedOn.toIso8601String(),
  };
}

class NotificationType {
  NotificationType({
    this.sms,
    this.email,
    this.pushNotification,
  });

  bool sms;
  bool email;
  bool pushNotification;

  factory NotificationType.fromJson(Map<String, dynamic> json) => NotificationType(
    sms: json["SMS"] == null ? null : json["SMS"],
    email: json["EMAIL"] == null ? null : json["EMAIL"],
    pushNotification: json["PUSH_NOTIFICATION"] == null ? null : json["PUSH_NOTIFICATION"],
  );

  Map<String, dynamic> toJson() => {
    "SMS": sms == null ? null : sms,
    "EMAIL": email == null ? null : email,
    "PUSH_NOTIFICATION": pushNotification == null ? null : pushNotification,
  };
}
