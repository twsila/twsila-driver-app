// To parse this JSON data, do
//
//     final currentLocationFilter = currentLocationFilterFromJson(jsonString);

import 'dart:convert';

CurrentLocationFilter currentLocationFilterFromJson(String str) => CurrentLocationFilter.fromJson(json.decode(str));

String currentLocationFilterToJson(CurrentLocationFilter data) => json.encode(data.toJson());

class CurrentLocationFilter {
  double latitude;
  double longitude;
  String cityName;

  CurrentLocationFilter({
    required this.latitude,
    required this.longitude,
    required this.cityName,
  });

  factory CurrentLocationFilter.fromJson(Map<String, dynamic> json) => CurrentLocationFilter(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    cityName: json["cityName"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "cityName": cityName,
  };
}
