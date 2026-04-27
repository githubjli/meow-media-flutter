import 'package:flutter/material.dart';

import '../data/meow_point_models.dart';

class MeowPointPackageCard extends StatelessWidget {
  const MeowPointPackageCard({required this.package, super.key});

  final MeowPointPackage package;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(package.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('${package.totalPoints} Meow Points'),
            Text('${package.paymentAmount} ${package.paymentCurrency}'),
            Text(package.tokenName),
            Text(package.exchangeRateLabel),
          ],
        ),
      ),
    );
  }
}
