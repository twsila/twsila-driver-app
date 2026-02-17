import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/driver_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Driver> {
  final Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Driver>> execute(LoginUseCaseInput input) async {
    return await _repository.login(
        LoginRequest(input.login, input.mobileUserDeviceDTO));
  }
}

class LoginUseCaseInput {
  String login;
  Map<String, dynamic> mobileUserDeviceDTO;

  LoginUseCaseInput(this.login, this.mobileUserDeviceDTO);
}

class LoginBOUseCase
    implements BaseUseCase<LoginBOUseCaseInput, BusinessOwnerModel> {
  final Repository _repository;

  LoginBOUseCase(this._repository);

  @override
  Future<Either<Failure, BusinessOwnerModel>> execute(
      LoginBOUseCaseInput input) async {
    return await _repository.loginBO(
        LoginRequest(input.login, input.mobileUserDeviceDTO));
  }
}

class LoginBOUseCaseInput {
  String login;
  Map<String, dynamic> mobileUserDeviceDTO;

  LoginBOUseCaseInput(this.login, this.mobileUserDeviceDTO);
}
