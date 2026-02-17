import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../../utils/resources/color_manager.dart';
import '../../../../../utils/resources/langauge_manager.dart';
import '../../../../../utils/resources/styles_manager.dart';
import 'package:path/path.dart';

class MenuWidget extends StatelessWidget {
  final AppPreferences appPreferences = instance();
  final String menuImage;
  final String menuLabel;
  final Function onPressed;

  MenuWidget({
    Key? key,
    required this.menuImage,
    required this.menuLabel,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Row(
          children: [
            extension(menuImage) == ".svg"
                ? SvgPicture.asset(menuImage)
                : Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: ColorManager.forthAccentColor,
                    ),
                    child: Image.asset(menuImage)),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      menuLabel,
                      style: getBoldStyle(
                        color: ColorManager.headersTextColor,
                        fontSize: AppSize.s16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    appPreferences.getAppLanguage() !=
                            LanguageType.ENGLISH.getValue()
                        ? Icons.keyboard_arrow_left
                        : Icons.keyboard_arrow_right,
                    color: ColorManager.headersTextColor,
                    size: 45,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
