import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile/profile_dto.dart';
import '../services/profile_service.dart';

final profileServiceProvider = Provider((ref) => ProfileService());

class ProfileState {
  final bool isLoading;
  final String? error;
  final ProfileDto? profile;

  ProfileState({
    this.isLoading = false,
    this.error,
    this.profile,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    ProfileDto? profile,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // overwrite error if explicitly changing it, or just use null
      profile: profile ?? this.profile,
    );
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(() {
  return ProfileNotifier();
});

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return ProfileState();
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = ref.read(profileServiceProvider);
      final profile = await service.getMyProfile();
      state = state.copyWith(isLoading: false, profile: profile);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> updateProfile(ProfileDto dto) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = ref.read(profileServiceProvider);
      final updatedProfile = await service.updateProfile(dto);
      state = state.copyWith(isLoading: false, profile: updatedProfile);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }
}
