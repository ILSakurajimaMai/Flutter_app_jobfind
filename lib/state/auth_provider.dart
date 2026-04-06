import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth/login_dto.dart';
import '../models/auth/register_dto.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Trigger initial auth check
    _checkInitialAuth();
    return AuthState();
  }

  Future<void> _checkInitialAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token != null && token.isNotEmpty) {
      // In real scenario, validate token or fetch profile
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<bool> login(LoginDto dto) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authService = ref.read(authServiceProvider);
      final userResponse = await authService.login(dto);
      
      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', userResponse.accessToken);
      await prefs.setString('refreshToken', userResponse.refreshToken);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: userResponse,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> register(RegisterDto dto) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.register(dto);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    state = AuthState(); // Reset
  }
}
