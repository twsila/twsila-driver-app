import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/domain/model/goods_service_type_model.dart';
import 'package:taxi_for_you/domain/model/lookupValueModel.dart';
import 'package:taxi_for_you/domain/model/persons_vehicle_type_model.dart';
import 'package:taxi_for_you/domain/model/vehicle_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/service_registration_second_step.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/addiontal_serivces_widget.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/goods_serivce_types_widget.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/persons_vehicle_shapes_widget.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/di.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/page_builder.dart';
import '../../bloc/serivce_registration_bloc.dart';
import '../widgets/service_model_widget.dart';

class ServiceRegistrationFirstStepView extends StatefulWidget {
  final RegistrationRequest requestModel;

  const ServiceRegistrationFirstStepView({required this.requestModel, Key? key})
      : super(key: key);

  @override
  State<ServiceRegistrationFirstStepView> createState() =>
      _ServiceRegistrationFirstStepViewState();
}

class _ServiceRegistrationFirstStepViewState
    extends State<ServiceRegistrationFirstStepView> {
  final AppPreferences _appPrefs = instance<AppPreferences>();
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final List<ServiceModel> serviceModelList = [
    ServiceModel(
        0, AppStrings.personsTransportation.tr(), ImageAssets.tripPersonsIc),
    ServiceModel(
        1, AppStrings.goodsTransportations.tr(), ImageAssets.tripGoodsIc),
  ];
  bool _showPersonsData = false;
  bool _displayLoadingIndicator = false;

  List<GoodsServiceTypeModel> goodsServiceTypesList = [];
  List<PersonsVehicleTypeModel> personsVehicleTypesList = [];
  List<LookupValueModel> tankTypes = [];
  List<LookupValueModel> tankSizes = [];
  LookupValueModel? selectedTankType;
  LookupValueModel? selectedTankSize;

  AdditionalServicesModel additionalServicesModel = AdditionalServicesModel();

  PersonsVehicleTypeModel? selectedPersonVehicleType;
  NumberOfPassenger? selectedNumberOfPassengers;

  GoodsServiceTypeModel? selectedGoodsServiceType;
  TruckType? selectedVehicleShape;

  @override
  void initState() {
    BlocProvider.of<ServiceRegistrationBloc>(context).add(GetTankTypes());
    BlocProvider.of<ServiceRegistrationBloc>(context).add(GetTankSizes());
    if (widget.requestModel.serviceModelId != null &&
        widget.requestModel.serviceModelId == 0) {
      BlocProvider.of<ServiceRegistrationBloc>(context)
          .add(GetPersonsVehicleTypes());
    } else if (widget.requestModel.serviceModelId != null &&
        widget.requestModel.serviceModelId == 1) {
      BlocProvider.of<ServiceRegistrationBloc>(context)
          .add(GetGoodsServiceTypes());
    } else {
      widget.requestModel.serviceModelId = 0;
      BlocProvider.of<ServiceRegistrationBloc>(context)
          .add(GetPersonsVehicleTypes());
    }
    super.initState();
  }

  void startLoading() {
    setState(() {
      _displayLoadingIndicator = true;
    });
  }

  void stopLoading() {
    setState(() {
      _displayLoadingIndicator = false;
    });
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
        allowBackButtonInAppBar: true,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<ServiceRegistrationBloc, ServiceRegistrationState>(
      listener: (context, state) {
        if (state is ServiceRegistrationLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is GoodsServicesTypesSuccess) {
          _showPersonsData = false;
          this.goodsServiceTypesList = state.goodsServiceTypesList;
        }
        if (state is TankTypesSuccess) {
          this.tankTypes = state.tankValues;
        }
        if (state is TankSizeSuccess) {
          this.tankSizes = state.tankSizeValues;
        }
        if (state is PersonsVehicleTypesSuccess) {
          _showPersonsData = true;
          this.personsVehicleTypesList = state.personsVehicleTypesList;
        }
        if (state is FirstStepDataAddedState) {
          Navigator.pushNamed(context, Routes.serviceRegistrationSecondStep,
              arguments: ServiceRegistrationSecondStepArguments(
                  state.registrationRequest));
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(
              left: AppMargin.m16, right: AppMargin.m16, top: AppMargin.m16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.close),
                  ),
                ),
                SizedBox(
                  height: AppSize.s10,
                ),
                Text(
                  AppStrings.stepOne.tr(),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorManager.headersTextColor),
                ),
                Text(
                  AppStrings.serviceData.tr(),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: AppSize.s28,
                      color: ColorManager.headersTextColor),
                ),
                Text(
                  AppStrings.selectServiceType.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: ColorManager.titlesTextColor),
                ),
                SizedBox(
                  height: AppSize.s10,
                ),
                ServiceModelWidget(
                  currentIndex: widget.requestModel.serviceModelId,
                  serviceModelList: serviceModelList,
                  onSelectedServiceModel: (selectedService) {
                    setState(() {
                      widget.requestModel.serviceModelId = selectedService.id;
                      resetSelectedValuesToNull();
                      if (selectedService.id == 0) {
                        if (personsVehicleTypesList.isNotEmpty) {
                          _showPersonsData = true;
                        } else {
                          BlocProvider.of<ServiceRegistrationBloc>(context)
                              .add(GetPersonsVehicleTypes());
                        }
                      } else if (selectedService.id == 1) {
                        if (goodsServiceTypesList.isNotEmpty) {
                          _showPersonsData = false;
                        } else {
                          BlocProvider.of<ServiceRegistrationBloc>(context)
                              .add(GetGoodsServiceTypes());
                        }
                      }
                    });
                  },
                ),
                SizedBox(
                  height: AppSize.s10,
                ),
                _showPersonsData
                    ? PersonsVehicleTypesWidget(
                        registrationRequest: widget.requestModel,
                        lang: _appPrefs.getAppLanguage(),
                        personsVehicleTypesList: this.personsVehicleTypesList,
                        selectedPersonsVehicleTypeModel:
                            (selectedPersonsVehicleTypeModel) {
                          setState(() {
                            this.selectedPersonVehicleType =
                                selectedPersonsVehicleTypeModel;
                            this.selectedGoodsServiceType = null;
                            this.selectedNumberOfPassengers = null;
                          });
                        },
                        selectedNumberOfPassengers:
                            (selectedNumberOfPassengers) {
                          setState(() {
                            this.selectedNumberOfPassengers =
                                selectedNumberOfPassengers;
                            this.selectedVehicleShape = null;
                          });
                        })
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GoodsServiceTypesWidget(
                              onSelectTankType: (tankType) {
                                this.selectedTankType = tankType;
                              },
                              onSelectTankSize: (tankSize) {
                                this.selectedTankSize = tankSize;
                              },
                              tankTypesList: tankTypes,
                              tankSizesList: tankSizes,
                              lang: _appPrefs.getAppLanguage(),
                              registrationRequest: widget.requestModel,
                              goodsServiceTypesList: this.goodsServiceTypesList,
                              selectedService: (selectedService) {
                                setState(() {
                                  this.selectedGoodsServiceType =
                                      selectedService;
                                  this.selectedPersonVehicleType = null;
                                  this.selectedVehicleShape = null;
                                });
                              },
                              selectedVehicleShape: (selectedVehicleShape) {
                                setState(() {
                                  this.selectedVehicleShape =
                                      selectedVehicleShape;
                                  this.selectedNumberOfPassengers = null;
                                });
                              }),
                          SizedBox(
                            height: AppSize.s10,
                          ),
                          Visibility(
                            visible: this.selectedGoodsServiceType != null &&
                                    this
                                        .selectedGoodsServiceType!
                                        .serviceTypeParam
                                        .contains("GOODS, FURNITURE") ||
                                this.selectedGoodsServiceType != null &&
                                    this
                                        .selectedGoodsServiceType!
                                        .serviceTypeParam
                                        .contains("FROZEN"),
                            child: AdditionalServicesWidget(
                                additionalServicesModel:
                                    additionalServicesModel,
                                registrationRequest: widget.requestModel),
                          )
                        ],
                      ),
                CustomTextButton(
                  text: AppStrings.continueStr.tr(),
                  icon: Icon(
                    Icons.arrow_forward,
                    color: ColorManager.white,
                  ),
                  onPressed: ((this.selectedGoodsServiceType != null &&
                                  this
                                      .selectedGoodsServiceType!
                                      .truckTypes
                                      .isEmpty) ||
                              this.selectedGoodsServiceType != null &&
                                  this.selectedVehicleShape != null) ||
                          (this.selectedPersonVehicleType != null &&
                              this.selectedNumberOfPassengers != null)
                      ? () {
                          BlocProvider.of<ServiceRegistrationBloc>(context).add(
                              SetFirstStepData(
                                  this.selectedGoodsServiceType != null
                                      ? this
                                          .selectedGoodsServiceType!
                                          .serviceTypeParam
                                          .toString()
                                      : this
                                          .selectedPersonVehicleType!
                                          .serviceType
                                          .toString(),
                                  this.selectedGoodsServiceType != null
                                      ? this
                                          .selectedGoodsServiceType!
                                          .id
                                          .toString()
                                      : this
                                          .selectedPersonVehicleType!
                                          .id
                                          .toString(),
                                  _showPersonsData
                                      ? this
                                          .selectedNumberOfPassengers!
                                          .id
                                          .toString()
                                      : this.selectedVehicleShape != null
                                          ? this
                                              .selectedVehicleShape!
                                              .id
                                              .toString()
                                          : "-1",
                                  widget.requestModel.serviceModelId!,
                                  additionalServicesModel,
                                  this.selectedTankType != null
                                      ? selectedTankType!.id.toString()
                                      : null,
                                  this.selectedTankSize != null
                                      ? selectedTankSize!.id.toString()
                                      : null));
                        }
                      : null,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void resetSelectedValuesToNull() {
    this.selectedPersonVehicleType = null;
    this.selectedNumberOfPassengers = null;
    this.selectedGoodsServiceType = null;
    this.selectedVehicleShape = null;
  }
}

class ServiceRegistrationFirstStepArguments {
  RegistrationRequest registrationRequest;

  ServiceRegistrationFirstStepArguments(this.registrationRequest);
}
