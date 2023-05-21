import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/routes/custom_routes.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/utills/theme/theme.dart';
import 'managers/preference_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'model/hive_job_history_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceManager().init();
  await Hive.initFlutter();
  Hive.registerAdapter(JobHistoryModelAdapter());
  Hive.registerAdapter(HistoryElementAdapter());
  Hive.registerAdapter(WorkPlanModelAdapter());
  await Hive.openBox('jobHistoryBox');
  await Hive.openBox('workPlan');
  CustomTextStyle();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            darkTheme: appTheme,
            onGenerateRoute: CustomRouter.allRoutes,
          );
        });
  }
}
