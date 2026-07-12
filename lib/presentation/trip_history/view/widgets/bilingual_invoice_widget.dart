import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/trip_history/model/trip_history_models.dart';
import 'package:taxi_for_you/utils/currency_display.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

class BilingualInvoiceWidget extends StatelessWidget {
  final TripInvoice invoice;

  const BilingualInvoiceWidget({Key? key, required this.invoice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyCode = invoice.currencyCode;
    final dateLabel = (invoice.completionDate ?? invoice.creationDate ?? '')
        .getTimeStampFromDate(pattern: 'dd MMM yyyy');
    final regularLines =
        invoice.lines.where((line) => !line.totalLine).toList();
    final totalLine =
        invoice.lines.where((line) => line.totalLine).firstOrNull;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorManager.borderColor.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: ColorManager.headersTextColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBrandHeader(),
          _buildTitleSection(),
          _buildMetaSection(dateLabel),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              children: [
                for (var i = 0; i < regularLines.length; i++) ...[
                  if (i > 0) const SizedBox(height: 4),
                  _lineItem(regularLines[i], currencyCode),
                  if (i < regularLines.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 1,
                        color: ColorManager.lineColor.withOpacity(0.7),
                      ),
                    ),
                ],
              ],
            ),
          ),
          if (totalLine != null) ...[
            _dashedSeparator(),
            _totalSection(totalLine, currencyCode),
          ],
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: const BoxDecoration(
        color: ColorManager.splashBGColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Image.asset(
            ImageAssets.splashIc,
            width: 140,
            height: 52,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.twselaCaptian.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              fontFamily: FontConstants.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        children: [
          Text(
            invoice.titleEn,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: ColorManager.headersTextColor,
              fontFamily: FontConstants.fontFamily,
            ),
          ),
          const SizedBox(height: 4),
          Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Text(
              invoice.titleAr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: ColorManager.headersTextColor,
                fontFamily: FontConstants.fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaSection(String dateLabel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: ColorManager.primaryBlueBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorManager.borderColor.withOpacity(0.5),
          ),
        ),
        child: Column(
          children: [
            if (invoice.tripNumber != null)
              _metaRow(
                AppStrings.tripNumber.tr(),
                invoice.tripNumber!,
              ),
            if (invoice.tripNumber != null && dateLabel.isNotEmpty)
              const SizedBox(height: 8),
            if (dateLabel.isNotEmpty)
              _metaRow('Date / التاريخ', dateLabel),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ColorManager.formHintTextColor,
              fontFamily: FontConstants.fontFamily,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ColorManager.headersTextColor,
              fontFamily: FontConstants.fontFamily,
            ),
          ),
        ),
      ],
    );
  }

  Widget _lineItem(InvoiceLine line, String currencyCode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.labelEn,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: ColorManager.headersTextColor,
                  height: 1.35,
                  fontFamily: FontConstants.fontFamily,
                ),
              ),
              const SizedBox(height: 3),
              Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    line.labelAr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ColorManager.titlesTextColor,
                      height: 1.35,
                      fontFamily: FontConstants.fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        CurrencyDisplay.amountText(
          line.amount,
          currencyCode: currencyCode,
          textAlign: TextAlign.end,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: ColorManager.headersTextColor,
            fontFamily: FontConstants.fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _dashedSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 6.0;
          const dashSpace = 4.0;
          final dashCount =
              (constraints.maxWidth / (dashWidth + dashSpace)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return Container(
                width: dashWidth,
                height: 1.5,
                color: ColorManager.lineColor,
              );
            }),
          );
        },
      ),
    );
  }

  Widget _totalSection(InvoiceLine line, String currencyCode) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ColorManager.splashBGColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ColorManager.splashBGColor.withOpacity(0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.labelEn,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.headersTextColor,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                const SizedBox(height: 3),
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                    line.labelAr,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.headersTextColor,
                      fontFamily: FontConstants.fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CurrencyDisplay.amountText(
            line.amount,
            currencyCode: currencyCode,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: ColorManager.splashBGColor,
              fontFamily: FontConstants.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
      child: Column(
        children: [
          Icon(
            Icons.verified_outlined,
            size: 18,
            color: ColorManager.formHintTextColor.withOpacity(0.8),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.tawsilaApplication.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: ColorManager.formHintTextColor,
              fontFamily: FontConstants.fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
