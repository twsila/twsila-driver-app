// To parse this JSON data, do
//
//     final verifyOtpModel = verifyOtpModelFromJson(jsonString);

import 'dart:convert';

import 'package:taxi_for_you/data/response/responses.dart';

VerifyOtpModel verifyOtpModelFromJson(String str) => VerifyOtpModel.fromJson(json.decode(str));

String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());

class VerifyOtpModel  {
  bool success;
  dynamic message;
  String dateTime;
  String result;

  VerifyOtpModel({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) => VerifyOtpModel(
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
