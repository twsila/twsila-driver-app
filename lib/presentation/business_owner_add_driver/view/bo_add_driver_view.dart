import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/business_owner_add_driver/view/add_driver_sheet.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';

class BOAddDriverView extends StatefulWidget {
  const BOAddDriverView();

  @override
  State<BOAddDriverView> createState() => _BOAddDriverViewState();
}

class _BOAddDriverViewState extends State<BOAddDriverView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;

  bottomSheetForAddDriver(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return AddDriverBottomSheetView();
        });
  }

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
          appbar: true,
          context: context,
          body: _getContentWidget(context),
          scaffoldKey: _key,
          displayLoadingIndicator: _displayLoadingIndicator,
          allowBackButtonInAppBar: true,
          appBarTitle: AppStrings.DriversAndCars.tr(),
          centerTitle: true),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppMargin.m12),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageAssets.BONoDriversAdded),
            SizedBox(
              height: 20,
            ),
            Text(
              AppStrings.noAddedDrivers.tr(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: FontSize.s26, color: ColorManager.secondaryColor),
            ),
            Text(
              AppStrings.noAddedDriversMessage.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: FontSize.s16, color: ColorManager.primaryPurple),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              AppStrings.importantNote.tr() + " : ",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: FontSize.s16, color: ColorManager.error),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              AppStrings.noAddedDriversimportantNote.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: FontSize.s16, color: ColorManager.primaryPurple),
            ),
            CustomTextButton(
              onPressed: () {
                bottomSheetForAddDriver(context);
              },
              isWaitToEnable: false,
              text: AppStrings.addDriver.tr(),
              icon: Icon(
                Icons.add,
                color: ColorManager.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
