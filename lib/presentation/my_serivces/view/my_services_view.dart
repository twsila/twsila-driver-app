import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/presentation/my_serivces/bloc/my_services_bloc.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';

class MyServicesView extends StatefulWidget {
  const MyServicesView({Key? key}) : super(key: key);

  @override
  State<MyServicesView> createState() => _MyServicesViewState();
}

class _MyServicesViewState extends State<MyServicesView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  String status = "";

  @override
  void initState() {
    // BlocProvider.of<MyServicesBloc>(context).add(GetServiceStatus());
    super.initState();
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
          appBarTitle: AppStrings.myServices.tr(),
          centerTitle: true),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<MyServicesBloc, MyServicesState>(
      listener: (context, state) {
        if (state is ServiceStatusLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is ServiceStatusSuccess) {
          status = state.status;
        }
      },
      builder: (context, state) {
        return Container(
            width: double.infinity,
            child: Card(
              elevation: AppSize.s2,
              shadowColor: ColorManager.lightGrey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                  side:
                      BorderSide(color: ColorManager.white, width: AppSize.s1)),
              child: Wrap(children: [
                Container(
                  margin: EdgeInsets.all(AppSize.s12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: ColorManager.accentColor,
                                  borderRadius: BorderRadius.circular(3)),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSize.s6),
                                child: Text(
                                  status == "PENDING"
                                      ? AppStrings.pending.tr()
                                      : status,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: ColorManager.accentTextColor,
                                          fontSize: FontSize.s12,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              'نوع الخدمة',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: ColorManager.headersTextColor,
                                      fontSize: FontSize.s20,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'نوع المركبة',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: ColorManager.headersTextColor,
                                      fontSize: FontSize.s16,
                                      fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        ImageAssets.newAppBarLogo,
                        width: AppSize.s90,
                        color: ColorManager.splashBGColor,
                      )
                    ],
                  ),
                ),
              ]),
            ));
      },
    );
  }
}
