import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_for_you/domain/model/coast_calculation_model.dart';
import 'package:taxi_for_you/presentation/coast_calculation/helpers/coast_calculations_helper.dart';

void main() {
  late CoastCalculationModel coastCalculationModel;

  // Set up global object once before all tests
  setUpAll(() {
    //current trip coast calculation
    // "twsilaCommissionForDriverAndBO": 0.176470588,
    // "twsilaCommissionForPassenger": 0.15,
    // "vatForDriverAndBo": 0.15,
    // "vatForPassenger": 0.130434783

    coastCalculationModel = CoastCalculationModel(
        twsilaCommissionForDriverAndBo: 0.176470588,
        twsilaCommissionForPassenger: 0.15,
        vatForDriverAndBo: 0.15,
        vatForPassenger: 0.130434783);
  });
  group('CostCalculation', () {
    test(
        'get driver share from amount ( amount is 5000 ) (driver share is  3,695.65) ',
        () {
      //ARRANGE

      double totalTripCost = 5000;

      //ACT

      double result = CoastCalculationsHelper()
          .getDriverShareFromAmount(coastCalculationModel, totalTripCost);

      //EXPECT

      expect(result, 3695.65);
    });

    test(
        'get all trip cost from driver offer ( driver offer is 4000 ) (all trip cost is   5,411.7)',
        () {
          //ARRANGE

          double driverOffer = 4000;

          //ACT

          double result = CoastCalculationsHelper()
              .getTotalAmountFromDriverOffer(coastCalculationModel, driverOffer);

          //EXPECT

          expect(result, 5411.76);
    });
  });
}
