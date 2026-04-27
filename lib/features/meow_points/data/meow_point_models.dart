class MeowPointBalance {
  const MeowPointBalance({
    required this.balance,
    required this.displayName,
    required this.unit,
  });

  final int balance;
  final String displayName;
  final String unit;
}

class MeowPointPackage {
  const MeowPointPackage({
    required this.id,
    required this.name,
    required this.pointsAmount,
    required this.bonusPoints,
    required this.totalPoints,
    required this.paymentAmount,
    required this.paymentCurrency,
    required this.blockchain,
    required this.tokenName,
    required this.exchangeRate,
    required this.exchangeRateLabel,
  });

  final int id;
  final String name;
  final int pointsAmount;
  final int bonusPoints;
  final int totalPoints;
  final String paymentAmount;
  final String paymentCurrency;
  final String blockchain;
  final String tokenName;
  final String exchangeRate;
  final String exchangeRateLabel;
}
