import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _localLanguage = const Locale('en');
  PreferenceManager preferenceManager = PreferenceManager();

  Future<void> setLocalBasedOnLanguagePreferenceValue() async {
    final String preferredLanguage = PreferenceManager().getLanguage;
    switch (preferredLanguage) {
      case 'English':
        _localLanguage = const Locale('en');
        break;

      case 'Spanish':
        _localLanguage = const Locale('es');
        break;
      default:
        _localLanguage = const Locale('en');
    }
  }

  get localLanguage => _localLanguage;

  set setLocal(String languageCode) {
    _localLanguage = Locale(languageCode);
    notifyListeners();
  }
}
