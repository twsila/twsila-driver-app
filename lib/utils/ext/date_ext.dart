import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';

extension TimeStampFromDate on String {
  String getTimeStampFromDate({pattern = 'dd MMM yyyy/ hh:mm a'}) {
    final AppPreferences _appPrefs = instance<AppPreferences>();
    int? timestamp = int.tryParse(this);

    if (timestamp == null) {
      return '';
    }
    return DateFormat(pattern, _appPrefs.getAppLanguage())
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  TimeOfDay getTimeStampFromTimeOfDay({pattern = 'dd MMM yyyy/ hh:mm a'}) {
    final AppPreferences _appPrefs = instance<AppPreferences>();
    return TimeOfDay.fromDateTime(
        DateFormat(pattern, _appPrefs.getAppLanguage()).parse(this));
  }

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }
}

extension DateTimeExtension on DateTime {


  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }


}
