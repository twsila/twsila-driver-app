import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/services_card_widget.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';

import '../../../../domain/model/service_type_model.dart';
import '../../../../domain/model/vehicle_model.dart';
import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';

class ServiceTypeWidget extends StatefulWidget {
  final List<ServiceTypeModel> serviceTypeModelList;
  Function(ServiceTypeModel service) selectedService;
  Function(VehicleModel? vehcileType) selectedVehicleType;
  ThirdServiceLevel? selectedThirdLevelOfService;

  ServiceTypeWidget(
      {required this.serviceTypeModelList,
      required this.selectedService,
      required this.selectedVehicleType,
      required this.selectedThirdLevelOfService});

  @override
  State<ServiceTypeWidget> createState() => _ServiceTypeWidgetState();
}

class _ServiceTypeWidgetState extends State<ServiceTypeWidget> {
  ServiceTypeModel? selectedService;
  VehicleModel? selectedVehicleModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
                                Image.asset(
                                  ImageAssets.newAppBarLogo,
                                  color: ColorManager.splashBGColor,
                                  height: AppSize.s33,
                                  width: AppSize.s33,
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
      ],
    );
  }
}
