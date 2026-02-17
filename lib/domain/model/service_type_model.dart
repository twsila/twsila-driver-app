import 'package:taxi_for_you/domain/model/vehicle_model.dart';

class ServiceTypeModel {
  String serviceName;
  ServiceIcon? serviceIcon;
  List<VehicleModel> VehicleModels;
  bool isSelected;

  ServiceTypeModel(
    this.serviceName,
    this.VehicleModels,
    this.serviceIcon, {
    this.isSelected = false,
  });
}

class ServiceIcon {
  int? id;
  String? url;

  ServiceIcon({required this.id, required this.url});

  factory ServiceIcon.fromJson(Map<String, dynamic> json) => ServiceIcon(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}

