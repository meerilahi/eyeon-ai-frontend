import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthController() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _user = _client.auth.currentUser;
    _client.auth.onAuthStateChange.listen((event) {
      _user = event.session?.user;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        _user = response.user;
      }
    } catch (e) {
      debugPrint('SignUp error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        _user = response.user;
      }
    } catch (e) {
      debugPrint('SignIn error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _client.auth.signOut();
      _user = null;
    } catch (e) {
      debugPrint('SignOut error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    debugPrint('AuthController: Clearing data');
    _user = null;
    _isLoading = false;
  }
}
