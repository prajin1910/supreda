package com.smarteval.app.data.repository

import com.smarteval.app.data.model.*
import com.smarteval.app.data.remote.ApiService
import com.smarteval.app.utils.Resource
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AIRepository @Inject constructor(
    private val apiService: ApiService
) {
    
    suspend fun generateRoadmap(request: GenerateRoadmapRequest): Flow<Resource<RoadmapResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.generateRoadmap(request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to generate roadmap"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun generateAssessment(request: GenerateAssessmentRequest): Flow<Resource<AIAssessmentResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.generateAssessment(request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to generate assessment"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun explainAnswer(request: ExplainAnswerRequest): Flow<Resource<ExplanationResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.explainAnswer(request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to get explanation"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun evaluateAnswers(request: EvaluateAnswersRequest): Flow<Resource<EvaluationResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.evaluateAnswers(request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to evaluate answers"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
}