import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/drama_api.dart';
import '../data/drama_models.dart';

class EpisodePlayerScreen extends ConsumerWidget {
  const EpisodePlayerScreen({
    required this.seriesId,
    required this.episodeNo,
    super.key,
  });

  final int seriesId;
  final int episodeNo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(dramaDetailProvider(seriesId));
    final episodeAsync = ref.watch(dramaEpisodeDetailProvider((seriesId: seriesId, episodeNo: episodeNo)));
    final episodesAsync = ref.watch(dramaEpisodesProvider(seriesId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: seriesAsync.when(
          data: (series) => Text(series?.title ?? 'Episode'),
          loading: () => const Text('Loading...'),
          error: (error, stack) => const Text('Episode'),
        ),
      ),
      body: episodeAsync.when(
        data: (episode) {
          if (episode == null) {
            return const Center(
              child: Text('Episode not found.', style: TextStyle(color: Colors.white)),
            );
          }

          return episodesAsync.when(
            data: (episodes) => _EpisodePlayerBody(
              seriesId: seriesId,
              episode: episode,
              episodes: episodes,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _EpisodePlayerBody(
              seriesId: seriesId,
              episode: episode,
              episodes: const [],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Unable to load episode right now.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _EpisodePlayerBody extends StatelessWidget {
  const _EpisodePlayerBody({
    required this.seriesId,
    required this.episode,
    required this.episodes,
  });

  final int seriesId;
  final DramaEpisode episode;
  final List<DramaEpisode> episodes;

  @override
  Widget build(BuildContext context) {
    final currentIndex = episodes.indexWhere((e) => e.episodeNo == episode.episodeNo);
    final prevEpisode = currentIndex > 0 ? episodes[currentIndex - 1] : null;
    final nextEpisode =
        currentIndex >= 0 && currentIndex < episodes.length - 1 ? episodes[currentIndex + 1] : null;

    final playbackInfo = episode.isLocked
        ? 'Locked episode. Unlock to access playback URL.'
        : 'Ready: ${episode.hlsUrl ?? episode.videoUrl ?? 'No URL provided'}';

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(12),
                color: Colors.black54,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Vertical Player Placeholder\n$playbackInfo',
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'EP ${episode.episodeNo} · ${episode.title}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: prevEpisode == null
                      ? null
                      : () => context.go('/dramas/$seriesId/episodes/${prevEpisode.episodeNo}'),
                  child: const Text('Previous'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: nextEpisode == null
                      ? null
                      : () => context.go('/dramas/$seriesId/episodes/${nextEpisode.episodeNo}'),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
          if (episode.isLocked) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unlock with Meow Points',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text('Required: ${episode.meowPointsPrice} Meow Points'),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () => context.go('/meow-points'),
                    child: const Text('Go to Meow Points Wallet'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
