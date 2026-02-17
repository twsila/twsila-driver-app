import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/goods_service_type_model.dart';

import '../../data/network/failure.dart';
import '../model/lookups_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class GoodsServiceTypesUseCase
    implements
        BaseUseCase<GoodsServiceTypesUseCaseInput,
            List<GoodsServiceTypeModel>> {
  final Repository _repository;

  GoodsServiceTypesUseCase(this._repository);

  @override
  Future<Either<Failure, List<GoodsServiceTypeModel>>> execute(
      GoodsServiceTypesUseCaseInput input) async {
    return await _repository.getGoodsServiceTypes();
  }
}

class GoodsServiceTypesUseCaseInput {}
