package com.smarteval.app.data.model

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class Assessment(
    val id: String,
    val title: String,
    val description: String,
    val questions: List<Question>,
    val startTime: String,
    val endTime: String,
    val createdBy: String,
    val assignedStudents: List<String>,
    val status: AssessmentStatus,
    val createdAt: String
) : Parcelable

@Parcelize
data class Question(
    val id: String,
    val questionText: String,
    val options: List<String>,
    val correctAnswer: Int
) : Parcelable

enum class AssessmentStatus {
    SCHEDULED, ONGOING, COMPLETED
}

data class AssessmentResult(
    val id: String,
    val assessmentId: String,
    val studentId: String,
    val answers: List<Int>,
    val score: Int,
    val completedAt: String
)

data class SubmitAssessmentRequest(
    val studentId: String,
    val answers: List<Int>
)

data class CreateAssessmentRequest(
    val title: String,
    val description: String,
    val questions: List<Question>,
    val startTime: String,
    val endTime: String,
    val assignedStudents: List<String>,
    val createdBy: String
)