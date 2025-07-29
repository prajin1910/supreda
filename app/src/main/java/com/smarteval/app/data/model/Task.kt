package com.smarteval.app.data.model

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class Task(
    val id: String,
    val studentId: String,
    val title: String,
    val description: String?,
    val startDateTime: String,
    val endDateTime: String,
    val status: TaskStatus,
    val priority: TaskPriority,
    val createdAt: String,
    val updatedAt: String,
    val completedAt: String?,
    val isOverdue: Boolean
) : Parcelable

enum class TaskStatus {
    PENDING, ONGOING, COMPLETED
}

enum class TaskPriority {
    LOW, MEDIUM, HIGH
}

data class TaskStats(
    val pending: Int,
    val ongoing: Int,
    val completed: Int,
    val overdue: Int
)

data class CreateTaskRequest(
    val title: String,
    val description: String?,
    val startDateTime: String,
    val endDateTime: String,
    val priority: String
)