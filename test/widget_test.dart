import 'package:flutter_test/flutter_test.dart';
import 'package:nora/main.dart';

void main() {
  testWidgets('NoraApp initial render smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NoraApp());
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(NoraApp), findsOneWidget);
  });
}
