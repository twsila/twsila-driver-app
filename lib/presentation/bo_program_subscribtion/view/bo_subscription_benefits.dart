import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../utils/ext/enums.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/custom_text_button.dart';
import '../../common/widgets/page_builder.dart';
import '../../payment/view/payment_screen.dart';

class BoSubscriptionBenefits extends StatefulWidget {
  const BoSubscriptionBenefits();

  @override
  State<BoSubscriptionBenefits> createState() => _BoSubscriptionBenefitsState();
}

class _BoSubscriptionBenefitsState extends State<BoSubscriptionBenefits> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        context: context,
        resizeToAvoidBottomInsets: true,
        appbar: false,
        allowBackButtonInAppBar: false,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImageAssets.successRegisterSubscriptionBenefits,
                  width: AppSize.s190,
                ),
                SizedBox(
                  height: AppSize.s25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: ColorManager.primary,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppStrings.yourAccountRegisteredSuccessfully.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ColorManager.primary,
                          fontSize: FontSize.s16),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.s25,
                ),
                Text(
                  "${AppStrings.payBusinessOwnerFeesMessage.tr()}: 200 ${getCurrency("SA")}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: ColorManager.secondaryColor,
                      fontSize: FontSize.s16),
                ),
                SizedBox(
                  height: AppSize.s20,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: const Divider(),
                ),
                Image.asset(
                  ImageAssets.vipIcon,
                  width: AppSize.s60,
                ),
                SizedBox(
                  height: AppSize.s20,
                ),
                Text(
                  "${AppStrings.subscriptionBenefits.tr()}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: ColorManager.secondaryColor,
                      fontSize: FontSize.s16),
                ),
                SizedBox(
                  height: AppSize.s20,
                ),
                Text(
                  "  •   One",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: ColorManager.secondaryColor,
                      fontSize: FontSize.s16),
                ),
                SizedBox(
                  height: AppSize.s16,
                ),
                Text(
                  "  •   Two",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: ColorManager.secondaryColor,
                      fontSize: FontSize.s16),
                ),
                SizedBox(
                  height: AppSize.s20,
                ),
                Text(
                  "  •   Three",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: ColorManager.secondaryColor,
                      fontSize: FontSize.s16),
                ),
                CustomTextButton(
                  text: AppStrings.subscribeAndGoToPay.tr(),
                  isWaitToEnable: false,
                  icon: Image.asset(
                    ImageAssets.tripDetailsVisaIcon,
                    color: ColorManager.white,
                    width: 16,
                  ),
                  onPressed: () {
                    _showPaymentBottomSheet();
                  },
                ),
                CustomTextButton(
                  text: AppStrings.later.tr(),
                  isWaitToEnable: false,
                  borderColor: ColorManager.black,
                  backgroundColor: Colors.transparent,
                  textColor: ColorManager.headersTextColor,
                  fontSize: FontSize.s16,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        scaffoldKey: _key,
      ),
    );
  }

  void _showPaymentBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        elevation: 10,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: PaymentScreen(),
              ),
            ));
  }
}
