import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_jobfind/features/auth/models/login_dto.dart';
import 'package:app_jobfind/features/auth/models/register_dto.dart';
import 'package:app_jobfind/features/auth/services/auth_service.dart';
import 'auth_state.dart';

/// Provider cung cấp đối tượng AuthService để gửi API đi bất kì đâu (tương tự ProfileService)
final authServiceProvider = Provider((ref) => AuthService());

/// AuthProvider chịu trách nhiệm nắm giữ khóa Token và đẩy trạng thái đăng nhập xuống cho các Widget UI (như SplashScreen, LoginScreen)
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Ngay lúc khởi tạo app (tại hàm build), thì lập tức rà soát xem cục Local Preferences có token dư không
    _checkInitialAuth();
    return AuthState(); // Khởi tạo state gốc khởi điểm
  }

  /// Hàm kiểm tra Token nội bộ tự chạy ngầm
  /// Nếu người dùng đã đăng nhập từ hôm qua, hàm này móc Token cũ ra, tự Set Auth = true để lướt qua màn hình đăng nhập
  Future<void> _checkInitialAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token != null && token.isNotEmpty) {
      // Trong kịch bản thực tế phức tạp hơn: cần ném Token này lên Server hỏi xem còn hạn (expire) không
      state = state.copyWith(isAuthenticated: true);
    }
  }

  /// Hàm Đăng Nhập
  Future<bool> login(LoginDto dto) async {
    // Sửa trạng thái thành "Đang Load"
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authService = ref.read(authServiceProvider);
      // Chờ dịch vụ hỏi Backend xem khớp Pass không
      final userResponse = await authService.login(dto);

      // Lưu 2 loại Token do Server nhả xuống vào ổ cứng máy (SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', userResponse.accessToken);
      await prefs.setString('refreshToken', userResponse.refreshToken);

      // Hoàn tất, tắt load, bật cờ Authenticated = True và gắn Profile ban đầu vào State
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: userResponse,
      );
      return true; // Trả tín hiệu về cho Nút nhấn UI
    } catch (e) {
      // Báo lỗi bằng chữ ra cho bắt SnackBar (nhớ cắt bỏ chữ "Exception:" thừa thãi)
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false; // Phun lỗi lên 
    }
  }

  /// Hàm Đăng Ký 
  Future<bool> register(RegisterDto dto) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authService = ref.read(authServiceProvider);
      // Đợi việc đăng ký được xác nhận (API Register ném 200)
      await authService.register(dto);
      
      // Xong thì tắt Loading, State vẫn vậy (chưa authenticated vì cần bắt người dùng tự gõ pass để đăng nhập tay lại một lần cho chắc)
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

  /// Hàm Đăng Xuất (Log out)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Quét sạch sẽ bằng cách phi tang dữ liệu cục bộ Token
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    
    // Gán nguyên cả cụm State bằng Default Object trống mới toanh (reset tất cả)
    state = AuthState(); 
  }
}
