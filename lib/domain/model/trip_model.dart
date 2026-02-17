// To parse this JSON data, do
//
//     final tripModel = tripModelFromJson(jsonString);

import 'dart:convert';

import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/app/extensions.dart';



TripModel tripModelFromJson(String str) => TripModel.fromJson(json.decode(str));

String tripModelToJson(TripModel data) => json.encode(data.toJson());

class TripModelResponse {
  bool success;
  dynamic message;
  String dateTime;
  List<TripModel> result;

  TripModelResponse({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory TripModelResponse.fromJson(Map<String, dynamic> json) =>
      TripModelResponse(
        success: json["success"],
        message: json["message"],
        dateTime: json["dateTime"],
        result: List<TripModel>.from(
            json["result"].map((x) => TripModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "dateTime": dateTime,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class TripModel {
  int? id;
  Ation? pickupLocation;
  Ation? destination;
  TripStatus? tripStatus;
  TripType? tripType;
  String? date;
  dynamic? tripNumber;
  Passenger? passenger;
  String? notes;
  double? clientOffer;
  String? clientOfferFormatted;
  List<Offer>? offers;
  AcceptedOffer? acceptedOffer;
  List<TripImage>? images;
  bool? containsPacking;
  bool? containsLoading;
  bool? containsLift;
  double? payloadWeight;
  FrozenMaterial? materialDetails;
  FrozenMaterial? packingDetails;
  bool? containsBoxes;
  String? shippingType;
  FrozenMaterial? frozenMaterial;
  TankDetails? tankDetails;
  String? tankType;
  bool? containsAssemble;
  String? furnitureItems;

  TripModel({
    this.id,
    this.pickupLocation,
    this.destination,
    this.tripStatus,
    this.tripType,
    this.date,
    this.tripNumber,
    this.passenger,
    this.notes,
    this.clientOffer,
    this.clientOfferFormatted,
    this.images,
    this.containsPacking,
    this.containsLoading,
    this.containsLift,
    this.payloadWeight,
    this.materialDetails,
    this.packingDetails,
    this.containsBoxes,
    this.shippingType,
    this.offers,
    this.acceptedOffer,
    this.frozenMaterial,
    this.tankDetails,
    this.tankType,
    this.containsAssemble,
    this.furnitureItems,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
        id: json["id"] != null ? json["id"] : null,
        pickupLocation: json["pickupLocation"] != null
            ? Ation.fromJson(json["pickupLocation"])
            : null,
        destination: json["destination"] != null
            ? Ation.fromJson(json["destination"])
            : null,
        tripStatus: json["tripStatus"] != null
            ? tripStatusValues.map[json["tripStatus"]]
            : null,
        tripType: json["tripType"] != null
            ? tripTypesValues.map[json["tripType"]]
            : null,
        offers: json["offers"] != null
            ? List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x)))
            : [],
        acceptedOffer: json["acceptedOffer"] != null
            ? AcceptedOffer.fromJson(json["acceptedOffer"])
            : null,
        date: json["date"] != null ? json["date"] : null,
        tripNumber: json["tripNumber"] != null ? json["tripNumber"] : null,
        passenger: json["passenger"] != null
            ? Passenger.fromJson(json["passenger"])
            : null,
        notes: json["notes"] != null ? json["notes"] : null,
        clientOffer: json["clientOffer"] != null
            ? json["clientOffer"]?.toDouble()
            : null,
        clientOfferFormatted: json["clientOffer"] != null
            ? (json["clientOffer"] as double).toCommaSeparated(decimalPlaces: 2)
            : null,
        images: json["images"] != null && json["images"].isNotEmpty
            ? List<TripImage>.from(
                json["images"].map((x) => TripImage.fromJson(x)))
            : [],
        containsPacking: json["containsPacking"],
        containsLoading: json["containsLoading"],
        containsLift: json["containsLift"],
        payloadWeight: json["payloadWeight"]?.toDouble(),
        materialDetails: json["materialDetails"] == null
            ? null
            : FrozenMaterial.fromJson(json["materialDetails"]),
        packingDetails: json["packingDetails"] == null
            ? null
            : FrozenMaterial.fromJson(json["packingDetails"]),
        containsBoxes: json["containsBoxes"],
        shippingType: json["shippingType"],
        frozenMaterial: json["frozenMaterial"] == null
            ? null
            : FrozenMaterial.fromJson(json["frozenMaterial"]),
        tankDetails: json["tankDetails"] == null
            ? null
            : TankDetails.fromJson(json["tankDetails"]),
        tankType: json["tankType"],
        containsAssemble: json["containsAssemble"],
        furnitureItems: json["furnitureItems"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pickupLocation": pickupLocation!.toJson(),
        "destination": destination!.toJson(),
        "tripStatus": tripStatusValues.reverse[tripStatus],
        "tripType": tripTypesValues.reverse[tripType],
        "date": date,
        "tripNumber": tripNumber,
        "passenger": passenger!.toJson(),
        "notes": notes,
        "clientOffer": clientOffer,
        "clientOfferFormatted": clientOfferFormatted,
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
        "containsPacking": containsPacking,
        "containsLoading": containsLoading,
        "containsLift": containsLift,
        "payloadWeight": payloadWeight,
        "materialDetails": materialDetails?.toJson(),
        "packingDetails": packingDetails?.toJson(),
        "containsBoxes": containsBoxes,
        "shippingType": shippingType,
        "frozenMaterial": frozenMaterial?.toJson(),
        "tankDetails": tankDetails?.toJson(),
        "tankType": tankType,
        "containsAssemble": containsAssemble,
        "furnitureItems": furnitureItems,
      };
}

class AcceptedOffer {
  final int acceptedOfferId;
  final Offer offer;

  AcceptedOffer({required this.acceptedOfferId, required this.offer});

  factory AcceptedOffer.fromJson(Map<String, dynamic> json) => AcceptedOffer(
        acceptedOfferId: json['id'],
        offer: Offer.fromJson(json['offer']),
      );
}

class Offer {
  final int offerId;
  final double driverOffer;
  final String? driverOfferFormatted;
  final String acceptanceStatus;
  final String creationDate;

  // final Driver driverModel; //will change to driverId
  final bool? woman;

  Offer({
    required this.offerId,
    // required this.driverModel,
    this.driverOfferFormatted,
    required this.acceptanceStatus,
    required this.creationDate,
    required this.driverOffer,
    this.woman,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        offerId: json['id'],
        // driverModel: Driver.fromJson(json['driver']),
        acceptanceStatus: json['acceptanceStatus'],
        creationDate: json['creationDate'] ?? "",
        driverOffer: json['driverOffer'],
        driverOfferFormatted:
        (json['driverOffer'] as double).toCommaSeparated(decimalPlaces: 2),
        woman: json['woman'],
      );
}

final tripTypesValues = EnumValues({
  "PERSON": TripType.PERSON,
  "CAR_AID": TripType.CAR_AID,
  "DRINK_WATER_TANK": TripType.DRINK_WATER_TANK,
  "FROZEN": TripType.FROZEN,
  "GOODS": TripType.GOODS,
  "FURNITURE": TripType.FURNITURE,
  "OTHER_TANK": TripType.OTHER_TANK,
});

class Ation {
  double latitude;
  double longitude;
  String locationName;

  Ation({
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  factory Ation.fromJson(Map<String, dynamic> json) => Ation(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        locationName: json["locationName"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "locationName": locationName,
      };
}

class FrozenMaterial {
  int id;
  String description;

  FrozenMaterial({
    required this.id,
    required this.description,
  });

  factory FrozenMaterial.fromJson(Map<String, dynamic> json) => FrozenMaterial(
        id: json["id"],
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
      };
}

class TripImage {
  int id;
  String imageName;

  TripImage({
    required this.id,
    required this.imageName,
  });

  factory TripImage.fromJson(Map<String, dynamic> json) => TripImage(
        id: json["id"],
        imageName: json["imageName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageName": imageName,
      };
}

class Passenger {
  int id;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String gender;
  String dateOfBirth;
  double rating;

  Passenger({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.rating,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        id: json["id"],
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? " ",
        mobile: json["mobile"],
        email: json["email"] ?? "",
        gender: json["gender"] ?? "",
        dateOfBirth: json["dateOfBirth"] ?? "",
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "email": email,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "rating": rating,
      };
}

class TankDetails {
  int id;
  int size;

  TankDetails({
    required this.id,
    required this.size,
  });

  factory TankDetails.fromJson(Map<String, dynamic> json) => TankDetails(
        id: json["id"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "size": size,
      };
}

final tripStatusValues = EnumValues({
  "DRAFTED": TripStatus.DRAFTED,
  "TRIP_SUBMITTED": TripStatus.TRIP_SUBMITTED,
  "TRIP_IN_NEGOTIATION": TripStatus.TRIP_IN_NEGOTIATION,
  "WAITING_FOR_PAYMENT": TripStatus.WAITING_FOR_PAYMENT,
  "READY_FOR_TAKEOFF": TripStatus.READY_FOR_TAKEOFF,
  "HEADING_TO_PICKUP_POINT": TripStatus.HEADING_TO_PICKUP_POINT,
  "ARRIVED_TO_PICKUP_POINT": TripStatus.ARRIVED_TO_PICKUP_POINT,
  "HEADING_TO_DESTINATION": TripStatus.HEADING_TO_DESTINATION,
  "TRIP_COMPLETED": TripStatus.TRIP_COMPLETED,
  "TRIP_CANCELLED": TripStatus.TRIP_CANCELLED
});
final acceptanceStatusValues = EnumValues({
  "PROPOSED": AcceptanceType.PROPOSED,
  "ACCEPTED": AcceptanceType.ACCEPTED,
  "EXPIRED": AcceptanceType.EXPIRED,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
