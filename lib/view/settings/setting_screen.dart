import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/component/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    PreferenceManager().setIsFirstLaunch = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: CustomTextStyle.kHeading2,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: ListView(
          children: [
            SizedBox(height: 10.h),
            const ChooseLanguageWidget(),
            SizedBox(height: 20.h),
            const ChooseFirstDayOfWeekWidget(),
            SizedBox(height: 20.h),
            const ChooseDateFormatWidget(),
            SizedBox(height: 20.h),
            const TimeFormatWidget(),
            SizedBox(height: 20.h),
            const StartJobNotificationWidget(),
            SizedBox(height: 20.h),
            const EndJobNotificationWidget(),
            SizedBox(height: 30.h),
            CustomButton(
              buttonHeight: 45.h,
              buttonWidth: double.infinity,
              buttonColor: greenColor,
              onButtonTab: () {},
              buttonText: AppLocalizations.of(context)?.settingScreenSaveChangesButtonText ?? '',
            ),
            SizedBox(height: 30.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonHeight: 45.h,
                    buttonWidth: double.infinity,
                    buttonColor: blueColor,
                    onButtonTab: () {},
                    buttonText: AppLocalizations.of(context)?.settingScreenRestoreDatabaseButtonText ?? '',
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomButton(
                    buttonHeight: 45.h,
                    buttonWidth: double.infinity,
                    buttonColor: greenColor,
                    onButtonTab: () {},
                    buttonText: AppLocalizations.of(context)?.settingScreenBackupDatabaseButtonText ?? '',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class EndJobNotificationWidget extends StatefulWidget {
  const EndJobNotificationWidget({Key? key}) : super(key: key);

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

  @override
  void initState() {
    selectedEndJobNotification = endJobNotificationList[0];
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
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class StartJobNotificationWidget extends StatefulWidget {
  const StartJobNotificationWidget({Key? key}) : super(key: key);

  @override
  State<StartJobNotificationWidget> createState() =>
      _StartJobNotificationWidgetState();
}

class _StartJobNotificationWidgetState
    extends State<StartJobNotificationWidget> {
  List startJobNotificationList = [
    '30 min',
    '1 hr',
    '10 min',
    '2 hr',
  ];
  String selectedStartJobNotification = '';

  @override
  void initState() {
    selectedStartJobNotification = startJobNotificationList[0];
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
                      style: CustomTextStyle.kBodyText2,
                    ),
                  ),
              ],
              onChanged: (val) {
                setState(() {
                  selectedStartJobNotification = val.toString();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ChooseLanguageWidget extends StatefulWidget {
  const ChooseLanguageWidget({Key? key}) : super(key: key);

  @override
  State<ChooseLanguageWidget> createState() => _ChooseLanguageWidgetState();
}

class _ChooseLanguageWidgetState extends State<ChooseLanguageWidget> {
  List languagesList = ['English', 'Egyption'];
  String selectedLanguage = '';

  @override
  void initState() {
    selectedLanguage = languagesList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
        AppLocalizations.of(context)?.settingScreenSelectLanguage ?? '',
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
                'Select',
                style: CustomTextStyle.kBodyText2,
              ),
              value: selectedLanguage,
              items: [
                for (int i = 0; i < languagesList.length; i++)
                  DropdownMenuItem(
                    value: languagesList[i],
                    child: Text(
                      languagesList[i],
                      style: CustomTextStyle.kBodyText2,
                    ),
                  ),
              ],
              onChanged: (val) {
                setState(() {
                  selectedLanguage = val.toString();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ChooseFirstDayOfWeekWidget extends StatefulWidget {
  const ChooseFirstDayOfWeekWidget({Key? key}) : super(key: key);

  @override
  State<ChooseFirstDayOfWeekWidget> createState() =>
      _ChooseFirstDayOfWeekWidgetState();
}

class _ChooseFirstDayOfWeekWidgetState
    extends State<ChooseFirstDayOfWeekWidget> {
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
    selectedFirstWeekDay = weekDaysList[0];
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
                      style: CustomTextStyle.kBodyText2,
                    ),
                  ),
              ],
              onChanged: (val) {
                setState(() {
                  selectedFirstWeekDay = val.toString();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ChooseDateFormatWidget extends StatefulWidget {
  const ChooseDateFormatWidget({Key? key}) : super(key: key);

  @override
  State<ChooseDateFormatWidget> createState() => _ChooseDateFormatWidgetState();
}

class _ChooseDateFormatWidgetState extends State<ChooseDateFormatWidget> {
  List dateFormatList = [
    'yyyy-MM-dd',
    'dd-MM-yyyy',
    'yyyy-dd-MM',
    'dd/MM/yyyy',
    'yyyy/dd/MM',
  ];
  String selectedDateFormat = '';

  PreferenceManager preferenceManager = PreferenceManager();

  @override
  void initState() {
    selectedDateFormat = dateFormatList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)?.settingScreenDateFormat ?? '',
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
              value: selectedDateFormat,
              items: [
                for (int i = 0; i < dateFormatList.length; i++)
                  DropdownMenuItem(
                    value: dateFormatList[i],
                    child: Text(
                      dateFormatList[i],
                      style: CustomTextStyle.kBodyText2,
                    ),
                  ),
              ],
              onChanged: (val) {
                setState(() {
                  selectedDateFormat = val.toString();
                  preferenceManager.setDateFormat = selectedDateFormat;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class TimeFormatWidget extends StatefulWidget {
  const TimeFormatWidget({Key? key}) : super(key: key);

  @override
  State<TimeFormatWidget> createState() => _TimeFormatWidgetState();
}

class _TimeFormatWidgetState extends State<TimeFormatWidget> {
  late bool isTwelveHourFormatSelected;

  PreferenceManager preferenceManager = PreferenceManager();

  @override
  void initState() {
    if(preferenceManager.getTimeFormat == '' || preferenceManager.getTimeFormat == '12h'){
      isTwelveHourFormatSelected = true;
    }else{
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
