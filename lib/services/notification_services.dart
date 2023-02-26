import 'package:courierx/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');
    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    // final MacOSInitializationSettings initializationSettingsMacOS =
    //     MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);
    tz.initializeTimeZones(); //
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails('Channel id', 'Channel name',
          channelDescription: 'Channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');

  // NotificationDetails platformChannelSpecifics =
  // NotificationDetails(
  //     android: _androidNotificationDetails,
  //     iOS: null  );

  Future selectNotification(String payload) async {

    
    //Handle notification tapped logic here
    // if (payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  Future<void> showNotifications(
      int id, String title, String description) async {
    for(int i =170; i<=173; i++){
      if (strings.langEng[i] == title){
        title = strings.get(i)!;
        break;
      }
    }
    for(int j =170; j<=173; j++){
      if (strings.langEng[j] == description){
        description = strings.get(j)!;
        break;
      }
    }
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      description,
      NotificationDetails(android: _androidNotificationDetails),
      // payload: 'Notification Payload',
    );
  }

  Future<void> scheduleNotifications(
      int id, String title, String description) async {
    for(int i =170; i<=173; i++){
      if (strings.langEng[i] == title){
        title = strings.get(i)!;
        break;
      }
    }
    for(int j =170; j<=173; j++){
      if (strings.langEng[j] == description){
        description = strings.get(j)!;
        break;
      }
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        description,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
