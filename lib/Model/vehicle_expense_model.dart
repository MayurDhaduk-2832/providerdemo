// To parse this JSON data, do
//
//     final vehicleExpensesModel = vehicleExpensesModelFromJson(jsonString);

import 'dart:convert';

VehicleExpensesModel vehicleExpensesModelFromJson(String str) => VehicleExpensesModel.fromJson(json.decode(str));

String vehicleExpensesModelToJson(VehicleExpensesModel data) => json.encode(data.toJson());

class VehicleExpensesModel {
  VehicleExpensesModel({
    this.graph,
  });

  List<ExpensesGraph> graph;

  factory VehicleExpensesModel.fromJson(Map<String, dynamic> json) => VehicleExpensesModel(
    graph: List<ExpensesGraph>.from(json["graph"].map((x) => ExpensesGraph.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "graph": List<dynamic>.from(graph.map((x) => x.toJson())),
  };
}

class ExpensesGraph {
  ExpensesGraph({
    this.id,
    this.amount,
  });

  String id;
  int amount;

  factory ExpensesGraph.fromJson(Map<String, dynamic> json) => ExpensesGraph(
    id: json["_id"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "amount": amount,
  };
}
