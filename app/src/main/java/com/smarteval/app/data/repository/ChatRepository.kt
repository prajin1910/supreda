package com.smarteval.app.data.repository

import com.smarteval.app.data.model.*
import com.smarteval.app.data.remote.ApiService
import com.smarteval.app.utils.Resource
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ChatRepository @Inject constructor(
    private val apiService: ApiService
) {
    
    suspend fun sendMessage(request: SendMessageRequest): Flow<Resource<ApiResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.sendMessage(request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to send message"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getMessages(userId1: String, userId2: String): Flow<Resource<List<ChatMessage>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getMessages(userId1, userId2)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch messages"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getConversations(userId: String): Flow<Resource<List<ChatConversation>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getConversations(userId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch conversations"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun searchUsers(query: String): Flow<Resource<List<User>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.searchUsers(query)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to search users"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
}