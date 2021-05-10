import 'dart:isolate';

import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:task_app_for_daniel/model/task.dart';
import 'package:task_app_for_daniel/services/local_storage.dart';
import 'package:task_app_for_daniel/services/notification_service.dart';

final int ALARM_ID = 123;
class AlarmService {
  /// The [SharedPreferences] key to access the alarm fire count.
  final String countKey = 'count';
  /// The name associated with the UI isolate's [SendPort].
  static String isolateName = 'isolate';
  /// A port used to communicate from a background isolate to the UI isolate.
  final ReceivePort port = ReceivePort();
  NotificationService notificationService;

  // The background
  static SendPort uiSendPort;

  // The callback for our alarm
  static Future<void> callback() async {
    AndroidAlarmManager.cancel(ALARM_ID);

    LocalStorage storage = LocalStorage();
    Task task = await storage.getCurrentTask();
    if ( task == null ) {
      return;
    }

    NotificationService notificationService = NotificationService();
    notificationService.initialiseNotification();
    notificationService.sendNotification(task);

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  AlarmService();

  initAlarms() async {

    notificationService = NotificationService();
    notificationService.initialiseNotification();
    // Register the UI isolate's SendPort to allow for communication from the
    // background isolate.
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
    AndroidAlarmManager.initialize();
  }

  setAlarmForTask(Task task) async {
    AndroidAlarmManager.cancel(ALARM_ID);
    await AndroidAlarmManager.oneShotAt(task.alarmTime, ALARM_ID, callback, exact: true, wakeup: true);
  }
}
