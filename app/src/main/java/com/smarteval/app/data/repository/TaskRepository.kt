package com.smarteval.app.data.repository

import com.smarteval.app.data.model.*
import com.smarteval.app.data.remote.ApiService
import com.smarteval.app.utils.Resource
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class TaskRepository @Inject constructor(
    private val apiService: ApiService
) {
    
    suspend fun createTask(studentId: String, request: CreateTaskRequest): Flow<Resource<Task>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.createTask(studentId, request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to create task"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getAllTasks(studentId: String): Flow<Resource<List<Task>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getAllTasks(studentId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch tasks"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getTasksByStatus(studentId: String, status: String): Flow<Resource<List<Task>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getTasksByStatus(studentId, status)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch tasks"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun updateTask(taskId: String, studentId: String, request: CreateTaskRequest): Flow<Resource<Task>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.updateTask(taskId, studentId, request)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to update task"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun deleteTask(taskId: String, studentId: String): Flow<Resource<ApiResponse>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.deleteTask(taskId, studentId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to delete task"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun markTaskCompleted(taskId: String, studentId: String): Flow<Resource<Task>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.markTaskCompleted(taskId, studentId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to mark task as completed"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun updateTaskStatus(taskId: String, studentId: String, status: String): Flow<Resource<Task>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.updateTaskStatus(taskId, studentId, status)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to update task status"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getTaskStats(studentId: String): Flow<Resource<TaskStats>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getTaskStats(studentId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch task stats"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
    
    suspend fun getTasksDueSoon(studentId: String): Flow<Resource<List<Task>>> = flow {
        try {
            emit(Resource.Loading())
            val response = apiService.getTasksDueSoon(studentId)
            if (response.isSuccessful) {
                response.body()?.let {
                    emit(Resource.Success(it))
                } ?: emit(Resource.Error("Unknown error occurred"))
            } else {
                emit(Resource.Error(response.message() ?: "Failed to fetch tasks due soon"))
            }
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "An unexpected error occurred"))
        }
    }
}