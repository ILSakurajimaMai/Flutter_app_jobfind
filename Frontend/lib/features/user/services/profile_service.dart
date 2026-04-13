import 'package:dio/dio.dart';
import 'package:app_jobfind/core/api_client.dart';
import 'package:app_jobfind/features/user/models/profile_dto.dart';

/// Lớp Service chịu trách nhiệm giao tiếp trực tiếp với Backend API liên quan đến Profile.
class ProfileService {
  final ApiClient _apiClient = ApiClient(); // Khởi tạo ApiClient chứa sẵn Cấu hình Token

  /// Hàm gọi lệnh lấy thông tin hồ sơ của chính người dùng đang đăng nhập
  Future<ProfileDto> getMyProfile() async {
    try {
      // Gọi API GET: /api/profiles/me
      final response = await _apiClient.dio.get('/profiles/me');
      if (response.data['success'] == true) {
        // Parse dữ liệu JSON thành object ProfileDto
        return ProfileDto.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load profile');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Unknown error occurred');
      }
      throw Exception(e.message);
    }
  }

  /// Hàm gửi yêu cầu tạo mới hoặc cập nhật hồ sơ cá nhân
  Future<ProfileDto> updateProfile(ProfileDto dto) async {
    try {
      // Gọi API POST: /api/profiles đính kèm dữ liệu từ App
      final response = await _apiClient.dio.post(
        '/profiles',
        data: dto.toJson(),
      );

      if (response.data['success'] == true) {
         // Trả về Profile mới nhất sau khi cập nhật thành công
        return ProfileDto.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update profile');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Unknown error occurred');
      }
      throw Exception(e.message);
    }
  }
}
