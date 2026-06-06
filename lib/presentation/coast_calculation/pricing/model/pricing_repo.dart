import 'package:dio/dio.dart';
import 'package:taxi_for_you/app/constants.dart';

import 'offer_price_breakdown_model.dart';

/// Self-contained repo for the pricing-preview / trip-final pricing APIs.
///
/// **Policy:** VAT, commission, and passenger/captain splits are computed only
/// on the server ([PricingCalculationService]). Change rates in backend config
/// (e.g. `app.cost-calculations`) and ship without app store updates. This
/// client only POSTs the typed amount and renders the returned breakdown.
///
/// Uses raw [Dio] (registered in [initAppModule]) instead of going through the
/// generated Retrofit `AppServiceClient` so we don't have to regenerate
/// `app_api.g.dart` for one isolated feature.
class PricingRepo {
  final Dio _dio;
  PricingRepo(this._dio);

  /// Preview when the passenger is the one entering an amount (their gross).
  Future<OfferPriceBreakdownModel> previewPassengerOffer({
    required double passengerTotal,
    String currencyCode = 'SAR',
    CancelToken? cancelToken,
  }) async {
    final res = await _dio.post(
      EndPointsConstants.pricingPreviewPassenger,
      data: {
        'passengerTotal': passengerTotal,
        'currencyCode': currencyCode,
      },
      cancelToken: cancelToken,
    );
    return _extractBreakdown(res.data);
  }

  /// Preview when the captain is the one entering an amount (their net).
  /// Used by the driver app under the cost-calculation bottom sheet.
  Future<OfferPriceBreakdownModel> previewCaptainOffer({
    required double captainNet,
    String currencyCode = 'SAR',
    CancelToken? cancelToken,
  }) async {
    final res = await _dio.post(
      EndPointsConstants.pricingPreviewCaptain,
      data: {
        'captainNet': captainNet,
        'currencyCode': currencyCode,
      },
      cancelToken: cancelToken,
    );
    return _extractBreakdown(res.data);
  }

  /// Returns the immutable accepted-trip pricing snapshot, if one exists.
  Future<OfferPriceBreakdownModel?> getTripFinalPricing({
    required int tripId,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dio.get(
        '${EndPointsConstants.pricingTripFinal}/$tripId/final',
        cancelToken: cancelToken,
      );
      final raw = res.data is Map<String, dynamic>
          ? res.data['result'] as Map<String, dynamic>?
          : null;
      if (raw == null) return null;
      // TripPriceDetailsDto carries the same fields as the breakdown DTO.
      return OfferPriceBreakdownModel.fromJson(raw);
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  OfferPriceBreakdownModel _extractBreakdown(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Unexpected pricing response shape');
    }
    final result = data['result'];
    if (result is Map<String, dynamic>) {
      final inner = result['breakdown'];
      if (inner is Map<String, dynamic>) {
        return OfferPriceBreakdownModel.fromJson(inner);
      }
      // Tolerate flattened payloads in case of envelope changes.
      return OfferPriceBreakdownModel.fromJson(result);
    }
    throw const FormatException('Missing pricing result envelope');
  }
}
