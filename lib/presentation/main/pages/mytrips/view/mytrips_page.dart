import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/presentation/main/pages/mytrips/view/widgets/ongoing_item.dart';
import 'package:taxi_for_you/presentation/main/pages/mytrips/view/widgets/precedent_item.dart';
import 'package:taxi_for_you/presentation/main/pages/mytrips/view/widgets/scheduled_item.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/trip_execution_view.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/di.dart';
import '../../../../../domain/model/trip_details_model.dart';
import '../../../../../domain/model/trip_model.dart';
import '../../../../../utils/ext/enums.dart';
import '../../../../../utils/resources/assets_manager.dart';
import '../../../../../utils/resources/routes_manager.dart';
import '../../../../../utils/resources/strings_manager.dart';
import '../../../../common/widgets/custom_card.dart';
import '../../../../common/widgets/custom_scaffold.dart';
import '../../../../common/widgets/page_builder.dart';
import '../../../../trip_details/view/trip_details_view.dart';
import '../bloc/my_trips_bloc.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({Key? key}) : super(key: key);

  @override
  _MyTripsPageState createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _loadingTripsList = false;
  List<TripDetailsModel> trips = [];
  bool _displayLoadingIndicator = false;
  List<MyTripsListModel> items = [
    MyTripsListModel("TODAY_TRIPS", AppStrings.onGoing.tr()),
    MyTripsListModel("SCHEDULED_TRIPS", AppStrings.scheduled.tr()),
    MyTripsListModel("OLD_TRIPS", AppStrings.last.tr()),
  ];
  int current = 0;

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
  void initState() {
    BlocProvider.of<MyTripsBloc>(context)
        .add(GetTripsTripModuleId(items[current].tripModelTypeId));
    super.initState();
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

  Widget _getContentWidget(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<MyTripsBloc>(context)
            .add(GetTripsTripModuleId(items[current].tripModelTypeId));
      },
      child: BlocConsumer<MyTripsBloc, MyTripsState>(
        listener: (context, state) {
          if (state is MyTripsLoading) {
            _loadingTripsList = true;
          } else {
            _loadingTripsList = false;
          }
          if (state is MyTripsSuccess) {
            trips = state.trips;
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _MyTripsTitlesTabsBar(),
                      _tripsListView(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tripsListView() {
    return Expanded(
      child: _loadingTripsList
          ? Center(
              child: CircularProgressIndicator(
                color: ColorManager.splashBGColor,
              ),
            )
          : trips.length == 0
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      AppStrings.noTripsAvailable.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorManager.formHintTextColor,
                            fontSize: FontSize.s16,
                          ),
                    ),
                  ),
                )
              : _TripsListView(trips),
    );
  }

  Widget _TripsListView(List<TripDetailsModel> tripsTitles) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(top: 0, bottom: 8),
      itemCount: trips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => tripItemView(trips[index]),
    );
  }

  tripItemView(TripDetailsModel trip) {
    String? date;
    if (trip.tripDetails.date != null) {
      date = trip.tripDetails.date!.getTimeStampFromDate();
    }
    return current == 0
        ? OngoingItemView(
            trip: trip,
            currentTripModelId: items[current].tripModelTypeId,
            date: date ?? "")
        : current == 1
            ? ScheduledItemView(
                trip: trip,
                currentTripModelId: items[current].tripModelTypeId,
                date: date ?? "")
            : PrecedentItemView(
                trip: trip,
                currentTripModelId: items[current].tripModelTypeId,
                date: date ?? "");
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
        AppStrings.myTrips.tr(),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
      ),
    );
  }

  Widget _MyTripsTitlesTabsBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorManager.borderColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(
          items.length,
          (index) => Expanded(child: _tabsTitleWidget(index)),
        ),
      ),
    );
  }

  Widget _tabsTitleWidget(int index) {
    final isSelected = current == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          current = index;
          BlocProvider.of<MyTripsBloc>(context)
              .add(GetTripsTripModuleId(items[current].tripModelTypeId));
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.splashBGColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ColorManager.splashBGColor.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            items[index].title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: FontSize.s14,
                  color:
                      isSelected ? Colors.white : ColorManager.headersTextColor,
                ),
          ),
        ),
      ),
    );
  }

  String handleDateString(String dateString) {
    DateTime parseDate =
        new DateFormat(Constants.dateFormatterString).parse(dateString);
    String date = DateFormat(
            Constants.dateFormatterString, _appPreferences.getAppLanguage())
        .format(parseDate);
    return date;
  }
}

class MyTripsListModel {
  String tripModelTypeId;
  String title;

  MyTripsListModel(this.tripModelTypeId, this.title);
}
