import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_date_picker.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';

import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_bottom_sheet.dart';
import '../../../common/widgets/custom_text_button.dart';

class FromToDateWidget extends StatefulWidget {
  final Function(String? fromDate, String? toDate, bool todayDate) onSelectDate;

  FromToDateWidget({required this.onSelectDate});

  @override
  State<FromToDateWidget> createState() => _FromToDateWidgetState();
}

class _FromToDateWidgetState extends State<FromToDateWidget> {
  bool isRangeOrDateSelected = true;
  bool todayDate = false;
  String? dateFromPicker;
  String? dateToPicker;
  String? selectedFromDate;
  String? selectedToDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.headersTextColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: selectedFromDate == null && selectedToDate == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.tripDate.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: FontSize.s16),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: CustomTextButton(
                    onPressed: () => _showSelectDateDialog(),
                    text: AppStrings.selectFromHereHint.tr(),
                    isWaitToEnable: false,
                    backgroundColor: ColorManager.splashBGColor,
                    textColor: Colors.white,
                    height: 48,
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: () => _showSelectDateDialog(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tripDate.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorManager.headersTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: FontSize.s16),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorManager.splashBGColor.withOpacity(0.08),
                      border: Border.all(
                        color: ColorManager.splashBGColor.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      selectedFromDate != null && selectedToDate != null
                          ? '${AppStrings.from.tr()} ${selectedFromDate?.getTimeStampFromDate(pattern: 'dd MMM yyyy')} – ${AppStrings.to.tr()} ${selectedToDate?.getTimeStampFromDate(pattern: 'dd MMM yyyy')}'
                          : selectedFromDate != null && selectedToDate == null
                              ? '${AppStrings.from.tr()} ${selectedFromDate?.getTimeStampFromDate(pattern: 'dd MMM yyyy')}'
                              : selectedFromDate == null && selectedToDate != null
                                  ? '${AppStrings.to.tr()} ${selectedToDate?.getTimeStampFromDate(pattern: 'dd MMM yyyy')}'
                                  : '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorManager.splashBGColor,
                            fontWeight: FontWeight.w600,
                            fontSize: FontSize.s14),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _dialogContentWidget(StateSetter setState) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            CustomDatePickerWidget(
              locale: ENGLISH_LOCAL,
              onSelectDate: (date) {
                selectedFromDate = date;
                dateFromPicker = selectedFromDate;
              },
              isDimmed: todayDate,
              pickTime: false,
              labelText: AppStrings.from.tr(),
              lastDate: DateTime(DateTime.now().year + 5),
              firstDate: DateTime(DateTime.now().year - 5),
              initialDate: DateTime.now(),
            ),
            CustomDatePickerWidget(
              locale: ENGLISH_LOCAL,
              onSelectDate: (date) {
                selectedToDate = date;
                dateToPicker = selectedToDate;
              },
              isDimmed: todayDate,
              pickTime: false,
              labelText: AppStrings.to.tr(),
              lastDate: DateTime(DateTime.now().year + 5),
              firstDate: DateTime(DateTime.now().year - 5),
              initialDate: DateTime.now(),
            ),
            Row(
              children: [
                Checkbox(
                    side: BorderSide(
                        color: ColorManager.secondaryColor,
                        width: AppSize.s1_5),
                    activeColor: ColorManager.secondaryColor,
                    focusColor: ColorManager.primary,
                    checkColor: ColorManager.white,
                    value: todayDate,
                    onChanged: (value) {
                      setState(() {
                        todayDate = value!;
                        if (todayDate) {
                          selectedFromDate = getDateOfNow(false);
                          selectedToDate = getDateOfNow(true);
                          debugPrint('[FromToDate] Using today: from $selectedFromDate to $selectedToDate');
                        } else if ((dateFromPicker != null &&
                                dateFromPicker!.isNotEmpty) &&
                            dateToPicker != null &&
                            dateToPicker!.isNotEmpty) {
                          selectedFromDate = dateFromPicker;
                          selectedToDate = dateToPicker;
                          debugPrint('[FromToDate] Selected range: $selectedFromDate - $selectedToDate');
                        }
                      });
                    }),
                Text(
                  AppStrings.todayDate.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorManager.titlesTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s16),
                ),
              ],
            ),
            CustomTextButton(
              text: AppStrings.confirm.tr(),
              isWaitToEnable: false,
              backgroundColor: ColorManager.secondaryColor,
              textColor: ColorManager.white,
              onPressed: () {
                if (selectedFromDate != null && selectedFromDate!.isNotEmpty ||
                    selectedToDate != null && selectedToDate!.isNotEmpty) {
                  widget.onSelectDate(
                      selectedFromDate, selectedToDate, todayDate);
                  Navigator.pop(context);
                } else {
                  ToastHandler(context).showToast(
                      AppStrings.selectDate.tr(), Toast.LENGTH_SHORT);
                }
              },
            ),
            CustomTextButton(
              text: AppStrings.back.tr(),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void _showSelectDateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return _dialogContentWidget(setState);
            },
          ),
        );
      },
    ).then((value) => (setState(() {})));
  }

  String getDateOfNow(bool isLastOfDay) {
    var now = new DateTime.now();
    var twelve;
    if (isLastOfDay) {
      twelve = now.copyWith(hour: 23, minute: 59, second: 1);
    } else {
      twelve = now.copyWith(hour: 0, minute: 0, second: 1);
    }
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = twelve.millisecondsSinceEpoch.toString();
    return formattedDate;
  }
}
