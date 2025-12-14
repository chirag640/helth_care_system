import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen state
class HomeState {
  const HomeState({
    this.isLoading = false,
    this.error,
    this.counter = 0,
  });

  final bool isLoading;
  final String? error;
  final int counter;

  HomeState copyWith({
    bool? isLoading,
    String? error,
    int? counter,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      counter: counter ?? this.counter,
    );
  }
}

/// Home screen state notifier using Riverpod's StateNotifier
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      // Process data here

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Provider for home screen state
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

