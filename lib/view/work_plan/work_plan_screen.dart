import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/alert_box_for_workplan_adding.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/appoinment_details_box.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/meeting_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkPlanScreen extends StatefulWidget {
  const WorkPlanScreen({Key? key}) : super(key: key);

  @override
  State<WorkPlanScreen> createState() => _WorkPlanScreenState();
}

class _WorkPlanScreenState extends State<WorkPlanScreen> {
  CalendarTapDetails? calendarTapDetail;

  final Box box = Hive.box('workPlan');

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
                    view: CalendarView.day,
                    firstDayOfWeek: 1,
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
