// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  MessageModel({
    this.code,
    this.data,
  });

  int code;
  List<Datum> data;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    code: json["code"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.phoneNumber,
    this.message,
  });

  String id;
  String phoneNumber;
  String message;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    phoneNumber: json["phone_number"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone_number": phoneNumber,
    "message": message,
  };
}
