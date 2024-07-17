import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/ui/notified_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotifyHelper() {
    initializeNotification();
  }

  Future<void> initializeNotification() async {
    _configureLocalTimezone();

    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('appicon');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotification,
    );
    print("Notification initialized");
  }

  void displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
    print("Notification displayed");
  }

  /*Future<void> scheduledNotification(int hour, int minutes, Task task) async {
    print("Scheduling notification");

    tz.TZDateTime scheduledTime = _convertTime(hour, minutes);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      int.parse(task.id!),
      task.title,
      task.note,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|${task.note}|",
    );

    print("Notification scheduled");
    print(tz.TZDateTime.now(tz.local));
  }*/
  Future<void> scheduledNotification(int hour, int minutes, Task task) async {
    print("Scheduling notification");

    // Set the local location
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    int notificationId;
    try {
      // Attempt to parse the task id to an integer
      notificationId = task.id.hashCode;
    } catch (e) {
      // Handle parsing error
      print('Error parsing task id: $e');
      return; // Exit the function if id is invalid
    }

    // Fetch the task document
    DocumentSnapshot taskDoc = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(task.id)
        .get();

    if (!taskDoc.exists) {
      print('Error: Task not found.');
      return;
    }

    // Extract remind value from Firestore document
    int remind = (taskDoc.data() as Map<String, dynamic>?)?['remind'] ?? 5; // Default to 5 minutes if not set

    // Schedule notification using remind value
    tz.TZDateTime scheduledTime = _convertTime(hour, minutes, remind);

    // Print the scheduled time
    print('Scheduled time: $scheduledTime');

    // Schedule notification using Firebase Messaging
    await _scheduleFirebaseNotification(task, scheduledTime);

    print("Notification scheduled");
  }

  Future<void> _scheduleFirebaseNotification(Task task, tz.TZDateTime scheduledTime) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) {
      print('Error: Unable to get FCM token.');
      return;
    }

    FirebaseFirestore.instance.collection('scheduled_notifications').add({
      'title': task.title,
      'body': task.note,
      'scheduled_time': scheduledTime.toIso8601String(),
      'token': token,
    });
  }

  tz.TZDateTime _convertTime(int hour, int minutes, int remind) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    // Adjust scheduleDate based on the remind duration
    switch (remind) {
      case 5:
        scheduleDate = scheduleDate.subtract(const Duration(minutes: 5));
        break;
      case 10:
        scheduleDate = scheduleDate.subtract(const Duration(minutes: 10));
        break;
      case 15:
        scheduleDate = scheduleDate.subtract(const Duration(minutes: 15));
        break;
      case 20:
        scheduleDate = scheduleDate.subtract(const Duration(minutes: 20));
        break;
      default:
      // Handle other cases if necessary
        break;
    }

    // Check if scheduleDate is before the current time
    if (scheduleDate.isBefore(now)) {
      scheduleDate = now.add(const Duration(minutes: 1)); // Example: add 1 minute
      print('Adjusted scheduleDate: $scheduleDate');
    }

    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  Future selectNotification(NotificationResponse notificationResponse) async {
    String? payload = notificationResponse.payload;
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }

    if (payload == "Theme Changed") {
      print("Nothing to navigate to");
    } else {
      Get.to(() => NotifiedPage(label: payload));
    }
  }
}