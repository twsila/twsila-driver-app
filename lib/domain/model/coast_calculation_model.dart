// To parse this JSON data, do
//
//     final coastCalculationModel = coastCalculationModelFromJson(jsonString);

import 'dart:convert';

CoastCalculationModel coastCalculationModelFromJson(String str) => CoastCalculationModel.fromJson(json.decode(str));

String coastCalculationModelToJson(CoastCalculationModel data) => json.encode(data.toJson());

class CoastCalculationModel {
  double twsilaCommissionForDriverAndBo;
  double twsilaCommissionForPassenger;
  double vatForDriverAndBo;
  double vatForPassenger;

  CoastCalculationModel({
    required this.twsilaCommissionForDriverAndBo,
    required this.twsilaCommissionForPassenger,
    required this.vatForDriverAndBo,
    required this.vatForPassenger,
  });

  factory CoastCalculationModel.fromJson(Map<String, dynamic> json) => CoastCalculationModel(
    twsilaCommissionForDriverAndBo: json["twsilaCommissionForDriverAndBO"]?.toDouble(),
    twsilaCommissionForPassenger: json["twsilaCommissionForPassenger"]?.toDouble(),
    vatForDriverAndBo: json["vatForDriverAndBo"]?.toDouble(),
    vatForPassenger: json["vatForPassenger"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "twsilaCommissionForDriverAndBO": twsilaCommissionForDriverAndBo,
    "twsilaCommissionForPassenger": twsilaCommissionForPassenger,
    "vatForDriverAndBo": vatForDriverAndBo,
    "vatForPassenger": vatForPassenger,
  };
}
