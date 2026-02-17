import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/country_lookup_model.dart';

import '../../data/network/failure.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class CountriesLookupUseCase
    implements BaseUseCase<LookupsUseCaseInput, List<CountryLookupModel>> {
  final Repository _repository;

  CountriesLookupUseCase(this._repository);

  @override
  Future<Either<Failure, List<CountryLookupModel>>> execute(LookupsUseCaseInput input) async {
    return await _repository.getCountriesLookup();
  }
}

class LookupsUseCaseInput {}
