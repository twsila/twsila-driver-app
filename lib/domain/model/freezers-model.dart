import 'package:taxi_for_you/domain/model/single_lookup_model.dart';
import 'package:taxi_for_you/domain/model/transportation_base_model.dart';

import '../../utils/helpers/double_prase.dart';

class FreezersModel extends TransportationBaseModel {
  LookupItem? shippedType;
  LookupItem? frozenType;
  double? payloadWeight;
  bool containsLoading = false;
  bool containsPacking = false;
  bool containsLift = false;

  FreezersModel();

  FreezersModel.fromJson(Map<String, dynamic> json) {
    fromJSON(json);
    if (json['shippingType'] != null) {
      shippedType = LookupItem.fromJson(json['shippingType']);
    }
    if (json['frozenType'] != null) {
      frozenType = LookupItem.fromJson(json['frozenType']);
    }
    if (json['payloadWeight'] != null) {
      payloadWeight = dynamicToDouble(json['payloadWeight']);
    }
    containsLoading = json['containsLoading'] is String
        ? json['containsLoading'] == "true"
        : json['containsLoading'];
    containsPacking = json['containsPacking'] is String
        ? json['containsPacking'] == "true"
        : json['containsPacking'];
    containsLift = json['containsLift'] is String
        ? json['containsLift'] == "true"
        : json['containsLift'];
  }

  Map<String, dynamic> toFreezersJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (shippedType != null) {
      data['shippingType'] = shippedType!.id.toString();
    }
    if (frozenType != null) {
      data['frozenType'] = frozenType!.id.toString();
    }
    if (payloadWeight != null) {
      data['payloadWeight'] = payloadWeight.toString();
    }
    data['containsLoading'] = containsLoading.toString();
    data['containsPacking'] = containsPacking.toString();
    data['containsLift'] = containsLift.toString();
    return data;
  }

  Map<String, dynamic> toFreezersCopyJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (shippedType != null) {
      data['shippingType'] = shippedType!.toJson();
    }
    if (frozenType != null) {
      data['frozenType'] = frozenType!.toJson();
    }
    if (payloadWeight != null) {
      data['payloadWeight'] = payloadWeight.toString();
    }
    data['containsLoading'] = containsLoading.toString();
    data['containsPacking'] = containsPacking.toString();
    data['containsLift'] = containsLift.toString();
    return data;
  }

  FreezersModel copyWith(FreezersModel freezersModel) {
    return FreezersModel.fromJson(freezersModel.toFreezersCopyJson());
  }
}
