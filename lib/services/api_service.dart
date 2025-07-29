import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/assessment.dart';
import '../models/task.dart';
import '../models/chat.dart';
import '../models/ai.dart';
import '../models/alumni.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        print('API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  // Auth APIs
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post('/auth/login', data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }

  Future<ApiResponse> register(RegisterRequest request) async {
    final response = await _dio.post('/auth/register', data: request.toJson());
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> verifyOtp(OtpVerificationRequest request) async {
    final response = await _dio.post('/auth/verify-otp', data: request.toJson());
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> resendOtp(String email) async {
    final response = await _dio.post('/auth/resend-otp', data: {'email': email});
    return ApiResponse.fromJson(response.data);
  }

  // Assessment APIs
  Future<Assessment> createAssessment(CreateAssessmentRequest request) async {
    final response = await _dio.post('/assessments', data: request.toJson());
    return Assessment.fromJson(response.data);
  }

  Future<List<Assessment>> getStudentAssessments(String studentId) async {
    final response = await _dio.get('/assessments/student/$studentId');
    return (response.data as List).map((json) => Assessment.fromJson(json)).toList();
  }

  Future<List<Assessment>> getProfessorAssessments(String professorId) async {
    final response = await _dio.get('/assessments/professor/$professorId');
    return (response.data as List).map((json) => Assessment.fromJson(json)).toList();
  }

  Future<Assessment> getAssessment(String assessmentId) async {
    final response = await _dio.get('/assessments/$assessmentId');
    return Assessment.fromJson(response.data);
  }

  Future<ApiResponse> submitAssessment(String assessmentId, SubmitAssessmentRequest request) async {
    final response = await _dio.post('/assessments/$assessmentId/submit', data: request.toJson());
    return ApiResponse.fromJson(response.data);
  }

  Future<List<AssessmentResult>> getAssessmentResults(String assessmentId) async {
    final response = await _dio.get('/assessments/$assessmentId/results');
    return (response.data as List).map((json) => AssessmentResult.fromJson(json)).toList();
  }

  Future<List<AssessmentResult>> getStudentResults(String studentId) async {
    final response = await _dio.get('/assessments/results/student/$studentId');
    return (response.data as List).map((json) => AssessmentResult.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> checkSubmission(String assessmentId, String studentId) async {
    final response = await _dio.get('/assessments/$assessmentId/submission/$studentId');
    return response.data;
  }

  // Task APIs
  Future<Task> createTask(String studentId, CreateTaskRequest request) async {
    final response = await _dio.post('/tasks?studentId=$studentId', data: request.toJson());
    return Task.fromJson(response.data);
  }

  Future<List<Task>> getAllTasks(String studentId) async {
    final response = await _dio.get('/tasks/student/$studentId');
    return (response.data as List).map((json) => Task.fromJson(json)).toList();
  }

  Future<List<Task>> getTasksByStatus(String studentId, String status) async {
    final response = await _dio.get('/tasks/student/$studentId/status/$status');
    return (response.data as List).map((json) => Task.fromJson(json)).toList();
  }

  Future<Task> getTask(String taskId, String studentId) async {
    final response = await _dio.get('/tasks/$taskId?studentId=$studentId');
    return Task.fromJson(response.data);
  }

  Future<Task> updateTask(String taskId, String studentId, CreateTaskRequest request) async {
    final response = await _dio.put('/tasks/$taskId?studentId=$studentId', data: request.toJson());
    return Task.fromJson(response.data);
  }

  Future<ApiResponse> deleteTask(String taskId, String studentId) async {
    final response = await _dio.delete('/tasks/$taskId?studentId=$studentId');
    return ApiResponse.fromJson(response.data);
  }

  Future<Task> markTaskCompleted(String taskId, String studentId) async {
    final response = await _dio.put('/tasks/$taskId/complete?studentId=$studentId');
    return Task.fromJson(response.data);
  }

  Future<Task> updateTaskStatus(String taskId, String studentId, String status) async {
    final response = await _dio.put('/tasks/$taskId/status?studentId=$studentId&status=$status');
    return Task.fromJson(response.data);
  }

  Future<TaskStats> getTaskStats(String studentId) async {
    final response = await _dio.get('/tasks/student/$studentId/stats');
    return TaskStats.fromJson(response.data);
  }

  Future<List<Task>> getOverdueTasks(String studentId) async {
    final response = await _dio.get('/tasks/student/$studentId/overdue');
    return (response.data as List).map((json) => Task.fromJson(json)).toList();
  }

  Future<List<Task>> getTasksDueSoon(String studentId) async {
    final response = await _dio.get('/tasks/student/$studentId/due-soon');
    return (response.data as List).map((json) => Task.fromJson(json)).toList();
  }

  // Chat APIs
  Future<ApiResponse> sendMessage(SendMessageRequest request) async {
    final response = await _dio.post('/chat/send', data: request.toJson());
    return ApiResponse.fromJson(response.data);
  }

  Future<List<ChatMessage>> getMessages(String userId1, String userId2) async {
    final response = await _dio.get('/chat/messages/$userId1/$userId2');
    return (response.data as List).map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<List<ChatConversation>> getConversations(String userId) async {
    final response = await _dio.get('/chat/conversations/$userId');
    return (response.data as List).map((json) => ChatConversation.fromJson(json)).toList();
  }

  Future<List<User>> searchUsers(String query) async {
    final response = await _dio.get('/users/search?q=$query');
    return (response.data as List).map((json) => User.fromJson(json)).toList();
  }

  // AI APIs
  Future<RoadmapResponse> generateRoadmap(GenerateRoadmapRequest request) async {
    final response = await _dio.post('/ai/roadmap', data: request.toJson());
    return RoadmapResponse.fromJson(response.data);
  }

  Future<AIAssessmentResponse> generateAssessment(GenerateAssessmentRequest request) async {
    final response = await _dio.post('/ai/assessment', data: request.toJson());
    return AIAssessmentResponse.fromJson(response.data);
  }

  Future<ExplanationResponse> explainAnswer(ExplainAnswerRequest request) async {
    final response = await _dio.post('/ai/explain', data: request.toJson());
    return ExplanationResponse.fromJson(response.data);
  }

  Future<EvaluationResponse> evaluateAnswers(EvaluateAnswersRequest request) async {
    final response = await _dio.post('/ai/evaluate', data: request.toJson());
    return EvaluationResponse.fromJson(response.data);
  }

  // Alumni APIs
  Future<List<AlumniRequest>> getPendingAlumniRequests(String professorId) async {
    final response = await _dio.get('/alumni/pending-requests/$professorId');
    return (response.data as List).map((json) => AlumniRequest.fromJson(json)).toList();
  }

  Future<ApiResponse> approveAlumniRequest(String requestId) async {
    final response = await _dio.put('/alumni/approve/$requestId');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> rejectAlumniRequest(String requestId) async {
    final response = await _dio.put('/alumni/reject/$requestId');
    return ApiResponse.fromJson(response.data);
  }
}