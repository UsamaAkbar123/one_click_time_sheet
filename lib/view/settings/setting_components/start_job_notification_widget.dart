import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/services/notification_service/notification_service.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartJobNotificationWidget extends StatefulWidget {
  final ValueChanged<String> onStartJobNotificationSelected;

  const StartJobNotificationWidget({
    Key? key,
    required this.onStartJobNotificationSelected,
  }) : super(key: key);

  @override
  State<StartJobNotificationWidget> createState() =>
      _StartJobNotificationWidgetState();
}

class _StartJobNotificationWidgetState
    extends State<StartJobNotificationWidget> {
  final Box box = Hive.box('workPlan');
  List startJobNotificationList = [
    '5 min',
    '10 min',
    '30 min',
    '60 min',
  ];
  String selectedStartJobNotification = '';

  PreferenceManager preferenceManager = PreferenceManager();

  /// set start job notification limit
  updateStartNotificationLimit(String value) {
    switch (value) {
      case '30 min':
        preferenceManager.setStartJobNotificationLimit = 30;
        break;
      case '60 min':
        preferenceManager.setStartJobNotificationLimit = 60;
        break;
      case '10 min':
        preferenceManager.setStartJobNotificationLimit = 10;
        break;
      case '5 min':
        preferenceManager.setStartJobNotificationLimit = 5;
        break;
    }
  }

  @override
  void initState() {
    if (preferenceManager.getStartJobNotification == '') {
      selectedStartJobNotification = startJobNotificationList[0];
    } else {
      selectedStartJobNotification = preferenceManager.getStartJobNotification;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)?.settingScreenStartJobNotification ?? '',
          style: CustomTextStyle.kBodyText1.copyWith(fontSize: 16.sp),
        ),
        Container(
          width: 120.w,
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
              value: selectedStartJobNotification,
              items: [
                for (int i = 0; i < startJobNotificationList.length; i++)
                  DropdownMenuItem(
                    value: startJobNotificationList[i],
                    child: Text(
                      startJobNotificationList[i],
                      style: CustomTextStyle.kBodyText2.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
              ],
              onChanged: (val) {
                setState(() {
                  selectedStartJobNotification = val.toString();
                  preferenceManager.setStartJobNotification =
                      selectedStartJobNotification;

                  updateStartNotificationLimit(
                      preferenceManager.getStartJobNotification);

                  /// get all the work plan from hive database
                  List<dynamic> dynamicWorkPlanList = box.values.toList();

                  if (dynamicWorkPlanList.isNotEmpty) {
                   List<WorkPlanModel> workPlanList = dynamicWorkPlanList.cast<WorkPlanModel>();
                   for(WorkPlanModel workPlanModel in workPlanList){
                     NotificationService().updateStartJobNotifications(workPlanModel);
                   }
                  }

                  widget.onStartJobNotificationSelected(
                      selectedStartJobNotification);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
