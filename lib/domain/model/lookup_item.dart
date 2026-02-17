import '../../app/app_prefs.dart';
import '../../app/di.dart';

class LookupItem {
  final int id;
  final String value;
  final String valueAr;

  LookupItem({
    required this.id,
    required this.value,
    required this.valueAr,
  });

  factory LookupItem.fromJson(Map<String, dynamic> json) {
    final AppPreferences appPreferences = instance();
    return LookupItem(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      value: appPreferences.isEnglish()
          ? json['value'].replaceAll('_', ' ')
          : json['valueAr'].replaceAll('_', ' '),
      valueAr: json['valueAr'].replaceAll('_', ' '),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id.toString();
    data['value'] = value.toString();
    data['valueAr'] = valueAr.toString();
    return data;
  }
}