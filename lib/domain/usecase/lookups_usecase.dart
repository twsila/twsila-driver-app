import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/logout_model.dart';
import 'package:taxi_for_you/domain/model/lookups_model.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/driver_model.dart';
import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class LookupsUseCase implements BaseUseCase<LookupsUseCaseInput, LookupsModel> {
  final Repository _repository;

  LookupsUseCase(this._repository);

  @override
  Future<Either<Failure, LookupsModel>> execute(
      LookupsUseCaseInput input) async {
    return await _repository.getLookups();
  }
}

class LookupsUseCaseInput {}
