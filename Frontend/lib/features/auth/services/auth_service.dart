// Dịch vụ (Service) xử lý các API liên quan đến xác thực (Auth) như Đăng nhập, Đăng ký.
import 'package:dio/dio.dart';
import 'package:app_jobfind/core/api_client.dart';
import 'package:app_jobfind/features/auth/models/login_dto.dart';
import 'package:app_jobfind/features/auth/models/register_dto.dart';
import 'package:app_jobfind/features/auth/models/auth_response_dto.dart';

/// Lớp [AuthService] quản lý các API liên quan đến tài khoản người dùng.
class AuthService {
  /// Đối tượng gọi API có cấu hình sẵn tự động gắn JWT Token.
  final ApiClient _apiClient = ApiClient();

  /// Đăng nhập hệ thống qua `/auth/login`.
  /// - Gửi Email, Password từ [LoginScreen]
  /// - Thành công: Trả về [AuthResponseDto] (chứa Token, thông tin user).
  /// - Thất bại: Ném Exception kèm câu lỗi từ Backend (hoặc Dio).
  Future<AuthResponseDto> login(LoginDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: dto.toJson(),
      );

      if (response.data['success'] == true) {
        return AuthResponseDto.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Unknown error occurred',
        );
      }
      throw Exception(e.message);
    }
  }

  /// Đăng ký tài khoản mới qua `/auth/register`.
  /// - Gửi thông tin (Email, Pass, Role...) từ [RegisterScreen]
  /// - Thành công: Trả về Map chứa thông báo hoặc Data khởi tạo.
  /// - Thất bại: Ném Exception kèm thông báo chi tiết (trùng email, pass yếu...).
  Future<Map<String, dynamic>> register(RegisterDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: dto.toJson(),
      );

      if (response.data['success'] == true) {
        return response.data['data']; 
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Unknown error occurred',
        );
      }
      throw Exception(e.message);
    }
  }
}
