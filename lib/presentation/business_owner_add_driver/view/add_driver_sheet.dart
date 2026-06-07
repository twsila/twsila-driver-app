import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/presentation/business_owner_cars_and_drivers/bloc/bo_drivers_cars_bloc.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../utils/dialogs/custom_dialog.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_text_button.dart';

class AddDriverBottomSheetView extends StatefulWidget {
  List<String>? pendingDriversMobileNumbers;

  AddDriverBottomSheetView({this.pendingDriversMobileNumbers});

  @override
  State<AddDriverBottomSheetView> createState() =>
      _AddDriverBottomSheetViewState();
}

class _AddDriverBottomSheetViewState extends State<AddDriverBottomSheetView> {
  bool _displayLoadingIndicator = false;
  List<Driver> driversList = [];
  List<int> selectedDriversToAddList = [];
  Driver? selectedDriver;
  AppPreferences appPreferences = instance();
  Timer? _debounce;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
        const Duration(milliseconds: Constants.onChangeDebounceMilliseconds),
        () {
      BlocProvider.of<BoDriversCarsBloc>(context)
          .add(SearchDriversByMobile(int.parse(query)));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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
    return BlocConsumer<BoDriversCarsBloc, BoDriversCarsState>(
      listener: (context, state) {
        if (state is BoDriversCarsLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is SearchDriversSuccess) {
          this.driversList = state.drivers;
          if (widget.pendingDriversMobileNumbers != null) {
            driversList.removeWhere((element) =>
                widget.pendingDriversMobileNumbers!.contains(element.mobile));
          }
        }

        if (state is AddDriversSuccess) {
          CustomDialog(context).showSuccessDialog(
              '', '', AppStrings.sendingRequestDone.tr(), onBtnPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }

        if (state is SearchDriversFail) {
          CustomDialog(context).showErrorDialog('', '', state.message);
        }

        if (state is AddDriverFail) {
          CustomDialog(context).showErrorDialog('', '', state.message);
        }
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p8),
          height: MediaQuery.of(context).size.height *
              0.85, //to control height of bottom sheet
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: AppSize.s14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.addDriver.tr(),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: FontSize.s16,
                          color: ColorManager.secondaryColor),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close))
                  ],
                ),
                SizedBox(
                  height: AppSize.s25,
                ),
                CustomTextInputField(
                  showLabelText: false,
                  istitleBold: false,
                  keyboardType: TextInputType.number,
                  labelText: AppStrings.driverMobileNumber.tr(),
                  hintText: AppStrings.addDriverMobileNumber.tr(),
                  onChanged: (value) {
                    _onSearchChanged(value);
                  },
                ),
                Expanded(
                    child: _displayLoadingIndicator
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: driversList.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    driversList[i].isChecked =
                                        !driversList[i].isChecked;

                                    selectedDriver = driversList[i];

                                    if (selectedDriver!.isChecked) {
                                      selectedDriversToAddList
                                          .add(selectedDriver!.id!);
                                    } else {
                                      selectedDriversToAddList
                                          .remove(selectedDriver!);
                                    }
                                    print(selectedDriversToAddList.length);
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(AppMargin.m8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${driversList[i].firstName} ${driversList[i].lastName}",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: FontSize.s16,
                                                    color: ColorManager
                                                        .headersTextColor),
                                          ),
                                          driversList[i].isChecked
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: ColorManager.primary,
                                                )
                                              : Icon(
                                                  Icons.check_circle,
                                                  color: ColorManager.darkGrey,
                                                )
                                        ],
                                      ),
                                      Text(
                                        "${driversList[i].mobile}",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: FontSize.s14,
                                                color:
                                                    ColorManager.primaryPurple),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })),
              ],
            ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 0,
              right: 0,
              child: CustomTextButton(
                onPressed: selectedDriver != null
                    ? () {
                        BlocProvider.of<BoDriversCarsBloc>(context).add(
                            addDriverForBusinessOwner(
                                appPreferences.getCachedDriver()!.id!,
                                selectedDriversToAddList));
                      }
                    : null,
                text: AppStrings.addDriver.tr(),
                icon: Icon(
                  Icons.add,
                  color: selectedDriver == null
                      ? ColorManager.disableTextColor
                      : ColorManager.white,
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}
