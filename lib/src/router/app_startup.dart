import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/onboarding/data/onboarding_repository.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final appStartupProvider = FutureProvider((ref) async {
  ref.onDispose(() {
    ref.invalidate(onboardingRepoProvider);
  });

  ref.watch(onboardingRepoProvider);
});

class AppStartup extends ConsumerWidget {
  final Widget child;

  const AppStartup({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return appStartupState.when(
      data: (_) => child,
      error:
          (error, _) => AppStartupErrorWidget(
            message: error.toString(),
            onRetry: () => ref.invalidate(appStartupProvider),
          ),
      loading: () => AppStartupLoadingWidget(),
    );
  }
}

/// Widget to show while initialization is in progress
class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Widget to show if initialization fails
class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text(message, style: Theme.of(context).textTheme.headlineSmall),

            ShadButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
