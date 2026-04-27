import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/drama_api.dart';
import '../widgets/episode_grid.dart';

class DramaDetailScreen extends ConsumerWidget {
  const DramaDetailScreen({required this.seriesId, super.key});

  final int seriesId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(dramaApiProvider);
    final series = api.getDramaById(seriesId);
    final episodes = api.getEpisodesBySeriesId(seriesId);

    if (series == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Drama not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(series.title)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            height: 180,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Cover / Header Placeholder'),
          ),
          const SizedBox(height: 12),
          Text(series.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(series.description),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: [for (final tag in series.tags) Chip(label: Text(tag))],
          ),
          const SizedBox(height: 8),
          Text('Total episodes: ${series.totalEpisodes}'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: episodes.isEmpty
                ? null
                : () => context.go('/dramas/$seriesId/episodes/${episodes.first.episodeNo}'),
            child: const Text('Start Watching'),
          ),
          const SizedBox(height: 12),
          Text('Episodes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          EpisodeGrid(
            episodes: episodes,
            onEpisodeTap: (episode) {
              context.go('/dramas/$seriesId/episodes/${episode.episodeNo}');
            },
          ),
        ],
      ),
    );
  }
}
