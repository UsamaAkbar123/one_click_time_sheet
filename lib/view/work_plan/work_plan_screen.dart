import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/alert_box_for_workplan_adding.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/appoinment_details_box.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/meeting_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class WorkPlanScreen extends StatefulWidget {
  const WorkPlanScreen({Key? key}) : super(key: key);

  @override
  State<WorkPlanScreen> createState() => _WorkPlanScreenState();
}

class _WorkPlanScreenState extends State<WorkPlanScreen> {
  CalendarTapDetails? calendarTapDetail;
  PreferenceManager preferenceManager = PreferenceManager();
  final Box box = Hive.box('workPlan');

  int getFirstDayOfWeek(String weekDay) {
    switch (weekDay) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      default:
        return 7;
    }
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    setState(() {});
    calendarTapDetail = calendarTapDetails;
    if (calendarTapDetail?.appointments != null &&
        calendarTapDetail!.appointments!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AppointmentDetailsBox(
            calendarTapDetail: calendarTapDetails,
          );
        },
      );
    } else {
      if (calendarTapDetails.date!.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('cannot add workplan before today date'),
            backgroundColor: redColor,
            showCloseIcon: true,
            closeIconColor: whiteColor,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AddWorkPlanBox(
              isEmptySpaceClick: true,
              startTime: calendarTapDetails.date,
              endTime:
                  calendarTapDetails.date?.add(const Duration(minutes: 60)),
            );
          },
        );
      }
    }
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
                    view: CalendarView.week,
                    timeSlotViewSettings: TimeSlotViewSettings(
                      timeFormat: preferenceManager.getTimeFormat == '12h'
                          ? 'hh:mm a'
                          : 'HH:mm',
                    ),
                    firstDayOfWeek:
                        getFirstDayOfWeek(preferenceManager.getFirstDayOfWeek),
                    dataSource: MeetingDateSource(
                      getAppointments(
                        workPlanList: workPlanList,
                      ),
                    ),
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
              return const AddWorkPlanBox();
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
