package com.smarteval.app.data.repository

import com.smarteval.app.data.model.*
import com.smarteval.app.data.remote.ApiService
import com.smarteval.app.utils.Resource
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AssessmentRepository @Inject constructor(
    private val apiService: ApiService
) {
    
    suspend fun createAssessment(request: CreateAssessmentRequest): Flow<Resource<Assessment>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.createAssessment(request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to create assessment"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getStudentAssessments(studentId: String): Flow<Resource<List<Assessment>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getStudentAssessments(studentId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch assessments"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getProfessorAssessments(professorId: String): Flow<Resource<List<Assessment>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getProfessorAssessments(professorId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch assessments"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getAssessment(assessmentId: String): Flow<Resource<Assessment>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getAssessment(assessmentId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch assessment"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun submitAssessment(assessmentId: String, request: SubmitAssessmentRequest): Flow<Resource<ApiResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.submitAssessment(assessmentId, request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to submit assessment"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getAssessmentResults(assessmentId: String): Flow<Resource<List<AssessmentResult>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getAssessmentResults(assessmentId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch results"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getStudentResults(studentId: String): Flow<Resource<List<AssessmentResult>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getStudentResults(studentId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch results"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
}