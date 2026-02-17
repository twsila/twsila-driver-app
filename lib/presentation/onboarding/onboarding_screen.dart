import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/styles_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    super.initState();
  }

  void _goToLogin() {
    _appPreferences.setOnboardingSeen(true);
    Navigator.pushReplacementNamed(context, Routes.selectRegistrationType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                Image.asset(
                  ImageAssets.appLogo,
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 48),

                // App Title
                Text(
                  AppStrings.welcomeTo.tr() + ' ' + AppStrings.appTitle.tr(),
                  style: getBoldStyle(
                    color: ColorManager.blackTextColor,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // App Purpose/Description
                Text(
                  AppStrings.appPurpose.tr(),
                  style: getMediumStyle(
                    color: ColorManager.blackTextColor.withOpacity(0.7),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Location Availability Message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ColorManager.primary.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.primary.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorManager.accentColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: ColorManager.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final text = AppStrings.appAvailableLocations.tr();
                            final matches =
                                RegExp(r'(Riyadh|الرياض|Al Hasa|الأحساء)')
                                    .allMatches(text);

                            final spans = <TextSpan>[];
                            int lastIndex = 0;

                            for (final match in matches) {
                              if (match.start > lastIndex) {
                                spans.add(TextSpan(
                                  text: text.substring(lastIndex, match.start),
                                  style: getMediumStyle(
                                    color: ColorManager.blackTextColor,
                                    fontSize: 14,
                                  ),
                                ));
                              }
                              spans.add(TextSpan(
                                text: match.group(0),
                                style: getBoldStyle(
                                  color: ColorManager.primary,
                                  fontSize: 14,
                                ),
                              ));
                              lastIndex = match.end;
                            }
                            if (lastIndex < text.length) {
                              spans.add(TextSpan(
                                text: text.substring(lastIndex),
                                style: getMediumStyle(
                                  color: ColorManager.blackTextColor,
                                  fontSize: 14,
                                ),
                              ));
                            }

                            return RichText(
                              text: TextSpan(children: spans),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Get Started Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _goToLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.getStarted.tr(),
                      style: getBoldStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
