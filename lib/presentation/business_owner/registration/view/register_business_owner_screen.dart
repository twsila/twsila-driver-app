import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/register_business_owner_viewmodel.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/header_widget.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/input_fields.dart';
import 'package:taxi_for_you/presentation/common/state_renderer/dialogs.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_scaffold.dart';
import 'package:taxi_for_you/presentation/common/widgets/page_builder.dart';
import 'package:taxi_for_you/presentation/login/bloc/login_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/bloc/serivce_registration_bloc.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/styles_manager.dart';
import '../../../common/widgets/custom_text_button.dart';

class RegisterBusinessOwnerScreen extends StatefulWidget {
  final String mobileNumber;
  final String countryCode;

  RegisterBusinessOwnerScreen(
      {Key? key, required this.mobileNumber, required this.countryCode})
      : super(key: key);

  @override
  State<RegisterBusinessOwnerScreen> createState() =>
      _RegisterBusinessOwnerScreenState();
}

class _RegisterBusinessOwnerScreenState
    extends State<RegisterBusinessOwnerScreen> {
  XFile? captainPhoto = XFile('');
  ImagePicker imgpicker = ImagePicker();
  final RegisterBusinessOwnerViewModel businessOwnerViewModel =
      RegisterBusinessOwnerViewModel();

  @override
  void initState() {
    businessOwnerViewModel.bind(widget.mobileNumber);
    super.initState();
  }

  @override
  void dispose() {
    businessOwnerViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginLoadingState) {
              setState(() {
                businessOwnerViewModel.displayLoadingIndicator = true;
              });
            } else {
              setState(() {
                businessOwnerViewModel.displayLoadingIndicator = false;
              });
            }
            if (state is LoginSuccessState) {
              businessOwnerViewModel.appPreferences.setUserLoggedIn();
              DriverBaseModel cachedDriver = state.driver;
              cachedDriver.captainType = RegistrationConstants.businessOwner;
              await businessOwnerViewModel.appPreferences
                  .setDriver(cachedDriver);
              DriverBaseModel? driver =
                  businessOwnerViewModel.appPreferences.getCachedDriver();
              if (driver != null) {
                Navigator.pushReplacementNamed(
                    context, Routes.welcomeToTwsilaBO);
              }
            }
            if (state is LoginFailState) {
              CustomDialog(context).showErrorDialog('', '', state.message);
            }
          },
          child: const SizedBox(),
        ),
        BlocListener<ServiceRegistrationBloc, ServiceRegistrationState>(
            listener: (context, state) {
              if (state is ServiceRegistrationLoading) {
                setState(() {
                  businessOwnerViewModel.displayLoadingIndicator = true;
                });
              } else {
                setState(() {
                  businessOwnerViewModel.displayLoadingIndicator = false;
                });
                if (state is ServiceBORegistrationSuccess) {
                  BlocProvider.of<LoginBloc>(context).add(
                    MakeLoginBOEvent(
                      businessOwnerViewModel.mobileNumberController.text,
                      widget.countryCode,
                    ),
                  );
                }
                if (state is ServiceRegistrationFail) {
                  CustomDialog(context).showErrorDialog('', '', state.message);

                  // Navigator.pushReplacementNamed(context, Routes.welcomeToTwsilaBO);
                }
              }
            },
            child: CustomScaffold(
              pageBuilder: PageBuilder(
                scaffoldKey: businessOwnerViewModel.scaffoldKey,
                context: context,
                resizeToAvoidBottomInsets: true,
                displayLoadingIndicator:
                    businessOwnerViewModel.displayLoadingIndicator,
                body: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppMargin.m20,
                    vertical: AppMargin.m12,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RegistrationBOHeaderWidget(),
                        const SizedBox(height: AppSize.s25),
                        _uploadBOPhoto(),
                        const SizedBox(height: AppSize.s28),
                        RegistartionBOInputFields(
                            viewModel: businessOwnerViewModel),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _uploadBOPhoto() {
    final hasPhoto = captainPhoto != null && captainPhoto!.path != "";
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: openImages,
        borderRadius: BorderRadius.circular(16),
        splashColor: ColorManager.primary.withOpacity(0.08),
        highlightColor: ColorManager.primary.withOpacity(0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20,
            vertical: AppPadding.p18,
          ),
          decoration: BoxDecoration(
            color: ColorManager.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorManager.primary.withOpacity(0.35),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              if (hasPhoto)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(captainPhoto!.path),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: ColorManager.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    ImageAssets.personIcon,
                    width: 32,
                    height: 32,
                    color: ColorManager.primary,
                  ),
                ),
              const SizedBox(width: AppSize.s16),
              Expanded(
                child: Text(
                  AppStrings.uploadBusinessOwnerPhoto.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                ),
              ),
              Icon(
                hasPhoto
                    ? Icons.edit_rounded
                    : Icons.add_photo_alternate_rounded,
                color: ColorManager.primary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  openImages() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: ColorManager.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      color: ColorManager.primary,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    AppStrings.gallery.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorManager.headersTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  onTap: () async {
                    try {
                      var pickedfile = await imgpicker.pickImage(
                          source: ImageSource.gallery);
                      setState(() {
                        captainPhoto = pickedfile;
                        businessOwnerViewModel.businessOwnerModel.profileImage =
                            captainPhoto;
                      });
                    } catch (e) {
                      ShowDialogHelper.showErrorMessage(e.toString(), context);
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: ColorManager.primary,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    AppStrings.camera.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorManager.headersTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  onTap: () async {
                    try {
                      var pickedfile =
                          await imgpicker.pickImage(source: ImageSource.camera);
                      setState(() {
                        captainPhoto = pickedfile;
                        businessOwnerViewModel.businessOwnerModel.profileImage =
                            captainPhoto;
                      });
                    } catch (e) {
                      ShowDialogHelper.showErrorMessage(e.toString(), context);
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BoRegistrationArguments {
  String mobileNumber;
  String countryCode;

  BoRegistrationArguments(this.mobileNumber, this.countryCode);
}
