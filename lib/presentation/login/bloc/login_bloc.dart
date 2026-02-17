import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/app/app_prefs.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:taxi_for_you/domain/model/allowed_services_model.dart';
import 'package:taxi_for_you/domain/usecase/allowed_services_usecase.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../domain/usecase/login_usecase.dart';
import '../../../utils/resources/constants_manager.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AppPreferences appPreferences = instance<AppPreferences>();

  LoginBloc() : super(LoginInitial()) {
    on<CheckInputIsValidEvent>(_checkInputStatus);
    on<MakeLoginEvent>(_makeLogin);
    on<MakeLoginBOEvent>(_makeBOLogin);
    on<SaveUserAllowedList>(_saveUserAllowedList);
  }

  FutureOr<void> _makeLogin(
      MakeLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    LoginUseCase loginUseCase = instance<LoginUseCase>();
    UserDevice userDevice = await setUserDevice();
    (await loginUseCase.execute(
      LoginUseCaseInput(
        event.login,
        userDevice.toJson(),
      ),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(LoginFailState(failure.message, failure.code.toString()))
                }, (driverModel) async {
      // right -> data (success)
      // content
      // emit success state
      setCountryCodeToCache(event.countryCode);
      if (driverModel.blocked != null && driverModel.blocked!) {
        emit(LoginFailState(AppStrings.blockedUserErrorMessage.tr(), ""));
      } else if (driverModel.disabled != null &&
          driverModel.disabled! == false) {
        emit(LoginSuccessButDisabled(driver: driverModel));
      } else {
        emit(LoginSuccessState(driver: driverModel));
      }
    });
  }

  FutureOr<void> _makeBOLogin(
      MakeLoginBOEvent event, Emitter<LoginState> emit) async {
    LoginBOUseCase loginBOUseCase = instance<LoginBOUseCase>();
    emit(LoginLoadingState());
    UserDevice userDevice = await setUserDevice();
    (await loginBOUseCase.execute(
      LoginBOUseCaseInput(
        event.login,
        userDevice.toJson(),
      ),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(LoginFailState(failure.message, failure.code.toString()))
                }, (driverModel) async {
      // right -> data (success)
      // content
      // emit success state
      setCountryCodeToCache(event.countryCode);
      if (driverModel.blocked != null && driverModel.blocked!) {
        emit(LoginFailState(AppStrings.blockedUserErrorMessage.tr(), ""));
      } else if (driverModel.disabled != null &&
          driverModel.disabled! == false) {
        emit(LoginSuccessButDisabled(driver: driverModel));
      } else {
        emit(LoginSuccessState(driver: driverModel));
      }
    });
  }

  FutureOr<void> _saveUserAllowedList(
      SaveUserAllowedList event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    AllowedServicesUseCase allowedServicesUseCase =
        instance<AllowedServicesUseCase>();
    (await allowedServicesUseCase.execute(
            AllowedServicesUseCaseInput(await appPreferences.getUserType()!)))
        .fold((failure) {
      emit(LoginFailState(failure.message, failure.code.toString()));
    }, (allowedList) {
      handleUserCurrentServiceList(allowedList);
      emit(LoginSuccessState(driver: event.driverBaseModel));
    });
  }

  FutureOr<void> _checkInputStatus(
      CheckInputIsValidEvent event, Emitter<LoginState> emit) async {
    // Saudi Arabia mobile numbers are exactly 9 digits after country code
    // Country code +966 is already included, so we check for 9 digits in the input
    int inputLength = event.input.length;

    developer.log(
        '📱 Validation Check - Input length: $inputLength, Input: ${event.input}');

    // Validate: Saudi mobile numbers are exactly 9 digits
    if (inputLength == 9) {
      developer.log('✅ Phone number is valid (9 digits)');
      emit(LoginIsAllInputValid());
    } else {
      developer.log(
          '❌ Phone number is invalid (Expected: 9 digits, Got: $inputLength)');
      emit(LoginIsAllInputNotValid());
    }
  }

  Future<UserDevice> setUserDevice() async {
    late UserDevice userDevice;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String token = await appPreferences.getFCMToken() ?? '1';

    if (Platform.isIOS) {
      userDevice = UserDevice(
        deviceOs: 'iPhone',
        appVersion: packageInfo.version,
        registrationId: token,
      );
    } else {
      userDevice = UserDevice(
        deviceOs: 'Android',
        appVersion: packageInfo.version,
        registrationId: token,
      );
    }

    return userDevice;
  }

  void setCountryCodeToCache(String countryCode) async {
    appPreferences.setUserSelectedCountry(countryCode);
  }

  Future<void> setUserAllowedList(List<AllowedServiceModel> serviceList) async {
    await appPreferences.saveAllowedServicesList(serviceList);
  }

  handleUserCurrentServiceList(List<AllowedServiceModel> servicesList) async {
    await appPreferences.saveAllowedServicesList(servicesList);
  }

  Future<DriverBaseModel> setUserInfoAndModelToCache(
      DriverBaseModel driverFromState, String registerAs) async {
    await appPreferences.setUserLoggedIn();
    DriverBaseModel cachedDriver = driverFromState;
    if (registerAs == RegistrationConstants.captain) {
      cachedDriver.captainType = RegistrationConstants.captain;
    } else {
      cachedDriver.captainType = RegistrationConstants.businessOwner;
    }
    await appPreferences.setDriver(cachedDriver);
    DriverBaseModel? driver = appPreferences.getCachedDriver();
    return driver!;
  }
}
