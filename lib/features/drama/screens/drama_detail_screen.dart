import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/drama_api.dart';
import '../data/drama_models.dart';
import '../widgets/episode_grid.dart';

class DramaDetailScreen extends ConsumerWidget {
  const DramaDetailScreen({required this.seriesId, super.key});

  final int seriesId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(dramaDetailProvider(seriesId));
    final episodesAsync = ref.watch(dramaEpisodesProvider(seriesId));

    return Scaffold(
      appBar: AppBar(),
      body: seriesAsync.when(
        data: (series) {
          if (series == null) {
            return const Center(child: Text('Drama not found.'));
          }

          return episodesAsync.when(
            data: (episodes) => _DetailView(series: series, episodes: episodes),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Unable to load episodes. Please try again.'),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Unable to load drama detail. Please try again.'),
          ),
        ),
      ),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.series, required this.episodes});

  final DramaSeries series;
  final List<DramaEpisode> episodes;

  @override
  Widget build(BuildContext context) {
    return ListView(
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
          onPressed:
              episodes.isEmpty ? null : () => context.go('/dramas/${series.id}/episodes/${episodes.first.episodeNo}'),
          child: const Text('Start Watching'),
        ),
        const SizedBox(height: 12),
        Text('Episodes', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        EpisodeGrid(
          episodes: episodes,
          onEpisodeTap: (episode) {
            context.go('/dramas/${series.id}/episodes/${episode.episodeNo}');
          },
        ),
      ],
    );
  }
}
