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
  const AddWorkPlanBox({Key? key}) : super(key: key);

  @override
  State<AddWorkPlanBox> createState() => _AddWorkPlanBoxState();
}

class _AddWorkPlanBoxState extends State<AddWorkPlanBox> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String workPlanDateForFrontEnd = 'select date';
  DateTime workPlanDateForBackend = DateTime.now();
  String startTimeForFrontEnd = 'select start time';
  DateTime startTimeForBackEnd = DateTime.now();
  String endTimeForFrontEnd = 'select end time';
  DateTime endTimeForBackEnd = DateTime.now();
  PreferenceManager preferenceManager = PreferenceManager();
  final Box box = Hive.box('workPlan');
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
            'Work Plan Information',
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
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 5.0.h, horizontal: 10.0.w),
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
                    DateFormat('MM/dd/yyyy').format(
                      dateTime,
                    );
                workPlanDateForBackend = dateTime;
                setState(() {});
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
                context: context, //context of current state
              );
              if (pickedTime != null) {
                setState(() {
                  workPlanDateForBackend = DateTime(
                    workPlanDateForBackend.year,
                    workPlanDateForBackend.month,
                    workPlanDateForBackend.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                });

                startTimeForBackEnd = workPlanDateForBackend;

                if (preferenceManager.getTimeFormat == '24h') {
                  startTimeForFrontEnd = DateFormat.Hm()
                      .addPattern('a')
                      .format(workPlanDateForBackend);
                } else {
                  startTimeForFrontEnd = DateFormat.jm()
                      .format(workPlanDateForBackend);
                }
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
                context: context, //context of current state
              );
              if (pickedTime != null) {
                setState(() {
                  workPlanDateForBackend = DateTime(
                    workPlanDateForBackend.year,
                    workPlanDateForBackend.month,
                    workPlanDateForBackend.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                });

                endTimeForBackEnd = workPlanDateForBackend;
                if (preferenceManager.getTimeFormat == '24h') {
                  endTimeForFrontEnd = DateFormat.Hm()
                      .addPattern('a')
                      .format(workPlanDateForBackend);
                } else {
                  endTimeForFrontEnd = DateFormat.jm()
                      .format(workPlanDateForBackend);
                }
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
                    content: const Text(
                        'Select Date or Start Time or End Time'),
                    backgroundColor: redColor,
                  ),
                );
              } else {
                const uuid = Uuid();
                String id = uuid.v4();
                WorkPlanModel workPlanModel = WorkPlanModel(
                  id: id,
                  workPlanName: nameController.text,
                  startWorkPlanTime: startTimeForBackEnd,
                  endWorkPlanTime: endTimeForBackEnd,
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
