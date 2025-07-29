package com.smarteval.app.data.model

data class GenerateRoadmapRequest(
    val domain: String,
    val timeframe: String,
    val difficulty: String
)

data class RoadmapResponse(
    val roadmap: List<String>
)

data class GenerateAssessmentRequest(
    val domain: String,
    val difficulty: String,
    val numberOfQuestions: Int
)

data class AIAssessmentResponse(
    val questions: List<AIQuestion>
)

data class AIQuestion(
    val question: String,
    val options: List<String>,
    val correctAnswer: Int
)

data class EvaluateAnswersRequest(
    val domain: String,
    val difficulty: String,
    val questions: List<AIQuestion>,
    val answers: List<Int>
)

data class EvaluationResponse(
    val score: Int,
    val totalQuestions: Int,
    val feedback: String,
    val detailedFeedback: String,
    val wrongAnswers: List<WrongAnswer>,
    val strengths: List<String>,
    val improvements: List<String>
)

data class WrongAnswer(
    val question: String,
    val userAnswer: String,
    val correctAnswer: String,
    val explanation: String
)

data class ExplainAnswerRequest(
    val question: String,
    val correctAnswer: String
)

data class ExplanationResponse(
    val explanation: String
)