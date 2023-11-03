// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/alert_box_for_workplan_adding.dart';
import 'package:one_click_time_sheet/view/work_plan/work_plan_component/appointment_text_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppointmentDetailsBox extends StatefulWidget {
  final CalendarTapDetails? calendarTapDetail;

  const AppointmentDetailsBox({Key? key, this.calendarTapDetail})
      : super(key: key);

  @override
  State<AppointmentDetailsBox> createState() => _AppointmentDetailsBoxState();
}

class _AppointmentDetailsBoxState extends State<AppointmentDetailsBox> {
  PreferenceManager preferenceManager = PreferenceManager();
  Box box = Hive.box('workPlan');
  late Appointment tappedMeeting;
  String meetingStatus = '';

  @override
  void initState() {
    tappedMeeting =
        widget.calendarTapDetail?.appointments?.first as Appointment;
    if (tappedMeeting.endTime.isBefore(DateTime.now())) {
      meetingStatus = 'old';
    } else {
      meetingStatus = 'new';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: EdgeInsets.only(top: 10.h, right: 10.w, bottom: 10.h),
      icon: meetingStatus == 'old'
          ? const SizedBox()
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    // User? user = FirebaseAuth.instance.currentUser;
                    box.delete(tappedMeeting.id).then((value) {
                      Navigator.of(context).pop();
                    });
                    // if (user != null) {
                    //   // print('user id: ${user.uid}');
                    //   try {
                    //     final DocumentReference documentRef = FirebaseFirestore
                    //         .instance
                    //         .collection('workPlanBackup')
                    //         .doc(user.uid);

                    //     // Get the current data from the document
                    //     DocumentSnapshot snapshot = await documentRef.get();
                    //     if (snapshot.exists) {
                    //       // Retrieve the list of maps from the document
                    //       Map<String, dynamic> dataMap =
                    //           snapshot.data() as Map<String, dynamic>;

                    //       dataMap.remove(tappedMeeting.id);

                    //       debugPrint('map data: $dataMap');

                    //       // Update the document with the modified list
                    //       await documentRef.set(dataMap);
                    //       debugPrint('Item deleted successfully');
                    //     } else {
                    //       debugPrint('Document not found');
                    //     }
                    //   } catch (e) {
                    //     debugPrint('Error deleting item: $e');
                    //   }
                    // }
                  },
                  child: Icon(
                    Icons.delete,
                    color: blackColor.withOpacity(0.4),
                  ),
                ),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AddWorkPlanBox(
                          isEditMode: true,
                          id: tappedMeeting.id.toString(),
                          workPlanName: tappedMeeting.subject,
                          startTime: tappedMeeting.startTime,
                          endTime: tappedMeeting.endTime,
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.edit,
                    color: blackColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(AppLocalizations.of(context)?.workPlanDetailBoxTitle ?? ''),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppointmentTextWidget(
            title:
                '${AppLocalizations.of(context)?.workPlanDetailBoxSubject ?? ''}: ',
            value: widget.calendarTapDetail?.appointments?.first.subject,
            valueTextColor: blueColor,
          ),
          AppointmentTextWidget(
            title:
                '${AppLocalizations.of(context)?.workPlanDetailBoxStartTime ?? ''}: ',
            value: preferenceManager.getTimeFormat == '12h'
                ? DateFormat.jm().format(
                    widget.calendarTapDetail?.appointments?.first.startTime)
                : DateFormat.Hm().format(
                    widget.calendarTapDetail?.appointments?.first.startTime),
            valueTextColor: greenColor,
          ),
          AppointmentTextWidget(
            title:
                '${AppLocalizations.of(context)?.workPlanDetailBoxEndTime ?? ''}: ',
            value: preferenceManager.getTimeFormat == '12h'
                ? DateFormat.jm().format(
                    widget.calendarTapDetail?.appointments?.first.endTime)
                : DateFormat.Hm().format(
                    widget.calendarTapDetail?.appointments?.first.endTime),
            valueTextColor: redColor,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
              AppLocalizations.of(context)?.workPlanDetailBoxCloseButton ?? ''),
        ),
      ],
    );
  }
}
