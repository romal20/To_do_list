/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/ui/notified_page.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    _configureLocalTimezone();
    // this is for latest iOS settings
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("appicon");

      final InitializationSettings initializationSettings =
      InitializationSettings(
      iOS: initializationSettingsIOS,
      android:initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);

    print("Notification initialized");
var now1 = tz.TZDateTime.now(tz.local);
    print(now1);
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    String timezoneName = tz.local.name;
    print('Current timezone name: $timezoneName');

  }

  displayNotification({required String title, required String body}) async {
    print("Displaying notification");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = new DarwinNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
    print("Notification displayed");
  }

  scheduledNotification(int hour, int minutes, Task task) async {
print("Scheduling notification");
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    tz.TZDateTime scheduledTime =
    tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2));



    await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(task.id!),
        task.title,
        task.note,
        _convertTime(hour,minutes),
//        scheduledTime,
        //tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|" + "${task.note}|"
    );
    print("Notification scheduled");
    print(tz.TZDateTime.now(tz.local));
  }
 */
/* scheduledNotification(int hour, int minutes, Task task) async {
    print("Scheduling notification");

    // Set the local location
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    // Determine the scheduled time (example: 2 minutes from now for testing)
    tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2));

    int notificationId;
    try {
      // Attempt to parse the task id to an integer
      notificationId = int.parse(task.id!);
    } catch (e) {
      // Handle parsing error
      print('Error parsing task id: $e');
      return; // Exit the function if id is invalid
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, // Use the parsed notificationId
        task.title,
        task.note,
        _convertTime(hour, minutes), // Convert the time using the provided method
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id',
              'your channel name',
              channelDescription: 'your channel description'
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|${task.note}|"
    );
    print("Notification scheduled");
    print(tz.TZDateTime.now(tz.local));
  }


  tz.TZDateTime _convertTime(int hour, int minutes){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    if(scheduleDate.isBefore(now)){
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }*//*

  */
/*scheduledNotification(int hour, int minutes, Task task) async {
    print("Scheduling notification");

    // Set the local location
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    // Determine the scheduled time (example: 2 minutes from now for testing)
    tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2));

    // Generate a unique integer ID from the Firestore document ID
    int notificationId = task.id.hashCode;

    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, // Use the generated notificationId
        task.title,
        task.note,
        _convertTime(hour, minutes), // Convert the time using the provided method
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id',
              'your channel name',
              channelDescription: 'your channel description'
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|${task.note}|"
    );
    print("Notification scheduled");
    print(tz.TZDateTime.now(tz.local));
  }*//*

  */
/*scheduledNotification(int hour, int minutes, Task task) async {
    print("Scheduling notification");

    // Set the local location
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    // Fetch the task document
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('title', isEqualTo: task.title)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print('Error: Task not found.');
      return;
    }

    // Use the first document found (assuming title is unique)
    DocumentSnapshot taskDoc = querySnapshot.docs[0];
    String docId = taskDoc.reference.path.split('/').last;

    // Generate a unique integer ID from the Firestore document ID
    int notificationId = docId.hashCode;

    // Determine the scheduled time (example: 2 minutes from now for testing)
    tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(task.id!), // Use the generated notificationId
        task.title,
        task.note,
        _convertTime(hour, minutes), // Convert the time using the provided method
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id',
              'your channel name',
              channelDescription: 'your channel description'
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|${task.note}|"
    );

    print("Notification scheduled");
    print(tz.TZDateTime.now(tz.local));
  }*//*



  tz.TZDateTime _convertTime(int hour, int minutes){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    if(scheduleDate.isBefore(now)){
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    print("iOS permissions requested");
  }

  Future selectNotification(NotificationResponse notificationResponse) async {
    String? payload = notificationResponse.payload;
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }

    if (payload == "Theme Changed"){
      print("Nothing to navigate to");
    }else{
      Get.to(() => NotifiedPage(label: payload));
    }

  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
showDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotifiedPage(label: payload,),
                ),
              );
            },
          )
        ],
      ),
    );

    Get.dialog(Text("Welcome to Flutter"));
  }

}
*/
/*import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/ui/notified_page.dart';

class NotifyHelper {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  NotifyHelper() {
    initializeFirebaseMessaging();
  }

  void initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received notification: ${message.notification?.title}");
      // Handle notification when the app is in the foreground
      handleNotification(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from notification: ${message.notification?.title}");
      // Handle notification when the app is opened from terminated state
      handleNotification(message.data);
    });
  }

  void displayNotification({required String title, required String body}) {
    // Not used with Firebase Messaging; handled by FCM server-side
  }

  void scheduledNotification(int hour, int minutes, Task task) {
    // Not used with Firebase Messaging; handled by FCM server-side
  }

  void requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Firebase Messaging permission granted: ${settings.authorizationStatus}');
  }

  void handleNotification(Map<String, dynamic> message) {
    String? payload = message['data']['payload'];
    if (payload == "Theme Changed") {
      print("Nothing to navigate to");
    } else {
      Get.to(() => NotifiedPage(label: payload));
    }
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/ui/notified_page.dart';

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

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|${task.note}|",
    );

    print("Notification scheduled");
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

    if (payload == "Theme Changed"){
      print("Nothing to navigate to");
    }else{
      Get.to(() => NotifiedPage(label: payload));
    }}
}
