package com.smarteval.app.data.repository

import com.smarteval.app.data.model.*
import com.smarteval.app.data.remote.ApiService
import com.smarteval.app.utils.Resource
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AlumniRepository @Inject constructor(
    private val apiService: ApiService
) {
    
    suspend fun getPendingRequests(professorId: String): Flow<Resource<List<AlumniRequest>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getPendingAlumniRequests(professorId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch alumni requests"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun approveRequest(requestId: String): Flow<Resource<ApiResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.approveAlumniRequest(requestId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to approve request"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun rejectRequest(requestId: String): Flow<Resource<ApiResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.rejectAlumniRequest(requestId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to reject request"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
}