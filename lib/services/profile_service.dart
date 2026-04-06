import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/profile/profile_dto.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<ProfileDto> getMyProfile() async {
    try {
      final response = await _apiClient.dio.get('/profiles/me');
      if (response.data['success'] == true) {
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

  Future<ProfileDto> updateProfile(ProfileDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/profiles',
        data: dto.toJson(),
      );

      if (response.data['success'] == true) {
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
