// To parse this JSON data, do
//
//     final logoutModel = logoutModelFromJson(jsonString);

import 'dart:convert';

LogoutModel logoutModelFromJson(String str) => LogoutModel.fromJson(json.decode(str));

String logoutModelToJson(LogoutModel data) => json.encode(data.toJson());

class LogoutModel {
  bool success;
  dynamic message;
  String dateTime;
  dynamic result;

  LogoutModel({
    required this.success,
    this.message,
    required this.dateTime,
    this.result,
  });

  factory LogoutModel.fromJson(Map<String, dynamic> json) => LogoutModel(
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
