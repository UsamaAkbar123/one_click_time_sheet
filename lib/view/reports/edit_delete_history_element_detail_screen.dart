import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/routes/routes_names.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';

class EditDeleteHistoryElement extends StatefulWidget {
  final List<HistoryElement>? historyElement;
  final String listKey;
  final int iIndex;

  const EditDeleteHistoryElement({
    required this.historyElement,
    required this.listKey,
    required this.iIndex,
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
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    final dynamicList = jobHistoryBox.get(widget.listKey);

    if (dynamicList.isNotEmpty) {
      for (int i = 0; i < dynamicList.length; i++) {
        jobList.add(dynamicList[i] as JobHistoryModel);
      }
    }

    // print(jobList.length);
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Edit & Delete',
            style: CustomTextStyle.kHeading2,
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                bottomNavBarScreenRoute,
                arguments: 1,
              );
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: blackColor,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: widget.historyElement?.length ?? 0,
          itemBuilder: (context, index) {
            jobNameController = TextEditingController(
                text: selectedIndex == index && jobTitle != ''
                    ? jobTitle
                    : widget.historyElement?[index].type);

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
                              selectedIndex = index;
                              // print(jobTitle);
                            },
                          ),
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () async {
                            selectedIndex = index;
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.fromDateTime(
                                  widget.historyElement?[index].time ??
                                      DateTime.now()),
                              context: context,
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    alwaysUse24HourFormat:
                                        preferenceManager.getTimeFormat ==
                                            '24h',
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

                              setState(() {});
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
                                      selectedIndex == index && jobTime != null
                                          ? jobTime ?? DateTime.now()
                                          : widget.historyElement?[index]
                                                  .time ??
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
                            DateFormat(preferenceManager.getDateFormat).format(
                                widget.historyElement?[index].time ??
                                    DateTime.now()),
                            style: CustomTextStyle.kBodyText1
                                .copyWith(fontSize: 12.sp),
                          ),
                        ),
                        SizedBox(width: 5.w),

                        /// Save Button
                        GestureDetector(
                          onTap: () async {
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
                                  if (historyElement[j].elementId ==
                                      elementId) {
                                    if (jobTitle != '') {
                                      jobList[i].historyElement?[j].type =
                                          jobTitle;

                                      await jobHistoryBox
                                          .put(widget.listKey, jobList)
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                            'Job History Element Updated',
                                          ),
                                          backgroundColor: greenColor,
                                          showCloseIcon: true,
                                          closeIconColor: whiteColor,
                                        ));
                                        jobTitle = '';
                                      });
                                    }

                                    if (jobTime != null) {
                                      jobList[i].historyElement?[j].time =
                                          jobTime;

                                      await jobHistoryBox
                                          .put(widget.listKey, jobList)
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                            'Job History Element Updated',
                                          ),
                                          backgroundColor: greenColor,
                                          showCloseIcon: true,
                                          closeIconColor: whiteColor,
                                        ));

                                        jobTime = null;
                                      });
                                    }

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
                                  if (historyElement[j].elementId ==
                                      elementId) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Alert'),
                                          content: const Text(
                                              'Are you sure to delete the job history?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                jobList[i]
                                                    .historyElement
                                                    ?.removeAt(j);

                                                if (jobList[i]
                                                    .historyElement!
                                                    .isEmpty) {
                                                  jobList.removeAt(i);
                                                  if (jobList.isEmpty) {
                                                    await jobHistoryBox
                                                        .deleteAt(
                                                      widget.iIndex,
                                                    );
                                                    if (mounted) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  } else {
                                                    jobHistoryBox
                                                        .put(widget.listKey,
                                                            jobList)
                                                        .then((value) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: const Text(
                                                            'Job History Element Deleted',
                                                          ),
                                                          backgroundColor:
                                                              redColor,
                                                          showCloseIcon: true,
                                                          closeIconColor:
                                                              whiteColor,
                                                        ),
                                                      );
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  }
                                                } else {
                                                  User? user = FirebaseAuth
                                                      .instance.currentUser;

                                                  // if (user != null) {
                                                  //   try {
                                                  //     final DocumentReference
                                                  //         document =
                                                  //         FirebaseFirestore
                                                  //             .instance
                                                  //             .collection(
                                                  //                 'backup')
                                                  //             .doc(user.uid);
                                                  //     final DocumentSnapshot
                                                  //         snapshot =
                                                  //         await document.get();
                                                  //     if (snapshot.exists) {
                                                  //       final Map<String,
                                                  //               dynamic>
                                                  //           dataMap =
                                                  //           snapshot.data()
                                                  //               as Map<String,
                                                  //                   dynamic>;
                                                  //     } else {
                                                  //       debugPrint(
                                                  //           'Not found documents');
                                                  //     }
                                                  //   } catch (e) {
                                                  //     debugPrint(
                                                  //         'Error with updates : $e');
                                                  //   }
                                                  // }

                                                  jobHistoryBox
                                                      .put(widget.listKey,
                                                          jobList)
                                                      .then((value) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          'Job History Element Deleted',
                                                        ),
                                                        backgroundColor:
                                                            redColor,
                                                        showCloseIcon: true,
                                                        closeIconColor:
                                                            whiteColor,
                                                      ),
                                                    );
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                                // Navigator.of(context).pop();

                                                setState(() {});
                                              },
                                              child: const Text('ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

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
      ),
    );
  }
}
