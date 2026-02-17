// To parse this JSON data, do
//
//     final serviceRegisterModel = serviceRegisterModelFromJson(jsonString);

import 'dart:convert';

ServiceRegisterModel serviceRegisterModelFromJson(String str) => ServiceRegisterModel.fromJson(json.decode(str));

String serviceRegisterModelToJson(ServiceRegisterModel data) => json.encode(data.toJson());

class ServiceRegisterModel {
  bool success;
  dynamic message;
  String dateTime;
  String result;

  ServiceRegisterModel({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory ServiceRegisterModel.fromJson(Map<String, dynamic> json) => ServiceRegisterModel(
    success: json["success"],
    message: json["message"],
    dateTime: json["dateTime"],
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "dateTime": dateTime,
    "result": result,
  };
}
