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

  factory DramaSeries.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? '') as String;
    final description = (json['description'] ?? '') as String;

    return DramaSeries(
      id: _toInt(json['id']),
      title: title,
      description: description,
      coverUrl: (json['cover_url'] ?? '') as String,
      tags: _toStringList(json['tags']),
      totalEpisodes: _toInt(json['total_episodes']),
      freeEpisodeCount: _toInt(json['free_episode_count']),
      lockedEpisodeCount: _toInt(json['locked_episode_count']),
      viewCount: _toInt(json['view_count']),
      favoriteCount: _toInt(json['favorite_count']),
      isFavorited: (json['is_favorited'] ?? false) as bool,
      continueEpisodeNo: _toNullableInt(json['continue_episode_no']),
      continueProgressSeconds: _toNullableInt(json['continue_progress_seconds']),
      hookText: description.isEmpty ? title : description,
      section: 'all',
    );
  }
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

  factory DramaEpisode.fromJson(Map<String, dynamic> json) {
    final isFree = (json['is_free'] ?? false) as bool;
    final isLocked = (json['is_locked'] ?? !isFree) as bool;

    return DramaEpisode(
      id: _toInt(json['id']),
      seriesId: _toInt(json['series_id']),
      episodeNo: _toInt(json['episode_no']),
      title: (json['title'] ?? '') as String,
      durationSeconds: _toInt(json['duration_seconds']),
      videoUrl: _toNullableString(json['video_url']),
      hlsUrl: _toNullableString(json['hls_url']),
      isFree: isFree,
      unlockType: (json['unlock_type'] ?? (isFree ? 'free' : 'meow_points')) as String,
      meowPointsPrice: _toInt(json['meow_points_price']),
      isLocked: isLocked,
      isUnlocked: (json['is_unlocked'] ?? !isLocked) as bool,
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  return _toInt(value);
}

String? _toNullableString(dynamic value) {
  if (value == null) return null;
  final stringValue = value.toString().trim();
  if (stringValue.isEmpty) return null;
  return stringValue;
}

List<String> _toStringList(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }
  if (value is String && value.trim().isNotEmpty) {
    return value
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
  }
  return const [];
}
