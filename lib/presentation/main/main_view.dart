import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/my_profile_view.dart';
import 'package:taxi_for_you/presentation/main/pages/mytrips/view/mytrips_page.dart';
import 'package:taxi_for_you/presentation/main/pages/search_trips/view/search_trips_page.dart';
import 'package:taxi_for_you/presentation/main/widgets/custom_bottom_nav.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';

import '../../utils/location/map_provider.dart';
import '../../utils/resources/color_manager.dart';
import '../../utils/resources/strings_manager.dart';
import '../../utils/resources/values_manager.dart';
import '../google_maps/bloc/maps_bloc.dart';
import '../google_maps/bloc/maps_events.dart';
import '../google_maps/bloc/maps_state.dart';
import '../google_maps/model/location_model.dart';

class MainView extends StatefulWidget {
  MainView() : super();

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<int> activePages = [];
  List<Widget> pages = [
    SearchTripsPage(),
    MyTripsPage(),
    MyProfilePage(),
  ];

  List<String> titles = [
    AppStrings.myProfile.tr(),
    AppStrings.myTrips.tr(),
    AppStrings.searchTrips.tr(),
  ];

  var _title = AppStrings.home.tr();
  var _currentIndex = 0;

  @override
  void initState() {
    BlocProvider.of<MapsBloc>(context).add(GetUserConfigAndPagesForUser());
    super.initState();
  }

  getCurrentLocation() async {
    BlocProvider.of<MapsBloc>(context, listen: false).add(GetCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CustomDialog(context).showCupertinoDialog(
            AppStrings.exitApp.tr(),
            AppStrings.areYouSureYouWantToExitFromApp.tr(),
            AppStrings.exit.tr(),
            AppStrings.cancel.tr(),
            ColorManager.error, () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        }, () {
          Navigator.of(context).pop(false);
        });
        return true;
      },
      child: Scaffold(
        body: pages[_currentIndex],
        bottomNavigationBar: BlocConsumer<MapsBloc, MapsState>(
          listener: (context, state) {
            // Don't block app navigation if location fails - location is optional
            // Only show non-blocking warning for location issues
            if (state is CurrentLocationFailed) {
              // Location failed but app should continue to work
              // Don't show blocking dialog, just silently continue
              // Location-dependent features will handle this gracefully
            } else if (state is CurrentLocationLoadedSuccessfully) {
              Provider.of<MapProvider>(context, listen: false).currentLocation =
                  state.currentLocation;
            }

            if (state is CurrentUserConfigAndPagesSuccess) {
              setState(() {
                activePages = state.activePageIndex;
                _currentIndex = state.currentIndex;
              });
            }
          },
          builder: (context, state) {
            final pages = state is CurrentUserConfigAndPagesSuccess
                ? state.activePageIndex
                : [0, 1, 2];
            return CustomBottomNav(
              currentIndex: _currentIndex,
              activePages: pages,
              onTap: onTap,
            );
          },
        ),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      if (activePages.contains(index)) {
        _currentIndex = index;
        _title = titles[index];
      } else {
        return;
      }
    });
  }
}

class MainViewArguments {
  LocationModel currentLocation;

  MainViewArguments(this.currentLocation);
}
