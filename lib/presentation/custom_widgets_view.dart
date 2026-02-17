import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../utils/resources/color_manager.dart';
import 'common/widgets/CustomAutoFullSms.dart';
import 'login/view/widgets/phone_view.dart';

class CustomWidgetsView extends StatefulWidget {
  const CustomWidgetsView({Key? key}) : super(key: key);

  @override
  State<CustomWidgetsView> createState() => _CustomWidgetsViewState();
}

class _CustomWidgetsViewState extends State<CustomWidgetsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 38.0),
          child: Column(
            children: [
              CustomTextButton(
                text: 'متابعة',
                icon: Icon(
                  Icons.arrow_forward,
                  color: ColorManager.white,
                ),
                onPressed: () {},
              ),
              // CustomVerificationCodeWidget(onComplete: (otp) {}, controller: null,),
              CustomTextInputField(
                showLabelText: true,
                istitleBold: false,
                labelText: "اسم مالك الشركة",
                hintText: "ادخل اسم الشركة هنا",
              )
            ],
          ),
        ));
  }
}
