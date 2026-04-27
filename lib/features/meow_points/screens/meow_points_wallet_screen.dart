import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/meow_point_mock_data.dart';
import '../widgets/meow_point_package_card.dart';

class MeowPointsWalletScreen extends StatelessWidget {
  const MeowPointsWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meow Points Wallet')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '1,250 Meow Points',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Packages', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final package in mockMeowPointPackages)
            MeowPointPackageCard(package: package),
          const SizedBox(height: 8),
          const Text(
            'Purchases will later use THB-LTT through the Django wallet prototype payment flow.',
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.wallet_outlined), label: 'Meow Points'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onDestinationSelected: (index) {
          if (index == 0) context.go('/');
          if (index == 2) context.go('/profile');
        },
      ),
    );
  }
}
