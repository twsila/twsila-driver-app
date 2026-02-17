import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/presentation/business_owner_cars_and_drivers/bloc/bo_drivers_cars_bloc.dart';
import 'package:taxi_for_you/presentation/driver_add_requests/bloc/driver_requests_bloc.dart';
import 'package:taxi_for_you/presentation/edit_user_profile/bloc/edit_profile_bloc.dart';
import 'package:taxi_for_you/presentation/filter_trips/bloc/filter_bloc.dart';
import 'package:taxi_for_you/presentation/location_bloc/location_bloc.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/bloc/my_profile_bloc.dart';
import 'package:taxi_for_you/presentation/main/pages/search_trips/search_trips_bloc/search_trips_bloc.dart';
import 'package:taxi_for_you/presentation/rate_passenger/bloc/rate_passenger_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/bloc/serivce_registration_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/serivce_registration_first_step_view.dart';
import 'package:taxi_for_you/presentation/trip_execution/bloc/trip_execution_bloc.dart';
import 'package:taxi_for_you/presentation/update_driver_profile/bloc/update_driver_bloc.dart';

import '../presentation/google_maps/bloc/maps_bloc.dart';
import '../presentation/google_maps/model/maps_repo.dart';
import '../presentation/login/bloc/login_bloc.dart';
import '../presentation/main/pages/mytrips/bloc/my_trips_bloc.dart';
import '../presentation/my_serivces/bloc/my_services_bloc.dart';
import '../presentation/otp/bloc/verify_otp_bloc.dart';
import '../presentation/trip_details/bloc/trip_details_bloc.dart';
import '../presentation/update_bo_profile/bloc/update_bo_bloc.dart';
import '../utils/location/map_provider.dart';

blocProviders(BuildContext context) {
  return [
    BlocProvider.value(value: MapsBloc(MapsRepo())),
    BlocProvider.value(value: LocationBloc()),
    BlocProvider.value(value: LoginBloc()),
    BlocProvider.value(value: VerifyOtpBloc()),
    BlocProvider.value(value: ServiceRegistrationBloc()),
    BlocProvider.value(value: MyServicesBloc()),
    BlocProvider.value(value: MyProfileBloc()),
    BlocProvider.value(value: SearchTripsBloc()),
    BlocProvider.value(value: MyTripsBloc()),
    BlocProvider.value(value: RatePassengerBloc()),
    BlocProvider.value(value: TripExecutionBloc()),
    BlocProvider.value(value: TripDetailsBloc()),
    BlocProvider.value(value: BoDriversCarsBloc()),
    BlocProvider.value(value: EditProfileBloc()),
    BlocProvider.value(value: FilterBloc()),
    BlocProvider.value(value: DriverRequestsBloc()),
    BlocProvider.value(value: UpdateDriverBloc()),
    BlocProvider.value(value: UpdateBoBloc()),
    ChangeNotifierProvider(create: (_) => MapProvider()),
  ];
}
