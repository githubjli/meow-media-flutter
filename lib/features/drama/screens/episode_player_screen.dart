import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/drama_api.dart';

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
    final api = ref.watch(dramaApiProvider);
    final series = api.getDramaById(seriesId);
    final episode = api.getEpisodeBySeriesIdAndNo(seriesId, episodeNo);
    final episodes = api.getEpisodesBySeriesId(seriesId);

    if (series == null || episode == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Episode not found.')),
      );
    }

    final currentIndex = episodes.indexWhere((e) => e.episodeNo == episodeNo);
    final prevEpisode = currentIndex > 0 ? episodes[currentIndex - 1] : null;
    final nextEpisode =
        currentIndex >= 0 && currentIndex < episodes.length - 1 ? episodes[currentIndex + 1] : null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(series.title),
      ),
      body: Padding(
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
                child: const Center(
                  child: Text(
                    'Vertical Player Placeholder',
                    style: TextStyle(color: Colors.white70),
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
      ),
    );
  }
}
