// To parse this JSON data, do
//
//     final lookupsModel = lookupsModelFromJson(jsonString);

import 'dart:convert';

LookupsModel lookupsModelFromJson(String str) => LookupsModel.fromJson(json.decode(str));

String lookupsModelToJson(LookupsModel data) => json.encode(data.toJson());

class LookupsModel {
  bool success;
  dynamic message;
  String dateTime;
  Result result;

  LookupsModel({
    required this.success,
    required this.message,
    required this.dateTime,
    required this.result,
  });

  factory LookupsModel.fromJson(Map<String, dynamic> json) => LookupsModel(
    success: json["success"],
    message: json["message"],
    dateTime: json["dateTime"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "dateTime": dateTime,
    "result": result.toJson(),
  };
}

class Result {
  List<String> shippingTypeAr;
  List<String> acceptanceType;
  List<String> tankTypeAr;
  List<String> shippingType;
  List<String> tankType;
  List<String> registrationStatus;
  List<VehicleType> vehicleType;
  List<String> cancelledByEnumAr;
  List<String> tripTypeAr;
  List<String> tripStatus;
  List<String> tripStatusAr;
  List<String> tripModelTypeAr;
  List<String> acceptanceTypeAr;
  List<String> driverServiceTypeAr;
  List<String> cancelledByEnum;
  List<String> notificationTypeAr;
  List<String> driverServiceType;
  List<String> submitStatus;
  List<String> registrationStatusAr;
  List<VehicleType> vehicleTypeAr;
  List<String> notificationType;
  List<String> tripType;
  List<String> submitStatusAr;
  List<String> tripModelType;

  Result({
    required this.shippingTypeAr,
    required this.acceptanceType,
    required this.tankTypeAr,
    required this.shippingType,
    required this.tankType,
    required this.registrationStatus,
    required this.vehicleType,
    required this.cancelledByEnumAr,
    required this.tripTypeAr,
    required this.tripStatus,
    required this.tripStatusAr,
    required this.tripModelTypeAr,
    required this.acceptanceTypeAr,
    required this.driverServiceTypeAr,
    required this.cancelledByEnum,
    required this.notificationTypeAr,
    required this.driverServiceType,
    required this.submitStatus,
    required this.registrationStatusAr,
    required this.vehicleTypeAr,
    required this.notificationType,
    required this.tripType,
    required this.submitStatusAr,
    required this.tripModelType,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    shippingTypeAr: List<String>.from(json["ShippingTypeAR"].map((x) => x)),
    acceptanceType: List<String>.from(json["AcceptanceType"].map((x) => x)),
    tankTypeAr: List<String>.from(json["TankTypeAR"].map((x) => x)),
    shippingType: List<String>.from(json["ShippingType"].map((x) => x)),
    tankType: List<String>.from(json["TankType"].map((x) => x)),
    registrationStatus: List<String>.from(json["RegistrationStatus"].map((x) => x)),
    vehicleType: List<VehicleType>.from(json["VehicleType"].map((x) => VehicleType.fromJson(x))),
    cancelledByEnumAr: List<String>.from(json["CancelledByEnumAR"].map((x) => x)),
    tripTypeAr: List<String>.from(json["TripTypeAR"].map((x) => x)),
    tripStatus: List<String>.from(json["TripStatus"].map((x) => x)),
    tripStatusAr: List<String>.from(json["TripStatusAR"].map((x) => x)),
    tripModelTypeAr: List<String>.from(json["TripModelTypeAR"].map((x) => x)),
    acceptanceTypeAr: List<String>.from(json["AcceptanceTypeAR"].map((x) => x)),
    driverServiceTypeAr: List<String>.from(json["DriverServiceTypeAR"].map((x) => x)),
    cancelledByEnum: List<String>.from(json["CancelledByEnum"].map((x) => x)),
    notificationTypeAr: List<String>.from(json["NotificationTypeAR"].map((x) => x)),
    driverServiceType: List<String>.from(json["DriverServiceType"].map((x) => x)),
    submitStatus: List<String>.from(json["SubmitStatus"].map((x) => x)),
    registrationStatusAr: List<String>.from(json["RegistrationStatusAR"].map((x) => x)),
    vehicleTypeAr: List<VehicleType>.from(json["VehicleTypeAR"].map((x) => VehicleType.fromJson(x))),
    notificationType: List<String>.from(json["NotificationType"].map((x) => x)),
    tripType: List<String>.from(json["TripType"].map((x) => x)),
    submitStatusAr: List<String>.from(json["SubmitStatusAR"].map((x) => x)),
    tripModelType: List<String>.from(json["TripModelType"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "ShippingTypeAR": List<dynamic>.from(shippingTypeAr.map((x) => x)),
    "AcceptanceType": List<dynamic>.from(acceptanceType.map((x) => x)),
    "TankTypeAR": List<dynamic>.from(tankTypeAr.map((x) => x)),
    "ShippingType": List<dynamic>.from(shippingType.map((x) => x)),
    "TankType": List<dynamic>.from(tankType.map((x) => x)),
    "RegistrationStatus": List<dynamic>.from(registrationStatus.map((x) => x)),
    "VehicleType": List<dynamic>.from(vehicleType.map((x) => x.toJson())),
    "CancelledByEnumAR": List<dynamic>.from(cancelledByEnumAr.map((x) => x)),
    "TripTypeAR": List<dynamic>.from(tripTypeAr.map((x) => x)),
    "TripStatus": List<dynamic>.from(tripStatus.map((x) => x)),
    "TripStatusAR": List<dynamic>.from(tripStatusAr.map((x) => x)),
    "TripModelTypeAR": List<dynamic>.from(tripModelTypeAr.map((x) => x)),
    "AcceptanceTypeAR": List<dynamic>.from(acceptanceTypeAr.map((x) => x)),
    "DriverServiceTypeAR": List<dynamic>.from(driverServiceTypeAr.map((x) => x)),
    "CancelledByEnum": List<dynamic>.from(cancelledByEnum.map((x) => x)),
    "NotificationTypeAR": List<dynamic>.from(notificationTypeAr.map((x) => x)),
    "DriverServiceType": List<dynamic>.from(driverServiceType.map((x) => x)),
    "SubmitStatus": List<dynamic>.from(submitStatus.map((x) => x)),
    "RegistrationStatusAR": List<dynamic>.from(registrationStatusAr.map((x) => x)),
    "VehicleTypeAR": List<dynamic>.from(vehicleTypeAr.map((x) => x.toJson())),
    "NotificationType": List<dynamic>.from(notificationType.map((x) => x)),
    "TripType": List<dynamic>.from(tripType.map((x) => x)),
    "SubmitStatusAR": List<dynamic>.from(submitStatusAr.map((x) => x)),
    "TripModelType": List<dynamic>.from(tripModelType.map((x) => x)),
  };
}

class VehicleType {
  String name;
  String id;
  List<int> noOfPassengers;

  VehicleType({
    required this.name,
    required this.id,
    required this.noOfPassengers,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    name: json["name"],
    id: json["id"],
    noOfPassengers: List<int>.from(json["noOfPassengers"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "noOfPassengers": List<dynamic>.from(noOfPassengers.map((x) => x)),
  };
}
