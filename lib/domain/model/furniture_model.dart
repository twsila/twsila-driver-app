import 'dart:convert';

import 'package:taxi_for_you/domain/model/transportation_base_model.dart';

import '../../utils/helpers/double_prase.dart';

class FurnitureModel extends TransportationBaseModel {
  FurnitureItems furnitureItems = FurnitureItems();
  bool containsLoading = false;
  bool containsAssemble = false;
  bool containsPacking = false;
  bool containsLift = false;

  FurnitureModel();

  FurnitureModel.fromJson(Map<String, dynamic> json) {
    fromJSON(json);
    furnitureItems =
        FurnitureItems.fromJson(jsonDecode(json['furnitureItems']));
    containsLoading = json['containsLoading'] is String
        ? json['containsLoading'] == 'true'
        : json['containsLoading'];
    containsAssemble = json['containsAssemble'] is String
        ? json['containsAssemble'] == 'true'
        : json['containsAssemble'];
    containsPacking = json['containsPacking'] is String
        ? json['containsPacking'] == 'true'
        : json['containsPacking'];
    containsLift = json['containsLift'] is String
        ? json['containsLift'] == 'true'
        : json['containsLift'];
  }

  Map<String, dynamic> toFurnitureJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    data['furnitureItems'] = json.encode(furnitureItems.toJson());
    data['containsLoading'] = containsLoading.toString();
    data['containsAssemble'] = containsAssemble.toString();
    data['containsPacking'] = containsPacking.toString();
    data['containsLift'] = containsLift.toString();
    return data;
  }



  FurnitureModel copyWith(FurnitureModel furnitureModel) {
    return FurnitureModel.fromJson(furnitureModel.toFurnitureJson());
  }
}

class FurnitureItems {
  double roomsNumber = 0;
  double fridgeNumber = 0;
  double sofaSetNumber = 0;
  double carpetNumber = 0;
  double windowAirconditionerNumber = 0;
  double splitAirconditionerNumber = 0;
  double kitchenNumber = 0;
  double tablesNumber = 0;
  double diningRoomNumber = 0;
  double other = 0;

  FurnitureItems();

  FurnitureItems.fromJson(Map<String, dynamic> json) {
    roomsNumber = dynamicToDouble(json['roomsNumber']) ?? 0;
    fridgeNumber = dynamicToDouble(json['fridgeNumber']) ?? 0;
    sofaSetNumber = dynamicToDouble(json['sofaSetNumber']) ?? 0;
    carpetNumber = dynamicToDouble(json['carpetNumber']) ?? 0;
    windowAirconditionerNumber =
        dynamicToDouble(json['windowAirconditionerNumber']) ?? 0;
    splitAirconditionerNumber =
        dynamicToDouble(json['splitAirconditionerNumber']) ?? 0;
    kitchenNumber = dynamicToDouble(json['kitchenNumber']) ?? 0;
    tablesNumber = dynamicToDouble(json['tablesNumber']) ?? 0;
    diningRoomNumber = dynamicToDouble(json['diningRoomNumber']) ?? 0;
    other = dynamicToDouble(json['other']) ?? 0;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['roomsNumber'] = roomsNumber.toString();
    data['fridgeNumber'] = fridgeNumber.toString();
    data['sofaSetNumber'] = sofaSetNumber.toString();
    data['carpetNumber'] = carpetNumber.toString();
    data['windowAirconditionerNumber'] = windowAirconditionerNumber.toString();
    data['splitAirconditionerNumber'] = splitAirconditionerNumber.toString();
    data['kitchenNumber'] = kitchenNumber.toString();
    data['tablesNumber'] = tablesNumber.toString();
    data['diningRoomNumber'] = diningRoomNumber.toString();
    data['other'] = other.toString();
    return data;
  }
}
