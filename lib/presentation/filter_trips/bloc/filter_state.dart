part of 'filter_bloc.dart';

@immutable
abstract class FilterState {}

class FilterInitial extends FilterState {}

class FilterLoading extends FilterState {}

class ServiceLookupSuccess extends FilterState {
  final List<LookupValueModel> services;

  ServiceLookupSuccess(this.services);
}

class FilterFailure extends FilterState {
  final String message;
  final String code;

  FilterFailure(this.message, this.code);
}
