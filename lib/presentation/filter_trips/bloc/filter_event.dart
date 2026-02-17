part of 'filter_bloc.dart';

@immutable
abstract class FilterEvent {}

class getServiceLookup extends FilterEvent {
  final String key;

  getServiceLookup(this.key);
}
