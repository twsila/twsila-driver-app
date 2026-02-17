// To parse this JSON data, do
//
//     final carBrandAndModelsModel = carBrandAndModelsModelFromJson(jsonString);

import 'dart:convert';

CarsResponseModel CarsResponseModelFromJson(String str) =>
    CarsResponseModel.fromJson(json.decode(str));

String CarsResponseModelToJson(CarsResponseModel data) =>
    json.encode(data.toJson());

class CarsResponseModel {
  bool success;
  dynamic message;
  String dateTime;
  List<CarModel> result;

  CarsResponseModel({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory CarsResponseModel.fromJson(Map<String, dynamic> json) =>
      CarsResponseModel(
        success: json["success"],
        message: json["message"],
        dateTime: json["dateTime"],
        result: List<CarModel>.from(
            json["result"].map((x) => CarModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "dateTime": dateTime,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

CarsManufacturerResponseModel CarsManufacturerResponseModelFromJson(
        String str) =>
    CarsManufacturerResponseModel.fromJson(json.decode(str));

String CarsManufacturerResponseModelToJson(CarsResponseModel data) =>
    json.encode(data.toJson());

class CarsManufacturerResponseModel {
  bool success;
  dynamic message;
  String dateTime;
  List<CarManufacturerModel> result;

  CarsManufacturerResponseModel({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory CarsManufacturerResponseModel.fromJson(Map<String, dynamic> json) =>
      CarsManufacturerResponseModel(
        success: json["success"],
        message: json["message"],
        dateTime: json["dateTime"],
        result: List<CarManufacturerModel>.from(
            json["result"].map((x) => CarModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "dateTime": dateTime,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

CarModel carModelFromJson(String str) => CarModel.fromJson(json.decode(str));

String carModelToJson(CarModel data) => json.encode(data.toJson());

class CarModel {
  int id;
  CarManufacturerModel carManufacturer;
  String modelName;
  String modelNameAr;

  CarModel({
    required this.id,
    required this.carManufacturer,
    required this.modelName,
    required this.modelNameAr,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json["id"],
        carManufacturer: CarManufacturerModel.fromJson(json["carManufacturer"]),
        modelName: json["modelName"],
        modelNameAr: json["modelNameAr"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "carManufacturer": carManufacturer.toJson(),
        "modelName": modelName,
        "modelNameAr": modelNameAr,
      };
}

// To parse this JSON data, do
//
//     final carManufacturerModel = carManufacturerModelFromJson(jsonString);

CarManufacturerModel carManufacturerModelFromJson(String str) =>
    CarManufacturerModel.fromJson(json.decode(str));

String carManufacturerModelToJson(CarManufacturerModel data) =>
    json.encode(data.toJson());

class CarManufacturerModel {
  int id;
  bool showInTwsila;
  String carManufacturerEn;
  String carManufacturerAr;

  CarManufacturerModel({
    required this.id,
    required this.showInTwsila,
    required this.carManufacturerEn,
    required this.carManufacturerAr,
  });

  factory CarManufacturerModel.fromJson(Map<String, dynamic> json) =>
      CarManufacturerModel(
        id: json["id"],
        showInTwsila: json["showInTwsila"],
        carManufacturerEn: json["carManufacturerEn"],
        carManufacturerAr: json["carManufacturerAr"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "showInTwsila": showInTwsila,
        "carManufacturerEn": carManufacturerEn,
        "carManufacturerAr": carManufacturerAr,
      };
}
