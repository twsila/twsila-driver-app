
import 'package:taxi_for_you/domain/model/transportation_base_model.dart';

class CarAidModel extends TransportationBaseModel {
  CarAidModel();

  CarAidModel.fromJson(Map<String, dynamic> json) {
    fromJSON(json);
  }

  Map<String, dynamic> toCarAidJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    return data;
  }

  CarAidModel copyWith(CarAidModel carAidModel) {
    return CarAidModel.fromJson(carAidModel.toCarAidJson());
  }
}
