import 'dart:convert';

import 'package:intl/intl.dart';

class Validators {
  static isNumber(String val) {
    if (val.isEmpty) return false;
    RegExp _reg = RegExp(r'^(\d*\.)?\d+$');
    return _reg.hasMatch(val);
  }

  static onlyCharacters(String val) {
    return !RegExp(r'^[a-zA-Z]+$').hasMatch(val);
  }

  static isGreaterOrEqualOne(String val) {
    if (val.isEmpty) return false;
    double? number = double.tryParse(val);
    if (number == null) return false;
    if (number >= 1) return true;
    return false;
  }

  static final RegExp _emailRegExp = RegExp(
    r'[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9\\d!@#$%^&*(),.?":{}\'
    '`~|<>;_+=^/\[\\]-]{7,}\$',
  );

  static checkIFAllZero(String text) {
    String textWithoutDashes = '';
    textWithoutDashes = text.replaceAll('/-/', "");
    double? parsed = double.tryParse(textWithoutDashes);
    if (textWithoutDashes == '' || (parsed != null && parsed <= 0)) {
      return true;
    } else {
      return false;
    }
  }

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    if (password.trim().length <= 0 && password.isEmpty)
      return "Please enter password";
    if (password.trim().length < 7)
      return 'Invalid password,\n password should be minimum 7 characters length';
    if (!_passwordRegExp.hasMatch(password)) return 'Invalid Password';
    return null;
  }

  static String? emailVal(String input, String error) {
    final validCharacters = RegExp(
        r'[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}');
    if (!validCharacters.hasMatch(input)) {
      return error;
    }
    return null;
  }

  static String? requirdVal(String input, String error) {
    if (input.isEmpty) {
      return error;
    }
    return null;
  }

  static bool required(String? input) {
    if (input == null) {
      return false;
    }
    if (input.trim().length <= 0 && input.isEmpty) {
      return false;
    }
    if (input.replaceAll(RegExp(" "), '').length == 0) {
      return false;
    }
    return true;
  }

  static String? requirdValMustBe4Degits(String input, String error) {
    if (input.trim().length <= 0 && input.isEmpty) {
      return "input can't be empty";
    } else if (input.trim().length != 4) {
      return "must be 4 digits";
    }
    return null;
  }

  static String? numberVal(String input, String error) {
    final validCharacters = RegExp(r'(^[0-9]*$)');
    if (!validCharacters.hasMatch(input)) {
      return error;
    }
    return null;
  }

  static String? maxVal(String input, int max, String errMsg) {
    if (input.length > 0 && int.parse(input) > max) {
      return errMsg;
    }
    return null;
  }

  static String? minVal(String input, int min, String errMsg) {
    if (input.length > 0 && int.parse(input) < min) {
      return errMsg;
    }
    return null;
  }

  static String? maximumVal(String input, int min, int max,
      [String? minError, String? maxError]) {
    if (input.length < min && min != 0) {
      return minError;
    } else if (input.length > max && max != 0) {
      return maxError;
    }
    return null;
  }

  static String? noSpecialVal(String input, String error) {
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    if (!validCharacters.hasMatch(input)) {
      return error;
    }
    return null;
  }

  static String? textVal(String input, String error) {
    final validCharacters = RegExp(r'(^[a-zA-Z ]*$)');
    if (!validCharacters.hasMatch(input)) {
      return error;
    }
    return null;
  }

  static String? phoneVal(String input, String error) {
    final validCharacters = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (!validCharacters.hasMatch(input)) {
      return error;
    }
    return null;
  }

  static String? validatePassword(String value, String error) {
    // Pattern pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
    RegExp regex = new RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    String trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return 'Please enter password';
//    } else if (!regex.hasMatch(value)) {
//      return error;
    } else {
      return null;
    }
  }

  static String? requirdValAndMatch(String input, String matchedInput,
      String errorEmpty, String errorMatched) {
    if (matchedInput.trim().length <= 0 && input.isEmpty) {
      return errorEmpty;
    } else {
      if (input != matchedInput) {
        return errorMatched;
      }
    }
    return null;
  }

  static String? validateRegistrationNumber(
      String value, String error, bool isRegistered) {
    if (value.trim().length <= 0 && value.isEmpty) {
      return 'Please enter mobile numer';
    } else if (isRegistered) {
      return error;
    } else {
      return null;
    }
  }

  static ValidJsonXpath checkValidJsonXpath(
      Map<String, dynamic> jsonObject, String xPathString) {
    ValidJsonXpath validityObject = ValidJsonXpath.fromJson({});

    if (xPathString.isNotEmpty) {
      Map<String, dynamic> flattenJsonObject(Map<String, dynamic> jsonObject,
          [String prefix = '']) {
        final Map<String, dynamic> jsonObjectFlatten = {};
        jsonObject.forEach((String key, dynamic value) {
          if (value is Map<String, dynamic>) {
            if (value.length != 0) {
              jsonObjectFlatten['$prefix$key'] = value;
              jsonObjectFlatten
                  .addAll(flattenJsonObject(value, '$prefix$key.'));
            }
          } else {
            jsonObjectFlatten['$prefix$key'] = value.toString();
          }
        });
        return jsonObjectFlatten;
      }

      Map jsonObjectFlatten = flattenJsonObject(jsonObject);

      if (jsonObjectFlatten.keys.contains(xPathString)) {
        validityObject.value = jsonObjectFlatten[xPathString];
        validityObject.valid = true;
      }
    }
    return validityObject;
  }

  static String formatAmount(dynamic unformattedAmount) {
    dynamic amount = unformattedAmount;
    if (amount != null && amount != "" && amount is num) {
      final numberFormat = new NumberFormat("#,##0.###", "en_US");
      amount = numberFormat.format(amount);
    }
    return amount;
  }

  static String formatAmountTwoDicimalPlaces(dynamic unformattedAmount) {
    if (unformattedAmount == null) return "";
    if (unformattedAmount is String) return unformattedAmount;
    if (unformattedAmount is int)
      unformattedAmount = unformattedAmount.toDouble();
    return unformattedAmount.toStringAsFixed((2)).toString();
  }
}
// To parse this JSON data, do
//
//     final validJsonXpath = validJsonXpathFromJson(jsonString);

ValidJsonXpath validJsonXpathFromJson(String str) =>
    ValidJsonXpath.fromJson(json.decode(str));

String validJsonXpathToJson(ValidJsonXpath data) => json.encode(data.toJson());

class ValidJsonXpath {
  ValidJsonXpath({
    this.valid,
    this.value,
  });

  bool? valid;
  dynamic value;

  factory ValidJsonXpath.fromJson(Map<String, dynamic> json) => ValidJsonXpath(
        valid: json["valid"] == null ? false : json["valid"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toJson() => {
        "valid": valid == null ? false : valid,
        "value": value == null ? null : value,
      };
}
