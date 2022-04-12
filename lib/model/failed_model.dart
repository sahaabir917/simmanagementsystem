// To parse this JSON data, do
//
//     final failedModel = failedModelFromJson(jsonString);

import 'dart:convert';

FailedModel failedModelFromJson(String str) => FailedModel.fromJson(json.decode(str));

String failedModelToJson(FailedModel data) => json.encode(data.toJson());

class FailedModel {
  FailedModel({
    this.code,
    this.message,
  });

  int code;
  String message;

  factory FailedModel.fromJson(Map<String, dynamic> json) => FailedModel(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}
