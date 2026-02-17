import '../../utils/ext/enums.dart';

enum SortCriterion {
  REQUEST_DATE,
  NEAREST_TO_ME,
  LIGHT_WEIGHT,
  SHORT_DISTANCE,
  HIGH_PRICE,
  TOP_RATED_CLIENT
}

class SortingModel {
  TripModelType? tripModelType;
  SortCriterion? id;
  String? title;
  bool? sendCurrentLocation;

  SortingModel(this.tripModelType, this.id, this.title,
      {this.sendCurrentLocation = true});
}
