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

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";
const String ACCEPT_LANGUAGE = "Accept-Language";
const String RETRY_COUNTER = "Retry-Count";
const String TRY_AUTH_REFRESH = "TRY_AUTH_REFRESH";
const String USER_TYPE = "User-Type";

class DioFactory {
  final AppPreferences _appPreferences;

  DioFactory(this._appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();

    String language = await _appPreferences.getAppLanguage();
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      USER_TYPE: _appPreferences.getUserType() ?? "",
      ACCEPT_LANGUAGE: language,
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
            options.headers[AUTHORIZATION] = token;
          }
          options.headers[USER_TYPE] = _appPreferences.getUserType() ?? "";
          return handler.next(options);
        },
        onError: (DioError error, handler) async {
          if (error.response?.statusCode == 401) {
            // If a 401 response is received, refresh the access token

            if (error.requestOptions.headers[RETRY_COUNTER] == 1) {
              return handler.next(error);
            }
            String newAccessToken = await refreshToken();
            await _appPreferences.setRefreshedToken(newAccessToken);

            // Update the request header with the new access token
            error.requestOptions.headers[AUTHORIZATION] =
                'Bearer $newAccessToken';

            error.requestOptions.headers[RETRY_COUNTER] = 1;

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
        CONTENT_TYPE: APPLICATION_JSON,
        ACCEPT: APPLICATION_JSON,
        USER_TYPE: _appPreferences.getUserType() ?? "",
        AUTHORIZATION: await _appPreferences.isUserLoggedIn()
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
