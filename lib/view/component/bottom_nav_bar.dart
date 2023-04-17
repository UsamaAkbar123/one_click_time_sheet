import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/provider/bottom_nav_provider.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomNavigationProvider>(
      create: (context) => BottomNavigationProvider(),
      child: Consumer<BottomNavigationProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body: provider.currentScreen,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)?.bottomNavBarHomeTabText ?? '',
                  icon: const Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)?.bottomNavBarReportTabText ?? '',
                  icon:const Icon(Icons.content_paste_go_sharp),
                ),
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)?.bottomNavBarWorkPlanTabText ?? '',
                  icon:const Icon(Icons.calendar_month),
                ),
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)?.bottomNavBarSettingTabText ?? '',
                  icon:const Icon(Icons.settings),
                ),
              ],
              currentIndex: provider.currentTab,
              selectedItemColor: greenColor,
              unselectedItemColor: greyColor,
              selectedFontSize: 10.sp,
              showUnselectedLabels: true,

              unselectedFontSize: 10.sp,
              iconSize: 23.h,
              onTap: (int index){
                provider.setCurrentTab = index;
              },
            ),
          );
        },
      ),
    );
  }
}
