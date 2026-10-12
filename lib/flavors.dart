enum Flavor {
  development,
  staging,
  production,
}

class F {
  static Flavor? appFlavor;

  /// Secure AWS API gateway / custom domain (HTTPS).
  static const String secureDevApiBaseUrl = 'https://dev-api.twsila-api.com/';

  /// Local Spring Boot (`profile=local`). Use LAN IP for a physical device on Wi‑Fi.
  static const String localBaseUrl = 'http://127.0.0.1:8080/';

  /// Example: same Mac, physical phone on Wi‑Fi — replace with your machine IP.
  static const String localLanBaseUrl = 'http://192.168.1.2:8080/';

  static String get name => appFlavor?.name ?? '';

  static const String awsDevBaseUrl = secureDevApiBaseUrl;
  static const String awsStagingBaseUrl = secureDevApiBaseUrl;

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
        // Local Spring Boot for ops/passenger/captain end-to-end testing.
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