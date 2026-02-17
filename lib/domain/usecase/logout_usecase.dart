import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/logout_model.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/driver_model.dart';
import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class LogoutUseCase implements BaseUseCase<LogoutUseCaseInput, LogoutModel> {
  final Repository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, LogoutModel>> execute(LogoutUseCaseInput input) async {
    return await _repository.logout(
        LogoutRequest(input.refreshToken));
  }
}

class LogoutUseCaseInput {
  String refreshToken;

  LogoutUseCaseInput(this.refreshToken);
}class BoLogoutUseCase implements BaseUseCase<BoLogoutUseCaseInput, LogoutModel> {
  final Repository _repository;

  BoLogoutUseCase(this._repository);

  @override
  Future<Either<Failure, LogoutModel>> execute(BoLogoutUseCaseInput input) async {
    return await _repository.boLogout(
        LogoutRequest(input.refreshToken));
  }
}

class BoLogoutUseCaseInput {
  String refreshToken;

  BoLogoutUseCaseInput(this.refreshToken);
}
