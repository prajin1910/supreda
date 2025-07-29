import 'package:flutter/material.dart';

import '../models/ai.dart';
import '../services/api_service.dart';

class AIProvider with ChangeNotifier {
  final ApiService _apiService;

  List<String> _roadmap = [];
  List<AIQuestion> _questions = [];
  EvaluationResponse? _evaluation;
  bool _isLoading = false;
  String? _error;

  AIProvider(this._apiService);

  List<String> get roadmap => _roadmap;
  List<AIQuestion> get questions => _questions;
  EvaluationResponse? get evaluation => _evaluation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> generateRoadmap(GenerateRoadmapRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.generateRoadmap(request);
      _roadmap = response.roadmap;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> generateAssessment(GenerateAssessmentRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.generateAssessment(request);
      _questions = response.questions;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> explainAnswer(ExplainAnswerRequest request) async {
    try {
      final response = await _apiService.explainAnswer(request);
      return response.explanation;
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  Future<void> evaluateAnswers(EvaluateAnswersRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      _evaluation = await _apiService.evaluateAnswers(request);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void clearRoadmap() {
    _roadmap.clear();
    notifyListeners();
  }

  void clearQuestions() {
    _questions.clear();
    notifyListeners();
  }

  void clearEvaluation() {
    _evaluation = null;
    notifyListeners();
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