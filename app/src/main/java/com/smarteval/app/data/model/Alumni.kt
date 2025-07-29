package com.smarteval.app.data.model

data class AlumniRequest(
    val id: String,
    val alumniId: String,
    val alumniUsername: String,
    val alumniEmail: String,
    val professorId: String,
    val professorEmail: String,
    val status: AlumniRequestStatus,
    val createdAt: String
)

enum class AlumniRequestStatus {
    PENDING, APPROVED, REJECTED
}