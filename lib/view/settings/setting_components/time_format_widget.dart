import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeFormatWidget extends StatefulWidget {
  final ValueChanged<String> onTimeFormatSelected;

  const TimeFormatWidget({
    Key? key,
    required this.onTimeFormatSelected,
  }) : super(key: key);

  @override
  State<TimeFormatWidget> createState() => _TimeFormatWidgetState();
}

class _TimeFormatWidgetState extends State<TimeFormatWidget> {
  late bool isTwelveHourFormatSelected;

  PreferenceManager preferenceManager = PreferenceManager();

  @override
  void initState() {
    if (preferenceManager.getTimeFormat == '' ||
        preferenceManager.getTimeFormat == '12h') {
      isTwelveHourFormatSelected = true;
    } else {
      isTwelveHourFormatSelected = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)?.settingScreenTimeFormat ?? '',
          style: CustomTextStyle.kBodyText1.copyWith(fontSize: 16.sp),
        ),
        const Spacer(),
        Expanded(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isTwelveHourFormatSelected = true;
                    widget.onTimeFormatSelected('12h');
                    preferenceManager.setTimeFormat = '12h';
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 18.w,
                      height: 18.h,
                      padding: EdgeInsets.all(2.w),
                      margin: EdgeInsets.only(left: 10.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: blackColor,
                          width: .5.w,
                        ),
                      ),
                      child: Container(
                        // padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTwelveHourFormatSelected
                              ? greenColor
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '12h',
                      style: CustomTextStyle.kBodyText2,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isTwelveHourFormatSelected = false;
                    widget.onTimeFormatSelected('24h');
                    preferenceManager.setTimeFormat = '24h';
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 18.w,
                      height: 18.h,
                      padding: EdgeInsets.all(2.w),
                      margin: EdgeInsets.only(right: 10.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: blackColor,
                          width: .5.w,
                        ),
                      ),
                      child: Container(
                        // padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: !isTwelveHourFormatSelected
                              ? greenColor
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    Text(
                      '24h',
                      style: CustomTextStyle.kBodyText2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
