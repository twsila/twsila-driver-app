// To parse this JSON data, do
//
//     final addRequestModel = addRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';

AddRequestModel addRequestModelFromJson(String str) =>
    AddRequestModel.fromJson(json.decode(str));

String addRequestModelToJson(AddRequestModel data) =>
    json.encode(data.toJson());

class AddRequestModel {
  int id;
  BusinessOwnerModel businessOwner;
  String driverAcquisitionEnum;
  String creationDate;

  AddRequestModel({
    required this.id,
    required this.businessOwner,
    required this.driverAcquisitionEnum,
    required this.creationDate,
  });

  factory AddRequestModel.fromJson(Map<String, dynamic> json) =>
      AddRequestModel(
        id: json["id"],
        businessOwner: BusinessOwnerModel.fromJson(json["businessOwner"]),
        driverAcquisitionEnum: json["driverAcquisitionEnum"],
        creationDate: json["creationDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "businessOwner": businessOwner.toJson(),
        "driverAcquisitionEnum": driverAcquisitionEnum,
        "creationDate": creationDate,
      };
}
