import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';

class LanguageHelper {
  String replaceArabicNumber(String input) {
    AppPreferences appPreferences = instance();
    String applang = appPreferences.getAppLanguage();

    if (applang == LanguageType.ARABIC.getValue()) {
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

      for (int i = 0; i < english.length; i++) {
        input = input.replaceAll(english[i], arabic[i]);
      }

      return input;
    } else {
      return input;
    }
  }

  String replaceEnglishNumber(String input) {
    AppPreferences appPreferences = instance();
    String applang = appPreferences.getAppLanguage();
    if (applang == LanguageType.ARABIC.getValue()) {
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

      for (int i = 0; i < arabic.length; i++) {
        input = input.replaceAll(arabic[i], english[i]);
      }
      return input;
    } else {
      return input;
    }
  }

  bool isRtl(BuildContext context) {
    return context.locale == ARABIC_LOCAL;
  }
}

// Arabic number formatter - commented out (using English format only)
// class ArabicNumbersTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     String text = LanguageHelper().replaceArabicNumber(newValue.text);
//
//     // Prevent and remove leading 0 (English) or ٠ (Arabic zero) after country code
//     // Remove all leading zeros (handles cases where user pastes multiple zeros)
//     String cleanedText = text;
//     int removedChars = 0;
//
//     while (cleanedText.isNotEmpty &&
//         (cleanedText[0] == '0' || cleanedText[0] == '٠')) {
//       cleanedText = cleanedText.substring(1);
//       removedChars++;
//     }
//
//     // If text was modified, adjust cursor position
//     if (cleanedText != text) {
//       int newCursorPosition = newValue.selection.start > removedChars
//           ? newValue.selection.start - removedChars
//           : 0;
//
//       // Ensure cursor position doesn't exceed text length
//       if (newCursorPosition > cleanedText.length) {
//         newCursorPosition = cleanedText.length;
//       }
//
//       // Ensure cursor position is not negative
//       if (newCursorPosition < 0) {
//         newCursorPosition = 0;
//       }
//
//       return TextEditingValue(
//         text: cleanedText,
//         selection: TextSelection.collapsed(offset: newCursorPosition),
//       );
//     }
//
//     return TextEditingValue(text: text, selection: newValue.selection);
//   }
// }

// Formatter to prevent leading zero after country code (English format only)
class NoLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Prevent and remove leading 0 after country code
    // Remove all leading zeros (handles cases where user pastes multiple zeros)
    String cleanedText = text;
    int removedChars = 0;

    while (cleanedText.isNotEmpty && cleanedText[0] == '0') {
      cleanedText = cleanedText.substring(1);
      removedChars++;
    }

    // If text was modified, adjust cursor position
    if (cleanedText != text) {
      int newCursorPosition = newValue.selection.start > removedChars
          ? newValue.selection.start - removedChars
          : 0;

      // Ensure cursor position doesn't exceed text length
      if (newCursorPosition > cleanedText.length) {
        newCursorPosition = cleanedText.length;
      }

      // Ensure cursor position is not negative
      if (newCursorPosition < 0) {
        newCursorPosition = 0;
      }

      return TextEditingValue(
        text: cleanedText,
        selection: TextSelection.collapsed(offset: newCursorPosition),
      );
    }

    return TextEditingValue(text: text, selection: newValue.selection);
  }
}
