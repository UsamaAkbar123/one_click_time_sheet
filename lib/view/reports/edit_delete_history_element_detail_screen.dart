import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';

class EditDeleteHistoryElement extends StatefulWidget {
  final List<HistoryElement>? historyElement;
  final String listKey;
  // final List<JobHistoryModel> jobList;
  final int iIndex;
  final int jIndex;

  const EditDeleteHistoryElement({
    required this.historyElement,
    required this.listKey,
    // required this.jobList,
    required this.iIndex,
    required this.jIndex,
    super.key,
  });

  @override
  State<EditDeleteHistoryElement> createState() =>
      _EditDeleteHistoryElementState();
}

class _EditDeleteHistoryElementState extends State<EditDeleteHistoryElement> {
  PreferenceManager preferenceManager = PreferenceManager();
  final Box jobHistoryBox = Hive.box('jobHistoryBox');
  List<JobHistoryModel> jobList = [];
  TextEditingController jobNameController = TextEditingController();
  String jobTitle = '';
  DateTime? jobTime;
  DateTime? jobDate;

  @override
  void initState() {
    super.initState();
    final dynamicList = jobHistoryBox.get(widget.listKey);
    // print(dynamicList);
    if (dynamicList.isNotEmpty) {
      for (int i = 0; i < dynamicList.length; i++) {
        jobList.add(dynamicList[i] as JobHistoryModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Edit & Delete',
          style: CustomTextStyle.kHeading2,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.historyElement?.length ?? 0,
        itemBuilder: (context, index) {
          jobNameController =
              TextEditingController(text: widget.historyElement?[index].type);
          // DateTime? jobTime = widget.historyElement?[index].time;

          // String showJobTime = preferenceManager.getTimeFormat == '12h'
          //     ? DateFormat.jm().format(jobTime ?? DateTime.now())
          //     : DateFormat.Hm().format(jobTime ?? DateTime.now());

          // String dateOfJob = DateFormat(preferenceManager.getDateFormat)
          //     .format(jobTime ?? DateTime.now());

          return SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Container(
                        height: 28.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.r),
                          border: Border.all(
                            color: blackColor.withOpacity(0.3),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          // key: UniqueKey(),
                          textAlign: TextAlign.center,
                          controller: jobNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              // left: 4.w,
                              bottom: 16.h,
                            ),
                          ),
                          style: TextStyle(fontSize: 12.sp),
                          onChanged: (value) {
                            jobTitle = value;
                            // print(jobTitle);
                          },
                        ),
                      ),
                      SizedBox(width: 5.w),
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.fromDateTime(
                                widget.historyElement?[index].time ??
                                    DateTime.now()),
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
                            DateTime dateTime =
                                widget.historyElement?[index].time ??
                                    DateTime.now();
                            jobTime = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );

                            // print(jobTime);
                          }
                        },
                        child: Container(
                          height: 28.h,
                          width: 55.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.r),
                            border: Border.all(
                              color: blackColor.withOpacity(0.3),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            preferenceManager.getTimeFormat == '12h'
                                ? DateFormat.jm().format(
                                    widget.historyElement?[index].time ??
                                        DateTime.now())
                                : DateFormat.Hm().format(
                                    widget.historyElement?[index].time ??
                                        DateTime.now()),
                            style: CustomTextStyle.kBodyText1
                                .copyWith(fontSize: 12.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      GestureDetector(
                        onTap: () async {
                          // DateTime? dateTime = await showDatePicker(
                          //   context: context,
                          //   initialDate: widget.historyElement?[index].time ??
                          //       DateTime.now(),
                          //   firstDate: widget.historyElement?[index].time ??
                          //       DateTime.now(),
                          //   lastDate: DateTime(2030, 12, 31),
                          // );
                          // if (dateTime != null) {
                          //   jobDate = dateTime;
                          //   print(jobDate);
                          // }
                        },
                        child: Container(
                          height: 28.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.r),
                            border: Border.all(
                              color: blackColor.withOpacity(0.3),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            DateFormat(preferenceManager.getDateFormat).format(
                                widget.historyElement?[index].time ??
                                    DateTime.now()),
                            style: CustomTextStyle.kBodyText1
                                .copyWith(fontSize: 12.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),

                      /// Save Button
                      GestureDetector(
                        onTap: () async {
                          // Navigator.of(context).pop();
                          String elementId =
                              widget.historyElement?[index].elementId ?? '';
                          for (int i = 0; i < jobList.length; i++) {
                            List<HistoryElement> historyElement =
                                jobList[i].historyElement ?? [];
                            if (historyElement.length ==
                                widget.historyElement!.length) {
                              for (int j = 0;
                                  j < widget.historyElement!.length;
                                  j++) {
                                if (historyElement[j].elementId == elementId) {
                                  if (jobTitle != '') {
                                    jobList[i].historyElement?[j].type =
                                        jobTitle;

                                    await jobHistoryBox
                                        .put(widget.listKey, jobList)
                                        .then((value) {
                                      jobTitle = '';
                                    });
                                  }

                                  if (jobTime != null) {
                                    jobList[i].historyElement?[j].time =
                                        jobTime;

                                    await jobHistoryBox
                                        .put(widget.listKey, jobList)
                                        .then((value) {
                                      jobTime = null;
                                    });
                                  }

                                  // print(jobTitle);
                                  // print(jobTime);

                                  setState(() {});

                                  break;
                                }
                              }
                            }
                          }
                        },
                        child: Container(
                          height: 28.h,
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Save',
                            style: CustomTextStyle.kBodyText1.copyWith(
                                fontSize: 12.sp,
                                color: whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),

                      /// Delete Button
                      GestureDetector(
                        onTap: () {
                          //Navigator.of(context).pop();

                          String elementId =
                              widget.historyElement?[index].elementId ?? '';
                          for (int i = 0; i < jobList.length; i++) {
                            List<HistoryElement> historyElement =
                                jobList[i].historyElement ?? [];
                            if (historyElement.length ==
                                widget.historyElement!.length) {
                              for (int j = 0;
                                  j < widget.historyElement!.length;
                                  j++) {
                                if (historyElement[j].elementId == elementId) {
                                  jobList[i].historyElement?.removeAt(j);

                                  jobHistoryBox.put(widget.listKey, jobList);

                                  setState(() {});

                                  break;
                                }
                              }
                            }
                          }
                        },
                        child: Container(
                          height: 28.h,
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: redColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Delete',
                            style: CustomTextStyle.kBodyText1.copyWith(
                                fontSize: 12.sp,
                                color: whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
