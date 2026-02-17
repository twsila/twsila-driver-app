
import 'package:taxi_for_you/domain/model/transportation_base_model.dart';

import 'lookup_item.dart';

class CisternsModel extends TransportationBaseModel {
  LookupItem? cisternsType;

  CisternsModel();

  CisternsModel.fromJson(Map<String, dynamic> json) {
    fromJSON(json);

    if (json['tankType'] != null) {
      cisternsType = LookupItem.fromJson(json['tankType']);
    }
  }

  Map<String, dynamic> toCisternsJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (cisternsType != null) {
      data['tankType'] = cisternsType!.id.toString();
    }
    return data;
  }

  Map<String, dynamic> toCisternsCopyJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (cisternsType != null) {
      data['tankType'] = cisternsType!.toJson();
    }
    return data;
  }

  CisternsModel copyWith(CisternsModel cisternsModel) {
    return CisternsModel.fromJson(cisternsModel.toCisternsCopyJson());
  }
}
