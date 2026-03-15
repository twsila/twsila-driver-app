import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/app_prefs.dart';
import '../../app/constants.dart';
import '../../flavors.dart';
import '../../utils/resources/global_key.dart';
import '../../utils/resources/routes_manager.dart';

class HttpHeaderKeys {
  static const String applicationJson = "application/json";
  static const String contentType = "content-type";
  static const String accept = "accept";
  static const String authorization = "authorization";
  static const String defaultLanguage = "language";
  static const String acceptLanguage = "Accept-Language";
  static const String retryCounter = "Retry-Count";
  static const String tryAuthRefresh = "TRY_AUTH_REFRESH";
  static const String userType = "User-Type";
}

class DioFactory {
  final AppPreferences _appPreferences;

  DioFactory(this._appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();

    String language = await _appPreferences.getAppLanguage();
    Map<String, String> headers = {
      HttpHeaderKeys.contentType: HttpHeaderKeys.applicationJson,
      HttpHeaderKeys.accept: HttpHeaderKeys.applicationJson,
      HttpHeaderKeys.userType: _appPreferences.getUserType() ?? "",
      HttpHeaderKeys.acceptLanguage: language,
    };

    dio.options = BaseOptions(
        baseUrl: F.baseUrl,
        headers: headers,
        receiveTimeout: Constants.apiTimeOut,
        sendTimeout: Constants.apiTimeOut);


    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add the access token to the request header
          String token = await _appPreferences.isUserLoggedIn()
              ? "Bearer " +
                  (_appPreferences.getCachedDriver()?.accessToken ?? "")
              : "";

          if (EndPointsConstants.cancelTokenApis.contains(options.path)) {
            options.cancelToken;
          } else {
            options.headers[HttpHeaderKeys.authorization] = token;
          }
          options.headers[HttpHeaderKeys.userType] =
              _appPreferences.getUserType() ?? "";
          return handler.next(options);
        },
        onError: (DioError error, handler) async {
          if (error.response?.statusCode == 401) {
            if (error.requestOptions.headers[HttpHeaderKeys.retryCounter] ==
                1) {
              return handler.next(error);
            }
            String newAccessToken = await refreshToken();
            await _appPreferences.setRefreshedToken(newAccessToken);

            error.requestOptions.headers[HttpHeaderKeys.authorization] =
                'Bearer $newAccessToken';
            error.requestOptions.headers[HttpHeaderKeys.retryCounter] = 1;

            // Repeat the request with the updated header
            return handler.resolve(await dio.fetch(error.requestOptions));
          }
          return handler.next(error);
        },
      ),
    );

    if (!kReleaseMode) {
      // its debug mode so print app logs
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    return dio;
  }

  Future<String> refreshToken() async {
    try {
      Response response = await Dio(BaseOptions(headers: {
        HttpHeaderKeys.contentType: HttpHeaderKeys.applicationJson,
        HttpHeaderKeys.accept: HttpHeaderKeys.applicationJson,
        HttpHeaderKeys.userType: _appPreferences.getUserType() ?? "",
        HttpHeaderKeys.authorization: await _appPreferences.isUserLoggedIn()
            ? "Bearer " + (_appPreferences.getCachedDriver()?.accessToken ?? "")
            : "",
      })).post(F.baseUrl + EndPointsConstants.refreshToken, data: {
        "refreshToken": _appPreferences.getCachedDriver()?.refreshToken ?? ""
      });
      return response.data["result"]["accessToken"];
    } catch (e) {
      _appPreferences.removeCachedDriver();
      _appPreferences.setUserLoggedOut(
          NavigationService.navigatorKey.currentState!.context);
      return "";
    }
  }
}
