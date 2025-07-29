package com.smarteval.app.data.repository

import com.smarteval.app.data.model.*
import com.smarteval.app.data.remote.ApiService
import com.smarteval.app.utils.Resource
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthRepository @Inject constructor(
    private val apiService: ApiService
) {
    
    suspend fun register(request: RegisterRequest): Flow<Resource<ApiResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.register(request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Registration failed"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun verifyOtp(request: OtpVerificationRequest): Flow<Resource<ApiResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.verifyOtp(request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "OTP verification failed"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun login(request: LoginRequest): Flow<Resource<LoginResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.login(request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Login failed"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun resendOtp(email: String): Flow<Resource<ApiResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.resendOtp(mapOf("email" to email))
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to resend OTP"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
}