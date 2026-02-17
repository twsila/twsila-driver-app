// To parse this JSON data, do
//
//     final countryLookupModel = countryLookupModelFromJson(jsonString);

import 'dart:convert';

CountryLookupModel countryLookupModelFromJson(String str) =>
    CountryLookupModel.fromJson(json.decode(str));

String countryLookupModelToJson(CountryLookupModel data) =>
    json.encode(data.toJson());

class CountryLookupModel {
  int countryId;
  String countryName;
  String countryCode;
  String? countryCodeAr;
  String country;
  String imageUrl;
  String language;

  CountryLookupModel({
    required this.countryId,
    required this.countryName,
    required this.countryCode,
    this.countryCodeAr,
    required this.country,
    required this.imageUrl,
    required this.language,
  });

  factory CountryLookupModel.fromJson(Map<String, dynamic> json) =>
      CountryLookupModel(
        countryId: json["countryID"],
        countryName: json["countryName"],
        countryCode: json["countryCode"],
        countryCodeAr: json["countryCodeAr"] ?? "",
        country: json["country"],
        imageUrl: json["imageURL"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "countryID": countryId,
        "countryName": countryName,
        "countryCode": countryCode,
        "countryCodeAr": countryCodeAr,
        "country": country,
        "imageURL": imageUrl,
        "language": language,
      };
}
