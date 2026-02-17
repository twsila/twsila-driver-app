import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/di.dart';
import '../../../../domain/model/lookupValueModel.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';

class TankSizeWidget extends StatefulWidget {
  Function(LookupValueModel tankSize) onSelectTankSize;
  final List<LookupValueModel> tankSizeList;

  TankSizeWidget({required this.onSelectTankSize, required this.tankSizeList});

  @override
  State<TankSizeWidget> createState() => _TankSizeWidgetState();
}

class _TankSizeWidgetState extends State<TankSizeWidget> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  int current = 0;

  @override
  void initState() {
    widget.onSelectTankSize(widget.tankSizeList[current]);
    super.initState();
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
          AppStrings.tankType.tr(),
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
              widget.tankSizeList.length,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        current = index;
                        widget.onSelectTankSize(widget.tankSizeList[current]);
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
                            Text(
                              _appPreferences.getAppLanguage() == "ar"
                                  ? widget.tankSizeList[index].valueAr ??
                                      widget.tankSizeList[index].value
                                  : widget.tankSizeList[index].value,
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
    );
  }
}
