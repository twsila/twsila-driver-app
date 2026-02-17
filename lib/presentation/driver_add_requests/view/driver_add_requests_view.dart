import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_card.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_network_image_widget.dart';
import 'package:taxi_for_you/presentation/driver_add_requests/bloc/driver_requests_bloc.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';

import '../../../domain/model/add_request_model.dart';
import '../../../utils/ext/enums.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';

class DriverAddRequestsView extends StatefulWidget {
  DriverAddRequestsView();

  @override
  State<DriverAddRequestsView> createState() => _DriverAddRequestsViewState();
}

class _DriverAddRequestsViewState extends State<DriverAddRequestsView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  List<AddRequestModel> requests = [];

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
  void initState() {
    BlocProvider.of<DriverRequestsBloc>(context).add(getAddRequests());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: true,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        appBarTitle: AppStrings.addRequestsFromBo.tr(),
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: true,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<DriverRequestsBloc, DriverRequestsState>(
        listener: (context, state) {
      if (state is DriverRequestsLoading) {
        startLoading();
      } else {
        stopLoading();
      }
      if (state is DriverRequestsSuccess) {
        requests = state.requests;
      }
      if (state is RequestStatusChanged) {
        CustomDialog(context).showSuccessDialog(
            '',
            '',
            state.driverAcquisitionEnum.name ==
                    DriverAcquisitionEnum.ACCEPTED.name
                ? AppStrings.requestAccepted.tr()
                : AppStrings.requestRejected.tr(), onBtnPressed: () {
          BlocProvider.of<DriverRequestsBloc>(context).add(getAddRequests());
        });
      }
      if (state is DriverRequestsFailure) {
        CustomDialog(context).showErrorDialog('', '', state.message);
      }
    }, builder: (context, state) {
      return requests.isEmpty
          ? Center(
              child: Text(
              AppStrings.noRequestsFound.tr(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: FontSize.s16,
                  color: ColorManager.error),
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: requests.length,
              itemBuilder: (context, i) {
                return RequestItemView(requests[i]);
              },
            );
    });
  }

  Widget RequestItemView(AddRequestModel requestModel) {
    return CustomCard(
        bodyWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   timeAgo(requestModel.creationDate),
            //   style: Theme
            //       .of(context)
            //       .textTheme
            //       .titleMedium
            //       ?.copyWith(
            //       color: ColorManager.headersTextColor,
            //       fontSize: FontSize.s14,
            //       fontWeight: FontWeight.bold),
            // )
            Row(
              children: [
                Container(
                    width: 50,
                    height: 50,
                    child: CustomNetworkImageWidget(
                        imageUrl: requestModel
                            .businessOwner.imagesFromApi![1].imageUrl
                            .toString())),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    "${requestModel.businessOwner.firstName}  ${requestModel.businessOwner.lastName} ${AppStrings.hasSent.tr()} ${AppStrings.addRequest.tr()} ${AppStrings.toYou.tr()}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: const Divider(
                height: 2,
                color: ColorManager.dividerColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<DriverRequestsBloc>(context).add(
                        changeRequestStatus(
                            requestModel.id, DriverAcquisitionEnum.ACCEPTED));
                  },
                  child: Container(
                    child: Center(
                        child: Text(
                      "${AppStrings.accept.tr()}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorManager.green,
                          fontSize: FontSize.s17,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                VerticalDivider(
                  color: ColorManager.dividerColor,
                  thickness: 5,
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<DriverRequestsBloc>(context).add(
                        changeRequestStatus(
                            requestModel.id, DriverAcquisitionEnum.REJECTED));
                  },
                  child: Container(
                    child: Center(
                        child: Text(
                      "${AppStrings.reject.tr()}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorManager.error,
                          fontSize: FontSize.s17,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                )
              ],
            )
          ],
        ),
        onClick: () {});
  }
}
