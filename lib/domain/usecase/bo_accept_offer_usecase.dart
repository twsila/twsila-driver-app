import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/response/responses.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class BOAcceptOfferUseCase
    implements BaseUseCase<BOAcceptOfferUseCaseInput, BaseResponse> {
  final Repository _repository;

  BOAcceptOfferUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      BOAcceptOfferUseCaseInput input) async {
    return await _repository.boAcceptOffer(input.businessOwnerId, input.tripId,input.driverId);
  }
}

class BOAcceptOfferUseCaseInput {
  int businessOwnerId;
  int tripId;
  int driverId;

  BOAcceptOfferUseCaseInput(this.businessOwnerId, this.tripId,this.driverId);
}
