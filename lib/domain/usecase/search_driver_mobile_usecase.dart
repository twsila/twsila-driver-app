import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/response/responses.dart';

import '../../data/network/failure.dart';
import '../model/driver_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class SearchDriversByMobileUseCase
    implements BaseUseCase<SearchDriversByMobileUseCaseInput, List<Driver>> {
  final Repository _repository;

  SearchDriversByMobileUseCase(this._repository);

  @override
  Future<Either<Failure, List<Driver>>> execute(
      SearchDriversByMobileUseCaseInput input) async {
    return await _repository.searchDriversByMobile(input.mobileNumber);
  }
}

class SearchDriversByMobileUseCaseInput {
  int mobileNumber;

  SearchDriversByMobileUseCaseInput(this.mobileNumber);
}
