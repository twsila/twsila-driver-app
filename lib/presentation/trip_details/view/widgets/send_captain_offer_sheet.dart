import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/presentation/coast_calculation/pricing/model/pricing_repo.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/presentation/trip_details/bloc/trip_details_bloc.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/styles_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

class SendCaptainOfferSheet extends StatefulWidget {
  final TripDetailsBloc tripDetailsBloc;
  final int userId;
  final int tripId;
  final String captainType;
  final int? driverId;
  final String currencySuffix;

  const SendCaptainOfferSheet({
    Key? key,
    required this.tripDetailsBloc,
    required this.userId,
    required this.tripId,
    required this.captainType,
    this.driverId,
    required this.currencySuffix,
  }) : super(key: key);

  @override
  State<SendCaptainOfferSheet> createState() => _SendCaptainOfferSheetState();
}

class _SendCaptainOfferSheetState extends State<SendCaptainOfferSheet> {
  bool _enableSend = false;
  double _amount = 0;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return BlocProvider.value(
      value: widget.tripDetailsBloc,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppPadding.p20,
            AppPadding.p4,
            AppPadding.p20,
            AppPadding.p20 + bottomInset,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSize.s20),
              Text(
                AppStrings.sendOfferWithPrice.tr(),
                style: getSemiBoldStyle(
                  fontSize: FontSize.s18,
                  color: ColorManager.headersTextColor,
                ),
              ),
              const SizedBox(height: AppSize.s12),
              CustomTextInputField(
                showLabelText: false,
                hintText: AppStrings.enterRequiredPrice.tr(),
                hintTextColor: ColorManager.formHintTextColor,
                margin: EdgeInsets.zero,
                borderRadius: AppSize.s12,
                borderColor: ColorManager.borderColor,
                suffixIcon: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppPadding.p8,
                    end: AppPadding.p12,
                  ),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      widget.currencySuffix,
                      style: getSemiBoldStyle(
                        fontSize: FontSize.s16,
                        color: ColorManager.headersTextColor,
                      ),
                    ),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    final parsed = double.tryParse(value);
                    if (parsed != null && parsed > 0) {
                      setState(() {
                        _enableSend = true;
                        _amount = parsed;
                      });
                    } else {
                      setState(() => _enableSend = false);
                    }
                  } else {
                    setState(() => _enableSend = false);
                  }
                },
              ),
              const SizedBox(height: AppPadding.p16),
              CustomTextButton(
                isWaitToEnable: false,
                margin: 0,
                text: AppStrings.sendOffer.tr(),
                onPressed: () {
                  if (!_enableSend) {
                    ToastHandler(context)
                        .showToast('enter valid price', Toast.LENGTH_SHORT);
                    return;
                  }
                  CustomDialog(context).showCupertinoDialog(
                      AppStrings.confirmSendOffer.tr(),
                      AppStrings.areYouSureToSendNewOffer.tr(),
                      AppStrings.confirm.tr(),
                      AppStrings.cancel.tr(),
                      ColorManager.primary, () {
                    final ctx = context;
                    final tripDetailsBloc =
                        BlocProvider.of<TripDetailsBloc>(ctx);
                    final navigator = Navigator.of(ctx);
                    // Captain types net; POST must send that same net — backend
                    // derives passenger gross + VAT/commission (do not send passengerTotal).
                    instance<PricingRepo>()
                        .previewCaptainOffer(
                            captainNet: _amount, currencyCode: 'SAR')
                        .then((_) {
                      if (!mounted) return;
                      tripDetailsBloc.add(AddOffer(
                        widget.userId,
                        widget.tripId,
                        _amount,
                        widget.captainType,
                        driverId: widget.driverId,
                      ));
                      navigator.pop();
                      navigator.pop();
                    }).catchError((_) {
                      if (!mounted) return;
                      Fluttertoast.showToast(
                          msg:
                              'Could not calculate offer. Check connection.',
                          toastLength: Toast.LENGTH_SHORT);
                      navigator.pop();
                    });
                  }, () {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
