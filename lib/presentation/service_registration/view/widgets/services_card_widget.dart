import 'dart:convert';

import 'package:dartz/dartz_unsafe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:taxi_for_you/domain/model/service_type_model.dart';
import 'package:taxi_for_you/domain/model/vehicle_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_network_image_widget.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/helpers/cast_helpers.dart';
import '../helpers/registration_request.dart';
import 'addiontal_serivces_widget.dart';

class ServiceCard extends StatefulWidget {
  final List<ServiceTypeModel> serviceTypeModelList;
  final bool showServiceCarTypes;
  Function(ServiceTypeModel service) selectedService;
  Function(VehicleModel? vehcileType) selectedVehicleType;
  Function(ThirdServiceLevel? selectedThirdLevel) selectedThirdLevel;
  AdditionalServicesModel additionalServicesModel;
  final RegistrationRequest registrationRequest;

  ServiceCard(
      {Key? key,
      required this.serviceTypeModelList,
      required this.showServiceCarTypes,
      required this.selectedService,
      required this.selectedVehicleType,
      required this.additionalServicesModel,
      required this.selectedThirdLevel,
      required this.registrationRequest})
      : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  ServiceTypeModel? selectedService;
  VehicleModel? selectedVehicleModel;
  ThirdServiceLevel? selectedThirdLevelOfService;
  List<ThirdServiceLevel>? listOfThirdServiceLevel;
  bool refreshVehicleTypes = false;

  @override
  void initState() {
    checkSelectedValues();
    super.initState();
  }

  checkSelectedValues() {
    if (widget.registrationRequest.serviceTypeParam != null) {
      selectedService = widget.serviceTypeModelList.firstWhere((element) =>
          element.serviceName == widget.registrationRequest.serviceTypeParam);
      if (widget.registrationRequest.vehicleTypeId != null &&
          selectedService != null) {
        int vehicleIndex = selectedService!.VehicleModels.indexWhere(
            (element) =>
                element.id.toString() ==
                widget.registrationRequest.vehicleTypeId);
        selectedVehicleModel = selectedService!.VehicleModels[vehicleIndex];
        listOfThirdServiceLevel = handleThirdServiceTypeString(
            selectedService!, selectedVehicleModel!);
        if (widget.registrationRequest.vehicleShapeId != null &&
            listOfThirdServiceLevel != null) {
          selectedThirdLevelOfService = listOfThirdServiceLevel!.firstWhere(
              (element) =>
                  element.id.toString() ==
                  widget.registrationRequest.vehicleShapeId.toString());
        }
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (selectedService != null && selectedVehicleModel != null) {
            selectedService!.isSelected = true;
            selectedVehicleModel!.isSelected = true;
            widget.selectedService(selectedService!);
            widget.selectedVehicleType(selectedVehicleModel!);
            if (selectedThirdLevelOfService != null) {
              selectedThirdLevelOfService!.isSelected = true;
              widget.selectedThirdLevel(selectedThirdLevelOfService);
            }
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.selectServiceType.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.normal,
              color: ColorManager.titlesTextColor),
        ),
        SizedBox(
          height: AppSize.s14,
        ),
        Row(
          children: [
            Wrap(
              direction: Axis.horizontal,
              spacing: context.getWidth() / AppSize.s32,
              runSpacing: 20,
              children: List.generate(
                  widget.serviceTypeModelList.length,
                  (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedService != null &&
                                selectedService !=
                                    widget.serviceTypeModelList[index]) {
                              selectedService!.isSelected = false;
                              selectedService =
                                  widget.serviceTypeModelList[index];
                              selectedService!.isSelected = true;
                              if (selectedVehicleModel != null) {
                                selectedVehicleModel!.isSelected = false;
                                widget.selectedVehicleType(null);
                              }
                            } else {
                              selectedService =
                                  widget.serviceTypeModelList[index];
                              selectedService!.isSelected = true;
                            }
                            widget.selectedService(selectedService!);
                            listOfThirdServiceLevel = null;
                          });
                        },
                        child: FittedBox(
                          child: Container(
                            padding: EdgeInsets.all(AppPadding.p8),
                            decoration: BoxDecoration(
                              color:
                                  widget.serviceTypeModelList[index].isSelected
                                      ? ColorManager.primaryBlueBackgroundColor
                                      : ColorManager.white,
                              borderRadius: BorderRadius.circular(2),
                              border:
                                  Border.all(color: ColorManager.borderColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: AppSize.s28,
                                  height: AppSize.s32,
                                  child: CustomNetworkImageWidget(
                                      imageUrl: widget
                                              .serviceTypeModelList[index]
                                              .serviceIcon!
                                              .url ??
                                          ""),
                                ),
                                SizedBox(
                                  width: AppSize.s8,
                                ),
                                Text(
                                  widget
                                      .serviceTypeModelList[index].serviceName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSize.s12,
                                          color: ColorManager.headersTextColor),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
            ),
          ],
        ),
        SizedBox(
          height: AppSize.s30,
        ),
        Text(
          AppStrings.selectServiceVehicleType.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.normal,
              color: ColorManager.titlesTextColor),
        ),
        SizedBox(
          height: AppSize.s12,
        ),
        selectedService != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: context.getWidth() / AppSize.s32,
                    runSpacing: 15,
                    children: List.generate(
                        selectedService?.VehicleModels.length ?? 0,
                        (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selectedVehicleModel != null &&
                                      selectedVehicleModel !=
                                          selectedService!
                                              .VehicleModels[index]) {
                                    selectedVehicleModel!.isSelected = false;
                                    selectedVehicleModel =
                                        selectedService!.VehicleModels[index];
                                    selectedVehicleModel!.isSelected = true;
                                    selectedThirdLevelOfService = null;
                                    widget.selectedThirdLevel(null);
                                  } else {
                                    selectedVehicleModel =
                                        selectedService!.VehicleModels[index];
                                    selectedVehicleModel!.isSelected = true;
                                  }
                                  widget.selectedVehicleType(
                                      selectedVehicleModel!);
                                  listOfThirdServiceLevel =
                                      handleThirdServiceTypeString(
                                          selectedService!,
                                          selectedVehicleModel!);
                                });
                              },
                              child: FittedBox(
                                child: Container(
                                  padding: EdgeInsets.all(AppPadding.p8),
                                  decoration: BoxDecoration(
                                    color: selectedService?.VehicleModels[index]
                                                .isSelected ??
                                            false
                                        ? ColorManager
                                            .primaryBlueBackgroundColor
                                        : ColorManager.white,
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                        color: ColorManager.borderColor),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: AppSize.s28,
                                        height: AppSize.s32,
                                        child: CustomNetworkImageWidget(
                                            imageUrl: selectedService!
                                                    .VehicleModels[index]
                                                    .icon
                                                    ?.url ??
                                                ""),
                                      ),
                                      SizedBox(
                                        width: AppSize.s8,
                                      ),
                                      Text(
                                        selectedService?.VehicleModels[index]
                                                .vehicleType ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: FontSize.s12,
                                                color: ColorManager
                                                    .headersTextColor),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    selectedService! == widget.serviceTypeModelList[1]
                        ? AppStrings.vehicleShape.tr()
                        : AppStrings.numberOfPassengers.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: ColorManager.titlesTextColor),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  listOfThirdServiceLevel != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              listOfThirdServiceLevel!.length ?? 0,
                              (index) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selectedThirdLevelOfService !=
                                                null &&
                                            selectedThirdLevelOfService !=
                                                listOfThirdServiceLevel![
                                                    index]) {
                                          selectedThirdLevelOfService!
                                              .isSelected = false;
                                          selectedThirdLevelOfService =
                                              listOfThirdServiceLevel![index];
                                          selectedThirdLevelOfService!
                                              .isSelected = true;
                                        } else {
                                          selectedThirdLevelOfService =
                                              listOfThirdServiceLevel![index];
                                          selectedThirdLevelOfService!
                                              .isSelected = true;
                                        }
                                        widget.selectedThirdLevel(
                                            selectedThirdLevelOfService!);
                                        widget.registrationRequest
                                                .vehicleShapeId =
                                            selectedThirdLevelOfService!.id
                                                .toString();
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          listOfThirdServiceLevel![index].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  color: ColorManager
                                                      .headersTextColor),
                                        ),
                                        SizedBox(
                                          width: AppSize.s30,
                                        ),
                                        Visibility(
                                          visible:
                                              listOfThirdServiceLevel![index]
                                                          .isSelected ??
                                                      false
                                                  ? true
                                                  : false,
                                          child: Icon(
                                            Icons.check,
                                            color: ColorManager
                                                .purpleMainTextColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                        )
                      : Container(),
                ],
              )
            : Container(),
        selectedService != null &&
                selectedService! == widget.serviceTypeModelList[1]
            ? AdditionalServicesWidget(
                additionalServicesModel: widget.additionalServicesModel,
                registrationRequest: widget.registrationRequest,
              )
            : Container()
      ],
    );
  }

  List<ThirdServiceLevel> handleThirdServiceTypeString(
      ServiceTypeModel serviceTypeModel, VehicleModel vehicleModel) {
    List<ThirdServiceLevel> thirdServiceLevel = [];
    if (serviceTypeModel == widget.serviceTypeModelList[1]) {
      if (vehicleModel.vehicleShapes != null &&
          vehicleModel.vehicleShapes!.isNotEmpty) {
        vehicleModel.vehicleShapes!.forEach((vehicleShape) {
          thirdServiceLevel
              .add(ThirdServiceLevel(vehicleShape.id, vehicleShape.value));
        });
      }
    } else {
     if(vehicleModel.numberOfPassengers != null && vehicleModel.numberOfPassengers!.isNotEmpty){
       vehicleModel.numberOfPassengers!.forEach((numberOfPassenger) {
         thirdServiceLevel.add(ThirdServiceLevel(numberOfPassenger.id,
             "${numberOfPassenger.numberOfPassengers.toString()}"));
       });
     }
    }
    return thirdServiceLevel;
  }
}

class Service {
  String name;
  List<VehicleModel> vehicleModels;

  Service(this.name, this.vehicleModels);
}

class Vehicle {
  int id;
  String vehicleType;
  String driverServiceType;

  Vehicle(this.id, this.vehicleType, this.driverServiceType);
}

class ThirdServiceLevel {
  int id;
  String name;
  bool? isSelected;

  ThirdServiceLevel(this.id, this.name, {this.isSelected = false});
}
