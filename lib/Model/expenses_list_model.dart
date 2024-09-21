// To parse this JSON data, do
//
//     final getExpensesListModel = getExpensesListModelFromJson(jsonString);

import 'dart:convert';

GetExpensesListModel getExpensesListModelFromJson(String str) => GetExpensesListModel.fromJson(json.decode(str));

String getExpensesListModelToJson(GetExpensesListModel data) => json.encode(data.toJson());

class GetExpensesListModel {
  GetExpensesListModel({
    this.expenseobj,
  });

  List<Expenseobj> expenseobj;

  factory GetExpensesListModel.fromJson(Map<String, dynamic> json) => GetExpensesListModel(
    expenseobj: List<Expenseobj>.from(json["expenseobj"].map((x) => Expenseobj.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "expenseobj": List<dynamic>.from(expenseobj.map((x) => x.toJson())),
  };
}

class Expenseobj {
  Expenseobj({
    this.id,
    this.total,
    this.currency,
  });

  String id;
  int total;
  String currency;

  factory Expenseobj.fromJson(Map<String, dynamic> json) => Expenseobj(
    id: json["_id"],
    total: json["total"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "total": total,
    "currency": currency,
  };
}
