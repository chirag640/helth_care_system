import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/appointment_card.dart';

class AppointmentState {
  final List<AppointmentData> upcomingAppointments;
  final List<AppointmentData> previousAppointments;
  final bool isLoading;

  AppointmentState({
    required this.upcomingAppointments,
    required this.previousAppointments,
    this.isLoading = false,
  });

  AppointmentState copyWith({
    List<AppointmentData>? upcomingAppointments,
    List<AppointmentData>? previousAppointments,
    bool? isLoading,
  }) {
    return AppointmentState(
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      previousAppointments: previousAppointments ?? this.previousAppointments,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AppointmentController extends StateNotifier<AppointmentState> {
  AppointmentController()
      : super(
          AppointmentState(
            upcomingAppointments: _getUpcomingAppointments(),
            previousAppointments: _getPreviousAppointments(),
          ),
        );

  static List<AppointmentData> _getUpcomingAppointments() {
    return [
      const AppointmentData(
        doctorName: 'Dr. Spike Brown',
        specialty: 'Certified Cardiologist',
        timeRange: '10:25 - 11:35 AM',
        day: 'Monday',
        date: '26 July',
        appointmentType: 'General Health Checkup',
        location:
            'Mundra Relocation Road, behind Ashapura College, in Bhuj, Kutch, 370001',
        isVerified: true,
        isUpcoming: true,
      ),
    ];
  }

  static List<AppointmentData> _getPreviousAppointments() {
    return [
      const AppointmentData(
        doctorName: 'Dr. Spike Brown',
        specialty: 'Certified Cardiologist',
        timeRange: '10:25 - 11:35 AM',
        day: 'Monday',
        date: '26 July',
        appointmentType: 'General Health Checkup',
        location:
            'Mundra Relocation Road, behind Ashapura College, in Bhuj, Kutch, 370001',
        isVerified: true,
        isUpcoming: false,
      ),
      const AppointmentData(
        doctorName: 'Dr. Spike Brown',
        specialty: 'Certified Cardiologist',
        timeRange: '10:25 - 11:35 AM',
        day: 'Monday',
        date: '26 July',
        appointmentType: 'General Health Checkup',
        location:
            'Mundra Relocation Road, behind Ashapura College, in Bhuj, Kutch, 370001',
        isVerified: true,
        isUpcoming: false,
      ),
    ];
  }

  Future<void> refreshAppointments() async {
    state = state.copyWith(isLoading: true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      upcomingAppointments: _getUpcomingAppointments(),
      previousAppointments: _getPreviousAppointments(),
      isLoading: false,
    );
  }
}

final appointmentControllerProvider =
    StateNotifierProvider<AppointmentController, AppointmentState>((ref) {
  return AppointmentController();
});
