import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:task_app_for_daniel/consts/app_colors.dart';
import 'package:task_app_for_daniel/screens/task_screen.dart';
import 'package:task_app_for_daniel/services/local_storage.dart';
import 'package:task_app_for_daniel/model/task.dart';
import 'package:task_app_for_daniel/services/date_time_utils.dart';
import 'package:task_app_for_daniel/widgets/field_with_label.dart';
import 'package:task_app_for_daniel/widgets/full_screen_loading.dart';

class CreateTaskScreen extends StatefulWidget {
  final LocalStorage storage;

  const CreateTaskScreen(this.storage, {Key key}) : super(key: key);

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  Task task = Task();
  Task oldTask;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getOldTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create an alarm"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => createAlarm(context),
        label: const Text('Set alarm'),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.pink,
      ),
      body: buildBody(context),
    );
  }

  void getOldTask() async {
    oldTask = await widget.storage.getCurrentTask();
    if (oldTask != null) {

      displayOldTask();
    }
  }

  void createAlarm(BuildContext context) async {
    if (task.title == null || task.title.isEmpty) {
      showError(
          "To save the alarm a title is necessary. Please add a title to the alarm");
      return;
    }
    if (task.description == null || task.description.isEmpty) {
      showError(
          "To save the alarm a description is necessary. Please add a description to the alarm");
      return;
    }

    if (task.alarmTime == null) {
      showError(
          "To save the alarm an alarm time is necessary. Please add an alarm time to the alarm");
      return;
    }

    setState(() {
      loading = true;
    });

    await widget.storage.saveCurrentTask(task);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TaskScreen(widget.storage);
        },
      ),
    );
  }

  titleChanged(String newTitle) {
    task.title = newTitle;
  }

  descChanged(String newDesc) {
    task.description = newDesc;
  }

  newAlarmDateConfirmed(DateTime time) {
    setState(() {
      task.alarmTime = time;
    });
  }

  showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  buildBody(BuildContext context) {
    if (loading) {
      return FullScreenLoading();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldWithLabel(
            labelText: "Title",
            hintText: "The title of the task",
            onChange: titleChanged,
            initialValue: task.title,
            validator: (value) {
              if (value.isEmpty) {
                return "Please add the title of the task.";
              }
              return null;
            },
          ),
          FieldWithLabel(
            labelText: "Description",
            hintText: "The description of the task",
            onChange: descChanged,
            initialValue: task.description,
            validator: (value) {
              if (value.isEmpty) {
                return "Please add the description of the task.";
              }
              return null;
            },
          ),
          Row(
            children: [
              Text(task.alarmTime == null
                  ? ""
                  : "Selected alarm time: ${parseDateTime(task.alarmTime)}"),
              SizedBox(
                width: 10.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime.now().add(Duration(days: 10)),
                        theme: DatePickerTheme(
                            headerColor: AppColors.primaryColor,
                            backgroundColor: AppColors.secondaryColor,
                            itemStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            doneStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                        onConfirm: newAlarmDateConfirmed,
                        currentTime: DateTime.now(),
                        locale: LocaleType.en);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      task.alarmTime == null
                          ? 'Select alarm time'
                          : "Edit alarm time",
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
            ],
          )

        ],
      ),
    );
  }

  void displayOldTask() async {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(oldTask.title),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(oldTask.description),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  deleteOldTask();
                },
              ),
            ],
          );
        },
      );
  }

  void deleteOldTask() async {
    await widget.storage.removeTask();
    Navigator.of(context).pop();
  }
}
