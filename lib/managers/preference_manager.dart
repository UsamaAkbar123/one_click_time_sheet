import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Keys {
  static const firstTimeLaunch = "first_launch";
}

class PreferenceManager{
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

  bool get getIsNotificationsEnabled =>
      _prefs?.getBool(_Keys.firstTimeLaunch) ?? false;
  set setNotificationsEnabled(bool value) =>
      _prefs?.setBool(_Keys.firstTimeLaunch, value);
}