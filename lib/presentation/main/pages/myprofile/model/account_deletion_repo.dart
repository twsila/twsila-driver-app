import 'package:dio/dio.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/utils/api_error_formatter.dart';

class AccountDeletionRepo {
  final Dio _dio;

  AccountDeletionRepo(this._dio);

  Future<void> deleteDriverAccount({required int userId}) async {
    try {
      final res = await _dio.post(
        EndPointsConstants.driverDeleteAccount,
        data: {'userId': userId.toString()},
      );
      final data = res.data;
      if (data is Map<String, dynamic> && data['success'] != true) {
        throw Exception(data['message'] as String? ?? 'Failed to delete account');
      }
    } on DioError catch (e) {
      throw Exception(formatApiError(e));
    }
  }
}
