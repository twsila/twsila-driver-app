// To parse this JSON data, do
//
//     final goodsServiceTypeModel = goodsServiceTypeModelFromJson(jsonString);

import 'dart:convert';

GoodsServiceTypeModel goodsServiceTypeModelFromJson(String str) =>
    GoodsServiceTypeModel.fromJson(json.decode(str));

String goodsServiceTypeModelToJson(GoodsServiceTypeModel data) =>
    json.encode(data.toJson());

class GoodsServiceTypeModel {
  int id;
  String serviceType;
  String serviceTypeAr;
  String serviceTypeParam;
  List<TruckType> truckTypes;
  GIcon icon;

  GoodsServiceTypeModel({
    required this.id,
    required this.serviceType,
    required this.serviceTypeAr,
    required this.serviceTypeParam,
    required this.truckTypes,
    required this.icon,
  });

  factory GoodsServiceTypeModel.fromJson(Map<String, dynamic> json) =>
      GoodsServiceTypeModel(
        id: json["id"],
        serviceType: json["serviceType"],
        serviceTypeAr: json["serviceTypeAr"],
        serviceTypeParam: json["serviceTypeParam"],
        truckTypes: json["truckTypes"] != null
            ? List<TruckType>.from(
                json["truckTypes"].map((x) => TruckType.fromJson(x)))
            : [],
        icon: GIcon.fromJson(json["icon"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serviceType": serviceType,
        "serviceTypeAr": serviceTypeAr,
        "serviceTypeParam": serviceTypeParam,
        "truckTypes": List<dynamic>.from(truckTypes.map((x) => x.toJson())),
        "icon": icon.toJson(),
      };
}

class GIcon {
  int id;
  String url;

  GIcon({
    required this.id,
    required this.url,
  });

  factory GIcon.fromJson(Map<String, dynamic> json) => GIcon(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}

class TruckType {
  int id;
  String value;
  String valueAr;
  String description;
  String descriptionAr;
  GIcon icon;

  TruckType({
    required this.id,
    required this.value,
    required this.valueAr,
    required this.description,
    required this.descriptionAr,
    required this.icon,
  });

  factory TruckType.fromJson(Map<String, dynamic> json) => TruckType(
        id: json["id"],
        value: json["value"],
        valueAr: json["valueAr"],
        description: json["description"],
        descriptionAr: json["descriptionAr"],
        icon: GIcon.fromJson(json["icon"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "valueAr": valueAr,
        "description": description,
        "descriptionAr": descriptionAr,
        "icon": icon,
      };
}
