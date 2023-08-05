import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/provider/localization_provider.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ChooseLanguageWidget extends StatefulWidget {
  final ValueChanged<String> onLanguageSelect;

  const ChooseLanguageWidget({
    Key? key,
    required this.onLanguageSelect,
  }) : super(key: key);

  @override
  State<ChooseLanguageWidget> createState() => _ChooseLanguageWidgetState();
}

class _ChooseLanguageWidgetState extends State<ChooseLanguageWidget> {
  List languagesList = ['English', 'Spanish'];
  String selectedLanguage = '';
  PreferenceManager preferenceManager = PreferenceManager();

  void changeLocal({
    required BuildContext context,
    required String language,
  }) {
    switch (language) {
      case 'English':
        context.read<LocalizationProvider>().setLocal = 'en';
        break;
      case 'Spanish':
        context.read<LocalizationProvider>().setLocal = 'es';
        break;
    }
  }

  @override
  void initState() {
    if (preferenceManager.getLanguage == '') {
      selectedLanguage = languagesList[0];
    } else {
      selectedLanguage = preferenceManager.getLanguage;
    }

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
                      style: CustomTextStyle.kBodyText2.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
              ],
              onChanged: (val) {
                setState(() {
                  selectedLanguage = val.toString();
                  preferenceManager.setLanguage = selectedLanguage;
                  widget.onLanguageSelect(selectedLanguage);
                  changeLocal(context: context, language: selectedLanguage);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
