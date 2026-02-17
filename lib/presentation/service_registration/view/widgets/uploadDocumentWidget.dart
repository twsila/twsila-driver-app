import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/styles_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_text_button.dart';
import '../../bloc/serivce_registration_bloc.dart';
import '../helpers/documents_helper.dart';

class UploadDocumentWidget extends StatefulWidget {
  String title;
  String buttonTitle;
  Widget iconWidget;
  DocumentType documentTypeFront;
  DocumentType documentTypeBack;
  PageController pageController;
  Function()? onButtonPressed;

  UploadDocumentWidget(
      this.title,
      this.buttonTitle,
      this.iconWidget,
      this.documentTypeFront,
      this.documentTypeBack,
      this.pageController,
      this.onButtonPressed);

  @override
  State<UploadDocumentWidget> createState() => _UploadDocumentWidgetState();
}

class _UploadDocumentWidgetState extends State<UploadDocumentWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceRegistrationBloc, ServiceRegistrationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: getRegularStyle(
                    color: ColorManager.titlesTextColor,
                    fontSize: FontSize.s14),
              ),
              CustomTextButton(
                text: widget.buttonTitle,
                width: AppSize.s140,
                height: AppSize.s50,
                isWaitToEnable: false,
                fontSize: FontSize.s10,
                backgroundColor: ColorManager.secondaryColor,
                icon: widget.iconWidget,
                onPressed: () async {
                  widget.onButtonPressed!();
                },
              )
            ],
          ),
        );
      },
    );
  }
}
