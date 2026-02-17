import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_language_widget.dart';
import 'package:taxi_for_you/presentation/common/widgets/page_builder.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';

import 'custom_back_button.dart';
import 'loading_indicator.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({Key? key, required this.pageBuilder}) : super(key: key);

  final PageBuilder pageBuilder;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.pageBuilder.backButtonCallBack != null &&
            !widget.pageBuilder.displayLoadingIndicator) {
          widget.pageBuilder.backButtonCallBack!();
          return false;
        }
        return !widget.pageBuilder.displayLoadingIndicator;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: widget.pageBuilder.extendAppBarIntoSafeArea
              ? SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                      widget.pageBuilder.appBarForegroundColor == Colors.white
                          ? Brightness.light
                          : Brightness.dark,
                )
              : SystemUiOverlayStyle(
                  statusBarColor: widget.pageBuilder.appBarBackgroundColor ??
                      ColorManager.secondaryColor,
                  statusBarIconBrightness:
                      widget.pageBuilder.appBarForegroundColor == Colors.white
                          ? Brightness.light
                          : Brightness.dark,
                ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SafeArea(
                  top: !widget.pageBuilder.extendAppBarIntoSafeArea,
                  child: Scaffold(
                    key: widget.pageBuilder.scaffoldKey,
                    extendBodyBehindAppBar:
                        widget.pageBuilder.extendBodyBehindAppBar,
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset:
                        widget.pageBuilder.resizeToAvoidBottomInsets,
                    appBar: !widget.pageBuilder.appbar
                        ? null
                        : widget.pageBuilder.extendAppBarIntoSafeArea
                            ? _buildExtendedAppBar(context)
                            : AppBar(
                                automaticallyImplyLeading:
                                    widget.pageBuilder.allowBackButtonInAppBar,
                                primary: true,
                                systemOverlayStyle: SystemUiOverlayStyle(
                                  statusBarColor: widget
                                          .pageBuilder.appBarBackgroundColor ??
                                      ColorManager.secondaryColor,
                                  statusBarIconBrightness: widget.pageBuilder
                                              .appBarForegroundColor ==
                                          Colors.white
                                      ? Brightness.light
                                      : Brightness.dark,
                                ),
                                actions: widget.pageBuilder.appBarActions,
                                leading: (widget
                                        .pageBuilder.allowBackButtonInAppBar)
                                    ? Semantics(
                                        label: "Back_button",
                                        child: CustomBackButton(
                                          onPressed: () {
                                            FocusScope.of(
                                                    widget.pageBuilder.context)
                                                .unfocus();
                                            if (widget.pageBuilder
                                                    .backButtonCallBack !=
                                                null) {
                                              widget.pageBuilder
                                                  .backButtonCallBack!();
                                            } else {
                                              Navigator.pop(
                                                  widget.pageBuilder.context);
                                            }
                                          },
                                        ),
                                      )
                                    : widget.pageBuilder.showLanguageChange ==
                                            true
                                        ? Semantics(child: LanguageWidget())
                                        : null,
                                title: _buildAppbarTitle(),
                                backgroundColor:
                                    widget.pageBuilder.appBarBackgroundColor ??
                                        Colors.transparent,
                                foregroundColor:
                                    widget.pageBuilder.appBarForegroundColor ??
                                        ColorManager.blackTextColor,
                                scrolledUnderElevation: 0,
                                centerTitle:
                                    widget.pageBuilder.centerTitle ?? false,
                                iconTheme: IconThemeData(
                                  color: widget
                                          .pageBuilder.appBarForegroundColor ??
                                      Colors.black,
                                ),
                                elevation: widget.pageBuilder.elevation ?? 0,
                                shape: widget.pageBuilder.appBarShape,
                              ),
                    body: widget.pageBuilder.screenTitle != null
                        ? SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.pageBuilder.screenTitle!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                  _buildBody(widget.pageBuilder)
                                ],
                              ),
                            ),
                          )
                        : _buildBody(widget.pageBuilder),
                    floatingActionButton:
                        widget.pageBuilder.floatingActionButton,
                  ),
                ),
              ),
              if (widget.pageBuilder.displayLoadingIndicator) EasyLoader(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildExtendedAppBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final toolbarHeight = 56.0;
    final totalHeight = topPadding + toolbarHeight;
    final bgColor =
        widget.pageBuilder.appBarBackgroundColor ?? ColorManager.secondaryColor;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    Widget leadingWidget = const SizedBox(width: 8);
    if (widget.pageBuilder.allowBackButtonInAppBar) {
      leadingWidget = Semantics(
        label: "Back_button",
        child: CustomBackButton(
          onPressed: () {
            FocusScope.of(widget.pageBuilder.context).unfocus();
            if (widget.pageBuilder.backButtonCallBack != null) {
              widget.pageBuilder.backButtonCallBack!();
            } else {
              Navigator.pop(widget.pageBuilder.context);
            }
          },
        ),
      );
    } else if (widget.pageBuilder.showLanguageChange == true) {
      leadingWidget = Semantics(child: LanguageWidget());
    }

    Widget titleWidget = widget.pageBuilder.centerTitle == true
        ? Center(child: _buildAppbarTitle())
        : Align(
            alignment: AlignmentDirectional.centerStart,
            child: _buildAppbarTitle(),
          );

    Widget actionsWidget = const SizedBox.shrink();
    if (widget.pageBuilder.appBarActions != null) {
      actionsWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.pageBuilder.appBarActions!,
      );
    }

    // Same order for both: leading | title | actions. With RTL, the row flips
    // so leading is on the right and actions (icon) on the left.
    return PreferredSize(
      preferredSize: Size.fromHeight(totalHeight),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: widget.pageBuilder.appBarShape != null
              ? const BorderRadius.vertical(bottom: Radius.circular(24))
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: topPadding),
            SizedBox(
              height: toolbarHeight,
              child: Row(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  leadingWidget,
                  Expanded(child: titleWidget),
                  actionsWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildAppbarTitle() {
    final titleColor =
        widget.pageBuilder.appBarForegroundColor ?? ColorManager.blackTextColor;
    return widget.pageBuilder.appbarTitleWidget != null
        ? widget.pageBuilder.appbarTitleWidget
        : widget.pageBuilder.appBarTitle != null
            ? Text(
                widget.pageBuilder.appBarTitle!,
                style: TextStyle(
                    color: titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              )
            : null;
  }

  _buildBody(PageBuilder pageBuilder) {
    return pageBuilder.body;
  }
}
