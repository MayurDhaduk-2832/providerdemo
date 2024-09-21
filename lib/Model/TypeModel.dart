import 'dart:convert';

List<TypeModel> typeModelFromJson(String str) => List<TypeModel>.from(json.decode(str).map((x) => TypeModel.fromJson(x)));


class TypeModel {
  TypeModel({
    this.id,
    this.name,
    this.status,
  });

  String id;
  String name;
  String type;
  String status;
  int v;

  factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
    id: json["_id"] == null ? null : json["_id"],
    name: json["name"] == null ? null : json["name"],
    status: json["status"] == null ? null : json["status"],
  );

}
