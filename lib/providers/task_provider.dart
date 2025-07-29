import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService;

  List<Task> _tasks = [];
  TaskStats? _stats;
  bool _isLoading = false;
  String? _error;

  TaskProvider(this._apiService);

  List<Task> get tasks => _tasks;
  TaskStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createTask(String studentId, CreateTaskRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final task = await _apiService.createTask(studentId, request);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllTasks(String studentId) async {
    _setLoading(true);
    _clearError();

    try {
      _tasks = await _apiService.getAllTasks(studentId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTasksByStatus(String studentId, String status) async {
    _setLoading(true);
    _clearError();

    try {
      _tasks = await _apiService.getTasksByStatus(studentId, status);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Task?> getTask(String taskId, String studentId) async {
    try {
      return await _apiService.getTask(taskId, studentId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  Future<void> updateTask(String taskId, String studentId, CreateTaskRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedTask = await _apiService.updateTask(taskId, studentId, request);
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTask(String taskId, String studentId) async {
    _setLoading(true);
    _clearError();

    try {
      await _apiService.deleteTask(taskId, studentId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> markTaskCompleted(String taskId, String studentId) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedTask = await _apiService.markTaskCompleted(taskId, studentId);
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTaskStatus(String taskId, String studentId, String status) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedTask = await _apiService.updateTaskStatus(taskId, studentId, status);
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTaskStats(String studentId) async {
    try {
      _stats = await _apiService.getTaskStats(studentId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<List<Task>> getOverdueTasks(String studentId) async {
    try {
      return await _apiService.getOverdueTasks(studentId);
    } catch (e) {
      _setError(e.toString());
      return [];
    }
  }

  Future<List<Task>> getTasksDueSoon(String studentId) async {
    try {
      return await _apiService.getTasksDueSoon(studentId);
    } catch (e) {
      _setError(e.toString());
      return [];
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