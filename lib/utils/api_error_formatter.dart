import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

/// Formats API / network errors for display in feature screens.
String formatApiError(Object error) {
  if (error is DioError) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 404) {
      final detail = _readDioMessage(error) ?? '';
      if (detail.contains('No static resource')) {
        return 'Trip history is not deployed on this server yet. '
            'For local testing, run the development flavor against '
            'http://127.0.0.1:8080 (flutter run --flavor development '
            '-t lib/main_development.dart).';
      }
      return 'Trip history is not available on the server. '
          'Restart the backend with the latest code.';
    }
    final message = _readDioMessage(error);
    if (message != null) {
      return message;
    }
    if (statusCode != null) {
      return 'Request failed (HTTP $statusCode). Please try again.';
    }
  }

  final raw = error.toString().replaceFirst('Exception: ', '').trim();
  if (raw.isNotEmpty && raw != 'Exception' && !raw.contains('\n')) {
    return raw;
  }

  return AppStrings.defaultError.tr();
}

String? _readDioMessage(DioError error) {
  final data = error.response?.data;
  if (data is String && data.trim().isNotEmpty) {
    return data.trim();
  }
  if (data is Map<String, dynamic>) {
    final message = data['message'] as String?;
    if (message != null && message.trim().isNotEmpty) {
      return message.trim();
    }
    final detail = data['detail'] as String?;
    if (detail != null && detail.trim().isNotEmpty) {
      return detail.trim();
    }
  }
  return null;
}
