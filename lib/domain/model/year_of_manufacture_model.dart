// To parse this JSON data, do
//
//     final yearOfManufactureModel = yearOfManufactureModelFromJson(jsonString);

import 'dart:convert';

YearOfManufactureModel yearOfManufactureModelFromJson(String str) => YearOfManufactureModel.fromJson(json.decode(str));

String yearOfManufactureModelToJson(YearOfManufactureModel data) => json.encode(data.toJson());

class YearOfManufactureModel {
  int id;
  String value;

  YearOfManufactureModel({
    required this.id,
    required this.value,
  });

  factory YearOfManufactureModel.fromJson(Map<String, dynamic> json) => YearOfManufactureModel(
    id: json["id"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
  };
}
