import 'package:dartz/dartz_unsafe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/presentation/filter_trips/bloc/filter_bloc.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/constants.dart';
import '../../../../app/di.dart';
import '../../../../domain/model/lookupValueModel.dart';
import '../../../../utils/ext/enums.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';

class FilterByServiceWidget extends StatefulWidget {
  List<String> serviceParams;
  Function(List<String> selectedServices) onSelectedServices;

  FilterByServiceWidget(
      {required this.serviceParams, required this.onSelectedServices});

  @override
  State<FilterByServiceWidget> createState() => _FilterByServiceWidgetState();
}

class _FilterByServiceWidgetState extends State<FilterByServiceWidget> {
  Map<String, bool> filterValues = {};
  bool _loading = false;
  List<LookupValueModel> serviceList = [];
  List<String> filterListToApi = [];

  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    widget.serviceParams.forEach((element) {
      filterValues.addAll({element.toString(): false});
    });

    BlocProvider.of<FilterBloc>(context)
        .add(getServiceLookup(LookupKeys.serviceType));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilterBloc, FilterState>(
      listener: (context, state) {
        if (state is FilterLoading) {
          _loading = true;
        } else {
          _loading = false;
        }

        if (state is ServiceLookupSuccess) {
          serviceList = state.services;
        }
      },
      builder: (context, state) {
        return _loading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primary,
                  ),
                ),
              )
            : ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: filterValues.keys.map((String key) {
                    String? serviceName;
                    for (int i = 0; i < serviceList.length; i++) {
                      if (serviceList[i].value == key) {
                        serviceName = _appPreferences.getAppLanguage() == "ar"
                            ? serviceList[i].valueAr
                            : serviceList[i].value;
                      }
                    }
                    return CheckboxListTile(
                      activeColor: ColorManager.splashBGColor,
                      title: Text(
                        serviceName != null && serviceName.isNotEmpty
                            ? serviceName!
                            : key,
                        style: TextStyle(
                          fontWeight: (filterValues[key] ?? false)
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: ColorManager.headersTextColor,
                        ),
                      ),
                      value: filterValues[key],
                      onChanged: (value) {
                        setState(() {
                          filterValues[key] = value ?? false;
                        });
                        filterListToApi.clear();
                        filterValues.forEach((key, value) {
                          if (value) {
                            filterListToApi.add(key);
                          }
                        });
                        widget.onSelectedServices(filterListToApi);
                      },
                    );
                  }).toList(),
              );
      },
    );
  }
}
