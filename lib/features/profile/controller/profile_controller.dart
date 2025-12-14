import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Profile data model
class ProfileData {
  final String fullName;
  final String phoneNumber;
  final String userId;
  final String gender;
  final String location;
  final String? avatarPath;

  ProfileData({
    required this.fullName,
    required this.phoneNumber,
    required this.userId,
    required this.gender,
    required this.location,
    this.avatarPath,
  });
}

/// Profile state
class ProfileState {
  final ProfileData profile;
  final bool isLoading;
  final String? error;

  ProfileState({
    required this.profile,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    ProfileData? profile,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Profile controller
class ProfileController extends StateNotifier<ProfileState> {
  ProfileController()
      : super(ProfileState(
          profile: ProfileData(
            fullName: 'John D. Wick',
            phoneNumber: '+91 XXXXX XXXXX',
            userId: '354545465667345',
            gender: 'Male',
            location: 'New York, USA',
            avatarPath: 'assets/images/profile_avatar.png',
          ),
        ));

  /// Update profile
  Future<void> updateProfile(ProfileData newProfile) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(profile: newProfile, isLoading: false);
  }

  /// Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    // Navigate to sign in handled by UI
  }
}

/// Profile controller provider
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController();
});
