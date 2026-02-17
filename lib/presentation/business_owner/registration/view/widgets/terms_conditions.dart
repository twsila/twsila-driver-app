import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_checkbox.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

class TermsAndConditionsWidget extends StatefulWidget {
  final Function(bool) onChecked;
  const TermsAndConditionsWidget({Key? key, required this.onChecked})
      : super(key: key);

  @override
  State<TermsAndConditionsWidget> createState() =>
      _TermsAndConditionsWidgetState();
}

class _TermsAndConditionsWidgetState extends State<TermsAndConditionsWidget> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return CustomCheckBox(
        checked: checked,
        fieldName: AppStrings.termsAndCondition.tr(),
        onChange: (check) {
          setState(() {
            checked = check;
            widget.onChecked(check);
          });
        });
  }
}
