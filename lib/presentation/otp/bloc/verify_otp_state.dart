part of 'verify_otp_bloc.dart';

@immutable
abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class GenerateOtpSuccess extends VerifyOtpState {
  String otp;

  GenerateOtpSuccess(this.otp);
}

class GenerateOtpFail extends VerifyOtpState {
  final String message;
  final String code;

  GenerateOtpFail(this.message, this.code);
}

class VerifyOtpSuccess extends VerifyOtpState {}

class gettingCoastCalculationsSuccess extends VerifyOtpState {
  CoastCalculationModel calculationModel;

  gettingCoastCalculationsSuccess({required this.calculationModel});
}

class VerifyOtpFail extends VerifyOtpState {
  final String message;
  final String code;

  VerifyOtpFail(this.message, this.code);
}
