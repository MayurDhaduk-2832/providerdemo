import 'dart:convert';

GetAllDocumentModel getAllDocumentModelFromJson(String str) => GetAllDocumentModel.fromJson(json.decode(str));


class GetAllDocumentModel {
  GetAllDocumentModel({
    this.documents,
  });

  List<Document> documents;

  factory GetAllDocumentModel.fromJson(Map<String, dynamic> json) => GetAllDocumentModel(
    documents: json["Documents"] == null ? null : List<Document>.from(json["Documents"].map((x) => Document.fromJson(x))),
  );

}

class Document {
  Document({
    this.id,
    this.device,
    this.imageDoc,
  });

  String id;
  String device;
  List<ImageDoc> imageDoc;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json["_id"] == null ? null : json["_id"],
    device: json["device"] == null ? null : json["device"],
    imageDoc: json["imageDoc"] == null ? null : List<ImageDoc>.from(json["imageDoc"].map((x) => ImageDoc.fromJson(x))),
  );

}

class ImageDoc {
  ImageDoc({
    this.id,
    this.image,
    this.date,
    this.number,
    this.name,
    this.type,
    this.expDate,
    this.phone,
  });

  String id;
  String image;
  DateTime date;
  String number;
  String name;
  String type;
  DateTime expDate;
  String phone;

  factory ImageDoc.fromJson(Map<String, dynamic> json) => ImageDoc(
    id: json["_id"] == null ? null : json["_id"],
    image: json["image"] == null ? null : json["image"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    number: json["number"] == null ? null : json["number"],
    name: json["name"] == null ? null : json["name"],
    type: json["type"] == null ? null : json["type"],
    expDate: json["expDate"] == null ? null : DateTime.parse(json["expDate"]),
    phone: json["phone"] == null ? null : json["phone"],
  );

}
