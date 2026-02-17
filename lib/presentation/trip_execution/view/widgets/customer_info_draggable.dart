import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taxi_for_you/domain/model/trip_details_model.dart';

import '../../../../domain/model/trip_model.dart';
import '../../../../utils/ext/enums.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';

class CustomerInfoHeader extends StatefulWidget {
  TripDetailsModel tripModel;

  CustomerInfoHeader({required this.tripModel});

  @override
  State<CustomerInfoHeader> createState() => _CustomerInfoHeaderState();
}

class _CustomerInfoHeaderState extends State<CustomerInfoHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                padding: EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundColor: ColorManager.accentColor,
                  radius: 48, // Image radius
                  backgroundImage: NetworkImage(
                      "https://t3.ftcdn.net/jpg/02/22/85/16/360_F_222851624_jfoMGbJxwRi5AWGdPgXKSABMnzCQo9RN.jpg"),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Text(
                    "${widget.tripModel.tripDetails.passenger!.firstName} ${widget.tripModel.tripDetails.passenger!.lastName}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontSize: FontSize.s14,
                        fontWeight: FontWeight.bold),
                  ),
                  RatingBarIndicator(
                    rating: widget.tripModel.tripDetails.passenger!.rating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Text(
                AppStrings.withBudget.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.headersTextColor,
                    fontSize: FontSize.s14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${widget.tripModel.tripDetails.clientOfferFormatted} ${getCurrency(widget.tripModel.tripDetails.passenger?.countryCode ?? "")}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.headersTextColor,
                    fontSize: FontSize.s14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
    ;
  }
}
