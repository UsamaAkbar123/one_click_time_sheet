import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:uuid/uuid.dart';

class AddWorkPlanBox extends StatefulWidget {
  final bool? isEditMode;
  final String? id;
  final String? workPlanName;
  final DateTime? startTime;
  final DateTime? endTime;

  const AddWorkPlanBox({
    Key? key,
    this.isEditMode,
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
  final nameController = TextEditingController(text: 'work');
  String workPlanDateForFrontEnd = 'select date';
  DateTime workPlanDateForBackend = DateTime.now();
  String startTimeForFrontEnd = 'select start time';
  DateTime startTimeForBackEnd = DateTime.now();
  String endTimeForFrontEnd = 'select end time';
  DateTime endTimeForBackEnd = DateTime.now();
  PreferenceManager preferenceManager = PreferenceManager();
  final Box box = Hive.box('workPlan');

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
    if (preferenceManager.getTimeFormat == '24h') {
      endTimeForFrontEnd = DateFormat.Hm().format(workPlanDateForBackend);
    } else {
      endTimeForFrontEnd = DateFormat.jm().format(workPlanDateForBackend);
    }
  }

  @override
  void initState() {
    if (widget.isEditMode == true) {
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
    }
    super.initState();
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
            'Work',
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
                    'work plan name',
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
                if (widget.isEditMode == true) {
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
                initialTime: TimeOfDay.now(),
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
                initialTime: TimeOfDay.now(),
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
              if (workPlanDateForFrontEnd == 'select date' ||
                  startTimeForFrontEnd == 'select start time' ||
                  endTimeForFrontEnd == 'select end time') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        const Text('Select Date or Start Time or End Time'),
                    backgroundColor: redColor,
                  ),
                );
              } else {
                if (widget.isEditMode == true) {
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

                  if (box.containsKey(workPlanModel.id)) {
                    box.put(widget.id, workPlanModel).then((value) {
                      nameController.clear();
                      startTimeForFrontEnd = 'select start time';
                      endTimeForFrontEnd = 'select end time';
                      workPlanDateForFrontEnd = 'select date';
                      Navigator.of(context).pop();
                    });
                  }
                } else {
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
          },
          child: const Text("save"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("cancel"),
        ),
      ],
    );
  }
}
