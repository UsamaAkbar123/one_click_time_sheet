import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/appointment_text_widget.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/meeting_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDetailsBox extends StatelessWidget {
  final CalendarTapDetails? calendarTapDetail;

  const AppointmentDetailsBox({Key? key, this.calendarTapDetail})
      : super(key: key);

  static PreferenceManager preferenceManager = PreferenceManager();
  static Box box = Hive.box('workPlan');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: EdgeInsets.only(top: 10.h, right: 10.w,bottom: 10.h),
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: (){
              // final tappedMeeting = calendarTapDetail?.appointments?.first as Appointment;
              // final meetingToDelete = box.values.firstWhere(
              //       (meeting) => meeting.id == tappedMeeting.id,
              //   orElse: () => null,
              // );
              // if (meetingToDelete != null) {
              //   box.delete(meetingToDelete.key);
              //   // Remove the appointment from the data source
              //   (calendarTapDetail?.resource as MeetingDateSource).appointments?.remove(tappedMeeting);
              // }else{
              //   print('not found');
              // }
              final tappedMeeting = calendarTapDetail?.appointments?.first;
              box.delete(tappedMeeting.id).then((value){
                print('delete');
              }).catchError((error){
                print(error);
              });
              //print(calendarTapDetail?.appointments?.first.key);
            },
            child: Icon(
              Icons.delete,
              color: blackColor.withOpacity(0.4),
            ),
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: (){},
            child: Icon(
              Icons.edit,
              color: blackColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text('Appointment Details'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppointmentTextWidget(
            title: 'Subject: ',
            value: calendarTapDetail?.appointments?.first.subject,
            valueTextColor: blueColor,
          ),
          AppointmentTextWidget(
            title: 'Start Time: ',
            value: preferenceManager.getTimeFormat == '12h'
                ? DateFormat.jm()
                    .format(calendarTapDetail?.appointments?.first.startTime)
                : DateFormat.Hm()
                    .addPattern('a')
                    .format(calendarTapDetail?.appointments?.first.startTime),
            valueTextColor: greenColor,
          ),
          AppointmentTextWidget(
            title: 'End Time: ',
            value: preferenceManager.getTimeFormat == '12h'
                ? DateFormat.jm()
                    .format(calendarTapDetail?.appointments?.first.endTime)
                : DateFormat.Hm()
                    .addPattern('a')
                    .format(calendarTapDetail?.appointments?.first.endTime),
            valueTextColor: redColor,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
