import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

class RegistrationBOHeaderWidget extends StatelessWidget {
  const RegistrationBOHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppStrings.welcomeInto.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.blackTextColor,
                    fontSize: 16,
                  ),
            ),
            Text(
              ' ' + AppStrings.twsela.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          AppStrings.pleaseResumeCompanyData.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: ColorManager.blackTextColor,
                fontWeight: FontWeight.w700,
                height: 1.25,
                letterSpacing: -0.3,
              ),
        ),
      ],
    );
  }
}
