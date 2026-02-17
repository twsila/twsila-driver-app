import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';

import '../../../../domain/model/vehicle_model.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';

class NumberOfPassengerWidget extends StatefulWidget {
  final NumberOfPassenger? preSelectedNumberOfPassengers;
  final List<NumberOfPassenger> numberOfPassengersList;
  final Function(NumberOfPassenger numberOfPassenger) selectedNumberOfPassenger;

  NumberOfPassengerWidget(
      {this.preSelectedNumberOfPassengers,
      required this.numberOfPassengersList,
      required this.selectedNumberOfPassenger});

  @override
  State<NumberOfPassengerWidget> createState() =>
      _NumberOfPassengerWidgetState();
}

class _NumberOfPassengerWidgetState extends State<NumberOfPassengerWidget> {
  int current = -1;
  NumberOfPassenger? selectedNumberOfPassengers;

  @override
  void initState() {
    super.initState();
    checkPreSelectedValues();
  }



  checkPreSelectedValues() {
    try {
      if (widget.preSelectedNumberOfPassengers != null && mounted) {
        selectedNumberOfPassengers = widget.numberOfPassengersList.firstWhere(
            (element) => element == widget.preSelectedNumberOfPassengers);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          setState(() {
            if (selectedNumberOfPassengers != null) {
              current = widget.numberOfPassengersList
                  .indexOf(selectedNumberOfPassengers!);
              widget.selectedNumberOfPassenger(selectedNumberOfPassengers!);
            }
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSize.s14,
        ),
        Text(
          AppStrings.numberOfPassengers.tr(),
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
              widget.numberOfPassengersList.length,
              (index) => GestureDetector(
                    onTap: () {
                      current = index;
                      setState(() {
                        widget.selectedNumberOfPassenger(
                            widget.numberOfPassengersList[index]);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget
                              .numberOfPassengersList[index].numberOfPassengers
                              .toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: ColorManager.headersTextColor),
                        ),
                        SizedBox(
                          width: AppSize.s30,
                        ),
                        Visibility(
                          visible: current == index,
                          child: Icon(
                            Icons.check,
                            color: ColorManager.purpleMainTextColor,
                          ),
                        )
                      ],
                    ),
                  )),
        ),
      ],
    );
  }


}
