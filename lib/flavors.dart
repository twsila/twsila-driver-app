enum Flavor {
  development,
  staging,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static const String awsDevBaseUrl =
      // 'http://54.89.92.148:8080';
      'http://twsila-dev-lb-944400879.us-east-1.elb.amazonaws.com:8080/';
  static const String awsStagingBaseUrl =
      // 'http://54.89.92.148:8080';
      'http://twsila-dev-lb-944400879.us-east-1.elb.amazonaws.com:8080/';

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return 'D-Captain - Business owner';
      case Flavor.staging:
        return 'S-Captain - Business owner';
      case Flavor.production:
        return 'Captain - Business owner';
      default:
        return 'title';
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.development:
        return awsDevBaseUrl;
      case Flavor.staging:
        return awsStagingBaseUrl;
      case Flavor.production:
        return awsStagingBaseUrl;
      default:
        return awsStagingBaseUrl;
    }
  }
}
