import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/langauge_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../../login/view/login_view.dart';
import '../../main/pages/myprofile/my_profile_helper.dart';

class RegistrationTypesView extends StatefulWidget {
  const RegistrationTypesView({Key? key}) : super(key: key);

  @override
  State<RegistrationTypesView> createState() => _RegistrationTypesViewState();
}

class _RegistrationTypesViewState extends State<RegistrationTypesView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: false,
        context: context,
        body: _build(context),
        scaffoldKey: _key,
        allowBackButtonInAppBar: false,
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    AppStrings.en.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorManager.headersTextColor,
                        ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    MyProfileHelper().changeAppLanguage(
                      context,
                      LanguageType.ENGLISH.getValue(),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    AppStrings.ar.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorManager.headersTextColor,
                        ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    MyProfileHelper().changeAppLanguage(
                      context,
                      LanguageType.ARABIC.getValue(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final isEnglish = _appPreferences.getAppLanguage() == ENGLISH;
    final languageLabel = isEnglish ? AppStrings.en.tr() : AppStrings.ar.tr();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppPadding.p20,
        AppPadding.p12,
        AppPadding.p20,
        AppPadding.p12,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showLanguageBottomSheet(context),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.language_rounded,
                    size: 22,
                    color: ColorManager.headersTextColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    languageLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: ColorManager.headersTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: FontSize.s16,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Image.asset(
              ImageAssets.newAppBarLogo,
              color: ColorManager.splashBGColor,
              height: 70,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopBar(context),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p20,
              vertical: AppPadding.p16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                SizedBox(height: AppSize.s28),
                _registrationTypeCard(
                  context: context,
                  iconPath: ImageAssets.captainApplyIcon,
                  title: AppStrings.registerAsACaptain.tr(),
                  subtitle: AppStrings.addOneCar.tr(),
                  accentColor: ColorManager.primary,
                  onTap: () {
                    _appPreferences.setUserType(UserTypeConstants.DRIVER);
                    Navigator.pushNamed(
                      context,
                      Routes.loginRoute,
                      arguments:
                          LoginViewArguments(RegistrationConstants.captain),
                    );
                  },
                ),
                SizedBox(height: AppSize.s16),
                _registrationTypeCard(
                  context: context,
                  iconPath: ImageAssets.boApplyIcon,
                  title: AppStrings.registerAsCompanyOwner.tr(),
                  subtitle: AppStrings.wantToAddAndManageMultipleCars.tr(),
                  accentColor: ColorManager.secondaryColor,
                  onTap: () {
                    _appPreferences
                        .setUserType(UserTypeConstants.BUSINESS_OWNER);
                    Navigator.pushNamed(
                      context,
                      Routes.loginRoute,
                      arguments: LoginViewArguments(
                          RegistrationConstants.businessOwner),
                    );
                  },
                ),
                SizedBox(height: AppSize.s40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.whichRegistrationTypeYouWant.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: ColorManager.headersTextColor,
                fontWeight: FontWeight.bold,
                height: 1.25,
                letterSpacing: -0.3,
              ),
        ),
        SizedBox(height: AppSize.s8),
        Text(
          AppStrings.welcomeInto.tr() + ' ' + AppStrings.twsela.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorManager.hintTextColor,
                fontSize: FontSize.s14,
              ),
        ),
      ],
    );
  }

  Widget _registrationTypeCard({
    required BuildContext context,
    required String iconPath,
    required String title,
    required String subtitle,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: accentColor.withOpacity(0.1),
        highlightColor: accentColor.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.all(AppPadding.p20),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorManager.borderColor.withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.headersTextColor.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  iconPath,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: AppSize.s18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorManager.headersTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: FontSize.s16,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: FontSize.s12,
                            color: ColorManager.hintTextColor,
                            height: 1.35,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSize.s8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: ColorManager.hintTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
