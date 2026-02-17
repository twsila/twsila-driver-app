import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/response/responses.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class BoSuggestNewOfferUseCase
    implements BaseUseCase<BoSuggestNewOfferUseCaseInput, BaseResponse> {
  final Repository _repository;

  BoSuggestNewOfferUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      BoSuggestNewOfferUseCaseInput input) async {
    return await _repository.boSuggestNewOffer(
        input.businessOwnerId, input.tripId, input.newSuggestedOffer,input.driverId);
  }
}

class BoSuggestNewOfferUseCaseInput {
  int businessOwnerId;
  int tripId;
  double newSuggestedOffer;
  int driverId;

  BoSuggestNewOfferUseCaseInput(
      this.businessOwnerId, this.tripId, this.newSuggestedOffer,this.driverId);
}
