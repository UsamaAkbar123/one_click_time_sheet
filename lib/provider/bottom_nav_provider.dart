import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/view/home/home_screen.dart';
import 'package:one_click_time_sheet/view/reports/report_screen.dart';
import 'package:one_click_time_sheet/view/settings/setting_screen.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_screen.dart';

class BottomNavigationProvider extends ChangeNotifier{

  int _currentTab = PreferenceManager().getIsFirstLaunch ? 3:0;

  List<Widget> screens = const[
    HomeScreen(),
    ReportScreen(),
    WorkPlanScreen(),
    SettingScreen(),
  ];

  get currentTab => _currentTab;

  set setCurrentTab(int tab){

    _currentTab = tab;
    notifyListeners();
  }

  get currentScreen => screens[_currentTab];



}