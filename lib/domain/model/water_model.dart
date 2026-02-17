import 'package:taxi_for_you/domain/model/transportation_base_model.dart';

import 'lookup_item.dart';

class WaterModel extends TransportationBaseModel {
  LookupItem? tankSize;

  WaterModel();

  WaterModel.fromJson(Map<String, dynamic> json) {
    fromJSON(json);
    if (json['tankSize'] != null) {
      tankSize = LookupItem.fromJson(json['tankSize']);
    }
  }

  Map<String, dynamic> toWaterJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (tankSize != null) {
      data['tankSize'] = tankSize!.id.toString();
    }
    return data;
  }

  Map<String, dynamic> toWaterCopyJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (tankSize != null) {
      data['tankSize'] = tankSize!.toJson();
    }
    return data;
  }

  WaterModel copyWith(WaterModel waterModel) {
    return WaterModel.fromJson(waterModel.toWaterCopyJson());
  }
}
