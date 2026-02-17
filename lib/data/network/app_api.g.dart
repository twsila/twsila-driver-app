// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AppServiceClient implements AppServiceClient {
  _AppServiceClient(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<BaseResponse> getCountriesLookup() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/lookups/country',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LoginResponse> login(
    login,
    userDeviceDTO,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'login': login,
      'mobileUserDeviceDTO': userDeviceDTO,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LoginResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/v1/auth/login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LoginResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GeneralResponse> loginBO(
    login,
    userDeviceDTO,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'login': login,
      'mobileUserDeviceDTO': userDeviceDTO,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GeneralResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/v1/auth/login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GeneralResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GenerateOtpModel> generateOtp(mobile) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'mobile': mobile};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GenerateOtpModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/otp/generate',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GenerateOtpModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> verifyOtp(
    mobile,
    userOtp,
    generatedOtp,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'mobile': mobile,
      'userOtp': userOtp,
      'generatedOtp': generatedOtp,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/otp/validate',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RegistrationServicesTypesResponse> registrationServices() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegistrationServicesTypesResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/vehicle-types',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RegistrationServicesTypesResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> carBrandsAndModels() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/lookups/car-models',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> carManufacturers(serviceType) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/lookups/car-manufacturers?vc=${serviceType}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(email) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'email': email};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ForgotPasswordResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customers/forgotPassword',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ForgotPasswordResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RegistrationResponse> registerCaptainWithPersonService(
    firstName,
    lastName,
    mobile,
    email,
    gender,
    dateOfBirth,
    nationalId,
    nationalIdExpiryDate,
    serviceTypeParam,
    vehicleTypeId,
    carManufacturerId,
    carModelId,
    vehicleYearOfManufacture,
    plateNumber,
    isAcknowledged,
    vehicleDocExpiryDate,
    vehicleOwnerNatIdExpiryDate,
    vehicleDriverNatIdExpiryDate,
    licenseExpiryDate,
    numberOfPassengers,
    driverImages,
    countryCode,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'firstName',
      firstName,
    ));
    _data.fields.add(MapEntry(
      'lastName',
      lastName,
    ));
    _data.fields.add(MapEntry(
      'mobile',
      mobile,
    ));
    _data.fields.add(MapEntry(
      'email',
      email,
    ));
    _data.fields.add(MapEntry(
      'gender',
      gender,
    ));
    _data.fields.add(MapEntry(
      'dateOfBirth',
      dateOfBirth,
    ));
    _data.fields.add(MapEntry(
      'nationalId',
      nationalId,
    ));
    _data.fields.add(MapEntry(
      'nationalIdExpiryDate',
      nationalIdExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'serviceTypes',
      serviceTypeParam,
    ));
    _data.fields.add(MapEntry(
      'vehicleType.id',
      vehicleTypeId,
    ));
    if (carManufacturerId != null) {
      _data.fields.add(MapEntry(
        'carManufacturer.id',
        carManufacturerId,
      ));
    }
    if (carModelId != null) {
      _data.fields.add(MapEntry(
        'carModel.id',
        carModelId,
      ));
    }
    if (vehicleYearOfManufacture != null) {
      _data.fields.add(MapEntry(
        'vehicleYearOfManufacture',
        vehicleYearOfManufacture,
      ));
    }
    _data.fields.add(MapEntry(
      'plateNumber',
      plateNumber,
    ));
    _data.fields.add(MapEntry(
      'isAcknowledged',
      isAcknowledged.toString(),
    ));
    _data.fields.add(MapEntry(
      'vehicleDocExpiryDate',
      vehicleDocExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'vehicleOwnerNatIdExpiryDate',
      vehicleOwnerNatIdExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'vehicleDriverNatIdExpiryDate',
      vehicleDriverNatIdExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'licenseExpiryDate',
      licenseExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'numberOfPassengers',
      numberOfPassengers,
    ));
    _data.files.addAll(driverImages.map((i) => MapEntry(
        'driverImages',
        MultipartFile.fromFileSync(
          i.path,
          filename: i.path.split(Platform.pathSeparator).last,
        ))));
    _data.fields.add(MapEntry(
      'countryCode',
      countryCode,
    ));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegistrationResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              '/drivers/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RegistrationResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RegistrationResponse> registerCaptainWithGoodsService(
    firstName,
    lastName,
    mobile,
    email,
    gender,
    dateOfBirth,
    nationalId,
    nationalIdExpiryDate,
    serviceTypeParam,
    carManufacturerId,
    carModelId,
    vehicleYearOfManufacture,
    tankType,
    tankSize,
    canTransportFurniture,
    canTransportGoods,
    canTransportFrozen,
    hasWaterTank,
    hasOtherTanks,
    hasPacking,
    hasLoading,
    hasAssembly,
    hasLifting,
    plateNumber,
    isAcknowledged,
    vehicleDocExpiryDate,
    vehicleOwnerNatIdExpiryDate,
    vehicleDriverNatIdExpiryDate,
    licenseExpiryDate,
    vehicleShapeId,
    driverImages,
    countryCode,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'firstName',
      firstName,
    ));
    _data.fields.add(MapEntry(
      'lastName',
      lastName,
    ));
    _data.fields.add(MapEntry(
      'mobile',
      mobile,
    ));
    _data.fields.add(MapEntry(
      'email',
      email,
    ));
    _data.fields.add(MapEntry(
      'gender',
      gender,
    ));
    _data.fields.add(MapEntry(
      'dateOfBirth',
      dateOfBirth,
    ));
    _data.fields.add(MapEntry(
      'nationalId',
      nationalId,
    ));
    _data.fields.add(MapEntry(
      'nationalIdExpiryDate',
      nationalIdExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'serviceTypes',
      serviceTypeParam,
    ));
    if (carManufacturerId != null) {
      _data.fields.add(MapEntry(
        'carManufacturer.id',
        carManufacturerId,
      ));
    }
    if (carModelId != null) {
      _data.fields.add(MapEntry(
        'carModel.id',
        carModelId,
      ));
    }
    if (vehicleYearOfManufacture != null) {
      _data.fields.add(MapEntry(
        'vehicleYearOfManufacture',
        vehicleYearOfManufacture,
      ));
    }
    if (tankType != null) {
      _data.fields.add(MapEntry(
        'tankType',
        tankType,
      ));
    }
    if (tankSize != null) {
      _data.fields.add(MapEntry(
        'tankSize',
        tankSize,
      ));
    }
    _data.fields.add(MapEntry(
      'canTransportFurniture',
      canTransportFurniture.toString(),
    ));
    _data.fields.add(MapEntry(
      'canTransportGoods',
      canTransportGoods.toString(),
    ));
    _data.fields.add(MapEntry(
      'canTransportFrozen',
      canTransportFrozen.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasWaterTank',
      hasWaterTank.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasOtherTanks',
      hasOtherTanks.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasPacking',
      hasPacking.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasLoading',
      hasLoading.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasAssembly',
      hasAssembly.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasLifting',
      hasLifting.toString(),
    ));
    _data.fields.add(MapEntry(
      'plateNumber',
      plateNumber,
    ));
    _data.fields.add(MapEntry(
      'isAcknowledged',
      isAcknowledged.toString(),
    ));
    _data.fields.add(MapEntry(
      'vehicleDocExpiryDate',
      vehicleDocExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'vehicleOwnerNatIdExpiryDate',
      vehicleOwnerNatIdExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'vehicleDriverNatIdExpiryDate',
      vehicleDriverNatIdExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'licenseExpiryDate',
      licenseExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'vehicleShape.id',
      vehicleShapeId,
    ));
    _data.files.addAll(driverImages.map((i) => MapEntry(
        'driverImages',
        MultipartFile.fromFileSync(
          i.path,
          filename: i.path.split(Platform.pathSeparator).last,
        ))));
    _data.fields.add(MapEntry(
      'countryCode',
      countryCode,
    ));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegistrationResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              '/drivers/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RegistrationResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RegistrationBOResponse> registerBOWithService(
    firstName,
    lastName,
    mobile,
    email,
    gender,
    dateOfBirth,
    entityName,
    taxNumber,
    nationalId,
    nationalIdExpiryDate,
    commercialNumber,
    commercialRegisterExpiryDate,
    images,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'firstName',
      firstName,
    ));
    _data.fields.add(MapEntry(
      'lastName',
      lastName,
    ));
    _data.fields.add(MapEntry(
      'mobile',
      mobile,
    ));
    _data.fields.add(MapEntry(
      'email',
      email,
    ));
    _data.fields.add(MapEntry(
      'gender',
      gender,
    ));
    _data.fields.add(MapEntry(
      'dateOfBirth',
      dateOfBirth,
    ));
    _data.fields.add(MapEntry(
      'entityName',
      entityName,
    ));
    _data.fields.add(MapEntry(
      'taxNumber',
      taxNumber,
    ));
    _data.fields.add(MapEntry(
      'nationalId',
      nationalId,
    ));
    _data.fields.add(MapEntry(
      'nationalIdExpiryDate',
      nationalIdExpiryDate,
    ));
    _data.fields.add(MapEntry(
      'commercialNumber',
      commercialNumber,
    ));
    _data.fields.add(MapEntry(
      'commercialRegisterExpiryDate',
      commercialRegisterExpiryDate,
    ));
    _data.files.addAll(images.map((i) => MapEntry(
        'businessEntityImages',
        MultipartFile.fromFileSync(
          i.path,
          filename: i.path.split(Platform.pathSeparator).last,
        ))));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegistrationBOResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              '/bo/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RegistrationBOResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ServiceRegisterModel> serviceStatus(userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'userId': userId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceRegisterModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/registration-status',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceRegisterModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getTripsByModuleId(
    endpoint,
    tripModelType,
    userId,
    dateFilter,
    locationFilter,
    currentLocation,
    sortCriterion,
    serviceTypesSelectedByBusinessOwner,
    serviceTypesSelectedByDriver,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'tripModelType': tripModelType,
      'userId': userId,
      'dateFilter': dateFilter,
      'locationFilter': locationFilter,
      'currentLocation': currentLocation,
      'sortCriterion': sortCriterion,
      'serviceTypesSelectedByBusinessOwner':
          serviceTypesSelectedByBusinessOwner,
      'serviceTypesSelectedByDriver': serviceTypesSelectedByDriver,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '${endpoint}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getMyTripsByModuleId(
    endpoint,
    tripModelType,
    userId,
    serviceTypesSelectedByBusinessOwner,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'tripModelType': tripModelType,
      'userId': userId,
      'serviceTypesSelectedByBusinessOwner':
          serviceTypesSelectedByBusinessOwner,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '${endpoint}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GeneralResponse> addOffer(
    userId,
    tripId,
    driverOffer,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'tripId': tripId,
      'driverOffer': driverOffer,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GeneralResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/offers/add',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GeneralResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GeneralResponse> acceptOffer(
    userId,
    tripId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'tripId': tripId,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GeneralResponse>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/offers/accept',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GeneralResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GeneralResponse> tripSummary(
    userId,
    tripId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'tripId': tripId,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GeneralResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/trip-summary',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GeneralResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LookupsModel> getLookups() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LookupsModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/lookups',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LookupsModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LogoutModel> logout(refreshToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'refreshToken': refreshToken};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LogoutModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/v1/auth/logout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LogoutModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LogoutModel> boLogout(refreshToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'refreshToken': refreshToken};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LogoutModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/v1/auth/logout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LogoutModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> changeTripStatus(
    userId,
    tripId,
    tripStatus,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'tripId': tripId,
      'tripStatus': tripStatus,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/trips/change-status',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> ratePassenger(
    driverId,
    tripId,
    rateNumber,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': driverId,
      'tripId': tripId,
      'rating': rateNumber,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/trips/rate',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> updateDriverProfile(
    driverId,
    firstName,
    lastName,
    email,
    nationalId,
    nationalIdExpiryDate,
    plateNumber,
    vehicleDocExpiryDate,
    vehicleOwnerNatIdExpiryDate,
    vehicleDriverNatIdExpiryDate,
    licenseExpiryDate,
    driverImages,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (driverId != null) {
      _data.fields.add(MapEntry(
        'id',
        driverId.toString(),
      ));
    }
    if (firstName != null) {
      _data.fields.add(MapEntry(
        'firstName',
        firstName,
      ));
    }
    if (lastName != null) {
      _data.fields.add(MapEntry(
        'lastName',
        lastName,
      ));
    }
    if (email != null) {
      _data.fields.add(MapEntry(
        'email',
        email,
      ));
    }
    if (nationalId != null) {
      _data.fields.add(MapEntry(
        'nationalId',
        nationalId,
      ));
    }
    if (nationalIdExpiryDate != null) {
      _data.fields.add(MapEntry(
        'nationalIdExpiryDate',
        nationalIdExpiryDate,
      ));
    }
    if (plateNumber != null) {
      _data.fields.add(MapEntry(
        'plateNumber',
        plateNumber,
      ));
    }
    if (vehicleDocExpiryDate != null) {
      _data.fields.add(MapEntry(
        'vehicleDocExpiryDate',
        vehicleDocExpiryDate,
      ));
    }
    if (vehicleOwnerNatIdExpiryDate != null) {
      _data.fields.add(MapEntry(
        'vehicleOwnerNatIdExpiryDate',
        vehicleOwnerNatIdExpiryDate,
      ));
    }
    if (vehicleDriverNatIdExpiryDate != null) {
      _data.fields.add(MapEntry(
        'vehicleDriverNatIdExpiryDate',
        vehicleDriverNatIdExpiryDate,
      ));
    }
    if (licenseExpiryDate != null) {
      _data.fields.add(MapEntry(
        'licenseExpiryDate',
        licenseExpiryDate,
      ));
    }
    if (driverImages != null) {
      _data.files.addAll(driverImages.map((i) => MapEntry(
          'driverImages',
          MultipartFile.fromFileSync(
            i.path,
            filename: i.path.split(Platform.pathSeparator).last,
          ))));
    }
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              '/drivers/update-profile',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> updateBOProfile(
    boId,
    firstName,
    lastName,
    entityName,
    email,
    taxNumber,
    commercialNumber,
    nationalId,
    nationalIdExpiryDate,
    commercialRegisterExpiryDate,
    businessEntityImages,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (boId != null) {
      _data.fields.add(MapEntry(
        'id',
        boId.toString(),
      ));
    }
    if (firstName != null) {
      _data.fields.add(MapEntry(
        'firstName',
        firstName,
      ));
    }
    if (lastName != null) {
      _data.fields.add(MapEntry(
        'lastName',
        lastName,
      ));
    }
    if (entityName != null) {
      _data.fields.add(MapEntry(
        'entityName',
        entityName,
      ));
    }
    if (email != null) {
      _data.fields.add(MapEntry(
        'email',
        email,
      ));
    }
    if (taxNumber != null) {
      _data.fields.add(MapEntry(
        'taxNumber',
        taxNumber,
      ));
    }
    if (commercialNumber != null) {
      _data.fields.add(MapEntry(
        'commercialNumber',
        commercialNumber,
      ));
    }
    if (nationalId != null) {
      _data.fields.add(MapEntry(
        'nationalId',
        nationalId,
      ));
    }
    if (nationalIdExpiryDate != null) {
      _data.fields.add(MapEntry(
        'nationalIdExpiryDate',
        nationalIdExpiryDate,
      ));
    }
    if (commercialRegisterExpiryDate != null) {
      _data.fields.add(MapEntry(
        'commercialRegisterExpiryDate',
        commercialRegisterExpiryDate,
      ));
    }
    if (businessEntityImages != null) {
      _data.files.addAll(businessEntityImages.map((i) => MapEntry(
          'businessEntityImages',
          MultipartFile.fromFileSync(
            i.path,
            filename: i.path.split(Platform.pathSeparator).last,
          ))));
    }
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              '/bo/update-profile',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getBODrivers(businessOwnerId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'businessOwnerId': businessOwnerId};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver-acquisition/get-my-drivers',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getBOPendingDrivers(businessOwnerId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'businessOwnerId': businessOwnerId};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver-acquisition/get-pending-drivers',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> searchDriversByMobile(mobileNumber) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'mobileNumber': mobileNumber};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/get-drivers',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> addDriverForBO(
    businessOwnerId,
    driverIds,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'businessOwnerId': businessOwnerId,
      'driverIds': driverIds,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver-acquisition/add-driver',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> boAssignDriverToTrip(
    businessOwnerId,
    driverId,
    tripId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'businessOwnerId': businessOwnerId,
      'driverId': driverId,
      'tripId': tripId,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver-acquisition/assign-driver',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> boSuggestNewOffer(
    businessOwnerId,
    tripId,
    newSuggestedOffer,
    driverId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'businessOwnerId': businessOwnerId,
      'tripId': tripId,
      'newSuggestedOffer': newSuggestedOffer,
      'driverId': driverId,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver-acquisition/propose-offer',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> boAcceptNewOffer(
    businessOwnerId,
    tripId,
    driverId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'businessOwnerId': businessOwnerId,
      'tripId': tripId,
      'driverId': driverId,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver-acquisition/accept-offer',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getGoodsServiceTypes() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/service-types',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getPersonsVehicleTypes() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/vehicle-types',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getLookupByKey(
    lookupKey,
    language,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'lookupKey': lookupKey,
      'language': language,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/lookups/by-key',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getAddRequests(driverId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver-acquisition/requests/${driverId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> changeRequestStatus(
    acquisitionId,
    driverAcquisitionDecision,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'acquisitionId': acquisitionId,
      'driverAcquisitionDecision': driverAcquisitionDecision,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver-acquisition/driver-action',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getAllowedServiceByUserType(userType) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/lookups/allowed-endpoints?ut=${userType}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getCoastCalculationValues() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/lookups/cost-calculations-config',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
