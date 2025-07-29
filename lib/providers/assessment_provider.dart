import 'package:flutter/material.dart';

import '../models/assessment.dart';
import '../services/api_service.dart';

class AssessmentProvider with ChangeNotifier {
  final ApiService _apiService;

  List<Assessment> _assessments = [];
  List<AssessmentResult> _results = [];
  bool _isLoading = false;
  String? _error;

  AssessmentProvider(this._apiService);

  List<Assessment> get assessments => _assessments;
  List<AssessmentResult> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createAssessment(CreateAssessmentRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final assessment = await _apiService.createAssessment(request);
      _assessments.add(assessment);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchStudentAssessments(String studentId) async {
    _setLoading(true);
    _clearError();

    try {
      _assessments = await _apiService.getStudentAssessments(studentId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchProfessorAssessments(String professorId) async {
    _setLoading(true);
    _clearError();

    try {
      _assessments = await _apiService.getProfessorAssessments(professorId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Assessment?> getAssessment(String assessmentId) async {
    try {
      return await _apiService.getAssessment(assessmentId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  Future<void> submitAssessment(String assessmentId, SubmitAssessmentRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      await _apiService.submitAssessment(assessmentId, request);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAssessmentResults(String assessmentId) async {
    _setLoading(true);
    _clearError();

    try {
      _results = await _apiService.getAssessmentResults(assessmentId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchStudentResults(String studentId) async {
    _setLoading(true);
    _clearError();

    try {
      _results = await _apiService.getStudentResults(studentId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> checkSubmission(String assessmentId, String studentId) async {
    try {
      return await _apiService.checkSubmission(assessmentId, studentId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}