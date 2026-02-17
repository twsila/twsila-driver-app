import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';

import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/styles_manager.dart';

class CustomCheckBox extends StatefulWidget {
  bool _checked = false;
  String _fieldName;
  Function(bool) _onChange;

  CustomCheckBox(
      {required bool checked,
      required String fieldName,
      required Function(bool) onChange})
      : _checked = checked,
        _fieldName = fieldName,
        _onChange = onChange;

  @override
  CustomCheckBoxState createState() => CustomCheckBoxState();
}

class CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            checkColor: Colors.white,
            focusColor: ColorManager.secondaryColor,
            activeColor: ColorManager.secondaryColor,
            hoverColor: ColorManager.primary,
            value: widget._checked,
            onChanged: (newValue) {
              setState(() {
                widget._checked = newValue ?? false;
                widget._onChange(newValue ?? false);
              });
            }),
        Expanded(
          child: Text(
            widget._fieldName,
            style: getRegularStyle(
                color: ColorManager.headersTextColor, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
