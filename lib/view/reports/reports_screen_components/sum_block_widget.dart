import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/routes/routes_names.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/reports/constant/common_functions.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/custom_save_pdf_send_email_button.dart';
import 'package:uuid/uuid.dart';

Widget sumBlock({
  required int totalHours,
  required int totalMinutes,
  required String listId,
  required List<HistoryElement> historyElement,
  required BuildContext context,
  required int iIndex,
  required int jIndex,
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
        // GestureDetector(
        //   onTap: () async {
        //     await Navigator.of(context).pushReplacement(MaterialPageRoute(
        //       builder: (context) {
        //         return AddNewHistoryElementOfJob(
        //           listId: listId,
        //           historyElement: historyElement,
        //           iIndex: iIndex,
        //           jIndex: jIndex,
        //         );
        //       },
        //     ));
        //   },
        //   child: Container(
        //     width: 50.w,
        //     alignment: Alignment.center,
        //     decoration: BoxDecoration(
        //       color: whiteColor,
        //       border: Border.all(
        //         color: Colors.grey,
        //       ),
        //     ),
        //     padding: EdgeInsets.symmetric(horizontal: 5.h),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       children: [
        //         Icon(
        //           Icons.edit,
        //           size: 12.h,
        //         ),
        //         SizedBox(width: 1.w),
        //         Text(
        //           'Add',
        //           style: CustomTextStyle.kBodyText2.copyWith(
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
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
  final int iIndex;
  final int jIndex;
  const AddNewHistoryElementOfJob({
    required this.listId,
    required this.historyElement,
    required this.iIndex,
    required this.jIndex,
    super.key,
  });

  @override
  State<AddNewHistoryElementOfJob> createState() =>
      _AddNewHistoryElementOfJobState();
}

class _AddNewHistoryElementOfJobState extends State<AddNewHistoryElementOfJob> {
  List jobTypeList = [
    'Unpaid break',
    'Paid break',
  ];
  String selectedJobType = '';

  TimeOfDay startInitialTime = TimeOfDay.now();
  PreferenceManager preferenceManager = PreferenceManager();

  final Box jobHistoryBox = Hive.box('jobHistoryBox');
  List<JobHistoryModel> jobList = [];

  late JobHistoryModel finalObjectOfList;
  late DateTime startTime;
  late DateTime endTime;
  String selectTimeForJobFrontEnd = 'select job time';
  DateTime selectTimeForJobBackEnd = DateTime.now();
  @override
  void initState() {
    selectedJobType = jobTypeList[0];

    final dynamicList = jobHistoryBox.get(widget.listId);

    if (dynamicList.isNotEmpty) {
      for (int i = 0; i < dynamicList.length; i++) {
        jobList.add(dynamicList[i] as JobHistoryModel);
      }
    }

    finalObjectOfList = jobList[widget.jIndex];

    startTime = getStartEndDateTime(finalObjectOfList.historyElement!.first);
    endTime = getStartEndDateTime(finalObjectOfList.historyElement!.last);

    // if (preferenceManager.getTimeFormat == '24h') {
    //   selectTimeForJob = DateFormat.Hm().format(startTime);
    // } else {
    //   selectTimeForJob = DateFormat.jm().format(jobDate);
    // }

    debugPrint(DateFormat.Hm().format(startTime));
    debugPrint(DateFormat.Hm().format(endTime));
    super.initState();
  }

  setStartTimeForFrontAndBackend({TimeOfDay? pickedTime}) {
    setState(() {
      DateTime jobDate = DateTime(
        widget.historyElement[0].time?.year ?? 0,
        widget.historyElement[0].time?.month ?? 0,
        widget.historyElement[0].time?.day ?? 0,
        pickedTime?.hour ?? 0,
        pickedTime?.minute ?? 0,
      );

      selectTimeForJobBackEnd = jobDate;

      if (preferenceManager.getTimeFormat == '24h') {
        selectTimeForJobFrontEnd = DateFormat.Hm().format(jobDate);
      } else {
        selectTimeForJobFrontEnd = DateFormat.jm().format(jobDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.of(context).pushReplacementNamed(
          bottomNavBarScreenRoute,
          arguments: 1,
        );
        return true;
      },
      child: Scaffold(
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
                  child: Text(selectTimeForJobFrontEnd),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomSavePdfSendEmailButton(
                    buttonText: 'save',
                    onTab: () {
                      if (selectTimeForJobFrontEnd == 'select job time') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('select the job time'),
                            backgroundColor: redColor,
                          ),
                        );
                      } else {
                        if (isBetween(
                          selectTimeForJobBackEnd,
                          startTime,
                          endTime,
                        )) {
                          if (finalObjectOfList.historyElement!.length == 2) {
                            HistoryElement insertElement = HistoryElement(
                              type: selectedJobType,
                              time: selectTimeForJobBackEnd,
                              elementId: const Uuid().v4(),
                            );

                            finalObjectOfList.historyElement!
                                .insert(1, insertElement);
                            // finalObjectOfList.historyElement!
                            //     .insert(2, finalObjectOfList.historyElement![1]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('job is added successfully'),
                                backgroundColor: greenColor,
                              ),
                            );

                            Navigator.of(context).pushReplacementNamed(
                              bottomNavBarScreenRoute,
                              arguments: 1,
                            );
                            // Navigator.of(context).pop();
                          } else {
                            int insertionCount = 0;
                            for (int i = 1;
                                i <
                                    finalObjectOfList.historyElement!.length -
                                        1;
                                i++) {
                              if (selectTimeForJobBackEnd.isAfter(
                                  finalObjectOfList.historyElement![i].time!)) {
                                HistoryElement insertElement = HistoryElement(
                                  type: selectedJobType,
                                  time: selectTimeForJobBackEnd,
                                  elementId: const Uuid().v4(),
                                );
                                finalObjectOfList.historyElement!.insert(
                                    i + 1 + insertionCount, insertElement);
                                insertionCount++;
                              }

                              // Move the remaining list values one index increment
                              for (int j = i + insertionCount + 1;
                                  j <
                                      finalObjectOfList.historyElement!.length -
                                          1;
                                  j++) {
                                finalObjectOfList.historyElement!.insert(j,
                                    finalObjectOfList.historyElement![j + 1]);

                                // jobList[widget.jIndex].historyElement =
                                //     finalObjectOfList.historyElement;
                                // finalObjectOfList.historyElement![j] =
                                //     finalObjectOfList.historyElement![j + 1];
                              }
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('job is added successfully'),
                                backgroundColor: greenColor,
                              ),
                            );

                            Navigator.of(context).pushReplacementNamed(
                              bottomNavBarScreenRoute,
                              arguments: 1,
                            );
                            // Navigator.of(context).pop();

                            // jobHistoryBox.put(widget.listId, jobList).then((value) {
                            //   print('Date inserted');
                            // });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'select job time should be in between start and end time'),
                              backgroundColor: redColor,
                            ),
                          );
                        }
                      }
                    },
                    buttonColor: greenColor,
                  ),
                  SizedBox(width: 10.w),
                  CustomSavePdfSendEmailButton(
                    buttonText: 'cancel',
                    onTab: () {
                      // Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(
                        bottomNavBarScreenRoute,
                        arguments: 1,
                      );
                    },
                    buttonColor: redColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isBetween(DateTime dateToCheck, DateTime startDate, DateTime endDate) {
    return dateToCheck.isAfter(startDate) && dateToCheck.isBefore(endDate);
  }
}
