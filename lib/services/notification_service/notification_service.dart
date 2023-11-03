import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as ty;

class NotificationService{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  /// initialize local notification
  init() async{

    // final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    // ty.initializeTimeZones();
    // tz.se


    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // // Create and set up the notification channel
    // final AndroidNotificationDetails androidNotificationDetails =
    // getAndroidNotificationDetails();
    // final AndroidNotificationChannel channel =
    // AndroidNotificationChannel(
    //     androidNotificationDetails.channelId,
    //     androidNotificationDetails.channelName,
    //     // channelDescription: androidNotificationDetails.channelDescription,
    //     importance: androidNotificationDetails.importance,
    //     playSound: androidNotificationDetails.playSound,
    //     enableVibration: androidNotificationDetails.enableVibration);
    //
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //     AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);
  }



  /// android notification detail
  getAndroidNotificationDetails(){
    return const AndroidNotificationDetails(
        'reminder',
      'Reminder Notification',
      channelDescription: 'Notification send as reminder',
      importance: Importance.max,
      enableVibration: true,
      category: AndroidNotificationCategory.reminder,
      icon: '@mipmap/ic_launcher',
      groupKey: 'com.example.one_click_time_sheet.REMINDER',
    );
  }

  /// get notification detail
  getNotificationDetails(){
    return NotificationDetails(
      android: getAndroidNotificationDetails(),
    );
  }

  /// notification time
  tz.TZDateTime notificationTime(DateTime dateTime){
    return tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      //dateTime.second,
    );
  }




  /// schedule the notification
  Future scheduleStartJobNotification({
    required int notificationId,
    required DateTime startJobTime,
    required int beforeNotificationSetter,
    required String body,
}) async{
    print(startJobTime.subtract(Duration(minutes: beforeNotificationSetter)));
    print(notificationId);
    print(beforeNotificationSetter);
    print(body);
    flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Reminder',
      body,
      notificationTime(startJobTime.subtract(Duration(minutes: beforeNotificationSetter))),
      getNotificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}