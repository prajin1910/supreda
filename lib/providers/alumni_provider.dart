import 'package:flutter/material.dart';

import '../models/alumni.dart';
import '../services/api_service.dart';

class AlumniProvider with ChangeNotifier {
  final ApiService _apiService;

  List<AlumniRequest> _requests = [];
  bool _isLoading = false;
  String? _error;

  AlumniProvider(this._apiService);

  List<AlumniRequest> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPendingRequests(String professorId) async {
    _setLoading(true);
    _clearError();

    try {
      _requests = await _apiService.getPendingAlumniRequests(professorId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> approveRequest(String requestId) async {
    _setLoading(true);
    _clearError();

    try {
      await _apiService.approveAlumniRequest(requestId);
      _requests.removeWhere((request) => request.id == requestId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> rejectRequest(String requestId) async {
    _setLoading(true);
    _clearError();

    try {
      await _apiService.rejectAlumniRequest(requestId);
      _requests.removeWhere((request) => request.id == requestId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
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