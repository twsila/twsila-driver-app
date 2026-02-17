import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/utils/resources/theme_manager.dart';

import '../utils/resources/global_key.dart';
import '../utils/resources/langauge_manager.dart';
import '../utils/resources/routes_manager.dart';
import 'app_prefs.dart';
import 'bloc_providers.dart';
import 'di.dart';
import 'package:easy_localization/easy_localization.dart';

class MyApp extends StatefulWidget {
  // named constructor
  MyApp._internal();

  int appState = 0;

  static final MyApp _instance =
      MyApp._internal(); // singleton or single instance

  factory MyApp() => _instance; // factory

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {
          context.setLocale(local),
          // Get.updateLocale(Locale(local.languageCode))
        });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: blocProviders(context),
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
        // fallbackLocale: context.locale,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.splashRoute,
        navigatorKey: NavigationService.navigatorKey,
        theme: getApplicationTheme(),
      ),
    );
  }
}
