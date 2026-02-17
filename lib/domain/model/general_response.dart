// To parse this JSON data, do
//
//     final generalResponse = generalResponseFromJson(jsonString);

import 'dart:convert';

GeneralResponse generalResponseFromJson(String str) =>
    GeneralResponse.fromJson(json.decode(str));

String generalResponseToJson(GeneralResponse data) =>
    json.encode(data.toJson());

class GeneralResponse {
  bool success;
  String? message;
  String? dateTime;
  dynamic result;

  GeneralResponse({
    required this.success,
    this.message,
    this.dateTime,
    this.result,
  });

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      GeneralResponse(
        success: json["success"],
        message: json["message"] ?? "",
        dateTime: json["dateTime"] ?? "",
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "dateTime": dateTime,
        "result": result,
      };
}
