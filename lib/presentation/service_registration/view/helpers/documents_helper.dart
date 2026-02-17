import 'package:flutter/foundation.dart' show describeEnum;

import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

import 'package:taxi_for_you/utils/resources/strings_manager.dart';

enum Documents {
  carDocument,
  driverLicense,
  driverId,
  ownerId,
  //Business owner
  boNationalId,
  boCommercialRegistrationDocument
}

enum DocumentType {
  carDocumentFront,
  carDocumentBack,
  driverLicenseFront,
  driverLicenseBack,
  driverIdFront,
  driverIdBack,
  ownerIdFront,
  ownerIdBack,
  //Business owner
  boNationalIdFront,
  boNationalIdBack,
  boCommercialRegistrationDocumentFront,
  boCommercialRegistrationDocumentBack
}

extension DocumentTypePhotoTitles on DocumentType {
  String get name => describeEnum(this);

  String get displayPhotosTitles {
    switch (this) {
      case DocumentType.carDocumentFront:
        return AppStrings.carDocumentFrontImage.tr();
      case DocumentType.carDocumentBack:
        return AppStrings.carDocumentBackImage.tr();
      case DocumentType.driverLicenseFront:
        return AppStrings.carDriverLicenseFrontImage.tr();
      case DocumentType.driverLicenseBack:
        return AppStrings.carDriverLicenseBackImage.tr();
      case DocumentType.driverIdFront:
        return AppStrings.carDriverIdentityCardFrontImage.tr();
      case DocumentType.driverIdBack:
        return AppStrings.carDriverIdentityCardBackImage.tr();
      case DocumentType.ownerIdFront:
        return AppStrings.carOwnerIdentityCardFrontImage.tr();
      case DocumentType.ownerIdBack:
        return AppStrings.carOwnerIdentityCardBackImage.tr();
      case DocumentType.boNationalIdFront:
        return AppStrings.boNationalIdFrontImage.tr();
      case DocumentType.boNationalIdBack:
        return AppStrings.boNationalIdBackImage.tr();
      case DocumentType.boCommercialRegistrationDocumentFront:
        return AppStrings.boCommercialRegistrationDocumentFrontImage.tr();
      case DocumentType.boCommercialRegistrationDocumentBack:
        return AppStrings.boCommercialRegistrationDocumentBackImage.tr();
      default:
        return 'title not found';
    }
  }
}

extension DocumentExpirationDateTitles on DocumentType {
  String get name => describeEnum(this);

  String get displayExpirationDateTitles {
    switch (this) {
      case DocumentType.carDocumentFront:
        return AppStrings.carDocumentExpireDate.tr();
      case DocumentType.driverLicenseFront:
        return AppStrings.carDriverLicenseExpireDate.tr();
      case DocumentType.driverIdFront:
        return AppStrings.carDriverIdentityCardExpireDate.tr();
      case DocumentType.ownerIdFront:
        return AppStrings.carOwnerIdentityCardExpireDate.tr();
      case DocumentType.boNationalIdFront:
        return AppStrings.boNationalIdExpireDate.tr();
      case DocumentType.boCommercialRegistrationDocumentFront:
        return AppStrings.boCommercialRegistrationDocumentExpireDate.tr();
      default:
        return 'title not found';
    }
  }
}

class DocumentObject {
  XFile? front;
  XFile? back;
  XFile? expiry;

  DocumentObject.empty();

  DocumentObject(this.front, this.back, this.expiry);
}
