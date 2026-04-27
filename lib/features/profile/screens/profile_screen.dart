import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Login placeholder'),
            subtitle: Text('Account sign in will be added later.'),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Watch history placeholder'),
            subtitle: Text('Continue watching and history will be connected later.'),
          ),
          ListTile(
            leading: Icon(Icons.favorite_outline),
            title: Text('Favorites placeholder'),
            subtitle: Text('Favorite dramas will be shown here in a later phase.'),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.wallet_outlined), label: 'Meow Points'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onDestinationSelected: (index) {
          if (index == 0) context.go('/');
          if (index == 1) context.go('/meow-points');
        },
      ),
    );
  }
}
