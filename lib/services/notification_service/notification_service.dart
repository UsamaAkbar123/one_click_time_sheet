import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  PreferenceManager preferenceManager = PreferenceManager();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  /// initialize local notification
  Future<void> initNotification() async {

    // Android initialization
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// schedule start job notification
  Future scheduleStartJobNotification({
    required WorkPlanModel workPlanModel,
  }) async {
    //print('start job id: ${workPlanModel.notificationId}');
    String startTime = '';
    String endTime = '';
    if (preferenceManager.getTimeFormat == '24h') {
      startTime =
          DateFormat.Hm().format(workPlanModel.startWorkPlanTime);
      endTime =
          DateFormat.Hm().format(workPlanModel.endWorkPlanTime);
    } else {
      startTime =
          DateFormat.jm().format(workPlanModel.startWorkPlanTime);
      endTime =
          DateFormat.jm().format(workPlanModel.endWorkPlanTime);
    }
    return flutterLocalNotificationsPlugin.zonedSchedule(
      workPlanModel.notificationId ?? 0,
      'Start Job Remainder',
      "${workPlanModel.workPlanName} from $startTime to $endTime",
      tz.TZDateTime.from(
        workPlanModel.startWorkPlanTime.subtract(
          Duration(
            minutes: preferenceManager
                .getStartJobNotificationLimit,
          ),
        ),
        // workPlanModel.startWorkPlanTime,
        tz.local,
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          importance: Importance.max,
        ),
        // iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// schedule end job notification
  Future scheduleEndJobNotification({
    required WorkPlanModel workPlanModel,
  }) async {
    // print('end job id: ${workPlanModel.notificationId}');
    return flutterLocalNotificationsPlugin.zonedSchedule(
      workPlanModel.notificationId ?? 0,
      'End Job Remainder',
      "Job end in ${PreferenceManager().getEndJobNotificationLimit} minutes",
      tz.TZDateTime.from(
        workPlanModel.endWorkPlanTime.subtract(
          Duration(
            minutes: preferenceManager
                .getEndJobNotificationLimit,
          ),
        ),
        // workPlanModel.endWorkPlanTime,
        tz.local,
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          importance: Importance.max,
        ),
        // iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


  /// end job has notification
  Future<bool> endJobHasNotification(WorkPlanModel workPlanModel) async{
    var pendingNotifications = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications.any((notification) => notification.id == workPlanModel.notificationId);
  }

  /// start job has notification
  Future<bool> startJobHasNotification(WorkPlanModel workPlanModel) async{
    var pendingNotifications = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications.any((notification) => notification.id == workPlanModel.notificationId);
  }

  /// update start job notification
  void updateStartJobNotifications(WorkPlanModel workPlanModel) async{
    var hasNotification = await startJobHasNotification(workPlanModel);
    if(hasNotification){
      flutterLocalNotificationsPlugin.cancel(workPlanModel.notificationId ?? 0);
    }

    scheduleStartJobNotification(workPlanModel: workPlanModel);
  }

  /// update start job notification
  void updateEndJobNotifications(WorkPlanModel workPlanModel) async{
    var hasNotification = await endJobHasNotification(workPlanModel);
    if(hasNotification){
      flutterLocalNotificationsPlugin.cancel(workPlanModel.notificationId ?? 0);
    }
    scheduleStartJobNotification(workPlanModel: workPlanModel);
  }


}
