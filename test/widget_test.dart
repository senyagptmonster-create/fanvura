import 'package:flutter_test/flutter_test.dart';
import 'package:fanvura/fanvura_app.dart';

void main() {
  testWidgets('FanvuraApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FanvuraApp());
    await tester.pump();
    expect(find.text('Tide Clock'), findsWidgets);
  });
}
