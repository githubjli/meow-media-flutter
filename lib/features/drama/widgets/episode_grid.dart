import 'package:flutter/material.dart';

import '../data/drama_models.dart';

class EpisodeGrid extends StatelessWidget {
  const EpisodeGrid({
    required this.episodes,
    required this.onEpisodeTap,
    super.key,
  });

  final List<DramaEpisode> episodes;
  final ValueChanged<DramaEpisode> onEpisodeTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: episodes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.45,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return InkWell(
          onTap: () => onEpisodeTap(episode),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: episode.isLocked ? Colors.grey.shade200 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('EP ${episode.episodeNo}'),
                const SizedBox(height: 4),
                if (episode.isLocked)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline, size: 14),
                      const SizedBox(width: 4),
                      Text('${episode.meowPointsPrice} Meow Points'),
                    ],
                  )
                else
                  const Text('Free'),
              ],
            ),
          ),
        );
      },
    );
  }
}
