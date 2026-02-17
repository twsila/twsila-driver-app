import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/update_driver_profile/view/widgets/update_document_data_bottom_sheet.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/values_manager.dart';

class ListAndUpdateDocumentsImages extends StatefulWidget {
  String title;
  String? expiryDate;
  List<String> imagesUrl;
  bool loadFromFiles;
  double? margin;
  bool? enableUpdateDocuments;
  final bool uploadMultipleImagesModel;

  final Function(List<File>? uploadedImages, File? frontImage, File? backImage,
      String? expiryDate) onDataUpdated;

  ListAndUpdateDocumentsImages(
      {required this.title,
      this.expiryDate,
      required this.imagesUrl,
      this.margin,
      this.enableUpdateDocuments = true,
      this.loadFromFiles = false,
      required this.uploadMultipleImagesModel,
      required this.onDataUpdated});

  @override
  State<ListAndUpdateDocumentsImages> createState() =>
      _ListAndUpdateDocumentsImagesState();
}

class _ListAndUpdateDocumentsImagesState
    extends State<ListAndUpdateDocumentsImages> {
  @override
  Widget build(BuildContext context) {
    return documentImages(
        widget.imagesUrl, widget.title, widget.expiryDate ?? "");
  }

  Widget documentImages(
      List<String> imageUrls, String title, String expiryDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imageUrls.isNotEmpty
            ? loadImagesList(imageUrls, title, expiryDate)
            : noImagesUploaded(imageUrls, title),
        Container(
                child: CustomTextButton(
                  margin: 15,
                  isWaitToEnable: false,
                  backgroundColor: ColorManager.headersTextColor,
                  text: widget.enableUpdateDocuments!
                      ? AppStrings.updateData.tr()
                      : AppStrings.cannotUpdateDataForNow.tr(),
                  onPressed: widget.enableUpdateDocuments!
                      ? () {
                          bottomSheetForUpdateDocumentData(context);
                        }
                      : null,
                ),
              )
      ],
    );
  }

  bottomSheetForUpdateDocumentData(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return UpdateDocumentDataBottomSheet(
            uploadMultipleImagesModel: widget.uploadMultipleImagesModel,
            onDataUpdated: (List<File>? uploadedImages, File? frontImage,
                File? backImage, String? expiryDate) {
              widget.onDataUpdated(
                  uploadedImages, frontImage, backImage, expiryDate);
            },
          );
        });
  }

  Widget loadImagesList(
      List<String> imageUrls, String title, String expiryDate) {
    return Container(
      margin: EdgeInsets.all(widget.margin ?? AppMargin.m12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: FontSize.s16,
                fontWeight: FontWeight.normal,
                color: ColorManager.titlesTextColor),
          ),
          SizedBox(
            height: 8,
          ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 5,
            children: List.generate(
                imageUrls.length, (index) => TripImageItem(imageUrls[index])),
          ),
          expiryDate != ""
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${AppStrings.expiryDate.tr()} ${expiryDate.getTimeStampFromDate(pattern: 'dd MMM yyyy')}",
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.normal,
                          color: ColorManager.titlesTextColor),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget noImagesUploaded(List<String> imageUrls, String title) {
    return Container(
      child: Container(
        margin: EdgeInsets.all(widget.margin ?? AppMargin.m12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.normal,
                  color: ColorManager.titlesTextColor),
            ),
            SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                AppStrings.no_images.tr(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.normal,
                    color: ColorManager.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageUrlWithHandle(String url) {
    try {
      return SizedBox(
        height: 75,
        width: 75,
        child: FullScreenWidget(
          disposeLevel: DisposeLevel.Medium,
          child: Hero(
            tag: "customTag${Random.secure().nextInt(99999999)}",
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: widget.loadFromFiles
                    ? Container(
                        height: 100.0,
                        width: 100.0,
                        child: Image.file(File(url)))
                    : Image.network(
                        url,
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                              child: CircularProgressIndicator(
                            color: ColorManager.primary,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ));
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            ImageAssets.newAppBarLogo,
                            color: ColorManager.splashBGColor,
                          );
                        },
                      )),
          ),
        ),
      );
    } catch (e) {
      return Image.asset(
        ImageAssets.newAppBarLogo,
        color: ColorManager.splashBGColor,
      );
    }
  }

  Widget TripImageItem(String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrlWithHandle(imageUrl),
        ],
      ),
    );
  }
}
