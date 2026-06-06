import 'package:taxi_for_you/domain/model/transportation_base_model.dart';

import '../../utils/helpers/double_prase.dart';
import 'lookup_item.dart';

class GoodsModel extends TransportationBaseModel {
  double? payloadWeight;
  LookupItem? materialType;
  LookupItem? packingType;
  bool containsLoading = false;
  bool containsPacking = false;
  bool containsLift = false;

  GoodsModel();

  GoodsModel.fromJson(Map<String, dynamic> json) {
    fromJSON(json);
    if (json['payloadWeight'] != null) {
      payloadWeight = dynamicToDouble(json['payloadWeight']);
    }
    if (json['packingType'] != null) {
      packingType = LookupItem.fromJson(json['packingType']);
    }
    if (json['materialType'] != null) {
      materialType = LookupItem.fromJson(json['materialType']);
    }
    containsLoading = json['containsLoading'] is String
        ? json['containsLoading'] == "true"
        : json['containsLoading'];
    containsPacking = json['containsPacking'] is String
        ? json['containsPacking'] == "true"
        : json['containsPacking'];
    containsLift = json['containsLift'] is String
        ? json['containsLift'] == true
        : json['containsLift'];
  }

  Map<String, dynamic> toGoodsJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (payloadWeight != null) {
      data['payloadWeight'] = payloadWeight.toString();
    }
    if (packingType != null) {
      data['packingType'] = packingType!.id.toString();
    }
    if (materialType != null) {
      data['materialType'] = materialType!.id.toString();
    }
    data['containsLoading'] = containsLoading.toString();
    data['containsPacking'] = containsPacking.toString();
    data['containsLift'] = containsLift.toString();
    return data;
  }

  Map<String, dynamic> toGoodsCopyJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (payloadWeight != null) {
      data['payloadWeight'] = payloadWeight.toString();
    }
    if (packingType != null) {
      data['packingType'] = packingType!.toJson();
    }
    if (materialType != null) {
      data['materialType'] = materialType!.toJson();
    }
    data['containsLoading'] = containsLoading.toString();
    data['containsPacking'] = containsPacking.toString();
    data['containsLift'] = containsLift.toString();
    return data;
  }

  GoodsModel copyWith(GoodsModel goodsModel) {
    return GoodsModel.fromJson(goodsModel.toGoodsCopyJson());
  }
}
