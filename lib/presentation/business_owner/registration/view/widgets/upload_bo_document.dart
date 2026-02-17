import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/documents_helper.dart';


class UploadBoDocumentView extends StatefulWidget {
  Documents Document;

  UploadBoDocumentView({required this.Document});

  @override
  State<UploadBoDocumentView> createState() => _UploadBoDocumentViewState();
}

class _UploadBoDocumentViewState extends State<UploadBoDocumentView> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return SingleChildScrollView(
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         CustomCard(
    //             bodyWidget: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 const SizedBox(
    //                   height: AppSize.s8,
    //                 ),
    //                 Text(
    //                   front,
    //                   style: getRegularStyle(
    //                       color: ColorManager.black, fontSize: FontSize.s18),
    //                 ),
    //                 const SizedBox(height: AppSize.s8),
    //                 _getMediaWidget(0, documents)
    //               ],
    //             ),
    //             onClick: () {}),
    //         CustomCard(
    //             bodyWidget: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 const SizedBox(
    //                   height: AppSize.s8,
    //                 ),
    //                 Text(
    //                   back,
    //                   style: getRegularStyle(
    //                       color: ColorManager.black, fontSize: FontSize.s18),
    //                 ),
    //                 const SizedBox(
    //                   height: AppSize.s8,
    //                 ),
    //                 _getMediaWidget(1, documents)
    //               ],
    //             ),
    //             onClick: () {}),
    //         CustomCard(
    //             bodyWidget: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 const SizedBox(
    //                   height: AppSize.s8,
    //                 ),
    //                 Text(
    //                   expiry,
    //                   style: getRegularStyle(
    //                       color: ColorManager.black, fontSize: FontSize.s18),
    //                 ),
    //                 const SizedBox(
    //                   height: AppSize.s8,
    //                 ),
    //                 expiryDate != null && expiryDate!.isNotEmpty
    //                     ? Row(
    //                   children: [
    //                     Flexible(
    //                       flex: 1,
    //                       child: Text(
    //                         AppStrings.selectDate.tr(),
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .titleMedium
    //                             ?.copyWith(
    //                             color:
    //                             ColorManager.headersTextColor),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       width: AppSize.s6,
    //                     ),
    //                     Flexible(
    //                       flex: 4,
    //                       child: Container(
    //                         padding: EdgeInsets.all(AppPadding.p8),
    //                         decoration: BoxDecoration(
    //                             border: Border.all(
    //                                 color: ColorManager.borderColor),
    //                             borderRadius: BorderRadius.circular(2)),
    //                         child: Row(
    //                           mainAxisAlignment:
    //                           MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             Text(
    //                               expiryDate!.getTimeStampFromDate(
    //                                   pattern: 'dd MMM yyyy'),
    //                               style: Theme.of(context)
    //                                   .textTheme
    //                                   .titleMedium
    //                                   ?.copyWith(
    //                                   color: ColorManager
    //                                       .headersTextColor),
    //                             ),
    //                             GestureDetector(
    //                               onTap: () {
    //                                 setState(() {
    //                                   expiryDate = null;
    //                                 });
    //                               },
    //                               child: Icon(
    //                                 Icons.delete,
    //                                 color: ColorManager.error,
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 )
    //                     : CustomDatePickerWidget(
    //                     labelText: AppStrings.selectDate.tr(),
    //                     onSelectDate: (date) {
    //                       expiryDate = date;
    //                       documentData.expireDate = date;
    //
    //                       BlocProvider.of<ServiceRegistrationBloc>(
    //                           context)
    //                           .add(SetDocumentForView(
    //                           documentPicked: 2, expireDate: date));
    //                     },
    //                     pickTime: false)
    //               ],
    //             ),
    //             onClick: () {}),
    //         Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: CustomTextButton(
    //               onPressed: () {
    //                 setState(() {
    //                   if (documentData.frontImage != null &&
    //                       documentData.backImage != null &&
    //                       documentData.expireDate != null) {
    //                     documentData.document = selectedDocument;
    //                     BlocProvider.of<ServiceRegistrationBloc>(context).add(
    //                         ChangeDocumentStatus(
    //                             selectedDocument, documentData));
    //                   }
    //                   _pageController.jumpToPage(
    //                     0,
    //                   );
    //                 });
    //               },
    //               text: AppStrings.finish.tr(),
    //             ))
    //       ],
    //     ),
    //   ),
    // ),
  }
}
