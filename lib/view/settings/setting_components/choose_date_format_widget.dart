import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseDateFormatWidget extends StatefulWidget {
  final ValueChanged<String> onDateFormatSelect;

  const ChooseDateFormatWidget({
    Key? key,
    required this.onDateFormatSelect,
  }) : super(key: key);

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
    if(preferenceManager.getDateFormat == ''){
      selectedDateFormat = dateFormatList[0];
    }else{
      selectedDateFormat = preferenceManager.getDateFormat;
    }

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
                  widget.onDateFormatSelect(selectedDateFormat);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
