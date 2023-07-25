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

  @override
  void initState() {
    super.initState();
    final dynamicList = jobHistoryBox.get(widget.listKey);
    for (int i = 0; i < dynamicList.length; i++) {
      jobList.add(dynamicList[i] as JobHistoryModel);
    }

    // for (int i = 0; i < jobList.length; i++) {
    //   List<HistoryElement> historyElement = jobList[i].historyElement ?? [];
    //   if (historyElement.length == widget.historyElement!.length) {
    //     // print(true);
    //   }
    // }
    // print(jobList.runtimeType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          TextEditingController jobNameController =
              TextEditingController(text: widget.historyElement?[index].type);
          DateTime? jobTime = widget.historyElement?[index].time;

          String showJobTime = preferenceManager.getTimeFormat == '12h'
              ? DateFormat.jm().format(jobTime ?? DateTime.now())
              : DateFormat.Hm().format(jobTime ?? DateTime.now());

          String dateOfJob = DateFormat(preferenceManager.getDateFormat)
              .format(jobTime ?? DateTime.now());

          return Padding(
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
                        key: UniqueKey(),
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
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Container(
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
                        showJobTime,
                        style: CustomTextStyle.kBodyText1
                            .copyWith(fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(width: 5.w),
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
                      child: Text(
                        dateOfJob,
                        style: CustomTextStyle.kBodyText1
                            .copyWith(fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(width: 5.w),

                    /// Save Button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
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
                            // print('object');
                            // break;
                            for (int j = 0;
                                j < widget.historyElement!.length;
                                j++) {
                              if (historyElement[j].elementId == elementId) {
                                jobList[i].historyElement?[j].type = 'ali';

                                // jobHistoryBox.put(widget.listKey,
                                //     jobList[i].historyElement?[j]);

                                setState(() {});

                                break;
                              }
                            }
                            // print(true);
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
          );
        },
      ),
    );
  }
}
