import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/domain/model/persons_model.dart';
import 'package:taxi_for_you/domain/model/transportation_base_model.dart';
import 'package:taxi_for_you/domain/model/water_model.dart';

import 'car-aid-model.dart';
import 'cisterns_model.dart';
import 'freezers-model.dart';
import 'furniture_model.dart';
import 'goods_model.dart';

class TripDetailsModel {
  final TransportationBaseModel tripDetails;

  TripDetailsModel({required this.tripDetails});

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    var details;
    String tripType = json['serviceType'];

    if (tripType == TripTypeConstants.furnitureType) {
      details = FurnitureModel.fromJson(json);
    } else if (tripType == TripTypeConstants.goodsType) {
      details = GoodsModel.fromJson(json);
    } else if (tripType == TripTypeConstants.frozenType) {
      details = FreezersModel.fromJson(json);
    } else if (tripType == TripTypeConstants.carAidType) {
      details = CarAidModel.fromJson(json);
    } else if (tripType == TripTypeConstants.drinkWaterType) {
      details = WaterModel.fromJson(json);
    } else if (tripType == TripTypeConstants.otherTankType) {
      details = CisternsModel.fromJson(json);
    } else if (tripType == TripTypeConstants.personsType) {
      details = PersonsModel.fromJson(json);
    }

    return TripDetailsModel(tripDetails: details);
  }
}

