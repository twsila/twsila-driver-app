import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/styles_manager.dart';

import '../model/offer_price_breakdown_model.dart';

/// Renders a single offer's price breakdown (subtotal / VAT / commission /
/// captain net / passenger total).
///
/// - Pass [breakdown] when you already have it.
/// - Pass [isLoading] / [errorMessage] for the live-preview path.
/// - [emphasizeCaptainNet] highlights the captain's take-home (driver app
///   default = true) versus the gross total (passenger app default).
/// - [displayCurrencyOverride] lets you display a localized symbol (e.g.
///   "ر.س") even though the breakdown's `currencyCode` is an ISO code
///   ("SAR") — useful so we don't have to push localized symbols to the
///   backend just for display.
class PriceBreakdownWidget extends StatelessWidget {
  final OfferPriceBreakdownModel? breakdown;
  final bool isLoading;
  final String? errorMessage;
  final bool emphasizeCaptainNet;
  final String? displayCurrencyOverride;
  final EdgeInsetsGeometry padding;
  final bool showTitle;

  const PriceBreakdownWidget({
    Key? key,
    this.breakdown,
    this.isLoading = false,
    this.errorMessage,
    this.emphasizeCaptainNet = true,
    this.displayCurrencyOverride,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    this.showTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: padding,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      );
    }
    if (errorMessage != null) {
      return Padding(
        padding: padding,
        child: Text(
          errorMessage!,
          style: getRegularStyle(
            color: ColorManager.error,
            fontSize: FontSize.s12,
          ),
        ),
      );
    }
    final b = breakdown;
    if (b == null) return const SizedBox.shrink();

    final currency = (displayCurrencyOverride?.isNotEmpty ?? false)
        ? displayCurrencyOverride!
        : b.currencyCode;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showTitle)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                AppStrings.priceBreakdownTitle.tr(),
                style: getBoldStyle(
                  color: ColorManager.blackTextColor,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
          _row(AppStrings.priceBreakdownSubtotal.tr(), b.subtotalBeforeVat, currency),
          _row(AppStrings.priceBreakdownVat.tr(), b.vatAmount, currency),
          // _row(AppStrings.priceBreakdownAppCommission.tr(), b.appCommissionAmount, currency),
          const Divider(height: 14, thickness: 0.6),
          // _row(
          //   AppStrings.priceBreakdownCaptainNet.tr(),
          //   b.captainNetAmount,
          //   currency,
          //   emphasize: emphasizeCaptainNet,
          // ),
          _row(
            AppStrings.priceBreakdownTotal.tr(),
            b.passengerTotal,
            currency,
            emphasize: true,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, double value, String currency, {bool emphasize = false}) {
    final labelStyle = emphasize
        ? getBoldStyle(color: ColorManager.blackTextColor, fontSize: FontSize.s14)
        : getMediumStyle(color: ColorManager.blackTextColor, fontSize: FontSize.s12);
    final valueStyle = emphasize
        ? getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s14)
        : getMediumStyle(color: ColorManager.blackTextColor, fontSize: FontSize.s12);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          Text('${value.toStringAsFixed(2)} $currency', style: valueStyle),
        ],
      ),
    );
  }
}
