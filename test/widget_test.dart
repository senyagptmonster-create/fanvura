import 'package:flutter_test/flutter_test.dart';
import 'package:fanvura/fanvura_app.dart';

void main() {
  testWidgets('FanvuraApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FanvuraApp());
    expect(find.text('Tide Clock Visualizer'), findsWidgets);
    expect(find.text('Simulate Tidal Cycle Phase'), findsOneWidget);
  });
}
