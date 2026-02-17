import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../model/location_model.dart';

class MapsState extends Equatable {
  @override
  List<Object> get props => [];
}

class CurrentLocationIsNotLoading extends MapsState {}

class CurrentLocationIsLoading extends MapsState {}
class CurrentUserConfigAndPagesSuccess extends MapsState {
  int currentIndex;
  List<int> activePageIndex;

  CurrentUserConfigAndPagesSuccess(this.currentIndex, this.activePageIndex);
}

class CurrentLocationLoadedSuccessfully extends MapsState {
  final LocationModel currentLocation;

  CurrentLocationLoadedSuccessfully({required this.currentLocation});

  @override
  List<Object> get props => [currentLocation];
}

class CurrentLocationFailed extends MapsState {
  final String errorMessage;

  CurrentLocationFailed({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [];
}
