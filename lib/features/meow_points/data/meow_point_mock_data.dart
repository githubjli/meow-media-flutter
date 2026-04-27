import 'meow_point_models.dart';

const MeowPointBalance mockMeowPointBalance = MeowPointBalance(
  balance: 1250,
  displayName: 'Meow Points',
  unit: 'points',
);

const List<MeowPointPackage> mockMeowPointPackages = [
  MeowPointPackage(
    id: 1,
    name: 'Starter Pack',
    pointsAmount: 1000,
    bonusPoints: 0,
    totalPoints: 1000,
    paymentAmount: '100.00',
    paymentCurrency: 'THB-LTT',
    blockchain: 'LTT',
    tokenName: 'LTT Thai Baht Stablecoin',
    exchangeRate: '10.00000000',
    exchangeRateLabel: '1 THB-LTT = 10 Meow Points',
  ),
  MeowPointPackage(
    id: 2,
    name: 'Value Pack',
    pointsAmount: 2500,
    bonusPoints: 300,
    totalPoints: 2800,
    paymentAmount: '250.00',
    paymentCurrency: 'THB-LTT',
    blockchain: 'LTT',
    tokenName: 'LTT Thai Baht Stablecoin',
    exchangeRate: '11.20000000',
    exchangeRateLabel: '1 THB-LTT = 11.2 Meow Points',
  ),
];
