import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;
import 'package:permission_handler/permission_handler.dart';

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

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> showDailyReminder(
    int hour,
    int minute,
    BuildContext context,
  ) async {
    // Cancel any existing reminders first
    await flutterLocalNotificationsPlugin.cancel(0);

    // Request notification permissions
    if (Platform.isAndroid) {
      final notificationStatus = await Permission.notification.request();
      if (!notificationStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification permission is required for reminders'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Request exact alarm permission for Android 12+
      if (await _isAndroid12OrHigher()) {
        final exactAlarmStatus = await Permission.scheduleExactAlarm.request();
        if (!exactAlarmStatus.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Please enable exact alarm permission in settings for precise reminders',
              ),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () {
                  openAppSettings();
                },
              ),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Daily habit reminders',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

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
          "Exact alarm not permitted, falling back to approximate reminder: $e",
        );

        try {
          // Fallback to approximate daily reminder
          await flutterLocalNotificationsPlugin.periodicallyShow(
            0,
            'Habit Reminder',
            'Time to check your habits!',
            RepeatInterval.daily,
            platformDetails,
            androidAllowWhileIdle: true,
          );
        } catch (e) {
          debugPrint("Approximate alarm also failed: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to schedule reminders. Please check app permissions.',
              ),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }
      }
    } else {
      // iOS fallback
      try {
        await flutterLocalNotificationsPlugin.periodicallyShow(
          0,
          'Habit Reminder',
          'Time to check your habits!',
          RepeatInterval.daily,
          platformDetails,
          androidAllowWhileIdle: true,
        );
      } catch (e) {
        debugPrint("iOS notification scheduling failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to schedule reminders.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
    }

    // Show an in-app toast/snackbar for testing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          exactScheduled
              ? 'Exact daily reminder scheduled!'
              : 'Approximate daily reminder scheduled!',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<bool> _isAndroid12OrHigher() async {
    if (!Platform.isAndroid) return false;
    // Android 12 is API level 31
    // We can check this by trying to access device info or just assume it's Android 12+ for now
    // For simplicity, we'll request the permission on all Android devices
    return true;
  }

  Future<bool> areNotificationsEnabled() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled() ??
        true; // Assume enabled on other platforms
  }

  tz.TZDateTime _nextInstanceOfTime({required int hour, required int minute}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
