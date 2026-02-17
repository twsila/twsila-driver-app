import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import 'CustomShowPIN.dart';

class CustomVerificationCodeWidget extends StatefulWidget {
  final TextEditingController controller;
  final int otpLength;
  final bool autoFocus;
  final bool _onEditing = true;
  final Function(String) onCodeChanged;
  final Function(String) onCodeSubmitted;

  CustomVerificationCodeWidget({
    Key? key,
    required this.controller,
    required this.onCodeSubmitted,
    required this.onCodeChanged,
    this.autoFocus = true,
    this.otpLength = 6,
  }) : super(key: key);

  @override
  State<CustomVerificationCodeWidget> createState() =>
      _CustomVerificationCodeWidgetState();
}

class _CustomVerificationCodeWidgetState
    extends State<CustomVerificationCodeWidget> with CodeAutoFill {
  String codeValue = '';
  bool _onEditing = true;
  bool _isHidden = true;
  String? appSignature;

  @override
  void codeUpdated() {
    setState(() {
      codeValue = code!;
    });
  }

  @override
  void initState() {
    // listenOtp();
    super.initState();
    // SmsAutoFill().getAppSignature.then((signature) {
    //   setState(() {
    //     appSignature = signature;
    //   });
    // });
  }

  @override
  void dispose() {
    // SmsAutoFill().unregisterListener();
    super.dispose();
    // cancel();
  }

  void listenOtp() async {
    await SmsAutoFill().unregisterListener();
    listenForCode();
    SmsAutoFill().listenForCode;
  }

  @override
  Widget build(BuildContext context) {
    // return
    // Column(
    // children: [
    return Container(
      width: double.infinity,
      height: 100,
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: PinCodeTextField(
          appContext: context,
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          textStyle: Theme.of(context).textTheme.displayLarge,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            activeColor: ColorManager.primary,
            inactiveFillColor: ColorManager.white,
            inactiveColor: ColorManager.primary,
            selectedFillColor: ColorManager.primaryBlueBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 50,
            activeFillColor: Colors.white,
          ),
          animationDuration: Duration(milliseconds: 300),
          enableActiveFill: true,
          controller: widget.controller,
          onCompleted: (code) {
            widget.onCodeSubmitted(code);
          },
          onChanged: (value) {},
          beforeTextPaste: (text) {
            return true;
          },
        ),
      ),
    );
    // PinFieldAutoFill(
    //   decoration: BoxLooseDecoration(
    //     bgColorBuilder: FixedColorBuilder(ColorManager.white),
    //     obscureStyle: ObscureStyle(
    //       isTextObscure: false,
    //       obscureText: '⬤',
    //     ),
    //     textStyle: Theme.of(context).textTheme.labelLarge,
    //     strokeColorBuilder: FixedColorBuilder(ColorManager.borderColor),
    //     radius: const Radius.circular(5),
    //     strokeWidth: 2,
    //     gapSpace: 5,
    //   ),
    //   autoFocus: widget.autoFocus,
    //   currentCode: codeValue,
    //   enableInteractiveSelection: false,
    //   controller: widget.controller,
    //   codeLength: widget.otpLength,
    //   onCodeSubmitted: (code) {
    //     widget.onCodeSubmitted(code);
    //   },
    //   onCodeChanged: (code) {
    //     setState(() {
    //       codeValue = code.toString();
    //       widget.onCodeChanged(codeValue);
    //     });
    //   },
    // ),
    // ,
    // const SizedBox(height: 24)
    // ,
    // CustomShowPinButton(onChanged: (isHidden) {
    //   setState(() {
    //     _isHidden = isHidden;
    //   });
    // })
    //   ],
    // );
  }
}
