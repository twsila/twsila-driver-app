import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/presentation/trip_history/model/trip_history_models.dart';
import 'package:taxi_for_you/utils/api_error_formatter.dart';

class TripHistoryRepo {
  final Dio _dio;

  TripHistoryRepo(this._dio);

  Future<List<TripHistoryItem>> getDriverHistory({
    required int userId,
    DateFilterRequest? dateFilter,
  }) async {
    final body = <String, dynamic>{
      'userId': userId.toString(),
      if (dateFilter != null) 'dateFilter': dateFilter.toJson(),
    };
    try {
      final res =
          await _dio.post(EndPointsConstants.driverTripHistory, data: body);
      return _parseHistoryList(_unwrapResult(res.data));
    } on DioError catch (e) {
      throw Exception(formatApiError(e));
    }
  }

  Future<TripInvoice> getCaptainInvoice(int tripId) async {
    try {
      final res =
          await _dio.get('${EndPointsConstants.captainInvoice}/$tripId');
      final result = _unwrapResult(res.data);
      if (result is Map<String, dynamic> && result['status'] == 404) {
        throw Exception(
          result['detail'] as String? ?? 'Invoice endpoint not found',
        );
      }
      if (result is! Map<String, dynamic>) {
        throw Exception('Invalid invoice response');
      }
      return TripInvoice.fromJson(result);
    } on DioError catch (e) {
      throw Exception(formatApiError(e));
    }
  }

  Future<Uint8List> downloadCaptainInvoicePdf(int tripId) async {
    try {
      final res = await _dio.get<List<int>>(
        '${EndPointsConstants.captainInvoice}/$tripId/pdf',
        options: Options(responseType: ResponseType.bytes),
      );
      if (res.statusCode != 200 || res.data == null) {
        throw Exception(
          'Failed to download invoice PDF (${res.statusCode ?? 0})',
        );
      }
      return Uint8List.fromList(res.data!);
    } on DioError catch (e) {
      throw Exception(formatApiError(e));
    }
  }

  dynamic _unwrapResult(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['result'] ?? data;
    }
    return data;
  }

  List<TripHistoryItem> _parseHistoryList(dynamic result) {
    if (result is Map<String, dynamic> && result['status'] == 404) {
      throw Exception(
        result['detail'] as String? ?? 'Trip history endpoint not found',
      );
    }
    if (result is! List) return [];
    return result
        .map((e) => TripHistoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
