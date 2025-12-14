import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/home_provider.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_view.dart';

/// Home screen content widget using ConsumerWidget for Riverpod
class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    if (homeState.isLoading) {
      return const LoadingIndicator(message: 'Loading...');
    }

    if (homeState.error != null) {
      return ErrorView(
        message: homeState.error!,
        onRetry: () => ref.read(homeProvider.notifier).loadData(),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Counter: ${homeState.counter}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.read(homeProvider.notifier).incrementCounter(),
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}

