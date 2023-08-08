import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/provider/bottom_nav_provider.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/component/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_click_time_sheet/view/component/loading_widget.dart';
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
            SizedBox(height: 30.h),
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
                      final DocumentReference document = FirebaseFirestore.instance.collection('backup').doc('T3Y3DuESiPyA6ZTxET61');
                      final DocumentSnapshot snapshot = await document.get();
                      final Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;

                      // Clear the current Hive box if you want to completely replace it with the restored data
                      await jobHistoryBox.clear();

                      dataMap.forEach((key, value) {
                        // Convert each value (which should be a List<Map<String, dynamic>>) into a List<JobHistoryModel>
                        List<Map<String, dynamic>> listMap = List<Map<String, dynamic>>.from(value);
                        List<JobHistoryModel> jobList = listMap.map((item) => JobHistoryModel.firebaseJson(item)).toList();

                        // Put the converted data back into the Hive box with the corresponding key
                        jobHistoryBox.put(key, jobList);
                      });
                      if(mounted){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:  const Text("data has been restored successfully"),
                            backgroundColor: greenColor,
                            showCloseIcon: true,
                            closeIconColor: whiteColor,
                          ),
                        );
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
                      if(jobHistoryBox.isNotEmpty){
                        loadingDialogue(context: context);
                        final CollectionReference collection = FirebaseFirestore.instance.collection('backup');
                        final DocumentReference document = collection.doc('T3Y3DuESiPyA6ZTxET61');
                        final DocumentSnapshot snapshot = await document.get();
                        //Map<String, dynamic> allData = {};
                        // for (int i = 0; i < jobHistoryBox.length; i++) {
                        //   String dataKey = jobHistoryBox.keyAt(i);
                        //   List<JobHistoryModel> jobList = jobHistoryBox.getAt(i).cast<JobHistoryModel>();
                        //   List<Map<String, dynamic>> extractedDataList = [];
                        //   for (int j = 0; j < jobList.length; j++) {
                        //     Map<String, dynamic> extractedData = jobList[j].toJson();
                        //     extractedDataList.add(extractedData);
                        //   }
                        //   allData[dataKey] = extractedDataList;
                        // }
                        // await document.set(allData);


                        //
                        //   // Convert the existing data in Firebase into a convenient format
                        Map<String, List<JobHistoryModel>> existingData = {};
                        if (snapshot.exists) {
                          Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;
                          dataMap.forEach((key, value) {
                            List<Map<String, dynamic>> listMap = List<Map<String, dynamic>>.from(value);
                            existingData[key] = listMap.map((item) => JobHistoryModel.firebaseJson(item)).toList();
                            print(existingData);
                          });
                        }

                        // Compare the Hive data with the existing data in Firebase
                        for (int i = 0; i < jobHistoryBox.length; i++) {
                          String dataKey = jobHistoryBox.keyAt(i);
                          List<JobHistoryModel> jobList = jobHistoryBox.getAt(i).cast<JobHistoryModel>();

                          // Get the existing list for this key, or an empty list if none exists
                          List<JobHistoryModel> existingList = existingData[dataKey] ?? [];

                          // Add only the new entries to the existing list
                          for (var job in jobList) {
                            if (!existingList.any((existingJob) => existingJob.uuid == job.uuid)) {
                              existingList.add(job);
                            }
                          }

                          // Update the existing data with the new combined list
                          existingData[dataKey] = existingList;
                        }

                        // Convert the existing data into the format for Firestore
                        Map<String, dynamic> allData = {};
                        existingData.forEach((key, value) {
                          allData[key] = value.map((item) => item.toJson()).toList();
                        });

                        // Update the document in Firestore with the combined data
                        //  await document.delete();
                        await document.set(allData).then((value)  {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:  const Text("data is successfully stored"),
                              backgroundColor: greenColor,
                              showCloseIcon: true,
                              closeIconColor: whiteColor,
                            ),
                          );
                        }).catchError((e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:  Text(e.toString()),
                              backgroundColor: redColor,
                              showCloseIcon: true,
                              closeIconColor: whiteColor,
                            ),
                          );
                        });
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('No data is available for backup'),
                            backgroundColor: redColor,
                            showCloseIcon: true,
                            closeIconColor: whiteColor,
                          ),
                        );
                      }

                    },
                    buttonText: AppLocalizations.of(context)
                            ?.settingScreenBackupDatabaseButtonText ??
                        '',
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
