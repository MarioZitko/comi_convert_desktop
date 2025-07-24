// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:comi_convert_desktop/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ComiConvertApp());

    // Verify that the app title is displayed
    expect(find.text('ComiConvert'), findsOneWidget);
    
    // Verify that file selection section is present
    expect(find.text('Select Comic/Manga File:'), findsOneWidget);
  });
}
