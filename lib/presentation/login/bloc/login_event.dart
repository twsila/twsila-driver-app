part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class MakeLoginEvent extends LoginEvent {
  final String login;
  final String countryCode;

  MakeLoginEvent(this.login, this.countryCode);
}

class SaveUserAllowedList extends LoginEvent {
  DriverBaseModel driverBaseModel;

  SaveUserAllowedList(this.driverBaseModel);
}

class MakeLoginBOEvent extends LoginEvent {
  final String countryCode;
  final String login;

  MakeLoginBOEvent(this.login, this.countryCode);
}

class CheckInputIsValidEvent extends LoginEvent {
  final String input;

  CheckInputIsValidEvent(this.input);
}
