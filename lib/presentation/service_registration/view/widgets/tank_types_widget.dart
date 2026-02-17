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

class TankTypesWidget extends StatefulWidget {
  Function(LookupValueModel tankType) onSelectTankType;
  final List<LookupValueModel> tankTypesList;

  TankTypesWidget(
      {required this.onSelectTankType, required this.tankTypesList});

  @override
  State<TankTypesWidget> createState() => _TankTypesWidgetState();
}

class _TankTypesWidgetState extends State<TankTypesWidget> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  int current = 0;

  @override
  void initState() {
    widget.onSelectTankType(widget.tankTypesList[current]);
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
              widget.tankTypesList.length,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        current = index;
                        widget.onSelectTankType(widget.tankTypesList[current]);
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
                                  ? widget.tankTypesList[index].valueAr ??
                                      widget.tankTypesList[index].value
                                  : widget.tankTypesList[index].value,
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
