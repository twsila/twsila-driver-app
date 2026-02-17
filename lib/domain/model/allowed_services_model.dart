// To parse this JSON data, do
//
//     final allowedServiceModel = allowedServiceModelFromJson(jsonString);

import 'dart:convert';

AllowedServiceModel allowedServiceModelFromJson(String str) => AllowedServiceModel.fromJson(json.decode(str));

String allowedServiceModelToJson(AllowedServiceModel data) => json.encode(data.toJson());

class AllowedServiceModel {
  int id;
  String value;
  String userType;
  bool allowed;

  AllowedServiceModel({
    required this.id,
    required this.value,
    required this.userType,
    required this.allowed,
  });

  factory AllowedServiceModel.fromJson(Map<String, dynamic> json) => AllowedServiceModel(
    id: json["id"],
    value: json["value"],
    userType: json["userType"],
    allowed: json["allowed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "userType": userType,
    "allowed": allowed,
  };
}
