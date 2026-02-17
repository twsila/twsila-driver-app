// onboarding models

class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(this.title, this.subTitle, this.image);
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;

  SliderViewObject(this.sliderObject, this.numOfSlides, this.currentIndex);
}

class CountryCodes {
  String flagPath;
  String countryPhoneKey;
  String countryIsoCode;
  String countryName;

  CountryCodes(this.flagPath, this.countryPhoneKey, this.countryIsoCode, this.countryName);
}

class DriverRegstrationObj {
  String serviceType;
  String serviceTypeCapacity;
  int plateNumber;
  String carBrandAndModel;
  String notes;
  String carDocumentFrontImage;
  String carDocumentBackImage;
  String carDocumentExpireDate;
  String carOwnerLicenseFrontImage;
  String carOwnerLicenseBackImage;
  String carOwnerLicenseExpireDate;
  String carOwnerIdentityCardFrontImage;
  String carOwnerIdentityCardBackImage;
  String carOwnerIdentityCardExpireDate;
  String carDriverIdentityCardFrontImage;
  String carDriverIdentityCardBackImage;
  String carDriverIdentityCardExpireDate;

  DriverRegstrationObj(
      this.serviceType,
      this.serviceTypeCapacity,
      this.plateNumber,
      this.carBrandAndModel,
      this.notes,
      this.carDocumentFrontImage,
      this.carDocumentBackImage,
      this.carDocumentExpireDate,
      this.carOwnerLicenseFrontImage,
      this.carOwnerLicenseBackImage,
      this.carOwnerLicenseExpireDate,
      this.carOwnerIdentityCardFrontImage,
      this.carOwnerIdentityCardBackImage,
      this.carOwnerIdentityCardExpireDate,
      this.carDriverIdentityCardFrontImage,
      this.carDriverIdentityCardBackImage,
      this.carDriverIdentityCardExpireDate);
}

// login models

class Customer {
  String id;
  String name;
  int numOfNotifications;

  Customer(this.id, this.name, this.numOfNotifications);
}

class Contacts {
  String phone;
  String email;
  String link;

  Contacts(this.phone, this.email, this.link);
}

class Authentication {
  Customer? customer;
  Contacts? contacts;

  Authentication(this.customer, this.contacts);
}

class FirebaseCodeSent {
  String verificationId;
  int? resendToken;

  FirebaseCodeSent(this.verificationId, this.resendToken);
}

class Service {
  int id;
  String title;
  String image;

  Service(this.id, this.title, this.image);
}

class Store {
  int id;
  String title;
  String image;

  Store(this.id, this.title, this.image);
}

class BannerAd {
  int id;
  String title;
  String image;
  String link;

  BannerAd(this.id, this.title, this.image, this.link);
}

class HomeData {
  List<Service> services;
  List<BannerAd> banners;
  List<Store> stores;

  HomeData(this.services, this.banners, this.stores);
}

class HomeObject {
  HomeData data;

  HomeObject(this.data);
}

class StoreDetails {
  int id;
  String title;
  String image;
  String details;
  String services;
  String about;

  StoreDetails(
      this.id, this.title, this.image, this.details, this.services, this.about);
}
