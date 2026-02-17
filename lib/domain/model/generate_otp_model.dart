// To parse this JSON data, do
//
//     final generateOtpModel = generateOtpModelFromJson(jsonString);

import 'dart:convert';

GenerateOtpModel generateOtpModelFromJson(String str) => GenerateOtpModel.fromJson(json.decode(str));

String generateOtpModelToJson(GenerateOtpModel data) => json.encode(data.toJson());

class GenerateOtpModel {
  bool success;
  dynamic message;
  String dateTime;
  Result result;

  GenerateOtpModel({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory GenerateOtpModel.fromJson(Map<String, dynamic> json) => GenerateOtpModel(
    success: json["success"],
    message: json["message"]??"",
    dateTime: json["dateTime"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message??"",
    "dateTime": dateTime,
    "result": result.toJson(),
  };
}

class Result {
  int id;
  DateTime createdAt;
  String otp;
  String mobile;
  String message;

  Result({
    required this.id,
    required this.createdAt,
    required this.otp,
    required this.mobile,
    required this.message,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    otp: json["otp"],
    mobile: json["mobile"],
    message: json["message"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "otp": otp,
    "mobile": mobile,
    "message": message??"",
  };
}
