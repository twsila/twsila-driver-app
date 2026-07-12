import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// UI currency formatting. API payloads still use ISO codes (e.g. SAR).
class CurrencyDisplay {
  CurrencyDisplay._();

  /// Official Saudi Riyal sign (Unicode U+20C1).
  static const String sarSymbol = '\u{20C1}';

  /// Bundled font that renders [sarSymbol]; Cairo/Lato do not include U+20C1.
  static const String sarFontFamily = 'SaudiRiyal';

  static const String _sarIso = 'SAR';

  static bool isSar(String? currency) {
    if (currency == null || currency.trim().isEmpty) {
      return true;
    }
    final normalized = currency.trim();
    if (normalized.toUpperCase() == _sarIso) {
      return true;
    }
    if (normalized.contains('ريال') ||
        normalized.toLowerCase().contains('saudi')) {
      return true;
    }
    return normalized == sarSymbol;
  }

  static String displaySymbol(String? currency) {
    if (isSar(currency)) {
      return sarSymbol;
    }
    return currency?.trim() ?? sarSymbol;
  }

  static String formatNumber(
    num? amount, {
    String pattern = '#,##0.00',
    String? locale,
    String fallback = '—',
  }) {
    if (amount == null) return fallback;
    return NumberFormat(pattern, locale ?? 'en').format(amount);
  }

  static String formatAmount(
    num? amount, {
    String? currencyCode,
    String pattern = '#,##0.00',
    String? locale,
    String fallback = '—',
  }) {
    if (amount == null) return fallback;
    return '${formatNumber(amount, pattern: pattern, locale: locale)} '
        '${displaySymbol(currencyCode)}';
  }

  /// Renders an amount with the Saudi Riyal symbol using the bundled font.
  static Widget amountText(
    num? amount, {
    required TextStyle style,
    String? currencyCode,
    String pattern = '#,##0.00',
    String? locale,
    String fallback = '—',
    TextAlign? textAlign,
  }) {
    if (amount == null) {
      return Text(fallback, style: style, textAlign: textAlign);
    }
    return Text.rich(
      amountSpan(
        amount,
        style: style,
        currencyCode: currencyCode,
        pattern: pattern,
        locale: locale,
      ),
      textAlign: textAlign,
    );
  }

  static TextSpan amountSpan(
    num amount, {
    required TextStyle style,
    String? currencyCode,
    String pattern = '#,##0.00',
    String? locale,
  }) {
    final formatted = formatNumber(amount, pattern: pattern, locale: locale);
    final symbol = displaySymbol(currencyCode);
    if (!isSar(currencyCode)) {
      return TextSpan(text: '$formatted $symbol', style: style);
    }
    return TextSpan(
      style: style,
      children: [
        TextSpan(text: '$formatted '),
        TextSpan(
          text: sarSymbol,
          style: style.copyWith(
            fontFamily: sarFontFamily,
            fontFamilyFallback: const <String>[],
          ),
        ),
      ],
    );
  }
}
