import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/routes/routes_names.dart';
import 'package:one_click_time_sheet/view/component/bottom_nav_bar.dart';
import 'package:one_click_time_sheet/view/home/home_screen.dart';
import 'package:one_click_time_sheet/view/not_found_page.dart';
import 'package:one_click_time_sheet/view/reports/report_screen.dart';
import 'package:one_click_time_sheet/view/settings/setting_screen.dart';
import 'package:one_click_time_sheet/view/splash/splash_screen.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_screen.dart';

class CustomRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case splashScreenRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case homeScreenRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case settingScreenRoute:
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      case workPlanScreenRoute:
        return MaterialPageRoute(builder: (_) => const WorkPlanScreen());
      case reportScreenRoute:
        return MaterialPageRoute(builder: (_) => const ReportScreen());
      case bottomNavBarScreenRoute:
        final arg = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => BottomNavBar(bottomNavIndexForReportDetail: arg),
        );
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
