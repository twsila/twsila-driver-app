import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/constants_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/routes_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/page_builder.dart';
import '../../../login/view/login_view.dart';

class ServiceAppliedSuccessView extends StatefulWidget {
  const ServiceAppliedSuccessView({Key? key}) : super(key: key);

  @override
  State<ServiceAppliedSuccessView> createState() =>
      _ServiceAppliedSuccessViewState();
}

class _ServiceAppliedSuccessViewState extends State<ServiceAppliedSuccessView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;

  @override
  void initState() {
    super.initState();
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
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(ImageAssets.appliedWaiting),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p14),
              child: Text(
                AppStrings.requestAppliedSuccessfully.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s16,
                    color: ColorManager.headersTextColor),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: AppPadding.p20, left: AppPadding.p20),
              child: Text(
                AppStrings.thankYouForRegisterWithTwsilaMessage.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: ColorManager.headersTextColor,fontSize: FontSize.s14),
              ),
            ),
          ),
          CustomTextButton(
            text: AppStrings.login.tr(),
            isWaitToEnable: false,
            onPressed: () {
              Phoenix.rebirth(context);
              // Navigator.pushNamed(
              //   context,
              //   Routes.selectRegistrationType,
              // );
            },
          )
        ],
      ),
    );
  }
}
