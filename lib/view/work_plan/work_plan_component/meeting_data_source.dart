import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingDateSource extends CalendarDataSource {
  MeetingDateSource(List<Appointment> source) {
    appointments = source;
  }
}

List<Appointment> getAppointments({
  required List<WorkPlanModel> workPlanList,
}) {
  List<Appointment> meetings = [];
  for (int i = 0; i < workPlanList.length; i++) {
    final DateTime startTime = DateTime(
      workPlanList[i].startWorkPlanTime.year,
      workPlanList[i].startWorkPlanTime.month,
      workPlanList[i].startWorkPlanTime.day,
      workPlanList[i].startWorkPlanTime.hour,
      workPlanList[i].startWorkPlanTime.minute,
      workPlanList[i].startWorkPlanTime.second,
    );

    final DateTime endTime = DateTime(
      workPlanList[i].endWorkPlanTime.year,
      workPlanList[i].endWorkPlanTime.month,
      workPlanList[i].endWorkPlanTime.day,
      workPlanList[i].endWorkPlanTime.hour,
      workPlanList[i].endWorkPlanTime.minute,
      workPlanList[i].endWorkPlanTime.second,
    );
    meetings.add(
      Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: workPlanList[i].workPlanName,
        color: greenColor,
      ),
    );
  }

  return meetings;
}
