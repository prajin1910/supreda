import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  final ApiService _apiService;

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._prefs, this._apiService) {
    _loadUserFromPrefs();
  }

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _loadUserFromPrefs() {
    final token = _prefs.getString('token');
    final userJson = _prefs.getString('user');
    
    if (token != null && userJson != null) {
      _token = token;
      _user = User.fromJson(json.decode(userJson));
    }
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiService.login(request);
      
      _user = response.user;
      _token = response.token;
      
      await _prefs.setString('token', response.token);
      await _prefs.setString('user', json.encode(response.user.toJson()));
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(String username, String email, String password, String role, {String? professorEmail}) async {
    _setLoading(true);
    _clearError();

    try {
      final request = RegisterRequest(
        username: username,
        email: email,
        password: password,
        role: role,
        professorEmail: professorEmail,
      );
      
      await _apiService.register(request);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    _setLoading(true);
    _clearError();

    try {
      final request = OtpVerificationRequest(email: email, otp: otp);
      await _apiService.verifyOtp(request);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resendOtp(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _apiService.resendOtp(email);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    
    await _prefs.remove('token');
    await _prefs.remove('user');
    
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