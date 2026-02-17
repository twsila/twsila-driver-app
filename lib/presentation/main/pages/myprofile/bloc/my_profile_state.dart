part of 'my_profile_bloc.dart';

@immutable
abstract class MyProfileState {}

class MyProfileInitial extends MyProfileState {}

class MyProfileLoading extends MyProfileState {}

class LoggedOutSuccessfully extends MyProfileState {}

class MyProfileFail extends MyProfileState {
  final String errorMessage;

  MyProfileFail(this.errorMessage);
}
