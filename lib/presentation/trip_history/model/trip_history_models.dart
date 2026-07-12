class DateFilterRequest {
  final String? startDate;
  final String? endDate;
  final bool? isToday;

  const DateFilterRequest({this.startDate, this.endDate, this.isToday});

  Map<String, dynamic> toJson() => {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (isToday != null) 'isToday': isToday,
      };
}

class TripLocation {
  final double? latitude;
  final double? longitude;
  final String? address;

  TripLocation({this.latitude, this.longitude, this.address});

  factory TripLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TripLocation();
    return TripLocation(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: (json['address'] as String?) ??
          (json['locationName'] as String?) ??
          (json['cityName'] as String?),
    );
  }
}

class TripHistoryItem {
  final int tripId;
  final String? tripNumber;
  final String? serviceType;
  final String? tripStatus;
  final String? creationDate;
  final String? completionDate;
  final TripLocation pickupLocation;
  final TripLocation destination;
  final double? totalAmount;
  final String currencyCode;
  final bool invoiceAvailable;
  final int? offerId;

  TripHistoryItem({
    required this.tripId,
    this.tripNumber,
    this.serviceType,
    this.tripStatus,
    this.creationDate,
    this.completionDate,
    required this.pickupLocation,
    required this.destination,
    this.totalAmount,
    this.currencyCode = 'SAR',
    this.invoiceAvailable = false,
    this.offerId,
  });

  factory TripHistoryItem.fromJson(Map<String, dynamic> json) {
    return TripHistoryItem(
      tripId: _asInt(json['tripId']) ?? 0,
      tripNumber: json['tripNumber'] as String?,
      serviceType: json['serviceType'] as String?,
      tripStatus: json['tripStatus'] as String?,
      creationDate: json['creationDate'] as String?,
      completionDate: json['completionDate'] as String?,
      pickupLocation:
          TripLocation.fromJson(json['pickupLocation'] as Map<String, dynamic>?),
      destination:
          TripLocation.fromJson(json['destination'] as Map<String, dynamic>?),
      totalAmount: _asDouble(json['totalAmount']),
      currencyCode: json['currencyCode'] as String? ?? 'SAR',
      invoiceAvailable: json['invoiceAvailable'] as bool? ?? false,
      offerId: _asInt(json['offerId']),
    );
  }
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

class InvoiceLine {
  final String labelEn;
  final String labelAr;
  final double amount;
  final bool totalLine;

  InvoiceLine({
    required this.labelEn,
    required this.labelAr,
    required this.amount,
    this.totalLine = false,
  });

  factory InvoiceLine.fromJson(Map<String, dynamic> json) {
    return InvoiceLine(
      labelEn: json['labelEn'] as String? ?? '',
      labelAr: json['labelAr'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      totalLine: json['totalLine'] as bool? ?? false,
    );
  }
}

class TripInvoice {
  final int tripId;
  final int? offerId;
  final String? tripNumber;
  final String currencyCode;
  final String titleEn;
  final String titleAr;
  final String? tripStatus;
  final String? creationDate;
  final String? completionDate;
  final TripLocation pickupLocation;
  final TripLocation destination;
  final List<InvoiceLine> lines;

  TripInvoice({
    required this.tripId,
    this.offerId,
    this.tripNumber,
    this.currencyCode = 'SAR',
    required this.titleEn,
    required this.titleAr,
    this.tripStatus,
    this.creationDate,
    this.completionDate,
    required this.pickupLocation,
    required this.destination,
    required this.lines,
  });

  factory TripInvoice.fromJson(Map<String, dynamic> json) {
    final rawLines = json['lines'] as List<dynamic>? ?? [];
    return TripInvoice(
      tripId: (json['tripId'] as num).toInt(),
      offerId: (json['offerId'] as num?)?.toInt(),
      tripNumber: json['tripNumber'] as String?,
      currencyCode: json['currencyCode'] as String? ?? 'SAR',
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      tripStatus: json['tripStatus'] as String?,
      creationDate: json['creationDate'] as String?,
      completionDate: json['completionDate'] as String?,
      pickupLocation:
          TripLocation.fromJson(json['pickupLocation'] as Map<String, dynamic>?),
      destination:
          TripLocation.fromJson(json['destination'] as Map<String, dynamic>?),
      lines: rawLines
          .map((e) => InvoiceLine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
