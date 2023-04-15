import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeScreenTitle => 'Title';

  @override
  String get homeScreenPlan => 'Plan:';

  @override
  String get homeScreenRefreshTime => 'Refresh time';

  @override
  String get homeScreenStartJob => 'Start job';

  @override
  String get homeScreenEndJob => 'End job';

  @override
  String get homeScreenPaidBreak => 'Paid Break';

  @override
  String get homeScreenUnPaidBreak => 'Unpaid Break';

  @override
  String get homeScreenLastHistory => 'Last history:';

  @override
  String get settingScreenTitle => 'Settings';

  @override
  String get settingScreenSelectLanguage => 'Language';

  @override
  String get settingScreenFirstDayOfWeek => 'First Day Of Week';

  @override
  String get settingScreenDateFormat => 'Data Format';

  @override
  String get settingScreenTimeFormat => 'Time Format';

  @override
  String get settingScreenStartJobNotification => 'Start Job Notification';

  @override
  String get settingScreenEndJobNotification => 'End Job Notification';

  @override
  String get settingScreenSaveChangesButtonText => 'save changes';

  @override
  String get settingScreenRestoreDatabaseButtonText => 'Restore Database';

  @override
  String get settingScreenBackupDatabaseButtonText => 'Backup Database';
}
