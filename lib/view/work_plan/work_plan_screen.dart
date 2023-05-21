import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

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
  String startTimeForFrontEnd = 'select start time';
  DateTime startTimeForBackEnd = DateTime.now();
  String endTimeForFrontEnd = 'select end time';
  DateTime endTimeForBackEnd = DateTime.now();
  PreferenceManager preferenceManager = PreferenceManager();
  final formKey = GlobalKey<FormState>();
  final Box box = Hive.box('workPlan');

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    setState(() {});
    calendarTapDetail = calendarTapDetails;
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
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, widget) {
          List<WorkPlanModel> workPlanList = [];
          if (box.isNotEmpty) {
            List<dynamic> dynamicWorkPlanList = box.values.toList();

            if (dynamicWorkPlanList.isNotEmpty) {
              workPlanList = dynamicWorkPlanList.cast<WorkPlanModel>();
            }
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Expanded(
                  child: SfCalendar(
                    cellBorderColor: Colors.transparent,
                    // view: CalendarView.day,
                    view: CalendarView.day,
                    // monthViewSettings: const MonthViewSettings(showAgenda: true),
                    firstDayOfWeek: 1,
                    dataSource: MeetingDateSource(
                      getAppointments(
                        workPlanList: workPlanList,
                      ),
                    ),
                    // appointmentBuilder: (context, calendarAppointmentDetails) {
                    //   return Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.blue, // Set the desired background color
                    //       borderRadius: BorderRadius.circular(8.0), // Set the desired border radius
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Text(calendarAppointmentDetails.appointments.first.subject), // Display the name of the work plan
                    //         Text(
                    //           '${calendarAppointmentDetails.appointments.first.startTime} - ${calendarAppointmentDetails.appointments.first.endTime}', // Display the start and end time
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    // },
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
          );
        },
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
                          key: formKey,
                          child: TextFormField(
                            controller: nameController,
                            style: CustomTextStyle.kBodyText2,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.0.h, horizontal: 10.0.w),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: greenColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: greenColor),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: greenColor),
                                ),
                                label: Text(
                                  'work plan name',
                                  style: CustomTextStyle.kBodyText2,
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the work plan name';
                              } else {
                                return null;
                              }
                            },
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
                            if (dateTime != null) {
                              workPlanDateForFrontEnd =
                                  DateFormat('MM/dd/yyyy').format(
                                dateTime,
                              );
                              workPlanDateForBackend = dateTime;
                              setState(() {});
                            }
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

                              startTimeForBackEnd = workPlanDateForBackend;

                              if (preferenceManager.getTimeFormat == '24h') {
                                startTimeForFrontEnd = DateFormat.Hm()
                                    .addPattern('a')
                                    .format(workPlanDateForBackend);
                              } else {
                                startTimeForFrontEnd = DateFormat.jm()
                                    .format(workPlanDateForBackend);
                              }
                            } else {
                              debugPrint("Time is not selected");
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
                              startTimeForFrontEnd,
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

                              endTimeForBackEnd = workPlanDateForBackend;
                              if (preferenceManager.getTimeFormat == '24h') {
                                endTimeForFrontEnd = DateFormat.Hm()
                                    .addPattern('a')
                                    .format(workPlanDateForBackend);
                              } else {
                                endTimeForFrontEnd = DateFormat.jm()
                                    .format(workPlanDateForBackend);
                              }
                            } else {
                              debugPrint("Time is not selected");
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
                              endTimeForFrontEnd,
                              style: CustomTextStyle.kBodyText2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (workPlanDateForFrontEnd == 'select date' ||
                                startTimeForFrontEnd == 'select start time' ||
                                endTimeForFrontEnd == 'select end time') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Select Date or Start Time or End Time'),
                                  backgroundColor: redColor,
                                ),
                              );
                            } else {
                              const uuid = Uuid();
                              String id = uuid.v4();
                              WorkPlanModel workPlanModel = WorkPlanModel(
                                id: id,
                                workPlanName: nameController.text,
                                startWorkPlanTime: startTimeForBackEnd,
                                endWorkPlanTime: endTimeForBackEnd,
                              );

                              await box.put(id, workPlanModel).then((value) {
                                nameController.clear();
                                startTimeForFrontEnd = 'select start time';
                                endTimeForFrontEnd = 'select end time';
                                workPlanDateForFrontEnd = 'select date';
                                Navigator.of(context).pop();
                              });
                            }
                          }
                        },
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

class MeetingDateSource extends CalendarDataSource {
  MeetingDateSource(List<Appointment> source) {
    appointments = source;
  }
}
