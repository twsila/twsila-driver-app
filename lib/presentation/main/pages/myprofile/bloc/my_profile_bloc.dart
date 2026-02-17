import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/usecase/logout_usecase.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/di.dart';
import '../../../../../utils/resources/constants_manager.dart';

part 'my_profile_event.dart';

part 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  MyProfileBloc() : super(MyProfileInitial()) {
    on<logoutEvent>(_makeLogout);
    on<deleteAccountEvent>(_makeDeleteAccount);
  }

  FutureOr<void> _makeLogout(
      logoutEvent event, Emitter<MyProfileState> emit) async {
    emit(MyProfileLoading());
    LogoutUseCase logoutUseCase = instance<LogoutUseCase>();
    BoLogoutUseCase boLogoutUseCase = instance<BoLogoutUseCase>();
    
    // Try to logout on backend, but always logout locally regardless of result
    // This ensures logout always succeeds even if backend call fails
    if (_appPreferences.getCachedDriver()!.captainType ==
        RegistrationConstants.captain) {
      (await logoutUseCase.execute(LogoutUseCaseInput(
              _appPreferences.getCachedDriver()!.refreshToken!)))
          .fold(
              (failure) async {
                    // left -> failure
                    // Even if backend logout fails (e.g., token not found, expired, etc.),
                    // we should still log out locally to ensure user can always logout
                    _appPreferences.removeCachedDriver();
                    _appPreferences.setUserLoggedOut(event.context);
                    emit(LoggedOutSuccessfully());
                  }, (logoutModel) async {
        // right -> data (success)
        _appPreferences.removeCachedDriver();
        _appPreferences.setUserLoggedOut(event.context);
        emit(LoggedOutSuccessfully());
      });
    } else {
      (await boLogoutUseCase.execute(BoLogoutUseCaseInput(
              _appPreferences.getCachedDriver()!.refreshToken!)))
          .fold(
              (failure) async {
                    // left -> failure
                    // Even if backend logout fails (e.g., token not found, expired, etc.),
                    // we should still log out locally to ensure user can always logout
                    _appPreferences.removeCachedDriver();
                    _appPreferences.setUserLoggedOut(event.context);
                    emit(LoggedOutSuccessfully());
                  }, (logoutModel) async {
        // right -> data (success)
        _appPreferences.removeCachedDriver();
        _appPreferences.setUserLoggedOut(event.context);
        emit(LoggedOutSuccessfully());
      });
    }
  }

  FutureOr<void> _makeDeleteAccount(
      deleteAccountEvent event, Emitter<MyProfileState> emit) async {
    emit(MyProfileLoading());
    
    // Fake API call - wait 4 seconds
    await Future.delayed(Duration(seconds: 4));
    
    // After fake API call, perform logout
    LogoutUseCase logoutUseCase = instance<LogoutUseCase>();
    BoLogoutUseCase boLogoutUseCase = instance<BoLogoutUseCase>();
    
    // Try to logout on backend, but always logout locally regardless of result
    // This ensures logout always succeeds even if backend call fails
    if (_appPreferences.getCachedDriver()!.captainType ==
        RegistrationConstants.captain) {
      (await logoutUseCase.execute(LogoutUseCaseInput(
              _appPreferences.getCachedDriver()!.refreshToken!)))
          .fold(
              (failure) async {
                    // left -> failure
                    // Even if backend logout fails (e.g., token not found, expired, etc.),
                    // we should still log out locally to ensure user can always logout
                    _appPreferences.removeCachedDriver();
                    _appPreferences.setUserLoggedOut(event.context);
                    emit(LoggedOutSuccessfully());
                  }, (logoutModel) async {
        // right -> data (success)
        _appPreferences.removeCachedDriver();
        _appPreferences.setUserLoggedOut(event.context);
        emit(LoggedOutSuccessfully());
      });
    } else {
      (await boLogoutUseCase.execute(BoLogoutUseCaseInput(
              _appPreferences.getCachedDriver()!.refreshToken!)))
          .fold(
              (failure) async {
                    // left -> failure
                    // Even if backend logout fails (e.g., token not found, expired, etc.),
                    // we should still log out locally to ensure user can always logout
                    _appPreferences.removeCachedDriver();
                    _appPreferences.setUserLoggedOut(event.context);
                    emit(LoggedOutSuccessfully());
                  }, (logoutModel) async {
        // right -> data (success)
        _appPreferences.removeCachedDriver();
        _appPreferences.setUserLoggedOut(event.context);
        emit(LoggedOutSuccessfully());
      });
    }
  }
}
