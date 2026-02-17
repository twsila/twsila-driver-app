import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_network_image_widget.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/update_driver_profile/view/widgets/list_documents_images.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/state_renderer/dialogs.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/custom_text_input_field.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/update_driver_bloc.dart';

//values to listen to the bool
//firstname,lastname,birthdate,nationalId,gender,

//if isDisabled = true , can access and view my profile screen only,make as much to be dynamic
//if isBlocked = true, error user cannot use the app for now

class UpdateDriverProfileView extends StatefulWidget {
  final DriverBaseModel driver;

  UpdateDriverProfileView({required this.driver});

  @override
  State<UpdateDriverProfileView> createState() =>
      _UpdateDriverProfileViewState();
}

class _UpdateDriverProfileViewState extends State<UpdateDriverProfileView> {
  bool _displayLoadingIndicator = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  AppPreferences _appPreferences = instance<AppPreferences>();
  String currentProfilePhoto = '';
  Driver? driver;

  String? captainImagePath;
  ImagePicker imgPicker = ImagePicker();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  TextEditingController _nationalIdController = TextEditingController();
  TextEditingController _plateNumberController = TextEditingController();

  String? dateOfBirth;

  bool enableUpdate = false;

  bool loadCarImagesFromFile = false;
  bool carDocumentImagesUrlsFromFile = false;
  bool driverNationalIdFromFile = false;
  bool driverLicenseFromFile = false;
  bool ownerNationalIdFromFile = false;

  List<String> carImagesUrls = [];
  List<String> carDocumentImagesUrls = [];
  List<String> driverNationalIdImagesUrls = [];
  List<String> driverLicenseImagesUrls = [];
  List<String> ownerNationalIdImagesUrls = [];

  String? carDocumentExpiryDate;
  String? driverNationalIdExpiryDate;
  String? driverLicenseExpiryDate;
  String? ownerNationalIdExpiryDate;

  @override
  initState() {
    driver = widget.driver as Driver;
    _firstNameController.text = driver!.firstName ?? '';
    _lastNameController.text = driver!.lastName ?? '';
    _mobileNumberController.text = driver!.mobile ?? '';
    _emailController.text = driver!.email ?? '';
    _nationalIdController.text = driver!.nationalId ?? '';
    _plateNumberController.text = driver!.plateNumber ?? '';
    carDocumentExpiryDate = driver!.vehicleDocExpiryDate ?? '';
    driverLicenseExpiryDate = driver!.vehicleDriverNatIdExpiryDate ?? '';
    driverNationalIdExpiryDate = driver!.vehicleDriverNatIdExpiryDate ?? '';
    ownerNationalIdExpiryDate = driver!.vehicleOwnerNatIdExpiryDate ?? '';
    BlocProvider.of<UpdateDriverBloc>(context)
        .add(splitAndOrganizeImagesList(driverImagesList: driver!.images));
    super.initState();
  }

  Future<String> getProfilePicPath() async {
    return _appPreferences.userProfilePicture(widget.driver);
  }

  void startLoading() {
    setState(() {
      _displayLoadingIndicator = true;
    });
  }

  void stopLoading() {
    setState(() {
      _displayLoadingIndicator = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
          appbar: true,
          context: context,
          body: _getContentWidget(context),
          scaffoldKey: _key,
          displayLoadingIndicator: _displayLoadingIndicator,
          allowBackButtonInAppBar: true,
          appBarTitle: AppStrings.changeMyProfile.tr(),
          centerTitle: true),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<UpdateDriverBloc, UpdateDriverState>(
      listener: (context, state) {
        if (state is UpdateDriverLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is driverOptimizedImagesSuccessState) {
          carImagesUrls = state.carImageUrls;
          carDocumentImagesUrls = state.carDocumentsImageUrls;
          driverNationalIdImagesUrls = state.driverNationalIdImageUrls;
          driverLicenseImagesUrls = state.driverLicenseImageUrls;
          ownerNationalIdImagesUrls = state.ownerNationalIdImageUrls;
        }

        if (state is UpdateDriverSuccess) {
          CustomDialog(context).showSuccessDialog(
              '', '', AppStrings.updateProfileDoneSuccessfully.tr(),
              onBtnPressed: () {
            Navigator.pushReplacementNamed(context, Routes.mainRoute);
          });
        }
        if (state is UpdateDriverFail) {
          CustomDialog(context).showErrorDialog('', '', '');
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profilePhotoHeader(),
                SizedBox(
                  height: 30,
                ),
                CustomTextInputField(
                  labelText: AppStrings.firstName.tr(),
                  showLabelText: true,
                  controller: _firstNameController,
                  hintText: AppStrings.enterFirstNameHere.tr(),
                  validateEmptyString: true,
                  onChanged: (value) {
                    if (value != driver!.firstName) {
                      setState(() {
                        enableUpdate = true;
                      });
                    }
                  },
                ),
                CustomTextInputField(
                  labelText: AppStrings.lastName.tr(),
                  showLabelText: true,
                  controller: _lastNameController,
                  hintText: AppStrings.enterLastNameHere.tr(),
                  validateEmptyString: true,
                  onChanged: (value) {
                    if (value != driver!.lastName) {
                      setState(() {
                        enableUpdate = true;
                      });
                    }
                  },
                ),
                CustomTextInputField(
                  labelText: AppStrings.jawalNumber.tr(),
                  showLabelText: true,
                  enabled: false,
                  controller: _mobileNumberController,
                  hintText: '',
                  onChanged: (value) {
                    if (value != driver!.mobile) {
                      setState(() {
                        enableUpdate = true;
                      });
                    }
                  },
                ),
                CustomTextInputField(
                  labelText: AppStrings.email.tr(),
                  showLabelText: true,
                  controller: _emailController,
                  validateEmail: true,
                  validateEmptyString: true,
                  hintText: AppStrings.enterEmailHere.tr(),
                  onChanged: (value) {
                    if (value != driver!.email) {
                      setState(() {
                        enableUpdate = true;
                      });
                    }
                  },
                ),
                CustomTextInputField(
                  enabled: driver!.proceedFirstTimeApproval!,
                  labelText: AppStrings.nationalIdNumber.tr(),
                  showLabelText: true,
                  controller: _nationalIdController,
                  validateEmptyString: true,
                  hintText: AppStrings.nationalIDHint.tr(),
                  onChanged: (value) {
                    if (value != driver!.nationalId) {
                      setState(() {
                        enableUpdate = true;
                      });
                    }
                  },
                ),
                CustomTextInputField(
                  enabled: driver!.proceedFirstTimeApproval!,
                  labelText: AppStrings.plateNumber.tr(),
                  showLabelText: true,
                  controller: _plateNumberController,
                  validateEmptyString: true,
                  hintText: AppStrings.plateNumber.tr(),
                  onChanged: (value) {
                    if (value != driver!.plateNumber) {
                      setState(() {
                        enableUpdate = true;
                      });
                    }
                  },
                ),
                ListAndUpdateDocumentsImages(
                  enableUpdateDocuments: driver!.proceedFirstTimeApproval!,
                  title: AppStrings.carPhotos.tr(),
                  imagesUrl: carImagesUrls ?? [],
                  uploadMultipleImagesModel: true,
                  loadFromFiles: loadCarImagesFromFile,
                  onDataUpdated:
                      (imagesList, frontImage, backImage, expiryDate) {
                    if (imagesList != null && imagesList.isNotEmpty) {
                      carImagesUrls = [];
                      imagesList.forEach((_element) {
                        carImagesUrls!.add(_element.path);
                      });
                      setState(() {
                        enableUpdate = true;
                        loadCarImagesFromFile = true;
                      });
                    }
                  },
                ),
                ListAndUpdateDocumentsImages(
                  enableUpdateDocuments: driver!.proceedFirstTimeApproval!,
                  title: AppStrings.carDocumentsInfo.tr(),
                  imagesUrl: carDocumentImagesUrls ?? [],
                  expiryDate: carDocumentExpiryDate,
                  uploadMultipleImagesModel: false,
                  loadFromFiles: carDocumentImagesUrlsFromFile,
                  onDataUpdated:
                      (imagesList, frontImage, backImage, expiryDate) {
                    if (frontImage != null &&
                        frontImage.path.isNotEmpty &&
                        backImage != null &&
                        backImage.path.isNotEmpty &&
                        expiryDate != null &&
                        expiryDate.isNotEmpty) {
                      carDocumentImagesUrls = [];
                      carDocumentImagesUrls.add(frontImage.path);
                      carDocumentImagesUrls.add(backImage.path);
                      carDocumentExpiryDate = expiryDate;
                      setState(() {
                        enableUpdate = true;
                        carDocumentImagesUrlsFromFile = true;
                      });
                    }
                  },
                ),
                ListAndUpdateDocumentsImages(
                  enableUpdateDocuments: driver!.proceedFirstTimeApproval!,
                  title: AppStrings.carDriverLicenseInfo.tr(),
                  imagesUrl: driverLicenseImagesUrls ?? [],
                  expiryDate: driverLicenseExpiryDate,
                  uploadMultipleImagesModel: false,
                  loadFromFiles: driverLicenseFromFile,
                  onDataUpdated:
                      (imagesList, frontImage, backImage, expiryDate) {
                    if (frontImage != null &&
                        frontImage.path.isNotEmpty &&
                        backImage != null &&
                        backImage.path.isNotEmpty &&
                        expiryDate != null &&
                        expiryDate.isNotEmpty) {
                      driverLicenseImagesUrls = [];
                      driverLicenseImagesUrls.add(frontImage.path);
                      driverLicenseImagesUrls.add(backImage.path);
                      driverLicenseExpiryDate = expiryDate;
                      setState(() {
                        enableUpdate = true;
                        driverLicenseFromFile = true;
                      });
                    }
                  },
                ),
                ListAndUpdateDocumentsImages(
                  enableUpdateDocuments: driver!.proceedFirstTimeApproval!,
                  title: AppStrings.carDriverIdentityInfo.tr(),
                  imagesUrl: driverNationalIdImagesUrls ?? [],
                  expiryDate: driverNationalIdExpiryDate,
                  uploadMultipleImagesModel: false,
                  loadFromFiles: driverNationalIdFromFile,
                  onDataUpdated:
                      (imagesList, frontImage, backImage, expiryDate) {
                    if (frontImage != null &&
                        frontImage.path.isNotEmpty &&
                        backImage != null &&
                        backImage.path.isNotEmpty &&
                        expiryDate != null &&
                        expiryDate.isNotEmpty) {
                      driverNationalIdImagesUrls = [];
                      driverNationalIdImagesUrls.add(frontImage.path);
                      driverNationalIdImagesUrls.add(backImage.path);
                      driverNationalIdExpiryDate = expiryDate;
                      setState(() {
                        enableUpdate = true;
                        driverNationalIdFromFile = true;
                      });
                    }
                  },
                ),
                ListAndUpdateDocumentsImages(
                  enableUpdateDocuments: driver!.proceedFirstTimeApproval!,
                  title: AppStrings.carOwnerIdentityInfo.tr(),
                  imagesUrl: ownerNationalIdImagesUrls ?? [],
                  expiryDate: ownerNationalIdExpiryDate,
                  uploadMultipleImagesModel: false,
                  loadFromFiles: ownerNationalIdFromFile,
                  onDataUpdated:
                      (imagesList, frontImage, backImage, expiryDate) {
                    if (frontImage != null &&
                        frontImage.path.isNotEmpty &&
                        backImage != null &&
                        backImage.path.isNotEmpty &&
                        expiryDate != null &&
                        expiryDate.isNotEmpty) {
                      ownerNationalIdImagesUrls = [];

                      ownerNationalIdImagesUrls.add(frontImage.path);
                      ownerNationalIdImagesUrls.add(backImage.path);

                      ownerNationalIdExpiryDate = expiryDate;
                      setState(() {
                        enableUpdate = true;
                        ownerNationalIdFromFile = true;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: AppSize.s50,
                ),
                CustomTextButton(
                  text: AppStrings.save.tr(),
                  isWaitToEnable: true,
                  onPressed: enableUpdate
                      ? () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            BlocProvider.of<UpdateDriverBloc>(context).add(
                                EditDriverProfileDataEvent(
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    email: _emailController.text,
                                    nationalIdNumber: _nationalIdController
                                        .text,
                                    plateNumber: _plateNumberController.text,
                                    carImagesFromFile: loadCarImagesFromFile
                                        ? carImagesUrls
                                        : null,
                                    carDocumentsImagesFromFile:
                                        carDocumentImagesUrlsFromFile
                                            ? carDocumentImagesUrls
                                            : null,
                                    driverLicenseImagesFromFile:
                                        driverLicenseFromFile
                                            ? driverLicenseImagesUrls
                                            : null,
                                    driverNationalIdImagesFromFile:
                                        driverNationalIdFromFile
                                            ? driverNationalIdImagesUrls
                                            : null,
                                    ownerNationalIdImagesFromFile:
                                        ownerNationalIdFromFile
                                            ? ownerNationalIdImagesUrls
                                            : null,
                                    carDocumentExpiryDate:
                                        carDocumentExpiryDate!,
                                    driverLicenseExpiryDate:
                                        driverLicenseExpiryDate!,
                                    driverNationalIdExpiryDate:
                                        driverNationalIdExpiryDate!,
                                    ownerNationalIdExpiryDate:
                                        ownerNationalIdExpiryDate!));
                          }
                        }
                      : null,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _profilePhotoHeader() {
    return FutureBuilder<String>(
        future: getProfilePicPath(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: AppSize.s16),
              child: Row(
                children: [
                  Container(
                      width: AppSize.s60,
                      height: AppSize.s60,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: captainImagePath != null &&
                                  captainImagePath!.isNotEmpty
                              ? Image.file(File(captainImagePath!))
                              : CustomNetworkImageWidget(
                                  imageUrl: snapshot.data.toString(),
                                ))),
                  SizedBox(
                    width: AppSize.s16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          openImages();
                        },
                        child: Row(
                          children: [
                            Text(
                              AppStrings.changeCaptainPhoto.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ColorManager.primary,
                                      fontSize: FontSize.s14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  openImages() async {
    showModalBottomSheet(
        elevation: 10,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        var pickedFile = await imgPicker.pickImage(
                            source: ImageSource.gallery);
                        captainImagePath = pickedFile?.path ?? "";
                        setState(() {
                          enableUpdate = true;
                        });
                      } catch (e) {
                        ShowDialogHelper.showErrorMessage(
                            e.toString(), context);
                      }

                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.gallery.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () async {
                      try {
                        var pickedFile = await imgPicker.pickImage(
                          source: ImageSource.camera,
                        );
                        captainImagePath = pickedFile?.path ?? "";
                        setState(() {
                          enableUpdate = true;
                        });
                      } catch (e) {
                        ShowDialogHelper.showErrorMessage(
                            e.toString(), context);
                      }

                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.camera.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ],
              ),
            ));
  }
}

class UpdateDriverProfileArguments {
  DriverBaseModel driver;

  UpdateDriverProfileArguments(this.driver);
}
