import 'package:dartz/dartz.dart';

import 'package:taxi_for_you/data/network/failure.dart';
import 'package:taxi_for_you/data/network/requests.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/verify_otp_model.dart';

import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class VerifyOtpUseCase
    implements BaseUseCase<VerifyOtpUseCaseInput, BaseResponse> {
  final Repository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(VerifyOtpUseCaseInput input) {
    return _repository.verifyOtp(VerifyOTPRequest(input.code, input.mobileNumber,input.generatedOtp));
  }

}

class VerifyOtpUseCaseInput {
  String mobileNumber;
  String code;
  String generatedOtp;

  VerifyOtpUseCaseInput(this.mobileNumber,this.code,this.generatedOtp);
}
