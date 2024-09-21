// To parse this JSON data, do
//
//     final commandQueueModel = commandQueueModelFromJson(jsonString);

import 'dart:convert';

List<CommandQueueModel> commandQueueModelFromJson(String str) => List<CommandQueueModel>.from(json.decode(str).map((x) => CommandQueueModel.fromJson(x)));

String commandQueueModelToJson(List<CommandQueueModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommandQueueModel {
  CommandQueueModel({
    this.id,
    this.imei,
    this.command,
    this.action,
    this.model,
    this.v,
    this.executedAt,
    this.status,
    this.lastModified,
    this.queuedAt,
  });

  String id;
  String imei;
  String command;
  String action;
  String model;
  int v;
  DateTime executedAt;
  String status;
  String lastModified;
  DateTime queuedAt;

  factory CommandQueueModel.fromJson(Map<String, dynamic> json) => CommandQueueModel(
    id: json["_id"] == null ? null : json["_id"],
    imei: json["imei"] == null ? null : json["imei"],
    command: json["command"] == null ? null : json["command"],
    action: json["action"] == null ? null : json["action"],
    model: json["model"] == null ? null : json["model"],
    v: json["__v"] == null ? null : json["__v"],
    executedAt: json["executedAt"] == null ? null : DateTime.parse(json["executedAt"]),
    status: json["status"] == null ? null : json["status"],
    lastModified: json["last_modified"] == null ? null : json["last_modified"],
    queuedAt: json["queuedAt"] == null ? null : DateTime.parse(json["queuedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "imei": imei == null ? null : imei,
    "command": command == null ? null : command,
    "action": action == null ? null : action,
    "model": model == null ? null : model,
    "__v": v == null ? null : v,
    "executedAt": executedAt == null ? null : executedAt.toIso8601String(),
    "status": status == null ? null : status,
    "last_modified": lastModified == null ? null : lastModified,
    "queuedAt": queuedAt == null ? null : queuedAt.toIso8601String(),
  };
}
