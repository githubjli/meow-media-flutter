import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../data/drama_api.dart';
import '../data/drama_models.dart';
import '../widgets/drama_card.dart';

class DramaHomeScreen extends ConsumerWidget {
  const DramaHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dramasAsync = ref.watch(dramaSeriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Meow Short Dramas')),
      body: dramasAsync.when(
        data: (dramas) {
          if (dramas.isEmpty) {
            return const _MessageState(
              title: 'No dramas yet',
              subtitle: 'Please check back soon for new short-drama releases.',
            );
          }

          final continueWatching = dramas.where((e) => e.continueEpisodeNo != null).toList(growable: false);

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _Section(title: 'Continue Watching', items: continueWatching),
              _Section(title: 'Hot Dramas', items: dramas),
              _Section(title: 'New Releases', items: dramas),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          final subtitle = AppConfig.enableMockFallback
              ? 'Unable to load backend dramas right now. Please try again.'
              : 'Backend is unavailable and mock fallback is disabled.';
          return _MessageState(
            title: 'Could not load dramas',
            subtitle: subtitle,
            actionLabel: 'Retry',
            onActionTap: () => ref.invalidate(dramaSeriesProvider),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.wallet_outlined), label: 'Meow Points'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onDestinationSelected: (index) {
          if (index == 1) context.go('/meow-points');
          if (index == 2) context.go('/profile');
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<DramaSeries> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && title == 'Continue Watching') {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (items.isEmpty)
          const Text('No items yet.')
        else
          for (final series in items)
            DramaCard(
              series: series,
              onTap: () => context.go('/dramas/${series.id}'),
            ),
      ],
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center),
            if (actionLabel != null && onActionTap != null) ...[
              const SizedBox(height: 12),
              FilledButton(onPressed: onActionTap, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
