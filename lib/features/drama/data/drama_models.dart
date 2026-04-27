class DramaSeries {
  const DramaSeries({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.tags,
    required this.totalEpisodes,
    required this.freeEpisodeCount,
    required this.lockedEpisodeCount,
    required this.viewCount,
    required this.favoriteCount,
    required this.isFavorited,
    required this.continueEpisodeNo,
    required this.continueProgressSeconds,
    required this.hookText,
    required this.section,
  });

  final int id;
  final String title;
  final String description;
  final String coverUrl;
  final List<String> tags;
  final int totalEpisodes;
  final int freeEpisodeCount;
  final int lockedEpisodeCount;
  final int viewCount;
  final int favoriteCount;
  final bool isFavorited;
  final int? continueEpisodeNo;
  final int? continueProgressSeconds;
  final String hookText;
  final String section;
}

class DramaEpisode {
  const DramaEpisode({
    required this.id,
    required this.seriesId,
    required this.episodeNo,
    required this.title,
    required this.durationSeconds,
    required this.videoUrl,
    required this.hlsUrl,
    required this.isFree,
    required this.unlockType,
    required this.meowPointsPrice,
    required this.isLocked,
    required this.isUnlocked,
  });

  final int id;
  final int seriesId;
  final int episodeNo;
  final String title;
  final int durationSeconds;
  final String? videoUrl;
  final String? hlsUrl;
  final bool isFree;
  final String unlockType;
  final int meowPointsPrice;
  final bool isLocked;
  final bool isUnlocked;
}
