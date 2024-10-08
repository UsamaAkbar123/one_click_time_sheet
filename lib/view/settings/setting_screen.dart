import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/provider/bottom_nav_provider.dart';
import 'package:one_click_time_sheet/services/firebase_service/data_backup.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/component/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_click_time_sheet/view/settings/setting_components/alert_to_email.dart';
import 'package:one_click_time_sheet/view/settings/setting_components/choose_date_format_widget.dart';
import 'package:one_click_time_sheet/view/settings/setting_components/choose_first_day_of_week_widget.dart';
import 'package:one_click_time_sheet/view/settings/setting_components/choose_language_widget.dart';
import 'package:one_click_time_sheet/view/settings/setting_components/end_job_notification_widget.dart';
import 'package:one_click_time_sheet/view/settings/setting_components/start_job_notification_widget.dart';
import 'package:one_click_time_sheet/view/settings/setting_components/time_format_widget.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  PreferenceManager preferenceManager = PreferenceManager();
  String? dateFormat;
  String? timeFormat;
  String? language;
  String? firstDayOfWeek;
  String? startJobNotification;
  String? endJobNotification;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Box jobHistoryBox = Hive.box('jobHistoryBox');


  @override
  void initState() {
    PreferenceManager().setIsFirstLaunch = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.settingScreenTitle ?? '',
          style: CustomTextStyle.kHeading2,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: ListView(
          children: [
            SizedBox(height: 10.h),
            ChooseLanguageWidget(
              onLanguageSelect: (value) {
                language = value;
              },
            ),
            SizedBox(height: 20.h),
            ChooseFirstDayOfWeekWidget(
              onFirstDaySelect: (value) {
                firstDayOfWeek = value;
              },
            ),
            SizedBox(height: 20.h),
            ChooseDateFormatWidget(
              onDateFormatSelect: (value) {
                dateFormat = value;
              },
            ),
            SizedBox(height: 20.h),
            TimeFormatWidget(
              onTimeFormatSelected: (value) {
                timeFormat = value;
              },
            ),
            SizedBox(height: 20.h),
            StartJobNotificationWidget(
              onStartJobNotificationSelected: (value) {
                startJobNotification = value;
              },
            ),
            SizedBox(height: 20.h),
            EndJobNotificationWidget(
              onEndJobNotificationSelected: (value) {
                endJobNotification = value;
              },
            ),
            SizedBox(height: 10.h),
            Text(
              'custom text for testing',
              style: CustomTextStyle.kBodyText1.copyWith(
                color: blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            CustomButton(
              buttonHeight: 45.h,
              buttonWidth: double.infinity,
              buttonColor: greenColor,
              onButtonTab: () {
                context.read<BottomNavigationProvider>().setCurrentTab = 0;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Changes Safe'),
                    backgroundColor: greenColor,
                    showCloseIcon: true,
                    closeIconColor: whiteColor,
                  ),
                );

                // if (dateFormat != null) {
                //   if (preferenceManager.getDateFormat != '') {
                //     preferenceManager.setDateFormat =
                //         dateFormat ?? preferenceManager.getDateFormat;
                //   } else {
                //     preferenceManager.setDateFormat = dateFormat ?? '';
                //   }
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: const Text('Changes Safe'),
                //       backgroundColor: greenColor,
                //     ),
                //   );
                // } else if (timeFormat != null) {
                //   if (preferenceManager.getTimeFormat != '') {
                //     preferenceManager.setTimeFormat =
                //         timeFormat ?? preferenceManager.getTimeFormat;
                //   } else {
                //     preferenceManager.setTimeFormat = timeFormat ?? '';
                //   }
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: const Text('Changes Safe'),
                //       backgroundColor: greenColor,
                //     ),
                //   );
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: const Text('Nothing is selected'),
                //       backgroundColor: redColor,
                //     ),
                //   );
                // }
              },
              buttonText: AppLocalizations.of(context)
                      ?.settingScreenSaveChangesButtonText ??
                  '',
            ),
            SizedBox(height: 30.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonHeight: 45.h,
                    buttonWidth: double.infinity,
                    buttonColor: blueColor,
                    onButtonTab: () async{
                      User? user = FirebaseAuth.instance.currentUser;
                      if(user?.uid == null){
                        showDialog(context: context, builder: (context){
                          return   const AlertBoxForAskingEmail(isSignupFunction: false, isBackup: false, );
                        });
                      }
                      else{
                        await DataBackup().dataRestoreFromFirebase(context).then((value) {
                          DataBackup().restoreDataWorkPlan(context);
                        });
                      }
                    },
                    buttonText: AppLocalizations.of(context)
                            ?.settingScreenRestoreDatabaseButtonText ??
                        '',
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomButton(
                    buttonHeight: 45.h,
                    buttonWidth: double.infinity,
                    buttonColor: greenColor,
                    onButtonTab: () async{
                      User? user = FirebaseAuth.instance.currentUser;
                      if(user?.uid == null){
                        showDialog(context: context, builder: (context){
                          return  const AlertBoxForAskingEmail(isSignupFunction: true,isBackup: true, );
                        });
                      }
                      else{
                        await DataBackup().backupDataWorkPlan(context).then((value) {
                           DataBackup().backupDataToFirebase(context);
                        });
                      }
                    },
                    buttonText: AppLocalizations.of(context)
                            ?.settingScreenBackupDatabaseButtonText ??
                        '',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          // IconButton(onPressed: (){
          //   FirebaseAuth.instance.signOut();
          // }, icon: Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }
}
