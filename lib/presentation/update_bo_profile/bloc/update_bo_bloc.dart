import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/domain/usecase/update_bo_profile_request.dart';
import 'package:taxi_for_you/domain/usecase/update_driver_profile_usecase.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';

part 'update_bo_event.dart';

part 'update_bo_state.dart';

class UpdateBoBloc extends Bloc<UpdateBoEvent, UpdateBoState> {
  AppPreferences appPreferences = instance<AppPreferences>();

  UpdateBoBloc() : super(UpdateBoInitial()) {
    on<splitAndOrganizeImagesList>(_splitAndOrganizeImagesList);
    on<EditBoProfileDataEvent>(_EditBoProfileDataEvent);
  }

  FutureOr<void> _splitAndOrganizeImagesList(
      splitAndOrganizeImagesList event, Emitter<UpdateBoState> emit) async {
    emit(UpdateBoLoading());

    List<String> boEntityImages = [];

    await Future.forEach(event.boImagesList, (DriverImage imageModel) {
      RegExp boEntityImagesPattern =
          RegExp(r'^business_owner_document_photo_\d+\.jpg$');
      if (boEntityImagesPattern.hasMatch(imageModel.imageName)) {
        boEntityImages.add(imageModel.imageUrl ?? "");
      }
      // if (imageModel.imageName
      //     .contains(Constants.BUSINESS_OWNER_PHOTO_IMAGE_STRING)) {
      //   boEntityImages.add(imageModel.imageUrl ?? "");
      // }
    });

    emit(BoOptimizedImagesSuccessState(
      entityImagesUrls: boEntityImages,
    ));
  }

  FutureOr<void> _EditBoProfileDataEvent(
      EditBoProfileDataEvent event, Emitter<UpdateBoState> emit) async {
    emit(UpdateBoLoading());

    UpdateBoProfileUseCase updateBoProfileUseCase =
        instance<UpdateBoProfileUseCase>();
    File? profilePhoto;
    List<File> entityImages = [];

    if (event.businessEntityImagesFromFile != null) {
      List<File> carImages = [];

      int counter = 1;
      await Future.forEach(event.businessEntityImagesFromFile!,
          (String imageFilePath) async {
        File boBusinessEntityImages = await changeImageFileNameOnly(
            File(imageFilePath),
            "${Constants.BUSINESS_OWNER_PHOTO_DOCUMENT_SUBSTRING}${counter}.jpg");
        carImages.add(boBusinessEntityImages);
        counter++;
      });

      entityImages.addAll(carImages);
    }

    (await updateBoProfileUseCase.execute(
      UpdateBoProfileUseCaseInput(
          event.id,
          event.firstName,
          event.lastName,
          event.entityName,
          event.email,
          event.taxNumber,
          event.commercialNumber,
          event.nationalId,
          entityImages,
          event.nationalIdExpiryDate,
          event.commercialRegisterExpiryDate),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(UpdateBoFail(failure.message, failure.code.toString()))
                }, (driverModelResponse) async {
      // right -> data (success)
      // content
      // emit success state
      emit(UpdateBoSuccess());
      //
      var response = driverModelResponse.result;
      BusinessOwnerModel bo = BusinessOwnerModel.fromJson(response);
      bo.accessToken = appPreferences.getCachedDriver()!.accessToken;
      bo.refreshToken = appPreferences.getCachedDriver()!.refreshToken;
      await appPreferences.setDriver(bo);
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
