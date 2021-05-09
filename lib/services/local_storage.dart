
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_app_for_daniel/model/task.dart';

class LocalStorage {

  static const String TASK_KEY = "TASK_KEY";

  FlutterSecureStorage storage;

  LocalStorage(){
    storage = new FlutterSecureStorage();
  }

  saveCurrentTask(Task task) {
    storage.write(key: TASK_KEY, value: json.encode(task.toJson()));
  }

  Future<Task> getCurrentTask() async {
    String task = await storage.read(key: TASK_KEY);
    if ( task != null && task.isNotEmpty ) {
        return Task.fromJson(json.decode(task));
    } 
    return null;
  }

  Future removeTask() async {
    await storage.delete(key: TASK_KEY);
  }

  Future clearAllStorage() async {
    return await removeTask();
  }

}
