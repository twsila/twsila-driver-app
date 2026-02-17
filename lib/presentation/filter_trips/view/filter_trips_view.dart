import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/domain/model/current_location_model.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/domain/model/location_filter_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_checkbox.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/filter_trips/view/widgets/city_filter_widget.dart';
import 'package:taxi_for_you/presentation/filter_trips/view/widgets/fiter_by_service_widget.dart';
import 'package:taxi_for_you/presentation/filter_trips/view/widgets/from_to_date_widget.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/date_filter_model.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../../main/pages/search_trips/view/search_trips_page.dart';
import 'helpers/filtration_helper.dart';

class FilterTripsView extends StatefulWidget {
  FilterTripsView();

  @override
  State<FilterTripsView> createState() => _FilterTripsViewState();
}

class _FilterTripsViewState extends State<FilterTripsView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  DateFilter? dateFilter;
  LocationFilter? locationFilter;
  CurrentLocationFilter? currentLocationFilter;
  bool? isTodayDate;
  bool isOfferedTrip = false;
  int selectedOption = 1;
  DriverBaseModel? driverBaseModel;
  String? filteredServices;

  @override
  void initState() {
    driverBaseModel = _appPreferences.getCachedDriver()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: false,
        context: context,
        body: _build(context),
        scaffoldKey: _key,
        allowBackButtonInAppBar: false,
        extendAppBarIntoSafeArea: true,
        appBarForegroundColor: Colors.white,
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 4,
        left: 8,
        right: 20,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: ColorManager.splashBGColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.splashBGColor.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
            color: Colors.white,
            style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              AppStrings.displayTrips.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FromToDateWidget(
                  onSelectDate: (fromDate, toDate, todayDate) {
                    dateFilter = DateFilter(
                        startDate: fromDate, endDate: toDate, isToday: todayDate);
                  },
                ),
                const SizedBox(height: 16),
                CityFilterWidget(
                  onSelectLocationFilter: (pickup, destination, currentFilter) {
                    locationFilter =
                        LocationFilter(pickup: pickup, destination: destination);
                    currentLocationFilter = currentFilter;
                  },
                ),
                const SizedBox(height: 16),
                tripTypeFiltration(),
                if ((driverBaseModel!.captainType == RegistrationConstants.captain &&
                        (driverBaseModel! as Driver).serviceTypes!.length > 1) ||
                    driverBaseModel!.captainType ==
                        RegistrationConstants.businessOwner) ...[
                  const SizedBox(height: 20),
                  _serviceTypeSection(context),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: CustomTextButton(
            text: AppStrings.searchTrips.tr(),
            isWaitToEnable: false,
            backgroundColor: ColorManager.splashBGColor,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(
                  context,
                  FilterTripsModel(
                      dateFilter: dateFilter ?? null,
                      locationFilter: locationFilter ?? null,
                      currentLocation: currentLocationFilter ?? null,
                      isOfferedTrips: isOfferedTrip,
                      filteredService:
                          filteredServices != null && filteredServices!.isNotEmpty
                              ? filteredServices
                              : driverBaseModel!.captainType ==
                                      RegistrationConstants.businessOwner
                                  ? FiltrationHelper().serviceTypesList.join(",")
                                  : null));
            },
          ),
        ),
      ],
    );
  }

  Widget _serviceTypeSection(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.selectServiceType.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: FontSize.s16),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: FilterByServiceWidget(
              serviceParams: driverBaseModel!.captainType ==
                      RegistrationConstants.captain
                  ? (driverBaseModel! as Driver).serviceTypes!
                  : FiltrationHelper().serviceTypesList,
              onSelectedServices: (list) {
                filteredServices = list.join(',');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget filterGoodsOrFurnitureRadioButtons() {
    return Visibility(
      visible: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.goodsType.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.titlesTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(
                      AppStrings.goods.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    leading: Radio(
                      value: 1,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value! as int;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      AppStrings.furniture.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    leading: Radio(
                      value: 2,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value! as int;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget tripTypeFiltration() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tripType.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: FontSize.s16),
          ),
          const SizedBox(height: 14),
          CustomCheckBox(
              checked: isOfferedTrip,
              fieldName: AppStrings.offerHasBeenSent.tr(),
              onChange: (value) {
                setState(() => isOfferedTrip = value);
              }),
        ],
      ),
    );
  }
}
