import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../../app/constants.dart';
import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_text_button.dart';

class UpdateDocumentDataBottomSheet extends StatefulWidget {
  final bool uploadMultipleImagesModel;
  final Function(List<File>? uploadedImages, File? frontImage, File? backImage,
      String? expiryDate) onDataUpdated;

  UpdateDocumentDataBottomSheet(
      {required this.uploadMultipleImagesModel, required this.onDataUpdated});

  @override
  State<UpdateDocumentDataBottomSheet> createState() =>
      _UpdateDocumentDataBottomSheetState();
}

class _UpdateDocumentDataBottomSheetState
    extends State<UpdateDocumentDataBottomSheet> {
  List<File>? imagesList;
  File? frontImageDir;
  File? backImageDir;
  String? expiryDate;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: (!widget.uploadMultipleImagesModel)
                ? uploadFrontBackExpiryImagesModel()
                : uploadMultipleImagesModel(),
          ),
          Container(
            child: CustomTextButton(
              text: AppStrings.save.tr(),
              onPressed: () {
                widget.onDataUpdated(
                    imagesList, frontImageDir, backImageDir, expiryDate);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget uploadMultipleImagesModel() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.uploadPhotos.tr(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: FontSize.s20,
                fontWeight: FontWeight.normal,
                color: ColorManager.titlesTextColor),
          ),
          SizedBox(
            height: 10,
          ),
          imagesList != null && imagesList!.isNotEmpty
              ? Container(
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 5,
                    children: List.generate(
                        imagesList!.length,
                        (index) => Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    child: Image.file(imagesList![index]),
                                  )
                                ],
                              ),
                            )),
                  ),
                )
              : Container(
                  child: GestureDetector(
                    onTap: () async {
                      var pickedFiles = await _imagePicker.pickMultiImage();
                      if (pickedFiles != null && pickedFiles.isNotEmpty) {
                        List<File> files = [];
                        await Future.forEach(pickedFiles, (XFile file) {
                          files.add(File(file.path));
                        });
                        imagesList = files;
                        setState(() {
                          print(imagesList!.length);
                        });
                      }
                    },
                    child: SizedBox(
                        width: 100,
                        height: 150,
                        child: SvgPicture.asset(ImageAssets.photoCameraIc)),
                  ),
                )
        ],
      ),
    );
  }

  Widget uploadFrontBackExpiryImagesModel() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.frontImage.tr(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: FontSize.s20,
                fontWeight: FontWeight.normal,
                color: ColorManager.titlesTextColor),
          ),
          SizedBox(
            height: 10,
          ),
          CustomUploadImage(frontImageDir, true),
          Text(
            AppStrings.backImage.tr(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: FontSize.s20,
                fontWeight: FontWeight.normal,
                color: ColorManager.titlesTextColor),
          ),
          SizedBox(
            height: 10,
          ),
          CustomUploadImage(backImageDir, false),
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
          CustomExpiryDateWidget(),
        ],
      ),
    );
  }

  Widget CustomUploadImage(File? image, bool isFront) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (image != null)
            ? Container(
                child: SizedBox(
                    width: AppSize.s190,
                    height: AppSize.s190,
                    child: Image.file(File(image.path))))
            : Container(
                child: SizedBox(
                    width: 100,
                    height: 150,
                    child: SvgPicture.asset(ImageAssets.photoCameraIc))),
        Container(
          child: CustomTextButton(
            margin: 15,
            isWaitToEnable: false,
            backgroundColor: ColorManager.headersTextColor,
            text: AppStrings.uploadPhoto.tr(),
            onPressed: () {
              _showPicker(context, isFront);
            },
          ),
        )
      ],
    );
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3000, 1));
    if (picked != null) {
      setState(() {
        expiryDate = picked.millisecondsSinceEpoch.toString();
      });
    }
  }

  _showPicker(BuildContext context, bool isFront) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: Text(AppStrings.photoGallery.tr()),
                onTap: () {
                  _imageFrom(isFront, ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(AppStrings.photoCamera.tr()),
                onTap: () {
                  _imageFrom(isFront, ImageSource.camera);
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
        });
  }

  _imageFrom(bool isFront, ImageSource imageSource) async {
    var pickedImage = await _imagePicker.pickImage(
        source: imageSource, imageQuality: Constants.IMAGE_QUALITY_COMPRESS);
    if (pickedImage != null) {
      setState(() {
        if (isFront)
          frontImageDir = File(pickedImage.path);
        else
          backImageDir = File(pickedImage.path);
      });
    }
  }

  Widget CustomExpiryDateWidget() {
    return GestureDetector(
      onTap: () {
        _selectExpiryDate(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        height: AppSize.s46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorManager.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p2),
              child: Text(
                expiryDate != null
                    ? expiryDate!.getTimeStampFromDate(pattern: 'dd MMM yyyy')
                    : AppStrings.expiryDate.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: expiryDate != null
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
