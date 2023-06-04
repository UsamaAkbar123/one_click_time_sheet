import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/generated/assets/icons.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/provider/bottom_nav_provider.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/custom_work_plan_time.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/paid_unpaid_break_box.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/refresh_time_button_widget.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/start_end_job_box.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime nowDateTime = DateTime.now();
  final Box jobHistoryBox = Hive.box('jobHistoryBox');
  final Box workPlanBox = Hive.box('workPlan');
  List<JobHistoryModel> jobHistoryData = [];
  PreferenceManager preferenceManager = PreferenceManager();
  final int _seconds = 0;
  DateTime startJobTime = DateTime.now();
  DateTime endJob = DateTime.now();
  DateTime paidBreak = DateTime.now();
  DateTime unPaidBreak = DateTime.now();

  bool isStartJobSelectCustomTime = false;
  bool isEndJobSelectCustomTime = false;
  bool isPaidBreakSelectCustomTime = false;
  bool isUnpaidBreakSelectCustomTime = false;

  List<HistoryElement> jobHistory = [];

  int currentIndex = -1;

  Color getTextColor(String type) {
    switch (type) {
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
            workPlanBox.isEmpty
                ? const SizedBox()
                : ValueListenableBuilder(
                    valueListenable: workPlanBox.listenable(),
                    builder: (context, Box box, widget) {
                      List<WorkPlanModel> workPlanList = [];
                      if (workPlanBox.isNotEmpty) {
                        if (box.isNotEmpty) {
                          List<dynamic> dynamicWorkPlanList =
                              box.values.toList();

                          if (dynamicWorkPlanList.isNotEmpty) {
                            workPlanList =
                                dynamicWorkPlanList.cast<WorkPlanModel>();
                          }
                        }
                      }
                      return Container(
                        height: 50.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: blackColor),
                        ),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)?.homeScreenPlan ??
                                  '',
                              style: CustomTextStyle.kHeading2,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  String startTime;
                                  String endTime;
                                  if (preferenceManager.getTimeFormat ==
                                      '12h') {
                                    startTime = DateFormat('h:mm').format(
                                        workPlanList[index].startWorkPlanTime);
                                    endTime = DateFormat('h:mm').format(
                                        workPlanList[index].endWorkPlanTime);
                                  } else {
                                    startTime = DateFormat('H:mm').format(
                                        workPlanList[index].startWorkPlanTime);
                                    endTime = DateFormat('H:mm').format(
                                        workPlanList[index].endWorkPlanTime);
                                  }

                                  return Center(
                                    child: CustomWorkPlanTime(
                                      startTime: startTime,
                                      endTime: endTime,
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Center(
                                    child: Text(
                                      ',',
                                      style: CustomTextStyle.kHeading2,
                                    ),
                                  );
                                },
                                itemCount: workPlanList.length < 2
                                    ? workPlanList.length
                                    : 2,
                              ),
                            ),
                            //const Spacer(),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<BottomNavigationProvider>()
                                    .setCurrentTab = 2;
                              },
                              icon: Icon(
                                Icons.edit,
                                color: greyColor,
                                size: 30.h,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            SizedBox(height: 5.h),

            /// refresh time widget
            RefreshTimeWidget(
              onTab: () {
                setState(() {
                  startJobTime = DateTime.now();
                  endJob = DateTime.now();
                  paidBreak = DateTime.now();
                  unPaidBreak = DateTime.now();
                });
              },
            ),
            SizedBox(height: 12.h),
            StartEndJobBox(
              jobStatus: AppLocalizations.of(context)?.homeScreenStartJob ?? '',
              color: currentIndex == 0
                  ? greyColor.withOpacity(0.3)
                  : lightGreenColor,
              plusMinuteTap: currentIndex == 0
                  ? null
                  : () {
                      setState(() {
                        startJobTime =
                            startJobTime.add(const Duration(minutes: 1));
                        isStartJobSelectCustomTime = true;
                      });
                    },
              minusMinuteTap: currentIndex == 0
                  ? null
                  : () {
                      setState(() {
                        startJobTime =
                            startJobTime.subtract(const Duration(minutes: 1));
                        isStartJobSelectCustomTime = true;
                      });
                    },
              manualTimeTap: currentIndex == 0
                  ? null
                  : () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context, //context of current state
                      );

                      if (pickedTime != null) {
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
                      } else {
                        debugPrint("Time is not selected");
                      }
                    },
              onTab: currentIndex == 0
                  ? null
                  : () async {
                      currentIndex = 0;
                      setState(() {
                        if (isStartJobSelectCustomTime) {
                          startJobTime = startJobTime;
                        } else {
                          startJobTime = DateTime.now();
                        }
                      });
                      HistoryElement historyElement =
                          HistoryElement(time: startJobTime, type: "Start job");
                      jobHistory.add(historyElement);
                    },
              time: _seconds,
              startingDate: startJobTime,
            ),
            SizedBox(height: 8.h),
            StartEndJobBox(
              jobStatus: AppLocalizations.of(context)?.homeScreenEndJob ?? '',
              plusMinuteTap: currentIndex == 1
                  ? null
                  : () {
                      setState(() {
                        endJob = endJob.add(const Duration(minutes: 1));
                        isEndJobSelectCustomTime = true;
                      });
                    },
              minusMinuteTap: currentIndex == 1
                  ? null
                  : () {
                      setState(() {
                        endJob = endJob.subtract(const Duration(minutes: 1));
                        isEndJobSelectCustomTime = true;
                      });
                    },
              manualTimeTap: currentIndex == 1
                  ? null
                  : () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context, //context of current state
                      );

                      if (pickedTime != null) {
                        setState(() {
                          isEndJobSelectCustomTime = true;
                          endJob = DateTime(
                            endJob.year,
                            endJob.month,
                            endJob.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      } else {
                        debugPrint("Time is not selected");
                      }
                    },
              startingDate: endJob,
              color: currentIndex == 1 ? greyColor.withOpacity(0.3) : redColor,
              time: 0,
              onTab: currentIndex == 1
                  ? null
                  : () async {
                      currentIndex = 1;

                      setState(() {
                        if (isEndJobSelectCustomTime) {
                          endJob = endJob;
                        } else {
                          endJob = DateTime.now();
                        }
                      });
                      HistoryElement historyElement =
                          HistoryElement(time: endJob, type: "End job");
                      jobHistory.add(historyElement);

                      String dateKey =
                          DateFormat('EEEE, d, M, y').format(DateTime.now());
                      final Box box = Hive.box('jobHistoryBox');
                      JobHistoryModel jobHistoryModel = JobHistoryModel(
                        id: DateFormat('EEEE, d, M, y').format(DateTime.now()),
                        historyElement: jobHistory,
                        timestamp: DateTime.now(),
                      );

                      List<JobHistoryModel> jobHistoryList = [];
                      if (box.isNotEmpty) {
                        List? dynamicList = box.get(dateKey);
                        if (dynamicList != null) {
                          List<JobHistoryModel> boxDataList =
                              dynamicList.cast<JobHistoryModel>();
                          jobHistoryData = boxDataList;
                          boxDataList.add(jobHistoryModel);
                          jobHistoryList = boxDataList;
                        } else {
                          jobHistoryList.add(jobHistoryModel);
                        }
                      } else {
                        jobHistoryList.add(jobHistoryModel);
                      }

                      box.put(dateKey, jobHistoryList).then((value) {
                        jobHistory = [];
                      });
                    },
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: PaidUnPaidBreakBox(
                    plusMinuteTap: currentIndex == 2
                        ? null
                        : () {
                            setState(() {
                              paidBreak =
                                  paidBreak.add(const Duration(minutes: 1));
                              isPaidBreakSelectCustomTime = true;
                            });
                          },
                    minusMinuteTap: currentIndex == 2
                        ? null
                        : () {
                            setState(() {
                              paidBreak = paidBreak
                                  .subtract(const Duration(minutes: 1));
                              isPaidBreakSelectCustomTime = true;
                            });
                          },
                    manualTimeTap: currentIndex == 2
                        ? null
                        : () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context, //context of current state
                            );

                            if (pickedTime != null) {
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
                            } else {
                              debugPrint("Time is not selected");
                            }
                          },
                    startingDate: paidBreak,
                    onTab: currentIndex == 2
                        ? null
                        : () {
                            currentIndex = 2;
                            setState(() {
                              if (isPaidBreakSelectCustomTime) {
                                paidBreak = paidBreak;
                              } else {
                                paidBreak = DateTime.now();
                              }
                            });
                            HistoryElement historyElement = HistoryElement(
                                time: paidBreak, type: "Paid break");
                            jobHistory.add(historyElement);
                          },
                    breakStatus:
                        AppLocalizations.of(context)?.homeScreenPaidBreak ?? '',
                    color: currentIndex == 2
                        ? greyColor.withOpacity(0.3)
                        : greenColor,
                    iconPath: AssetsIcon.paidBreakIcon,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: PaidUnPaidBreakBox(
                    startingDate: unPaidBreak,
                    plusMinuteTap: currentIndex == 3
                        ? null
                        : () {
                            setState(() {
                              unPaidBreak =
                                  unPaidBreak.add(const Duration(minutes: 1));
                              isUnpaidBreakSelectCustomTime = true;
                            });
                          },
                    minusMinuteTap: currentIndex == 3
                        ? null
                        : () {
                            setState(() {
                              unPaidBreak = unPaidBreak
                                  .subtract(const Duration(minutes: 1));
                              isUnpaidBreakSelectCustomTime = true;
                            });
                          },
                    manualTimeTap: currentIndex == 3
                        ? null
                        : () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context, //context of current state
                            );

                            if (pickedTime != null) {
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
                            } else {
                              debugPrint("Time is not selected");
                            }
                          },
                    onTab: currentIndex == 3
                        ? null
                        : () {
                            currentIndex = 3;
                            setState(() {
                              if (isUnpaidBreakSelectCustomTime) {
                                unPaidBreak = unPaidBreak;
                              } else {
                                unPaidBreak = DateTime.now();
                              }
                            });
                            HistoryElement historyElement = HistoryElement(
                                time: unPaidBreak, type: "Unpaid break");
                            jobHistory.add(historyElement);
                          },
                    breakStatus:
                        AppLocalizations.of(context)?.homeScreenUnPaidBreak ??
                            '',
                    color: currentIndex == 3
                        ? greyColor.withOpacity(0.3)
                        : orangeColor,
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

            ListView.builder(
              shrinkWrap: true,
              itemCount: jobHistory.length,
              itemBuilder: (context, index) {
                return Text(
                  "${DateFormat('d.M.y').format(jobHistory[index].time ?? DateTime.now())}-"
                  "${DateFormat('h:mm a').format(jobHistory[index].time ?? DateTime.now())}-${jobHistory[index].type}",
                  style: CustomTextStyle.kBodyText1.copyWith(
                      color: getTextColor(jobHistory[index].type ?? ''),
                      fontWeight: FontWeight.w400),
                );
              },
            ),

            SizedBox(height: 10.h),
            jobHistoryBox.isNotEmpty
                ? ValueListenableBuilder(
                    valueListenable: jobHistoryBox.listenable(),
                    builder: (context, Box box, widget) {
                      return ListView.builder(
                          itemCount: box.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            List<JobHistoryModel> jobList =
                                box.getAt(i).cast<JobHistoryModel>();
                            jobList.sort(
                                (a, b) => b.timestamp.compareTo(a.timestamp));
                            String dataKey = box.keyAt(i);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dataKey,
                                  style: CustomTextStyle.kBodyText1.copyWith(
                                      color: blueColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                ListView.builder(
                                  itemBuilder: (context, j) {
                                    List<HistoryElement> historyList =
                                        jobList[j].historyElement ?? [];

                                    historyList.sort(
                                        (a, b) => b.time!.compareTo(a.time!));

                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15.h),
                                      child: ListView.builder(
                                        itemCount: historyList.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemBuilder: (context, k) {
                                          return Text(
                                            "${DateFormat('d.M.y').format(historyList[k].time ?? DateTime.now())}-"
                                            "${DateFormat('h:mm a').format(historyList[k].time ?? DateTime.now())}-${historyList[k].type}",
                                            style: CustomTextStyle.kBodyText1
                                                .copyWith(
                                                    color: getTextColor(jobList[
                                                                j]
                                                            .historyElement?[k]
                                                            .type ??
                                                        ''),
                                                    fontWeight:
                                                        FontWeight.w400),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  itemCount: jobList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                )
                              ],
                            );
                          });
                    })
                : const Center(
                    child: Text("No history found"),
                  ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
