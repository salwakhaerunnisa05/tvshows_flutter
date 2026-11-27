import 'package:flutter_test/flutter_test.dart';
import 'package:tv_shows/main.dart';

void main() {
  testWidgets('ToonVerse app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ToonVerseApp());
    expect(find.textContaining('Toon'), findsWidgets);
  });
}