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
}
