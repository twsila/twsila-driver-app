import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/page_builder.dart';

class NoServiceAddedView extends StatefulWidget {
  const NoServiceAddedView({Key? key}) : super(key: key);

  @override
  State<NoServiceAddedView> createState() => _NoServiceAddedViewState();
}

class _NoServiceAddedViewState extends State<NoServiceAddedView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final bool _displayLoadingIndicator = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
          appbar: true,
          context: context,
          body: _getContentWidget(context),
          scaffoldKey: _key,
          displayLoadingIndicator: _displayLoadingIndicator,
          allowBackButtonInAppBar: true,
          centerTitle: true,
          appBarTitle: AppStrings.myServices.tr()),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal:AppMargin.m12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            ImageAssets.noServiceAdded,
            width: AppSize.s160,
            height: AppSize.s160,
          ),
          const SizedBox(
            height: AppSize.s30,
          ),
          Text(
            AppStrings.youDidntAddAnySerivces.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: FontSize.s26,
                color: ColorManager.headersTextColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${AppStrings.startNowAndAddYourCarIntoApplication.tr()} ",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: FontSize.s16,
                    color: ColorManager.titlesTextColor),
              ),
              Text(
                "${AppStrings.twsela.tr()} ",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: FontSize.s16, color: ColorManager.primary),
              ),
            ],
          ),
          const SizedBox(
            height: AppSize.s30,
          ),
          CustomTextButton(
            icon: Icon(
              Icons.add,
              color: ColorManager.white,
            ),
            text: AppStrings.addService.tr(),
            onPressed: () {
              Navigator.pushNamed(context,Routes.serviceRegistrationFirstStep);
            },
          )
        ],
      ),
    );
  }
}
