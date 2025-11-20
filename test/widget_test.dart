import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_viewer/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // בונה את האפליקציה
    await tester.pumpWidget(const MyApp());
    
    // בודק שהטקסט 'מציג PDF' מופיע
    expect(find.text('מציג PDF'), findsOneWidget);
  });
}