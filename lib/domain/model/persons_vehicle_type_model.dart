// To parse this JSON data, do
//
//     final personsVehicleTypeModel = personsVehicleTypeModelFromJson(jsonString);

import 'dart:convert';

import 'package:taxi_for_you/domain/model/vehicle_model.dart';

PersonsVehicleTypeModel personsVehicleTypeModelFromJson(String str) =>
    PersonsVehicleTypeModel.fromJson(json.decode(str));

String personsVehicleTypeModelToJson(PersonsVehicleTypeModel data) =>
    json.encode(data.toJson());

class PersonsVehicleTypeModel {
  int id;
  String vehicleType;
  String vehicleTypeAr;
  String serviceType;
  List<NumberOfPassenger> numberOfPassengers;
  VIcon icon;

  PersonsVehicleTypeModel({
    required this.id,
    required this.vehicleType,
    required this.vehicleTypeAr,
    required this.serviceType,
    required this.numberOfPassengers,
    required this.icon,
  });

  factory PersonsVehicleTypeModel.fromJson(Map<String, dynamic> json) =>
      PersonsVehicleTypeModel(
        id: json["id"],
        vehicleType: json["vehicleType"],
        vehicleTypeAr: json["vehicleTypeAr"],
        serviceType: json["serviceType"],
        numberOfPassengers: List<NumberOfPassenger>.from(
            json["numberOfPassengers"]
                .map((x) => NumberOfPassenger.fromJson(x))).toList(),
        icon: VIcon.fromJson(json["icon"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicleType": vehicleType,
        "vehicleTypeAr": vehicleTypeAr,
        "serviceType": serviceType,
        "numberOfPassengers":
            List<NumberOfPassenger>.from(numberOfPassengers.map((x) => x)),
        "icon": icon.toJson(),
      };
}

class VIcon {
  int id;
  String url;

  VIcon({
    required this.id,
    required this.url,
  });

  factory VIcon.fromJson(Map<String, dynamic> json) => VIcon(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
