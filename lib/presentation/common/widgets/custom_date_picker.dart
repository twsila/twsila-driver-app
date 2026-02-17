import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/styles_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

class CustomDatePickerWidget extends StatefulWidget {
  final Function(String date) onSelectDate;
  final bool pickTime;
  final String? labelText;
  final bool? isDimmed;
  final String dateFormatterString;
  final Locale? locale;
  DateTime? initialDate;
  DateTime? firstDate;
  DateTime? lastDate;

  CustomDatePickerWidget(
      {Key? key,
      required this.onSelectDate,
      required this.pickTime,
      this.isDimmed = false,
      this.dateFormatterString = 'dd MMM, yyyy',
      this.locale,
      this.labelText,
      this.firstDate,
      this.lastDate,
      this.initialDate})
      : super(key: key);

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  final _appPrefs = instance<AppPreferences>();
  final ValueNotifier<DateTime?> dateSub = ValueNotifier(null);

  Widget buildDateTimePicker(String data) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Text(
            widget.labelText ?? AppStrings.scheduleAppoinment.tr(),
            style: getMediumStyle(
                color: ColorManager.titlesTextColor, fontSize: AppSize.s14),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          flex: 3,
          child: ListTile(
            enabled: widget.isDimmed! ? false : true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: ColorManager.lightPrimary, width: 1.5),
            ),
            title: Text(
              data != '' ? data : AppStrings.selectDate.tr(),
              textAlign: TextAlign.start,
            ),
            leading: Icon(
              Icons.calendar_today,
              color: ColorManager.titlesTextColor,
            ),
          ),
        ),
      ],
    );
  }

  String convertDate(DateTime dateTime) {
    if (dateTime == null) return '';
    DateTime dateFormatted =
        widget.pickTime ? dateTime : DateUtils.dateOnly(dateTime);
    String timestamp = dateFormatted.millisecondsSinceEpoch.toString();

    widget.onSelectDate(timestamp);
    String date = timestamp.getTimeStampFromDate(
        pattern: widget.pickTime ? 'dd MMM yyyy/ hh:mm a' : 'dd MMM yyyy');
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: ValueListenableBuilder<DateTime?>(
            valueListenable: dateSub,
            builder: (context, dateVal, child) {
              return InkWell(
                  onTap: widget.isDimmed!
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          DateTime? date = await showDatePicker(
                              locale: widget.locale != null
                                  ? widget.locale
                                  : _appPrefs.getAppLanguage() ==
                                          LanguageType.ENGLISH.getValue()
                                      ? ENGLISH_LOCAL
                                      : ARABIC_LOCAL,
                              context: context,
                              initialDate: widget.initialDate != null
                                  ? widget.initialDate!
                                  : DateTime.now(),
                              firstDate: widget.firstDate != null
                                  ? widget.firstDate!
                                  : widget.initialDate != null
                                      ? widget.initialDate!
                                      : DateTime.now(),
                              lastDate: widget.lastDate != null
                                  ? widget.lastDate!
                                  : DateTime(2050),
                              currentDate: DateTime.now(),
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialDatePickerMode: DatePickerMode.day,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.fromSwatch(
                                    primarySwatch: Colors.green,
                                    accentColor: ColorManager.lightGrey,
                                    backgroundColor: Colors.blue,
                                    cardColor: Colors.white,
                                  )),
                                  child: child!,
                                );
                              });
                          if (widget.pickTime) {
                            final timeValue = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.fromSwatch(
                                      primarySwatch: Colors.green,
                                      accentColor: ColorManager.lightGrey,
                                      backgroundColor: Colors.lightBlue,
                                      cardColor: Colors.white,
                                    )),
                                    child: child!,
                                  );
                                });
                            var dateTime = DateTime(
                              date!.year,
                              date.month,
                              date.day,
                              timeValue!.hour,
                              timeValue.minute,
                            );
                            dateSub.value = dateTime;
                          } else {
                            var dateTime = DateTime(
                              date!.year,
                              date.month,
                              date.day,
                              DateTime.now().hour,
                              DateTime.now().minute,
                            );
                            dateSub.value = dateTime;
                          }
                        },
                  child: buildDateTimePicker(
                      dateVal != null ? convertDate(dateVal) : ''));
            }));
  }
}
