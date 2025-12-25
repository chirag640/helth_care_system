import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';
import '../services/prescription_api_service.dart';

/// Records state
class RecordsState {
  const RecordsState({
    this.prescriptions = const [],
    this.activePrescriptions = const [],
    this.pastPrescriptions = const [],
    this.needsRefillPrescriptions = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.searchQuery,
  });

  final List<PrescriptionModel> prescriptions;
  final List<PrescriptionModel> activePrescriptions;
  final List<PrescriptionModel> pastPrescriptions;
  final List<PrescriptionModel> needsRefillPrescriptions;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final String? searchQuery;

  RecordsState copyWith({
    List<PrescriptionModel>? prescriptions,
    List<PrescriptionModel>? activePrescriptions,
    List<PrescriptionModel>? pastPrescriptions,
    List<PrescriptionModel>? needsRefillPrescriptions,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
  }) {
    return RecordsState(
      prescriptions: prescriptions ?? this.prescriptions,
      activePrescriptions: activePrescriptions ?? this.activePrescriptions,
      pastPrescriptions: pastPrescriptions ?? this.pastPrescriptions,
      needsRefillPrescriptions:
          needsRefillPrescriptions ?? this.needsRefillPrescriptions,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Get total prescription count
  int get totalCount => prescriptions.length;

  /// Check if there are active prescriptions
  bool get hasActivePrescriptions => activePrescriptions.isNotEmpty;

  /// Check if there are prescriptions needing refill
  bool get hasRefillNeeded => needsRefillPrescriptions.isNotEmpty;
}

/// Records controller with real API integration
class RecordsController extends StateNotifier<RecordsState> {
  RecordsController(this._service) : super(const RecordsState()) {
    loadPrescriptions();
  }

  final PrescriptionApiService _service;

  /// Load prescriptions
  Future<void> loadPrescriptions() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load all prescriptions
      final prescriptions = await _service.getMyPrescriptions(limit: 50);

      // Categorize prescriptions
      final active = <PrescriptionModel>[];
      final past = <PrescriptionModel>[];
      final needsRefill = <PrescriptionModel>[];

      for (final prescription in prescriptions) {
        if (prescription.status.isActive) {
          active.add(prescription);
          if (prescription.needsRefill) {
            needsRefill.add(prescription);
          }
        } else if (prescription.status.isCompleted ||
            prescription.status == PrescriptionStatus.cancelled ||
            prescription.status == PrescriptionStatus.stopped) {
          past.add(prescription);
        }
      }

      state = state.copyWith(
        prescriptions: prescriptions,
        activePrescriptions: active,
        pastPrescriptions: past,
        needsRefillPrescriptions: needsRefill,
        isLoading: false,
        currentPage: 1,
        hasMore: prescriptions.length >= 50,
      );
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error(
          'Load prescriptions failed', e, null, 'RecordsController');
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e) {
      AppLogger.error(
          'Load prescriptions failed', e, null, 'RecordsController');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load prescriptions',
      );
    }
  }

  /// Load more prescriptions (pagination)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final newPrescriptions = await _service.getMyPrescriptions(
        page: nextPage,
        limit: 50,
      );

      if (newPrescriptions.isEmpty) {
        state = state.copyWith(
          isLoadingMore: false,
          hasMore: false,
        );
        return;
      }

      final allPrescriptions = [...state.prescriptions, ...newPrescriptions];

      // Re-categorize all prescriptions
      final active = <PrescriptionModel>[];
      final past = <PrescriptionModel>[];
      final needsRefill = <PrescriptionModel>[];

      for (final prescription in allPrescriptions) {
        if (prescription.status.isActive) {
          active.add(prescription);
          if (prescription.needsRefill) {
            needsRefill.add(prescription);
          }
        } else if (prescription.status.isCompleted ||
            prescription.status == PrescriptionStatus.cancelled ||
            prescription.status == PrescriptionStatus.stopped) {
          past.add(prescription);
        }
      }

      state = state.copyWith(
        prescriptions: allPrescriptions,
        activePrescriptions: active,
        pastPrescriptions: past,
        needsRefillPrescriptions: needsRefill,
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: newPrescriptions.length >= 50,
      );
    } on DioException catch (e) {
      AppLogger.error(
          'Load more prescriptions failed', e, null, 'RecordsController');
      state = state.copyWith(isLoadingMore: false);
    } catch (e) {
      AppLogger.error(
          'Load more prescriptions failed', e, null, 'RecordsController');
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Refresh prescriptions
  Future<void> refreshPrescriptions() async {
    state = state.copyWith(currentPage: 1, hasMore: true);
    await loadPrescriptions();
  }

  /// Search prescriptions
  Future<void> searchPrescriptions(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchQuery: null);
      await loadPrescriptions();
      return;
    }

    state = state.copyWith(isLoading: true, error: null, searchQuery: query);

    try {
      final results = await _service.searchPrescriptions(query);

      // Categorize search results
      final active = <PrescriptionModel>[];
      final past = <PrescriptionModel>[];

      for (final prescription in results) {
        if (prescription.status.isActive) {
          active.add(prescription);
        } else {
          past.add(prescription);
        }
      }

      state = state.copyWith(
        prescriptions: results,
        activePrescriptions: active,
        pastPrescriptions: past,
        isLoading: false,
        hasMore: false, // Search doesn't paginate
      );
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error(
          'Search prescriptions failed', e, null, 'RecordsController');
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e) {
      AppLogger.error(
          'Search prescriptions failed', e, null, 'RecordsController');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to search prescriptions',
      );
    }
  }

  /// Clear search and reload
  Future<void> clearSearch() async {
    state = state.copyWith(searchQuery: null);
    await loadPrescriptions();
  }

  /// Request a refill
  Future<bool> requestRefill(String prescriptionId) async {
    try {
      final updatedPrescription = await _service.requestRefill(prescriptionId);

      // Update the prescription in state
      final updatedPrescriptions = state.prescriptions.map((p) {
        if (p.id == prescriptionId) {
          return updatedPrescription;
        }
        return p;
      }).toList();

      // Re-categorize
      final active = <PrescriptionModel>[];
      final past = <PrescriptionModel>[];
      final needsRefill = <PrescriptionModel>[];

      for (final prescription in updatedPrescriptions) {
        if (prescription.status.isActive) {
          active.add(prescription);
          if (prescription.needsRefill) {
            needsRefill.add(prescription);
          }
        } else {
          past.add(prescription);
        }
      }

      state = state.copyWith(
        prescriptions: updatedPrescriptions,
        activePrescriptions: active,
        pastPrescriptions: past,
        needsRefillPrescriptions: needsRefill,
      );

      return true;
    } on DioException catch (e) {
      AppLogger.error('Request refill failed', e, null, 'RecordsController');
      return false;
    } catch (e) {
      AppLogger.error('Request refill failed', e, null, 'RecordsController');
      return false;
    }
  }

  /// Get prescription by ID
  Future<PrescriptionModel?> getPrescription(String id) async {
    try {
      return await _service.getPrescriptionById(id);
    } on DioException catch (e) {
      AppLogger.error('Get prescription failed', e, null, 'RecordsController');
      return null;
    } catch (e) {
      AppLogger.error('Get prescription failed', e, null, 'RecordsController');
      return null;
    }
  }

  String _getErrorMessage(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      return data['message'] as String? ?? 'An error occurred';
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

/// Provider for prescription API service
final prescriptionServiceProvider = Provider<PrescriptionApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PrescriptionApiService(apiClient);
});

/// Provider for records controller
final recordsControllerProvider =
    StateNotifierProvider<RecordsController, RecordsState>((ref) {
  final service = ref.watch(prescriptionServiceProvider);
  return RecordsController(service);
});
