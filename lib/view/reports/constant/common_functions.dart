import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';

/// get start and end time of report job
String getStartEndTimeOfReport(
    PreferenceManager preferenceManager, HistoryElement historyElement) {
  return preferenceManager.getTimeFormat == '12h'
      ? DateFormat('h:mm a').format(historyElement.time ?? DateTime.now())
      : DateFormat.Hm().format(
          historyElement.time ?? DateTime.now(),
        );
}

/// get start end date time of report
DateTime getStartEndDateTime(HistoryElement historyElement) {
  return DateTime(
      historyElement.time?.year ?? 0,
      historyElement.time?.month ?? 0,
      historyElement.time?.day ?? 0,
      historyElement.time?.hour ?? 0,
      historyElement.time?.minute ?? 0);
}

String selectMonth(val) {
  switch (val) {
    case 1:
      return 'January';

    case 2:
      return 'February';

    case 3:
      return 'March';

    case 4:
      return 'April';

    case 5:
      return 'May';

    case 6:
      return 'June';

    case 7:
      return 'July';

    case 8:
      return 'August';

    case 9:
      return 'September';

    case 10:
      return 'October';

    case 11:
      return 'November';

    case 12:
      return 'December';
    default:
      return '';
  }
}
