import 'package:taxi_for_you/app/extensions.dart';
import 'package:taxi_for_you/domain/model/coast_calculation_model.dart';

/// Legacy client-side splits for trip list / accept-offer flows.
///
/// **Avoid for new features:** offer/trip pricing should use the backend
/// (`/api/v1/pricing/calculate/...`, [PricingRepo], persisted breakdowns) so
/// VAT and commission updates ship from the server without an app release.
/// This helper remains only until those call sites are migrated.
class CoastCalculationsHelper {
  double getDriverShareFromAmount(
      CoastCalculationModel coastCalculationModel, double amount) {


    double addedValueTax =
       amount * coastCalculationModel.vatForPassenger;

    double tawsilaShareAmount =
        (amount - addedValueTax) * coastCalculationModel.twsilaCommissionForPassenger;



    return (amount - (tawsilaShareAmount + addedValueTax)).toPrecision(2);
  }
  double getTotalAmountFromDriverOffer(
      CoastCalculationModel coastCalculationModel, double amount) {


    double captainShareAmount =
        amount;

    double tawsilaShareAmount =
        amount *
            coastCalculationModel
                .twsilaCommissionForDriverAndBo;

    double addedValueTax =
        (amount +
            tawsilaShareAmount) *
            coastCalculationModel.vatForDriverAndBo;

    double allTripCalculatedAmount = (addedValueTax +
        tawsilaShareAmount +
        captainShareAmount).toPrecision(2);



    return allTripCalculatedAmount;
  }
}
