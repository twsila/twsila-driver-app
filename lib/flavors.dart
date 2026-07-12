enum Flavor {
  development,
  staging,
  production,
}

class F {
  static Flavor? appFlavor;

  /// Local Spring Boot (`profile=local`). Use LAN IP for a physical device on Wi‑Fi.
  static const String localBaseUrl = 'http://twsila-dev-lb-944400879.us-east-1.elb.amazonaws.com:8080/';
  /// Example: same Mac, physical phone on Wi‑Fi — replace with your machine IP.
  static const String localLanBaseUrl = 'http://twsila-dev-lb-944400879.us-east-1.elb.amazonaws.com:8080/';

  static String get name => appFlavor?.name ?? '';

  static const String awsDevBaseUrl =
      'http://twsila-dev-lb-944400879.us-east-1.elb.amazonaws.com:8080/';
  static const String awsStagingBaseUrl =
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
        return localBaseUrl;
      case Flavor.staging:
        return awsStagingBaseUrl;
      case Flavor.production:
        return awsStagingBaseUrl;
      default:
        return localBaseUrl;
    }
  }
}
