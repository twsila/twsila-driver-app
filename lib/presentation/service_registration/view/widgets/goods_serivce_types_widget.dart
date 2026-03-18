import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:taxi_for_you/domain/model/lookupValueModel.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_network_image_widget.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/tank_size_widget.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/tank_types_widget.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/vehicle_shape_widget.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';

import '../../../../domain/model/goods_service_type_model.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';

class GoodsServiceTypesWidget extends StatefulWidget {
  final String lang;
  final RegistrationRequest registrationRequest;
  final List<GoodsServiceTypeModel> goodsServiceTypesList;
  final List<LookupValueModel> tankTypesList;
  final List<LookupValueModel> tankSizesList;
  final Function(GoodsServiceTypeModel selectedService) selectedService;
  final Function(LookupValueModel? selectedTankType) onSelectTankType;
  final Function(LookupValueModel? selectedTankSize) onSelectTankSize;
  final Function(TruckType vehicleShape) selectedVehicleShape;

  GoodsServiceTypesWidget(
      {required this.lang,
      required this.registrationRequest,
      required this.tankTypesList,
      required this.tankSizesList,
      required this.goodsServiceTypesList,
      required this.selectedService,
      required this.onSelectTankType,
      required this.onSelectTankSize,
      required this.selectedVehicleShape});

  @override
  State<GoodsServiceTypesWidget> createState() =>
      _GoodsServiceTypesWidgetState();
}

class _GoodsServiceTypesWidgetState extends State<GoodsServiceTypesWidget> {
  int current = -1;
  GoodsServiceTypeModel? selectedGoodsServiceTypeModel;
  TruckType? vehicleShape;

  @override
  void didUpdateWidget(GoodsServiceTypesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.goodsServiceTypesList != oldWidget.goodsServiceTypesList) {
      checkSelectedValues();
    }
  }

  checkSelectedValues() {
    try {
      if (widget.registrationRequest.serviceTypeParam != null && mounted) {
        int serviceIndex = widget.goodsServiceTypesList.indexWhere((element) =>
            element.serviceTypeParam ==
            widget.registrationRequest.serviceTypeParam);
        selectedGoodsServiceTypeModel =
            widget.goodsServiceTypesList[serviceIndex];

        if (widget.registrationRequest.vehicleTypeId != null &&
            selectedGoodsServiceTypeModel != null &&
            selectedGoodsServiceTypeModel!.truckTypes.isNotEmpty) {
          int vehicleIndex = selectedGoodsServiceTypeModel!.truckTypes
              .indexWhere((element) =>
                  element.id.toString() ==
                  widget.registrationRequest.vehicleTypeId);

          if (vehicleIndex < selectedGoodsServiceTypeModel!.truckTypes.length) {
            vehicleShape =
                selectedGoodsServiceTypeModel!.truckTypes[vehicleIndex];
          }
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          setState(() {
            if (selectedGoodsServiceTypeModel != null && vehicleShape != null) {
              current = widget.goodsServiceTypesList
                  .indexOf(selectedGoodsServiceTypeModel!);
              widget.selectedService(selectedGoodsServiceTypeModel!);
              widget.selectedVehicleShape(vehicleShape!);
            }
          });
        });
      }
    } catch (e) {
      debugPrint('[GoodsServiceTypes] Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.selectSubServiceType.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.normal,
              color: ColorManager.titlesTextColor),
        ),
        SizedBox(
          height: AppSize.s14,
        ),
        Wrap(
          direction: Axis.horizontal,
          spacing: context.getWidth() / AppSize.s32,
          runSpacing: 20,
          children: List.generate(
              widget.goodsServiceTypesList.length,
              (index) => GestureDetector(
                    onTap: () {
                      current = index;
                      if (selectedGoodsServiceTypeModel != null &&
                          selectedGoodsServiceTypeModel!.id != 4) {
                        //OTHER TANK SERVICE ID
                        widget.onSelectTankType(null);
                      }
                      setState(() {
                        widget.selectedService(
                            widget.goodsServiceTypesList[index]);
                        selectedGoodsServiceTypeModel =
                            widget.goodsServiceTypesList[index];
                      });
                    },
                    child: FittedBox(
                      child: Container(
                        padding: EdgeInsets.all(AppPadding.p8),
                        decoration: BoxDecoration(
                          color: current == index
                              ? ColorManager.thirdAccentColor
                              : ColorManager.white,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                              color: current == index
                                  ? ColorManager.thirdAccentColor
                                  : ColorManager.borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: AppSize.s28,
                              height: AppSize.s32,
                              child: CustomNetworkImageWidget(
                                imageUrl: widget
                                    .goodsServiceTypesList[index].icon.url,
                              ),
                            ),
                            SizedBox(
                              width: AppSize.s8,
                            ),
                            Text(
                              widget.lang == ARABIC
                                  ? widget.goodsServiceTypesList[index]
                                      .serviceTypeAr
                                  : widget
                                      .goodsServiceTypesList[index].serviceType,
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
        //OTHER_TANK service type id is 4
        Visibility(
            visible: selectedGoodsServiceTypeModel != null &&
                selectedGoodsServiceTypeModel!.id == 4 &&
                widget.tankTypesList.isNotEmpty,
            child: TankTypesWidget(
              tankTypesList: widget.tankTypesList,
              onSelectTankType: (tankType) {
                widget.onSelectTankType(tankType);
              },
            )),
        // DRINK_WATER_TANK service type id is 5
        Visibility(
            visible: selectedGoodsServiceTypeModel != null &&
                selectedGoodsServiceTypeModel!.id == 5 &&
                widget.tankSizesList.isNotEmpty,
            child: TankSizeWidget(
              tankSizeList: widget.tankSizesList,
              onSelectTankSize: (tankSize) {
                widget.onSelectTankSize(tankSize);
              },
            )),
        VehicleShapeWidget(
            lang: widget.lang,
            preselectedVehicle: this.vehicleShape,
            vehicleShapesList: selectedGoodsServiceTypeModel?.truckTypes ?? [],
            selectedVehicle: (vehicleShapes) {
              widget.selectedVehicleShape(vehicleShapes);
            })
      ],
    );
  }
}
