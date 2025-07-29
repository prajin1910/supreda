package com.smarteval.app.data.model

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class User(
    val id: String,
    val username: String,
    val email: String,
    val role: UserRole,
    val isVerified: Boolean,
    val isApproved: Boolean = false
) : Parcelable

enum class UserRole {
    STUDENT, PROFESSOR, ALUMNI
}

data class LoginRequest(
    val email: String,
    val password: String
)

data class RegisterRequest(
    val username: String,
    val email: String,
    val password: String,
    val role: String,
    val professorEmail: String? = null
)

data class OtpVerificationRequest(
    val email: String,
    val otp: String
)

data class LoginResponse(
    val token: String,
    val user: User
)

data class ApiResponse(
    val success: Boolean,
    val message: String
)