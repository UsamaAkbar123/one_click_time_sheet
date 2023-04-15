import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
        child: Column(
          children: [
            SizedBox(height: 10.h),
            const ChooseLanguageWidget(),
            SizedBox(height: 20.h),
            const ChooseFirstDayOfWeekWidget(),
          ],
        ),
      ),
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
          'Language',
          style: CustomTextStyle.kBodyText1.copyWith(fontSize: 16.sp),
        ),
        Container(
          width: 90.w,
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
  List weekDaysList = ['Monday', 'Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
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
          'First Day of Week',
          style: CustomTextStyle.kBodyText1.copyWith(fontSize: 16.sp),
        ),
        Container(
          width: 90.w,
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
