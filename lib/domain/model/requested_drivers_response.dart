// To parse this JSON data, do
//
//     final requestedDriversResponse = requestedDriversResponseFromJson(jsonString);

import 'dart:convert';

import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';

import '../../data/response/responses.dart';

RequestedDriversResponse requestedDriversResponseFromJson(String str) =>
    RequestedDriversResponse.fromJson(json.decode(str));

String requestedDriversResponseToJson(RequestedDriversResponse data) =>
    json.encode(data.toJson());

class RequestedDriversResponse extends BaseResponse {
  int id;
  BusinessOwnerModel businessOwner;
  Driver driver;
  String driverAcquisitionEnum;
  String creationDate;

  RequestedDriversResponse({
    required this.id,
    required this.businessOwner,
    required this.driver,
    required this.driverAcquisitionEnum,
    required this.creationDate,
  });

  factory RequestedDriversResponse.fromJson(Map<String, dynamic> json) =>
      RequestedDriversResponse(
        id: json["id"],
        businessOwner: BusinessOwnerModel.fromJsonDirect(json["businessOwner"]),
        driver: Driver.fromJson(json["driver"]),
        driverAcquisitionEnum: json["driverAcquisitionEnum"],
        creationDate: json["creationDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "businessOwner": businessOwner.toJson(),
        "driver": driver.toJson(),
        "driverAcquisitionEnum": driverAcquisitionEnum,
        "creationDate": creationDate,
      };
}
