import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/extensions.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/add_request_model.dart';
import 'package:taxi_for_you/domain/model/allowed_services_model.dart';
import 'package:taxi_for_you/domain/model/coast_calculation_model.dart';
import 'package:taxi_for_you/domain/model/general_response.dart';
import 'package:taxi_for_you/domain/model/goods_service_type_model.dart';
import 'package:taxi_for_you/domain/model/lookupValueModel.dart';
import 'package:taxi_for_you/domain/model/lookups_model.dart';
import 'package:taxi_for_you/domain/model/persons_vehicle_type_model.dart';
import 'package:taxi_for_you/domain/model/service_type_model.dart';
import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/generate_otp_model.dart';
import 'package:taxi_for_you/domain/model/logout_model.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';
import 'package:taxi_for_you/domain/model/vehicle_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/coast_calculation/helpers/coast_calculations_helper.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';

import '../../app/di.dart';
import '../../domain/model/country_lookup_model.dart';
import '../../domain/model/driver_model.dart';
import '../../domain/model/trip_details_model.dart';
import '../../domain/repository/repository.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';
import '../network/error_handler.dart';
import '../network/failure.dart';
import '../network/network_info.dart';
import '../network/requests.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final FirebaseAuth auth = FirebaseAuth.instance;
  AppPreferences _appPreferences = instance<AppPreferences>();

  RepositoryImpl(
      this._remoteDataSource, this._networkInfo, this._localDataSource);

  @override
  Future<Either<Failure, Driver>> login(LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        var response = await _remoteDataSource.login(loginRequest);

        if (response.success == ApiInternalStatus.SUCCESS) {
          // success
          // return either right
          // return data
          //save driver data
          String accessToken = response.result["accessToken"];
          String refreshToken = response.result["refreshToken"];
          Driver driver = Driver.fromJson(response.result!["user"]["driver"]);
          driver.accessToken = accessToken;
          driver.refreshToken = refreshToken;
          return Right(driver);
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left

      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BusinessOwnerModel>> loginBO(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        var response = await _remoteDataSource.loginBO(loginRequest);

        if (response.success == ApiInternalStatus.SUCCESS) {
          // success
          // return either right
          // return data
          //save driver data
          String accessToken = response.result["accessToken"];
          String refreshToken = response.result["refreshToken"];
          BusinessOwnerModel businessOwner = BusinessOwnerModel.fromJson(
              response.result!["user"]["businessOwner"]);
          businessOwner.accessToken = accessToken;
          businessOwner.refreshToken = refreshToken;
          return Right(businessOwner);
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, GenerateOtpModel>> generateOtp(
      GenerateOTPRequest otpRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.generateOtp(otpRequest);

        if (response.success == ApiInternalStatus.SUCCESS) {
          // success
          // return either right
          // return data
          return Right(response);
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> verifyOtp(
      VerifyOTPRequest verifyOTPRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.verifyOtp(verifyOTPRequest);

        if (response.success == ApiInternalStatus.SUCCESS) {
          // success
          // return either right
          // return data
          return Right(response);
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceTypeModel>>>
      registrationServiceTypes() async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.registrationServicesType();

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<ServiceTypeModel> servicesList = [];

          response.result.forEach((key, value) {
            List<VehicleModel> vehicleModels = List<VehicleModel>.from(
                value["vehicleTypes"].map((x) => VehicleModel.fromJson(x)));
            ServiceIcon serviceIcon =
                ServiceIcon.fromJson(value["serviceIcon"]);

            servicesList.add(ServiceTypeModel(key, vehicleModels, serviceIcon));
          });

          return Right(servicesList);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<CarModel>>> carBrandsAndModels() async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.carBrandAndModel();

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<CarModel> carModelsList = List<CarModel>.from(
              response.result.map((x) => CarModel.fromJson(x)));

          return Right(carModelsList);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<CarManufacturerModel>>> carManufacturers(
      String serviceType) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.carManufacturers(serviceType);

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<CarManufacturerModel> carManufacturerList =
              List<CarManufacturerModel>.from(
                  response.result.map((x) => CarManufacturerModel.fromJson(x)));
          return Right(carManufacturerList);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ServiceRegisterModel>> getServiceStatus(
      String userId) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.servicesStatus(userId);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, LogoutModel>> logout(
      LogoutRequest logoutRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.logout(logoutRequest);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, RegistrationResponse>> register(
      RegistrationRequest registrationRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response;
        if (registrationRequest.serviceModelId! == 1) {
          response = await _remoteDataSource
              .registerCaptainWithGoodsService(registrationRequest);
        } else {
          response = await _remoteDataSource
              .registerCaptainWithPersonsService(registrationRequest);
        }
        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, RegistrationBOResponse>> registerBO(
      BusinessOwnerModel businessOwnerModel) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response =
            await _remoteDataSource.registerBOWithService(businessOwnerModel);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<TripDetailsModel>>> getTrips(
    String endPoint,
    String tripTypeModuleId,
    int userId,
    Map<String, dynamic>? dateFilter,
    Map<String, dynamic>? locationFilter,
    Map<String, dynamic>? currentLocation,
    String? sortCriterion,
    String? serviceTypesSelectedByBusinessOwner,
    String? serviceTypesSelectedByDriver,
  ) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        CoastCalculationModel coastCalculationModel =
            await instance<AppPreferences>().getCoastCalculationData();

        final response = await _remoteDataSource.tripsByModuleId(
            endPoint,
            tripTypeModuleId,
            userId,
            dateFilter,
            locationFilter,
            currentLocation,
            sortCriterion,
            serviceTypesSelectedByBusinessOwner,
            serviceTypesSelectedByDriver);

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<TripDetailsModel> trips = List<TripDetailsModel>.from(
              response.result!.map((x) => TripDetailsModel.fromJson(x)));

          await Future.forEach(trips, (TripDetailsModel trip) {
            trip.tripDetails.clientOffer = CoastCalculationsHelper()
                .getDriverShareFromAmount(
                    coastCalculationModel, trip.tripDetails.clientOffer!);
            trip.tripDetails.clientOfferFormatted =
                (trip.tripDetails.clientOffer as double)
                    .toCommaSeparated(decimalPlaces: 2).toString();
          });
          return Right(trips);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<TripDetailsModel>>> getMyTrips(
      String endPoint, String tripTypeModuleId, int userId) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.myTripsByModuleId(
            endPoint, tripTypeModuleId, userId);

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<TripDetailsModel> trips = List<TripDetailsModel>.from(
              response.result!.map((x) => TripDetailsModel.fromJson(x)));

          return Right(trips);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, GeneralResponse>> acceptOffer(
      int userId, int tripId) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.acceptOffer(userId, tripId);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, GeneralResponse>> addOffer(
      int userId, int tripId, double driverOffer) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response =
            await _remoteDataSource.addOffer(userId, tripId, driverOffer);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, TripDetailsModel>> tripSummary(
      int userId, int tripId) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.tripSummary(userId, tripId);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(TripDetailsModel.fromJson(response.result));
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, LookupsModel>> getLookups() async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.getLookups();

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> changeTripStatus(
      int userId, int tripId, String tripStatus) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.changeTripStatus(
            userId, tripId, tripStatus);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> ratePassenger(
      int driverId, int tripId, rate) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response =
            await _remoteDataSource.ratePassenger(driverId, tripId, rate);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> UpdateDriverProfile(
      UpdateDriverProfileRequest updateProfileRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response;
        response =
            await _remoteDataSource.updateDriverProfile(updateProfileRequest);
        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> UpdateBOProfile(
      UpdateBoProfileRequest updateBoProfileRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response;
        response =
            await _remoteDataSource.updateBOProfile(updateBoProfileRequest);
        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<Driver>>> getBODrivers(
      int businessOwnerId) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.getBODrivers(businessOwnerId);

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<Driver> driversList = List<Driver>.from(
              response.result!.map((x) => Driver.fromJson(x)));
          return Right(driversList);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<Driver>>> getBOPendingDrivers(
      int businessOwnerId) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response =
            await _remoteDataSource.getBOPendingDrivers(businessOwnerId);

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<Driver> driversList = List<Driver>.from(
              response.result!.map((x) => Driver.fromJson(x)));
          return Right(driversList);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<Driver>>> searchDriversByMobile(
      int mobileNumber) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response =
            await _remoteDataSource.searchDriversByMobile(mobileNumber);

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<Driver> drivers = List<Driver>.from(
              response.result!.map((x) => Driver.fromJson(x)));

          return Right(drivers);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> addDriverForBO(
      int businessOwnerId, List<int> driverIds) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response =
            await _remoteDataSource.addDriverForBO(businessOwnerId, driverIds);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, LogoutModel>> boLogout(
      LogoutRequest logoutRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.boLogout(logoutRequest);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> boAcceptOffer(
      int businessOwnerId, int tripId, int driverId) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.boAcceptOffer(
            businessOwnerId, tripId, driverId);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> boAssignDriverToTrip(
      int businessOwnerId, int driverId, int tripId) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.boAssignDriverForTrip(
            businessOwnerId, driverId, tripId);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> boSuggestNewOffer(int businessOwnerId,
      int tripId, double newSuggestedOffer, int driverId) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.boSuggestNewOffer(
            businessOwnerId, tripId, newSuggestedOffer, driverId);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<CountryLookupModel>>> getCountriesLookup() async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.getCountriesLookup();

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<CountryLookupModel> countries = List<CountryLookupModel>.from(
              response.result.map((x) => CountryLookupModel.fromJson(x)));
          return Right(countries);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<GoodsServiceTypeModel>>>
      getGoodsServiceTypes() async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.getGoodsServiceTypes();

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<GoodsServiceTypeModel> goodsServiceTypesList =
              List<GoodsServiceTypeModel>.from(response
                  .result["serviceTypeLookup"]
                  .map((x) => GoodsServiceTypeModel.fromJson(x)));
          return Right(goodsServiceTypesList);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<PersonsVehicleTypeModel>>>
      getPersonsVehicleTypes() async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.getPersonsVehicleTypes();

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<PersonsVehicleTypeModel> personsVehicleTypesList =
              List<PersonsVehicleTypeModel>.from(response.result["vehicleTypes"]
                  .map((x) => PersonsVehicleTypeModel.fromJson(x)));
          return Right(personsVehicleTypesList);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<LookupValueModel>>> getLookupByKey(
      String key, String lang) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.getLookupByKey(key, lang);

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<LookupValueModel> lookupsValues = List<LookupValueModel>.from(
              response.result.map((x) => LookupValueModel.fromJson(x)));
          return Right(lookupsValues);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<AddRequestModel>>> getAddRequests(
      int driverId) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response =
            await _remoteDataSource.getAddRequestsForDriver(driverId);

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<AddRequestModel> addRequestList = List<AddRequestModel>.from(
              response.result.map((x) => AddRequestModel.fromJson(x)));
          return Right(addRequestList);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> changeRequestStatus(
      int acquisitionId, String driverAcquisitionDecision) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.changeRequestStatus(
            acquisitionId, driverAcquisitionDecision);

        if (response.success == ApiInternalStatus.SUCCESS) {
          return Right(response);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<AllowedServiceModel>>>
      getAllowedServicesByUserType(String userType) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response =
            await _remoteDataSource.getAllowedServicesByUserType(userType);

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<AllowedServiceModel> listOfAllowedServices =
              List<AllowedServiceModel>.from(
                  response.result.map((x) => AllowedServiceModel.fromJson(x)));
          return Right(listOfAllowedServices);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, CoastCalculationModel>>
      getCostCalculationValues() async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.getCoastCalculationValues();

        if (response.success == ApiInternalStatus.SUCCESS) {
          CoastCalculationModel calculationModel =
              CoastCalculationModel.fromJson(response.result);
          return Right(calculationModel);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
