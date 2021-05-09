import 'package:flutter/material.dart';
import 'package:task_app_for_daniel/screens/create_task_screen.dart';
import 'package:task_app_for_daniel/services/local_storage.dart';
import 'package:task_app_for_daniel/model/task.dart';
import 'package:task_app_for_daniel/screens/task_screen.dart';
import 'package:task_app_for_daniel/widgets/full_screen_loading.dart';

class LoadingScreen extends StatelessWidget {
  final LocalStorage storage;

  const LoadingScreen({Key key, this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getTaskFromStorage(context);
    return FullScreenLoading();
  }

  getTaskFromStorage(BuildContext context) async {
    Task task = await storage.getCurrentTask();
    if (task == null || task.alarmTime == null || task.isExpired()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CreateTaskScreen(storage);
          },
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return TaskScreen(storage);
          },
        ),
      );
    }
  }
}
