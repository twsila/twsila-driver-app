import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/app/extensions.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/coast_calculation_model.dart';
import '../../../domain/model/driver_model.dart';
import '../../../utils/dialogs/custom_dialog.dart';
import '../../../utils/resources/color_manager.dart';
import '../../common/widgets/custom_text_button.dart';
import '../../common/widgets/custom_text_input_field.dart';
import '../../trip_details/bloc/trip_details_bloc.dart';

class CoastCalculationBottomSheetView extends StatefulWidget {
  bool? isSuggestNewOffer;
  bool? isAcceptOffer;
  double? clientOfferAmount;
  int tripId;
  Driver? assignedDriverToTrip;

  CoastCalculationBottomSheetView(
      {required this.tripId,
      this.isAcceptOffer,
      this.clientOfferAmount,
      this.isSuggestNewOffer,
      this.assignedDriverToTrip});

  @override
  State<CoastCalculationBottomSheetView> createState() =>
      _CoastCalculationBottomSheetViewState();
}

class _CoastCalculationBottomSheetViewState
    extends State<CoastCalculationBottomSheetView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  TextEditingController _amountController = TextEditingController();

  CoastCalculationModel? coastCalculationModel;

  bool assignedDriverToTrip = false; // is bool to handle bo assign driver

  double addedValueTax = 0.0;
  double tawsilaShareAmount = 0.0;
  double captainShareAmount = 0.0;
  double allTripCalculatedAmount = 0.0;

  @override
  initState() {
    _loadDataFromSharedPreferences();
    super.initState();
  }

  // Method to load data from SharedPreferences
  Future<void> _loadDataFromSharedPreferences() async {
    coastCalculationModel = await _appPreferences.getCoastCalculationData();

    if (coastCalculationModel != null) {

      if (widget.isAcceptOffer != null && widget.isAcceptOffer == true) {

        _amountController.text = widget.clientOfferAmount.toString();

        captainShareAmount = double.parse(_amountController.text);

        tawsilaShareAmount = double.parse(_amountController.text) *
            coastCalculationModel!.twsilaCommissionForDriverAndBo;

        addedValueTax =
            (double.parse(_amountController.text) + tawsilaShareAmount) *
                coastCalculationModel!.vatForDriverAndBo;

        allTripCalculatedAmount =
            addedValueTax + tawsilaShareAmount + captainShareAmount;
      }
    }
    setState(() {});
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: FontSize.s16, color: ColorManager.blackTextColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate column widths dynamically based on screen width
            double screenWidth = constraints.maxWidth;
            double firstColumnWidth =
                screenWidth * 0.33; // 66% for the first column
            double secondColumnWidth =
                screenWidth * 0.66; // 33% for the second column
            return Column(
              crossAxisAlignment: _appPreferences.getAppLanguage() == 'ar'
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Table(
                  border: TableBorder.all(
                    color: Colors.black, // Color of the border
                    width: 2, // Width of the border
                    borderRadius: BorderRadius.circular(
                        5), // Optional: to round the corners
                  ),
                  columnWidths: {
                    0: FixedColumnWidth(firstColumnWidth),
                    // First column with double width (adjust size here)
                    1: FixedColumnWidth(secondColumnWidth),
                    // Second column with normal width (adjust size here)
                  },
                  children: [
                    // Row 1
                    TableRow(
                      children: [
                        _buildTableCell(AppStrings.addedValueTax.tr()),
                        _buildTableCell(addedValueTax.toCommaSeparated(decimalPlaces: 2)),
                      ],
                    ),
                    // Row 2
                    TableRow(
                      children: [
                        _buildTableCell(AppStrings.twsilaShareAmount.tr()),
                        _buildTableCell(
                            tawsilaShareAmount.toCommaSeparated(decimalPlaces: 2)),
                      ],
                    ),
                    // Row 3
                    TableRow(
                      children: [
                        _buildTableCell(AppStrings.captainShareAmount.tr()),
                        _buildTableCell(
                            captainShareAmount.toCommaSeparated(decimalPlaces: 2)),
                      ],
                    ),
                    // Row 4
                    TableRow(
                      children: [
                        _buildTableCell(AppStrings.allTripCalculatedAmount.tr()),
                        _buildTableCell(
                            allTripCalculatedAmount.toCommaSeparated(decimalPlaces: 2)),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                widget.isAcceptOffer != null && widget.isAcceptOffer == true
                    ? Container()
                    : CustomTextInputField(
                        margin: EdgeInsets.zero,
                        validateEmptyString: true,
                        labelText: AppStrings.enterPriceThatYouWant.tr(),
                        showLabelText: true,
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                        validateSpecialCharacter: true,
                        hintText: AppStrings.enterRequiredPrice.tr(),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              resetValues();
                              return;
                            }

                            captainShareAmount =
                                double.parse(_amountController.text);

                            tawsilaShareAmount =
                                double.parse(_amountController.text) *
                                    coastCalculationModel!
                                        .twsilaCommissionForDriverAndBo;

                            addedValueTax =
                                (double.parse(_amountController.text) +
                                        tawsilaShareAmount) *
                                    coastCalculationModel!.vatForDriverAndBo;

                            allTripCalculatedAmount = (addedValueTax +
                                tawsilaShareAmount +
                                captainShareAmount).toPrecision(2);
                          });
                        },
                      ),
                widget.isAcceptOffer != null && widget.isAcceptOffer == true
                    ? CustomTextButton(
                        text: AppStrings.confirm.tr(),
                        isWaitToEnable: true,
                        onPressed: () {
                          CustomDialog(context).showCupertinoDialog(
                              AppStrings.confirmSendOffer.tr(),
                              AppStrings.areYouSureToSendNewOffer.tr(),
                              AppStrings.confirm.tr(),
                              AppStrings.cancel.tr(),
                              ColorManager.primary, () {
                            if (widget.assignedDriverToTrip != null) {
                              BlocProvider.of<TripDetailsBloc>(context).add(
                                  AcceptOffer(
                                      _appPreferences.getCachedDriver()!.id!,
                                      widget.tripId,
                                      _appPreferences
                                          .getCachedDriver()!
                                          .captainType
                                          .toString(),
                                      driverId: widget.assignedDriverToTrip!.id));
                            } else {
                              BlocProvider.of<TripDetailsBloc>(context).add(
                                  AcceptOffer(
                                      _appPreferences.getCachedDriver()!.id!,
                                      widget.tripId,
                                      _appPreferences
                                          .getCachedDriver()!
                                          .captainType
                                          .toString()));
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }, () {
                            Navigator.pop(context);
                          });
                        })
                    : CustomTextButton(
                        text: AppStrings.confirm.tr(),
                        isWaitToEnable: true,
                        onPressed: _amountController.text.isEmpty
                            ? null
                            : () {
                                CustomDialog(context).showCupertinoDialog(
                                    AppStrings.confirmSendOffer.tr(),
                                    AppStrings.areYouSureToSendNewOffer.tr(),
                                    AppStrings.confirm.tr(),
                                    AppStrings.cancel.tr(),
                                    ColorManager.primary, () {
                                  BlocProvider.of<TripDetailsBloc>(context).add(
                                      AddOffer(
                                          _appPreferences.getCachedDriver()!.id!,
                                          widget.tripId,
                                          allTripCalculatedAmount.toPrecision(2),
                                          _appPreferences
                                              .getCachedDriver()!
                                              .captainType
                                              .toString(),
                                          driverId: widget.assignedDriverToTrip !=
                                                  null
                                              ? widget.assignedDriverToTrip!.id
                                              : null));
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }, () {
                                  Navigator.pop(context);
                                });
                              },
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  void resetValues() {
    _amountController.clear();
    addedValueTax = 0.0;
    tawsilaShareAmount = 0.0;
    captainShareAmount = 0.0;
    allTripCalculatedAmount = 0.0;
  }
}
