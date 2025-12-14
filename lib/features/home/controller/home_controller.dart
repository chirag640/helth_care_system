import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/prescription_card.dart';

class HomeState {
  final List<PrescriptionData> prescriptions;
  final int currentNavIndex;
  final bool isLoading;

  HomeState({
    required this.prescriptions,
    required this.currentNavIndex,
    this.isLoading = false,
  });

  HomeState copyWith({
    List<PrescriptionData>? prescriptions,
    int? currentNavIndex,
    bool? isLoading,
  }) {
    return HomeState(
      prescriptions: prescriptions ?? this.prescriptions,
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  HomeController()
      : super(
          HomeState(
            prescriptions: _getDummyPrescriptions(),
            currentNavIndex: 0,
          ),
        );

  static List<PrescriptionData> _getDummyPrescriptions() {
    return [
      PrescriptionData(
        date: '27',
        month: 'FEB',
        diagnosis: 'Chronic Pain Disorder',
        doctorName: 'Dr. Malina Wazir',
        doctorQualification: 'Nurse',
        location: 'Hospital Civil, Rawalpindi',
        prescriptionId: 'ZP001',
        prescriptionCount: 2,
      ),
      PrescriptionData(
        date: '24',
        month: 'FEB',
        diagnosis: 'Migraine Headache',
        doctorName: 'Dr. Sarah Ahmed',
        doctorQualification: 'Neurologist',
        location: 'Mayo Hospital, Lahore',
        prescriptionId: 'ZP002',
        prescriptionCount: 1,
      ),
      PrescriptionData(
        date: '20',
        month: 'FEB',
        diagnosis: 'Seasonal Allergies',
        doctorName: 'Dr. Hassan Ali',
        doctorQualification: 'General Physician',
        location: 'Shifa International, Islamabad',
        prescriptionId: 'ZP003',
        prescriptionCount: 3,
      ),
      PrescriptionData(
        date: '15',
        month: 'FEB',
        diagnosis: 'Lower Back Pain',
        doctorName: 'Dr. Ayesha Khan',
        doctorQualification: 'Orthopedic',
        location: 'Aga Khan Hospital, Karachi',
        prescriptionId: 'ZP004',
        prescriptionCount: 2,
      ),
    ];
  }

  void setNavIndex(int index) {
    state = state.copyWith(currentNavIndex: index);
  }

  Future<void> refreshPrescriptions() async {
    state = state.copyWith(isLoading: true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      prescriptions: _getDummyPrescriptions(),
      isLoading: false,
    );
  }
}

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController();
});
