// To parse this JSON data, do
//
//     final driverModel = driverModelFromJson(jsonString);

import 'dart:convert';

import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

Driver driverModelFromJson(String str) => Driver.fromJson(json.decode(str));

String driverModelToJson(Driver data) => json.encode(data.toJson());

abstract class DriverBaseModel {
  int? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? gender;
  String? captainType;
  String? accessToken;
  String? refreshToken;
  UserDevice? userDevice;
  String? tokenExpirationTime;
  bool? deleted;
  bool? disabled;
  bool? blocked;
}

class Driver extends DriverBaseModel {
  String dateOfBirth;
  List<String>? serviceTypes;
  RegistrationStatus registrationStatus;
  DriverVehicleType? vehicleType;
  CarManufacturerModel? carManufacturer;
  CarModel? carModel;
  bool canTransportFurniture;
  bool canTransportGoods;
  bool canTransportFrozen;
  bool hasWaterTank;
  bool hasOtherTanks;
  bool hasPacking;
  bool hasLoading;
  bool hasAssembly;
  bool hasLifting;
  String plateNumber;
  String? driverStatus;
  int? businessOwnerId;
  List<DriverImage> images;
  double rating;
  bool acknowledged;
  bool isChecked;
  bool? isPending;

  String? nationalId;
  String? nationalIdExpiryDate;
  String? vehicleDocExpiryDate;
  String? vehicleDriverNatIdExpiryDate;
  String? vehicleOwnerNatIdExpiryDate;
  String? licenseExpiryDate;
  bool? proceedFirstTimeApproval;

  Driver(
      {required id,
      required firstName,
      required lastName,
      required mobile,
      required email,
      required gender,
      required captainType,
      required this.dateOfBirth,
      this.serviceTypes,
      required this.registrationStatus,
      this.vehicleType,
      this.driverStatus,
      this.carManufacturer,
      this.carModel,
      required this.canTransportFurniture,
      required this.canTransportGoods,
      required this.canTransportFrozen,
      required this.hasWaterTank,
      required this.hasOtherTanks,
      required this.hasPacking,
      required this.hasLoading,
      required this.hasAssembly,
      required this.hasLifting,
      required this.plateNumber,
      required this.images,
      required this.rating,
      required this.acknowledged,
      required accessToken,
      required refreshToken,
      required userDevice,
      this.nationalId,
      this.nationalIdExpiryDate,
      this.vehicleDocExpiryDate,
      this.vehicleDriverNatIdExpiryDate,
      this.vehicleOwnerNatIdExpiryDate,
      this.licenseExpiryDate,
      this.proceedFirstTimeApproval,
      this.businessOwnerId,
      this.isPending = false,
      required tokenExpirationTime,
      required deleted,
      required disabled,
      required blocked,
      this.isChecked = false}) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.mobile = mobile;
    this.email = email;
    this.gender = gender;
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.userDevice = userDevice;
    this.tokenExpirationTime = tokenExpirationTime;
    this.captainType = RegistrationConstants.captain;
    this.disabled = disabled;
    this.blocked = blocked;
    this.deleted = deleted;
  }

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        driverStatus:
            json["driverStatus"] != null ? json["driverStatus"] : null,
        mobile: json["mobile"],
        email: json["email"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"] ?? "",
        serviceTypes: json["serviceTypes"] != null
            ? List<String>.from(json["serviceTypes"]).toList()
            : [],
        registrationStatus:
            RegistrationStatus.fromJson(json["registrationStatus"]),
        vehicleType: json["vehicleType"] != null
            ? DriverVehicleType.fromJson(json["vehicleType"])
            : null,
        captainType: RegistrationConstants.captain,
        carManufacturer: json["carManufacturer"] != null
            ? CarManufacturerModel.fromJson(json["carManufacturer"])
            : null,
        carModel: json["carModel"] != null
            ? CarModel.fromJson(json["carModel"])
            : null,
        businessOwnerId: json["businessOwnerId"],
        nationalId: json["nationalId"],
        nationalIdExpiryDate: json["nationalIdExpiryDate"],
        vehicleDocExpiryDate: json["vehicleDocExpiryDate"],
        vehicleDriverNatIdExpiryDate: json["vehicleDriverNatIdExpiryDate"],
        vehicleOwnerNatIdExpiryDate: json["vehicleOwnerNatIdExpiryDate"],
        licenseExpiryDate: json["licenseExpiryDate"],
        proceedFirstTimeApproval: json["proceedFirstTimeApproval"],
        isPending: json["isPending"] ?? false,
        canTransportFurniture: json["canTransportFurniture"],
        canTransportGoods: json["canTransportGoods"],
        canTransportFrozen: json["canTransportFrozen"],
        hasWaterTank: json["hasWaterTank"],
        hasOtherTanks: json["hasOtherTanks"],
        hasPacking: json["hasPacking"],
        hasLoading: json["hasLoading"],
        hasAssembly: json["hasAssembly"],
        hasLifting: json["hasLifting"],
        plateNumber: json["plateNumber"],
        images: List<DriverImage>.from(
            json["images"].map((x) => DriverImage.fromJson(x))).toList(),
        rating: json["rating"],
        acknowledged: json["acknowledged"],
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        userDevice: json["userDevice"],
        tokenExpirationTime: json["tokenExpirationTime"] ?? "",
        disabled: json["disabled"],
        blocked: json["blocked"],
        deleted: json["deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "email": email,
        "driverStatus": driverStatus,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "isPending": isPending,
        "nationalId": nationalId,
        "nationalIdExpiryDate": nationalIdExpiryDate,
        "vehicleDocExpiryDate": vehicleDocExpiryDate,
        "vehicleDriverNatIdExpiryDate": vehicleDriverNatIdExpiryDate,
        "vehicleOwnerNatIdExpiryDate": vehicleOwnerNatIdExpiryDate,
        "licenseExpiryDate": licenseExpiryDate,
        "proceedFirstTimeApproval": proceedFirstTimeApproval,
        "serviceTypes": serviceTypes,
        "registrationStatus": registrationStatus,
        "vehicleType": vehicleType != null ? vehicleType!.toJson() : null,
        "carManufacturer":
            carManufacturer != null ? carManufacturer!.toJson() : null,
        "carModel": carModel != null ? carModel!.toJson() : null,
        "canTransportFurniture": canTransportFurniture,
        "canTransportGoods": canTransportGoods,
        "canTransportFrozen": canTransportFrozen,
        "hasWaterTank": hasWaterTank,
        "hasOtherTanks": hasOtherTanks,
        "hasPacking": hasPacking,
        "hasLoading": hasLoading,
        "captainType": RegistrationConstants.captain,
        "hasAssembly": hasAssembly,
        "hasLifting": hasLifting,
        "businessOwner": businessOwnerId,
        "plateNumber": plateNumber,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "rating": rating,
        "acknowledged": acknowledged,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "userDevice": userDevice,
        "tokenExpirationTime": tokenExpirationTime,
        "disabled": disabled,
        "blocked": blocked,
        "deleted": deleted,
      };
}

class RegistrationStatus {
  int id;
  String value;
  String valueAr;

  RegistrationStatus({
    required this.id,
    required this.value,
    required this.valueAr,
  });

  factory RegistrationStatus.fromJson(Map<String, dynamic> json) =>
      RegistrationStatus(
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

class DriverCarManufacturer {
  int id;
  String carManufacturer;

  DriverCarManufacturer({
    required this.id,
    required this.carManufacturer,
  });

  factory DriverCarManufacturer.fromJson(Map<String, dynamic> json) =>
      DriverCarManufacturer(
        id: json["id"],
        carManufacturer: json["carManufacturer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "carManufacturer": carManufacturer,
      };
}

class DriverCarModel {
  int id;
  DriverCarManufacturer carManufacturerId;
  String modelName;

  DriverCarModel({
    required this.id,
    required this.carManufacturerId,
    required this.modelName,
  });

  factory DriverCarModel.fromJson(Map<String, dynamic> json) => DriverCarModel(
        id: json["id"],
        carManufacturerId:
            DriverCarManufacturer.fromJson(json["carManufacturerId"]),
        modelName: json["modelName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "carManufacturerId": carManufacturerId.toJson(),
        "modelName": modelName,
      };
}

class DriverImage {
  int id;
  String imageName;
  String? imageUrl;

  DriverImage({
    required this.id,
    required this.imageName,
    this.imageUrl,
  });

  factory DriverImage.fromJson(Map<String, dynamic> json) => DriverImage(
        id: json["id"],
        imageName: json["imageName"],
        imageUrl: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageName": imageName,
        "url": imageUrl,
      };
}

class DriverVehicleType {
  int id;
  String vehicleType;
  String serviceType;
  String? driverServiceType;

  DriverVehicleType({
    required this.id,
    required this.vehicleType,
    required this.serviceType,
    this.driverServiceType,
  });

  factory DriverVehicleType.fromJson(Map<String, dynamic> json) =>
      DriverVehicleType(
        id: json["id"],
        vehicleType: json["vehicleType"],
        serviceType: json["serviceType"],
        driverServiceType: json["driverServiceType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicleType": vehicleType,
        "serviceType": serviceType,
        "driverServiceType": driverServiceType,
      };
}

UserDevice userDeviceFromJson(String str) =>
    UserDevice.fromJson(json.decode(str));

String userDeviceToJson(UserDevice data) => json.encode(data.toJson());

class UserDevice {
  String? id;
  String? userId;
  String? registrationId;
  String? deviceOs;
  String? appVersion;

  UserDevice({
    this.registrationId,
    this.appVersion,
    this.deviceOs,
  });

  UserDevice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    registrationId = json['registrationId'];
    deviceOs = json['deviceOS'];
    appVersion = json['appVersion'];
  }

  Map<String, dynamic> toJson() => {
        // "id": registrationId,
        // "userId": registrationId,
        "registrationId": registrationId,
        "deviceOs": deviceOs,
        "appVersion": appVersion,
      };
}
