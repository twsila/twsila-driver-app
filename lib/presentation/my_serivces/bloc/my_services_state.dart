part of 'my_services_bloc.dart';

@immutable
abstract class MyServicesState {}

class MyServicesInitial extends MyServicesState {}

class ServiceStatusLoading extends MyServicesState {}

class ServiceStatusSuccess extends MyServicesState {
  final String status;

  ServiceStatusSuccess(this.status);
}

class ServiceStatusFail extends MyServicesState {
  final String message;
  final String code;

  ServiceStatusFail(this.message, this.code);
}
