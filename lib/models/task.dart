import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final String id;
  final String studentId;
  final String title;
  final String? description;
  final String startDateTime;
  final String endDateTime;
  final String status;
  final String priority;
  final String createdAt;
  final String updatedAt;
  final String? completedAt;
  final bool isOverdue;

  Task({
    required this.id,
    required this.studentId,
    required this.title,
    this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    required this.isOverdue,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

@JsonSerializable()
class TaskStats {
  final int pending;
  final int ongoing;
  final int completed;
  final int overdue;

  TaskStats({
    required this.pending,
    required this.ongoing,
    required this.completed,
    required this.overdue,
  });

  factory TaskStats.fromJson(Map<String, dynamic> json) => _$TaskStatsFromJson(json);
  Map<String, dynamic> toJson() => _$TaskStatsToJson(this);
}

@JsonSerializable()
class CreateTaskRequest {
  final String title;
  final String? description;
  final String startDateTime;
  final String endDateTime;
  final String priority;

  CreateTaskRequest({
    required this.title,
    this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.priority,
  });

  factory CreateTaskRequest.fromJson(Map<String, dynamic> json) => _$CreateTaskRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTaskRequestToJson(this);
}