// To parse this JSON data, do
//
//     final registrationResponse = registrationResponseFromJson(jsonString);

import 'dart:convert';

RegistrationResponse registrationResponseFromJson(String str) =>
    RegistrationResponse.fromJson(json.decode(str));

String registrationResponseToJson(RegistrationResponse data) =>
    json.encode(data.toJson());

class RegistrationResponse {
  bool success;
  dynamic message;
  String dateTime;
  Map<String,dynamic> result;

  RegistrationResponse({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      RegistrationResponse(
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

class RegistrationBOResponse {
  bool success;
  dynamic message;
  String dateTime;
  Map<String, dynamic> result;

  RegistrationBOResponse({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory RegistrationBOResponse.fromJson(Map<String, dynamic> json) =>
      RegistrationBOResponse(
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
