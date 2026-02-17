import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';
import '../../../../domain/model/goods_model.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/styles_manager.dart';
import '../../../common/widgets/custom_checkbox.dart';

class AdditionalServicesWidget extends StatefulWidget {
  final AdditionalServicesModel additionalServicesModel;
  RegistrationRequest registrationRequest;

  AdditionalServicesWidget(
      {Key? key,
      required this.additionalServicesModel,
      required this.registrationRequest})
      : super(key: key);

  @override
  _AdditionalServicesWidgetState createState() =>
      _AdditionalServicesWidgetState();
}

class _AdditionalServicesWidgetState extends State<AdditionalServicesWidget> {
  @override
  void initState() {
    widget.additionalServicesModel.canTransportFurniture =
        widget.registrationRequest.canTransportFurniture ?? false;

    widget.additionalServicesModel.canTransportGoods =
        widget.registrationRequest.canTransportGoods ?? false;

    widget.additionalServicesModel.canTransportFrozen =
        widget.registrationRequest.canTransportFrozen ?? false;

    widget.additionalServicesModel.hasWaterTank =
        widget.registrationRequest.hasWaterTank ?? false;

    widget.additionalServicesModel.hasOtherTanks =
        widget.registrationRequest.hasOtherTanks ?? false;

    widget.additionalServicesModel.hasPacking =
        widget.registrationRequest.hasPacking ?? false;

    widget.additionalServicesModel.hasLoading =
        widget.registrationRequest.hasLoading ?? false;

    widget.additionalServicesModel.hasLifting =
        widget.registrationRequest.hasLifting ?? false;

    widget.additionalServicesModel.hasAssembly =
        widget.registrationRequest.hasAssembly ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSize.s16,
        ),
        Text(
          AppStrings.extraServices.tr(),
          textAlign: TextAlign.start,
          style: getMediumStyle(
            color: ColorManager.titlesTextColor,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: AppSize.s16,
        ),
        Visibility(
          visible: false,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomCheckBox(
                    checked:
                        widget.additionalServicesModel.canTransportFurniture ??
                            false,
                    fieldName: AppStrings.canTransportFurniture.tr(),
                    onChange: (checked) {
                      widget.additionalServicesModel.canTransportFurniture =
                          checked;
                      widget.registrationRequest.canTransportFurniture =
                          checked;
                    }),
              ),
              Expanded(
                flex: 1,
                child: CustomCheckBox(
                    checked: widget.additionalServicesModel.canTransportGoods ??
                        false,
                    fieldName: AppStrings.canTransportGoods.tr(),
                    onChange: (checked) {
                      widget.additionalServicesModel.canTransportGoods =
                          checked;
                      widget.registrationRequest.canTransportGoods = checked;
                    }),
              ),
            ],
          ),
        ),
        Visibility(
          visible: false,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomCheckBox(
                    checked:
                        widget.additionalServicesModel.canTransportFrozen ??
                            false,
                    fieldName: AppStrings.canTransportFrozen.tr(),
                    onChange: (checked) {
                      widget.additionalServicesModel.canTransportFrozen =
                          checked;
                      widget.registrationRequest.canTransportFrozen = checked;
                    }),
              ),
              Expanded(
                flex: 1,
                child: CustomCheckBox(
                    checked:
                        widget.additionalServicesModel.hasWaterTank ?? false,
                    fieldName: AppStrings.hasWaterTank.tr(),
                    onChange: (checked) {
                      widget.additionalServicesModel.hasWaterTank = checked;
                      widget.registrationRequest.hasWaterTank = checked;
                    }),
              ),
            ],
          ),
        ),
        Visibility(
          visible: false,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomCheckBox(
                    checked:
                        widget.additionalServicesModel.hasOtherTanks ?? false,
                    fieldName: AppStrings.hasOtherTanks.tr(),
                    onChange: (checked) {
                      widget.additionalServicesModel.hasOtherTanks = checked;
                      widget.registrationRequest.hasOtherTanks = checked;
                    }),
              ),
              Expanded(
                flex: 1,
                child: CustomCheckBox(
                    checked: widget.additionalServicesModel.hasPacking ?? false,
                    fieldName: AppStrings.hasPacking.tr(),
                    onChange: (checked) {
                      widget.additionalServicesModel.hasPacking = checked;
                      widget.registrationRequest.hasPacking = checked;
                    }),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomCheckBox(
                  checked: widget.additionalServicesModel.hasLoading ?? false,
                  fieldName: AppStrings.hasLoading.tr(),
                  onChange: (checked) {
                    widget.additionalServicesModel.hasLoading = checked;
                    widget.registrationRequest.hasLoading = checked;
                  }),
            ),
            Expanded(
              flex: 1,
              child: CustomCheckBox(
                  checked: widget.additionalServicesModel.hasAssembly ?? false,
                  fieldName: AppStrings.hasAssembly.tr(),
                  onChange: (checked) {
                    widget.additionalServicesModel.hasAssembly = checked;
                    widget.registrationRequest.hasAssembly = checked;
                  }),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomCheckBox(
                  checked: widget.additionalServicesModel.hasLifting ?? false,
                  fieldName: AppStrings.hasLifting.tr(),
                  onChange: (checked) {
                    widget.additionalServicesModel.hasLifting = checked;
                    widget.registrationRequest.hasLifting = checked;
                  }),
            ),
            Expanded(
              flex: 1,
              child: CustomCheckBox(
                  checked: widget.additionalServicesModel.hasPacking ?? false,
                  fieldName: AppStrings.hasPacking.tr(),
                  onChange: (checked) {
                    widget.additionalServicesModel.hasPacking = checked;
                    widget.registrationRequest.hasPacking = checked;
                  }),
            ),
          ],
        ),
      ],
    );
  }
}

class AdditionalServicesModel {
  bool? canTransportFurniture;
  bool? canTransportGoods;
  bool? canTransportFrozen;
  bool? hasWaterTank;
  bool? hasOtherTanks;
  bool? hasPacking;
  bool? hasLoading;
  bool? hasAssembly;
  bool? hasLifting;

  AdditionalServicesModel({
    this.canTransportFurniture = false,
    this.canTransportGoods = false,
    this.canTransportFrozen = false,
    this.hasWaterTank = false,
    this.hasOtherTanks = false,
    this.hasPacking = false,
    this.hasLoading = false,
    this.hasAssembly = false,
    this.hasLifting = false,
  });
}
