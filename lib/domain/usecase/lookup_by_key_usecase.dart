import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/response/responses.dart';

import '../../data/network/failure.dart';
import '../model/lookupValueModel.dart';
import '../model/lookups_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class LookupByKeyUseCase implements BaseUseCase<LookupByKeyUseCaseInput, List<LookupValueModel>> {
  final Repository _repository;

  LookupByKeyUseCase(this._repository);

  @override
  Future<Either<Failure, List<LookupValueModel>>> execute(
      LookupByKeyUseCaseInput input) async {
    return await _repository.getLookupByKey(input.key,input.lang);
  }
}

class LookupByKeyUseCaseInput {
  String key;
  String lang;

  LookupByKeyUseCaseInput(this.key,this.lang);
}
