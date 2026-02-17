// To parse this JSON data, do
//
//     final registrationServicesTypesResponse = registrationServicesTypesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:taxi_for_you/domain/model/vehicle_model.dart';

RegistrationServicesTypesResponse registrationServicesTypesResponseFromJson(
        String str) =>
    RegistrationServicesTypesResponse.fromJson(json.decode(str));

String registrationServicesTypesResponseToJson(
        RegistrationServicesTypesResponse data) =>
    json.encode(data.toJson());

class RegistrationServicesTypesResponse {
  bool success;
  dynamic message;
  String dateTime;
  Map<String, dynamic> result;

  RegistrationServicesTypesResponse({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory RegistrationServicesTypesResponse.fromJson(
          Map<String, dynamic> json) =>
      RegistrationServicesTypesResponse(
        success: json["success"],
        message: json["message"],
        dateTime: json["dateTime"],
        result: json['result'],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "dateTime": dateTime,
        "result": result,
      };
}

class Result {
  List<Good> persons;
  List<Good> goods;

  Result({
    required this.persons,
    required this.goods,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        persons: List<Good>.from(json["PERSONS"].map((x) => Good.fromJson(x))),
        goods: List<Good>.from(json["GOODS"].map((x) => Good.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PERSONS": List<dynamic>.from(persons.map((x) => x.toJson())),
        "GOODS": List<dynamic>.from(goods.map((x) => x.toJson())),
      };
}

class Good {
  int id;
  String vehicleType;
  String driverServiceType;

  Good({
    required this.id,
    required this.vehicleType,
    required this.driverServiceType,
  });

  factory Good.fromJson(Map<String, dynamic> json) => Good(
        id: json["id"],
        vehicleType: json["vehicleType"],
        driverServiceType: json["driverServiceType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicleType": vehicleType,
        "driverServiceType": driverServiceType,
      };
}
