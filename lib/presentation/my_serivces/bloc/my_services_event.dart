part of 'my_services_bloc.dart';

@immutable
abstract class MyServicesEvent {}

class GetServiceStatus extends MyServicesEvent {
  GetServiceStatus();
}
