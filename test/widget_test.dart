import 'package:flutter_test/flutter_test.dart';
import 'package:meow_media_flutter/app/app.dart';

void main() {
  testWidgets('App shell renders placeholder text', (tester) async {
    await tester.pumpWidget(const MeowMediaApp());

    expect(find.text('Meow Media Flutter app shell is ready.'), findsOneWidget);
  });
}
