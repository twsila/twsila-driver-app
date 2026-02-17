import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../app/di.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/langauge_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../main/pages/myprofile/my_profile_helper.dart';

class LanguageWidget extends StatefulWidget {
  const LanguageWidget({Key? key}) : super(key: key);

  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  final SharedPreferences _sharedPreferences = instance();
  final AppPreferences _appPrefs = instance();

  void _showBottomSheet() {
    showModalBottomSheet(
        elevation: 10,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      MyProfileHelper().changeAppLanguage(
                          context, LanguageType.ENGLISH.getValue());
                    },
                    child: Text(
                      AppStrings.en.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () {
                      MyProfileHelper().changeAppLanguage(
                          context, LanguageType.ARABIC.getValue());
                    },
                    child: Text(
                      AppStrings.ar.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FittedBox(
              child: Icon(
                Icons.language,
                color: ColorManager.grey,
              ),
            ),
          ),
          const SizedBox(width: AppSize.s4),
          Expanded(
            child: FittedBox(
              child: Text(
                _appPrefs.getAppLanguage().tr(),
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontSize: FontSize.s12),
              ),
            ),
          )
        ],
      ),
    );
  }
}
