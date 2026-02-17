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
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../utils/resources/constants_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/state_renderer/dialogs.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/custom_text_input_field.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/update_bo_bloc.dart';

class UpdateBoProfileView extends StatefulWidget {
  final BusinessOwnerModel boUser;

  UpdateBoProfileView({required this.boUser});

  @override
  State<UpdateBoProfileView> createState() => _UpdateBoProfileViewState();
}

class _UpdateBoProfileViewState extends State<UpdateBoProfileView> {
  bool _displayLoadingIndicator = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  ImagePicker imgPicker = ImagePicker();
  AppPreferences _appPreferences = instance<AppPreferences>();
  String currentProfilePhoto = '';
  BusinessOwnerModel? boUser;
  bool enableUpdate = false;

  String? boImagePath;

  String? birthDate;
  String? nationalIdExpiryDate;
  String? commercialRegisterExpiryDate;
  bool proceedFirstTimeApproval = false;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _entityNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _taxNumberController = TextEditingController();
  TextEditingController _taxCommercialNumberController =
      TextEditingController();
  TextEditingController _nationalIdController = TextEditingController();

  String? dateOfBirth;

  bool loadBusinessEntityImagesFromFile = false;

  List<String> businessEntityImages = [];

  @override
  initState() {
    boUser = widget.boUser;
    _firstNameController.text = boUser!.firstName ?? '';
    _lastNameController.text = boUser!.lastName ?? '';
    _entityNameController.text = boUser!.entityName ?? '';
    _emailController.text = boUser!.email ?? '';
    _taxNumberController.text = boUser!.taxNumber ?? '';
    _taxCommercialNumberController.text = boUser!.commercialNumber ?? '';
    _nationalIdController.text = boUser!.nationalId ?? '';
    birthDate = boUser!.dateOfBirth ?? '';
    commercialRegisterExpiryDate = boUser!.commercialRegisterExpiryDate ?? '';
    nationalIdExpiryDate = boUser!.nationalIdExpiryDate ?? '';
    proceedFirstTimeApproval = boUser!.proceedFirstTimeApproval ?? false;

    BlocProvider.of<UpdateBoBloc>(context)
        .add(splitAndOrganizeImagesList(boImagesList: boUser!.imagesFromApi!));
    super.initState();
  }

  Future<String> getProfilePicPath() async {
    return _appPreferences.userProfilePicture(widget.boUser,
        userType: RegistrationConstants.businessOwner);
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
    return BlocConsumer<UpdateBoBloc, UpdateBoState>(
      listener: (context, state) {
        if (state is UpdateBoLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is BoOptimizedImagesSuccessState) {
          businessEntityImages = state.entityImagesUrls;
        }

        if (state is UpdateBoSuccess) {
          CustomDialog(context).showSuccessDialog(
              '', '', AppStrings.updateProfileDoneSuccessfully.tr(),
              onBtnPressed: () {
            Navigator.pushReplacementNamed(context, Routes.mainRoute);
          });
        }
        if (state is UpdateBoFail) {
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
                    if (value != boUser!.firstName) {
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
                    if (value != boUser!.lastName) {
                      setState(() {
                        enableUpdate = true;
                      });
                    }
                  },
                ),
                Text(
                  AppStrings.birtDate.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: ColorManager.headersTextColor),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomBirthDateWidget(),
                CustomTextInputField(
                  labelText: AppStrings.companyName.tr(),
                  showLabelText: true,
                  enabled: proceedFirstTimeApproval,
                  controller: _entityNameController,
                  hintText: '',
                  onChanged: (value) {
                    if (value != boUser!.entityName) {
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
                    if (value != boUser!.email) {
                      setState(() {
                        enableUpdate = true;
                      });
                    }
                  },
                ),
                CustomTextInputField(
                  enabled: proceedFirstTimeApproval,
                  labelText: AppStrings.taxNumber.tr(),
                  showLabelText: true,
                  controller: _taxNumberController,
                  validateEmptyString: true,
                  hintText: AppStrings.taxNumber.tr(),
                  onChanged: (value) {
                    if (value != boUser!.taxNumber) {
                      setState(() {
                        enableUpdate = true;
                      });
                    }
                  },
                ),
                CustomTextInputField(
                  enabled: proceedFirstTimeApproval,
                  labelText: AppStrings.commercialNumber.tr(),
                  showLabelText: true,
                  controller: _taxCommercialNumberController,
                  validateEmptyString: true,
                  hintText: AppStrings.commercialNumberHint.tr(),
                  onChanged: (value) {},
                ),
                Text(
                  AppStrings.commercialExpiryDate.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: ColorManager.headersTextColor),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomCommercialNumberExpiryDateWidget(),
                CustomTextInputField(
                  enabled: proceedFirstTimeApproval,
                  labelText: AppStrings.nationalIdNumber.tr(),
                  showLabelText: true,
                  controller: _nationalIdController,
                  validateEmptyString: true,
                  hintText: AppStrings.nationalIDHint.tr(),
                  onChanged: (value) {
                    if (value != boUser!.nationalId) {
                      setState(() {
                        enableUpdate = true;
                      });
                    }
                  },
                ),
                Text(
                  AppStrings.nationalIdExpiryDate.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: ColorManager.headersTextColor),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomNationalIdExpiryDateWidget(),
                ListAndUpdateDocumentsImages(
                  enableUpdateDocuments: proceedFirstTimeApproval,
                  title: AppStrings.boImage.tr(),
                  imagesUrl: businessEntityImages ?? [],
                  uploadMultipleImagesModel: true,
                  loadFromFiles: loadBusinessEntityImagesFromFile,
                  onDataUpdated:
                      (imagesList, frontImage, backImage, expiryDate) {
                    if (imagesList != null && imagesList.isNotEmpty) {
                      businessEntityImages = [];
                      imagesList.forEach((_element) {
                        businessEntityImages.add(_element.path);
                      });
                      setState(() {
                        enableUpdate = true;
                        loadBusinessEntityImagesFromFile = true;
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
                            BlocProvider.of<UpdateBoBloc>(context).add(
                                EditBoProfileDataEvent(
                                    boUser!.id,
                                    _firstNameController.text,
                                    _lastNameController.text,
                                    _entityNameController.text,
                                    _emailController.text,
                                    _taxNumberController.text,
                                    _taxCommercialNumberController.text,
                                    _nationalIdController.text,
                                    loadBusinessEntityImagesFromFile
                                        ? businessEntityImages
                                        : null,
                                    nationalIdExpiryDate,
                                    commercialRegisterExpiryDate));
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
                          child: boImagePath != null && boImagePath!.isNotEmpty
                              ? Image.file(File(boImagePath!))
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
                        boImagePath = pickedFile?.path ?? "";
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
                        boImagePath = pickedFile?.path ?? "";
                        setState(() {
                          enableUpdate = true;});
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

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3000, 1));
    if (picked != null) {
      setState(() {
        birthDate = picked.millisecondsSinceEpoch.toString();
      });
    }
  }

  Future<void> _selectNationalIdExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3000, 1));
    if (picked != null) {
      setState(() {
        nationalIdExpiryDate = picked.millisecondsSinceEpoch.toString();
      });
    }
  }

  Future<void> _selectCommercialNumberExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3000, 1));
    if (picked != null) {
      setState(() {
        commercialRegisterExpiryDate = picked.millisecondsSinceEpoch.toString();
      });
    }
  }

  Widget CustomNationalIdExpiryDateWidget() {
    return GestureDetector(
      onTap: proceedFirstTimeApproval
          ? () {
              _selectNationalIdExpiryDate(context);
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        margin: EdgeInsets.symmetric(horizontal: AppMargin.m12),
        height: AppSize.s46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: proceedFirstTimeApproval
                ? null
                : ColorManager.primaryBlueBackgroundColor,
            border: Border.all(color: ColorManager.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p2),
              child: Text(
                nationalIdExpiryDate != null
                    ? nationalIdExpiryDate!
                        .getTimeStampFromDate(pattern: 'dd MMM yyyy')
                    : AppStrings.nationalIdExpiryDate.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: nationalIdExpiryDate != null
                        ? ColorManager.headersTextColor
                        : ColorManager.hintTextColor),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomCommercialNumberExpiryDateWidget() {
    return GestureDetector(
      onTap: proceedFirstTimeApproval
          ? () {
              _selectCommercialNumberExpiryDate(context);
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        margin: EdgeInsets.symmetric(horizontal: AppMargin.m12),
        height: AppSize.s46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: proceedFirstTimeApproval
                ? null
                : ColorManager.primaryBlueBackgroundColor,
            border: Border.all(color: ColorManager.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p2),
              child: Text(
                commercialRegisterExpiryDate != null
                    ? commercialRegisterExpiryDate!
                        .getTimeStampFromDate(pattern: 'dd MMM yyyy')
                    : AppStrings.commercialExpiryDateHint.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: commercialRegisterExpiryDate != null
                        ? ColorManager.headersTextColor
                        : ColorManager.hintTextColor),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomBirthDateWidget() {
    return GestureDetector(
      onTap: proceedFirstTimeApproval
          ? () {
              _selectBirthDate(context);
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        margin: EdgeInsets.symmetric(horizontal: AppMargin.m12),
        height: AppSize.s46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: proceedFirstTimeApproval
                ? null
                : ColorManager.primaryBlueBackgroundColor,
            border: Border.all(color: ColorManager.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p2),
              child: Text(
                birthDate != null
                    ? birthDate!.getTimeStampFromDate(pattern: 'dd MMM yyyy')
                    : AppStrings.birtDateHint.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: birthDate != null
                        ? ColorManager.headersTextColor
                        : ColorManager.hintTextColor),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateBoProfileArguments {
  BusinessOwnerModel businessOwnerModel;

  UpdateBoProfileArguments(this.businessOwnerModel);
}
