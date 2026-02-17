import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/domain/model/requested_drivers_response.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_card.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_network_image_widget.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../utils/ext/enums.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../business_owner_add_driver/view/add_driver_sheet.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/bo_drivers_cars_bloc.dart';

class BOCarsAndDriversView extends StatefulWidget {
  const BOCarsAndDriversView();

  @override
  State<BOCarsAndDriversView> createState() => _BOCarsAndDriversViewState();
}

class _BOCarsAndDriversViewState extends State<BOCarsAndDriversView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  bool pushed = false;
  bool activeDriversDone = false;
  bool pendingDriversDone = false;
  List<Driver> driversList = [];
  List<Driver> pendingDriversList = [];
  List<String> driversMobileNumbers = [];

  AppPreferences appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    BlocProvider.of<BoDriversCarsBloc>(context)
        .add(GetActiveDriversAndCars(false));
    BlocProvider.of<BoDriversCarsBloc>(context)
        .add(GetPendingDriversAndCars(false));
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

  bottomSheetForAddDriver(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return AddDriverBottomSheetView(
              pendingDriversMobileNumbers: driversMobileNumbers);
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
          centerTitle: true,
          appBarActions: [
            GestureDetector(
              onTap: () {
                bottomSheetForAddDriver(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                  color: ColorManager.primary,
                ),
              ),
            )
          ]),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<BoDriversCarsBloc, BoDriversCarsState>(
      listener: (context, state) {
        if (state is BoDriversCarsLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is BoActiveDriversAndCars) {
          driversList = state.driversList;
          activeDriversDone = true;
          handlePushToAddDrivers();
        }
        if (state is BoPendingDriversAndCars) {
          pendingDriversList = state.driversList;
          pendingDriversDone = true;
          handlePushToAddDrivers();
        }

        if (state is BoDriversCarsFail) {
          CustomDialog(context).showErrorDialog('', '', state.message);
        }
      },
      builder: (context, state) {
        return driversList.isEmpty
            ? Center(
                child: Text(
                  AppStrings.noAddedDrivers.tr(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: FontSize.s16, color: ColorManager.error),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: driversList.length,
                itemBuilder: (context, i) {
                  bool isPending = false;
                  return Container(
                      margin: EdgeInsets.all(AppMargin.m8),
                      child: CustomCard(
                        backgroundColor: driversList[i].isPending ?? false
                            ? ColorManager.disableColor
                            : ColorManager.white,
                        onClick: () {},
                        bodyWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: driversList[i].carModel != null,
                                  child: Text(
                                    "${appPreferences.getAppLanguage() == "ar" ? driversList[i].carModel?.modelNameAr ?? "" : driversList[i].carModel?.modelName ?? ""} / ${appPreferences.getAppLanguage() == "ar" ? driversList[i].carModel?.carManufacturer.carManufacturerAr ?? "" : driversList[i].carModel?.carManufacturer.carManufacturerEn ?? ""}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: FontSize.s18,
                                            color: driversList[i].isPending ??
                                                    false
                                                ? ColorManager
                                                    .disableCardTextColor
                                                : ColorManager.secondaryColor),
                                  ),
                                ),
                                Text(
                                  "${driversList[i].firstName} ${driversList[i].lastName}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSize.s18,
                                          color: driversList[i].isPending!
                                              ? ColorManager
                                                  .disableCardTextColor
                                              : ColorManager.secondaryColor),
                                ),
                                Text(
                                  "${driversList[i].mobile}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: FontSize.s16,
                                          color: driversList[i].isPending ??
                                                  false
                                              ? ColorManager
                                                  .disableCardTextColor
                                              : ColorManager.secondaryColor),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(AppPadding.p8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: ColorManager.lightGrey)),
                              height: AppSize.s120,
                              width: AppSize.s90,
                              child: driversList[i].images != null &&
                                      driversList[i].images.length > 1 &&
                                      driversList[i].images[1].imageUrl != null
                                  ? CustomNetworkImageWidget(
                                      imageUrl:
                                          driversList[i].images[1].imageUrl!)
                                  : Image.asset(
                                      ImageAssets.newAppBarLogo,
                                      color: ColorManager.splashBGColor,
                                    ),
                            )
                          ],
                        ),
                      ));
                });
      },
    );
  }

  void handlePushToAddDrivers() {
    if (activeDriversDone && pendingDriversDone) {
      if (driversList.isEmpty && pendingDriversList.isEmpty) {
        if (pushed == false) {
          Navigator.pushNamed(context, Routes.BOaddDriver).then((value) =>
              BlocProvider.of<BoDriversCarsBloc>(context)
                  .add(GetDriversAndCars(true)));
          pushed = true;
        }
      } else {
        driversList.addAll(pendingDriversList);
        driversList.forEach((element) {
          driversMobileNumbers.add(element.mobile!);
        });
      }
    }
  }
}
