import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';

import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/values_manager.dart';

class ServiceModelWidget extends StatefulWidget {
  final int? currentIndex;
  final List<ServiceModel> serviceModelList;
  final Function(ServiceModel selectedServiceModel) onSelectedServiceModel;

  ServiceModelWidget(
      {this.currentIndex,
      required this.serviceModelList,
      required this.onSelectedServiceModel});

  @override
  State<ServiceModelWidget> createState() => _ServiceModelWidgetState();
}

class _ServiceModelWidgetState extends State<ServiceModelWidget> {
  int current = 0;

  @override
  void initState() {
    if (widget.currentIndex != null) {
      current = widget.currentIndex!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: context.getWidth() / AppSize.s32,
      runSpacing: 20,
      children: List.generate(
          widget.serviceModelList.length,
          (index) => GestureDetector(
                onTap: () {
                  current = index;
                  setState(() {
                    widget
                        .onSelectedServiceModel(widget.serviceModelList[index]);
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
                          child: Image.asset(
                              widget.serviceModelList[index].imagePath),
                        ),
                        SizedBox(
                          width: AppSize.s8,
                        ),
                        Text(
                          widget.serviceModelList[index].serviceModelName,
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
    );
  }
}

class ServiceModel {
  int id;
  String serviceModelName;
  String imagePath;

  ServiceModel(this.id, this.serviceModelName, this.imagePath);
}
