import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

/// Global authentication and user session manager.
class AuthManager extends ChangeNotifier {
  AuthManager._();
  static final AuthManager instance = AuthManager._();

  UserAccount? _currentUser;
  String? _sessionToken;
  bool _initialized = false;

  UserAccount? get currentUser => _currentUser;
  String? get sessionToken => _sessionToken;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _initialized;

  static const String _prefUserKey = 'mindmap_user_data';
  static const String _prefTokenKey = 'mindmap_auth_token';

  /// Restores session on app startup.
  Future<void> init() async {
    if (_initialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _sessionToken = prefs.getString(_prefTokenKey);
      final rawUser = prefs.getString(_prefUserKey);
      if (rawUser != null && rawUser.isNotEmpty) {
        final map = jsonDecode(rawUser) as Map<String, dynamic>;
        _currentUser = UserAccount(
          id: map['id'] as int?,
          name: map['name'] as String? ?? 'User',
          email: map['email'] as String? ?? '',
          passwordHash: '',
          salt: '',
          createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
          lastLoginAt: DateTime.tryParse(map['lastLoginAt'] as String? ?? ''),
        );
      }
    } catch (_) {
      // Corrupt or outdated session cache: ignore and clear
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  /// Sign In with email & password.
  Future<AuthResponse> login(String email, String password) async {
    final response = await client.user.login(email, password);
    if (response.success && response.user != null) {
      _currentUser = response.user;
      _sessionToken = response.token;
      await _persistSession(response.user!, response.token);
      notifyListeners();
    }
    return response;
  }

  /// Sign Up with name, email & password.
  Future<AuthResponse> register(String name, String email, String password) async {
    final response = await client.user.register(name, email, password);
    if (response.success && response.user != null) {
      _currentUser = response.user;
      _sessionToken = response.token;
      await _persistSession(response.user!, response.token);
      notifyListeners();
    }
    return response;
  }

  /// Log out and clear saved session.
  Future<void> logout() async {
    _currentUser = null;
    _sessionToken = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefUserKey);
      await prefs.remove(_prefTokenKey);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> _persistSession(UserAccount user, String? token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString(_prefTokenKey, token);
      }
      final map = {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'createdAt': user.createdAt.toIso8601String(),
        'lastLoginAt': user.lastLoginAt?.toIso8601String(),
      };
      await prefs.setString(_prefUserKey, jsonEncode(map));
    } catch (_) {}
  }
}
