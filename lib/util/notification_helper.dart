import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;

class NotificationHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationHelper() {
    _init();
  }

  void _init() async {
    tzData.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> showDailyReminder(int hour, int minute, BuildContext context) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminders',
      channelDescription: 'Daily habit reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    bool exactScheduled = false;

    if (Platform.isAndroid) {
      try {
        // Try exact alarm first
        await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Habit Reminder',
          'Time to check your habits!',
          _nextInstanceOfTime(hour: hour, minute: minute),
          platformDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        exactScheduled = true;
      } catch (e) {
        debugPrint(
            "Exact alarm not permitted, falling back to approximate reminder: $e");

        // Fallback to approximate daily reminder
        await flutterLocalNotificationsPlugin.periodicallyShow(
          0,
          'Habit Reminder',
          'Time to check your habits!',
          RepeatInterval.daily,
          platformDetails,
          androidAllowWhileIdle: true,
        );
      }
    } else {
      // iOS fallback
      await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Habit Reminder',
        'Time to check your habits!',
        RepeatInterval.daily,
        platformDetails,
        androidAllowWhileIdle: true,
      );
    }

    // Show an in-app toast/snackbar for testing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(exactScheduled
            ? 'Exact daily reminder scheduled!'
            : 'Approximate daily reminder scheduled!'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  tz.TZDateTime _nextInstanceOfTime({required int hour, required int minute}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}


