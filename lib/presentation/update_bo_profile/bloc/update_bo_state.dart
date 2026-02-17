part of 'update_bo_bloc.dart';

@immutable
abstract class UpdateBoState {}

class UpdateBoInitial extends UpdateBoState {}

class UpdateBoLoading extends UpdateBoState {}

class BoOptimizedImagesSuccessState extends UpdateBoState {
  List<String> entityImagesUrls;

  BoOptimizedImagesSuccessState({required this.entityImagesUrls});
}

class UpdateBoSuccess extends UpdateBoState {}

class UpdateBoFail extends UpdateBoState {
  final String message;
  final String errorCode;

  UpdateBoFail(this.message, this.errorCode);
}
