// To parse this JSON data, do
//
//     final dateFilterModel = dateFilterModelFromJson(jsonString);

import 'dart:convert';

DateFilterModel dateFilterModelFromJson(String str) =>
    DateFilterModel.fromJson(json.decode(str));

String dateFilterModelToJson(DateFilterModel data) =>
    json.encode(data.toJson());

class DateFilterModel {
  DateFilter dateFilter;

  DateFilterModel({
    required this.dateFilter,
  });

  factory DateFilterModel.fromJson(Map<String, dynamic> json) =>
      DateFilterModel(
        dateFilter: DateFilter.fromJson(json["dateFilter"]),
      );

  Map<String, dynamic> toJson() => {
        "dateFilter": dateFilter.toJson(),
      };
}

class DateFilter {
  String? startDate;
  String? endDate;
  bool? isToday;

  DateFilter({
    this.startDate,
    this.endDate,
    this.isToday,
  });

  factory DateFilter.fromJson(Map<String, dynamic> json) => DateFilter(
        startDate: json["startDate"],
        endDate: json["endDate"],
        isToday: json["isToday"],
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate,
        "endDate": endDate,
        "isToday": isToday,
      };
}
