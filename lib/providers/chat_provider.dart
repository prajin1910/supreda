import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  final ApiService _apiService;

  List<ChatMessage> _messages = [];
  List<ChatConversation> _conversations = [];
  List<User> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  ChatProvider(this._apiService);

  List<ChatMessage> get messages => _messages;
  List<ChatConversation> get conversations => _conversations;
  List<User> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> sendMessage(SendMessageRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      await _apiService.sendMessage(request);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchMessages(String userId1, String userId2) async {
    _setLoading(true);
    _clearError();

    try {
      _messages = await _apiService.getMessages(userId1, userId2);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchConversations(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _conversations = await _apiService.getConversations(userId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchUsers(String query) async {
    _setLoading(true);
    _clearError();

    try {
      _searchResults = await _apiService.searchUsers(query);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void clearSearchResults() {
    _searchResults.clear();
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