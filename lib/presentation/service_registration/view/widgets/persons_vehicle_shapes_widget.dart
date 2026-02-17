import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:taxi_for_you/domain/model/vehicle_model.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/number_of_passenger_widget.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';

import '../../../../domain/model/persons_vehicle_type_model.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/langauge_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_network_image_widget.dart';
import '../helpers/registration_request.dart';

class PersonsVehicleTypesWidget extends StatefulWidget {
  final String lang;
  final RegistrationRequest registrationRequest;
  final List<PersonsVehicleTypeModel> personsVehicleTypesList;
  final Function(PersonsVehicleTypeModel personsVehicleTypeModel)
      selectedPersonsVehicleTypeModel;
  final Function(NumberOfPassenger numberOfPassengers)
      selectedNumberOfPassengers;

  PersonsVehicleTypesWidget(
      {required this.registrationRequest,
      required this.lang,
      required this.personsVehicleTypesList,
      required this.selectedPersonsVehicleTypeModel,
      required this.selectedNumberOfPassengers});

  @override
  State<PersonsVehicleTypesWidget> createState() =>
      _PersonsVehicleTypesWidgetState();
}

class _PersonsVehicleTypesWidgetState extends State<PersonsVehicleTypesWidget> {
  int current = -1;
  PersonsVehicleTypeModel? selectedPersonVehicle;
  NumberOfPassenger? selectedNumberOfPassenger;

  @override
  void initState() {
    super.initState();
    sortValuesList();
    checkSelectedValues();
  }

  checkSelectedValues() {
    try {
      if (widget.registrationRequest.serviceTypeParam != null &&
          widget.registrationRequest.serviceTypeParam == "PERSONS" &&
          widget.registrationRequest.vehicleTypeId != null &&
          mounted) {
        int serviceIndex = widget.personsVehicleTypesList.indexWhere(
            (element) =>
                element.id.toString() ==
                widget.registrationRequest.vehicleTypeId);
        selectedPersonVehicle = widget.personsVehicleTypesList[serviceIndex];

        if (widget.registrationRequest.vehicleShapeId != null &&
            selectedPersonVehicle != null) {
          int numberOfPassengerIndex = selectedPersonVehicle!.numberOfPassengers
              .indexWhere((element) =>
                  element.id.toString() ==
                  widget.registrationRequest.vehicleShapeId);

          selectedNumberOfPassenger =
              selectedPersonVehicle!.numberOfPassengers[numberOfPassengerIndex];
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          setState(() {
            if (selectedPersonVehicle != null &&
                selectedNumberOfPassenger != null) {
              current = widget.personsVehicleTypesList
                  .indexOf(selectedPersonVehicle!);
              widget.selectedPersonsVehicleTypeModel(selectedPersonVehicle!);
              widget.selectedNumberOfPassengers(selectedNumberOfPassenger!);
            }
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void sortValuesList() {
    widget.personsVehicleTypesList.forEach((personsVehicleType) {
      personsVehicleType.numberOfPassengers.sort((a, b) {
        return a.numberOfPassengers.compareTo(b.numberOfPassengers);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.selectServiceVehicleType.tr(),
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
              widget.personsVehicleTypesList.length,
              (index) => GestureDetector(
                    onTap: () {
                      current = index;
                      setState(() {
                        widget.selectedPersonsVehicleTypeModel(
                            widget.personsVehicleTypesList[index]);
                        selectedPersonVehicle =
                            widget.personsVehicleTypesList[index];
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
                                    .personsVehicleTypesList[index].icon.url,
                              ),
                            ),
                            SizedBox(
                              width: AppSize.s8,
                            ),
                            Text(
                              widget.lang == ARABIC
                                  ? widget.personsVehicleTypesList[index]
                                      .vehicleTypeAr
                                  : widget.personsVehicleTypesList[index]
                                      .vehicleType,
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
        SizedBox(
          width: AppSize.s8,
        ),
        NumberOfPassengerWidget(
            preSelectedNumberOfPassengers: selectedNumberOfPassenger,
            numberOfPassengersList:
                selectedPersonVehicle?.numberOfPassengers ?? [],
            selectedNumberOfPassenger: (selectedNumberOfPassenger) {
              widget.selectedNumberOfPassengers(selectedNumberOfPassenger);
            })
      ],
    );
  }
}
