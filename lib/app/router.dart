import 'package:go_router/go_router.dart';

import '../features/drama/screens/drama_detail_screen.dart';
import '../features/drama/screens/drama_home_screen.dart';
import '../features/drama/screens/episode_player_screen.dart';
import '../features/meow_points/screens/meow_points_wallet_screen.dart';
import '../features/profile/screens/profile_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DramaHomeScreen(),
    ),
    GoRoute(
      path: '/dramas/:seriesId',
      builder: (context, state) {
        final seriesId = int.tryParse(state.pathParameters['seriesId'] ?? '');
        return DramaDetailScreen(seriesId: seriesId ?? -1);
      },
    ),
    GoRoute(
      path: '/dramas/:seriesId/episodes/:episodeNo',
      builder: (context, state) {
        final seriesId = int.tryParse(state.pathParameters['seriesId'] ?? '');
        final episodeNo = int.tryParse(state.pathParameters['episodeNo'] ?? '');
        return EpisodePlayerScreen(
          seriesId: seriesId ?? -1,
          episodeNo: episodeNo ?? -1,
        );
      },
    ),
    GoRoute(
      path: '/meow-points',
      builder: (context, state) => const MeowPointsWalletScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
