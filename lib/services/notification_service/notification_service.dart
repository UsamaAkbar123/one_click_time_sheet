import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

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

  Future scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduledNotificationDateTime,
  }) async {
    return flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
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

  Future<void> showNotification(int id, String title, String body) async {
    return flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channelId',
            'channelName',
            importance: Importance.max,
          ),
          // iOS: DarwinNotificationDetails(),
        )
        // iOS details
        );
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   id,
    //   title,
    //   body,
    //   tz.TZDateTime.now(tz.local).add(
    //     const Duration(
    //       seconds: 1,
    //     ),
    //   ), //schedule the notification to show after 2 seconds.
    //   const NotificationDetails(
    //     // Android details
    //     android: AndroidNotificationDetails(
    //       'main_channel',
    //       'Main Channel',
    //       channelDescription: "ashwin",
    //       importance: Importance.max,
    //       priority: Priority.max,
    //     ),
    //     // iOS details
    //   ),
    //
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   androidAllowWhileIdle: true,
    // );
  }
}

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService{
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   static const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'reminder',
//     'Reminder Notification',
//     description: 'Notification send as reminder',
//     importance: Importance.defaultImportance,
//   );
//
//   /// initialize local notification
//   init() async{
//
//     // Initialize the local timezone
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
//
//     AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     InitializationSettings initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//     );
//
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//     final platform = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(channel);
//   }
//
//
//
//   /// android notification detail
//   getAndroidNotificationDetails(){
//     return  AndroidNotificationDetails(
//         channel.id,
//       channel.name,
//       channelDescription: channel.description,
//       importance: Importance.max,
//       enableVibration: true,
//       category: AndroidNotificationCategory.reminder,
//       icon: '@mipmap/ic_launcher',
//       groupKey: 'com.example.one_click_time_sheet.REMINDER',
//     );
//   }
//
//   /// get notification detail
//   getNotificationDetails(){
//     return NotificationDetails(
//       android: getAndroidNotificationDetails(),
//     );
//   }
//
//   /// notification time
//   tz.TZDateTime notificationTime(DateTime dateTime){
//     return tz.TZDateTime(
//       tz.local,
//       dateTime.year,
//       dateTime.month,
//       dateTime.day,
//       dateTime.hour,
//       dateTime.minute,
//       dateTime.second,
//     );
//   }
//
//
//
//
//   /// schedule the notification
//   Future scheduleStartJobNotification({
//     required int notificationId,
//     required DateTime startJobTime,
//     required int beforeNotificationSetter,
//     required String body,
// }) async{
//     print(startJobTime.subtract(Duration(minutes: beforeNotificationSetter)));
//     print(notificationId);
//     print(beforeNotificationSetter);
//     print(body);
//     print(tz.local);
//     flutterLocalNotificationsPlugin.zonedSchedule(
//       notificationId,
//       'Reminder',
//       body,
//       notificationTime(startJobTime.subtract(Duration(minutes: beforeNotificationSetter))),
//       getNotificationDetails(),
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }
