import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/app/constants.dart';

import '../../../utils/location/map_provider.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/styles_manager.dart';

class GoogleMapsPlacesField extends StatefulWidget {
  TextEditingController controller;
  FocusNode focusNode;
  String? hintText;
  bool? enabled;
  Function(Prediction?) predictionCallback;

  GoogleMapsPlacesField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.predictionCallback,
    this.enabled = true,
    this.hintText,
  }) : super(key: key);

  @override
  State<GoogleMapsPlacesField> createState() => _GoogleMapsPlacesFieldState();
}

class _GoogleMapsPlacesFieldState extends State<GoogleMapsPlacesField> {
  Color fillColor = Colors.white70;
  List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        boxShadow: shadow,
      ),
      child: Focus(
        focusNode: widget.focusNode,
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              // fillColor = Colors.white;
              shadow = [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 1.0),
                )
              ];
            });
          } else {
            setState(() {
              // fillColor = Colors.white70;
              shadow = null;
            });
          }
        },
        child: Consumer<MapProvider>(builder: (context, mapProvider, _) {
          return GooglePlaceAutoCompleteTextField(
            textEditingController: widget.controller,
            googleAPIKey: Platform.isIOS
                ? Constants.GOOGLE_API_KEY_IOS
                : Constants.GOOGLE_API_KEY_ANDROID,
            debounceTime: 400,
            textStyle: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: ColorManager.black),
            // countries: const ["eg", "sa"],
            countries: mapProvider.countries,
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              widget.predictionCallback(prediction);
            },
            itemClick: (Prediction prediction) {
              if (prediction.description != null) {
                setState(() {
                  widget.controller.text = prediction.description!;
                });
                widget.controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description!.length));
                FocusScope.of(context).unfocus();
              }
            },
            inputDecoration: InputDecoration(
              enabled: widget.enabled!,
              contentPadding: const EdgeInsets.only(left: 8, right: 8),
              hintText: widget.hintText ?? "Search your location..",
              hintStyle: getRegularStyle(
                  color: ColorManager.grey, fontSize: FontSize.s14),
              // fillColor: fillColor,
              filled: true,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: ColorManager.error,
                ),
              ),
              suffixIcon: widget.controller.text == ''
                  ? null
                  : GestureDetector(
                      child: const Icon(Icons.cancel),
                      onTap: () {
                        setState(() {
                          widget.controller.text = '';
                          widget.predictionCallback(null);
                        });
                      },
                    ),
              focusedBorder: outlineBorder(),
              disabledBorder: outlineBorder(),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: ColorManager.error,
                ),
              ),
              enabledBorder: outlineBorder(),
            ),
          );
        }),
      ),
    );
  }

  OutlineInputBorder outlineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }
}
