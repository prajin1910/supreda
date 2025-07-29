import 'package:json_annotation/json_annotation.dart';

part 'ai.g.dart';

@JsonSerializable()
class GenerateRoadmapRequest {
  final String domain;
  final String timeframe;
  final String difficulty;

  GenerateRoadmapRequest({
    required this.domain,
    required this.timeframe,
    required this.difficulty,
  });

  factory GenerateRoadmapRequest.fromJson(Map<String, dynamic> json) => _$GenerateRoadmapRequestFromJson(json);
  Map<String, dynamic> toJson() => _$GenerateRoadmapRequestToJson(this);
}

@JsonSerializable()
class RoadmapResponse {
  final List<String> roadmap;

  RoadmapResponse({
    required this.roadmap,
  });

  factory RoadmapResponse.fromJson(Map<String, dynamic> json) => _$RoadmapResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RoadmapResponseToJson(this);
}

@JsonSerializable()
class GenerateAssessmentRequest {
  final String domain;
  final String difficulty;
  final int numberOfQuestions;

  GenerateAssessmentRequest({
    required this.domain,
    required this.difficulty,
    required this.numberOfQuestions,
  });

  factory GenerateAssessmentRequest.fromJson(Map<String, dynamic> json) => _$GenerateAssessmentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$GenerateAssessmentRequestToJson(this);
}

@JsonSerializable()
class AIAssessmentResponse {
  final List<AIQuestion> questions;

  AIAssessmentResponse({
    required this.questions,
  });

  factory AIAssessmentResponse.fromJson(Map<String, dynamic> json) => _$AIAssessmentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AIAssessmentResponseToJson(this);
}

@JsonSerializable()
class AIQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;

  AIQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory AIQuestion.fromJson(Map<String, dynamic> json) => _$AIQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$AIQuestionToJson(this);
}

@JsonSerializable()
class EvaluateAnswersRequest {
  final String domain;
  final String difficulty;
  final List<AIQuestion> questions;
  final List<int> answers;

  EvaluateAnswersRequest({
    required this.domain,
    required this.difficulty,
    required this.questions,
    required this.answers,
  });

  factory EvaluateAnswersRequest.fromJson(Map<String, dynamic> json) => _$EvaluateAnswersRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EvaluateAnswersRequestToJson(this);
}

@JsonSerializable()
class EvaluationResponse {
  final int score;
  final int totalQuestions;
  final String feedback;
  final String detailedFeedback;
  final List<WrongAnswer> wrongAnswers;
  final List<String> strengths;
  final List<String> improvements;

  EvaluationResponse({
    required this.score,
    required this.totalQuestions,
    required this.feedback,
    required this.detailedFeedback,
    required this.wrongAnswers,
    required this.strengths,
    required this.improvements,
  });

  factory EvaluationResponse.fromJson(Map<String, dynamic> json) => _$EvaluationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EvaluationResponseToJson(this);
}

@JsonSerializable()
class WrongAnswer {
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final String explanation;

  WrongAnswer({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.explanation,
  });

  factory WrongAnswer.fromJson(Map<String, dynamic> json) => _$WrongAnswerFromJson(json);
  Map<String, dynamic> toJson() => _$WrongAnswerToJson(this);
}

@JsonSerializable()
class ExplainAnswerRequest {
  final String question;
  final String correctAnswer;

  ExplainAnswerRequest({
    required this.question,
    required this.correctAnswer,
  });

  factory ExplainAnswerRequest.fromJson(Map<String, dynamic> json) => _$ExplainAnswerRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ExplainAnswerRequestToJson(this);
}

@JsonSerializable()
class ExplanationResponse {
  final String explanation;

  ExplanationResponse({
    required this.explanation,
  });

  factory ExplanationResponse.fromJson(Map<String, dynamic> json) => _$ExplanationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExplanationResponseToJson(this);
}