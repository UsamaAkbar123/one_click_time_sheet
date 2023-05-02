import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/generated/assets/icons.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/model/job_history_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/custom_work_plan_time.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/paid_unpaid_break_box.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/start_end_job_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //late JobHistoryModel jobHistoryModel;
  DateTime nowDateTime = DateTime.now();
  final Box box = Hive.box('jobHistoryBox');

  List<JobHistoryModel> jobHistoryData = [];


  Timer? _timer;
  int _seconds = 0;
  DateTime startJobTime = DateTime.now();
  DateTime endJob = DateTime.now();
  DateTime paidBreak = DateTime.now();
  DateTime unPaidBreak = DateTime.now();
  bool _isRunning = false;

  bool isStartJobSelectCustomTime = false;
  bool isEndJobSelectCustomTime = false;
  bool isPaidBreakSelectCustomTime = false;
  bool isUnpaidBreakSelectCustomTime = false;

  List<HistoryElement> jobHistory = [];


  _startJobTime(){
    if (_isRunning) {
      // Stop the timer
      _timer?.cancel();
      _isRunning = false;
      setState(() {

      });
    } else {
      // Start the timer
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
      _isRunning = true;
    }
  }

  int currentIndex = -1;

  Color getTextColor (String type){
    switch(type){
      case "Start job":
        return lightGreenColor;
      case "End job":
        return redColor;
      case "Paid break":
        return greenColor;
      default:
        return orangeColor;
    }
  }

  @override
  void initState() {
    // jobHistoryModel.id =  DateFormat('EEEE, d, M, y').format(DateTime.now());
    // jobHistoryModel.historyElement = [];
    if(box.isNotEmpty){
      List? dynamicList = box.get(DateFormat('EEEE, d, M, y').format(DateTime.now()));
      if(dynamicList != null){
        jobHistoryData = dynamicList.cast<JobHistoryModel>();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.homeScreenTitle ?? '',
          style: CustomTextStyle.kHeading2,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: ListView(
          children: [
            SizedBox(height: 10.h),
            /// future work plan widget
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: blackColor),
              ),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)?.homeScreenPlan ?? '',
                    style: CustomTextStyle.kHeading2,
                  ),
                  SizedBox(width: 10.w),
                  const CustomWorkPlanTime(
                    startTime: '8:00',
                    endTime: '11:30',
                  ),
                  Text(
                    ',',
                    style: CustomTextStyle.kHeading2,
                  ),
                  SizedBox(width: 5.w),
                  const CustomWorkPlanTime(
                    startTime: '12:00',
                    endTime: '15:00',
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      color: greyColor,
                      size: 30.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            /// refresh time widget
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: blueColor,
                border: Border.all(
                  color: blackColor,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Spacer(),
                  Icon(
                    Icons.refresh,
                    color: blackColor,
                    size: 40.h,
                  ),
                  SizedBox(width: 2.w),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      AppLocalizations.of(context)?.homeScreenRefreshTime ?? '',
                      style: CustomTextStyle.kBodyText1.copyWith(
                        fontSize: 22.sp,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            StartEndJobBox(
              jobStatus: AppLocalizations.of(context)?.homeScreenStartJob ?? '',
              color: currentIndex == 0 ? greyColor:lightGreenColor,
              plusMinuteTap: (){
                setState(() {
                startJobTime = startJobTime.add(const Duration(minutes: 1));
                isStartJobSelectCustomTime = true;
                });
              },
              minusMinuteTap: (){
                setState(() {
                  startJobTime = startJobTime.subtract(const Duration(minutes: 1));
                  isStartJobSelectCustomTime = true;
                });
              },
              manualTimeTap: () async{
                TimeOfDay? pickedTime =  await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context, //context of current state
                );

                if(pickedTime != null ){
                  setState(() {
                    isStartJobSelectCustomTime = true;
                    startJobTime = DateTime(
                      startJobTime.year,
                      startJobTime.month,
                      startJobTime.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  });
                }else{
                  print("Time is not selected");
                }
              },
              onTab: currentIndex == 0 ? null :  () async{
                currentIndex = 0;
                setState(() {
                  if(isStartJobSelectCustomTime){
                    startJobTime = startJobTime;
                  }
                  else{
                    startJobTime = DateTime.now();
                  }
                });
                HistoryElement historyElement = HistoryElement(
                  time: startJobTime,
                  type: "Start job"
                );
                jobHistory.add(historyElement);
              },
              time: _seconds,
              startingDate: startJobTime,
            ),
            SizedBox(height: 8.h),
            StartEndJobBox(
              jobStatus: AppLocalizations.of(context)?.homeScreenEndJob ?? '',
              plusMinuteTap: (){
                setState(() {
                  endJob = endJob.add(const Duration(minutes: 1));
                  isEndJobSelectCustomTime = true;
                });
              },
              minusMinuteTap: (){
                setState(() {
                  endJob = endJob.subtract(const Duration(minutes: 1));
                  isEndJobSelectCustomTime = true;
                });
              },
              manualTimeTap: () async{
                TimeOfDay? pickedTime =  await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context, //context of current state
                );

                if(pickedTime != null ){
                  setState(() {
                    isEndJobSelectCustomTime = true;
                    endJob = DateTime(
                      endJob.year ,
                      endJob.month,
                      endJob.day ,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  });
                }else{
                  print("Time is not selected");
                }
              },
              startingDate: endJob,
              color: redColor,
              time: 0,
              onTab: currentIndex == -1 ? null : () async{
                currentIndex = -1;

                setState(() {
                  if(isEndJobSelectCustomTime){
                    endJob = endJob;
                  }
                  else{
                    endJob = DateTime.now();
                  }
                });
                HistoryElement historyElement = HistoryElement(
                    time: endJob,
                    type: "End job"
                );
                jobHistory.add(historyElement);

                String dateKey = DateFormat('EEEE, d, M, y').format(DateTime.now());

                await Hive.initFlutter();
                if (!Hive.isAdapterRegistered(1)) {
                  Hive.registerAdapter(JobHistoryModelAdapter());
                  Hive.registerAdapter(HistoryElementAdapter());
                }
                await Hive.openBox('jobHistoryBox');
                final Box box = Hive.box('jobHistoryBox');

                JobHistoryModel jobHistoryModel = JobHistoryModel(
                    id: DateFormat('EEEE, d, M, y').format(DateTime.now()),
                    historyElement: jobHistory
                );

                List<JobHistoryModel> jobHistoryList= [];
                if(box.isNotEmpty){
                  List? dynamicList = box.get(dateKey);
                  if(dynamicList != null){
                    List<JobHistoryModel> boxDataList = dynamicList.cast<JobHistoryModel>();
                    jobHistoryData = boxDataList;
                    boxDataList.add(jobHistoryModel);
                    jobHistoryList = boxDataList;
                  }
                  else{
                    jobHistoryList.add(jobHistoryModel);
                  }
                }

                box.put(dateKey,jobHistoryList).then((value) {
                  jobHistory = [];
                });

              },
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: PaidUnPaidBreakBox(
                    plusMinuteTap: (){
                      setState(() {
                        paidBreak = paidBreak.add(const Duration(minutes: 1));
                        isPaidBreakSelectCustomTime = true;
                      });
                    },
                    minusMinuteTap: (){
                      setState(() {
                        paidBreak = paidBreak.subtract(const Duration(minutes: 1));
                        isPaidBreakSelectCustomTime = true;
                      });
                    },
                    manualTimeTap: () async{
                      TimeOfDay? pickedTime =  await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context, //context of current state
                      );

                      if(pickedTime != null ){
                        setState(() {
                          isPaidBreakSelectCustomTime = true;
                          paidBreak = DateTime(
                            paidBreak.year,
                            paidBreak.month,
                            paidBreak.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }else{
                        print("Time is not selected");
                      }
                    },
                    startingDate: paidBreak,
                    onTab: currentIndex == 2 ? null : () {
                      currentIndex = 2;
                      setState(() {
                        if(isPaidBreakSelectCustomTime){
                          paidBreak = paidBreak;
                        }
                        else{
                          paidBreak = DateTime.now();
                        }
                      });
                      HistoryElement historyElement = HistoryElement(
                          time: paidBreak,
                          type: "Paid break"
                      );
                      jobHistory.add(historyElement);
                    },
                    breakStatus: AppLocalizations.of(context)?.homeScreenPaidBreak ?? '',
                    color: currentIndex == 2 ? greyColor: greenColor,
                    iconPath: AssetsIcon.paidBreakIcon,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: PaidUnPaidBreakBox(
                    startingDate: unPaidBreak,
                    plusMinuteTap: (){
                      setState(() {
                        unPaidBreak = unPaidBreak.add(const Duration(minutes: 1));
                        isUnpaidBreakSelectCustomTime = true;
                      });
                    },
                    minusMinuteTap: (){
                      setState(() {
                        unPaidBreak = unPaidBreak.subtract(const Duration(minutes: 1));
                        isUnpaidBreakSelectCustomTime = true;
                      });
                    },
                    manualTimeTap: () async{
                      TimeOfDay? pickedTime =  await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context, //context of current state
                      );

                      if(pickedTime != null ){
                        setState(() {
                          isUnpaidBreakSelectCustomTime = true;
                          unPaidBreak = DateTime(
                            unPaidBreak.year,
                            unPaidBreak.month,
                            unPaidBreak.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }else{
                        print("Time is not selected");
                      }
                    },
                    onTab: currentIndex == 3 ? null : () {
                      currentIndex = 3;
                      setState(() {
                        if(isUnpaidBreakSelectCustomTime){
                          unPaidBreak = unPaidBreak;
                        }
                        else{
                          unPaidBreak = DateTime.now();
                        }
                      });
                      HistoryElement historyElement = HistoryElement(
                          time: unPaidBreak,
                          type: "Unpaid break"
                      );
                      jobHistory.add(historyElement);
                    },
                    breakStatus: AppLocalizations.of(context)?.homeScreenUnPaidBreak ?? '',
                    color: currentIndex == 3 ? greyColor: orangeColor,
                    iconPath: AssetsIcon.coffeeIcon,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              AppLocalizations.of(context)?.homeScreenLastHistory ?? '',
              style: CustomTextStyle.kHeading2,
            ),
            SizedBox(height: 20.h),
            Text("TODAY - ${DateFormat('EEEE, d, M, y').format(DateTime.now())}",
              style: CustomTextStyle.kBodyText1.copyWith(
                color: blueColor,
                fontWeight: FontWeight.w600
              ),),
            SizedBox(height: 10.h),
            jobHistoryData.isNotEmpty ? ListView.builder(
              itemCount: jobHistoryData.last.historyElement?.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return Text("${DateFormat('d.M.y').format(jobHistoryData.last.historyElement?[index].time ?? DateTime.now())}-"
                      "${DateFormat('h:mm a').format(jobHistoryData.last.historyElement?[index].time ?? DateTime.now())}-${jobHistoryData.last.historyElement?[index].type}",
                    style: CustomTextStyle.kBodyText1.copyWith(
                        color: getTextColor(jobHistoryData.last.historyElement?[index].type ?? ''),
                        fontWeight: FontWeight.w400
                    ),
                  );
                }): const Center(child: Text("No history found"),),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
