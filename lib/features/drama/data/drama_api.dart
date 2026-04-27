import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import 'drama_mock_data.dart';
import 'drama_models.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final dramaApiProvider = Provider<DramaApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DramaApi(apiClient: apiClient);
});

final dramaSeriesProvider = FutureProvider<List<DramaSeries>>((ref) async {
  final api = ref.watch(dramaApiProvider);
  return api.listDramas();
});

final dramaDetailProvider = FutureProvider.family<DramaSeries?, int>((ref, seriesId) async {
  final api = ref.watch(dramaApiProvider);
  return api.getDrama(seriesId);
});

final dramaEpisodesProvider = FutureProvider.family<List<DramaEpisode>, int>((ref, seriesId) async {
  final api = ref.watch(dramaApiProvider);
  return api.listEpisodes(seriesId);
});

final dramaEpisodeDetailProvider =
    FutureProvider.family<DramaEpisode?, ({int seriesId, int episodeNo})>((ref, args) async {
  final api = ref.watch(dramaApiProvider);
  return api.getEpisode(args.seriesId, args.episodeNo);
});

class DramaApi {
  DramaApi({required this.apiClient});

  final ApiClient apiClient;

  Future<List<DramaSeries>> listDramas() async {
    try {
      final data = await apiClient.getJson('/api/dramas/');
      final results = data['results'];
      if (results is List<dynamic>) {
        return results
            .whereType<Map<String, dynamic>>()
            .map(DramaSeries.fromJson)
            .toList(growable: false);
      }
      return const [];
    } catch (_) {
      if (AppConfig.enableMockFallback) {
        return mockDramaSeries;
      }
      rethrow;
    }
  }

  Future<DramaSeries?> getDrama(int seriesId) async {
    try {
      final data = await apiClient.getJson('/api/dramas/$seriesId/');
      return DramaSeries.fromJson(data);
    } catch (_) {
      if (AppConfig.enableMockFallback) {
        for (final drama in mockDramaSeries) {
          if (drama.id == seriesId) {
            return drama;
          }
        }
        return null;
      }
      rethrow;
    }
  }

  Future<List<DramaEpisode>> listEpisodes(int seriesId) async {
    try {
      final data = await apiClient.getJson('/api/dramas/$seriesId/episodes/');
      final results = data['results'];
      if (results is List<dynamic>) {
        final episodes = results
            .whereType<Map<String, dynamic>>()
            .map(DramaEpisode.fromJson)
            .toList(growable: false);
        return episodes..sort((a, b) => a.episodeNo.compareTo(b.episodeNo));
      }
      return const [];
    } catch (_) {
      if (AppConfig.enableMockFallback) {
        final episodes =
            mockDramaEpisodes.where((episode) => episode.seriesId == seriesId).toList(growable: false);
        return episodes..sort((a, b) => a.episodeNo.compareTo(b.episodeNo));
      }
      rethrow;
    }
  }

  Future<DramaEpisode?> getEpisode(int seriesId, int episodeNo) async {
    try {
      final data = await apiClient.getJson('/api/dramas/$seriesId/episodes/$episodeNo/');
      return DramaEpisode.fromJson(data);
    } catch (_) {
      if (AppConfig.enableMockFallback) {
        for (final episode in mockDramaEpisodes) {
          if (episode.seriesId == seriesId && episode.episodeNo == episodeNo) {
            return episode;
          }
        }
        return null;
      }
      rethrow;
    }
  }
}
