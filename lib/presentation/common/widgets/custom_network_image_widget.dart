import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';

class CustomNetworkImageWidget extends StatefulWidget {
  String imageUrl;

  CustomNetworkImageWidget({required this.imageUrl});

  @override
  State<CustomNetworkImageWidget> createState() =>
      _CustomNetworkImageWidgetState();
}

class _CustomNetworkImageWidgetState extends State<CustomNetworkImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FadeInImage(
      image: NetworkImage(widget.imageUrl),
      placeholder: AssetImage(ImageAssets.appIcon),
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset(ImageAssets.newAppBarLogo,
            color: ColorManager.splashBGColor, fit: BoxFit.fitWidth);
      },
      fit: BoxFit.fitWidth,
    ));
  }
}
