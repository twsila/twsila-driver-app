import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moyasar/moyasar.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../utils/dialogs/custom_dialog.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/langauge_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen();

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final AppPreferences appPreferences = instance();
  PaymentConfig paymentConfig = PaymentConfig(
      publishableApiKey: PaymentConstants.PRODUCTION_KEY,
      amount: 200 * 100,
      description: 'order #1324',
      metadata: {'size': '250g'});
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;

  @override
  void initState() {
    paymentConfig.creditCard = CreditCardConfig(saveCard: false, manual: false);
    super.initState();
  }

  void onPaymentResult(result) {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.paid:
          CustomDialog(context).showSuccessDialog(
              '', '', AppStrings.paymentSuccess.tr(), onBtnPressed: () {
            Navigator.pop(context);
          });
          break;
        case PaymentStatus.failed:
          CustomDialog(context).showErrorDialog(
              '',
              '',
              AppStrings.paymentFailed.tr() +
                  result.source.message.toString().tr(), onBtnPressed: () {
            Navigator.pop(context);
          });
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: false,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: false,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.enterCreditCardData.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: ColorManager.headersTextColor, fontSize: FontSize.s18),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: ColorManager.black,
              ),
            )
          ],
        ),
        SizedBox(
          height: AppSize.s16,
        ),
        CreditCard(
          config: paymentConfig,
          onPaymentResult: onPaymentResult,

          locale:
              appPreferences.getAppLanguage() == LanguageType.ENGLISH.getValue()
                  ? const Localization.en()
                  : const Localization.ar(),
        ),
      ],
    ));
  }
}
