import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/bloc/my_profile_bloc.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/my_profile_helper.dart';
import 'package:taxi_for_you/presentation/payment/view/payment_screen.dart';
import 'package:taxi_for_you/presentation/update_bo_profile/view/update_bo_profile_view.dart';
import 'package:taxi_for_you/presentation/update_driver_profile/view/update_driver_profile_view.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/constants_manager.dart';
import '../../../../utils/resources/langauge_manager.dart';
import '../../../../utils/resources/routes_manager.dart';
import '../../../common/widgets/custom_network_image_widget.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/page_builder.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  DriverBaseModel? driver;
  AppPreferences _appPreferences = instance<AppPreferences>();
  final SharedPreferences _sharedPreferences = instance();

  @override
  void initState() {
    driver = _appPreferences.getCachedDriver() ?? null;
    super.initState();
  }

  Future<String> getProfilePicPath() async {
    return _appPreferences.userProfilePicture(driver!);
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorManager.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppStrings.language.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorManager.blackTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.language_rounded,
                    color: ColorManager.headersTextColor),
                title: Text(
                  AppStrings.en.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                onTap: () {
                  MyProfileHelper().changeAppLanguage(
                      context, LanguageType.ENGLISH.getValue());
                  if (context.mounted) Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(Icons.language_rounded,
                    color: ColorManager.headersTextColor),
                title: Text(
                  AppStrings.ar.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                onTap: () {
                  MyProfileHelper().changeAppLanguage(
                      context, LanguageType.ARABIC.getValue());
                  if (context.mounted) Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      elevation: 10,
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height / 1.2,
        child: PaymentScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: false,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: false,
        extendBodyBehindAppBar: true,
        extendAppBarIntoSafeArea: true,
        appBarForegroundColor: Colors.white,
      ),
    );
  }

  void startLoading() {
    setState(() {
      _displayLoadingIndicator = true;
    });
  }

  void stopLoading() {
    setState(() {
      _displayLoadingIndicator = false;
    });
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<MyProfileBloc, MyProfileState>(
      listener: (context, state) {
        if (state is MyProfileLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is LoggedOutSuccessfully) {
          Navigator.pushNamed(context, Routes.selectRegistrationType);
        }
        if (state is MyProfileFail) {
          CustomDialog(context).showErrorDialog('', '', state.errorMessage);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_appPreferences.getCachedDriver()!.captainType ==
                        RegistrationConstants.businessOwner) ...[
                      _successSubscriptionAndPayWidgetBO(),
                      const SizedBox(height: 16),
                    ],
                    _profileDataHeader(),
                    const SizedBox(height: 20),
                    _menuCard(context),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 8,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: ColorManager.splashBGColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.splashBGColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        AppStrings.myProfile.tr(),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
      ),
    );
  }

  Widget _menuCard(BuildContext context) {
    final isCaptain = driver!.captainType == RegistrationConstants.captain;
    final isDriverWithBo = isCaptain && (driver as Driver).businessOwnerId == null;
    final menuItems = <_MenuItem>[
      _MenuItem(
        icon: isCaptain ? ImageAssets.MyServicesIc : ImageAssets.carsAndDriversIcon,
        label: isCaptain ? AppStrings.myServices.tr() : AppStrings.DriversAndCars.tr(),
        onTap: () => Navigator.pushNamed(
          context,
          isCaptain ? Routes.myServices : Routes.boDriversAndCars,
        ),
      ),
      if (isDriverWithBo)
        _MenuItem(
          icon: ImageAssets.addRequestsIcon,
          label: AppStrings.addRequestsFromBo.tr(),
          onTap: () => Navigator.pushNamed(context, Routes.driverRequests),
        ),
      _MenuItem(
        icon: ImageAssets.languageIc,
        label: AppStrings.language.tr(),
        onTap: () => _showBottomSheet(),
      ),
      _MenuItem(
        icon: ImageAssets.logout,
        label: AppStrings.logout.tr(),
        onTap: () => CustomDialog(context).showCupertinoDialog(
          AppStrings.logout.tr(),
          AppStrings.areYouSureYouWantToLogout.tr(),
          AppStrings.confirmLogout.tr(),
          AppStrings.cancel.tr(),
          ColorManager.error, () {
            BlocProvider.of<MyProfileBloc>(context).add(logoutEvent(context));
            Navigator.pop(context);
          }, () => Navigator.pop(context),
        ),
      ),
      _MenuItem(
        icon: ImageAssets.logout,
        label: AppStrings.deleteAccount.tr(),
        onTap: () => CustomDialog(context).showCupertinoDialog(
          AppStrings.deleteAccount.tr(),
          AppStrings.areYouSureYouWantToDeleteAccount.tr(),
          AppStrings.confirmDelete.tr(),
          AppStrings.cancel.tr(),
          ColorManager.error, () {
            BlocProvider.of<MyProfileBloc>(context).add(deleteAccountEvent(context));
            Navigator.pop(context);
          }, () => Navigator.pop(context),
        ),
      ),
    ];
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.headersTextColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            for (int i = 0; i < menuItems.length; i++) ...[
              _menuTile(menuItems[i]),
              if (i < menuItems.length - 1)
                Container(
                  height: 1,
                  margin: const EdgeInsets.only(left: 56),
                  color: ColorManager.lineColor.withOpacity(0.5),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _menuTile(_MenuItem item) {
    final isSvg = item.icon.endsWith('.svg');
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ColorManager.splashBGColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: isSvg
                    ? SvgPicture.asset(item.icon, width: 24, height: 24)
                    : Image.asset(item.icon, width: 24, height: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: FontSize.s16,
                      ),
                ),
              ),
              Icon(
                _appPreferences.getAppLanguage() != LanguageType.ENGLISH.getValue()
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_right,
                color: ColorManager.formHintTextColor,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _successSubscriptionAndPayWidgetBO() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManager.splashBGColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.splashBGColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: ColorManager.splashBGColor,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppStrings.yourAccountRegisteredSuccessfully.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: ColorManager.splashBGColor,
                      fontSize: FontSize.s16),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${AppStrings.payBusinessOwnerFeesMessage.tr()}: 200 ${getCurrency("SA")}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: ColorManager.secondaryColor,
                fontSize: FontSize.s16),
          ),
          CustomTextButton(
            text: AppStrings.viewSubscriptionBenefits.tr(),
            isWaitToEnable: false,
            borderColor: ColorManager.black,
            backgroundColor: ColorManager.highlightBackgroundColor,
            textColor: ColorManager.black,
            onPressed: () {
              Navigator.pushNamed(context, Routes.boSubscriptionBenefits);
            },
          ),
          CustomTextButton(
            text: AppStrings.subscribeAndGoToPay.tr(),
            isWaitToEnable: false,
            backgroundColor: ColorManager.splashBGColor,
            textColor: Colors.white,
            icon: Image.asset(
              ImageAssets.tripDetailsVisaIcon,
              color: Colors.white,
              width: 16,
            ),
            onPressed: () {
              _showPaymentBottomSheet();
            },
          )
        ],
      ),
    );
  }

  Widget _profileDataHeader() {
    return FutureBuilder<String>(
        future: getProfilePicPath(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorManager.borderColor.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.headersTextColor.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorManager.borderColor.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.headersTextColor.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorManager.splashBGColor.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.splashBGColor.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: CustomNetworkImageWidget(
                        imageUrl: snapshot.data.toString(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver != null
                              ? (driver?.firstName ?? "") +
                                  ' ' +
                                  (driver?.lastName ?? "")
                              : "",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: ColorManager.headersTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: FontSize.s18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          driver != null ? (driver?.mobile ?? "") : "",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: ColorManager.formHintTextColor,
                                fontSize: FontSize.s14),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            driver != null &&
                                    driver!.captainType ==
                                        RegistrationConstants.captain
                                ? Navigator.pushNamed(
                                    context, Routes.updateDriverProfile,
                                    arguments:
                                        UpdateDriverProfileArguments(driver!))
                                : Navigator.pushNamed(
                                    context, Routes.updateBoProfile,
                                    arguments: UpdateBoProfileArguments(
                                        driver as BusinessOwnerModel));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppStrings.changeMyProfile.tr(),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: ColorManager.splashBGColor,
                                      fontSize: FontSize.s14,
                                      fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.edit_rounded,
                                color: ColorManager.splashBGColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class _MenuItem {
  final String icon;
  final String label;
  final VoidCallback onTap;
  _MenuItem({required this.icon, required this.label, required this.onTap});
}
