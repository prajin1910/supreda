import 'package:json_annotation/json_annotation.dart';

part 'assessment.g.dart';

@JsonSerializable()
class Assessment {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final String startTime;
  final String endTime;
  final String createdBy;
  final List<String> assignedStudents;
  final String status;
  final String createdAt;

  Assessment({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
    required this.assignedStudents,
    required this.status,
    required this.createdAt,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) => _$AssessmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssessmentToJson(this);
}

@JsonSerializable()
class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswer;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class AssessmentResult {
  final String id;
  final String assessmentId;
  final String studentId;
  final List<int> answers;
  final int score;
  final String completedAt;

  AssessmentResult({
    required this.id,
    required this.assessmentId,
    required this.studentId,
    required this.answers,
    required this.score,
    required this.completedAt,
  });

  factory AssessmentResult.fromJson(Map<String, dynamic> json) => _$AssessmentResultFromJson(json);
  Map<String, dynamic> toJson() => _$AssessmentResultToJson(this);
}

@JsonSerializable()
class SubmitAssessmentRequest {
  final String studentId;
  final List<int> answers;

  SubmitAssessmentRequest({
    required this.studentId,
    required this.answers,
  });

  factory SubmitAssessmentRequest.fromJson(Map<String, dynamic> json) => _$SubmitAssessmentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SubmitAssessmentRequestToJson(this);
}

@JsonSerializable()
class CreateAssessmentRequest {
  final String title;
  final String description;
  final List<Question> questions;
  final String startTime;
  final String endTime;
  final List<String> assignedStudents;
  final String createdBy;

  CreateAssessmentRequest({
    required this.title,
    required this.description,
    required this.questions,
    required this.startTime,
    required this.endTime,
    required this.assignedStudents,
    required this.createdBy,
  });

  factory CreateAssessmentRequest.fromJson(Map<String, dynamic> json) => _$CreateAssessmentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateAssessmentRequestToJson(this);
}