import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/styles_manager.dart';
import '../../../app/constants.dart';
import '../../../utils/dialogs/toast_handler.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../state_renderer/dialogs.dart';

class MutliPickImageWidget extends StatefulWidget {
  final Function(List<XFile>? images) onPickedImages;
  final Function(XFile images)? onRemovedImage;
  RegistrationRequest? registrationRequest;
  List<XFile>? selectedBeforeImages;
  final String titleText;
  final String btnText;
  final Widget btnIcon;
  final Color btnBackgroundColor;
  bool addMultiplePhotos;
  double? fontSize;

  MutliPickImageWidget(this.onPickedImages, this.titleText, this.btnText,
      this.btnIcon, this.btnBackgroundColor, this.registrationRequest,
      {this.addMultiplePhotos = true,
      this.onRemovedImage,
      this.fontSize,
      this.selectedBeforeImages});

  @override
  State<MutliPickImageWidget> createState() => _MutliPickImageWidgetState();
}

class _MutliPickImageWidgetState extends State<MutliPickImageWidget> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];

  @override
  void initState() {
    if (widget.registrationRequest != null &&
        widget.registrationRequest!.carImages != null &&
        widget.registrationRequest!.carImages!.isNotEmpty) {
      imagefiles.addAll(widget.registrationRequest!.carImages!);
    }
    super.initState();
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
                        if (widget.registrationRequest != null &&
                            widget.registrationRequest!.carImages != null &&
                            widget.registrationRequest!.carImages!.isNotEmpty &&
                            widget.registrationRequest!.carImages!.length >=
                                Constants.MAXIMUM_MULTI_PIC_IMAGES) {
                          setState(() {
                            imagefiles.clear();
                            widget.registrationRequest!.carImages!.clear();
                          });
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                        var pickedfiles = await imgpicker.pickMultiImage();
                        if (pickedfiles.length > 4) {
                          ToastHandler(context).showToast(
                              AppStrings.photo_limits_error.tr(),
                              Toast.LENGTH_LONG);
                        } else {
                          await Future.forEach<XFile>(pickedfiles,
                              (element) async {
                            String filePath = element.path;
                            final lastIndex =
                                filePath.lastIndexOf(RegExp(r'.jp'));
                            final splitted = filePath.substring(0, (lastIndex));
                            final outPath =
                                "${splitted}_out${filePath.substring(lastIndex)}";

                            var result =
                                await FlutterImageCompress.compressAndGetFile(
                              filePath,
                              outPath,
                              quality: Constants.IMAGE_QUALITY_COMPRESS,
                            );

                            if (result == null) return;
                            imagefiles.add(result);
                          });

                          widget.onPickedImages(imagefiles);
                          if (widget.registrationRequest != null) {
                            widget.registrationRequest!.carImages = imagefiles;
                          }
                          setState(() {});
                        }
                      } catch (e) {
                        // ToastHandler(context).showToast(
                        //     AppStrings.error_while_adding_images.tr(),
                        //     Toast.LENGTH_LONG);
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
                        if (widget.registrationRequest != null &&
                            widget.registrationRequest!.carImages != null &&
                            widget.registrationRequest!.carImages!.isNotEmpty &&
                            widget.registrationRequest!.carImages!.length >=
                                Constants.MAXIMUM_MULTI_PIC_IMAGES) {
                          setState(() {
                            imagefiles.clear();
                            widget.registrationRequest!.carImages!.clear();
                          });
                        }
                        var pickedfile = await imgpicker.pickImage(
                            source: ImageSource.camera);

                        if (pickedfile == null) return;

                        String filePath = pickedfile.path;
                        final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
                        final splitted = filePath.substring(0, (lastIndex));
                        final outPath =
                            "${splitted}_out${filePath.substring(lastIndex)}";

                        var result =
                            await FlutterImageCompress.compressAndGetFile(
                          filePath,
                          outPath,
                          quality: Constants.IMAGE_QUALITY_COMPRESS,
                        );
                        if (result == null) return;
                        imagefiles.add(result);
                        widget.onPickedImages(imagefiles);
                        setState(() {});
                        if (widget.registrationRequest != null) {
                          widget.registrationRequest!.carImages = imagefiles;
                        }
                        setState(() {});
                      } catch (e) {
                        // ToastHandler(context).showToast(
                        //     AppStrings.error_while_adding_images.tr(),
                        //     Toast.LENGTH_LONG);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 16, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "* ${AppStrings.photo_limits_warning.tr()} ${Constants.MAXIMUM_MULTI_PIC_IMAGES} ${AppStrings.photos_lower.tr()}",
            style: getRegularStyle(
                color: ColorManager.warningTextColor, fontSize: FontSize.s12),
          ),
          Text(
            widget.titleText,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: ColorManager.titlesTextColor),
          ),
          SizedBox(
            height: 10,
          ),
          imagefiles.isNotEmpty
              ? Wrap(
                  children: imagefiles.map((imageone) {
                    return Stack(
                      children: [
                        Card(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.file(File(imageone.path)),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.onRemovedImage != null
                                    ? widget.onRemovedImage!(imageone)
                                    : null;
                                imagefiles.remove(imageone);
                                if (widget.registrationRequest != null &&
                                    widget.registrationRequest!.carImages !=
                                        null &&
                                    widget.registrationRequest!.carImages!
                                        .isNotEmpty) {
                                  widget.registrationRequest!.carImages!
                                      .removeWhere(
                                          (element) => element == imageone);
                                }
                              });
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }).toList(),
                )
              : Container(),
          widget.addMultiplePhotos == false && imagefiles.length > 0
              ? Container()
              : CustomTextButton(
                  margin: 0,
                  text: widget.btnText.tr(),
                  isWaitToEnable: false,
                  fontSize: widget.fontSize,
                  backgroundColor: widget.btnBackgroundColor,
                  icon: widget.btnIcon,
                  onPressed: () {
                    openImages();
                  },
                ),
        ],
      ),
    );
  }
}
