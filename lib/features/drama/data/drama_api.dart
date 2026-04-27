import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'drama_mock_data.dart';
import 'drama_models.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final dramaApiProvider = Provider<DramaApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DramaApi(apiClient: apiClient);
});

final dramaSeriesProvider = Provider<List<DramaSeries>>((ref) {
  final api = ref.watch(dramaApiProvider);
  return api.getDramaSeries();
});

class DramaApi {
  DramaApi({required this.apiClient});

  final ApiClient apiClient;

  List<DramaSeries> getDramaSeries() => mockDramaSeries;

  DramaSeries? getDramaById(int id) {
    for (final drama in mockDramaSeries) {
      if (drama.id == id) {
        return drama;
      }
    }
    return null;
  }

  List<DramaEpisode> getEpisodesBySeriesId(int seriesId) {
    return mockDramaEpisodes.where((episode) => episode.seriesId == seriesId).toList()
      ..sort((a, b) => a.episodeNo.compareTo(b.episodeNo));
  }

  DramaEpisode? getEpisodeBySeriesIdAndNo(int seriesId, int episodeNo) {
    for (final episode in mockDramaEpisodes) {
      if (episode.seriesId == seriesId && episode.episodeNo == episodeNo) {
        return episode;
      }
    }
    return null;
  }
}
