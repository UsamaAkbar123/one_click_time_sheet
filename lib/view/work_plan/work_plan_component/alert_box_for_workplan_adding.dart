import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/services/notification_service/notification_service.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:uuid/uuid.dart';

class AddWorkPlanBox extends StatefulWidget {
  final bool? isEditMode;
  final bool? isEmptySpaceClick;
  final String? id;
  final String? workPlanName;
  final DateTime? startTime;
  final DateTime? endTime;

  const AddWorkPlanBox({
    Key? key,
    this.isEditMode,
    this.isEmptySpaceClick,
    this.id,
    this.workPlanName,
    this.startTime,
    this.endTime,
  }) : super(key: key);

  @override
  State<AddWorkPlanBox> createState() => _AddWorkPlanBoxState();
}

class _AddWorkPlanBoxState extends State<AddWorkPlanBox> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  String workPlanDateForFrontEnd = '';
  DateTime workPlanDateForBackend = DateTime.now();
  String startTimeForFrontEnd = '';
  DateTime startTimeForBackEnd = DateTime.now();
  String endTimeForFrontEnd = '';
  DateTime endTimeForBackEnd = DateTime.now();
  PreferenceManager preferenceManager = PreferenceManager();
  final Box box = Hive.box('workPlan');

  /// initial values of time picker if user are in edit or empty space click
  /// then the time will show according to user click
  TimeOfDay startInitialTime = TimeOfDay.now();
  TimeOfDay endInitialTime = TimeOfDay.now();

  setStartTimeForFrontAndBackend({
    TimeOfDay? pickedTime,
    DateTime? editDateTime,
  }) {
    setState(() {
      workPlanDateForBackend = DateTime(
        workPlanDateForBackend.year,
        workPlanDateForBackend.month,
        workPlanDateForBackend.day,
        pickedTime?.hour ?? editDateTime!.hour,
        pickedTime?.minute ?? editDateTime!.minute,
      );
    });

    startTimeForBackEnd = workPlanDateForBackend;
    startInitialTime = TimeOfDay.fromDateTime(startTimeForBackEnd);
    if (preferenceManager.getTimeFormat == '24h') {
      startTimeForFrontEnd = DateFormat.Hm().format(workPlanDateForBackend);
    } else {
      startTimeForFrontEnd = DateFormat.jm().format(workPlanDateForBackend);
    }
  }

  setEndTimeForFrontAndBackend({
    TimeOfDay? pickedTime,
    DateTime? editDateTime,
  }) {
    setState(() {
      workPlanDateForBackend = DateTime(
        workPlanDateForBackend.year,
        workPlanDateForBackend.month,
        workPlanDateForBackend.day,
        pickedTime?.hour ?? editDateTime!.hour,
        pickedTime?.minute ?? editDateTime!.minute,
      );
    });

    endTimeForBackEnd = workPlanDateForBackend;

    /// set select time for showTimePicker
    endInitialTime = TimeOfDay.fromDateTime(endTimeForBackEnd);
    if (preferenceManager.getTimeFormat == '24h') {
      endTimeForFrontEnd = DateFormat.Hm().format(workPlanDateForBackend);
    } else {
      endTimeForFrontEnd = DateFormat.jm().format(workPlanDateForBackend);
    }
  }

  @override
  void didChangeDependencies() {
    if (widget.isEmptySpaceClick == true) {
      if (preferenceManager.getTimeFormat == '24h') {
        startTimeForFrontEnd =
            DateFormat.Hm().format(widget.startTime ?? DateTime.now());
      } else {
        startTimeForFrontEnd =
            DateFormat.jm().format(widget.startTime ?? DateTime.now());
      }
      if (preferenceManager.getTimeFormat == '24h') {
        endTimeForFrontEnd =
            DateFormat.Hm().format(widget.endTime ?? DateTime.now());
      } else {
        endTimeForFrontEnd =
            DateFormat.jm().format(widget.endTime ?? DateTime.now());
      }
      workPlanDateForFrontEnd =
          DateFormat(preferenceManager.getDateFormat).format(
        widget.startTime ?? DateTime.now(),
      );
      nameController = TextEditingController(
          text: AppLocalizations.of(context)?.addWorkPlanDialogTitle ?? '');
      workPlanDateForBackend = widget.startTime ?? DateTime.now();
      startTimeForBackEnd = widget.startTime ?? DateTime.now();
      endTimeForBackEnd = widget.endTime ?? DateTime.now();

      /// set select time for showTimePicker
      startInitialTime = TimeOfDay.fromDateTime(startTimeForBackEnd);
      endInitialTime = TimeOfDay.fromDateTime(endTimeForBackEnd);
    } else if (widget.isEditMode == true) {
      nameController = TextEditingController(
          text: AppLocalizations.of(context)?.addWorkPlanDialogTitle ?? '');
      nameController.text = widget.workPlanName ?? '';
      if (preferenceManager.getTimeFormat == '24h') {
        startTimeForFrontEnd =
            DateFormat.Hm().format(widget.startTime ?? DateTime.now());
      } else {
        startTimeForFrontEnd =
            DateFormat.jm().format(widget.startTime ?? DateTime.now());
      }
      if (preferenceManager.getTimeFormat == '24h') {
        endTimeForFrontEnd =
            DateFormat.Hm().format(widget.endTime ?? DateTime.now());
      } else {
        endTimeForFrontEnd =
            DateFormat.jm().format(widget.endTime ?? DateTime.now());
      }
      workPlanDateForFrontEnd =
          DateFormat(preferenceManager.getDateFormat).format(
        widget.startTime ?? DateTime.now(),
      );
      workPlanDateForBackend = widget.startTime ?? DateTime.now();
      startTimeForBackEnd = widget.startTime ?? DateTime.now();
      endTimeForBackEnd = widget.endTime ?? DateTime.now();

      /// set select time for showTimePicker
      startInitialTime = TimeOfDay.fromDateTime(startTimeForBackEnd);
      endInitialTime = TimeOfDay.fromDateTime(endTimeForBackEnd);
    } else {
      workPlanDateForFrontEnd =
          AppLocalizations.of(context)?.addWorkPlanDialogWorkPlanSelectDate ??
              '';
      startTimeForFrontEnd = AppLocalizations.of(context)
              ?.addWorkPlanDialogWorkPlanSelectStartTime ??
          '';
      endTimeForFrontEnd = AppLocalizations.of(context)
              ?.addWorkPlanDialogWorkPlanSelectEndTime ??
          '';

      nameController = TextEditingController(
          text: AppLocalizations.of(context)?.addWorkPlanDialogTitle ?? '');
    }

    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   // if (widget.isEmptySpaceClick == true) {
  //   //   if (preferenceManager.getTimeFormat == '24h') {
  //   //     startTimeForFrontEnd =
  //   //         DateFormat.Hm().format(widget.startTime ?? DateTime.now());
  //   //   } else {
  //   //     startTimeForFrontEnd =
  //   //         DateFormat.jm().format(widget.startTime ?? DateTime.now());
  //   //   }
  //   //   if (preferenceManager.getTimeFormat == '24h') {
  //   //     endTimeForFrontEnd =
  //   //         DateFormat.Hm().format(widget.endTime ?? DateTime.now());
  //   //   } else {
  //   //     endTimeForFrontEnd =
  //   //         DateFormat.jm().format(widget.endTime ?? DateTime.now());
  //   //   }
  //   //   workPlanDateForFrontEnd =
  //   //       DateFormat(preferenceManager.getDateFormat).format(
  //   //     widget.startTime ?? DateTime.now(),
  //   //   );
  //   //   workPlanDateForBackend = widget.startTime ?? DateTime.now();
  //   //   startTimeForBackEnd = widget.startTime ?? DateTime.now();
  //   //   endTimeForBackEnd = widget.endTime ?? DateTime.now();

  //   //   /// set select time for showTimePicker
  //   //   startInitialTime = TimeOfDay.fromDateTime(startTimeForBackEnd);
  //   //   endInitialTime = TimeOfDay.fromDateTime(endTimeForBackEnd);
  //   // }
  //   if (widget.isEditMode == true) {
  //     // nameController.text = widget.workPlanName ?? '';
  //     // if (preferenceManager.getTimeFormat == '24h') {
  //     //   startTimeForFrontEnd =
  //     //       DateFormat.Hm().format(widget.startTime ?? DateTime.now());
  //     // } else {
  //     //   startTimeForFrontEnd =
  //     //       DateFormat.jm().format(widget.startTime ?? DateTime.now());
  //     // }
  //     // if (preferenceManager.getTimeFormat == '24h') {
  //     //   endTimeForFrontEnd =
  //     //       DateFormat.Hm().format(widget.endTime ?? DateTime.now());
  //     // } else {
  //     //   endTimeForFrontEnd =
  //     //       DateFormat.jm().format(widget.endTime ?? DateTime.now());
  //     // }
  //     // workPlanDateForFrontEnd =
  //     //     DateFormat(preferenceManager.getDateFormat).format(
  //     //   widget.startTime ?? DateTime.now(),
  //     // );
  //     // workPlanDateForBackend = widget.startTime ?? DateTime.now();
  //     // startTimeForBackEnd = widget.startTime ?? DateTime.now();
  //     // endTimeForBackEnd = widget.endTime ?? DateTime.now();

  //     // /// set select time for showTimePicker
  //     // startInitialTime = TimeOfDay.fromDateTime(startTimeForBackEnd);
  //     // endInitialTime = TimeOfDay.fromDateTime(endTimeForBackEnd);
  //   }
  //   super.initState();
  // }

  // TimeOfDay selectedTime = TimeOfDay.now();

  bool isWorkPlanExist(
    List<WorkPlanModel> existingWorkPlanList,
    WorkPlanModel workPlanModel,
    bool isEditMood,
  ) {
    /// filter work plan based on date
    List<WorkPlanModel> filterWorkPlanOnDate = [];

    for (WorkPlanModel meeting in existingWorkPlanList) {
      if (meeting.workPlanDate == workPlanModel.workPlanDate) {
        filterWorkPlanOnDate.add(meeting);
      }
    }

    // print('length: ${filterWorkPlanOnDate.length}');

    if (filterWorkPlanOnDate.isEmpty) {
      return false;
    }

    for (WorkPlanModel meeting in filterWorkPlanOnDate) {
      /// case 1 if start time hour and end time hour is equal to new meeting start time end time hour
      if (isEditMood == false) {
        if (workPlanModel.startWorkPlanTime.hour ==
                meeting.startWorkPlanTime.hour ||
            workPlanModel.endWorkPlanTime.hour ==
                meeting.endWorkPlanTime.hour) {
          // print('case 1');
          // isAlreadyWorkPlanExist = true;
          return true;
          // print(isAlreadyWorkPlanExist);
          // break;
        }
      }

      /// case 2/3 if new meeting start end time is between old meeting start end time
      /// case 3 if start time of new meeting is between old meeting start end time
      if (workPlanModel.startWorkPlanTime.isAfter(meeting.startWorkPlanTime) &&
          workPlanModel.startWorkPlanTime.isBefore(meeting.endWorkPlanTime)) {
        // print('case 2/3');
        // isAlreadyWorkPlanExist = true;
        // print(isAlreadyWorkPlanExist);
        // break;
        return true;
      }

      /// case 3 if start time of new meeting is between old meeting start end time
      if (workPlanModel.endWorkPlanTime.isAfter(meeting.startWorkPlanTime) &&
          workPlanModel.endWorkPlanTime.isBefore(meeting.endWorkPlanTime)) {
        // print('case 4');
        // isAlreadyWorkPlanExist = true;
        // print(isAlreadyWorkPlanExist);
        // break;
        return true;
      }

      /// case 5 if end time of new meeting is before and after old meeting start end time
      if (workPlanModel.startWorkPlanTime.isBefore(meeting.startWorkPlanTime) &&
          workPlanModel.endWorkPlanTime.isAfter(meeting.endWorkPlanTime)) {
        // print('case 5');
        // isAlreadyWorkPlanExist = true;
        // print(isAlreadyWorkPlanExist);
        // break;
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)?.workPlanScreenTitle ?? '',
            style: CustomTextStyle.kHeading2.copyWith(
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 5.h),
          Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              style: CustomTextStyle.kBodyText2,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 10.0.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: greenColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: greenColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: greenColor),
                  ),
                  label: Text(
                    AppLocalizations.of(context)
                            ?.addWorkPlanDialogWorkPlanName ??
                        '',
                    style: CustomTextStyle.kBodyText2,
                  )),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the work plan name';
                } else {
                  return null;
                }
              },
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () async {
              DateTime? dateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030, 12, 31),
              );
              if (dateTime != null) {
                workPlanDateForFrontEnd =
                    DateFormat(preferenceManager.getDateFormat).format(
                  dateTime,
                );
                workPlanDateForBackend = dateTime;
                setState(() {});
                if (widget.isEditMode == true ||
                    widget.isEmptySpaceClick == true) {
                  setEndTimeForFrontAndBackend(editDateTime: widget.endTime);

                  /// start time
                  setStartTimeForFrontAndBackend(
                    editDateTime: widget.startTime,
                  );
                }
              }
            },
            child: Container(
              height: 40.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: greenColor),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              alignment: Alignment.centerLeft,
              child: Text(
                workPlanDateForFrontEnd,
                style: CustomTextStyle.kBodyText2,
              ),
            ),
          ),
          SizedBox(height: 8.h),
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
              height: 40.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: greenColor)),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              alignment: Alignment.centerLeft,
              child: Text(
                startTimeForFrontEnd,
                style: CustomTextStyle.kBodyText2,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                initialTime: endInitialTime,
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
                setEndTimeForFrontAndBackend(pickedTime: pickedTime);
              } else {
                debugPrint("Time is not selected");
              }
            },
            child: Container(
              height: 40.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: greenColor)),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              alignment: Alignment.centerLeft,
              child: Text(
                endTimeForFrontEnd,
                style: CustomTextStyle.kBodyText2,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              if (workPlanDateForFrontEnd ==
                      AppLocalizations.of(context)
                          ?.addWorkPlanDialogWorkPlanSelectDate ||
                  startTimeForFrontEnd ==
                      AppLocalizations.of(context)
                          ?.addWorkPlanDialogWorkPlanSelectStartTime ||
                  endTimeForFrontEnd ==
                      AppLocalizations.of(context)
                          ?.addWorkPlanDialogWorkPlanSelectEndTime) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)
                            ?.addWorkPlanValidatorMessage ??
                        ''),
                    backgroundColor: redColor,
                  ),
                );
              } else {
                if (widget.isEditMode == true) {
                  if (endTimeForBackEnd.isBefore(startTimeForBackEnd)) {
                    endTimeForBackEnd = endTimeForBackEnd.add(
                      const Duration(hours: 24),
                    );
                  }
                  WorkPlanModel workPlanModel = WorkPlanModel(
                    id: widget.id ?? '',
                    workPlanName: nameController.text,
                    startWorkPlanTime: startTimeForBackEnd,
                    endWorkPlanTime: endTimeForBackEnd,
                    workPlanDate: DateTime(
                      startTimeForBackEnd.year,
                      startTimeForBackEnd.month,
                      startTimeForBackEnd.day,
                    ),
                  );

                  /// check that on added time, can work plan added or not
                  List<WorkPlanModel> existingWorkPlanList =
                      box.values.cast<WorkPlanModel>().toList();

                  /// variable for check work plan already on given start end time
                  bool isAlreadyWorkPlanExist = false;

                  if (existingWorkPlanList.isNotEmpty) {
                    isAlreadyWorkPlanExist = isWorkPlanExist(
                      existingWorkPlanList,
                      workPlanModel,
                      true,
                    );
                  }

                  // print(isAlreadyWorkPlanExist);

                  if (isAlreadyWorkPlanExist) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'WorkPlan Already added on this time slot',
                        ),
                        backgroundColor: redColor,
                      ),
                    );
                  } else {
                    if (box.containsKey(workPlanModel.id)) {
                      box.put(widget.id, workPlanModel).then((value) {
                        nameController.clear();
                        startTimeForFrontEnd = AppLocalizations.of(context)
                                ?.addWorkPlanDialogWorkPlanSelectEndTime ??
                            '';
                        endTimeForFrontEnd = AppLocalizations.of(context)
                                ?.addWorkPlanDialogWorkPlanSelectEndTime ??
                            '';
                        workPlanDateForFrontEnd = AppLocalizations.of(context)
                                ?.addWorkPlanDialogWorkPlanSelectDate ??
                            '';
                        Navigator.of(context).pop();
                      });
                    }
                  }
                } else if (widget.isEmptySpaceClick == true) {
                  if (endTimeForBackEnd.isBefore(startTimeForBackEnd)) {
                    endTimeForBackEnd = endTimeForBackEnd.add(
                      const Duration(hours: 24),
                    );
                  }
                  const uuid = Uuid();
                  String id = uuid.v4();
                  WorkPlanModel workPlanModel = WorkPlanModel(
                    id: id,
                    workPlanName: nameController.text,
                    startWorkPlanTime: startTimeForBackEnd,
                    endWorkPlanTime: endTimeForBackEnd,
                    workPlanDate: DateTime(
                      startTimeForBackEnd.year,
                      startTimeForBackEnd.month,
                      startTimeForBackEnd.day,
                    ),
                  );

                  // NotificationService().scheduleStartJobNotification(
                  //   notificationId: 1,
                  //   startJobTime: startTimeForBackEnd,
                  //   beforeNotificationSetter: 1
                  //     , body: nameController.text,
                  // );

                  /// check that on added time, can work plan added or not
                  List<WorkPlanModel> existingWorkPlanList =
                      box.values.cast<WorkPlanModel>().toList();

                  /// variable for check work plan already on given start end time
                  bool isAlreadyWorkPlanExist = false;

                  if (existingWorkPlanList.isNotEmpty) {
                    isAlreadyWorkPlanExist = isWorkPlanExist(
                      existingWorkPlanList,
                      workPlanModel,
                      false,
                    );
                  }

                  if (isAlreadyWorkPlanExist) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'WorkPlan Already added on this time slot',
                        ),
                        backgroundColor: redColor,
                      ),
                    );
                  } else {
                    await box.put(id, workPlanModel).then((value) {
                      NotificationService().scheduleNotification(
                        title: 'Remainder',
                        body: nameController.text,
                        scheduledNotificationDateTime:
                            startTimeForBackEnd.subtract(
                          const Duration(minutes: 1),
                        ),
                      );
                      nameController.clear();
                      startTimeForFrontEnd = 'select start time';
                      endTimeForFrontEnd = 'select end time';
                      workPlanDateForFrontEnd = 'select date';
                      Navigator.of(context).pop();
                    });
                  }
                } else {
                  if (endTimeForBackEnd.isBefore(startTimeForBackEnd)) {
                    endTimeForBackEnd = endTimeForBackEnd.add(
                      const Duration(hours: 24),
                    );
                  }
                  const uuid = Uuid();
                  String id = uuid.v4();
                  WorkPlanModel workPlanModel = WorkPlanModel(
                    id: id,
                    workPlanName: nameController.text,
                    startWorkPlanTime: startTimeForBackEnd,
                    endWorkPlanTime: endTimeForBackEnd,
                    workPlanDate: DateTime(
                      startTimeForBackEnd.year,
                      startTimeForBackEnd.month,
                      startTimeForBackEnd.day,
                    ),
                  );

                  /// check that on added time, can work plan added or not
                  List<WorkPlanModel> existingWorkPlanList =
                      box.values.cast<WorkPlanModel>().toList();

                  /// variable for check work plan already on given start end time
                  bool isAlreadyWorkPlanExist = false;

                  if (existingWorkPlanList.isNotEmpty) {
                    isAlreadyWorkPlanExist = isWorkPlanExist(
                      existingWorkPlanList,
                      workPlanModel,
                      false,
                    );
                  }

                  if (isAlreadyWorkPlanExist) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'WorkPlan Already added on this time slot',
                        ),
                        backgroundColor: redColor,
                      ),
                    );
                  } else {
                    await box.put(id, workPlanModel).then((value) {
                      nameController.clear();
                      startTimeForFrontEnd = 'select start time';
                      endTimeForFrontEnd = 'select end time';
                      workPlanDateForFrontEnd = 'select date';
                      Navigator.of(context).pop();
                    });
                  }
                }
              }
            }
          },
          child: Text(
              AppLocalizations.of(context)?.workPlanScreenSaveButton ?? ''),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
              AppLocalizations.of(context)?.workPlanScreenCancelButton ?? ''),
        ),
      ],
    );
  }
}
