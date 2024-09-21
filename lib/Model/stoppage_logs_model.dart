// To parse this JSON data, do
//
//     final stoppageLogsModel = stoppageLogsModelFromJson(jsonString);

import 'dart:convert';

StoppageLogsModel stoppageLogsModelFromJson(String str) => StoppageLogsModel.fromJson(json.decode(str));

String stoppageLogsModelToJson(StoppageLogsModel data) => json.encode(data.toJson());

class StoppageLogsModel {
  StoppageLogsModel({
    this.todayRunning,
    this.todaysOdo,
    this.todayStopped,
    this.status,
    this.result,
    this.message,
  });

  int todayRunning;
  double todaysOdo;
  int todayStopped;
  int status;
  List<Result> result;
  String message;

  factory StoppageLogsModel.fromJson(Map<String, dynamic> json) => StoppageLogsModel(
    todayRunning: json["today_running"] == null ? null : json["today_running"],
    todaysOdo: json["todays_odo"] == null ? null : json["todays_odo"].toDouble(),
    todayStopped: json["today_stopped"] == null ? null : json["today_stopped"],
    status: json["status"] == null ? null : json["status"],
    result: json["result"] == null ? null : List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "today_running": todayRunning == null ? null : todayRunning,
    "todays_odo": todaysOdo == null ? null : todaysOdo,
    "today_stopped": todayStopped == null ? null : todayStopped,
    "status": status == null ? null : status,
    "result": result == null ? null : List<dynamic>.from(result.map((x) => x.toJson())),
    "message": message == null ? null : message,
  };
}

class Result {
  Result({
    this.type,
    this.startTime,
    this.endTime,
    this.eventTime,
    this.startLat,
    this.startLong,
    this.endLat,
    this.endLong,
    this.distance,
  });

  String type;
  DateTime startTime;
  DateTime endTime;
  int eventTime;
  String startLat;
  String startLong;
  String endLat;
  String endLong;
  double distance;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    type: json["type"] == null ? null : json["type"],
    startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    eventTime: json["event_time"] == null ? null : json["event_time"],
    startLat: json["start_lat"] == null ? null : json["start_lat"],
    startLong: json["start_long"] == null ? null : json["start_long"],
    endLat: json["end_lat"] == null ? null : json["end_lat"],
    endLong: json["end_long"] == null ? null : json["end_long"],
    distance: json["distance"] == null ? null : json["distance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "start_time": startTime == null ? null : startTime.toIso8601String(),
    "end_time": endTime == null ? null : endTime.toIso8601String(),
    "event_time": eventTime == null ? null : eventTime,
    "start_lat": startLat == null ? null : startLat,
    "start_long": startLong == null ? null : startLong,
    "end_lat": endLat == null ? null : endLat,
    "end_long": endLong == null ? null : endLong,
    "distance": distance == null ? null : distance,
  };
}
