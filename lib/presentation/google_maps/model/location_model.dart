class LocationModel {
  final String locationName;
  final double latitude;
  final double longitude;
   String? cityName;

  LocationModel(
      {required this.locationName,
      required this.latitude,
      required this.longitude,
       this.cityName});
}
