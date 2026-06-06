import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import '../pricing/model/pricing_repo.dart';
import '../pricing/widgets/live_price_breakdown.dart';

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

  // Legacy sheet state used only for [isAcceptOffer] (accept passenger budget).
  // Counter-offer / add-offer UI uses [LivePriceBreakdown] → backend preview only.
  double addedValueTax = 0.0;
  double tawsilaShareAmount = 0.0;
  double captainShareAmount = 0.0;
  double allTripCalculatedAmount = 0.0;

  /// Captain net while typing; drives [LivePriceBreakdown] (server preview).
  double? _livePreviewAmount;

  @override
  initState() {
    _loadDataFromSharedPreferences();
    super.initState();
  }

  Future<void> _loadDataFromSharedPreferences() async {
    coastCalculationModel = await _appPreferences.getCoastCalculationData();

    if (coastCalculationModel != null) {

      if (widget.isAcceptOffer != null && widget.isAcceptOffer == true) {

        _amountController.text = widget.clientOfferAmount?.toString() ?? '';

        captainShareAmount = double.parse(_amountController.text);

        tawsilaShareAmount = double.parse(_amountController.text) *
            coastCalculationModel!.twsilaCommissionForDriverAndBo;

        addedValueTax =
            (double.parse(_amountController.text) + tawsilaShareAmount) *
                coastCalculationModel!.vatForDriverAndBo;

        allTripCalculatedAmount =
            addedValueTax + tawsilaShareAmount + captainShareAmount;

        _livePreviewAmount = captainShareAmount;
      }
    }
    setState(() {});
  }

  /// Total trip amount shown in the sheet — backend requires this on PUT /drivers/offers/accept.
  double _acceptedTripAmountForApi() {
    if (allTripCalculatedAmount > 0) return allTripCalculatedAmount;
    if (captainShareAmount > 0) return captainShareAmount;
    return widget.clientOfferAmount ?? 0;
  }

  /// Validates captain net with the pricing preview API before add-offer.
  /// POST `/drivers/offers/add` must send **captain net** only; the server
  /// computes passenger gross (sending `passengerTotal` here double-charges).
  Future<void> _previewCaptainNetBeforeAddOffer() async {
    if (captainShareAmount <= 0) {
      throw StateError('captainShareAmount must be positive');
    }
    await instance<PricingRepo>().previewCaptainOffer(
      captainNet: captainShareAmount,
      currencyCode: 'SAR',
    );
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
                if (widget.isAcceptOffer == true) ...[
                  Table(
                    border: TableBorder.all(
                      color: Colors.black,
                      width: 2,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    columnWidths: {
                      0: FixedColumnWidth(firstColumnWidth),
                      1: FixedColumnWidth(secondColumnWidth),
                    },
                    children: [
                      TableRow(
                        children: [
                          _buildTableCell(AppStrings.addedValueTax.tr()),
                          _buildTableCell(addedValueTax
                              .toCommaSeparated(decimalPlaces: 2)),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell(AppStrings.twsilaShareAmount.tr()),
                          _buildTableCell(tawsilaShareAmount
                              .toCommaSeparated(decimalPlaces: 2)),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell(AppStrings.captainShareAmount.tr()),
                          _buildTableCell(captainShareAmount
                              .toCommaSeparated(decimalPlaces: 2)),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell(
                              AppStrings.allTripCalculatedAmount.tr()),
                          _buildTableCell(allTripCalculatedAmount
                              .toCommaSeparated(decimalPlaces: 2)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
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
                            _livePreviewAmount = captainShareAmount;
                          });
                        },
                      ),
                if (widget.isAcceptOffer != true)
                  LivePriceBreakdown(
                    amount: _livePreviewAmount,
                    mode: PricingPreviewMode.captainNet,
                    currencyCode: 'SAR',
                    displayCurrencyOverride: AppStrings.sarCurrency.tr(),
                    emphasizeCaptainNet: true,
                    padding: const EdgeInsets.only(top: 12.0),
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
                                      _acceptedTripAmountForApi(),
                                      driverId: widget.assignedDriverToTrip!.id));
                            } else {
                              BlocProvider.of<TripDetailsBloc>(context).add(
                                  AcceptOffer(
                                      _appPreferences.getCachedDriver()!.id!,
                                      widget.tripId,
                                      _appPreferences
                                          .getCachedDriver()!
                                          .captainType
                                          .toString(),
                                      _acceptedTripAmountForApi()));
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
                                  final tripDetailsBloc =
                                      BlocProvider.of<TripDetailsBloc>(context);
                                  final navigator = Navigator.of(context);
                                  final captainNet =
                                      (captainShareAmount * 100).round() / 100.0;
                                  _previewCaptainNetBeforeAddOffer().then((_) {
                                    if (!mounted) return;
                                    tripDetailsBloc.add(AddOffer(
                                        _appPreferences.getCachedDriver()!.id!,
                                        widget.tripId,
                                        captainNet,
                                        _appPreferences
                                            .getCachedDriver()!
                                            .captainType
                                            .toString(),
                                        driverId: widget.assignedDriverToTrip !=
                                                null
                                            ? widget.assignedDriverToTrip!.id
                                            : null));
                                    navigator.pop();
                                    navigator.pop();
                                  }).catchError((_) {
                                    if (!mounted) return;
                                    Fluttertoast.showToast(
                                      msg:
                                          'Could not calculate offer. Check connection.',
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
                                    navigator.pop();
                                  });
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
    _livePreviewAmount = null;
  }
}
