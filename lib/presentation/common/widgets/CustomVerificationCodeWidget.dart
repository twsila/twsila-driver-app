import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';

class CustomVerificationCode extends StatefulWidget {
  Function(String) onComplete;
  Function(String) onChanged;
  Function(String)? validator;
  TextEditingController plateNumberController;

  CustomVerificationCode(
      {Key? key,
      required this.onComplete,
      required this.onChanged,
      required this.plateNumberController,
      this.validator})
      : super(key: key);

  @override
  State<CustomVerificationCode> createState() => _CustomVerificationCodeState();
}

class _CustomVerificationCodeState extends State<CustomVerificationCode> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: AppSize.s55,
      height: AppSize.s60,
      margin: const EdgeInsets.all(2),
      textStyle: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontSize: FontSize.s16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorManager.borderColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: ColorManager.borderColor),
      ),
    );
    return Pinput(
      controller: widget.plateNumberController,
      length: 6,
      keyboardType: TextInputType.name,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      showCursor: true,
      onChanged: (value) {
        widget.onChanged(value);
      },
      validator: (value) {
        widget.validator != null ? widget.validator!(value!) : null;
      },
      onCompleted: (value) {
        widget.onComplete(value);
      },
    );
  }
}
