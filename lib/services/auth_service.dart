import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/auth/login_dto.dart';
import '../models/auth/register_dto.dart';
import '../models/auth/auth_response_dto.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<AuthResponseDto> login(LoginDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: dto.toJson(),
      );

      // Theo backend.NET: Result<AuthResponseDto>
      if (response.data['success'] == true) {
        return AuthResponseDto.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Unknown error occurred');
      }
      throw Exception(e.message);
    }
  }

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
        throw Exception(e.response?.data['message'] ?? 'Unknown error occurred');
      }
      throw Exception(e.message);
    }
  }
}
