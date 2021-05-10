import 'package:flutter/material.dart';
import 'package:task_app_for_daniel/consts/app_colors.dart';
import 'package:task_app_for_daniel/model/task.dart';
import 'package:task_app_for_daniel/screens/create_task_screen.dart';
import 'package:task_app_for_daniel/services/alarm_service.dart';
import 'package:task_app_for_daniel/services/date_time_utils.dart';
import 'package:task_app_for_daniel/services/local_storage.dart';
import 'package:task_app_for_daniel/widgets/full_screen_loading.dart';

class TaskScreen extends StatefulWidget {
  final LocalStorage storage;

  const TaskScreen(this.storage, {Key key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Task task;
  bool loading = true;
  AlarmService alarmService;

  @override
  void initState() {
    super.initState();
    getTaskFromStorageAndSendAlarm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Running alarm"),
      ),
      body: buildBody(context),
    );
  }

  buildBody(BuildContext context) {
    if (loading) {
      return FullScreenLoading();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          task.isExpired()
              ? Center(
                  child: Text(
                    "Task has expired",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : Container(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Title:  ",
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                task.title,
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Description:  ",
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                task.description,
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Alarm time:  ",
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                parseDateTime(task.alarmTime),
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          task.isExpired()
              ? ElevatedButton(
                  onPressed: goToCreateNewTask,
                  child: Text(
                    "Create new task",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : ElevatedButton(
                  onPressed: _showMyDialog,
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
        ],
      ),
    );
  }

  void getTaskFromStorageAndSendAlarm() async {
    await getTaskFromStorage();
    alarmService = AlarmService();
    await alarmService.initAlarms();
    startAlarm();
  }

  void getTaskFromStorage() async {
    Task storedTask = await widget.storage.getCurrentTask();
    setState(() {
      loading = false;
      task = storedTask;
    });
  }

  void deleteTask() async {
    setState(() {
      loading = true;
    });
    await widget.storage.removeTask();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CreateTaskScreen(widget.storage);
        },
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete task'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure you want to delete the task?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                deleteTask();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startAlarm() {
    alarmService.setAlarmForTask(task, refresh);
  }

  refresh() {
    getTaskFromStorage();
  }

  void goToCreateNewTask() async {
    await widget.storage.removeTask();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CreateTaskScreen(widget.storage);
        },
      ),
    );
  }
}
