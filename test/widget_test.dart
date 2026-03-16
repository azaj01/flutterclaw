import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterclaw/app.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FlutterClawApp()));
    await tester.pump();
    expect(find.text('FlutterClaw'), findsAny);
  });
}
