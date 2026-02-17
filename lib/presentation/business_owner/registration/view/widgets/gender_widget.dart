import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/gender_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/register_business_owner_viewmodel.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

class GenderWidget extends StatefulWidget {
  final Function(GenderModel) onSelectGender;
  final RegisterBusinessOwnerViewModel viewModel;
  final String? initialGender;
  const GenderWidget({
    Key? key,
    required this.onSelectGender,
    required this.viewModel,
    this.initialGender,
  }) : super(key: key);

  @override
  State<GenderWidget> createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  late GenderModel _selectedGender;

  @override
  initState() {
    if (widget.initialGender != null) {
      _selectedGender = widget.viewModel.genderTypes.singleWhere(
        (element) => element.value == widget.initialGender,
      );
    } else {
      _selectedGender = widget.viewModel.genderTypes[0];
    }
    widget.onSelectGender(_selectedGender);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.gender.tr(),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: ColorManager.titlesTextColor),
        ),
        Row(
          children: List.generate(
            widget.viewModel.genderTypes.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = widget.viewModel.genderTypes[index];
                });
                widget.onSelectGender(_selectedGender);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: widget.viewModel.genderTypes[index] == _selectedGender
                      ? ColorManager.headersTextColor
                      : Colors.transparent,
                  border: Border.all(
                    color:
                        widget.viewModel.genderTypes[index] == _selectedGender
                            ? Colors.transparent
                            : ColorManager.lightGrey,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    widget.viewModel.genderTypes[index].name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: widget.viewModel.genderTypes[index] ==
                                  _selectedGender
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
