import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
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
  final nameController = TextEditingController();
  String workPlanDateForFrontEnd = 'select date';
  DateTime workPlanDateForBackend = DateTime.now();
  String startTime = 'select start time';
  String endTime = 'select end time';
  PreferenceManager preferenceManager = PreferenceManager();

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
            // Row(
            //   children: [
            //     Icon(
            //       Icons.lock_clock,
            //       color: greenColor,
            //       size: 27.w,
            //     ),
            //     SizedBox(width: 10.w),
            //     Text(
            //       '20 hrs 22 mins',
            //       style: CustomTextStyle.kBodyText1.copyWith(
            //         fontSize: 18.sp,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ],
            // ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Work Plan Information',
                          style: CustomTextStyle.kHeading2.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Form(
                          child: SizedBox(
                            height: 40.h,
                            width: double.infinity,
                            child: TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(color: greenColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(color: greenColor),
                                  ),
                                  label: Text(
                                    'work plan name',
                                    style: CustomTextStyle.kBodyText2,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () async {
                            DateTime? dateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030, 12, 31),
                            );
                            workPlanDateForFrontEnd =
                                DateFormat('MM/dd/yyyy').format(
                              dateTime ?? DateTime.now(),
                            );
                            workPlanDateForBackend = dateTime ?? DateTime.now();
                            setState(() {});
                          },
                          child: Container(
                            height: 40.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: greenColor),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              workPlanDateForFrontEnd,
                              style: CustomTextStyle.kBodyText2,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context, //context of current state
                            );
                            if (pickedTime != null) {
                              setState(() {
                                workPlanDateForBackend = DateTime(
                                  workPlanDateForBackend.year,
                                  workPlanDateForBackend.month,
                                  workPlanDateForBackend.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            } else {
                              debugPrint("Time is not selected");
                            }
                            if (preferenceManager.getTimeFormat == '24h') {
                              startTime = DateFormat.Hm()
                                  .addPattern('a')
                                  .format(workPlanDateForBackend);
                            } else {
                              startTime = DateFormat.jm()
                                  .format(workPlanDateForBackend);
                            }
                          },
                          child: Container(
                            height: 40.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: greenColor)),
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              startTime,
                              style: CustomTextStyle.kBodyText2,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context, //context of current state
                            );
                            if (pickedTime != null) {
                              setState(() {
                                workPlanDateForBackend = DateTime(
                                  workPlanDateForBackend.year,
                                  workPlanDateForBackend.month,
                                  workPlanDateForBackend.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            } else {
                              debugPrint("Time is not selected");
                            }
                            if (preferenceManager.getTimeFormat == '24h') {
                              endTime = DateFormat.Hm()
                                  .addPattern('a')
                                  .format(workPlanDateForBackend);
                            } else {
                              endTime = DateFormat.jm()
                                  .format(workPlanDateForBackend);
                            }
                          },
                          child: Container(
                            height: 40.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: greenColor)),
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              endTime,
                              style: CustomTextStyle.kBodyText2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("save"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("cancel"),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
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
