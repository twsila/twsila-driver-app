import 'package:flutter/material.dart';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';

import 'package:taxi_for_you/presentation/trip_execution/view/widgets/bottom_info_widget.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/widgets/customer_info_draggable.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/widgets/map_widget.dart';

import '../../../domain/model/trip_details_model.dart';

class TrackingPage extends StatefulWidget {
  final TripDetailsModel tripModel;
  final int currentStepIndex;
  final String currentTripStatus;

  TrackingPage({
    Key? key,
    required this.tripModel,
    required this.currentStepIndex,
    required this.currentTripStatus,
  }) : super(key: key);

  @override
  State<TrackingPage> createState() => TrackingPageState();
}

class TrackingPageState extends State<TrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ExpandableBottomSheet(
        animationCurveExpand: Curves.easeInToLinear,
        enableToggle: true,
        background: MapWidget(
          key: ValueKey(
              '${widget.currentStepIndex}_${widget.currentTripStatus}'),
          tripModel: widget.tripModel,
          currentStepIndex: widget.currentStepIndex,
          currentTripStatus: widget.currentTripStatus,
        ),
        persistentHeader: CustomerInfoHeader(
          tripModel: widget.tripModel,
        ),
        expandableContent: BottomInfoWidget(
          tripModel: widget.tripModel,
        ),
      ),
    );
  }
}

class NavigationTrackingArguments {
  TripDetailsModel tripModel;
  int currentStepIndex;
  String currentTripStatus;

  NavigationTrackingArguments(
    this.tripModel, {
    required this.currentStepIndex,
    required this.currentTripStatus,
  });
}
