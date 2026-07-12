import 'package:flutter/material.dart';

import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/domain/model/trip_details_model.dart';
import 'package:taxi_for_you/presentation/rate_passenger/view/rate_passenger_view.dart';

class TripFlowPopups {
  static Future<bool?> showRatePassenger(
    BuildContext context,
    TripDetailsModel trip,
  ) {
    initRatePassengerModule();
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(sheetContext).padding.top + 48,
        ),
        child: RatePassengerView(
          tripDetailsModel: trip,
          isPopup: true,
        ),
      ),
    );
  }
}
