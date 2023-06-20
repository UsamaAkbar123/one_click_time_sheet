import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseFirstDayOfWeekWidget extends StatefulWidget {
  final ValueChanged<String> onFirstDaySelect;

  const ChooseFirstDayOfWeekWidget({
    Key? key,
    required this.onFirstDaySelect,
  }) : super(key: key);

  @override
  State<ChooseFirstDayOfWeekWidget> createState() =>
      _ChooseFirstDayOfWeekWidgetState();
}

class _ChooseFirstDayOfWeekWidgetState
    extends State<ChooseFirstDayOfWeekWidget> {
  PreferenceManager preferenceManager = PreferenceManager();

  List weekDaysList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String selectedFirstWeekDay = '';

  @override
  void initState() {
    if (preferenceManager.getFirstDayOfWeek == '') {
      selectedFirstWeekDay = weekDaysList[0];
    } else {
      selectedFirstWeekDay = preferenceManager.getFirstDayOfWeek;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)?.settingScreenFirstDayOfWeek ?? '',
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
              value: selectedFirstWeekDay,
              items: [
                for (int i = 0; i < weekDaysList.length; i++)
                  DropdownMenuItem(
                    value: weekDaysList[i],
                    child: Text(
                      weekDaysList[i],
                      style: CustomTextStyle.kBodyText2.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
              ],
              onChanged: (val) {
                setState(() {
                  selectedFirstWeekDay = val.toString();
                  preferenceManager.setFirstDayOfWeek = selectedFirstWeekDay;
                  widget.onFirstDaySelect(selectedFirstWeekDay);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
