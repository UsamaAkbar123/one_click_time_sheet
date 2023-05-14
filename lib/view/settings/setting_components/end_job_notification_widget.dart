import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EndJobNotificationWidget extends StatefulWidget {
  final ValueChanged<String> onEndJobNotificationSelected;

  const EndJobNotificationWidget({
    Key? key,
    required this.onEndJobNotificationSelected,
  }) : super(key: key);

  @override
  State<EndJobNotificationWidget> createState() =>
      _EndJobNotificationWidgetState();
}

class _EndJobNotificationWidgetState extends State<EndJobNotificationWidget> {
  List endJobNotificationList = [
    '30 min',
    '1 hr',
    '10 min',
    '2 hr',
  ];
  String selectedEndJobNotification = '';

  PreferenceManager preferenceManager = PreferenceManager();

  @override
  void initState() {
    if(preferenceManager.getEndJobNotification == ''){
      selectedEndJobNotification = endJobNotificationList[0];
    }else{
      selectedEndJobNotification = preferenceManager.getEndJobNotification;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)?.settingScreenEndJobNotification ?? '',
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
              value: selectedEndJobNotification,
              items: [
                for (int i = 0; i < endJobNotificationList.length; i++)
                  DropdownMenuItem(
                    value: endJobNotificationList[i],
                    child: Text(
                      endJobNotificationList[i],
                      style: CustomTextStyle.kBodyText2,
                    ),
                  ),
              ],
              onChanged: (val) {
                setState(() {
                  selectedEndJobNotification = val.toString();
                  preferenceManager.setEndJobNotification = selectedEndJobNotification;
                  widget.onEndJobNotificationSelected(selectedEndJobNotification);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
