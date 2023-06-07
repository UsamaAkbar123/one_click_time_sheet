import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Keys {
  static const firstTimeLaunch = "first_launch";
  static const timeFormat = "time_format";
  static const dateFormat = "date_format";
  static const language = "language";
  static const firstDayOfWeek = "first_day_of_week";
  static const startJobNotification = "start_job_notification";
  static const endJobNotification = "end_job_notification";
}

class PreferenceManager {
  /// Shared object which is used. No new instances are created for this class
  static final PreferenceManager _shared = PreferenceManager._internal();

  /// Factory returns `_shared` object for every
  /// instantiation like `PreferenceManager()`
  factory PreferenceManager() {
    return _shared;
  }

  /// Private constructor
  PreferenceManager._internal();

  /// SharedPreferences instance
  SharedPreferences? _prefs;

  /// Boolean get to check if `_prefs` are initialized
  bool get _isInitialized => _prefs != null;

// Set prefs
  set prefs(SharedPreferences prefs) => {
        if (_isInitialized)
          {
            debugPrint(
                "🐞 WARNING: SharedPreferences are already initialized. Should only be initialized once.")
          }
        else
          {_prefs = prefs}
      };

  /// Initializes `SharedPreferences`. This has to be set after
  /// `WidgetsFlutterBinding.ensureInitialized();`. This ensures
  /// that native libraries are loaded. Native library in this
  /// case is `SharedPreferences` instance.
  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool get getIsFirstLaunch => _prefs?.getBool(_Keys.firstTimeLaunch) ?? true;

  set setIsFirstLaunch(bool value) =>
      _prefs?.setBool(_Keys.firstTimeLaunch, value);

  String get getTimeFormat => _prefs?.getString(_Keys.timeFormat) ?? '24h';
  set setTimeFormat(String value) =>
      _prefs?.setString(_Keys.timeFormat, value) ?? '24h';

  String get getDateFormat =>
      _prefs?.getString(_Keys.dateFormat) ?? 'dd/MM/yyyy';
  set setDateFormat(String value) =>
      _prefs?.setString(_Keys.dateFormat, value) ?? 'dd/MM/yyyy';

  String get getLanguage => _prefs?.getString(_Keys.language) ?? '';
  set setLanguage(String value) =>
      _prefs?.setString(_Keys.language, value) ?? '';

  String get getFirstDayOfWeek =>
      _prefs?.getString(_Keys.firstDayOfWeek) ?? 'Monday';
  set setFirstDayOfWeek(String value) =>
      _prefs?.setString(_Keys.firstDayOfWeek, value) ?? 'Monday';

  String get getStartJobNotification =>
      _prefs?.getString(_Keys.startJobNotification) ?? '';
  set setStartJobNotification(String value) =>
      _prefs?.setString(_Keys.startJobNotification, value) ?? '';

  String get getEndJobNotification =>
      _prefs?.getString(_Keys.endJobNotification) ?? '';
  set setEndJobNotification(String value) =>
      _prefs?.setString(_Keys.endJobNotification, value) ?? '';
}
