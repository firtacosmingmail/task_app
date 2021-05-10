import 'dart:developer';
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

  Function UICallback = null;

  NotificationService notificationService;

  // The background
  static SendPort uiSendPort;

  // The callback for our alarm
  static Future<void> callback() async {

    print("alarm called");
    AndroidAlarmManager.cancel(ALARM_ID);

    LocalStorage storage = LocalStorage();
    Task task = await storage.getCurrentTask();
    if ( task == null ) {
      return;
    }

    print("printing notification");
    NotificationService notificationService = NotificationService();
    await notificationService.initialiseNotification();
    await notificationService.sendNotification(task);
    print("printed notification");

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(task);
  }

  AlarmService();

  initAlarms() async {
    print("init Alarms");

    notificationService = NotificationService();
    notificationService.initialiseNotification();
    // Register the UI isolate's SendPort to allow for communication from the
    // background isolate.
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
    AndroidAlarmManager.initialize();
    port.listen((_) async => await callUICallback());

    print("done init Alarms");
  }

  setAlarmForTask(Task task, Function callbackWhenIsCalled) async {
    UICallback = callbackWhenIsCalled;
    print("setting alarm for task");
    AndroidAlarmManager.cancel(ALARM_ID);
    await AndroidAlarmManager.oneShotAt(task.alarmTime, ALARM_ID, callback, exact: true, wakeup: true);
  }

  callUICallback() {
    if ( UICallback != null ) {
      UICallback();
    }
  }
}
