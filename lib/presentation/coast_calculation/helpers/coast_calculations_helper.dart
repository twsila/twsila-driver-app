import 'package:taxi_for_you/app/extensions.dart';
import 'package:taxi_for_you/domain/model/coast_calculation_model.dart';

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
