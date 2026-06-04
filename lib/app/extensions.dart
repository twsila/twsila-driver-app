import 'constants.dart';
import 'package:intl/intl.dart';
extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return Constants.empty;
    } else {
      return this!;
    }
  }
}

extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      return Constants.zero;
    } else {
      return this!;
    }
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension DoubleExtensions on double {
  /// Formats the double value with comma separators and a fixed number of decimal places
  String toCommaSeparated({int decimalPlaces = 2}) {
    return NumberFormat('#,##0.${'0' * decimalPlaces}').format(this);
  }

  /// Parses a formatted string back to a double
  static double fromCommaSeparated(String formattedValue) {
    return NumberFormat('#,##0.##').parse(formattedValue).toDouble();
  }
}
