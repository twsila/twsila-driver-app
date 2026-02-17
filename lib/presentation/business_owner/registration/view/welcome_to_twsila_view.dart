import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/routes_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/page_builder.dart';

class WelcomeToTwsilaView extends StatelessWidget {
  WelcomeToTwsilaView();

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        context: context,
        resizeToAvoidBottomInsets: true,
        allowBackButtonInAppBar: false,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageAssets.welcomeToTawselaGraphic),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.welcomeInto.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorManager.titlesTextColor,
                        fontSize: FontSize.s12),
                  ),
                  const SizedBox(
                    width: AppSize.s4,
                  ),
                  Text(
                    AppStrings.twselaCaptian.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorManager.primary, fontSize: FontSize.s12),
                  ),
                ],
              ),
              SizedBox(
                height: AppSize.s210,
              ),
              Spacer(),
              CustomTextButton(
                text: AppStrings.mainScreen.tr(),
                isWaitToEnable: false,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.mainRoute);
                },
              )
            ],
          ),
        ),
        scaffoldKey: _key,
      ),
    );
  }
}
