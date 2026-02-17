import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/service_registration_second_step.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

class BusinessOwnerModel extends DriverBaseModel {
  String? entityName;
  String? taxNumber;
  String? nationalId;
  String? dateOfBirth;
  String? commercialRegisterExpiryDate;
  String? nationalIdExpiryDate;
  String? commercialNumber;
  List<File>? images;
  List<DriverImage>? imagesFromApi;
  UserDevice? userDevice;
  XFile? profileImage;
  bool? proceedFirstTimeApproval;
  DocumentData? boNationalIdDocument;
  DocumentData? boCommercialRegistrationDocument;

  BusinessOwnerModel({
    id,
    firstName,
    lastName,
    mobile,
    email,
    gender,
    token,
    this.profileImage,
    this.taxNumber,
    this.entityName,
    this.dateOfBirth,
    this.commercialRegisterExpiryDate,
    this.nationalId,
    this.nationalIdExpiryDate,
    this.imagesFromApi,
    this.commercialNumber,
    this.userDevice,
    this.proceedFirstTimeApproval,
    this.boNationalIdDocument,
    this.boCommercialRegistrationDocument,
  }) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.mobile = mobile;
    this.email = email;
    this.gender = gender;
    this.imagesFromApi = imagesFromApi;
    this.userDevice = userDevice;
    this.tokenExpirationTime = tokenExpirationTime;
    this.profileImage = profileImage;
    this.captainType = RegistrationConstants.businessOwner;
    this.disabled = disabled;
    this.blocked = blocked;
    this.deleted = deleted;
  }

  BusinessOwnerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    taxNumber = json['taxNumber'];
    dateOfBirth = json['dateOfBirth'];
    commercialRegisterExpiryDate = json['commercialRegisterExpiryDate'];
    nationalId = json['nationalId'];
    nationalIdExpiryDate = json['nationalIdExpiryDate'];
    entityName = json['entityName'];
    proceedFirstTimeApproval = json['proceedFirstTimeApproval'];
    imagesFromApi = List<DriverImage>.from(
        json["images"].map((x) => DriverImage.fromJson(x)));
    commercialNumber = json['commercialNumber'];
    userDevice = json["userDevice"] != null
        ? UserDevice.fromJson(json["userDevice"])
        : null;
    tokenExpirationTime = json["tokenExpirationTime"];
    captainType = RegistrationConstants.businessOwner;
    disabled = json["disabled"];
    blocked = json["blocked"];
    deleted = json["deleted"];
  }

  BusinessOwnerModel.fromJsonDirect(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    commercialRegisterExpiryDate = json['commercialRegisterExpiryDate'];
    taxNumber = json['taxNumber'];
    nationalId = json['nationalId'];
    nationalIdExpiryDate = json['nationalIdExpiryDate'];
    entityName = json['entityName'];
    proceedFirstTimeApproval = json['proceedFirstTimeApproval'];
    imagesFromApi = List<DriverImage>.from(
        json["images"].map((x) => DriverImage.fromJson(x)));
    commercialNumber = json['commercialNumber'];
    userDevice = json["userDevice"] != null
        ? UserDevice.fromJson(json["userDevice"])
        : null;
    tokenExpirationTime = json["tokenExpirationTime"];
    captainType = RegistrationConstants.businessOwner;
    disabled = json["disabled"];
    blocked = json["blocked"];
    deleted = json["deleted"];
  }

  BusinessOwnerModel.fromCachedJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    commercialRegisterExpiryDate = json['commercialRegisterExpiryDate'];
    taxNumber = json['taxNumber'];
    nationalId = json['nationalId'];
    nationalIdExpiryDate = json['nationalIdExpiryDate'];
    entityName = json['entityName'];
    accessToken = json["accessToken"];
    proceedFirstTimeApproval = json["proceedFirstTimeApproval"];
    refreshToken = json["refreshToken"];
    commercialNumber = json['commercialNumber'];
    imagesFromApi = List<DriverImage>.from(
        json["images"].map((x) => DriverImage.fromJson(x)));
    userDevice = json["userDevice"];
    tokenExpirationTime = json["tokenExpirationTime"];
    captainType = RegistrationConstants.businessOwner;
    disabled = json["disabled"];
    blocked = json["blocked"];
    deleted = json["deleted"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['commercialRegisterExpiryDate'] = commercialRegisterExpiryDate;
    data['taxNumber'] = taxNumber;
    data['nationalId'] = nationalId;
    data['nationalIdExpiryDate'] = nationalIdExpiryDate;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['proceedFirstTimeApproval'] = proceedFirstTimeApproval;
    data['images'] = imagesFromApi;
    data['entityName'] = entityName;
    data['commercialNumber'] = commercialNumber;
    data['captainType'] = RegistrationConstants.businessOwner;
    data['disabled'] = disabled;
    data['blocked'] = blocked;
    data['deleted'] = deleted;
    if (userDevice != null) data['userDevice'] = userDevice!.toJson();
    return data;
  }
}
