import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_network_image_widget.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/edit_user_profile/bloc/edit_profile_bloc.dart';
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

class EditProfileView extends StatefulWidget {
  final DriverBaseModel driver;

  EditProfileView({required this.driver});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  bool _displayLoadingIndicator = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  AppPreferences _appPreferences = instance<AppPreferences>();
  String currentProfilePhoto = '';

  String? captainImagePath;
  ImagePicker imgPicker = ImagePicker();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  initState() {
    _firstNameController.text = widget.driver.firstName ?? '';
    _lastNameController.text = widget.driver.lastName ?? '';
    _mobileNumberController.text = widget.driver.mobile ?? '';
    _emailController.text = widget.driver.email ?? '';
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
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is EditProfileSuccess) {
          CustomDialog(context).showSuccessDialog(
              '', '', AppStrings.updateProfileDoneSuccessfully.tr(),
              onBtnPressed: () {
            Navigator.pushReplacementNamed(context, Routes.mainRoute);
          });
        }
        if (state is EditProfileError) {
          CustomDialog(context).showErrorDialog('', '', state.message);
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
                  onChanged: (value) {},
                ),
                CustomTextInputField(
                  labelText: AppStrings.lastName.tr(),
                  showLabelText: true,
                  controller: _lastNameController,
                  hintText: AppStrings.enterLastNameHere.tr(),
                  validateEmptyString: true,
                  onChanged: (value) {},
                ),
                CustomTextInputField(
                  labelText: AppStrings.jawalNumber.tr(),
                  showLabelText: true,
                  enabled: false,
                  controller: _mobileNumberController,
                  hintText: '',
                  onChanged: (value) {},
                ),
                CustomTextInputField(
                  labelText: AppStrings.email.tr(),
                  showLabelText: true,
                  controller: _emailController,
                  validateEmail: true,
                  validateEmptyString: true,
                  hintText: AppStrings.enterEmailHere.tr(),
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: AppSize.s50,
                ),
                CustomTextButton(
                  text: AppStrings.save.tr(),
                  isWaitToEnable: false,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      // BlocProvider.of<EditProfileBloc>(context).add(
                          // EditProfileDataEvent(
                          //     _firstNameController.text,
                          //     _lastNameController.text,
                          //     _emailController.text,
                          //     captainImagePath != null &&
                          //             captainImagePath!.isNotEmpty
                          //         ? File(captainImagePath!)
                          //         : null));
                    }
                  },
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
                          child:
                          captainImagePath != null && captainImagePath!.isNotEmpty
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
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                        setState(() {});
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
                        setState(() {});
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

class EditProfileArguments {
  DriverBaseModel driver;

  EditProfileArguments(this.driver);
}
