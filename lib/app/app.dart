import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class MeowMediaApp extends StatelessWidget {
  const MeowMediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: 'Meow Media',
        theme: buildAppTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}
