/// Mirrors the backend `OfferPriceBreakdownDto` (twsila-common).
///
/// All monetary fields are non-nullable for ergonomic UI usage; we coerce
/// missing/invalid JSON values to 0.0 so the widget never crashes on a
/// malformed payload.
class OfferPriceBreakdownModel {
  final String calculationMode; // "FROM_PASSENGER_TOTAL" | "FROM_CAPTAIN_NET"
  final double vatRate;
  final double appCommissionRate;
  final double passengerTotal;
  final double subtotalBeforeVat;
  final double vatAmount;
  final double appCommissionAmount;
  final double captainNetAmount;
  final String currencyCode;

  OfferPriceBreakdownModel({
    required this.calculationMode,
    required this.vatRate,
    required this.appCommissionRate,
    required this.passengerTotal,
    required this.subtotalBeforeVat,
    required this.vatAmount,
    required this.appCommissionAmount,
    required this.captainNetAmount,
    required this.currencyCode,
  });

  factory OfferPriceBreakdownModel.fromJson(Map<String, dynamic> json) {
    return OfferPriceBreakdownModel(
      calculationMode: (json['calculationMode'] ?? '').toString(),
      vatRate: _asDouble(json['vatRate']),
      appCommissionRate: _asDouble(json['appCommissionRate']),
      passengerTotal: _asDouble(json['passengerTotal']),
      subtotalBeforeVat: _asDouble(json['subtotalBeforeVat']),
      vatAmount: _asDouble(json['vatAmount']),
      appCommissionAmount: _asDouble(json['appCommissionAmount']),
      captainNetAmount: _asDouble(json['captainNetAmount']),
      currencyCode: (json['currencyCode'] ?? 'SAR').toString(),
    );
  }

  static double _asDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}

/// Wrapper for the preview API response (`PricingPreviewResponseDto`).
class PricingPreviewResponseModel {
  final OfferPriceBreakdownModel breakdown;

  PricingPreviewResponseModel({required this.breakdown});

  factory PricingPreviewResponseModel.fromJson(Map<String, dynamic> json) {
    final inner =
        (json['breakdown'] ?? json) as Map<String, dynamic>; // tolerate either shape
    return PricingPreviewResponseModel(
      breakdown: OfferPriceBreakdownModel.fromJson(inner),
    );
  }
}
