import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/appointment_text_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class AppointmentDetailsBox extends StatelessWidget {
  final CalendarTapDetails ? calendarTapDetail;
  const AppointmentDetailsBox({Key? key,this.calendarTapDetail}) : super(key: key);

  static PreferenceManager preferenceManager = PreferenceManager();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Appointment Details'),
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
                ? DateFormat.jm().format(
                calendarTapDetail?.appointments?.first.startTime)
                : DateFormat.Hm().addPattern('a').format(
                calendarTapDetail?.appointments?.first.startTime),
            valueTextColor: greenColor,
          ),
          AppointmentTextWidget(
            title: 'End Time: ',
            value: preferenceManager.getTimeFormat == '12h'
                ? DateFormat.jm().format(
                calendarTapDetail?.appointments?.first.endTime)
                : DateFormat.Hm().addPattern('a').format(
                calendarTapDetail?.appointments?.first.endTime),
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
