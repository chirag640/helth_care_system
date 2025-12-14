import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/prescription_card.dart';

class RecordsState {
  final List<PrescriptionData> latestPrescriptions;
  final List<PrescriptionData> pastPrescriptions;
  final bool isLoading;

  RecordsState({
    required this.latestPrescriptions,
    required this.pastPrescriptions,
    this.isLoading = false,
  });

  RecordsState copyWith({
    List<PrescriptionData>? latestPrescriptions,
    List<PrescriptionData>? pastPrescriptions,
    bool? isLoading,
  }) {
    return RecordsState(
      latestPrescriptions: latestPrescriptions ?? this.latestPrescriptions,
      pastPrescriptions: pastPrescriptions ?? this.pastPrescriptions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RecordsController extends StateNotifier<RecordsState> {
  RecordsController()
      : super(
          RecordsState(
            latestPrescriptions: _getLatestPrescriptions(),
            pastPrescriptions: _getPastPrescriptions(),
          ),
        );

  static List<PrescriptionData> _getLatestPrescriptions() {
    return [
      PrescriptionData(
        date: '27',
        month: 'FEB',
        diagnosis: 'Dengue',
        doctorName: 'Dr. Mahek Mahta',
        doctorQualification: 'M.B.B.S',
        location: 'Mundra Relocation Road, behind',
        prescriptionId: '#55645',
        prescriptionCount: 1,
      ),
    ];
  }

  static List<PrescriptionData> _getPastPrescriptions() {
    return [
      PrescriptionData(
        date: '27',
        month: 'FEB',
        diagnosis: 'Dengue',
        doctorName: 'Dr. Mahek Mahta',
        doctorQualification: 'M.B.B.S',
        location: 'Mundra Relocation Road, behind',
        prescriptionId: '#55645',
        prescriptionCount: 1,
      ),
      PrescriptionData(
        date: '27',
        month: 'FEB',
        diagnosis: 'Dengue',
        doctorName: 'Dr. Mahek Mahta',
        doctorQualification: 'M.B.B.S',
        location: 'Mundra Relocation Road, behind',
        prescriptionId: '#55645',
        prescriptionCount: 1,
      ),
      PrescriptionData(
        date: '27',
        month: 'FEB',
        diagnosis: 'Dengue',
        doctorName: 'Dr. Mahek Mahta',
        doctorQualification: 'M.B.B.S',
        location: 'Mundra Relocation Road, behind',
        prescriptionId: '#55645',
        prescriptionCount: 1,
      ),
    ];
  }

  Future<void> refreshRecords() async {
    state = state.copyWith(isLoading: true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      latestPrescriptions: _getLatestPrescriptions(),
      pastPrescriptions: _getPastPrescriptions(),
      isLoading: false,
    );
  }
}

final recordsControllerProvider =
    StateNotifierProvider<RecordsController, RecordsState>((ref) {
  return RecordsController();
});
