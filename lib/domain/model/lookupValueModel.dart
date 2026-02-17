
import 'dart:convert';

LookupValueModel lookupValueModelFromJson(String str) =>
    LookupValueModel.fromJson(json.decode(str));

String lookupValueModelToJson(LookupValueModel data) =>
    json.encode(data.toJson());

class LookupValueModel {
  int id;
  String value;
  String? valueAr;

  LookupValueModel({
    required this.id,
    required this.value,
    this.valueAr,
  });

  factory LookupValueModel.fromJson(Map<String, dynamic> json) =>
      LookupValueModel(
        id: json["id"],
        value: json["value"],
        valueAr: json["valueAr"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "valueAr": valueAr,
      };
}
