import 'package:flutter_test/flutter_test.dart';
import 'package:sieve/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App initializes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SieveApp(),
      ),
    );
    // App should render without crashing
    expect(find.byType(SieveApp), findsOneWidget);
  });
}
