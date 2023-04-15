import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/routes/routes_names.dart';
import 'package:one_click_time_sheet/view/home/home_screen.dart';
import 'package:one_click_time_sheet/view/not_found_page.dart';
import 'package:one_click_time_sheet/view/settings/setting_screen.dart';
import 'package:one_click_time_sheet/view/splash/splash_screen.dart';
class CustomRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case splashScreenRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case homeScreenRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case settingScreenRoute:
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
