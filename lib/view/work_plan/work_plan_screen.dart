import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkPlanScreen extends StatefulWidget {
  const WorkPlanScreen({Key? key}) : super(key: key);

  @override
  State<WorkPlanScreen> createState() => _WorkPlanScreenState();
}

class _WorkPlanScreenState extends State<WorkPlanScreen> {
  CalendarTapDetails? calendarTapDetail;

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    setState(() {});
    calendarTapDetail = calendarTapDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.workPlanScreenTitle ?? '',
          style: CustomTextStyle.kHeading2,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.lock_clock,
                  color: greenColor,
                  size: 27.w,
                ),
                SizedBox(width: 10.w),
                Text(
                  '20 hrs 22 mins',
                  style: CustomTextStyle.kBodyText1.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: SfCalendar(
                cellBorderColor: Colors.transparent,
                // view: CalendarView.day,
                view: CalendarView.week,
                // monthViewSettings: const MonthViewSettings(showAgenda: true),
                firstDayOfWeek: 1,
                dataSource: MeetingDateSource(getAppointments()),
                // initialDisplayDate: DateTime(2023, 4, 15, 08, 30),
                // initialSelectedDate: DateTime(2023, 4, 15, 08, 30),
                //backgroundColor: Colors.white,
                // appointmentTextStyle: const TextStyle(color: Colors.black
                // //   // darkThemeProvider.darkTheme? Colors.black: Colors.white
                //  ),
                // timeSlotViewSettings: TimeSlotViewSettings(
                //     startHour: 9,
                //     endHour: 16,
                //     nonWorkingDays: <int>[DateTime.friday, DateTime.saturday]),
                // monthViewSettings: const MonthViewSettings(
                //   appointmentDisplayMode:
                //   MonthAppointmentDisplayMode.appointment,
                // ),
                // firstDayOfWeek: 1,
                // // dataSource: _dataSource,
                onTap: calendarTapped,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = [];
  final DateTime today = DateTime.now();
  final DateTime startTime = DateTime(
    today.year,
    today.month,
    today.day,
    9,
    0,
    0,
  );
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(
    Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Conference',
      color: greenColor,
    ),
  );
  meetings.add(
    Appointment(
      startTime: startTime.add(const Duration(hours: 3)),
      endTime: endTime,
      subject: 'Meeting With Client',
      color: blueColor,
    ),
  );

  return meetings;
}

class MeetingDateSource extends CalendarDataSource {
  MeetingDateSource(List<Appointment> source) {
    appointments = source;
  }
}
