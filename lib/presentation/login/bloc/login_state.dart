part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final DriverBaseModel driver;

  LoginSuccessState({required this.driver});
}

class LoginSuccessButDisabled extends LoginState {
  final DriverBaseModel driver;

  LoginSuccessButDisabled({required this.driver});
}

class LoginFailState extends LoginState {
  final String message;
  final String errorCode;

  LoginFailState(this.message, this.errorCode);
}

class LoginIsAllInputValid extends LoginState {}

class LoginIsAllInputNotValid extends LoginState {}
