import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {

  String title;
  String description;
  DateTime alarmTime;

  Task({this.title, this.description, this.alarmTime});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  bool isExpired(){
    return alarmTime == null || alarmTime.isBefore(DateTime.now());
  }

}