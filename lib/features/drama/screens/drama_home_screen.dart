import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/drama_api.dart';
import '../data/drama_models.dart';
import '../widgets/drama_card.dart';

class DramaHomeScreen extends ConsumerWidget {
  const DramaHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dramas = ref.watch(dramaSeriesProvider);
    final continueWatching = dramas.where((e) => e.continueEpisodeNo != null).toList();
    final hot = dramas.where((e) => e.section == 'hot').toList();
    final newReleases = dramas.where((e) => e.section == 'new').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Meow Short Dramas')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _Section(
            title: 'Continue Watching',
            items: continueWatching,
          ),
          _Section(
            title: 'Hot Dramas',
            items: hot,
          ),
          _Section(
            title: 'New Releases',
            items: newReleases,
          ),
        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
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
