
class DistanceMatrix {
  final List<String>? destinations;
  final List<String>? origins;
  final List<Element>? elements;
  final String? status;

  DistanceMatrix({this.destinations, this.origins, this.elements, this.status});

  factory DistanceMatrix.fromJson(Map<String, dynamic> json) {
    var destinationsJson = json['destination_addresses'] as List?;
    var originsJson = json['origin_addresses'] as List?;
    final rows = json['rows'] as List?;
    List<Element>? elementsList;
    if (rows != null && rows.isNotEmpty) {
      final firstRow = rows[0];
      if (firstRow is Map<String, dynamic>) {
        final elementsRaw = firstRow['elements'] as List?;
        if (elementsRaw != null && elementsRaw.isNotEmpty) {
          elementsList = elementsRaw
              .whereType<Map<String, dynamic>>()
              .map((i) => Element.fromJson(i))
              .toList();
        }
      }
    }

    return DistanceMatrix(
        destinations: destinationsJson?.cast<String>(),
        origins: originsJson?.cast<String>(),
        elements: elementsList,
        status: json['status'] as String?);
  }

}

class Element {
  final Distance? distance;
  final Duration? duration;
  final String? status;

  Element({this.distance, this.duration, this.status});

  factory Element.fromJson(Map<String, dynamic> json) {
    final distanceJson = json['distance'];
    final durationJson = json['duration'];
    return Element(
        distance: distanceJson is Map<String, dynamic>
            ? Distance.fromJson(distanceJson)
            : null,
        duration: durationJson is Map<String, dynamic>
            ? Duration.fromJson(durationJson)
            : null,
        status: json['status'] as String?);
  }
}

class Distance {
  final String? text;
  final int? value;

  Distance({this.text, this.value});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
        text: json['text'] as String?,
        value: json['value'] as int?);
  }
}

class Duration {
  final String? text;
  final int? value;

  Duration({this.text, this.value});

  factory Duration.fromJson(Map<String, dynamic> json) {
    return Duration(
        text: json['text'] as String?,
        value: json['value'] as int?);
  }
}