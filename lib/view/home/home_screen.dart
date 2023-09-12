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
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime nowDateTime = DateTime.now();
  final Box jobHistoryBox = Hive.box('jobHistoryBox');
  final Box workPlanBox = Hive.box('workPlan');
  final Box currentWorkHistoryElement = Hive.box('currentWorkHistoryElement');
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

  int currentIndex = -1;

  List<HistoryElement> currentHistoryElementJobList = [];

  DateTime? previousStartJobTime;
  DateTime? previousEndJobTime;
  DateTime? previousPaidBreakTime;
  DateTime? previousUnPaidBreakTime;
  String dateKey = '';

  /// previous data plus minus time check
  bool isPreviousJobAdded = false;

  String formatJobData({required DateTime? jobTime, required String? jobType}) {
    if (preferenceManager.getTimeFormat == '12h') {
      return "${DateFormat(preferenceManager.getDateFormat).format(jobTime ?? DateTime.now())} - "
          "${DateFormat('h:mm a').format(jobTime ?? DateTime.now())} - $jobType";
    } else {
      return "${DateFormat(preferenceManager.getDateFormat).format(jobTime ?? DateTime.now())} - "
          "${DateFormat.Hm().format(jobTime ?? DateTime.now())} - $jobType";
    }
  }

  Color getTextColor(String type) {
    switch (type) {
      case "Start job":
        return greenColor;
      case "End job":
        return redColor;
      case "Paid break":
        return lightGreenColor;
      case "paid break":
        return lightGreenColor;
      default:
        return orangeColor;
    }
  }

  void setCurrentIndexAccordingToJobType(String jobType) {
    switch (jobType) {
      case 'Start job':
        currentIndex = 0;
        break;
      case 'Paid break':
        currentIndex = 2;
        break;
      case 'Unpaid break':
        currentIndex = 3;
        break;
      default:
        currentIndex = -1;
    }
  }

  @override
  void initState() {
    currentHistoryElementJobList =
        currentWorkHistoryElement.values.toList().cast<HistoryElement>();

    if (currentHistoryElementJobList.isNotEmpty) {
      HistoryElement historyElement = currentHistoryElementJobList.last;
      setCurrentIndexAccordingToJobType(historyElement.type ?? '');
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
                            final tempWorkPlanList =
                                dynamicWorkPlanList.cast<WorkPlanModel>();
                            DateTime now = DateTime.now();
                            for (final workPlan in tempWorkPlanList) {
                              if (workPlan.workPlanDate ==
                                  DateTime(now.year, now.month, now.day)) {
                                workPlanList.add(workPlan);
                              }
                            }
                            // Sort the workplan list based on the start time in ascending order.
                            workPlanList.sort((a, b) => a.startWorkPlanTime
                                .compareTo(b.startWorkPlanTime));
                          }
                        }
                      }
                      return workPlanList.isEmpty
                          ? const SizedBox()
                          : Container(
                              height: 50.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: blackColor),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                            ?.homeScreenPlan ??
                                        '',
                                    style: CustomTextStyle.kHeading2,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: workPlanList.length < 2
                                          ? workPlanList.length
                                          : 2,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        String startTime;
                                        String endTime;
                                        if (preferenceManager.getTimeFormat ==
                                            '12h') {
                                          startTime = DateFormat('h:mm a')
                                              .format(workPlanList[index]
                                                  .startWorkPlanTime);
                                          endTime = DateFormat('h:mm a').format(
                                              workPlanList[index]
                                                  .endWorkPlanTime);
                                        } else {
                                          startTime = DateFormat('H:mm').format(
                                              workPlanList[index]
                                                  .startWorkPlanTime);
                                          endTime = DateFormat('H:mm').format(
                                              workPlanList[index]
                                                  .endWorkPlanTime);
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
                  previousStartJobTime = null;
                  previousEndJobTime = null;
                  previousPaidBreakTime = null;
                  previousUnPaidBreakTime = null;
                  isPreviousJobAdded = false;
                });
              },
            ),
            SizedBox(height: 12.h),
            StartEndJobBox(
              jobStatus: AppLocalizations.of(context)?.homeScreenStartJob ?? '',
              color:
                  currentIndex == 0 ? greyColor.withOpacity(0.3) : greenColor,
              plusMinuteTap: currentIndex == 0
                  ? null
                  : () {
                      if (previousStartJobTime != null) {
                        startJobTime = previousStartJobTime!;
                      }
                      //print(startJobTime);
                      setState(() {
                        startJobTime =
                            startJobTime.add(const Duration(minutes: 1));

                        isStartJobSelectCustomTime = true;
                        if (isPreviousJobAdded == true) {
                          previousStartJobTime = startJobTime;
                        }
                      });
                    },
              minusMinuteTap: currentIndex == 0
                  ? null
                  : () {
                      if (previousStartJobTime != null) {
                        startJobTime = previousStartJobTime!;
                      }
                      setState(() {
                        startJobTime =
                            startJobTime.subtract(const Duration(minutes: 1));

                        isStartJobSelectCustomTime = true;
                        if (isPreviousJobAdded == true) {
                          previousStartJobTime = startJobTime;
                        }
                      });
                    },
              manualTimeTap: currentIndex == 0
                  ? null
                  : () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              alwaysUse24HourFormat:
                                  preferenceManager.getTimeFormat == '24h',
                            ),
                            child: child ?? const SizedBox(),
                          );
                        }, //context of current state
                      );

                      if (previousStartJobTime != null) {
                        startJobTime = previousStartJobTime!;
                      }

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
                        if (isPreviousJobAdded == true) {
                          previousStartJobTime = startJobTime;
                        }
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
                          if (previousStartJobTime != null) {
                            startJobTime = previousStartJobTime!;
                          } else {
                            startJobTime = DateTime.now();
                          }
                        }
                      });
                      HistoryElement historyElement = HistoryElement(
                        time: startJobTime,
                        type: "Start job",
                        elementId: const Uuid().v4(),
                      );

                      await currentWorkHistoryElement.add(historyElement);
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
                      if (previousEndJobTime != null) {
                        endJob = previousEndJobTime!;
                      }
                      setState(() {
                        endJob = endJob.add(const Duration(minutes: 1));
                        isEndJobSelectCustomTime = true;
                        if (isPreviousJobAdded == true) {
                          previousEndJobTime = endJob;
                        }
                      });
                    },
              minusMinuteTap: currentIndex == 1
                  ? null
                  : () {
                      if (previousEndJobTime != null) {
                        endJob = previousEndJobTime!;
                      }
                      setState(() {
                        endJob = endJob.subtract(const Duration(minutes: 1));
                        isEndJobSelectCustomTime = true;
                        if (isPreviousJobAdded == true) {
                          previousEndJobTime = endJob;
                        }
                      });
                    },
              manualTimeTap: currentIndex == 1
                  ? null
                  : () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              alwaysUse24HourFormat:
                                  preferenceManager.getTimeFormat == '24h',
                            ),
                            child: child ?? const SizedBox(),
                          );
                        }, //context of current state
                      );

                      if (previousEndJobTime != null) {
                        endJob = previousEndJobTime!;
                      }

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
                          if (isPreviousJobAdded == true) {
                            previousEndJobTime = endJob;
                          }
                        });
                      } else {
                        debugPrint("Time is not selected");
                      }
                    },
              startingDate: endJob,
              color: currentIndex == 1 ? greyColor.withOpacity(0.3) : redColor,
              time: 0,
              onTab: currentIndex == -1
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Please first start the job'),
                          backgroundColor: redColor,
                          showCloseIcon: true,
                          closeIconColor: whiteColor,
                        ),
                      );
                    }
                  : currentIndex == 1
                      ? null
                      : () async {
                          currentIndex = 1;

                          setState(() {
                            if (isEndJobSelectCustomTime) {
                              endJob = endJob;
                            } else {
                              if (previousEndJobTime != null) {
                                endJob = previousEndJobTime!;
                              } else {
                                endJob = DateTime.now();
                              }
                            }
                          });
                          HistoryElement historyElement = HistoryElement(
                            time: endJob,
                            type: "End job",
                            elementId: const Uuid().v4(),
                          );

                          await currentWorkHistoryElement.add(historyElement);

                          currentHistoryElementJobList =
                              currentWorkHistoryElement.values
                                  .toList()
                                  .cast<HistoryElement>();

                          await currentWorkHistoryElement.clear();

                          dateKey = DateFormat('EEEE, d, M, y').format(
                              previousEndJobTime != null
                                  ? previousEndJobTime!
                                  : DateTime.now());
                          final Box box = Hive.box('jobHistoryBox');
                          JobHistoryModel jobHistoryModel = JobHistoryModel(
                              id: DateFormat('EEEE, d, M, y').format(
                                  previousEndJobTime != null
                                      ? previousEndJobTime!
                                      : DateTime.now()),
                              // historyElement: jobHistory,
                              historyElement: currentHistoryElementJobList,
                              timestamp: previousEndJobTime != null
                                  ? previousEndJobTime!
                                  : DateTime.now(),
                              uuid: const Uuid().v4());

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

                          box.put(dateKey, jobHistoryList).then((value) {});

                          currentHistoryElementJobList = [];
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
                            if (previousPaidBreakTime != null) {
                              paidBreak = previousPaidBreakTime!;
                            }
                            setState(() {
                              paidBreak =
                                  paidBreak.add(const Duration(minutes: 1));
                              isPaidBreakSelectCustomTime = true;
                              if (isPreviousJobAdded == true) {
                                previousPaidBreakTime = paidBreak;
                              }
                            });
                          },
                    minusMinuteTap: currentIndex == 2
                        ? null
                        : () {
                            if (previousPaidBreakTime != null) {
                              paidBreak = previousPaidBreakTime!;
                            }
                            setState(() {
                              paidBreak = paidBreak
                                  .subtract(const Duration(minutes: 1));
                              isPaidBreakSelectCustomTime = true;
                              if (isPreviousJobAdded == true) {
                                previousPaidBreakTime = paidBreak;
                              }
                            });
                          },
                    manualTimeTap: currentIndex == 2
                        ? null
                        : () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    alwaysUse24HourFormat:
                                        preferenceManager.getTimeFormat ==
                                            '24h',
                                  ),
                                  child: child ?? const SizedBox(),
                                );
                              }, //context of current state
                            );

                            if (previousPaidBreakTime != null) {
                              paidBreak = previousPaidBreakTime!;
                            }

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
                                if (isPreviousJobAdded == true) {
                                  previousPaidBreakTime = paidBreak;
                                }
                              });
                            } else {
                              debugPrint("Time is not selected");
                            }
                          },
                    startingDate: paidBreak,
                    onTab: currentIndex == -1
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Please first start the job'),
                                backgroundColor: redColor,
                                showCloseIcon: true,
                                closeIconColor: whiteColor,
                              ),
                            );
                          }
                        : currentIndex == 2
                            ? null
                            : () async {
                                currentIndex = 2;
                                setState(() {
                                  if (isPaidBreakSelectCustomTime) {
                                    paidBreak = paidBreak;
                                  } else {
                                    if (previousPaidBreakTime != null) {
                                      paidBreak = previousPaidBreakTime!;
                                    } else {
                                      paidBreak = DateTime.now();
                                    }
                                  }
                                });
                                HistoryElement historyElement = HistoryElement(
                                  time: paidBreak,
                                  type: "Paid break",
                                  elementId: const Uuid().v4(),
                                );

                                await currentWorkHistoryElement
                                    .add(historyElement);
                              },
                    breakStatus:
                        AppLocalizations.of(context)?.homeScreenPaidBreak ?? '',
                    color: currentIndex == 2
                        ? greyColor.withOpacity(0.3)
                        : lightGreenColor,
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
                              if (previousUnPaidBreakTime != null) {
                                unPaidBreak = previousUnPaidBreakTime!;
                              }
                              unPaidBreak =
                                  unPaidBreak.add(const Duration(minutes: 1));
                              isUnpaidBreakSelectCustomTime = true;
                              if (isPreviousJobAdded == true) {
                                previousUnPaidBreakTime = unPaidBreak;
                              }
                            });
                          },
                    minusMinuteTap: currentIndex == 3
                        ? null
                        : () {
                            if (previousUnPaidBreakTime != null) {
                              unPaidBreak = previousUnPaidBreakTime!;
                            }
                            setState(() {
                              unPaidBreak = unPaidBreak
                                  .subtract(const Duration(minutes: 1));
                              isUnpaidBreakSelectCustomTime = true;
                              if (isPreviousJobAdded == true) {
                                previousUnPaidBreakTime = unPaidBreak;
                              }
                            });
                          },
                    manualTimeTap: currentIndex == 3
                        ? null
                        : () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    alwaysUse24HourFormat:
                                        preferenceManager.getTimeFormat ==
                                            '24h',
                                  ),
                                  child: child ?? const SizedBox(),
                                );
                              }, //context of current state
                            );

                            if (previousUnPaidBreakTime != null) {
                              unPaidBreak = previousUnPaidBreakTime!;
                            }

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
                                if (isPreviousJobAdded == true) {
                                  previousUnPaidBreakTime = unPaidBreak;
                                }
                              });
                            } else {
                              debugPrint("Time is not selected");
                            }
                          },
                    onTab: currentIndex == -1
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Please first start the job'),
                                backgroundColor: redColor,
                                showCloseIcon: true,
                                closeIconColor: whiteColor,
                              ),
                            );
                          }
                        : currentIndex == 3
                            ? null
                            : () async {
                                currentIndex = 3;
                                setState(() {
                                  if (isUnpaidBreakSelectCustomTime) {
                                    unPaidBreak = unPaidBreak;
                                  } else {
                                    if (previousUnPaidBreakTime != null) {
                                      unPaidBreak = previousUnPaidBreakTime!;
                                    } else {
                                      unPaidBreak = DateTime.now();
                                    }
                                  }
                                });
                                HistoryElement historyElement = HistoryElement(
                                  time: unPaidBreak,
                                  type: "Unpaid break",
                                  elementId: const Uuid().v4(),
                                );

                                await currentWorkHistoryElement
                                    .add(historyElement);
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

            currentWorkHistoryElement.isEmpty
                ? const SizedBox()
                : ValueListenableBuilder(
                    valueListenable: currentWorkHistoryElement.listenable(),
                    builder: (context, Box box, widget) {
                      currentHistoryElementJobList = currentWorkHistoryElement
                          .values
                          .toList()
                          .cast<HistoryElement>();
                      currentHistoryElementJobList =
                          currentHistoryElementJobList.reversed.toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Job',
                            style: CustomTextStyle.kBodyText1.copyWith(
                                color: blueColor, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10.h),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: currentHistoryElementJobList.length,
                            itemBuilder: (context, index) {
                              return Text(
                                formatJobData(
                                  jobTime: currentHistoryElementJobList[index]
                                          .time ??
                                      DateTime.now(),
                                  jobType:
                                      currentHistoryElementJobList[index].type,
                                ),
                                // "${DateFormat('d.M.y').format(currentHistoryElementJobList[index].time ?? DateTime.now())}-"
                                // "${DateFormat('h:mm a').format(currentHistoryElementJobList[index].time ?? DateTime.now())}-${currentHistoryElementJobList[index].type}",
                                style: CustomTextStyle.kBodyText1.copyWith(
                                    color: getTextColor(
                                      currentHistoryElementJobList[index]
                                              .type ??
                                          '',
                                    ),
                                    fontWeight: FontWeight.w400),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),

            SizedBox(height: 10.h),
            jobHistoryBox.isNotEmpty
                ? ValueListenableBuilder(
                    valueListenable: jobHistoryBox.listenable(),
                    builder: (context, Box box, widget) {
                      final keys = box.keys.toList();
                      // for (int i = 0; i < keys.length; i++) {
                      //   print('Before keys: ${keys[i]}');
                      // }
                      keys.sort(
                          // (a, b) =>
                          //     DateTime.parse(b).compareTo(DateTime.parse(a)),
                          (a, b) {
                        return DateFormat('EEEE, dd, M, yyyy')
                            .parse(b)
                            .compareTo(
                                DateFormat('EEEE, dd, M, yyyy').parse(a));
                      });

                      // for (int i = 0; i < keys.length; i++) {
                      //   print('After keys: ${keys[i]}');
                      // }
                      return ListView.builder(
                          // itemCount: box.length,
                          itemCount: keys.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            final key = keys[i]; // Get the sorted key
                            List<JobHistoryModel> jobList =
                                box.get(key).cast<JobHistoryModel>();

                            // List<JobHistoryModel> jobList =
                            //     box.getAt(i).cast<JobHistoryModel>();

                            jobList.sort(
                                (a, b) => b.timestamp.compareTo(a.timestamp));
                            // String dataKey = box.keyAt(key);
                            String dataKey = '';
                            DateTime dateTime =
                                DateFormat('EEEE, dd, M, yyyy').parse(key);
                            dataKey =
                                DateFormat(preferenceManager.getDateFormat)
                                    .format(dateTime);
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
                                  itemCount: jobList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemBuilder: (context, j) {
                                    List<HistoryElement> historyList =
                                        jobList[j].historyElement ?? [];

                                    // historyList = historyList.reversed.toList();
                                    historyList.sort(
                                      (a, b) => b.time!
                                          .compareTo(a.time ?? DateTime.now()),
                                    );

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
                                          // final reversedIndex =
                                          //     historyList.length - 1 - k;
                                          return Text(
                                            formatJobData(
                                                jobTime: historyList[k].time ??
                                                    DateTime.now(),
                                                jobType:
                                                    historyList[k].type ?? ''),
                                            style: CustomTextStyle.kBodyText1
                                                .copyWith(
                                                    color: getTextColor(
                                                        historyList[k].type ??
                                                            ''),
                                                    fontWeight:
                                                        FontWeight.w400),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                              ],
                            );
                          });
                    })
                : const Center(
                    child: Text(""),
                  ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DateTime? dateTime = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000, 12, 31),
            lastDate: DateTime(2030, 12, 31),
          );
          if (dateTime != null) {
            previousStartJobTime = dateTime;
            previousEndJobTime = dateTime;
            previousPaidBreakTime = dateTime;
            previousUnPaidBreakTime = dateTime;
            startJobTime = previousStartJobTime!;
            endJob = previousEndJobTime!;
            paidBreak = previousPaidBreakTime!;
            unPaidBreak = previousUnPaidBreakTime!;
            isPreviousJobAdded = true;
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
