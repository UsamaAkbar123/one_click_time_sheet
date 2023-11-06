import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

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
    required DateTime scheduledNotificationDateTime,
  }) async {
    return flutterLocalNotificationsPlugin.zonedSchedule(
      workPlanModel.notificationId ?? 0,
      'Start Job Remainder',
      "${workPlanModel.workPlanName} from ${workPlanModel.startWorkPlanTime} to ${workPlanModel.endWorkPlanTime}",
      tz.TZDateTime.from(
        scheduledNotificationDateTime,
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
    required DateTime scheduledNotificationDateTime,
  }) async {
    // Generate a unique id based on the current timestamp
    int id = DateTime.now().millisecondsSinceEpoch % 2147483647;
    return flutterLocalNotificationsPlugin.zonedSchedule(
      workPlanModel.notificationId ?? 0,
      'End Job Remainder',
      "Job end in ${PreferenceManager().getEndJobNotificationLimit} minutes",
      tz.TZDateTime.from(
        scheduledNotificationDateTime,
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

  /// update notification
  void updateStartJobNotifications(WorkPlanModel workPlanModel) async{
    var hasNotification = await startJobHasNotification(workPlanModel);
    if(hasNotification){
      flutterLocalNotificationsPlugin.cancel(workPlanModel.notificationId ?? 0);
    }

    // scheduleStartJobNotification(workPlanModel: workPlanModel, scheduledNotificationDateTime: wo)
  }


}
