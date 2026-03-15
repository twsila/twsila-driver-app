import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_geocoder/geocoder.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';

import '../../../../../app/constants.dart';
import '../../../utils/helpers/user_current_location.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/styles_manager.dart';
import '../../google_maps/view/google_places_field.dart';
import '../state_renderer/dialogs.dart';
import 'custom_circular_indicator.dart';
import 'custom_close_button.dart';
import 'custom_maps_widget.dart';

class CustomSearchBottomsheet extends StatefulWidget {
  final String title;
  final bool showCurrentLocation;
  final Function(String lat, String long, String locationName) onSelectPlace;

  const CustomSearchBottomsheet({
    Key? key,
    required this.title,
    required this.onSelectPlace,
    this.showCurrentLocation = false,
  }) : super(key: key);

  @override
  _CustomSearchBottomsheetState createState() =>
      _CustomSearchBottomsheetState();
}

class _CustomSearchBottomsheetState extends State<CustomSearchBottomsheet> {
  final TextEditingController _searchController = TextEditingController();
  late final LocatitonGeocoder geocoder;
  bool getLocationFromMap = false;
  bool _isAddressLoading = false;

  @override
  void initState() {
    if (widget.showCurrentLocation) {
      final AppPreferences _appPrefs = instance();
      var language = _appPrefs.getAppLanguage();
      geocoder = LocatitonGeocoder(
        Platform.isIOS
            ? Constants.googleApiKeyIos
            : Constants.googleApiKeyAndroid,
        lang: language,
      );
      getLocation();
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void getLocation() async {
    try {
      setState(() {
        _isAddressLoading = true;
      });
      var location;
      await UserCurrentLocation().checkLocationPermission();
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        location = LatLng(position.latitude, position.longitude);
        getAddress(location!);
      });
    } catch (e) {
      setState(() {
        _isAddressLoading = false;
      });
      // Location is needed for this feature, but don't force close
      // Show message and allow user to manually search or continue
      ShowDialogHelper.showDialogPopupWithCancel(
        AppStrings.location_required.tr(),
        "${AppStrings.locationEnable.tr()}. You can still manually search for locations.",
        context,
        () {
          // Don't close the bottom sheet - allow manual search
          Navigator.pop(context);
        },
        () {
          Geolocator.openLocationSettings();
          Navigator.pop(context);
        },
        okText: AppStrings.tryAgain.tr(),
        dismissible: true,
      );
    }
  }

  void getAddress(LatLng location) async {
    final coordinates = Coordinates(location.latitude, location.longitude);
    try {
      var addresses = await geocoder.findAddressesFromCoordinates(coordinates);
      _searchController.text = addresses.first.addressLine ??
          addresses.first.adminArea ??
          addresses.first.locality ??
          '';
      widget.onSelectPlace(
        location.latitude.toString(),
        location.longitude.toString(),
        _searchController.text,
      );
    } catch (e) {
      ShowDialogHelper.showErrorMessage(e.toString(), context);
    }
    setState(() {
      _isAddressLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: !getLocationFromMap
          ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style:
                            getMediumStyle(color: ColorManager.titlesTextColor),
                      ),
                      const CustomCloseButton(),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  child: Column(
                    children: [
                      _isAddressLoading
                          ? const CustomCircularProgressIndicator()
                          : GoogleMapsPlacesField(
                              controller: _searchController,
                              focusNode: FocusNode(debugLabel: 'source_node'),
                              hintText: widget.title,
                              predictionCallback: (prediction) {
                                if (prediction != null) {
                                  widget.onSelectPlace(
                                    prediction.lat!,
                                    prediction.lng!,
                                    prediction.description!,
                                  );
                                  Navigator.pop(context);
                                } else {}
                              },
                            ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            getLocationFromMap = true;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.pin),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppStrings.selectLocationOnMap.tr(),
                                style: getBoldStyle(
                                    color: ColorManager.titlesTextColor,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          : ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: CustomMapsWidget(
                  title: widget.title,
                  onSelectLocation: (lat, long, locationName) {
                    widget.onSelectPlace(
                      lat,
                      long,
                      locationName,
                    );
                    Navigator.pop(context);
                  },
                  onBackPressed: () {
                    setState(() {
                      getLocationFromMap = false;
                    });
                  }),
            ),
    );
  }
}
