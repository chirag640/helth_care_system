import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/token_storage.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';
import '../services/profile_api_service.dart';

/// Profile state
class ProfileState {
  const ProfileState({
    this.patient,
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploadingPhoto = false,
    this.error,
    this.successMessage,
  });

  final PatientModel? patient;
  final bool isLoading;
  final bool isUpdating;
  final bool isUploadingPhoto;
  final String? error;
  final String? successMessage;

  ProfileState copyWith({
    PatientModel? patient,
    bool? isLoading,
    bool? isUpdating,
    bool? isUploadingPhoto,
    String? error,
    String? successMessage,
  }) {
    return ProfileState(
      patient: patient ?? this.patient,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      error: error,
      successMessage: successMessage,
    );
  }

  /// Check if profile is complete
  bool get isProfileComplete {
    if (patient == null) return false;
    return patient!.firstName != null &&
        patient!.lastName != null &&
        patient!.phoneNumber != null &&
        patient!.dateOfBirth != null &&
        patient!.gender != null;
  }

  /// Get display name
  String get displayName => patient?.fullName ?? 'User';

  /// Get profile photo URL
  String? get profilePhotoUrl => patient?.profilePhoto;
}

/// Profile controller with real API integration
class ProfileController extends StateNotifier<ProfileState> {
  ProfileController(this._service) : super(const ProfileState()) {
    loadProfile();
  }

  final ProfileApiService _service;

  /// Load current user's profile
  /// Sets patient to null if no profile exists (user needs to complete profile)
  Future<void> loadProfile() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final patient = await _service.getCurrentPatient();
      if (patient == null) {
        // No patient profile yet - this is normal for new users
        AppLogger.info(
            'No patient profile found - profile setup required',
            'ProfileController');
        state = const ProfileState(
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          patient: patient,
          isLoading: false,
        );
      }
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error('Load profile failed', e, null, 'ProfileController');
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e) {
      AppLogger.error('Load profile failed', e, null, 'ProfileController');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load profile',
      );
    }
  }

  /// Refresh profile
  Future<void> refreshProfile() async {
    await loadProfile();
  }

  /// Update profile
  Future<bool> updateProfile(UpdatePatientRequest request) async {
    if (state.patient == null) return false;

    state = state.copyWith(isUpdating: true, error: null);

    try {
      final updated = await _service.updatePatient(state.patient!.id, request);
      state = state.copyWith(
        patient: updated,
        isUpdating: false,
        successMessage: 'Profile updated successfully',
      );
      return true;
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error('Update profile failed', e, null, 'ProfileController');
      state = state.copyWith(
        isUpdating: false,
        error: errorMessage,
      );
      return false;
    }
  }

  /// Update basic info
  Future<bool> updateBasicInfo({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    Gender? gender,
  }) async {
    return updateProfile(UpdatePatientRequest(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      gender: gender,
    ));
  }

  /// Upload profile photo
  Future<bool> uploadProfilePhoto(File photo) async {
    if (state.patient == null) return false;

    state = state.copyWith(isUploadingPhoto: true, error: null);

    try {
      final photoUrl = await _service.uploadProfilePhoto(
        state.patient!.id,
        photo,
      );

      state = state.copyWith(
        patient: state.patient!.copyWith(profilePhoto: photoUrl),
        isUploadingPhoto: false,
        successMessage: 'Photo uploaded successfully',
      );
      return true;
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error('Upload photo failed', e, null, 'ProfileController');
      state = state.copyWith(
        isUploadingPhoto: false,
        error: errorMessage,
      );
      return false;
    }
  }

  /// Delete profile photo
  Future<bool> deleteProfilePhoto() async {
    if (state.patient == null) return false;

    state = state.copyWith(isUpdating: true, error: null);

    try {
      await _service.deleteProfilePhoto(state.patient!.id);

      state = state.copyWith(
        patient: state.patient!.copyWith(profilePhoto: null),
        isUpdating: false,
        successMessage: 'Photo removed successfully',
      );
      return true;
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error('Delete photo failed', e, null, 'ProfileController');
      state = state.copyWith(
        isUpdating: false,
        error: errorMessage,
      );
      return false;
    }
  }

  /// Update emergency contact
  Future<bool> updateEmergencyContact(EmergencyContact contact) async {
    if (state.patient == null) return false;

    state = state.copyWith(isUpdating: true, error: null);

    try {
      final updated = await _service.updateEmergencyContact(
        state.patient!.id,
        contact,
      );

      state = state.copyWith(
        patient: updated,
        isUpdating: false,
        successMessage: 'Emergency contact updated',
      );
      return true;
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error(
          'Update emergency contact failed', e, null, 'ProfileController');
      state = state.copyWith(
        isUpdating: false,
        error: errorMessage,
      );
      return false;
    }
  }

  /// Update address
  Future<bool> updateAddress(AddressInfo address) async {
    if (state.patient == null) return false;

    state = state.copyWith(isUpdating: true, error: null);

    try {
      final updated = await _service.updateAddress(state.patient!.id, address);

      state = state.copyWith(
        patient: updated,
        isUpdating: false,
        successMessage: 'Address updated',
      );
      return true;
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error('Update address failed', e, null, 'ProfileController');
      state = state.copyWith(
        isUpdating: false,
        error: errorMessage,
      );
      return false;
    }
  }

  /// Update health info
  Future<bool> updateHealthInfo({
    BloodGroup? bloodGroup,
    double? height,
    double? weight,
    List<String>? allergies,
    List<String>? chronicConditions,
  }) async {
    return updateProfile(UpdatePatientRequest(
      bloodGroup: bloodGroup,
      height: height,
      weight: weight,
      allergies: allergies,
      chronicConditions: chronicConditions,
    ));
  }

  /// Update insurance info
  Future<bool> updateInsurance({
    required String provider,
    required String policyNumber,
  }) async {
    if (state.patient == null) return false;

    state = state.copyWith(isUpdating: true, error: null);

    try {
      final updated = await _service.updateInsurance(
        state.patient!.id,
        provider: provider,
        policyNumber: policyNumber,
      );

      state = state.copyWith(
        patient: updated,
        isUpdating: false,
        successMessage: 'Insurance updated',
      );
      return true;
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error('Update insurance failed', e, null, 'ProfileController');
      state = state.copyWith(
        isUpdating: false,
        error: errorMessage,
      );
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await TokenStorage.instance.clearTokens();
    state = const ProfileState();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear success message
  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  String _getErrorMessage(DioException e) {
    if (e.response?.data != null && e.response!.data is Map) {
      final data = e.response!.data as Map;
      return data['message']?.toString() ?? 'An error occurred';
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

/// Profile controller provider
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final service = ref.watch(profileApiServiceProvider);
  return ProfileController(service);
});

/// Current patient provider (shortcut)
final currentPatientProvider = Provider<PatientModel?>((ref) {
  return ref.watch(profileControllerProvider).patient;
});

/// Profile loading state provider
final profileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(profileControllerProvider).isLoading;
});
