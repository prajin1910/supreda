package com.smarteval.app.data.remote

import com.smarteval.app.data.model.*
import retrofit2.Response
import retrofit2.http.*

interface ApiService {
    
    // Auth endpoints
    @POST("auth/register")
    suspend fun register(@Body request: RegisterRequest): Response<ApiResponse>
    
    @POST("auth/verify-otp")
    suspend fun verifyOtp(@Body request: OtpVerificationRequest): Response<ApiResponse>
    
    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): Response<LoginResponse>
    
    @POST("auth/resend-otp")
    suspend fun resendOtp(@Body request: Map<String, String>): Response<ApiResponse>
    
    // Assessment endpoints
    @POST("assessments")
    suspend fun createAssessment(@Body request: CreateAssessmentRequest): Response<Assessment>
    
    @GET("assessments/student/{studentId}")
    suspend fun getStudentAssessments(@Path("studentId") studentId: String): Response<List<Assessment>>
    
    @GET("assessments/professor/{professorId}")
    suspend fun getProfessorAssessments(@Path("professorId") professorId: String): Response<List<Assessment>>
    
    @GET("assessments/{assessmentId}")
    suspend fun getAssessment(@Path("assessmentId") assessmentId: String): Response<Assessment>
    
    @POST("assessments/{assessmentId}/submit")
    suspend fun submitAssessment(
        @Path("assessmentId") assessmentId: String,
        @Body request: SubmitAssessmentRequest
    ): Response<ApiResponse>
    
    @GET("assessments/{assessmentId}/results")
    suspend fun getAssessmentResults(@Path("assessmentId") assessmentId: String): Response<List<AssessmentResult>>
    
    @GET("assessments/results/student/{studentId}")
    suspend fun getStudentResults(@Path("studentId") studentId: String): Response<List<AssessmentResult>>
    
    @GET("assessments/{assessmentId}/submission/{studentId}")
    suspend fun checkSubmission(
        @Path("assessmentId") assessmentId: String,
        @Path("studentId") studentId: String
    ): Response<Map<String, Any>>
    
    // Task endpoints
    @POST("tasks")
    suspend fun createTask(
        @Query("studentId") studentId: String,
        @Body request: CreateTaskRequest
    ): Response<Task>
    
    @GET("tasks/student/{studentId}")
    suspend fun getAllTasks(@Path("studentId") studentId: String): Response<List<Task>>
    
    @GET("tasks/student/{studentId}/status/{status}")
    suspend fun getTasksByStatus(
        @Path("studentId") studentId: String,
        @Path("status") status: String
    ): Response<List<Task>>
    
    @GET("tasks/{taskId}")
    suspend fun getTask(
        @Path("taskId") taskId: String,
        @Query("studentId") studentId: String
    ): Response<Task>
    
    @PUT("tasks/{taskId}")
    suspend fun updateTask(
        @Path("taskId") taskId: String,
        @Query("studentId") studentId: String,
        @Body request: CreateTaskRequest
    ): Response<Task>
    
    @DELETE("tasks/{taskId}")
    suspend fun deleteTask(
        @Path("taskId") taskId: String,
        @Query("studentId") studentId: String
    ): Response<ApiResponse>
    
    @PUT("tasks/{taskId}/complete")
    suspend fun markTaskCompleted(
        @Path("taskId") taskId: String,
        @Query("studentId") studentId: String
    ): Response<Task>
    
    @PUT("tasks/{taskId}/status")
    suspend fun updateTaskStatus(
        @Path("taskId") taskId: String,
        @Query("studentId") studentId: String,
        @Query("status") status: String
    ): Response<Task>
    
    @GET("tasks/student/{studentId}/stats")
    suspend fun getTaskStats(@Path("studentId") studentId: String): Response<TaskStats>
    
    @GET("tasks/student/{studentId}/overdue")
    suspend fun getOverdueTasks(@Path("studentId") studentId: String): Response<List<Task>>
    
    @GET("tasks/student/{studentId}/due-soon")
    suspend fun getTasksDueSoon(@Path("studentId") studentId: String): Response<List<Task>>
    
    // Chat endpoints
    @POST("chat/send")
    suspend fun sendMessage(@Body request: SendMessageRequest): Response<ApiResponse>
    
    @GET("chat/messages/{userId1}/{userId2}")
    suspend fun getMessages(
        @Path("userId1") userId1: String,
        @Path("userId2") userId2: String
    ): Response<List<ChatMessage>>
    
    @GET("chat/conversations/{userId}")
    suspend fun getConversations(@Path("userId") userId: String): Response<List<ChatConversation>>
    
    @GET("users/search")
    suspend fun searchUsers(@Query("q") query: String): Response<List<User>>
    
    // AI endpoints
    @POST("ai/roadmap")
    suspend fun generateRoadmap(@Body request: GenerateRoadmapRequest): Response<RoadmapResponse>
    
    @POST("ai/assessment")
    suspend fun generateAssessment(@Body request: GenerateAssessmentRequest): Response<AIAssessmentResponse>
    
    @POST("ai/explain")
    suspend fun explainAnswer(@Body request: ExplainAnswerRequest): Response<ExplanationResponse>
    
    @POST("ai/evaluate")
    suspend fun evaluateAnswers(@Body request: EvaluateAnswersRequest): Response<EvaluationResponse>
    
    // Alumni endpoints
    @GET("alumni/pending-requests/{professorId}")
    suspend fun getPendingAlumniRequests(@Path("professorId") professorId: String): Response<List<AlumniRequest>>
    
    @PUT("alumni/approve/{requestId}")
    suspend fun approveAlumniRequest(@Path("requestId") requestId: String): Response<ApiResponse>
    
    @PUT("alumni/reject/{requestId}")
    suspend fun rejectAlumniRequest(@Path("requestId") requestId: String): Response<ApiResponse>
}