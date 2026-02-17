import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_checkbox.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/resources/strings_manager.dart';

class CustomCheckboxDateTimeNow extends StatefulWidget {
  final bool isChecked;
  final Function(String? date) onSelectDate;
  final Function(bool checked) onCheckedChanged;
  const CustomCheckboxDateTimeNow({
    Key? key,
    required this.isChecked,
    required this.onSelectDate,
    required this.onCheckedChanged,
  }) : super(key: key);

  @override
  State<CustomCheckboxDateTimeNow> createState() =>
      _CustomCheckboxDateTimeNowState();
}

class _CustomCheckboxDateTimeNowState extends State<CustomCheckboxDateTimeNow> {
  String dateFormatterString = 'dd MMM, yyyy hh:mm a';
  final _appPrefs = instance<AppPreferences>();
  final dateNow = DateTime.now();
  final timeNow = TimeOfDay.now();
  late DateTime dateTime;

  @override
  void initState() {
    dateTime = DateTime(
      dateNow.year,
      dateNow.month,
      dateNow.day,
      timeNow.hour,
      timeNow.minute,
    );
    super.initState();
  }

  String convertDate() {
    String dateFormatted =
        DateFormat(dateFormatterString, _appPrefs.getAppLanguage())
            .format(dateTime);
    widget.onSelectDate(dateFormatted);
    return DateFormat(dateFormatterString, _appPrefs.getAppLanguage())
        .format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCheckBox(
      checked: widget.isChecked,
      fieldName: AppStrings.now.tr(),
      onChange: (checked) {
        if (checked) {
          widget.onSelectDate(convertDate());
        } else {
          widget.onSelectDate(null);
        }
        widget.onCheckedChanged(checked);
      },
    );
  }
}
