import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';

class BottomSheetField extends StatefulWidget {
   BottomSheetField({
    Key? key,
    this.showLabelText = false,
    this.labelText,
    required this.hintText,
    required this.items,
    this.closeButton = true,
    this.hintStyle,
    this.isDismiss = true,
    this.initialChildSize = 0.3,
    this.maxChildSize = 0.94,
    this.minChildSize = 0.1,
    this.closeButtonAction,
    this.enableDrag = true,
    this.borderColor,
  }) : super(key: key);

  final bool showLabelText;
  final String? labelText;
  final String? hintText;
  final List<Widget> items;
  final bool closeButton;
  final TextStyle? hintStyle;
  final bool isDismiss;
  final bool enableDrag;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final VoidCallback? closeButtonAction;
  Color? borderColor;

  @override
  _BottomSheetFieldState createState() => _BottomSheetFieldState();
}

class _BottomSheetFieldState extends State<BottomSheetField> {
  var textStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Roboto-Medium',
    color: ColorManager.primary,
  );
  var textStyle2 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: ColorManager.primary,
  );

  @override
  Widget build(BuildContext context) {
    return widget.showLabelText
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.labelText!,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto-Medium',
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              _dropDownField(),
            ],
          )
        : _dropDownField();
  }

  _dropDownField() {
    return InkWell(
      onTap: () {
        CustomBottomSheet.heightWrappedBottomSheet(
            context: context,
            items: widget.items,
            showCloseButton: widget.closeButton,
            isDismiss: widget.isDismiss,
            enableDrag: widget.enableDrag,
            closeButtonAction: widget.closeButtonAction);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: widget.borderColor ?? ColorManager.borderColor,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.hintText!.trim(),
                overflow: TextOverflow.ellipsis,
                style: widget.hintStyle ??
                    TextStyle(
                      fontSize: 14,
                      fontFamily: 'Roboto-Medium',
                      color: ColorManager.hintTextColor,
                    ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: ColorManager.primary,
              size: 27,
            ),
          ],
        ),
      ),
    );
  }
}

abstract class CustomBottomSheet {
  static void displayModalBottomSheet(
      {required BuildContext context,
      bool isDismiss = true,
      required List<Widget> items,
      Color color = Colors.white,
      bool showCloseButton = true,
      bool draggableScrollableSheet = true,
      double initialChildSize = 0.3,
      double minChildSize = 0.1,
      double maxChildSize = 0.94,
      bool enableDrag = true,
      VoidCallback? closeButtonAction}) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      isDismissible: isDismiss,
      enableDrag: enableDrag,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                if (showCloseButton)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                          if (closeButtonAction != null) closeButtonAction();
                        },
                      ),
                    ],
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(children: items),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static void displayModalBottomSheetList(
      {required BuildContext context,
      bool isDismiss = true,
      required Widget customWidget,
      Color color = Colors.white,
      bool showCloseButton = true,
      bool draggableScrollableSheet = true,
      double initialChildSize = 0.3,
      double minChildSize = 0.1,
      double maxChildSize = 0.94,
      bool enableDrag = true,
      VoidCallback? closeButtonAction}) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      isDismissible: isDismiss,
      enableDrag: enableDrag,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                if (showCloseButton)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                          if (closeButtonAction != null) closeButtonAction();
                        },
                      ),
                    ],
                  ),
                Expanded(
                  child: customWidget,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static void heightWrappedBottomSheet({
    required BuildContext context,
    bool isDismiss = true,
    required List<Widget> items,
    Color color = Colors.white,
    bool showCloseButton = true,
    bool draggableScrollableSheet = true,
    bool scrollable = true,
    Widget? notScrollingView,
    bool enableDrag = true,
    VoidCallback? closeButtonAction,
    EdgeInsetsGeometry? margin,
    double radius = 25,
  }) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      isScrollControlled: true,
      isDismissible: isDismiss,
      enableDrag: enableDrag,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => scrollable
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
                ),
                color: Colors.white,
              ),
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                margin: margin ?? const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.only(top: 8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (showCloseButton)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              iconSize: 20,
                              icon: Icon(
                                Icons.close,
                              ),
                              onPressed: () {
                                if (closeButtonAction != null)
                                  closeButtonAction();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ...items
                    ],
                  ),
                ),
              ),
            )
          : notScrollingView ?? Container(),
    );
  }

  /// flexible height according to the child
  static void smallSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 6,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(25)),
          ),
          child,
        ],
      ),
    );
  }
}
