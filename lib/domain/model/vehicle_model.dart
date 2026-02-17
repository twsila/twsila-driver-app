// To parse this JSON data, do
//
//     final vehicleModel = vehicleModelFromJson(jsonString);

import 'dart:convert';

import 'goods_service_type_model.dart';

VehicleModel vehicleModelFromJson(String str) =>
    VehicleModel.fromJson(json.decode(str));

String vehicleModelToJson(VehicleModel data) => json.encode(data.toJson());

class VehicleModel {
  int id;
  String? vehicleType;
  String? vehicleTypeAr;
  String? serviceType;
  List<NumberOfPassenger>? numberOfPassengers;
  List<TruckType>? vehicleShapes;
  VehicleIcon? icon;
  bool? isSelected;

  VehicleModel(
      {required this.id,
      this.vehicleType,
      this.vehicleTypeAr,
      this.serviceType,
      required this.numberOfPassengers,
      required this.vehicleShapes,
      this.icon,
      this.isSelected = false});

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        vehicleType: json["vehicleType"] ?? "",
        vehicleTypeAr: json["vehicleTypeAr"],
        serviceType: json["serviceType"] ?? "",
        numberOfPassengers: json["numberOfPassengers"] != null
            ? List<NumberOfPassenger>.from(json["numberOfPassengers"]
                .map((x) => NumberOfPassenger.fromJson(x)))
            : null,
        vehicleShapes: json["vehicleShapes"] != null
            ? List<TruckType>.from(
                json["truckType"].map((x) => TruckType.fromJson(x)))
            : null,
        icon: json["icon"] != null ? VehicleIcon.fromJson(json["icon"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicleType": vehicleType,
        "vehicleTypeAr": vehicleTypeAr,
        "serviceType": serviceType,
        "numberOfPassengers": numberOfPassengers != null
            ? List<dynamic>.from(numberOfPassengers!.map((x) => x.toJson()))
            : null,
        "vehicleShapes": vehicleShapes != null
            ? List<dynamic>.from(vehicleShapes!.map((x) => x))
            : [],
        "icon": icon!.toJson(),
      };
}

class VehicleIcon {
  int id;
  String url;

  VehicleIcon({
    required this.id,
    required this.url,
  });

  factory VehicleIcon.fromJson(Map<String, dynamic> json) => VehicleIcon(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}

class NumberOfPassenger {
  int id;
  int numberOfPassengers;
  bool? isSelected;

  NumberOfPassenger({
    required this.id,
    required this.numberOfPassengers,
    this.isSelected = false,
  });

  factory NumberOfPassenger.fromJson(Map<String, dynamic> json) =>
      NumberOfPassenger(
        id: json["id"],
        numberOfPassengers: json["numberOfPassengers"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "numberOfPassengers": numberOfPassengers,
      };
}
