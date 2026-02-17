import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../app/constants.dart';
import '../../domain/model/trip_model.dart';
import '../../presentation/google_maps/model/location_model.dart';
import '../../presentation/trip_execution/helper/location_helper.dart';

enum AcceptanceType { PROPOSED, ACCEPTED, EXPIRED }

enum ShippingType { CHILLER, FROZEN, DRY }

enum DriverServiceType { PROPOSED, ACCEPTED, EXPIRED }

enum TankType { PROPOSED, ACCEPTED, EXPIRED }

enum SubmitStatus { TRIP_SUBMITTED, NOT_SUBMITTED }

enum RegistrationStatus { PENDING, APPROVED }

enum NotificationType {
  REQUEST_EXECUTION,
  EARLY_NOTIFICATION_ON_TRIP_DAY,
  DRIVER_ON_HIS_WAY,
  DRIVER_ARRIVED,
  TRIP_LAUNCHED,
  TRIP_FINISHED
}

enum DriverAcquisitionEnum { ACCEPTED, REJECTED, PENDING }

enum TripType {
  PERSON,
  CAR_AID,
  DRINK_WATER_TANK,
  FROZEN,
  FURNITURE,
  GOODS,
  OTHER_TANK
}

String getIconName(String tripType) {
  switch (tripType) {
    case TripTypeConstants.furnitureType:
      return ImageAssets.tripGoodsIc;
    case TripTypeConstants.frozenType:
      return ImageAssets.tripFrozenIc;
    case TripTypeConstants.goodsType:
      return ImageAssets.tripGoodsIc;
    case TripTypeConstants.carAidType:
      return ImageAssets.tripSatahatIc;
    case TripTypeConstants.otherTankType:
      return ImageAssets.tripSwarekIc;
    case TripTypeConstants.drinkWaterType:
      return ImageAssets.tripWaterTankIc;
    case TripTypeConstants.personsType:
      return ImageAssets.tripPersonsIc;
    default:
      return ImageAssets.tripGoodsIc;
  }
}

String getTitle(String tripType) {
  switch (tripType) {
    case TripTypeConstants.personsType:
      return AppStrings.request.tr() +
          ' ' +
          AppStrings.personsTransportation.tr();
    case TripTypeConstants.furnitureType:
      return AppStrings.request.tr() +
          ' ' +
          AppStrings.furnitureTransportation.tr();
    case TripTypeConstants.frozenType:
      return AppStrings.request.tr() + ' ' + AppStrings.freezers.tr();
    case TripTypeConstants.goodsType:
      return AppStrings.request.tr() + ' ' + AppStrings.goodsDeliver.tr();
    case TripTypeConstants.carAidType:
      return AppStrings.request.tr() + ' ' + AppStrings.carAid.tr();
    case TripTypeConstants.otherTankType:
      return AppStrings.request.tr() + ' ' + AppStrings.cisterns.tr();
    case TripTypeConstants.drinkWaterType:
      return AppStrings.wanet.tr() + ' ' + AppStrings.waterCisterns.tr();
    default:
      return AppStrings.request.tr() +
          ' ' +
          AppStrings.furnitureTransportation.tr();
  }
}

String getServiceTypeName(String tripType) {
  switch (tripType) {
    case TripTypeConstants.personsType:
      return AppStrings.request.tr() +
          ' ' +
          AppStrings.personsTransportation.tr();
    case TripTypeConstants.furnitureType:
      return AppStrings.request.tr() +
          ' ' +
          AppStrings.furnitureTransportation.tr();
    case TripTypeConstants.frozenType:
      return AppStrings.request.tr() + ' ' + AppStrings.freezers.tr();
    case TripTypeConstants.goodsType:
      return AppStrings.request.tr() + ' ' + AppStrings.goodsDeliver.tr();
    case TripTypeConstants.carAidType:
      return AppStrings.request.tr() + ' ' + AppStrings.carAid.tr();
    case TripTypeConstants.otherTankType:
      return AppStrings.request.tr() + ' ' + AppStrings.cisterns.tr();
    case TripTypeConstants.drinkWaterType:
      return AppStrings.wanet.tr() + ' ' + AppStrings.waterCisterns.tr();
    default:
      return AppStrings.request.tr() +
          ' ' +
          AppStrings.furnitureTransportation.tr();
  }
}

String getCurrency(String countryCode) {
  switch (countryCode) {
    case "SA":
      return AppStrings.ryalSuadi.tr();
    case "EG":
      return AppStrings.gnehMasry.tr();
    default:
      return "";
  }
}

String getTripStatusDiscs(String tripStatus) {
  switch (tripStatus) {
    case TripStatusConstants.DRAFTED:
      return AppStrings.draft_disc.tr();
    case TripStatusConstants.TRIP_SUBMITTED:
      return AppStrings.submitted_disc.tr();
    case TripStatusConstants.TRIP_IN_NEGOTIATION:
      return AppStrings.evaluated_disc.tr();
    case TripStatusConstants.WAITING_FOR_PAYMENT:
      return AppStrings.payment_disc.tr();
    case TripStatusConstants.READY_FOR_TAKEOFF:
      return AppStrings.startTripNowAndMoveToPickupLocation.tr();
    case TripStatusConstants.HEADING_TO_PICKUP_POINT:
      return AppStrings.tripStartedMoveNow.tr();
    case TripStatusConstants.ARRIVED_TO_PICKUP_POINT:
      return AppStrings.youArrivedPickupLocation.tr();
    case TripStatusConstants.HEADING_TO_DESTINATION:
      return AppStrings.youArrivedPickupLocation.tr();
    case TripStatusConstants.TRIP_COMPLETED:
      return AppStrings.youArrivedDestinationLocation.tr();
    case TripStatusConstants.TRIP_CANCELLED:
      return AppStrings.canceled_disc.tr();
    default:
      return "";
  }
}

String getTripStatusSubDis(String tripStatus) {
  switch (tripStatus) {
    case TripStatusConstants.DRAFTED:
      return "";
    case TripStatusConstants.TRIP_SUBMITTED:
      return "";
    case TripStatusConstants.TRIP_IN_NEGOTIATION:
      return "";
    case TripStatusConstants.WAITING_FOR_PAYMENT:
      return "";
    case TripStatusConstants.READY_FOR_TAKEOFF:
      return '${AppStrings.estimatedTimeToArrivePickupLocationIs.tr()} 15 ${AppStrings.minute.tr()}';
    case TripStatusConstants.HEADING_TO_PICKUP_POINT:
      return '${AppStrings.pleaseShipGoodsAndMoveToDestinationLocation.tr()}';
    case TripStatusConstants.ARRIVED_TO_PICKUP_POINT:
      return '${AppStrings.pleaseShipGoodsAndMoveToDestinationLocation.tr()}';
    case TripStatusConstants.HEADING_TO_DESTINATION:
      return ' ';
    case TripStatusConstants.TRIP_COMPLETED:
      return "";
    case TripStatusConstants.TRIP_CANCELLED:
      return "";
    default:
      return "";
  }
}

String tripStepperTitles(
    String tripStatus, String driverServiceType, String userType) {
  if (userType == RegistrationConstants.captain &&
      driverServiceType == "PERSONS") {
    switch (tripStatus) {
      case TripStatusConstants.READY_FOR_TAKEOFF:
        return '${AppStrings.stepper_driver_first_step_title.tr()}';
      case TripStatusConstants.HEADING_TO_PICKUP_POINT:
        return '${AppStrings.stepper_driver_second_step_title.tr()}';
      case TripStatusConstants.ARRIVED_TO_PICKUP_POINT:
        return '${AppStrings.stepper_driver_third_step_title.tr()}';
      case TripStatusConstants.HEADING_TO_DESTINATION:
        return '${AppStrings.stepper_driver_forth_step_title.tr()}';
      case TripStatusConstants.TRIP_COMPLETED:
        return '${AppStrings.stepper_driver_forth_step_title.tr()}';
    }
  } else if (userType == RegistrationConstants.captain &&
      driverServiceType != "PERSONS") {
    switch (tripStatus) {
      case TripStatusConstants.READY_FOR_TAKEOFF:
        return '${AppStrings.stepper_driver_first_step_title.tr()}';
      case TripStatusConstants.HEADING_TO_PICKUP_POINT:
        return '${AppStrings.stepper_driver_second_step_title.tr()}';
      case TripStatusConstants.ARRIVED_TO_PICKUP_POINT:
        return '${AppStrings.stepper_driver_third_step_title.tr()}';
      case TripStatusConstants.HEADING_TO_DESTINATION:
        return '${AppStrings.stepper_driver_forth_step_title.tr()}';
      case TripStatusConstants.TRIP_COMPLETED:
        return '${AppStrings.stepper_driver_forth_step_title.tr()}';
    }
  } else if (userType == RegistrationConstants.businessOwner) {
    switch (tripStatus) {
      case TripStatusConstants.READY_FOR_TAKEOFF:
        return '${AppStrings.stepper_bo_first_step_title.tr()}';
      case TripStatusConstants.HEADING_TO_PICKUP_POINT:
        return '${AppStrings.stepper_bo_second_step_title.tr()}';
      case TripStatusConstants.ARRIVED_TO_PICKUP_POINT:
        return '${AppStrings.stepper_bo_third_step_title.tr()}';
      case TripStatusConstants.HEADING_TO_DESTINATION:
        return '${AppStrings.stepper_bo_forth_step_title.tr()}';
      case TripStatusConstants.TRIP_COMPLETED:
        return '${AppStrings.stepper_bo_forth_step_title.tr()}';
    }
  }
  return "";
}

String tripStepperDisc(
    String tripStatus, String driverServiceType, String userType) {
  if (userType == RegistrationConstants.captain &&
      driverServiceType == "PERSONS") {
    switch (tripStatus) {
      case TripStatusConstants.READY_FOR_TAKEOFF:
        return '${AppStrings.stepper_driver_first_step_disc.tr()}';
      case TripStatusConstants.HEADING_TO_PICKUP_POINT:
        // return '${AppStrings.estimatedTimeToArrivePickupLocationIs.tr()} 15 ${AppStrings.minute.tr()}';
        return '';
      case TripStatusConstants.ARRIVED_TO_PICKUP_POINT:
        return '${AppStrings.stepper_driver_third_step_disc.tr()}';
      case TripStatusConstants.HEADING_TO_DESTINATION:
        return '${AppStrings.stepper_driver_third_step_disc.tr()}';
      case TripStatusConstants.TRIP_COMPLETED:
        return '${AppStrings.stepper_driver_forth_step_disc.tr()}';
    }
  } else if (userType == RegistrationConstants.captain &&
      driverServiceType != "PERSONS") {
    switch (tripStatus) {
      case TripStatusConstants.READY_FOR_TAKEOFF:
        return '';
      case TripStatusConstants.HEADING_TO_PICKUP_POINT:
        // return '${AppStrings.estimatedTimeToArrivePickupLocationIs.tr()} 15 ${AppStrings.minute.tr()}';
        return '';
      case TripStatusConstants.ARRIVED_TO_PICKUP_POINT:
        return '${AppStrings.stepper_driver_goods_third_step_disc.tr()}';
      case TripStatusConstants.HEADING_TO_DESTINATION:
        return '${AppStrings.stepper_driver_goods_third_step_disc.tr()}';
      case TripStatusConstants.TRIP_COMPLETED:
        return '${AppStrings.stepper_driver_goods_forth_step_disc.tr()}';
    }
  } else if (userType == RegistrationConstants.businessOwner) {
    switch (tripStatus) {
      case TripStatusConstants.READY_FOR_TAKEOFF:
        return '';
      case TripStatusConstants.HEADING_TO_PICKUP_POINT:
        return '';
      case TripStatusConstants.ARRIVED_TO_PICKUP_POINT:
        return '${AppStrings.stepper_bo_third_step_disc.tr()}';
      case TripStatusConstants.HEADING_TO_DESTINATION:
        return '${AppStrings.stepper_bo_third_step_disc.tr()}';
      case TripStatusConstants.TRIP_COMPLETED:
        return '${AppStrings.stepper_bo_third_step_disc.tr()}';
    }
  }
  return "";
}

Color getTripStatusDisColor(String tripStatus) {
  switch (tripStatus) {
    case TripStatusConstants.DRAFTED:
      return ColorManager.supportTextColor;
    case TripStatusConstants.TRIP_SUBMITTED:
      return ColorManager.supportTextColor;
    case TripStatusConstants.TRIP_IN_NEGOTIATION:
      return ColorManager.supportTextColor;
    case TripStatusConstants.WAITING_FOR_PAYMENT:
      return ColorManager.supportTextColor;
    case TripStatusConstants.READY_FOR_TAKEOFF:
      return ColorManager.primary;
    case TripStatusConstants.HEADING_TO_PICKUP_POINT:
      return ColorManager.accentTextColor;
    case TripStatusConstants.ARRIVED_TO_PICKUP_POINT:
      return ColorManager.accentTextColor;
    case TripStatusConstants.HEADING_TO_DESTINATION:
      return ColorManager.accentTextColor;
    case TripStatusConstants.TRIP_COMPLETED:
      return ColorManager.primary;
    case TripStatusConstants.TRIP_CANCELLED:
      return ColorManager.error;
    default:
      return ColorManager.secondaryColor;
  }
}

extension TripTypeIcon on TripType {
  String getIconAsset() {
    switch (this) {
      case TripType.PERSON:
        return ImageAssets.tripPersonsIc;
      case TripType.CAR_AID:
        return ImageAssets.tripPersonsIc;
      case TripType.DRINK_WATER_TANK:
        return ImageAssets.tripWaterTankIc;
      case TripType.FROZEN:
        return ImageAssets.tripFrozenIc;
      case TripType.FURNITURE:
        return ImageAssets.tripGoodsIc;
      case TripType.GOODS:
        return ImageAssets.tripGoodsIc;
      case TripType.OTHER_TANK:
        return ImageAssets.tripSwarekIc;
    }
  }
}

extension TripTypeTitle on TripType {
  String getTripTitle() {
    switch (this) {
      case TripType.PERSON:
        return AppStrings.personsTransportation.tr();
      case TripType.CAR_AID:
        return AppStrings.personsTransportation.tr();
      case TripType.DRINK_WATER_TANK:
        return AppStrings.waterCisterns.tr();
      case TripType.FROZEN:
        return AppStrings.freezers.tr();
      case TripType.FURNITURE:
        return AppStrings.furnitureTransportation.tr();
      case TripType.GOODS:
        return AppStrings.goodsDeliver.tr();
      case TripType.OTHER_TANK:
        return AppStrings.cisterns.tr();
    }
  }
}

enum TripModelType {
  ALL_TRIPS,
  SCHEDULED_TRIPS,
  TODAY_TRIPS,
  OFFERED_TRIPS,
  OLD_TRIPS
}

enum TripStatus {
  DRAFTED,
  TRIP_SUBMITTED,
  TRIP_IN_NEGOTIATION,
  WAITING_FOR_PAYMENT,
  READY_FOR_TAKEOFF,
  HEADING_TO_PICKUP_POINT,
  ARRIVED_TO_PICKUP_POINT,
  HEADING_TO_DESTINATION,
  TRIP_COMPLETED,
  TRIP_CANCELLED
}
