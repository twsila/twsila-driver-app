import 'package:equatable/equatable.dart';

class MapsEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetCurrentLocation extends MapsEvents {}

class GetUserConfigAndPagesForUser extends MapsEvents {
  GetUserConfigAndPagesForUser();
}
