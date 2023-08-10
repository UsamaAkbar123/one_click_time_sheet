import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/custom_save_pdf_send_email_button.dart';

Widget sumBlock({
  required int totalHours,
  required int totalMinutes,
  required String listId,
  required List<HistoryElement> historyElement,
  required BuildContext context,
}) {
  return SizedBox(
    height: 30.h,
    width: double.infinity,
    child: Row(
      children: [
        Container(
          width: 50.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          padding: EdgeInsets.only(left: 3.w),
          child: Text('Sum', style: CustomTextStyle.kBodyText2),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return AddNewHistoryElementOfJob(
                  listId: listId,
                  historyElement: historyElement,
                );
              },
            ));
          },
          child: Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.edit,
                  size: 12.h,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Add',
                  style: CustomTextStyle.kBodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 50.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: Text(
            '',
            style: CustomTextStyle.kBodyText2,
          ),
        ),
        Expanded(
          child: Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Text(
              '',
              style: CustomTextStyle.kBodyText2,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Text(
              '$totalHours:${totalMinutes.toString().padLeft(2, '0')}',
              style: CustomTextStyle.kBodyText2,
            ),
          ),
        ),
        Container(
          width: 50.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(),
              Container(color: Colors.grey, width: 1),
              const SizedBox(),
            ],
          ),
        ),
      ],
    ),
  );
}

class AddNewHistoryElementOfJob extends StatefulWidget {
  final String listId;
  final List<HistoryElement> historyElement;
  const AddNewHistoryElementOfJob({
    required this.listId,
    required this.historyElement,
    super.key,
  });

  @override
  State<AddNewHistoryElementOfJob> createState() =>
      _AddNewHistoryElementOfJobState();
}

class _AddNewHistoryElementOfJobState extends State<AddNewHistoryElementOfJob> {
  List jobTypeList = [
    'Unpaid break',
    'paid break',
  ];
  String selectedJobType = '';
  String selectTimeForJob = 'select job time';
  TimeOfDay startInitialTime = TimeOfDay.now();
  PreferenceManager preferenceManager = PreferenceManager();

  @override
  void initState() {
    selectedJobType = jobTypeList[0];
    super.initState();
  }

  setStartTimeForFrontAndBackend({
    TimeOfDay? pickedTime,
    DateTime? editDateTime,
  }) {
    setState(() {
      DateTime jobDate = DateTime(
        widget.historyElement[0].time?.year ?? 0,
        widget.historyElement[0].time?.month ?? 0,
        widget.historyElement[0].time?.day ?? 0,
        pickedTime?.hour ?? 0,
        pickedTime?.minute ?? 0,
      );

      if (preferenceManager.getTimeFormat == '24h') {
        selectTimeForJob = DateFormat.Hm().format(jobDate);
      } else {
        selectTimeForJob = DateFormat.jm().format(jobDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Job Element',
          style: CustomTextStyle.kBodyText2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Text(
              'Job Type',
              style: CustomTextStyle.kBodyText2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              // width: 120.w,
              height: 30.h,
              padding: EdgeInsets.only(
                left: 4.w,
                right: 4.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                border: Border.all(
                  color: blackColor,
                  width: .5.w,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: whiteColor,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.h,
                    color: blackColor,
                  ),
                  isExpanded: true,
                  hint: Text(
                    'Monday',
                    style: CustomTextStyle.kBodyText2,
                  ),
                  value: selectedJobType,
                  items: [
                    for (int i = 0; i < jobTypeList.length; i++)
                      DropdownMenuItem(
                        value: jobTypeList[i],
                        child: Text(
                          jobTypeList[i],
                          style: CustomTextStyle.kBodyText2.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      selectedJobType = val.toString();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Select Time',
              style: CustomTextStyle.kBodyText2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  initialTime: startInitialTime,
                  context: context,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        alwaysUse24HourFormat:
                            preferenceManager.getTimeFormat == '24h',
                      ),
                      child: child ?? const SizedBox(),
                    );
                  }, //context of current state
                );
                if (pickedTime != null) {
                  setStartTimeForFrontAndBackend(pickedTime: pickedTime);
                } else {
                  debugPrint("Time is not selected");
                }
              },
              child: Container(
                height: 30.h,
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 4.w,
                  right: 4.w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(
                    color: blackColor,
                    width: .5.w,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(selectTimeForJob),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomSavePdfSendEmailButton(
                  buttonText: 'save',
                  onTab: () {},
                  buttonColor: greenColor,
                ),
                SizedBox(width: 10.w),
                CustomSavePdfSendEmailButton(
                  buttonText: 'cancel',
                  onTab: () {
                    Navigator.of(context).pop();
                  },
                  buttonColor: redColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
