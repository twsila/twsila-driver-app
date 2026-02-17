import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/coast_calculation_model.dart';

import '../../data/network/failure.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class CoastCalculationUseCase
    implements BaseUseCase<String, CoastCalculationModel> {
  final Repository _repository;

  CoastCalculationUseCase(this._repository);

  @override
  Future<Either<Failure, CoastCalculationModel>> execute(String input) async {
    return await _repository.getCostCalculationValues();
  }
}
