import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/domain/usecase/update_driver_profile_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';

part 'update_driver_event.dart';

part 'update_driver_state.dart';

class UpdateDriverBloc extends Bloc<UpdateDriverEvent, UpdateDriverState> {
  AppPreferences appPreferences = instance<AppPreferences>();

  UpdateDriverBloc() : super(UpdateDriverInitial()) {
    on<splitAndOrganizeImagesList>(_splitAndOrganizeImagesList);
    on<EditDriverProfileDataEvent>(_EditDriverProfileDataEvent);
  }

  FutureOr<void> _splitAndOrganizeImagesList(
      splitAndOrganizeImagesList event, Emitter<UpdateDriverState> emit) async {
    emit(UpdateDriverLoading());

    List<String> carImageUrls = [];
    List<String> carDocumentsImageUrls = [];
    List<String> driverLicenseImageUrls = [];
    List<String> driverNationalIdImageUrls = [];
    List<String> ownerNationalIdImageUrls = [];

    await Future.forEach(event.driverImagesList, (DriverImage driverImage) {
      RegExp carImagesStringPattern = RegExp(r'^driver-car-photo-\d+\.jpg$');
      if (carImagesStringPattern.hasMatch(driverImage.imageName)) {
        carImageUrls.add(driverImage.imageUrl ?? "");
      }
      if (driverImage.imageName.contains(
              DriverImagesConstants.DRIVER_LICENSE_FRONT_IMAGE_STRING) ||
          driverImage.imageName.contains(
              DriverImagesConstants.DRIVER_LICENSE_BACK_IMAGE_STRING)) {
        driverLicenseImageUrls.add(driverImage.imageUrl ?? "");
      }
      if (driverImage.imageName.contains(
              DriverImagesConstants.CAR_DOCUMENT_FRONT_IMAGE_STRING) ||
          driverImage.imageName
              .contains(DriverImagesConstants.CAR_DOCUMENT_BACK_IMAGE_STRING)) {
        carDocumentsImageUrls.add(driverImage.imageUrl ?? "");
      }
      if (driverImage.imageName.contains(
              DriverImagesConstants.DRIVER_NATIONAL_ID_FRONT_IMAGE_STRING) ||
          driverImage.imageName.contains(
              DriverImagesConstants.DRIVER_NATIONAL_ID_BACK_IMAGE_STRING)) {
        driverNationalIdImageUrls.add(driverImage.imageUrl ?? "");
      }
      if (driverImage.imageName.contains(
              DriverImagesConstants.OWNER_NATIONAL_ID_FRONT_IMAGE_STRING) ||
          driverImage.imageName.contains(
              DriverImagesConstants.OWNER_NATIONAL_ID_BACK_IMAGE_STRING)) {
        ownerNationalIdImageUrls.add(driverImage.imageUrl ?? "");
      }
    });

    emit(driverOptimizedImagesSuccessState(
        carImageUrls,
        carDocumentsImageUrls,
        driverLicenseImageUrls,
        driverNationalIdImageUrls,
        ownerNationalIdImageUrls));
  }

  FutureOr<void> _EditDriverProfileDataEvent(
      EditDriverProfileDataEvent event, Emitter<UpdateDriverState> emit) async {
    emit(UpdateDriverLoading());

    UpdateDriverProfileUseCase updateDriverProfileUseCase =
        instance<UpdateDriverProfileUseCase>();
    File? profilePhoto;
    List<File> driverImages = [];
    if (event.profilePhoto != null) {
      profilePhoto = await changeImageFileNameOnly(
          event.profilePhoto!, Constants.DRIVER_PHOTO_IMAGE_STRING);
      driverImages.add(profilePhoto);
    }

    if (event.carImagesFromFile != null) {
      List<File> carImages = [];
      await Future.forEach(event.carImagesFromFile!, (String imageFilePath) async {
        int counter = 0;
        File carImageFile = await changeImageFileNameOnly(File(imageFilePath),
            "${DriverImagesConstants.DRIVER_CAR_PHOTOS_IMAGE_STRING}${counter}.jpg");
        carImages.add(carImageFile);
      });

      driverImages.addAll(carImages);
    }

    if (event.carDocumentsImagesFromFile != null) {
      File carDocumentFront = await changeImageFileNameOnly(
          File(event.carDocumentsImagesFromFile![0]),
          DriverImagesConstants.CAR_DOCUMENT_FRONT_IMAGE_STRING);
      File carDocumentBack = await changeImageFileNameOnly(
          File(event.carDocumentsImagesFromFile![1]),
          DriverImagesConstants.CAR_DOCUMENT_BACK_IMAGE_STRING);
      driverImages.add(carDocumentFront);
      driverImages.add(carDocumentBack);
    }

    if (event.driverNationalIdImagesFromFile != null) {
      File driverNationalIdFront = await changeImageFileNameOnly(
          File(event.driverNationalIdImagesFromFile![0]),
          DriverImagesConstants.DRIVER_NATIONAL_ID_FRONT_IMAGE_STRING);
      File driverNationalIdBack = await changeImageFileNameOnly(
          File(event.carDocumentsImagesFromFile![1]),
          DriverImagesConstants.DRIVER_NATIONAL_ID_BACK_IMAGE_STRING);
      driverImages.add(driverNationalIdFront);
      driverImages.add(driverNationalIdBack);
    }

    if (event.driverLicenseImagesFromFile != null) {
      File driverLicenseFront = await changeImageFileNameOnly(
          File(event.driverLicenseImagesFromFile![0]),
          DriverImagesConstants.DRIVER_LICENSE_FRONT_IMAGE_STRING);
      File driverLicenseBack = await changeImageFileNameOnly(
          File(event.driverLicenseImagesFromFile![1]),
          DriverImagesConstants.DRIVER_LICENSE_BACK_IMAGE_STRING);
      driverImages.add(driverLicenseFront);
      driverImages.add(driverLicenseBack);
    }

    if (event.ownerNationalIdImagesFromFile != null) {
      File ownerNationalIdFront = await changeImageFileNameOnly(
          File(event.ownerNationalIdImagesFromFile![0]),
          DriverImagesConstants.OWNER_NATIONAL_ID_FRONT_IMAGE_STRING);
      File ownerNationalIdBack = await changeImageFileNameOnly(
          File(event.ownerNationalIdImagesFromFile![1]),
          DriverImagesConstants.OWNER_NATIONAL_ID_BACK_IMAGE_STRING);
      driverImages.add(ownerNationalIdFront);
      driverImages.add(ownerNationalIdBack);
    }

    (await updateDriverProfileUseCase.execute(
      UpdateDriverProfileUseCaseInput(
          driverId: appPreferences.getCachedDriver()!.id!,
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          nationalId: event.nationalIdNumber,
          nationalIdExpiryDate: event.driverNationalIdExpiryDate,
          plateNumber: event.plateNumber,
          vehicleDocExpiryDate: event.carDocumentExpiryDate,
          vehicleOwnerNatIdExpiryDate: event.ownerNationalIdExpiryDate,
          vehicleDriverNatIdExpiryDate: event.driverNationalIdExpiryDate,
          licenseExpiryDate: event.driverLicenseExpiryDate,
          driverImages: driverImages),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(UpdateDriverFail(
                      failure.message, failure.code.toString()))
                }, (driverModelResponse) async {
      // right -> data (success)
      // content
      // emit success state
      emit(UpdateDriverSuccess());
      //
      var response = driverModelResponse.result;
      Driver driver = Driver.fromJson(response);
      driver.accessToken = appPreferences.getCachedDriver()!.accessToken;
      driver.refreshToken = appPreferences.getCachedDriver()!.refreshToken;
      await appPreferences.setDriver(driver);
    });
  }

  Future<UserDevice> setUserDevice() async {
    late UserDevice userDevice;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String token = await appPreferences.getFCMToken() ?? '1';

    if (Platform.isIOS) {
      userDevice = UserDevice(
        deviceOs: 'iPhone',
        appVersion: packageInfo.version,
        registrationId: token,
      );
    } else {
      userDevice = UserDevice(
        deviceOs: 'Android',
        appVersion: packageInfo.version,
        registrationId: token,
      );
    }

    return userDevice;
  }

  Future<File> changeImageFileNameOnly(File image, String newFileName) {
    var path = image.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return image.copy(newPath);
  }
}
