// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    title: json['title'] as String,
    description: json['description'] as String,
    alarmTime: json['alarmTime'] == null
        ? null
        : DateTime.parse(json['alarmTime'] as String),
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'alarmTime': instance.alarmTime?.toIso8601String(),
    };
